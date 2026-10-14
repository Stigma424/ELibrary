
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

        private const int BookPageSize = 10;
        private const int LossHistoryPageSize = 10;

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
                ClearInventoryLossForm();
                LoadBooks();
                LoadInventoryLossHistory();
            }
        }

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
            get
            {
                return (string)(ViewState["AppliedAvailability"] ?? "All");
            }
            set { ViewState["AppliedAvailability"] = value; }
        }

        private string AppliedSort
        {
            get
            {
                return (string)(ViewState["AppliedSort"] ?? "Default");
            }
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

        private string AppliedLossHistorySearch
        {
            get
            {
                return (string)(
                    ViewState["AppliedLossHistorySearch"] ?? "");
            }
            set { ViewState["AppliedLossHistorySearch"] = value; }
        }

        private int CurrentLossHistoryPage
        {
            get
            {
                return (int)(ViewState["CurrentLossHistoryPage"] ?? 1);
            }
            set { ViewState["CurrentLossHistoryPage"] = value; }
        }

        private int TotalLossHistoryPages
        {
            get
            {
                return (int)(ViewState["TotalLossHistoryPages"] ?? 1);
            }
            set { ViewState["TotalLossHistoryPages"] = value; }
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

        private void LoadBooks()
        {
            DataSet ds = new DataSet();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand("EBook_WebAdminSearch", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(
                    "@Search", SqlDbType.VarChar, 255).Value =
                    string.IsNullOrWhiteSpace(AppliedSearch)
                        ? (object)DBNull.Value
                        : AppliedSearch;

                cmd.Parameters.Add(
                    "@GenreID", SqlDbType.Int).Value =
                    AppliedGenreID.HasValue
                        ? (object)AppliedGenreID.Value
                        : DBNull.Value;

                cmd.Parameters.Add(
                    "@Availability", SqlDbType.VarChar, 20).Value =
                    AppliedAvailability;

                cmd.Parameters.Add(
                    "@Sort", SqlDbType.VarChar, 20).Value =
                    AppliedSort;

                cmd.Parameters.Add(
                    "@PageNumber", SqlDbType.Int).Value =
                    CurrentBookPage;

                cmd.Parameters.Add(
                    "@PageSize", SqlDbType.Int).Value =
                    BookPageSize;

                using (SqlDataAdapter adapter =
                    new SqlDataAdapter(cmd))
                {
                    adapter.Fill(ds);
                }
            }

            if (ds.Tables.Count < 2)
            {
                throw new InvalidOperationException(
                    "Book search returned incomplete data.");
            }

            int filteredCount =
                ds.Tables[0].Rows.Count > 0
                    ? Convert.ToInt32(
                        ds.Tables[0].Rows[0]["FilteredCount"])
                    : 0;

            TotalBookPages = Math.Max(
                1,
                (int)Math.Ceiling(
                    filteredCount / (double)BookPageSize));

            if (CurrentBookPage > TotalBookPages)
            {
                CurrentBookPage = TotalBookPages;
                LoadBooks();
                return;
            }

            gvBooks.DataSource = ds.Tables[1];
            gvBooks.DataBind();

            int first = filteredCount == 0
                ? 0
                : (CurrentBookPage - 1) * BookPageSize + 1;

            int last = Math.Min(
                CurrentBookPage * BookPageSize,
                filteredCount);

            lblBookResultCount.Text = string.Format(
                "Showing {0}–{1} of {2} books",
                first,
                last,
                filteredCount);

            lblPageInfo.Text = string.Format(
                "Page {0} of {1}",
                CurrentBookPage,
                TotalBookPages);

            btnPrevious.Visible = TotalBookPages > 1;
            btnNext.Visible = TotalBookPages > 1;
            btnPrevious.Enabled = CurrentBookPage > 1;
            btnNext.Enabled = CurrentBookPage < TotalBookPages;
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            AppliedSearch = (txtSearch.Text ?? "").Trim();

            int genreID;

            AppliedGenreID =
                int.TryParse(
                    ddlSearchGenre.SelectedValue,
                    out genreID)
                    ? (int?)genreID
                    : null;

            AppliedAvailability =
                ddlAvailability.SelectedValue;

            AppliedSort = ddlSort.SelectedValue;

            CurrentBookPage = 1;
            RefreshBooks();
        }

        protected void btnResetFilters_Click(
            object sender,
            EventArgs e)
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

        protected void btnPrevious_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentBookPage > 1)
            {
                CurrentBookPage--;
                RefreshBooks();
            }
        }

        protected void btnNext_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentBookPage < TotalBookPages)
            {
                CurrentBookPage++;
                RefreshBooks();
            }
        }

        private void RefreshBooks()
        {
            try
            {
                LoadBooks();
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to load books: " + ex.Message,
                    false);
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

        private void ShowMessage(
            string message,
            bool success)
        {
            lblMessage.Text = Server.HtmlEncode(message);

            lblMessage.CssClass =
                success
                    ? "book-message book-message-success"
                    : "book-message book-message-error";
        }

        protected void btnSave_Click(
            object sender,
            EventArgs e)
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

            if (!int.TryParse(
                hfBookID.Value, out bookID) ||
                bookID < 0)
            {
                ShowMessage("Invalid book ID.", false);
                return;
            }

            if (!int.TryParse(
                ddlGenre.SelectedValue,
                out genreID))
            {
                ShowMessage(
                    "Please select a genre.", false);
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
                txtTotalCopies.Text,
                out totalCopies) ||
                totalCopies < 0)
            {
                ShowMessage(
                    "Enter a valid number of copies.",
                    false);
                return;
            }

            if (!decimal.TryParse(
                txtBorrowingFee.Text,
                out borrowingFee) ||
                borrowingFee < 0)
            {
                ShowMessage(
                    "Enter a valid borrowing fee.",
                    false);
                return;
            }

            if (string.IsNullOrWhiteSpace(bookDesc))
            {
                ShowMessage(
                    "Book description is required.",
                    false);
                return;
            }

            string newImagePath = null;

            try
            {
                // Validate duplicate ISBN.
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
                            "This ISBN already exists.",
                            false);
                        return;
                    }
                }

                // Validate image upload.
                if (fuBookCover.HasFile)
                {
                    newImagePath =
                        ImageUploadHelper.SaveImage(
                            fuBookCover,
                            "~/Uploads/BookCovers");
                }

                // Save through the hardened SQL procedure.
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
                // Preserve the original uploaded-image
                // cleanup behavior.
                if (!string.IsNullOrEmpty(newImagePath))
                {
                    try
                    {
                        bool isReferenced;

                        using (SqlConnection con =
                            new SqlConnection(connectionString))
                        using (SqlCommand cmd =
                            new SqlCommand(
                                "SELECT COUNT(*) FROM dbo.EBook " +
                                "WHERE CoverImagePath = @Path",
                                con))
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
                        // Do not hide the original error.
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
                    ClearInventoryLossForm();
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
            else if (e.CommandName == "InventoryLost")
            {
                OpenInventoryLossForm(bookID);
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
                    "@BookID", SqlDbType.Int).Value =
                    bookID;

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
                    "Book archived successfully.",
                    true);
            }
            catch (SqlException ex)
            {
                ShowMessage(ex.Message, false);
            }
        }

        protected void btnClear_Click(
            object sender,
            EventArgs e)
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

        // ================================================
        // PHASE 8H - BATCH 3: INVENTORY LOSS
        // ================================================

        private void OpenInventoryLossForm(int bookID)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "SELECT BookID, Title, TotalCopies, " +
                        "AvailableCopies, IsArchived " +
                        "FROM dbo.EBook WHERE BookID = @BookID",
                        con))
                {
                    cmd.Parameters.Add(
                        "@BookID", SqlDbType.Int).Value =
                        bookID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            ShowMessage(
                                "Book not found.", false);
                            return;
                        }

                        int available =
                            Convert.ToInt32(
                                reader["AvailableCopies"]);

                        if (available <= 0)
                        {
                            ShowMessage(
                                "This book has no available copies to mark lost.",
                                false);
                            return;
                        }

                        if (Convert.ToBoolean(
                            reader["IsArchived"]))
                        {
                            ShowMessage(
                                "Archived books cannot be adjusted here.",
                                false);
                            return;
                        }

                        hfInventoryLossBookID.Value =
                            reader["BookID"].ToString();

                        lblLossBookTitle.Text =
                            Server.HtmlEncode(
                                reader["Title"].ToString());

                        lblLossTotal.Text =
                            reader["TotalCopies"].ToString();

                        lblLossAvailable.Text =
                            available.ToString();

                        lblLossMaximum.Text =
                            available.ToString();

                        txtQuantityLost.Text = "";
                        txtLossReason.Text = "";

                        pnlInventoryLoss.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to open inventory loss form: " +
                    ex.Message,
                    false);
            }
        }

        private void ClearInventoryLossForm()
        {
            hfInventoryLossBookID.Value = "0";
            lblLossBookTitle.Text = "";
            lblLossTotal.Text = "0";
            lblLossAvailable.Text = "0";
            lblLossMaximum.Text = "0";
            txtQuantityLost.Text = "";
            txtLossReason.Text = "";
            pnlInventoryLoss.Visible = false;
        }

        protected void btnCancelInventoryLoss_Click(
            object sender,
            EventArgs e)
        {
            ClearInventoryLossForm();
            lblMessage.Text = "";
        }

        protected void btnConfirmInventoryLoss_Click(
            object sender,
            EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int bookID;
            int quantityLost;
            int adminUserID;

            string reason =
                (txtLossReason.Text ?? "").Trim();

            if (!int.TryParse(
                hfInventoryLossBookID.Value,
                out bookID) ||
                bookID <= 0)
            {
                ShowMessage(
                    "Please select a book to mark lost.",
                    false);
                return;
            }

            if (!int.TryParse(
                txtQuantityLost.Text,
                out quantityLost) ||
                quantityLost <= 0)
            {
                ShowMessage(
                    "Quantity lost must be greater than zero.",
                    false);
                return;
            }

            if (string.IsNullOrWhiteSpace(reason))
            {
                ShowMessage(
                    "A reason for inventory loss is required.",
                    false);
                return;
            }

            if (reason.Length > 500)
            {
                ShowMessage(
                    "Reason must not exceed 500 characters.",
                    false);
                return;
            }

            if (Session["UserID"] == null ||
                !int.TryParse(
                    Convert.ToString(Session["UserID"]),
                    out adminUserID))
            {
                ShowMessage(
                    "Your session has expired. Please sign in again.",
                    false);
                return;
            }

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBook_WebPostInventoryLoss", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@BookID", SqlDbType.Int).Value =
                        bookID;

                    cmd.Parameters.Add(
                        "@QuantityLost", SqlDbType.Int).Value =
                        quantityLost;

                    cmd.Parameters.Add(
                        "@Reason", SqlDbType.NVarChar, 500).Value =
                        reason;

                    cmd.Parameters.Add(
                        "@AdminUserID", SqlDbType.Int).Value =
                        adminUserID;

                    con.Open();

                    // The procedure performs stock deduction,
                    // history insert, and audit insert atomically.
                    cmd.ExecuteNonQuery();
                }

                ClearInventoryLossForm();

                // Refresh the editor if it currently shows
                // the affected book, preventing stale stock.
                int editingBookID;

                if (int.TryParse(
                    hfBookID.Value,
                    out editingBookID) &&
                    editingBookID == bookID)
                {
                    LoadBook(bookID);
                }

                RefreshBooks();
                RefreshInventoryLossHistory();

                ShowMessage(
                    "Inventory loss recorded successfully. " +
                    "Total and available copies were updated.",
                    true);
            }
            catch (SqlException ex)
            {
                // Keep the form open so the librarian
                // can correct the quantity or reason.
                ShowMessage(
                    "Unable to record inventory loss: " +
                    ex.Message,
                    false);
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to record inventory loss: " +
                    ex.Message,
                    false);
            }
        }

        // ================================================
        // INVENTORY LOSS HISTORY
        // ================================================

        private void LoadInventoryLossHistory()
        {
            DataTable table = new DataTable();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand(
                    "EBook_WebInventoryLossHistory", con))
            {
                cmd.CommandType =
                    CommandType.StoredProcedure;

                cmd.Parameters.Add(
                    "@BookID", SqlDbType.Int).Value =
                    DBNull.Value;

                cmd.Parameters.Add(
                    "@Search", SqlDbType.NVarChar, 255).Value =
                    string.IsNullOrWhiteSpace(
                        AppliedLossHistorySearch)
                        ? (object)DBNull.Value
                        : AppliedLossHistorySearch;

                cmd.Parameters.Add(
                    "@PageNumber", SqlDbType.Int).Value =
                    CurrentLossHistoryPage;

                cmd.Parameters.Add(
                    "@PageSize", SqlDbType.Int).Value =
                    LossHistoryPageSize;

                using (SqlDataAdapter adapter =
                    new SqlDataAdapter(cmd))
                {
                    adapter.Fill(table);
                }
            }

            int totalRecords = 0;

            if (table.Rows.Count > 0 &&
                table.Columns.Contains("TotalRecords"))
            {
                totalRecords = Convert.ToInt32(
                    table.Rows[0]["TotalRecords"]);
            }

            TotalLossHistoryPages = Math.Max(
                1,
                (int)Math.Ceiling(
                    totalRecords / (double)LossHistoryPageSize));

            if (CurrentLossHistoryPage > TotalLossHistoryPages)
            {
                CurrentLossHistoryPage = TotalLossHistoryPages;
                LoadInventoryLossHistory();
                return;
            }

            gvInventoryLossHistory.DataSource = table;
            gvInventoryLossHistory.DataBind();

            lblLossHistoryPageInfo.Text = string.Format(
                "Page {0} of {1}",
                CurrentLossHistoryPage,
                TotalLossHistoryPages);

            btnLossHistoryPrevious.Visible =
                TotalLossHistoryPages > 1;

            btnLossHistoryNext.Visible =
                TotalLossHistoryPages > 1;

            btnLossHistoryPrevious.Enabled =
                CurrentLossHistoryPage > 1;

            btnLossHistoryNext.Enabled =
                CurrentLossHistoryPage < TotalLossHistoryPages;
        }

        private void RefreshInventoryLossHistory()
        {
            try
            {
                LoadInventoryLossHistory();
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to load inventory loss history: " +
                    ex.Message,
                    false);
            }
        }

        protected void btnLossHistorySearch_Click(
            object sender,
            EventArgs e)
        {
            AppliedLossHistorySearch =
                (txtLossHistorySearch.Text ?? "").Trim();

            CurrentLossHistoryPage = 1;
            RefreshInventoryLossHistory();
        }

        protected void btnLossHistoryClear_Click(
            object sender,
            EventArgs e)
        {
            txtLossHistorySearch.Text = "";
            AppliedLossHistorySearch = "";
            CurrentLossHistoryPage = 1;
            RefreshInventoryLossHistory();
        }

        protected void btnLossHistoryPrevious_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentLossHistoryPage > 1)
            {
                CurrentLossHistoryPage--;
                RefreshInventoryLossHistory();
            }
        }

        protected void btnLossHistoryNext_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentLossHistoryPage <
                TotalLossHistoryPages)
            {
                CurrentLossHistoryPage++;
                RefreshInventoryLossHistory();
            }
        }
    }
}
