
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using Microsoft.Reporting.WebForms;

namespace ELibrary.Admin.Reports.Inventory
{
    public partial class GenrePopularity : Page
    {
        private const string CacheKey =
            "ELibrary_Report_GenrePopularity";

        [Serializable]
        private sealed class ReportState
        {
            public DataTable Data { get; set; }
            public DateTime From { get; set; }
            public DateTime To { get; set; }
            public string Search { get; set; }
            public bool IncludeArchived { get; set; }
            public DateTime GeneratedOn { get; set; }
        }

        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["ElibraryConnection"]
                    .ConnectionString;
            }
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
                pnlResults.Visible = false;
                pnlEmpty.Visible = true;
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
                return;

            DateTime from;
            DateTime to;

            if (!DateTime.TryParseExact(
                    txtFrom.Text, "yyyy-MM-dd",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None, out from)
                ||
                !DateTime.TryParseExact(
                    txtTo.Text, "yyyy-MM-dd",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None, out to)
                ||
                from > to ||
                to == DateTime.MaxValue.Date)
            {
                Reset("Please select a valid date range.");
                return;
            }

            string search = (txtSearch.Text ?? "").Trim();

            if (search.Length > 100)
            {
                Reset("Search cannot exceed 100 characters.");
                return;
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
                    IncludeArchived = includeArchived,
                    GeneratedOn = DateTime.Now,
                    Data = LoadData(
                        from, to, search, includeArchived)
                };

                Session[CacheKey] = state;
                BindReport(state);
            }
            catch (Exception)
            {
                Reset(
                    "Unable to generate Genre Popularity. " +
                    "Verify the stored procedure and RDLC.");
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            if (AdminHelper.IsAdmin(Session) &&
                IsPostBack &&
                string.IsNullOrEmpty(lblError.Text))
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
                        Reset("Unable to restore the report preview.");
                    }
                }
            }

            base.OnPreRender(e);
        }

        private DataTable LoadData(
            DateTime from,
            DateTime to,
            string search,
            bool includeArchived)
        {
            DataTable table =
                new DataTable("GenrePopularityDataSet");

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(
                "dbo.EReport_GenrePopularity", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 60;

                cmd.Parameters.Add(
                    "@DateFrom", SqlDbType.Date).Value = from;

                cmd.Parameters.Add(
                    "@DateTo", SqlDbType.Date).Value = to;

                cmd.Parameters.Add(
                    "@IncludeArchived", SqlDbType.Bit)
                    .Value = includeArchived;

                cmd.Parameters.Add(
                    "@Search", SqlDbType.NVarChar, 100)
                    .Value = string.IsNullOrWhiteSpace(search)
                        ? (object)DBNull.Value : search;

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
            if (state.Data == null || state.Data.Rows.Count == 0)
            {
                pnlResults.Visible = false;
                pnlEmpty.Visible = true;
                lblError.Text =
                    "No genres match your selected filters.";
                return;
            }

            long borrowings = 0;

            foreach (DataRow row in state.Data.Rows)
            {
                borrowings +=
                    Convert.ToInt64(row["BorrowingCount"]);
            }

            lblGenres.Text =
                state.Data.Rows.Count.ToString("N0");

            lblBorrowings.Text =
                borrowings.ToString("N0");

            lblTopGenre.Text = borrowings > 0
                ? Server.HtmlEncode(
                    Convert.ToString(
                        state.Data.Rows[0]["GenreName"]))
                : "No borrowing activity";

            pnlResults.Visible = true;
            pnlEmpty.Visible = false;

            rvReport.ProcessingMode = ProcessingMode.Local;
            rvReport.LocalReport.ReportPath =
                Server.MapPath(
                    "~/Reports/Inventory/GenrePopularity.rdlc");

            rvReport.LocalReport.DataSources.Clear();

            rvReport.LocalReport.DataSources.Add(
                new ReportDataSource(
                    "GenrePopularityDataSet",
                    state.Data));

            string period =
                state.From.ToString("MMM dd, yyyy") +
                " - " +
                state.To.ToString("MMM dd, yyyy");

            string filters =
                "Archived: " +
                (state.IncludeArchived
                    ? "Included" : "Excluded") +
                " | Genre Search: " +
                (string.IsNullOrWhiteSpace(state.Search)
                    ? "All" : state.Search);

            rvReport.LocalReport.SetParameters(
                new ReportParameter[]
                {
                    new ReportParameter("Period", period),
                    new ReportParameter("Filters", filters),
                    new ReportParameter(
                        "TotalBorrowings",
                        borrowings.ToString("N0")),
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
