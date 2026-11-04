
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace ELibrary.Admin.Reports.Consolidated
{
    public partial class LibraryPerformance : Page
    {
        private const string CacheKey =
            "ELibrary_ConsolidatedLibraryPerformance";

        private static readonly CultureInfo PhilippineCulture =
            CultureInfo.GetCultureInfo("en-PH");

        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["ElibraryConnection"]
                    .ConnectionString;
            }
        }

        [Serializable]
        private sealed class ReportState
        {
            public DataSet Data { get; set; }
            public DateTime From { get; set; }
            public DateTime To { get; set; }
            public DateTime GeneratedOn { get; set; }
            public string PeriodType { get; set; }
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
                InitializeFilters();

                Session.Remove(CacheKey);
                pnlResults.Visible = false;
                pnlEmpty.Visible = true;
            }
        }

        private void InitializeFilters()
        {
            DateTime today = DateTime.Today;

            ddlYear.Items.Clear();

            for (int year = today.Year + 1;
                 year >= today.Year - 10;
                 year--)
            {
                ddlYear.Items.Add(
                    new ListItem(
                        year.ToString(),
                        year.ToString()));
            }

            ddlYear.SelectedValue = today.Year.ToString();

            ddlPeriod.SelectedValue = "Monthly";
            ddlMonth.SelectedValue = today.Month.ToString();

            int quarter = ((today.Month - 1) / 3) + 1;
            ddlQuarter.SelectedValue = quarter.ToString();

            txtFrom.Text = new DateTime(
                today.Year, today.Month, 1)
                .ToString("yyyy-MM-dd");

            txtTo.Text = today.ToString("yyyy-MM-dd");
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
                return;

            DateTime from;
            DateTime to;
            string periodType;

            if (!TryResolvePeriod(
                    out from,
                    out to,
                    out periodType))
            {
                Reset(
                    "Please select a valid reporting period.");
                return;
            }

            if (from > to ||
                to == DateTime.MaxValue.Date ||
                (to - from).TotalDays > 1830)
            {
                Reset(
                    "Select a valid date range of up to five years.");
                return;
            }

            try
            {
                ReportState state = new ReportState
                {
                    From = from,
                    To = to,
                    PeriodType = periodType,
                    GeneratedOn = DateTime.Now
                };

                state.Data = LoadReportData(from, to);

                if (state.Data.Tables["OverviewDataSet"]
                    .Rows.Count == 0)
                {
                    Reset(
                        "The consolidated overview returned no data.");
                    return;
                }

                Session[CacheKey] = state;

                BindReport(state);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError(
                    "LibraryPerformance generation failed: " + ex);

                Reset(
                    "Unable to generate the consolidated report. " +
                    "Verify the stored procedures and RDLC file.");
            }
        }

        private bool TryResolvePeriod(
            out DateTime from,
            out DateTime to,
            out string periodType)
        {
            from = DateTime.MinValue;
            to = DateTime.MinValue;
            periodType = ddlPeriod.SelectedValue;

            int year;
            int month;
            int quarter;

            if (periodType == "Custom")
            {
                return DateTime.TryParseExact(
                        txtFrom.Text,
                        "yyyy-MM-dd",
                        CultureInfo.InvariantCulture,
                        DateTimeStyles.None,
                        out from)
                    &&
                    DateTime.TryParseExact(
                        txtTo.Text,
                        "yyyy-MM-dd",
                        CultureInfo.InvariantCulture,
                        DateTimeStyles.None,
                        out to);
            }

            if (!int.TryParse(
                ddlYear.SelectedValue, out year))
            {
                return false;
            }

            if (year < 2000 || year > 9998)
                return false;

            if (periodType == "Monthly")
            {
                if (!int.TryParse(
                        ddlMonth.SelectedValue,
                        out month) ||
                    month < 1 || month > 12)
                {
                    return false;
                }

                from = new DateTime(year, month, 1);
                to = from.AddMonths(1).AddDays(-1);

                return true;
            }

            if (periodType == "Quarterly")
            {
                if (!int.TryParse(
                        ddlQuarter.SelectedValue,
                        out quarter) ||
                    quarter < 1 || quarter > 4)
                {
                    return false;
                }

                month = ((quarter - 1) * 3) + 1;

                from = new DateTime(year, month, 1);
                to = from.AddMonths(3).AddDays(-1);

                return true;
            }

            if (periodType == "Yearly")
            {
                from = new DateTime(year, 1, 1);
                to = new DateTime(year, 12, 31);
                return true;
            }

            return false;
        }

        private DataSet LoadReportData(
            DateTime from,
            DateTime to)
        {
            DataSet result = new DataSet(
                "LibraryPerformanceReport");

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            {
                con.Open();

                AddStoredProcedureTable(
                    con,
                    result,
                    "OverviewDataSet",
                    "dbo.EReport_ConsolidatedOverview",
                    from,
                    to);

                AddStoredProcedureTable(
                    con,
                    result,
                    "BorrowingTrendDataSet",
                    "dbo.EReport_ConsolidatedBorrowingTrend",
                    from,
                    to);

                LoadFinancialTrends(con, result, from, to);
                LoadTopBooks(con, result, from, to);
                LoadGenrePopularity(con, result, from, to);
                LoadAuditCategories(con, result, from, to);
            }

            return result;
        }

        private void AddStoredProcedureTable(
            SqlConnection con,
            DataSet result,
            string tableName,
            string procedureName,
            DateTime from,
            DateTime to)
        {
            using (SqlCommand cmd =
                new SqlCommand(procedureName, con))
            {
                cmd.CommandType =
                    CommandType.StoredProcedure;

                cmd.CommandTimeout = 120;

                AddDateRange(cmd, from, to);

                FillTable(result, tableName, cmd);
            }
        }

        private static void AddDateRange(
            SqlCommand cmd,
            DateTime from,
            DateTime to)
        {
            cmd.Parameters.Add(
                "@DateFrom", SqlDbType.Date).Value = from;

            cmd.Parameters.Add(
                "@DateTo", SqlDbType.Date).Value = to;
        }

        private static void FillTable(
            DataSet result,
            string tableName,
            SqlCommand cmd)
        {
            DataTable table = new DataTable(tableName);

            using (SqlDataAdapter adapter =
                new SqlDataAdapter(cmd))
            {
                adapter.Fill(table);
            }

            result.Tables.Add(table);
        }

        private void LoadFinancialTrends(
            SqlConnection con,
            DataSet result,
            DateTime from,
            DateTime to)
        {
            using (SqlCommand cmd = new SqlCommand(
                "dbo.EReport_CollectionTrends", con))
            {
                cmd.CommandType =
                    CommandType.StoredProcedure;

                cmd.CommandTimeout = 120;

                AddDateRange(cmd, from, to);

                cmd.Parameters.Add(
                    "@Grouping", SqlDbType.VarChar, 10)
                    .Value = "Monthly";

                FillTable(
                    result,
                    "FinancialTrendDataSet",
                    cmd);
            }
        }

        private void LoadTopBooks(
            SqlConnection con,
            DataSet result,
            DateTime from,
            DateTime to)
        {
            using (SqlCommand cmd = new SqlCommand(
                "dbo.EReport_MostBorrowedBooks", con))
            {
                cmd.CommandType =
                    CommandType.StoredProcedure;

                cmd.CommandTimeout = 120;

                AddDateRange(cmd, from, to);

                cmd.Parameters.Add(
                    "@Search", SqlDbType.NVarChar, 150)
                    .Value = DBNull.Value;

                cmd.Parameters.Add(
                    "@GenreID", SqlDbType.Int)
                    .Value = DBNull.Value;

                cmd.Parameters.Add(
                    "@IncludeArchived", SqlDbType.Bit)
                    .Value = false;

                cmd.Parameters.Add(
                    "@TopN", SqlDbType.Int)
                    .Value = 10;

                FillTable(result, "TopBooksDataSet", cmd);
            }
        }

        private void LoadGenrePopularity(
            SqlConnection con,
            DataSet result,
            DateTime from,
            DateTime to)
        {
            using (SqlCommand cmd = new SqlCommand(
                "dbo.EReport_GenrePopularity", con))
            {
                cmd.CommandType =
                    CommandType.StoredProcedure;

                cmd.CommandTimeout = 120;

                AddDateRange(cmd, from, to);

                cmd.Parameters.Add(
                    "@IncludeArchived", SqlDbType.Bit)
                    .Value = false;

                cmd.Parameters.Add(
                    "@Search", SqlDbType.NVarChar, 100)
                    .Value = DBNull.Value;

                FillTable(
                    result,
                    "GenrePopularityDataSet",
                    cmd);
            }
        }

        private void LoadAuditCategories(
            SqlConnection con,
            DataSet result,
            DateTime from,
            DateTime to)
        {
            const string sql = @"
SELECT
    COALESCE(
        NULLIF(LTRIM(RTRIM(ActionCategory)), ''),
        'Uncategorized'
    ) AS ActionCategory,
    COUNT(*) AS EventCount
FROM dbo.EAuditLog
WHERE TimeStamp >= @DateFrom
  AND TimeStamp < DATEADD(DAY, 1, @DateTo)
GROUP BY
    COALESCE(
        NULLIF(LTRIM(RTRIM(ActionCategory)), ''),
        'Uncategorized'
    )
ORDER BY EventCount DESC, ActionCategory;";

            using (SqlCommand cmd =
                new SqlCommand(sql, con))
            {
                cmd.CommandType = CommandType.Text;
                cmd.CommandTimeout = 120;

                AddDateRange(cmd, from, to);

                FillTable(
                    result,
                    "AuditCategoryDataSet",
                    cmd);
            }
        }

        private void BindReport(ReportState state)
        {
            DataRow overview =
                state.Data.Tables["OverviewDataSet"].Rows[0];

            decimal gross = 0m;
            decimal refunds = 0m;
            decimal net = 0m;

            foreach (DataRow row in
                state.Data.Tables["FinancialTrendDataSet"].Rows)
            {
                gross += ToDecimal(row["GrossPayments"]);
                refunds += ToDecimal(row["TotalRefunds"]);
                net += ToDecimal(row["NetCollections"]);
            }

            lblBorrowings.Text =
                Convert.ToInt32(
                    overview["CollectedBorrowings"])
                    .ToString("N0");

            lblConversion.Text =
                ToDecimal(overview["ConversionRate"])
                    .ToString("N2") + "%";

            lblGross.Text = Money(gross);
            lblNet.Text = Money(net);

            lblSnapshot.Text =
                "Reporting period: " +
                state.From.ToString("MMM dd, yyyy") +
                " - " +
                state.To.ToString("MMM dd, yyyy") +
                " | Current snapshots generated: " +
                state.GeneratedOn.ToString(
                    "MMM dd, yyyy hh:mm tt");

            pnlResults.Visible = true;
            pnlEmpty.Visible = false;

            rvReport.ProcessingMode =
                ProcessingMode.Local;

            rvReport.LocalReport.ReportPath =
                Server.MapPath(
                    "~/Reports/Consolidated/LibraryPerformance.rdlc");

            rvReport.LocalReport.DisplayName =
                "ELibrary_Performance_" +
                state.PeriodType + "_" +
                state.From.ToString("yyyyMMdd") + "_" +
                state.To.ToString("yyyyMMdd");

            rvReport.LocalReport.DataSources.Clear();

            AddReportSource(
                state, "OverviewDataSet");

            AddReportSource(
                state, "BorrowingTrendDataSet");

            AddReportSource(
                state, "FinancialTrendDataSet");

            AddReportSource(
                state, "TopBooksDataSet");

            AddReportSource(
                state, "GenrePopularityDataSet");

            AddReportSource(
                state, "AuditCategoryDataSet");

            rvReport.LocalReport.SetParameters(
                new ReportParameter[]
                {
                    new ReportParameter(
                        "PeriodType",
                        state.PeriodType),

                    new ReportParameter(
                        "Period",
                        state.From.ToString("MMM dd, yyyy") +
                        " - " +
                        state.To.ToString("MMM dd, yyyy")),

                    new ReportParameter(
                        "GeneratedOn",
                        state.GeneratedOn.ToString(
                            "MMM dd, yyyy hh:mm tt")),

                    new ReportParameter(
                        "GrossPayments", Money(gross)),

                    new ReportParameter(
                        "TotalRefunds", Money(refunds)),

                    new ReportParameter(
                        "NetCollections", Money(net))
                });

            rvReport.LocalReport.Refresh();
            lblError.Text = "";
        }

        private void AddReportSource(
            ReportState state,
            string tableName)
        {
            rvReport.LocalReport.DataSources.Add(
                new ReportDataSource(
                    tableName,
                    state.Data.Tables[tableName]));
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
                    catch (Exception ex)
                    {
                        System.Diagnostics.Trace.TraceError(
                            "Consolidated report restore failed: " + ex);

                        Reset(
                            "Unable to restore consolidated report.");
                    }
                }
            }

            base.OnPreRender(e);
        }

        private static decimal ToDecimal(object value)
        {
            if (value == null || value == DBNull.Value)
                return 0m;

            return Convert.ToDecimal(value);
        }

        private static string Money(decimal amount)
        {
            return "₱" + amount.ToString(
                "N2", PhilippineCulture);
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
