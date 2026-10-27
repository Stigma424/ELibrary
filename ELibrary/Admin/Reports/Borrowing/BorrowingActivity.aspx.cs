
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using Microsoft.Reporting.WebForms;

namespace ELibrary.Admin.Reports.Borrowing
{
    public partial class BorrowingActivity : Page
    {
        private readonly string connectionString =
            ConfigurationManager
                .ConnectionStrings["ElibraryConnection"]
                .ConnectionString;

        private string FilterKey
        {
            get
            {
                return "ELibrary_BorrowingActivity_Filter_" +
                    Convert.ToString(Session["UserID"]);
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

                txtDateFrom.Text =
                    new DateTime(
                        today.Year,
                        today.Month,
                        1).ToString("yyyy-MM-dd");

                txtDateTo.Text =
                    today.ToString("yyyy-MM-dd");

                pnlReport.Visible = false;
                pnlEmpty.Visible = true;

                Session.Remove(FilterKey);
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            if (AdminHelper.IsAdmin(Session))
            {
                ReportFilter filter =
                    Session[FilterKey] as ReportFilter;

                if (filter != null)
                {
                    try
                    {
                        GenerateReport(
                            filter.DateFrom,
                            filter.DateTo,
                            filter.Status);
                    }
                    catch (Exception ex)
                    {
                        ShowError(
                            "Unable to display borrowing report: " +
                            ex.Message);
                    }
                }
            }

            base.OnPreRender(e);
        }

        protected void btnGenerate_Click(
            object sender,
            EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
                return;

            lblMessage.Text = "";

            DateTime from;
            DateTime to;

            bool validFrom = DateTime.TryParseExact(
                txtDateFrom.Text,
                "yyyy-MM-dd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out from);

            bool validTo = DateTime.TryParseExact(
                txtDateTo.Text,
                "yyyy-MM-dd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out to);

            if (!validFrom || !validTo)
            {
                Session.Remove(FilterKey);

                ShowError(
                    "Please select valid reporting dates.");
                return;
            }

            if (from > to)
            {
                Session.Remove(FilterKey);

                ShowError(
                    "Date From cannot be later than Date To.");
                return;
            }

            if (to >= DateTime.MaxValue.Date)
            {
                Session.Remove(FilterKey);

                ShowError(
                    "Please select an earlier end date.");
                return;
            }

            string status = ddlStatus.SelectedValue;

            Session[FilterKey] = new ReportFilter
            {
                DateFrom = from,
                DateTo = to,
                Status = status
            };
        }

        private DataTable LoadBorrowingData(
            DateTime dateFrom,
            DateTime dateTo,
            string status)
        {
            DataTable table =
                new DataTable("BorrowingDataSet");

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand(
                    "dbo.EReport_BorrowingActivity",
                    con))
            {
                cmd.CommandType =
                    CommandType.StoredProcedure;

                cmd.CommandTimeout = 60;

                cmd.Parameters.Add(
                    "@DateFrom",
                    SqlDbType.Date).Value =
                    dateFrom.Date;

                cmd.Parameters.Add(
                    "@DateTo",
                    SqlDbType.Date).Value =
                    dateTo.Date;

                cmd.Parameters.Add(
                    "@Status",
                    SqlDbType.VarChar,
                    20).Value =
                    string.IsNullOrWhiteSpace(status)
                        ? (object)DBNull.Value
                        : status;

                using (SqlDataAdapter adapter =
                    new SqlDataAdapter(cmd))
                {
                    adapter.Fill(table);
                }
            }

            return table;
        }

        private void GenerateReport(
            DateTime dateFrom,
            DateTime dateTo,
            string status)
        {
            DataTable data = LoadBorrowingData(
                dateFrom,
                dateTo,
                status);

            if (data.Rows.Count == 0)
            {
                pnlReport.Visible = false;
                pnlEmpty.Visible = true;

                lblMessage.Text =
                    "No borrowing transactions match " +
                    "the selected filters.";

                return;
            }

            pnlReport.Visible = true;
            pnlEmpty.Visible = false;

            rvBorrowing.ProcessingMode =
                ProcessingMode.Local;

            rvBorrowing.LocalReport.ReportPath =
                Server.MapPath(
                    "~/Reports/Borrowing/BorrowingActivity.rdlc");

            rvBorrowing.LocalReport.DataSources.Clear();

            rvBorrowing.LocalReport.DataSources.Add(
                new ReportDataSource(
                    "BorrowingDataSet",
                    data));

            ReportParameter[] parameters =
            {
                new ReportParameter(
                    "DateFrom",
                    dateFrom.ToString(
                        "MMMM dd, yyyy",
                        CultureInfo.GetCultureInfo("en-PH"))),

                new ReportParameter(
                    "DateTo",
                    dateTo.ToString(
                        "MMMM dd, yyyy",
                        CultureInfo.GetCultureInfo("en-PH"))),

                new ReportParameter(
                    "GeneratedOn",
                    DateTime.Now.ToString(
                        "MMMM dd, yyyy hh:mm tt",
                        CultureInfo.GetCultureInfo("en-PH")))
            };

            rvBorrowing.LocalReport.SetParameters(
                parameters);

            rvBorrowing.LocalReport.Refresh();

            lblRecordCount.Text =
                data.Rows.Count.ToString("N0") +
                " Records";

            lblMessage.Text = "";
        }

        private void ShowError(string message)
        {
            lblMessage.Text =
                Server.HtmlEncode(message);

            pnlReport.Visible = false;
            pnlEmpty.Visible = true;
        }

        [Serializable]
        private sealed class ReportFilter
        {
            public DateTime DateFrom { get; set; }
            public DateTime DateTo { get; set; }
            public string Status { get; set; }
        }
    }
}
