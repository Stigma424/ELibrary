
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using Microsoft.Reporting.WebForms;

namespace ELibrary.Admin.Reports.Finance
{
    public partial class CollectionTrends : Page
    {
        private const string CacheKey =
            "ELibrary_Report_CollectionTrends";

        [Serializable]
        private sealed class ReportState
        {
            public DataTable Data { get; set; }
            public DateTime From { get; set; }
            public DateTime To { get; set; }
            public string Grouping { get; set; }
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
                ddlGrouping.SelectedValue = "Monthly";

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

            string grouping = ddlGrouping.SelectedValue;

            if (grouping != "Daily" &&
                grouping != "Weekly" &&
                grouping != "Monthly")
            {
                Reset("Invalid grouping option.");
                return;
            }

            try
            {
                ReportState state = new ReportState
                {
                    From = from,
                    To = to,
                    Grouping = grouping,
                    GeneratedOn = DateTime.Now,
                    Data = LoadData(from, to, grouping)
                };

                Session[CacheKey] = state;
                BindReport(state);
            }
            catch (Exception)
            {
                Reset(
                    "Unable to generate collection trends. " +
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
                            "Unable to restore collection trends.");
                    }
                }
            }

            base.OnPreRender(e);
        }

        private DataTable LoadData(
            DateTime from,
            DateTime to,
            string grouping)
        {
            DataTable table =
                new DataTable("CollectionTrendsDataSet");

            string connectionString =
                ConfigurationManager.ConnectionStrings[
                    "ElibraryConnection"].ConnectionString;

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand(
                    "dbo.EReport_CollectionTrends", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 60;

                cmd.Parameters.Add(
                    "@DateFrom", SqlDbType.Date).Value = from;

                cmd.Parameters.Add(
                    "@DateTo", SqlDbType.Date).Value = to;

                cmd.Parameters.Add(
                    "@Grouping", SqlDbType.VarChar, 10)
                    .Value = grouping;

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
                    "No fee transactions were recorded " +
                    "during this period.";
                return;
            }

            decimal payments = 0m;
            decimal refunds = 0m;

            foreach (DataRow row in state.Data.Rows)
            {
                payments += Convert.ToDecimal(
                    row["GrossPayments"]);

                refunds += Convert.ToDecimal(
                    row["TotalRefunds"]);
            }

            decimal net = payments - refunds;

            lblPayments.Text = Money(payments);
            lblRefunds.Text = Money(refunds);
            lblNet.Text = Money(net);

            pnlResults.Visible = true;
            pnlEmpty.Visible = false;

            rvReport.ProcessingMode = ProcessingMode.Local;
            rvReport.LocalReport.ReportPath =
                Server.MapPath(
                    "~/Reports/Finance/CollectionTrends.rdlc");

            rvReport.LocalReport.DataSources.Clear();

            rvReport.LocalReport.DataSources.Add(
                new ReportDataSource(
                    "CollectionTrendsDataSet",
                    state.Data));

            string period =
                state.From.ToString("MMM dd, yyyy") +
                " - " +
                state.To.ToString("MMM dd, yyyy");

            rvReport.LocalReport.SetParameters(
                new ReportParameter[]
                {
                    new ReportParameter("Period", period),
                    new ReportParameter(
                        "Grouping", state.Grouping),
                    new ReportParameter(
                        "GrossPayments", Money(payments)),
                    new ReportParameter(
                        "TotalRefunds", Money(refunds)),
                    new ReportParameter(
                        "NetCollections", Money(net)),
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
