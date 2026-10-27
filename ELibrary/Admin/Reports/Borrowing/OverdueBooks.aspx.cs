
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using Microsoft.Reporting.WebForms;

namespace ELibrary.Admin.Reports.Borrowing
{
    public partial class OverdueBooks : Page
    {
        private readonly string connectionString =
            ConfigurationManager
                .ConnectionStrings["ElibraryConnection"]
                .ConnectionString;

        private string CacheKey
        {
            get
            {
                return "ELibrary_Report_OverdueBooks_" +
                    Convert.ToString(Session["UserID"]);
            }
        }

        protected void Page_Load(
            object sender,
            EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect(
                    "~/Login.aspx",
                    false);

                Context.ApplicationInstance
                    .CompleteRequest();

                return;
            }

            if (!IsPostBack)
            {
                txtSearch.Text = "";
                ddlMinimumDays.SelectedValue = "1";

                Session.Remove(CacheKey);

                pnlReport.Visible = false;
                pnlEmpty.Visible = true;
            }
        }

        protected void btnGenerate_Click(
            object sender,
            EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
                return;

            lblMessage.Text = "";

            int minimumDays;

            if (!int.TryParse(
                ddlMinimumDays.SelectedValue,
                out minimumDays))
            {
                ClearReport();

                ShowError(
                    "Invalid minimum days overdue filter.");

                return;
            }

            if (minimumDays < 1 ||
                minimumDays > 36500)
            {
                ClearReport();

                ShowError(
                    "Minimum days overdue must be valid.");

                return;
            }

            string search =
                (txtSearch.Text ?? "").Trim();

            if (search.Length > 150)
            {
                ClearReport();

                ShowError(
                    "Search cannot exceed 150 characters.");

                return;
            }

            try
            {
                DataTable records = LoadData(
                    search,
                    minimumDays);

                ReportState state = new ReportState
                {
                    Records = records,
                    Search = search,
                    MinimumDays = minimumDays,
                    GeneratedOn = DateTime.Now
                };

                Session[CacheKey] = state;

                DisplayReport(state);
            }
            catch (Exception)
            {
                ClearReport();

                ShowError(
                    "Unable to generate the overdue report. " +
                    "Verify the SQL procedure and RDLC file.");
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            if (AdminHelper.IsAdmin(Session) &&
                IsPostBack &&
                lblMessage.Text.Length == 0)
            {
                ReportState state =
                    Session[CacheKey] as ReportState;

                if (state != null)
                {
                    try
                    {
                        DisplayReport(state);
                    }
                    catch (Exception)
                    {
                        ClearReport();

                        ShowError(
                            "Unable to restore the report preview.");
                    }
                }
            }

            base.OnPreRender(e);
        }

        private DataTable LoadData(
            string search,
            int minimumDays)
        {
            DataTable table =
                new DataTable("OverdueDataSet");

            using (SqlConnection connection =
                new SqlConnection(connectionString))
            using (SqlCommand command =
                new SqlCommand(
                    "dbo.EReport_OverdueBooks",
                    connection))
            {
                command.CommandType =
                    CommandType.StoredProcedure;

                command.CommandTimeout = 60;

                command.Parameters.Add(
                    "@Search",
                    SqlDbType.NVarChar,
                    150).Value =
                    string.IsNullOrWhiteSpace(search)
                        ? (object)DBNull.Value
                        : search;

                command.Parameters.Add(
                    "@MinimumDaysOverdue",
                    SqlDbType.Int).Value =
                    minimumDays;

                using (SqlDataAdapter adapter =
                    new SqlDataAdapter(command))
                {
                    adapter.Fill(table);
                }
            }

            return table;
        }

        private void DisplayReport(ReportState state)
        {
            if (state == null ||
                state.Records == null)
                return;

            DataTable records = state.Records;

            if (records.Rows.Count == 0)
            {
                pnlReport.Visible = false;
                pnlEmpty.Visible = true;

                lblMessage.Text =
                    "No currently overdue books match " +
                    "your selected filters.";

                return;
            }

            pnlReport.Visible = true;
            pnlEmpty.Visible = false;

            rvOverdue.ProcessingMode =
                ProcessingMode.Local;

            rvOverdue.LocalReport.ReportPath =
                Server.MapPath(
                    "~/Reports/Borrowing/OverdueBooks.rdlc");

            rvOverdue.LocalReport.DataSources.Clear();

            rvOverdue.LocalReport.DataSources.Add(
                new ReportDataSource(
                    "OverdueDataSet",
                    records));

            rvOverdue.LocalReport.SetParameters(
                new ReportParameter[]
                {
                    new ReportParameter(
                        "ReportDate",
                        state.GeneratedOn.ToString(
                            "MMMM dd, yyyy",
                            CultureInfo.GetCultureInfo(
                                "en-PH"))),

                    new ReportParameter(
                        "GeneratedOn",
                        state.GeneratedOn.ToString(
                            "MMMM dd, yyyy hh:mm tt",
                            CultureInfo.GetCultureInfo(
                                "en-PH"))),

                    new ReportParameter(
                        "FilterDescription",
                        BuildFilterDescription(state))
                });

            rvOverdue.LocalReport.Refresh();

            lblRecordCount.Text =
                records.Rows.Count.ToString("N0") +
                " Overdue Records";

            lblMessage.Text = "";
        }

        private string BuildFilterDescription(
            ReportState state)
        {
            string description =
                "At least " +
                state.MinimumDays.ToString() +
                (state.MinimumDays == 1
                    ? " calendar day overdue"
                    : " calendar days overdue");

            if (!string.IsNullOrWhiteSpace(
                state.Search))
            {
                description +=
                    " | Search: " + state.Search;
            }

            return description;
        }

        private void ClearReport()
        {
            Session.Remove(CacheKey);

            pnlReport.Visible = false;
            pnlEmpty.Visible = true;
        }

        private void ShowError(string message)
        {
            lblMessage.Text =
                Server.HtmlEncode(message);

            pnlReport.Visible = false;
            pnlEmpty.Visible = true;
        }

        [Serializable]
        private sealed class ReportState
        {
            public DataTable Records { get; set; }
            public string Search { get; set; }
            public int MinimumDays { get; set; }
            public DateTime GeneratedOn { get; set; }
        }
    }
}
