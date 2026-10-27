
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using Microsoft.Reporting.WebForms;

namespace ELibrary.Admin.Reports.Borrowing
{
    public partial class CustomerBorrowing : Page
    {
        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["ElibraryConnection"]
                    .ConnectionString;
            }
        }

        private string CacheKey
        {
            get { return "ELibrary_Report_CustomerBorrowing"; }
        }

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

                txtDateFrom.Text = new DateTime(
                    today.Year, today.Month, 1)
                    .ToString("yyyy-MM-dd");

                txtDateTo.Text =
                    today.ToString("yyyy-MM-dd");

                pnlReport.Visible = false;
                pnlEmpty.Visible = true;

                Session.Remove(CacheKey);
            }
        }

        protected void btnGenerate_Click(
            object sender, EventArgs e)
        {
            lblMessage.Text = "";

            DateTime from;
            DateTime to;

            if (!DateTime.TryParseExact(
                    txtDateFrom.Text,
                    "yyyy-MM-dd",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out from)
                ||
                !DateTime.TryParseExact(
                    txtDateTo.Text,
                    "yyyy-MM-dd",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out to))
            {
                ResetReport("Please select valid dates.");
                return;
            }

            if (from > to || to == DateTime.MaxValue.Date)
            {
                ResetReport("Please select a valid date range.");
                return;
            }

            string search = (txtCustomer.Text ?? "").Trim();
            string status = ddlStatus.SelectedValue;

            try
            {
                DataTable data =
                    LoadData(from, to, search, status);

                ReportState state = new ReportState
                {
                    Data = data,
                    From = from,
                    To = to,
                    Search = search,
                    Status = status,
                    GeneratedOn = DateTime.Now
                };

                Session[CacheKey] = state;
                BindReport(state);
            }
            catch (Exception)
            {
                ResetReport(
                    "Unable to generate the customer borrowing report.");
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            if (AdminHelper.IsAdmin(Session)
                && IsPostBack
                && string.IsNullOrEmpty(lblMessage.Text))
            {
                ReportState state = Session[CacheKey]
                    as ReportState;

                if (state != null)
                {
                    try
                    {
                        BindReport(state);
                    }
                    catch (Exception)
                    {
                        ResetReport(
                            "Unable to display the report preview.");
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
                new DataTable("CustomerBorrowingDataSet");

            using (SqlConnection connection =
                new SqlConnection(ConnectionString))
            using (SqlCommand command =
                new SqlCommand(
                    "dbo.EReport_CustomerBorrowing",
                    connection))
            {
                command.CommandType =
                    CommandType.StoredProcedure;

                command.CommandTimeout = 60;

                command.Parameters.Add(
                    "@DateFrom", SqlDbType.Date).Value =
                    from;

                command.Parameters.Add(
                    "@DateTo", SqlDbType.Date).Value =
                    to;

                command.Parameters.Add(
                    "@Search", SqlDbType.NVarChar, 150)
                    .Value = string.IsNullOrWhiteSpace(search)
                    ? (object)DBNull.Value
                    : search;

                command.Parameters.Add(
                    "@Status", SqlDbType.VarChar, 20)
                    .Value = string.IsNullOrWhiteSpace(status)
                    ? (object)DBNull.Value
                    : status;

                using (SqlDataAdapter adapter =
                    new SqlDataAdapter(command))
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
                pnlReport.Visible = false;
                pnlEmpty.Visible = true;
                lblMessage.Text =
                    "No borrowing records match the selected filters.";
                return;
            }

            pnlReport.Visible = true;
            pnlEmpty.Visible = false;

            rvReport.ProcessingMode = ProcessingMode.Local;

            rvReport.LocalReport.ReportPath =
                Server.MapPath(
                    "~/Reports/Borrowing/CustomerBorrowing.rdlc");

            rvReport.LocalReport.DataSources.Clear();

            rvReport.LocalReport.DataSources.Add(
                new ReportDataSource(
                    "CustomerBorrowingDataSet",
                    state.Data));

            string period =
                state.From.ToString("MMM dd, yyyy") +
                " - " +
                state.To.ToString("MMM dd, yyyy");

            string filters =
                "Customer: " +
                (string.IsNullOrWhiteSpace(state.Search)
                    ? "All Customers"
                    : state.Search) +
                " | Status: " +
                (string.IsNullOrEmpty(state.Status)
                    ? "All"
                    : state.Status);

            rvReport.LocalReport.SetParameters(
                new ReportParameter[]
                {
                    new ReportParameter("Period", period),
                    new ReportParameter("Filters", filters),
                    new ReportParameter(
                        "GeneratedOn",
                        state.GeneratedOn.ToString(
                            "MMM dd, yyyy hh:mm tt"))
                });

            rvReport.LocalReport.Refresh();

            lblCount.Text =
                state.Data.Rows.Count.ToString("N0") +
                " Records";

            lblMessage.Text = "";
        }

        private void ResetReport(string message)
        {
            Session.Remove(CacheKey);
            pnlReport.Visible = false;
            pnlEmpty.Visible = true;
            lblMessage.Text = Server.HtmlEncode(message);
        }
    }
}
