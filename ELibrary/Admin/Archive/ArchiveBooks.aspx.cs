using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ELibrary.Admin.Archive
{
    public partial class ArchiveBooks : System.Web.UI.Page
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
        // APPLIED SEARCH / FILTER STATE
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

        private string AppliedReason
        {
            get
            {
                return (string)(
                    ViewState["AppliedReason"] ?? "");
            }
            set
            {
                ViewState["AppliedReason"] = value;
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
                LoadArchiveReasons();
                LoadArchivedBooks();
            }
        }

        // ==========================================
        // LOAD ARCHIVE REASONS
        // ==========================================

        private void LoadArchiveReasons()
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        @"SELECT DISTINCT Reason
                          FROM dbo.EArchiveBook
                          WHERE Reason IS NOT NULL
                            AND LTRIM(RTRIM(Reason)) <> ''
                          ORDER BY Reason;",
                        con))
                {
                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string reason =
                                Convert.ToString(reader["Reason"]);

                            ddlReason.Items.Add(
                                new ListItem(reason, reason));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to load archive reasons: " +
                    ex.Message,
                    false);
            }
        }

        // ==========================================
        // LOAD ARCHIVED BOOKS
        // ==========================================

        private void LoadArchivedBooks()
        {
            try
            {
                DataSet ds = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EArchiveBook_WebAdminSearch",
                        con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar,
                        255).Value =
                        DbValue(AppliedSearch);

                    cmd.Parameters.Add(
                        "@Reason",
                        SqlDbType.VarChar,
                        255).Value =
                        DbValue(AppliedReason);

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
                        "Archive search returned incomplete data.");
                }

                int filteredCount = 0;

                if (ds.Tables[0].Rows.Count > 0)
                {
                    filteredCount = Convert.ToInt32(
                        ds.Tables[0].Rows[0]["FilteredCount"]);
                }

                TotalPages = Math.Max(
                    1,
                    (int)Math.Ceiling(
                        filteredCount / (double)PageSize));

                if (CurrentPage > TotalPages)
                {
                    CurrentPage = TotalPages;
                    LoadArchivedBooks();
                    return;
                }

                gvArchivedBooks.DataSource = ds.Tables[1];
                gvArchivedBooks.DataBind();

                int first = filteredCount == 0
                    ? 0
                    : (CurrentPage - 1) * PageSize + 1;

                int last = Math.Min(
                    CurrentPage * PageSize,
                    filteredCount);

                lblResultCount.Text = string.Format(
                    "Showing {0}–{1} of {2} archived books",
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
                    "Unable to load archived books: " +
                    ex.Message,
                    false);
            }
        }

        // ==========================================
        // APPLY FILTERS
        // ==========================================

        protected void btnApply_Click(
            object sender,
            EventArgs e)
        {
            AppliedSearch =
                (txtSearch.Text ?? "").Trim();

            AppliedReason =
                ddlReason.SelectedValue;

            AppliedSort =
                ddlSort.SelectedValue;

            CurrentPage = 1;

            LoadArchivedBooks();
        }

        // ==========================================
        // CLEAR FILTERS
        // ==========================================

        protected void btnClearFilters_Click(
            object sender,
            EventArgs e)
        {
            txtSearch.Text = "";
            ddlReason.SelectedValue = "";
            ddlSort.SelectedValue = "Default";

            AppliedSearch = "";
            AppliedReason = "";
            AppliedSort = "Default";

            CurrentPage = 1;

            LoadArchivedBooks();
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
                LoadArchivedBooks();
            }
        }

        protected void btnNext_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage < TotalPages)
            {
                CurrentPage++;
                LoadArchivedBooks();
            }
        }

        // ==========================================
        // REFRESH
        // ==========================================

        protected void btnRefresh_Click(
            object sender,
            EventArgs e)
        {
            LoadArchivedBooks();
        }

        // ==========================================
        // RESTORE COMMAND
        // ==========================================

        protected void gvArchivedBooks_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (e.CommandName != "RestoreBook")
                return;

            int archiveID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out archiveID))
            {
                ShowMessage(
                    "Invalid archive ID.",
                    false);
                return;
            }

            RestoreBook(archiveID);
        }

        // ==========================================
        // RESTORE BOOK
        // ==========================================

        private void RestoreBook(int archiveID)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EArchiveBook_WebRestore",
                        con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@ArchiveID",
                        SqlDbType.Int).Value =
                        archiveID;

                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value =
                        Convert.ToInt32(Session["UserID"]);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                // Reload the archive list after restoration.
                // The procedure handles the actual restore.
                LoadArchivedBooks();

                ShowMessage(
                    "Book restored successfully.",
                    true);
            }
            catch (SqlException ex)
            {
                ShowMessage(
                    ex.Message,
                    false);
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to restore book: " +
                    ex.Message,
                    false);
            }
        }

        // ==========================================
        // HELPERS
        // ==========================================

        private object DbValue(string value)
        {
            return string.IsNullOrWhiteSpace(value)
                ? (object)DBNull.Value
                : value.Trim();
        }

        private void ShowMessage(
            string message,
            bool success)
        {
            lblMessage.CssClass =
                success
                    ? "text-success"
                    : "text-danger";

            lblMessage.Text =
                Server.HtmlEncode(message);
        }
    }
}