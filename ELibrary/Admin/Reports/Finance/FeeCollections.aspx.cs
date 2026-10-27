
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using Microsoft.Reporting.WebForms;

namespace ELibrary.Admin.Reports.Finance
{
    public partial class FeeCollections : Page
    {
        private const string CacheKey = "ELibrary_Report_FeeCollections";

        [Serializable]
        private sealed class ReportState
        {
            public DataTable Data { get; set; }
            public DateTime From { get; set; }
            public DateTime To { get; set; }
            public string FeeType { get; set; }
            public string TransactionType { get; set; }
            public DateTime GeneratedAt { get; set; }
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
                txtFrom.Text = new DateTime(today.Year, today.Month, 1)
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

            bool fromValid = DateTime.TryParseExact(
                txtFrom.Text, "yyyy-MM-dd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None, out from);

            bool toValid = DateTime.TryParseExact(
                txtTo.Text, "yyyy-MM-dd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None, out to);

            if (!fromValid || !toValid ||
                from > to || to == DateTime.MaxValue.Date)
            {
                Reset("Please select a valid date range.");
                return;
            }

            try
            {
                ReportState state = new ReportState
                {
                    Data = LoadData(from, to,
                        ddlFeeType.SelectedValue,
                        ddlTransaction.SelectedValue),
                    From = from,
                    To = to,
                    FeeType = ddlFeeType.SelectedValue,
                    TransactionType = ddlTransaction.SelectedValue,
                    GeneratedAt = DateTime.Now
                };

                Session[CacheKey] = state;
                BindReport(state);
            }
            catch (Exception)
            {
                Reset("Unable to generate fee collections. Verify the stored procedure and RDLC.");
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            if (AdminHelper.IsAdmin(Session) &&
                IsPostBack &&
                string.IsNullOrEmpty(lblError.Text))
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
                        Reset("Unable to display the fee collections preview.");
                    }
                }
            }

            base.OnPreRender(e);
        }

        private DataTable LoadData(DateTime from, DateTime to,
            string feeType, string transactionType)
        {
            DataTable data = new DataTable("FeeCollectionsDataSet");

            string cs = ConfigurationManager
                .ConnectionStrings["ElibraryConnection"]
                .ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(
                "dbo.EReport_FeeCollections", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 60;

                cmd.Parameters.Add("@DateFrom", SqlDbType.Date).Value = from;
                cmd.Parameters.Add("@DateTo", SqlDbType.Date).Value = to;

                cmd.Parameters.Add("@FeeType", SqlDbType.VarChar, 50).Value =
                    string.IsNullOrEmpty(feeType)
                        ? (object)DBNull.Value : feeType;

                cmd.Parameters.Add("@TransactionType", SqlDbType.VarChar, 10).Value =
                    string.IsNullOrEmpty(transactionType)
                        ? (object)DBNull.Value : transactionType;

                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(data);
                }
            }

            return data;
        }

        private void BindReport(ReportState state)
        {
            if (state.Data.Rows.Count == 0)
            {
                pnlResults.Visible = false;
                pnlEmpty.Visible = true;
                lblError.Text = "No fee transactions match the selected filters.";
                return;
            }

            decimal payments = 0m;
            decimal refunds = 0m;

            foreach (DataRow row in state.Data.Rows)
            {
                decimal amount = Convert.ToDecimal(row["SignedAmount"]);

                if (amount >= 0)
                    payments += amount;
                else
                    refunds += -amount;
            }

            decimal net = payments - refunds;

            lblPayments.Text = Money(payments);
            lblRefunds.Text = Money(refunds);
            lblNet.Text = Money(net);

            pnlResults.Visible = true;
            pnlEmpty.Visible = false;

            rvReport.ProcessingMode = ProcessingMode.Local;
            rvReport.LocalReport.ReportPath = Server.MapPath(
                "~/Reports/Finance/FeeCollections.rdlc");

            rvReport.LocalReport.DataSources.Clear();
            rvReport.LocalReport.DataSources.Add(
                new ReportDataSource("FeeCollectionsDataSet", state.Data));

            rvReport.LocalReport.SetParameters(
                new ReportParameter[]
                {
                    new ReportParameter("Period",
                        state.From.ToString("MMM dd, yyyy") + " - " +
                        state.To.ToString("MMM dd, yyyy")),
                    new ReportParameter("Filters",
                        "Fee: " + (string.IsNullOrEmpty(state.FeeType)
                            ? "All" : state.FeeType) +
                        " | Transactions: " +
                        (string.IsNullOrEmpty(state.TransactionType)
                            ? "All" : state.TransactionType)),
                    new ReportParameter("GrossPayments", Money(payments)),
                    new ReportParameter("Refunds", Money(refunds)),
                    new ReportParameter("NetCollections", Money(net)),
                    new ReportParameter("GeneratedOn",
                        state.GeneratedAt.ToString("MMM dd, yyyy hh:mm tt"))
                });

            rvReport.LocalReport.Refresh();
            lblError.Text = "";
        }

        private static string Money(decimal amount)
        {
            return "₱" + amount.ToString("N2",
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
