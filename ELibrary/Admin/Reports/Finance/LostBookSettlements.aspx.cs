
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using Microsoft.Reporting.WebForms;

namespace ELibrary.Admin.Reports.Finance
{
    public partial class LostBookSettlements : Page
    {
        private const string CacheKey =
            "ELibrary_Report_LostBookSettlements";

        [Serializable]
        private sealed class ReportState
        {
            public DataTable Data { get; set; }
            public DateTime From { get; set; }
            public DateTime To { get; set; }
            public string Search { get; set; }
            public string Status { get; set; }
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
                txtFrom.Text = new DateTime(
                    today.Year, today.Month, 1)
                    .ToString("yyyy-MM-dd");

                txtTo.Text = today.ToString("yyyy-MM-dd");

                Session.Remove(CacheKey);
                pnlResults.Visible = false;
                pnlEmpty.Visible = true;
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
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
            string status = ddlStatus.SelectedValue;

            if (search.Length > 150)
            {
                Reset("Search cannot exceed 150 characters.");
                return;
            }

            try
            {
                ReportState state = new ReportState
                {
                    From = from,
                    To = to,
                    Search = search,
                    Status = status,
                    GeneratedOn = DateTime.Now,
                    Data = LoadData(from, to, search, status)
                };

                Session[CacheKey] = state;
                BindReport(state);
            }
            catch (Exception)
            {
                Reset(
                    "Unable to generate lost book settlements. " +
                    "Verify the SQL procedure and RDLC.");
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
                        Reset(
                            "Unable to restore the settlement report.");
                    }
                }
            }

            base.OnPreRender(e);
        }

        private DataTable LoadData(
            DateTime from,
            DateTime to,
            string search,
            string status)
        {
            DataTable table =
                new DataTable("LostBookSettlementsDataSet");

            string connectionString =
                ConfigurationManager.ConnectionStrings[
                    "ElibraryConnection"].ConnectionString;

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand(
                    "dbo.EReport_LostBookSettlements", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 60;

                cmd.Parameters.Add(
                    "@DateFrom", SqlDbType.Date).Value = from;

                cmd.Parameters.Add(
                    "@DateTo", SqlDbType.Date).Value = to;

                cmd.Parameters.Add(
                    "@SettlementStatus",
                    SqlDbType.VarChar, 30).Value =
                    string.IsNullOrWhiteSpace(status)
                        ? (object)DBNull.Value : status;

                cmd.Parameters.Add(
                    "@Search",
                    SqlDbType.NVarChar, 150).Value =
                    string.IsNullOrWhiteSpace(search)
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
            if (state.Data.Rows.Count == 0)
            {
                pnlResults.Visible = false;
                pnlEmpty.Visible = true;
                lblError.Text =
                    "No lost-book cases match the selected filters.";
                return;
            }

            int fullyPaid = 0;
            decimal outstanding = 0m;

            foreach (DataRow row in state.Data.Rows)
            {
                if (Convert.ToString(row["SettlementStatus"])
                    == "Fully Paid")
                {
                    fullyPaid++;
                }

                outstanding += Convert.ToDecimal(
                    row["OutstandingBalance"]);
            }

            lblCases.Text =
                state.Data.Rows.Count.ToString("N0");

            lblSettled.Text = fullyPaid.ToString("N0");
            lblOutstanding.Text = Money(outstanding);

            pnlResults.Visible = true;
            pnlEmpty.Visible = false;

            rvReport.ProcessingMode = ProcessingMode.Local;

            rvReport.LocalReport.ReportPath =
                Server.MapPath(
                    "~/Reports/Finance/LostBookSettlements.rdlc");

            rvReport.LocalReport.DataSources.Clear();

            rvReport.LocalReport.DataSources.Add(
                new ReportDataSource(
                    "LostBookSettlementsDataSet",
                    state.Data));

            string period =
                state.From.ToString("MMM dd, yyyy") +
                " - " +
                state.To.ToString("MMM dd, yyyy");

            string filters =
                "Settlement: " +
                (string.IsNullOrEmpty(state.Status)
                    ? "All" : state.Status) +
                " | Search: " +
                (string.IsNullOrEmpty(state.Search)
                    ? "All" : state.Search);

            rvReport.LocalReport.SetParameters(
                new ReportParameter[]
                {
                    new ReportParameter("Period", period),
                    new ReportParameter("Filters", filters),
                    new ReportParameter(
                        "OutstandingTotal",
                        Money(outstanding)),
                    new ReportParameter(
                        "GeneratedOn",
                        state.GeneratedOn.ToString(
                            "MMM dd, yyyy hh:mm tt"))
                });

            rvReport.LocalReport.Refresh();
            lblError.Text = "";
        }

        private static string Money(decimal amount)
        {
            return "₱" + amount.ToString(
                "N2",
                CultureInfo.GetCultureInfo("en-PH"));
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
