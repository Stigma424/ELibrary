
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
    public partial class MostBorrowedBooks : Page
    {
        private const string CacheKey =
            "ELibrary_Report_MostBorrowedBooks";

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
            public DateTime From { get; set; }
            public DateTime To { get; set; }
            public string Search { get; set; }
            public string Genre { get; set; }
            public int TopN { get; set; }
            public bool IncludeArchived { get; set; }
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
                DateTime today = DateTime.Today;

                txtFrom.Text =
                    new DateTime(today.Year, today.Month, 1)
                        .ToString("yyyy-MM-dd");

                txtTo.Text = today.ToString("yyyy-MM-dd");

                Session.Remove(CacheKey);

                try
                {
                    LoadGenres();
                }
                catch (Exception)
                {
                    lblError.Text = "Unable to load genres.";
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
            DateTime from;
            DateTime to;
            int topN;

            bool validFrom = DateTime.TryParseExact(
                txtFrom.Text, "yyyy-MM-dd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None, out from);

            bool validTo = DateTime.TryParseExact(
                txtTo.Text, "yyyy-MM-dd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None, out to);

            if (!validFrom || !validTo ||
                from > to ||
                to == DateTime.MaxValue.Date ||
                !int.TryParse(ddlTop.SelectedValue, out topN))
            {
                Reset("Please select valid report filters.");
                return;
            }

            string search = (txtSearch.Text ?? "").Trim();

            if (search.Length > 150)
            {
                Reset("Search cannot exceed 150 characters.");
                return;
            }

            int genreId;
            int? selectedGenre = null;

            if (!string.IsNullOrEmpty(ddlGenre.SelectedValue))
            {
                if (!int.TryParse(
                    ddlGenre.SelectedValue, out genreId))
                {
                    Reset("Invalid genre selection.");
                    return;
                }

                selectedGenre = genreId;
            }

            bool includeArchived =
                ddlArchived.SelectedValue == "1";

            try
            {
                ReportState state = new ReportState
                {
                    From = from,
                    To = to,
                    Search = search,
                    Genre = ddlGenre.SelectedItem.Text,
                    TopN = topN,
                    IncludeArchived = includeArchived,
                    GeneratedOn = DateTime.Now,
                    Data = LoadData(
                        from,
                        to,
                        search,
                        selectedGenre,
                        includeArchived,
                        topN)
                };

                Session[CacheKey] = state;
                BindReport(state);
            }
            catch (Exception)
            {
                Reset(
                    "Unable to generate book popularity report. " +
                    "Verify SQL and RDLC files.");
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            if (AdminHelper.IsAdmin(Session)
                && IsPostBack
                && string.IsNullOrEmpty(lblError.Text))
            {
                ReportState state =
                    Session[CacheKey] as ReportState;

                if (state != null)
                {
                    try
                    {
                        BindReport(state);
                    }
                    catch (Exception)
                    {
                        Reset("Unable to restore popularity report.");
                    }
                }
            }

            base.OnPreRender(e);
        }

        private DataTable LoadData(
            DateTime from,
            DateTime to,
            string search,
            int? genreId,
            bool includeArchived,
            int topN)
        {
            DataTable table =
                new DataTable("MostBorrowedBooksDataSet");

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                new SqlCommand(
                    "dbo.EReport_MostBorrowedBooks", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 60;

                cmd.Parameters.Add(
                    "@DateFrom", SqlDbType.Date).Value = from;

                cmd.Parameters.Add(
                    "@DateTo", SqlDbType.Date).Value = to;

                cmd.Parameters.Add(
                    "@Search", SqlDbType.NVarChar, 150).Value =
                    string.IsNullOrWhiteSpace(search)
                        ? (object)DBNull.Value : search;

                cmd.Parameters.Add(
                    "@GenreID", SqlDbType.Int).Value =
                    genreId.HasValue
                        ? (object)genreId.Value : DBNull.Value;

                cmd.Parameters.Add(
                    "@IncludeArchived", SqlDbType.Bit)
                    .Value = includeArchived;

                cmd.Parameters.Add(
                    "@TopN", SqlDbType.Int).Value = topN;

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
                    "No titles match the selected popularity filters.";
                return;
            }

            long borrowingCount = 0;

            foreach (DataRow row in state.Data.Rows)
            {
                borrowingCount +=
                    Convert.ToInt64(row["BorrowingCount"]);
            }

            lblTitles.Text = state.Data.Rows.Count.ToString("N0");
            lblBorrowings.Text = borrowingCount.ToString("N0");
            lblTopBook.Text = Server.HtmlEncode(
                Convert.ToString(state.Data.Rows[0]["BookTitle"]));

            pnlResults.Visible = true;
            pnlEmpty.Visible = false;

            rvReport.ProcessingMode = ProcessingMode.Local;
            rvReport.LocalReport.ReportPath = Server.MapPath(
                "~/Reports/Inventory/MostBorrowedBooks.rdlc");

            rvReport.LocalReport.DataSources.Clear();

            rvReport.LocalReport.DataSources.Add(
                new ReportDataSource(
                    "MostBorrowedBooksDataSet", state.Data));

            string period =
                state.From.ToString("MMM dd, yyyy") +
                " - " +
                state.To.ToString("MMM dd, yyyy");

            string filters =
                "Genre: " + state.Genre +
                " | Top " + state.TopN +
                " | Archived: " +
                (state.IncludeArchived ? "Included" : "Excluded");

            if (!string.IsNullOrEmpty(state.Search))
                filters += " | Search: " + state.Search;

            rvReport.LocalReport.SetParameters(
                new ReportParameter[]
                {
                    new ReportParameter("Period", period),
                    new ReportParameter("Filters", filters),
                    new ReportParameter(
                        "TotalBorrowings",
                        borrowingCount.ToString("N0")),
                    new ReportParameter(
                        "GeneratedOn",
                        state.GeneratedOn.ToString(
                            "MMM dd, yyyy hh:mm tt"))
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
