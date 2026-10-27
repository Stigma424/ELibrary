
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using Microsoft.Reporting.WebForms;

namespace ELibrary.Admin.Reports.Deposits
{
    public partial class SecurityDeposits : Page
    {
        private const string CacheKey =
            "ELibrary_Report_SecurityDepositTransactions";

        [Serializable]
        private sealed class ReportState
        {
            public DataTable Data { get; set; }
            public DateTime From { get; set; }
            public DateTime To { get; set; }
            public string TransactionType { get; set; }
            public string PaymentMethod { get; set; }
            public string Search { get; set; }
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

            string type = ddlType.SelectedValue;
            string method = ddlMethod.SelectedValue;
            string search = (txtSearch.Text ?? "").Trim();

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
                    TransactionType = type,
                    PaymentMethod = method,
                    Search = search,
                    GeneratedOn = DateTime.Now,
                    Data = LoadData(
                        from, to, type, method, search)
                };

                Session[CacheKey] = state;
                BindReport(state);
            }
            catch (Exception)
            {
                Reset(
                    "Unable to generate deposit transactions. " +
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
                        Reset("Unable to restore deposit report.");
                    }
                }
            }

            base.OnPreRender(e);
        }

        private DataTable LoadData(
            DateTime from,
            DateTime to,
            string transactionType,
            string paymentMethod,
            string search)
        {
            DataTable table =
                new DataTable("SecurityDepositsDataSet");

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                new SqlCommand(
                    "dbo.EReport_SecurityDepositTransactions",
                    con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 60;

                cmd.Parameters.Add(
                    "@DateFrom", SqlDbType.Date).Value = from;

                cmd.Parameters.Add(
                    "@DateTo", SqlDbType.Date).Value = to;

                cmd.Parameters.Add(
                    "@TransactionType",
                    SqlDbType.VarChar, 20).Value =
                    string.IsNullOrWhiteSpace(transactionType)
                        ? (object)DBNull.Value
                        : transactionType;

                cmd.Parameters.Add(
                    "@PaymentMethod",
                    SqlDbType.VarChar, 30).Value =
                    string.IsNullOrWhiteSpace(paymentMethod)
                        ? (object)DBNull.Value
                        : paymentMethod;

                cmd.Parameters.Add(
                    "@Search",
                    SqlDbType.NVarChar, 150).Value =
                    string.IsNullOrWhiteSpace(search)
                        ? (object)DBNull.Value
                        : search;

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
                    "No deposit transactions match the filters.";
                return;
            }

            decimal collected = 0m;
            decimal refunded = 0m;

            foreach (DataRow row in state.Data.Rows)
            {
                decimal amount =
                    Convert.ToDecimal(row["Amount"]);

                string type =
                    Convert.ToString(row["TransactionType"]);

                if (type == "Collection")
                    collected += amount;
                else if (type == "Refund")
                    refunded += amount;
            }

            decimal net = collected - refunded;

            lblCollected.Text = Money(collected);
            lblRefunded.Text = Money(refunded);
            lblNet.Text = Money(net);

            pnlResults.Visible = true;
            pnlEmpty.Visible = false;

            rvReport.ProcessingMode = ProcessingMode.Local;

            rvReport.LocalReport.ReportPath =
                Server.MapPath(
                    "~/Reports/Deposits/SecurityDeposits.rdlc");

            rvReport.LocalReport.DataSources.Clear();

            rvReport.LocalReport.DataSources.Add(
                new ReportDataSource(
                    "SecurityDepositsDataSet",
                    state.Data));

            string period =
                state.From.ToString("MMM dd, yyyy") +
                " - " +
                state.To.ToString("MMM dd, yyyy");

            string filters =
                "Transaction: " +
                (string.IsNullOrEmpty(state.TransactionType)
                    ? "All" : state.TransactionType) +
                " | Method: " +
                (string.IsNullOrEmpty(state.PaymentMethod)
                    ? "All" : state.PaymentMethod) +
                " | Search: " +
                (string.IsNullOrEmpty(state.Search)
                    ? "All" : state.Search);

            rvReport.LocalReport.SetParameters(
                new ReportParameter[]
                {
                    new ReportParameter("Period", period),
                    new ReportParameter("Filters", filters),
                    new ReportParameter(
                        "TotalCollected", Money(collected)),
                    new ReportParameter(
                        "TotalRefunded", Money(refunded)),
                    new ReportParameter(
                        "NetMovement", Money(net)),
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
                "N2", CultureInfo.GetCultureInfo("en-PH"));
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
