
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using Microsoft.Reporting.WebForms;

namespace ELibrary.Admin.Reports.Borrowing
{
    public partial class ReservationConversion : Page
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

        private const string CacheKey =
            "ELibrary_Report_ReservationConversion";

        [Serializable]
        private sealed class ReportState
        {
            public DataTable Data { get; set; }
            public DateTime From { get; set; }
            public DateTime To { get; set; }
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

                Session.Remove(CacheKey);
                pnlResults.Visible = false;
                pnlEmpty.Visible = true;
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

            try
            {
                DataTable data = LoadData(from, to);

                ReportState state = new ReportState
                {
                    Data = data,
                    From = from,
                    To = to,
                    GeneratedOn = DateTime.Now
                };

                Session[CacheKey] = state;
                BindReport(state);
            }
            catch (Exception)
            {
                ResetReport(
                    "Unable to generate the reservation report.");
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
            DateTime from, DateTime to)
        {
            DataTable table =
                new DataTable("ReservationConversionDataSet");

            using (SqlConnection connection =
                new SqlConnection(ConnectionString))
            using (SqlCommand command =
                new SqlCommand(
                    "dbo.EReport_ReservationConversion",
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
            DataTable data = state.Data;

            if (data.Rows.Count == 0)
            {
                pnlResults.Visible = false;
                pnlEmpty.Visible = true;
                lblMessage.Text =
                    "No online reservations found for this period.";
                return;
            }

            int total = data.Rows.Count;
            int collected = 0;

            foreach (DataRow row in data.Rows)
            {
                if (Convert.ToInt32(
                    row["IsConverted"]) == 1)
                {
                    collected++;
                }
            }

            int notCollected = total - collected;

            decimal rate = total == 0
                ? 0m
                : 100m * collected / total;

            lblTotal.Text = total.ToString("N0");
            lblCollected.Text = collected.ToString("N0");
            lblNotCollected.Text =
                notCollected.ToString("N0");

            lblRate.Text =
                rate.ToString("N1") + "%";

            pnlResults.Visible = true;
            pnlEmpty.Visible = false;

            rvReport.ProcessingMode =
                ProcessingMode.Local;

            rvReport.LocalReport.ReportPath =
                Server.MapPath(
                    "~/Reports/Borrowing/ReservationConversion.rdlc");

            rvReport.LocalReport.DataSources.Clear();

            rvReport.LocalReport.DataSources.Add(
                new ReportDataSource(
                    "ReservationConversionDataSet",
                    data));

            string period =
                state.From.ToString("MMM dd, yyyy") +
                " - " +
                state.To.ToString("MMM dd, yyyy");

            rvReport.LocalReport.SetParameters(
                new ReportParameter[]
                {
                    new ReportParameter("Period", period),

                    new ReportParameter(
                        "TotalReservations",
                        total.ToString("N0")),

                    new ReportParameter(
                        "CollectedReservations",
                        collected.ToString("N0")),

                    new ReportParameter(
                        "ConversionRate",
                        rate.ToString("N1") + "%"),

                    new ReportParameter(
                        "GeneratedOn",
                        state.GeneratedOn.ToString(
                            "MMM dd, yyyy hh:mm tt"))
                });

            rvReport.LocalReport.Refresh();
            lblMessage.Text = "";
        }

        private void ResetReport(string message)
        {
            Session.Remove(CacheKey);
            pnlResults.Visible = false;
            pnlEmpty.Visible = true;
            lblMessage.Text = Server.HtmlEncode(message);
        }
    }
}
