
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

namespace ELibrary.Admin.Reports.Audit
{
    public partial class AuditTrailSummary : Page
    {
        private const string CacheKey =
            "ELibrary_Report_AuditTrailSummary";

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
            public DateTime From { get; set; }
            public DateTime To { get; set; }
            public string Search { get; set; }
            public string Category { get; set; }
            public int? Role { get; set; }
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

                txtFrom.Text =
                    new DateTime(today.Year, today.Month, 1)
                    .ToString("yyyy-MM-dd");

                txtTo.Text = today.ToString("yyyy-MM-dd");

                Session.Remove(CacheKey);
                pnlResults.Visible = false;
                pnlEmpty.Visible = true;

                try
                {
                    LoadCategories();
                }
                catch (Exception)
                {
                    lblError.Text = "Unable to load audit categories.";
                }
            }
        }

        private void LoadCategories()
        {
            ddlCategory.Items.Clear();
            ddlCategory.Items.Add(
                new ListItem("All Categories", ""));

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT DISTINCT ActionCategory FROM dbo.EAuditLog " +
                "WHERE ActionCategory IS NOT NULL " +
                "AND LTRIM(RTRIM(ActionCategory)) <> '' " +
                "ORDER BY ActionCategory", con))
            {
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        string value = Convert.ToString(
                            reader["ActionCategory"]);

                        ddlCategory.Items.Add(
                            new ListItem(value, value));
                    }
                }
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
                DateTimeStyles.None, out from) ||
                !DateTime.TryParseExact(
                txtTo.Text, "yyyy-MM-dd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None, out to) ||
                from > to ||
                to == DateTime.MaxValue.Date)
            {
                Reset("Please select a valid date range.");
                return;
            }

            int role;
            int? selectedRole = null;

            if (!string.IsNullOrWhiteSpace(ddlRole.SelectedValue))
            {
                if (!int.TryParse(ddlRole.SelectedValue, out role) ||
                    (role != 1 && role != 2))
                {
                    Reset("Invalid actor role.");
                    return;
                }

                selectedRole = role;
            }

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
                    Search = search,
                    Category = ddlCategory.SelectedValue,
                    Role = selectedRole,
                    GeneratedOn = DateTime.Now
                };

                state.Data = LoadData(state);
                Session[CacheKey] = state;
                BindReport(state);
            }
            catch (Exception)
            {
                Reset("Unable to generate audit trail summary.");
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
                        Reset("Unable to restore audit trail report.");
                    }
                }
            }

            base.OnPreRender(e);
        }

        private DataTable LoadData(ReportState state)
        {
            DataTable table =
                new DataTable("AuditTrailSummaryDataSet");

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(
                "dbo.EReport_AuditTrailSummary", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 60;

                cmd.Parameters.Add(
                    "@DateFrom", SqlDbType.Date).Value = state.From;

                cmd.Parameters.Add(
                    "@DateTo", SqlDbType.Date).Value = state.To;

                cmd.Parameters.Add(
                    "@Search", SqlDbType.NVarChar, 150).Value =
                    string.IsNullOrEmpty(state.Search)
                        ? (object)DBNull.Value : state.Search;

                cmd.Parameters.Add(
                    "@Category", SqlDbType.VarChar, 30).Value =
                    string.IsNullOrEmpty(state.Category)
                        ? (object)DBNull.Value : state.Category;

                cmd.Parameters.Add(
                    "@ActorRole", SqlDbType.Int).Value =
                    state.Role.HasValue
                        ? (object)state.Role.Value
                        : DBNull.Value;

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
                    "No audit events match your selected filters.";
                return;
            }

            HashSet<int> actors = new HashSet<int>();

            HashSet<string> categories =
                new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            foreach (DataRow row in state.Data.Rows)
            {
                actors.Add(Convert.ToInt32(row["UserID"]));

                if (row["ActionCategory"] != DBNull.Value)
                {
                    categories.Add(Convert.ToString(
                        row["ActionCategory"]));
                }
            }

            lblEvents.Text = state.Data.Rows.Count.ToString("N0");
            lblActors.Text = actors.Count.ToString("N0");
            lblCategories.Text = categories.Count.ToString("N0");

            pnlResults.Visible = true;
            pnlEmpty.Visible = false;

            rvReport.ProcessingMode = ProcessingMode.Local;
            rvReport.LocalReport.ReportPath = Server.MapPath(
                "~/Reports/Audit/AuditTrailSummary.rdlc");

            rvReport.LocalReport.DataSources.Clear();

            rvReport.LocalReport.DataSources.Add(
                new ReportDataSource(
                    "AuditTrailSummaryDataSet", state.Data));

            string roleFilter = !state.Role.HasValue
                ? "All"
                : state.Role.Value == 2
                    ? "Librarian" : "Customer";

            rvReport.LocalReport.SetParameters(
                new ReportParameter[]
                {
                    new ReportParameter(
                        "Period",
                        state.From.ToString("MMM dd, yyyy") + " - " +
                        state.To.ToString("MMM dd, yyyy")),
                    new ReportParameter(
                        "Filters",
                        "Role: " + roleFilter +
                        " | Category: " +
                        (string.IsNullOrEmpty(state.Category)
                            ? "All" : state.Category) +
                        " | Search: " +
                        (string.IsNullOrEmpty(state.Search)
                            ? "All" : state.Search)),
                    new ReportParameter(
                        "GeneratedOn",
                        state.GeneratedOn.ToString(
                            "MMM dd, yyyy hh:mm tt"))
                });

            rvReport.LocalReport.Refresh();
            lblError.Text = "";
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
