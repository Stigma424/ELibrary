
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ELibrary.Admin.Books
{
    public partial class ManageGenres : System.Web.UI.Page
    {
        private const int PageSize = 10;

        private readonly string connectionString =
            ConfigurationManager
                .ConnectionStrings["ElibraryConnection"]
                .ConnectionString;

        // ==========================================
        // APPLIED FILTERS
        // ==========================================

        private string AppliedSearch
        {
            get
            {
                return (string)(ViewState["AppliedSearch"] ?? "");
            }
            set
            {
                ViewState["AppliedSearch"] = value;
            }
        }

        private string AppliedSort
        {
            get
            {
                return (string)(ViewState["AppliedSort"] ?? "Default");
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
                return (int)(ViewState["CurrentPage"] ?? 1);
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
                return (int)(ViewState["TotalPages"] ?? 1);
            }
            set
            {
                ViewState["TotalPages"] = value;
            }
        }

        // ==========================================
        // PAGE LOAD
        // ==========================================

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadGenres();
            }
        }

        // ==========================================
        // LOAD GENRES
        // ==========================================

        private void LoadGenres()
        {
            DataSet ds = new DataSet();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand("EGenre_WebAdminSearch", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(
                    "@Search", SqlDbType.VarChar, 255).Value =
                    string.IsNullOrWhiteSpace(AppliedSearch)
                        ? (object)DBNull.Value
                        : AppliedSearch;

                cmd.Parameters.Add(
                    "@Sort", SqlDbType.VarChar, 20).Value =
                    AppliedSort;

                cmd.Parameters.Add(
                    "@PageNumber", SqlDbType.Int).Value =
                    CurrentPage;

                cmd.Parameters.Add(
                    "@PageSize", SqlDbType.Int).Value =
                    PageSize;

                using (SqlDataAdapter adapter =
                    new SqlDataAdapter(cmd))
                {
                    adapter.Fill(ds);
                }
            }

            if (ds.Tables.Count < 2)
            {
                throw new InvalidOperationException(
                    "Genre search returned incomplete data.");
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
                LoadGenres();
                return;
            }

            gvGenres.DataSource = ds.Tables[1];
            gvGenres.DataBind();

            int first = filteredCount == 0
                ? 0
                : ((CurrentPage - 1) * PageSize) + 1;

            int last = Math.Min(
                CurrentPage * PageSize,
                filteredCount);

            lblResultCount.Text = string.Format(
                "Showing {0}–{1} of {2} genres",
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

        // ==========================================
        // SEARCH / FILTER
        // ==========================================

        protected void btnApply_Click(
            object sender,
            EventArgs e)
        {
            AppliedSearch = (txtSearch.Text ?? "").Trim();
            AppliedSort = ddlSort.SelectedValue;

            CurrentPage = 1;
            RefreshGenres();
        }

        protected void btnClearFilters_Click(
            object sender,
            EventArgs e)
        {
            txtSearch.Text = "";
            ddlSort.SelectedValue = "Default";

            AppliedSearch = "";
            AppliedSort = "Default";

            CurrentPage = 1;
            RefreshGenres();
        }

        private void RefreshGenres()
        {
            try
            {
                LoadGenres();
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to load genres.",
                    false);
            }
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
                RefreshGenres();
            }
        }

        protected void btnNext_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage < TotalPages)
            {
                CurrentPage++;
                RefreshGenres();
            }
        }

        // ==========================================
        // SAVE GENRE
        // ==========================================

        protected void btnSave_Click(
            object sender,
            EventArgs e)
        {
            string genreName =
                txtGenreName.Text.Trim();

            string genreDesc =
                txtGenreDesc.Text.Trim();

            int genreID;

            if (!int.TryParse(hfGenreID.Value, out genreID)
                || genreID < 0)
            {
                ShowMessage("Invalid genre ID.", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(genreName))
            {
                ShowMessage("Genre name is required.", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(genreDesc))
            {
                ShowMessage(
                    "Genre description is required.", false);
                return;
            }

            if (genreName.Length > 100 ||
                genreDesc.Length > 255)
            {
                ShowMessage(
                    "Genre name or description is too long.",
                    false);
                return;
            }

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EGenre_WebValidate", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@GenreID",
                        SqlDbType.Int).Value =
                        genreID == 0
                            ? (object)DBNull.Value
                            : genreID;

                    cmd.Parameters.Add(
                        "@GenreName",
                        SqlDbType.VarChar,
                        100).Value = genreName;

                    con.Open();

                    object result = cmd.ExecuteScalar();

                    if (result != null &&
                        result != DBNull.Value &&
                        Convert.ToInt32(result) == 0)
                    {
                        ShowMessage(
                            "This genre already exists.", false);
                        return;
                    }
                }

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EGenre_WebSave", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@GenreID",
                        SqlDbType.Int).Value =
                        genreID == 0
                            ? (object)DBNull.Value
                            : genreID;

                    cmd.Parameters.Add(
                        "@GenreName",
                        SqlDbType.VarChar,
                        100).Value = genreName;

                    cmd.Parameters.Add(
                        "@GenreDesc",
                        SqlDbType.VarChar,
                        255).Value = genreDesc;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                ClearForm();
                RefreshGenres();

                ShowMessage(
                    genreID == 0
                        ? "Genre added successfully."
                        : "Genre updated successfully.",
                    true);
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to save genre: " + ex.Message,
                    false);
            }
        }

        // ==========================================
        // EDIT / DELETE COMMANDS
        // ==========================================

        protected void gvGenres_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (e.CommandName != "EditGenre" &&
                e.CommandName != "DeleteGenre")
            {
                return;
            }

            int genreID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out genreID))
            {
                ShowMessage("Invalid genre ID.", false);
                return;
            }

            if (e.CommandName == "EditGenre")
            {
                LoadGenre(genreID);
            }
            else
            {
                DeleteGenre(genreID);
            }
        }

        // ==========================================
        // LOAD ONE GENRE FOR EDITING
        // ==========================================

        private void LoadGenre(int genreID)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand("EGenre_WebOne", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@GenreID",
                        SqlDbType.Int).Value = genreID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            ShowMessage(
                                "Genre not found.", false);
                            return;
                        }

                        hfGenreID.Value =
                            Convert.ToString(reader["GenreID"]);

                        txtGenreName.Text =
                            Convert.ToString(reader["GenreName"]);

                        txtGenreDesc.Text =
                            Convert.ToString(reader["GenreDesc"]);

                        btnSave.Text = "Update Genre";
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to load genre: " + ex.Message,
                    false);
            }
        }

        // ==========================================
        // DELETE GENRE
        // ==========================================

        private void DeleteGenre(int genreID)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand("EGenre_WebDelete", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@GenreID",
                        SqlDbType.Int).Value = genreID;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                ClearForm();
                RefreshGenres();

                ShowMessage(
                    "Genre deleted successfully.", true);
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to delete genre: " + ex.Message,
                    false);
            }
        }

        // ==========================================
        // CLEAR EDITOR
        // ==========================================

        protected void btnCancel_Click(
            object sender,
            EventArgs e)
        {
            ClearForm();
            lblMessage.Text = "";
        }

        private void ClearForm()
        {
            hfGenreID.Value = "0";
            txtGenreName.Text = "";
            txtGenreDesc.Text = "";
            btnSave.Text = "Save Genre";
        }

        // ==========================================
        // MESSAGE
        // ==========================================

        private void ShowMessage(
            string message,
            bool success)
        {
            lblMessage.CssClass =
                success
                    ? "el-ac-message success"
                    : "el-ac-message error";

            lblMessage.Text =
                Server.HtmlEncode(message);
        }
    }
}
