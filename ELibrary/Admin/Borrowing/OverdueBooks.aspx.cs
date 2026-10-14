using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ELibrary.Admin.Borrowing
{
    public partial class OverdueBooks : System.Web.UI.Page
    {
        private const int PageSize = 10;

        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["ElibraryConnection"]
                    .ConnectionString;
            }
        }

        // ==========================================
        // APPLIED FILTERS
        // ==========================================

        private string AppliedSearch
        {
            get
            {
                return (string)(
                    ViewState["AppliedSearch"] ?? "");
            }
            set
            {
                ViewState["AppliedSearch"] = value;
            }
        }

        private string AppliedDuration
        {
            get
            {
                return (string)(
                    ViewState["AppliedDuration"] ?? "All");
            }
            set
            {
                ViewState["AppliedDuration"] = value;
            }
        }

        private string AppliedSort
        {
            get
            {
                return (string)(
                    ViewState["AppliedSort"] ?? "Default");
            }
            set
            {
                ViewState["AppliedSort"] = value;
            }
        }

        private int CurrentPage
        {
            get
            {
                return (int)(
                    ViewState["CurrentPage"] ?? 1);
            }
            set
            {
                ViewState["CurrentPage"] = value;
            }
        }

        private int TotalPages
        {
            get
            {
                return (int)(
                    ViewState["TotalPages"] ?? 1);
            }
            set
            {
                ViewState["TotalPages"] = value;
            }
        }

        // ==========================================
        // PAGE LOAD
        // ==========================================

        protected void Page_Load(
            object sender,
            EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                ProcessOverdue();
                LoadOverdueBooks();
            }
        }

        // ==========================================
        // PROCESS OVERDUE
        // ==========================================

        private void ProcessOverdue()
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebProcessOverdue",
                        con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to update overdue status: " +
                    ex.Message);
            }
        }

        // ==========================================
        // LOAD OVERDUE BOOKS
        // ==========================================

        private void LoadOverdueBooks()
        {
            try
            {
                DataSet ds = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebAdminOverdueSearch",
                        con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar,
                        255).Value =
                        string.IsNullOrWhiteSpace(AppliedSearch)
                            ? (object)DBNull.Value
                            : AppliedSearch;

                    cmd.Parameters.Add(
                        "@Duration",
                        SqlDbType.VarChar,
                        20).Value =
                        AppliedDuration;

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
                        PageSize;

                    using (SqlDataAdapter da =
                        new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count < 2)
                {
                    throw new InvalidOperationException(
                        "Overdue search returned incomplete data.");
                }

                int filteredCount = 0;

                if (ds.Tables[0].Rows.Count > 0)
                {
                    filteredCount =
                        Convert.ToInt32(
                            ds.Tables[0].Rows[0]["FilteredCount"]);
                }

                TotalPages = Math.Max(
                    1,
                    (int)Math.Ceiling(
                        filteredCount / (double)PageSize));

                if (CurrentPage > TotalPages)
                {
                    CurrentPage = TotalPages;
                    LoadOverdueBooks();
                    return;
                }

                gvOverdue.DataSource = ds.Tables[1];
                gvOverdue.DataBind();

                int first = filteredCount == 0
                    ? 0
                    : (CurrentPage - 1) * PageSize + 1;

                int last = Math.Min(
                    CurrentPage * PageSize,
                    filteredCount);

                lblResultCount.Text = string.Format(
                    "Showing {0}–{1} of {2} overdue records",
                    first,
                    last,
                    filteredCount);

                lblPageInfo.Text = string.Format(
                    "Page {0} of {1}",
                    CurrentPage,
                    TotalPages);

                btnPrevious.Visible = TotalPages > 1;
                btnNext.Visible = TotalPages > 1;

                btnPrevious.Enabled = CurrentPage > 1;
                btnNext.Enabled = CurrentPage < TotalPages;
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to load overdue books: " +
                    ex.Message);
            }
        }

        // ==========================================
        // APPLY SEARCH AND FILTER
        // ==========================================

        protected void btnApply_Click(
            object sender,
            EventArgs e)
        {
            AppliedSearch =
                (txtSearch.Text ?? "").Trim();

            AppliedDuration =
                ddlDuration.SelectedValue;

            AppliedSort =
                ddlSort.SelectedValue;

            CurrentPage = 1;

            LoadOverdueBooks();
        }

        // ==========================================
        // CLEAR FILTERS
        // ==========================================

        protected void btnClearFilters_Click(
            object sender,
            EventArgs e)
        {
            txtSearch.Text = "";
            ddlDuration.SelectedValue = "All";
            ddlSort.SelectedValue = "Default";

            AppliedSearch = "";
            AppliedDuration = "All";
            AppliedSort = "Default";

            CurrentPage = 1;

            LoadOverdueBooks();
        }

        // ==========================================
        // PAGINATION
        // ==========================================

        protected void btnPrevious_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadOverdueBooks();
            }
        }

        protected void btnNext_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage < TotalPages)
            {
                CurrentPage++;
                LoadOverdueBooks();
            }
        }

        // ==========================================
        // REFRESH
        // ==========================================

        protected void btnRefresh_Click(
            object sender,
            EventArgs e)
        {
            ProcessOverdue();
            LoadOverdueBooks();
        }

        // ==========================================
        // MESSAGE
        // ==========================================

        private void ShowMessage(string message)
        {
            lblMessage.CssClass = "br-message";
            lblMessage.Text =
                Server.HtmlEncode(message);
        }
    }
}