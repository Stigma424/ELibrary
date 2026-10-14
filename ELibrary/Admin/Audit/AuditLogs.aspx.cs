
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;

namespace ELibrary.Admin.Audit
{
    public partial class AuditLogs : Page
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

        private int CurrentPage
        {
            get
            {
                object value = ViewState["AuditPage"];

                if (value == null)
                    return 1;

                return Convert.ToInt32(value);
            }
            set
            {
                ViewState["AuditPage"] = value;
            }
        }

        private string AppliedSearch
        {
            get
            {
                return Convert.ToString(
                    ViewState["AuditSearch"] ?? "");
            }
            set
            {
                ViewState["AuditSearch"] = value;
            }
        }

        private string AppliedCategory
        {
            get
            {
                return Convert.ToString(
                    ViewState["AuditCategory"] ?? "");
            }
            set
            {
                ViewState["AuditCategory"] = value;
            }
        }

        private string AppliedAction
        {
            get
            {
                return Convert.ToString(
                    ViewState["AuditAction"] ?? "");
            }
            set
            {
                ViewState["AuditAction"] = value;
            }
        }

        private string AppliedSort
        {
            get
            {
                return Convert.ToString(
                    ViewState["AuditSort"] ?? "date-desc");
            }
            set
            {
                ViewState["AuditSort"] = value;
            }
        }

        private string AppliedDateFrom
        {
            get
            {
                return Convert.ToString(
                    ViewState["AuditDateFrom"] ?? "");
            }
            set
            {
                ViewState["AuditDateFrom"] = value;
            }
        }

        private string AppliedDateTo
        {
            get
            {
                return Convert.ToString(
                    ViewState["AuditDateTo"] ?? "");
            }
            set
            {
                ViewState["AuditDateTo"] = value;
            }
        }

        private int AppliedPageSize
        {
            get
            {
                object value = ViewState["AuditPageSize"];

                if (value == null)
                    return 10;

                return Convert.ToInt32(value);
            }
            set
            {
                ViewState["AuditPageSize"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CurrentPage = 1;
                SaveAppliedFilters();
                LoadAuditLogs();
            }
        }

        private void SaveAppliedFilters()
        {
            AppliedSearch = txtSearch.Text.Trim();
            AppliedCategory = ddlCategory.SelectedValue;
            AppliedAction = ddlAction.SelectedValue;
            AppliedSort = ddlSort.SelectedValue;
            AppliedDateFrom = txtDateFrom.Text.Trim();
            AppliedDateTo = txtDateTo.Text.Trim();

            int pageSize;

            if (!int.TryParse(
                    ddlPageSize.SelectedValue,
                    out pageSize))
            {
                pageSize = 10;
            }

            AppliedPageSize = pageSize;
        }


        private bool ValidateDates()
        {
            DateTime dateFrom = DateTime.MinValue;
            DateTime dateTo = DateTime.MinValue;

            bool hasFrom =
                !string.IsNullOrWhiteSpace(txtDateFrom.Text);

            bool hasTo =
                !string.IsNullOrWhiteSpace(txtDateTo.Text);

            if (hasFrom &&
                !DateTime.TryParseExact(
                    txtDateFrom.Text,
                    "yyyy-MM-dd",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out dateFrom))
            {
                lblMessage.Text =
                    "Please enter a valid start date.";

                return false;
            }

            if (hasTo &&
                !DateTime.TryParseExact(
                    txtDateTo.Text,
                    "yyyy-MM-dd",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out dateTo))
            {
                lblMessage.Text =
                    "Please enter a valid end date.";

                return false;
            }

            if (hasFrom && hasTo && dateFrom > dateTo)
            {
                lblMessage.Text =
                    "Start date cannot be later than end date.";

                return false;
            }

            return true;
        }

        private object OptionalString(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return DBNull.Value;

            return value;
        }

        private object OptionalDate(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return DBNull.Value;

            return DateTime.ParseExact(
                value,
                "yyyy-MM-dd",
                CultureInfo.InvariantCulture);
        }

        private void LoadAuditLogs()
        {
            lblMessage.Text = "";

            try
            {
                int totalRecords = 0;

                DataTable records = new DataTable();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd =
                        new SqlCommand(
                            "EAuditLog_WebAdminSearch",
                            con))
                    {
                        cmd.CommandType =
                            CommandType.StoredProcedure;

                        cmd.Parameters.Add(
                            "@Search",
                            SqlDbType.VarChar,
                            255).Value =
                            OptionalString(AppliedSearch);

                        cmd.Parameters.Add(
                            "@Action",
                            SqlDbType.VarChar,
                            255).Value =
                            OptionalString(AppliedAction);

                        cmd.Parameters.Add(
                            "@Sort",
                            SqlDbType.VarChar,
                            20).Value =
                            AppliedSort;

                        cmd.Parameters.Add(
                            "@PageNumber",
                            SqlDbType.Int).Value =
                            CurrentPage;

                        cmd.Parameters.Add(
                            "@PageSize",
                            SqlDbType.Int).Value =
                            AppliedPageSize;

                        cmd.Parameters.Add(
                            "@Category",
                            SqlDbType.VarChar,
                            30).Value =
                            OptionalString(AppliedCategory);

                        cmd.Parameters.Add(
                            "@DateFrom",
                            SqlDbType.Date).Value =
                            OptionalDate(AppliedDateFrom);

                        cmd.Parameters.Add(
                            "@DateTo",
                            SqlDbType.Date).Value =
                            OptionalDate(AppliedDateTo);

                        con.Open();

                        using (SqlDataReader reader =
                            cmd.ExecuteReader())
                        {
                            // Result set 1: filtered count
                            if (reader.Read())
                            {
                                totalRecords =
                                    Convert.ToInt32(
                                        reader["FilteredCount"]);
                            }

                            // Result set 2: current page
                            if (reader.NextResult())
                            {
                                records.Load(reader);
                            }
                        }
                    }
                }

                gvAuditLogs.DataSource = records;
                gvAuditLogs.DataBind();

                int totalPages =
                    Math.Max(
                        1,
                        (int)Math.Ceiling(
                            totalRecords /
                            (double)AppliedPageSize));

                lblRecords.Text =
                    totalRecords.ToString("N0") +
                    " record(s) found";

                lblPage.Text =
                    "Page " + CurrentPage +
                    " of " + totalPages;

                btnPrevious.Enabled =
                    CurrentPage > 1;

                btnNext.Enabled =
                    CurrentPage < totalPages;
            }
            catch (SqlException ex)
            {
                lblMessage.Text =
                    Server.HtmlEncode(ex.Message);

                gvAuditLogs.DataSource = null;
                gvAuditLogs.DataBind();

                btnPrevious.Enabled = false;
                btnNext.Enabled = false;
            }
            catch (Exception ex)
            {
                lblMessage.Text =
                    "Unable to load audit logs: " +
                    Server.HtmlEncode(ex.Message);

                gvAuditLogs.DataSource = null;
                gvAuditLogs.DataBind();

                btnPrevious.Enabled = false;
                btnNext.Enabled = false;
            }
        }

        protected void btnApply_Click(
            object sender,
            EventArgs e)
        {
            if (!ValidateDates())
                return;

            SaveAppliedFilters();
            CurrentPage = 1;

            LoadAuditLogs();
        }

        protected void btnClear_Click(
            object sender,
            EventArgs e)
        {
            txtSearch.Text = "";
            ddlCategory.SelectedIndex = 0;
            ddlAction.SelectedIndex = 0;
            ddlSort.SelectedIndex = 0;
            txtDateFrom.Text = "";
            txtDateTo.Text = "";
            ddlPageSize.SelectedValue = "10";

            SaveAppliedFilters();
            CurrentPage = 1;

            LoadAuditLogs();
        }

        protected void btnPrevious_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
            }

            LoadAuditLogs();
        }

        protected void btnNext_Click(
            object sender,
            EventArgs e)
        {
            CurrentPage++;

            LoadAuditLogs();
        }
    }
}
