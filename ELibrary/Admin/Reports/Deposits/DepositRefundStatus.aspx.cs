
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace ELibrary.Admin.Reports.Deposits
{
    public partial class DepositRefundStatus : Page
    {
        private const string CacheKey =
            "ELibrary_Report_DepositRefundStatus";

        private string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings[
                    "ElibraryConnection"].ConnectionString;
            }
        }

        [Serializable]
        private sealed class ReportState
        {
            public DataTable Data { get; set; }
            public string Search { get; set; }
            public string Status { get; set; }
            public bool OnlyHeld { get; set; }
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
                Session.Remove(CacheKey);
                pnlResults.Visible = false;
                pnlEmpty.Visible = true;

                try
                {
                    LoadStatuses();
                }
                catch (Exception)
                {
                    lblError.Text = "Unable to load deposit statuses.";
                }
            }
        }

        private void LoadStatuses()
        {
            ddlStatus.Items.Clear();
            ddlStatus.Items.Add(
                new ListItem("All Deposit Statuses", ""));

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT DISTINCT Status FROM dbo.ESecurityDeposit " +
                "WHERE Status IS NOT NULL AND LTRIM(RTRIM(Status)) <> '' " +
                "ORDER BY Status", con))
            {
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        string value =
                            Convert.ToString(reader["Status"]);

                        ddlStatus.Items.Add(
                            new ListItem(value, value));
                    }
                }
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
                return;

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
                    Search = search,
                    Status = ddlStatus.SelectedValue,
                    OnlyHeld = ddlHeld.SelectedValue == "1",
                    GeneratedOn = DateTime.Now
                };

                state.Data = LoadData(state);
                Session[CacheKey] = state;
                BindReport(state);
            }
            catch (Exception)
            {
                Reset("Unable to generate deposit refund status.");
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
                        Reset("Unable to restore deposit report.");
                    }
                }
            }

            base.OnPreRender(e);
        }

        private DataTable LoadData(ReportState state)
        {
            DataTable table =
                new DataTable("DepositRefundStatusDataSet");

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(
                "dbo.EReport_DepositRefundStatus", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 60;

                cmd.Parameters.Add(
                    "@Search", SqlDbType.NVarChar, 150).Value =
                    string.IsNullOrWhiteSpace(state.Search)
                        ? (object)DBNull.Value : state.Search;

                cmd.Parameters.Add(
                    "@Status", SqlDbType.VarChar, 20).Value =
                    string.IsNullOrWhiteSpace(state.Status)
                        ? (object)DBNull.Value : state.Status;

                cmd.Parameters.Add(
                    "@OnlyHeld", SqlDbType.Bit).Value =
                    state.OnlyHeld;

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
                lblError.Text = "No deposits match your filters.";
                return;
            }

            decimal refunded = 0m;
            decimal held = 0m;

            foreach (DataRow row in state.Data.Rows)
            {
                refunded += Convert.ToDecimal(
                    row["AmountRefunded"]);

                held += Convert.ToDecimal(
                    row["AmountHeld"]);
            }

            lblCount.Text = state.Data.Rows.Count.ToString("N0");
            lblRefunded.Text = Money(refunded);
            lblHeld.Text = Money(held);

            pnlResults.Visible = true;
            pnlEmpty.Visible = false;

            rvReport.ProcessingMode = ProcessingMode.Local;

            rvReport.LocalReport.ReportPath =
                Server.MapPath(
                    "~/Reports/Deposits/DepositRefundStatus.rdlc");

            rvReport.LocalReport.DataSources.Clear();

            rvReport.LocalReport.DataSources.Add(
                new ReportDataSource(
                    "DepositRefundStatusDataSet",
                    state.Data));

            string filters =
                "Status: " +
                (string.IsNullOrEmpty(state.Status)
                    ? "All" : state.Status) +
                " | Only Held: " +
                (state.OnlyHeld ? "Yes" : "No") +
                " | Search: " +
                (string.IsNullOrEmpty(state.Search)
                    ? "All" : state.Search);

            rvReport.LocalReport.SetParameters(
                new ReportParameter[]
                {
                    new ReportParameter("Filters", filters),
                    new ReportParameter("TotalHeld", Money(held)),
                    new ReportParameter("TotalRefunded", Money(refunded)),
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
