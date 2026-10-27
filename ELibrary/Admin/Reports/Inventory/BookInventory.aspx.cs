
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace ELibrary.Admin.Reports.Inventory
{
    public partial class BookInventory : Page
    {
        private const string CacheKey = "ELibrary_Report_BookInventory";

        private string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings[
                    "ElibraryConnection"].ConnectionString;
            }
        }

        [Serializable]
        private sealed class ReportState
        {
            public DataTable Data { get; set; }
            public string Search { get; set; }
            public string Genre { get; set; }
            public string Archive { get; set; }
            public string Stock { get; set; }
            public int Threshold { get; set; }
            public DateTime GeneratedOn { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                Session.Remove(CacheKey);

                try
                {
                    LoadGenres();
                }
                catch (Exception)
                {
                    lblError.Text = "Unable to load book genres.";
                }

                pnlResults.Visible = false;
                pnlEmpty.Visible = true;
            }
        }

        private void LoadGenres()
        {
            ddlGenre.Items.Clear();
            ddlGenre.Items.Add(
                new ListItem("All Genres", ""));

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT GenreID, GenreName " +
                "FROM dbo.EGenre ORDER BY GenreName, GenreID",
                con))
            {
                con.Open();

                using (SqlDataReader reader =
                    cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ddlGenre.Items.Add(
                            new ListItem(
                                Convert.ToString(reader["GenreName"]),
                                Convert.ToString(reader["GenreID"])));
                    }
                }
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            string search = (txtSearch.Text ?? "").Trim();
            int threshold;

            if (search.Length > 150 ||
                !int.TryParse(ddlThreshold.SelectedValue,
                    out threshold))
            {
                Reset("Invalid inventory filters.");
                return;
            }

            int genreId;
            int? selectedGenre = null;

            if (!string.IsNullOrEmpty(ddlGenre.SelectedValue))
            {
                if (!int.TryParse(ddlGenre.SelectedValue,
                    out genreId))
                {
                    Reset("Invalid genre selection.");
                    return;
                }

                selectedGenre = genreId;
            }

            try
            {
                ReportState state = new ReportState
                {
                    Search = search,
                    Genre = ddlGenre.SelectedItem.Text,
                    Archive = ddlArchive.SelectedValue,
                    Stock = ddlStock.SelectedValue,
                    Threshold = threshold,
                    GeneratedOn = DateTime.Now,
                    Data = LoadData(
                        search,
                        selectedGenre,
                        ddlArchive.SelectedValue,
                        ddlStock.SelectedValue,
                        threshold)
                };

                Session[CacheKey] = state;
                BindReport(state);
            }
            catch (Exception)
            {
                Reset(
                    "Unable to generate inventory report. " +
                    "Check the SQL procedure and RDLC.");
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            if (AdminHelper.IsAdmin(Session)
                && IsPostBack
                && string.IsNullOrEmpty(lblError.Text))
            {
                ReportState state = Session[CacheKey] as ReportState;

                if (state != null)
                {
                    try
                    {
                        BindReport(state);
                    }
                    catch (Exception)
                    {
                        Reset("Unable to restore inventory preview.");
                    }
                }
            }

            base.OnPreRender(e);
        }

        private DataTable LoadData(
            string search,
            int? genreId,
            string archive,
            string stock,
            int threshold)
        {
            DataTable table = new DataTable("BookInventoryDataSet");

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(
                "dbo.EReport_BookInventory", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 60;

                cmd.Parameters.Add("@Search", SqlDbType.NVarChar, 150)
                    .Value = string.IsNullOrWhiteSpace(search)
                        ? (object)DBNull.Value : search;

                cmd.Parameters.Add("@GenreID", SqlDbType.Int)
                    .Value = genreId.HasValue
                        ? (object)genreId.Value : DBNull.Value;

                cmd.Parameters.Add("@ArchiveStatus", SqlDbType.VarChar, 15)
                    .Value = archive;

                cmd.Parameters.Add("@StockFilter", SqlDbType.VarChar, 20)
                    .Value = stock;

                cmd.Parameters.Add("@LowStockThreshold", SqlDbType.Int)
                    .Value = threshold;

                using (SqlDataAdapter adapter =
                    new SqlDataAdapter(cmd))
                {
                    adapter.Fill(table);
                }
            }

            return table;
        }

        private void BindReport(ReportState state)
        {
            if (state.Data.Rows.Count == 0)
            {
                pnlResults.Visible = false;
                pnlEmpty.Visible = true;
                lblError.Text =
                    "No books match the selected inventory filters.";
                return;
            }

            long totalCopies = 0;
            long availableCopies = 0;
            int lowStockTitles = 0;

            foreach (DataRow row in state.Data.Rows)
            {
                totalCopies += Convert.ToInt64(row["TotalCopies"]);
                availableCopies +=
                    Convert.ToInt64(row["AvailableCopies"]);

                string status = Convert.ToString(row["StockStatus"]);

                if (status == "Low Stock" ||
                    status == "No Stock")
                {
                    lowStockTitles++;
                }
            }

            lblTitles.Text = state.Data.Rows.Count.ToString("N0");
            lblTotalCopies.Text = totalCopies.ToString("N0");
            lblAvailable.Text = availableCopies.ToString("N0");
            lblLowStock.Text = lowStockTitles.ToString("N0");

            pnlResults.Visible = true;
            pnlEmpty.Visible = false;

            rvReport.ProcessingMode = ProcessingMode.Local;
            rvReport.LocalReport.ReportPath = Server.MapPath(
                "~/Reports/Inventory/BookInventory.rdlc");

            rvReport.LocalReport.DataSources.Clear();
            rvReport.LocalReport.DataSources.Add(
                new ReportDataSource(
                    "BookInventoryDataSet", state.Data));

            string filters =
                "Genre: " + state.Genre +
                " | Archive: " + state.Archive +
                " | Stock: " + state.Stock +
                " | Low Stock Threshold: " + state.Threshold;

            if (!string.IsNullOrWhiteSpace(state.Search))
                filters += " | Search: " + state.Search;

            rvReport.LocalReport.SetParameters(
                new ReportParameter[]
                {
                    new ReportParameter("Filters", filters),
                    new ReportParameter(
                        "GeneratedOn",
                        state.GeneratedOn.ToString(
                            "MMM dd, yyyy hh:mm tt")),
                    new ReportParameter(
                        "TotalTitles",
                        state.Data.Rows.Count.ToString("N0")),
                    new ReportParameter(
                        "TotalCopies",
                        totalCopies.ToString("N0")),
                    new ReportParameter(
                        "AvailableCopies",
                        availableCopies.ToString("N0"))
                });

            rvReport.LocalReport.Refresh();
            lblError.Text = "";
        }

        private void Reset(string message)
        {
            Session.Remove(CacheKey);
            pnlResults.Visible = false;
            pnlEmpty.Visible = true;
            lblError.Text = Server.HtmlEncode(message);
        }
    }
}
