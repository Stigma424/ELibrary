
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary.Admin.Books
{
    public partial class ManageBooks : Page
    {
        private readonly string connectionString =
            ConfigurationManager
                .ConnectionStrings["ElibraryConnection"]
                .ConnectionString;

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
                LoadSearchGenres();
                ClearForm();
                LoadBooks();
            }
        }

        private void LoadGenres()
        {
            ddlGenre.Items.Clear();
            ddlGenre.Items.Add(
                new ListItem("-- Select Genre --", ""));

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand("EGenre_Web", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ddlGenre.Items.Add(
                            new ListItem(
                                reader["GenreName"].ToString(),
                                reader["GenreID"].ToString()));
                    }
                }
            }
        }

        private void LoadSearchGenres()
        {
            ddlSearchGenre.Items.Clear();
            ddlSearchGenre.Items.Add(
                new ListItem("-- All Genres --", ""));

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand("EGenre_Web", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ddlSearchGenre.Items.Add(
                            new ListItem(
                                reader["GenreName"].ToString(),
                                reader["GenreID"].ToString()));
                    }
                }
            }
        }

        private const int BookPageSize = 10;

        private string AppliedSearch
        {
            get { return (string)(ViewState["AppliedSearch"] ?? ""); }
            set { ViewState["AppliedSearch"] = value; }
        }

        private int? AppliedGenreID
        {
            get
            {
                object value = ViewState["AppliedGenreID"];
                return value == null ? (int?)null : (int)value;
            }
            set { ViewState["AppliedGenreID"] = value; }
        }

        private string AppliedAvailability
        {
            get { return (string)(ViewState["AppliedAvailability"] ?? "All"); }
            set { ViewState["AppliedAvailability"] = value; }
        }

        private string AppliedSort
        {
            get { return (string)(ViewState["AppliedSort"] ?? "Default"); }
            set { ViewState["AppliedSort"] = value; }
        }

        private int CurrentBookPage
        {
            get { return (int)(ViewState["CurrentBookPage"] ?? 1); }
            set { ViewState["CurrentBookPage"] = value; }
        }

        private int TotalBookPages
        {
            get { return (int)(ViewState["TotalBookPages"] ?? 1); }
            set { ViewState["TotalBookPages"] = value; }
        }

        private void LoadBooks()
        {
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("EBook_WebAdminSearch", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Search", SqlDbType.VarChar, 255).Value =
                    string.IsNullOrWhiteSpace(AppliedSearch)
                    ? (object)DBNull.Value : AppliedSearch;
                cmd.Parameters.Add("@GenreID", SqlDbType.Int).Value =
                    AppliedGenreID.HasValue
                    ? (object)AppliedGenreID.Value : DBNull.Value;
                cmd.Parameters.Add("@Availability", SqlDbType.VarChar, 20).Value =
                    AppliedAvailability;
                cmd.Parameters.Add("@Sort", SqlDbType.VarChar, 20).Value =
                    AppliedSort;
                cmd.Parameters.Add("@PageNumber", SqlDbType.Int).Value =
                    CurrentBookPage;
                cmd.Parameters.Add("@PageSize", SqlDbType.Int).Value =
                    BookPageSize;
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    adapter.Fill(ds);
            }

            if (ds.Tables.Count < 2)
                throw new InvalidOperationException("Book search returned incomplete data.");

            int filteredCount = ds.Tables[0].Rows.Count > 0
                ? Convert.ToInt32(ds.Tables[0].Rows[0]["FilteredCount"]) : 0;
            TotalBookPages = Math.Max(1,
                (int)Math.Ceiling(filteredCount / (double)BookPageSize));

            if (CurrentBookPage > TotalBookPages)
            {
                CurrentBookPage = TotalBookPages;
                LoadBooks();
                return;
            }

            gvBooks.DataSource = ds.Tables[1];
            gvBooks.DataBind();

            int first = filteredCount == 0 ? 0 :
                (CurrentBookPage - 1) * BookPageSize + 1;
            int last = Math.Min(CurrentBookPage * BookPageSize, filteredCount);
            lblBookResultCount.Text = string.Format(
                "Showing {0}–{1} of {2} books", first, last, filteredCount);
            lblPageInfo.Text = string.Format(
                "Page {0} of {1}", CurrentBookPage, TotalBookPages);
            btnPrevious.Visible = TotalBookPages > 1;
            btnNext.Visible = TotalBookPages > 1;
            btnPrevious.Enabled = CurrentBookPage > 1;
            btnNext.Enabled = CurrentBookPage < TotalBookPages;
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            AppliedSearch = (txtSearch.Text ?? "").Trim();
            int genreID;
            AppliedGenreID = int.TryParse(ddlSearchGenre.SelectedValue, out genreID)
                ? (int?)genreID : null;
            AppliedAvailability = ddlAvailability.SelectedValue;
            AppliedSort = ddlSort.SelectedValue;
            CurrentBookPage = 1;
            RefreshBooks();
        }

        protected void btnResetFilters_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlSearchGenre.SelectedIndex = 0;
            ddlAvailability.SelectedValue = "All";
            ddlSort.SelectedValue = "Default";
            AppliedSearch = "";
            AppliedGenreID = null;
            AppliedAvailability = "All";
            AppliedSort = "Default";
            CurrentBookPage = 1;
            RefreshBooks();
        }

        protected void btnPrevious_Click(object sender, EventArgs e)
        {
            if (CurrentBookPage > 1)
            {
                CurrentBookPage--;
                RefreshBooks();
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            if (CurrentBookPage < TotalBookPages)
            {
                CurrentBookPage++;
                RefreshBooks();
            }
        }

        private void RefreshBooks()
        {
            try { LoadBooks(); }
            catch (Exception ex)
            {
                ShowMessage("Unable to load books: " + ex.Message, false);
            }
        }

        protected string GetCoverUrl(object pathValue)
        {
            string path = Convert.ToString(pathValue);

            if (!string.IsNullOrWhiteSpace(path) &&
                path.StartsWith(
                    "~/Uploads/BookCovers/",
                    StringComparison.Ordinal) &&
                path.IndexOf("..", StringComparison.Ordinal) < 0 &&
                path.IndexOf('\\') < 0)
            {
                return ResolveUrl(path);
            }

            return ResolveUrl(
                "~/Content/Images/default-book.svg");
        }

        private void ShowMessage(string message, bool success)
        {
            lblMessage.Text = Server.HtmlEncode(message);
            lblMessage.CssClass =
                success
                    ? "book-message book-message-success"
                    : "book-message book-message-error";
        }

        protected void btnSave_Click(
            object sender, EventArgs e)
        {
            lblMessage.Text = "";

            string title = txtTitle.Text.Trim();
            string isbn = txtISBN.Text.Trim();
            string author = txtAuthor.Text.Trim();
            string bookDesc = txtBookDesc.Text.Trim();

            int bookID;
            int genreID;
            int totalCopies;
            decimal borrowingFee;

            if (!int.TryParse(hfBookID.Value, out bookID) ||
                bookID < 0)
            {
                ShowMessage("Invalid book ID.", false);
                return;
            }

            if (!int.TryParse(
                ddlGenre.SelectedValue, out genreID))
            {
                ShowMessage("Please select a genre.", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(title))
            {
                ShowMessage("Title is required.", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(isbn))
            {
                ShowMessage("ISBN is required.", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(author))
            {
                ShowMessage("Author is required.", false);
                return;
            }

            if (!int.TryParse(
                txtTotalCopies.Text, out totalCopies) ||
                totalCopies < 0)
            {
                ShowMessage(
                    "Enter a valid number of copies.", false);
                return;
            }

            if (!decimal.TryParse(
                txtBorrowingFee.Text, out borrowingFee) ||
                borrowingFee < 0)
            {
                ShowMessage(
                    "Enter a valid borrowing fee.", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(bookDesc))
            {
                ShowMessage(
                    "Book description is required.", false);
                return;
            }

            string newImagePath = null;

            try
            {
                // Validate duplicate ISBN before uploading.
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand("EBook_WebValidate", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@BookID", SqlDbType.Int).Value =
                        bookID == 0
                            ? (object)DBNull.Value
                            : bookID;

                    cmd.Parameters.Add(
                        "@ISBN", SqlDbType.VarChar, 20).Value =
                        isbn;

                    con.Open();

                    object result = cmd.ExecuteScalar();

                    if (result != null &&
                        Convert.ToInt32(result) == 0)
                    {
                        ShowMessage(
                            "This ISBN already exists.", false);
                        return;
                    }
                }

                // Validate and save a new image if provided.
                if (fuBookCover.HasFile)
                {
                    newImagePath =
                        ImageUploadHelper.SaveImage(
                            fuBookCover,
                            "~/Uploads/BookCovers");
                }

                // Save book information and image path.
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand("EBook_WebSave", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@BookID", SqlDbType.Int).Value =
                        bookID == 0
                            ? (object)DBNull.Value
                            : bookID;

                    cmd.Parameters.Add(
                        "@Title", SqlDbType.VarChar, 255).Value =
                        title;

                    cmd.Parameters.Add(
                        "@ISBN", SqlDbType.VarChar, 20).Value =
                        isbn;

                    cmd.Parameters.Add(
                        "@GenreID", SqlDbType.Int).Value =
                        genreID;

                    cmd.Parameters.Add(
                        "@TotalCopies", SqlDbType.Int).Value =
                        totalCopies;

                    cmd.Parameters.Add(
                        "@BookDesc", SqlDbType.VarChar, 255).Value =
                        bookDesc;

                    cmd.Parameters.Add(
                        "@Author", SqlDbType.VarChar, 150).Value =
                        author;

                    SqlParameter feeParameter =
                        cmd.Parameters.Add(
                            "@BorrowingFee", SqlDbType.Decimal);

                    feeParameter.Precision = 10;
                    feeParameter.Scale = 2;
                    feeParameter.Value = borrowingFee;

                    cmd.Parameters.Add(
                        "@CoverImagePath",
                        SqlDbType.NVarChar, 500).Value =
                        string.IsNullOrEmpty(newImagePath)
                            ? (object)DBNull.Value
                            : newImagePath;

                    con.Open();

                    object savedID = cmd.ExecuteScalar();

                    if (savedID == null ||
                        savedID == DBNull.Value)
                    {
                        throw new InvalidOperationException(
                            "Book could not be saved.");
                    }
                }

                ClearForm();
                LoadBooks();

                ShowMessage(
                    bookID == 0
                        ? "Book added successfully."
                        : "Book updated successfully.",
                    true);
            }
            catch (Exception ex)
            {
                // Remove a newly uploaded file if the
                // database operation did not succeed.
                // A failed cleanup must not hide the main error.
                if (!string.IsNullOrEmpty(newImagePath))
                {
                    try
                    {
                        // Do not delete the file if SQL saved
                        // successfully but a later UI refresh failed.
                        bool isReferenced;

                        using (SqlConnection con =
                            new SqlConnection(connectionString))
                        using (SqlCommand cmd =
                            new SqlCommand(
                                "SELECT COUNT(*) FROM dbo.EBook " +
                                "WHERE CoverImagePath = @Path", con))
                        {
                            cmd.Parameters.Add(
                                "@Path",
                                SqlDbType.NVarChar, 500).Value =
                                newImagePath;

                            con.Open();
                            isReferenced =
                                Convert.ToInt32(
                                    cmd.ExecuteScalar()) > 0;
                        }

                        if (!isReferenced)
                        {
                            ImageUploadHelper.DeleteImage(
                                newImagePath);
                        }
                    }
                    catch
                    {
                        // Leave the file for later cleanup.
                    }
                }

                ShowMessage(
                    "Unable to save book: " + ex.Message,
                    false);
            }
        }

        protected void gvBooks_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            int bookID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out bookID))
            {
                return;
            }

            if (e.CommandName == "EditBook")
            {
                try
                {
                    LoadBook(bookID);
                }
                catch (Exception ex)
                {
                    ShowMessage(
                        "Unable to load book: " + ex.Message,
                        false);
                }
            }
            else if (e.CommandName == "ArchiveBook")
            {
                ArchiveBook(bookID);
            }
        }

        private void LoadBook(int bookID)
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand("EBook_WebOne", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(
                    "@BookID", SqlDbType.Int).Value = bookID;

                con.Open();

                using (SqlDataReader reader =
                    cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        hfBookID.Value =
                            reader["BookID"].ToString();

                        txtTitle.Text =
                            reader["Title"].ToString();

                        txtISBN.Text =
                            reader["ISBN"].ToString();

                        ddlGenre.SelectedValue =
                            reader["GenreID"].ToString();

                        txtAuthor.Text =
                            reader["Author"].ToString();

                        txtTotalCopies.Text =
                            reader["TotalCopies"].ToString();

                        txtBorrowingFee.Text =
                            reader["BorrowingFee"].ToString();

                        txtBookDesc.Text =
                            reader["BookDesc"].ToString();

                        imgCoverPreview.ImageUrl =
                            GetCoverUrl(
                                reader["CoverImagePath"]);

                        btnSave.Text = "Update Book";
                    }
                    else
                    {
                        ShowMessage(
                            "Book not found.", false);
                    }
                }
            }
        }

        private void ArchiveBook(int bookID)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EArchiveBook_WebPost", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@BookID", SqlDbType.Int).Value =
                        bookID;

                    cmd.Parameters.Add(
                        "@UserID", SqlDbType.Int).Value =
                        Convert.ToInt32(Session["UserID"]);

                    cmd.Parameters.Add(
                        "@Reason", SqlDbType.VarChar, 255).Value =
                        "Archived by librarian";

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadBooks();
                ShowMessage(
                    "Book archived successfully.", true);
            }
            catch (SqlException ex)
            {
                ShowMessage(ex.Message, false);
            }
        }

        protected void btnClear_Click(
            object sender, EventArgs e)
        {
            ClearForm();
            lblMessage.Text = "";
        }

        private void ClearForm()
        {
            hfBookID.Value = "0";

            txtTitle.Text = "";
            txtISBN.Text = "";
            txtAuthor.Text = "";
            txtTotalCopies.Text = "";
            txtBorrowingFee.Text = "";
            txtBookDesc.Text = "";

            if (ddlGenre.Items.Count > 0)
            {
                ddlGenre.SelectedIndex = 0;
            }

            imgCoverPreview.ImageUrl =
                ResolveUrl(
                    "~/Content/Images/default-book.svg");

            btnSave.Text = "Save Book";
        }
    }
}
