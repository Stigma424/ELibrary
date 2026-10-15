
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary.Admin.Borrowing
{
    public partial class WalkInBorrow : Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings[
                "ElibraryConnection"].ConnectionString;

        // ==========================================
        // SELECTED RECORDS
        // ==========================================

        private int SelectedUserID
        {
            get
            {
                object value = ViewState["SelectedUserID"];

                return value == null
                    ? 0
                    : Convert.ToInt32(value);
            }
            set
            {
                ViewState["SelectedUserID"] = value;
            }
        }

        private int SelectedBookID
        {
            get
            {
                object value = ViewState["SelectedBookID"];

                return value == null
                    ? 0
                    : Convert.ToInt32(value);
            }
            set
            {
                ViewState["SelectedBookID"] = value;
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
                ClearForm();
            }

            hfFocusTarget.Value = "";
        }

        // ==========================================
        // LOCAL NOTIFICATIONS
        // ==========================================

        private enum MessageArea
        {
            Customer,
            Book,
            Verification,
            Confirmation,
            Completed
        }

        private void ShowMessage(
            string message,
            bool success,
            MessageArea area)
        {
            Label label;
            string focus;

            switch (area)
            {
                case MessageArea.Customer:
                    label = lblCustomerMessage;
                    focus = "walkinCustomer";
                    break;

                case MessageArea.Book:
                    label = lblBookMessage;
                    focus = "walkinBook";
                    break;

                case MessageArea.Verification:
                    label = lblVerifyMessage;
                    focus = "walkinVerify";
                    break;

                case MessageArea.Completed:
                    pnlCompleted.Visible = true;
                    label = lblCompletedMessage;
                    focus = "pnlCompleted";
                    break;

                default:
                    pnlPreview.Visible = true;
                    label = lblMessage;
                    focus = "pnlPreview";
                    break;
            }

            label.Text = Server.HtmlEncode(message);
            label.CssClass = success
                ? "wi-message success"
                : "wi-message error";

            label.Visible = true;
            hfFocusTarget.Value = focus;
        }

        private void HideMessages()
        {
            HideLabel(lblCustomerMessage);
            HideLabel(lblBookMessage);
            HideLabel(lblVerifyMessage);
            HideLabel(lblMessage);
            HideLabel(lblCompletedMessage);
        }

        private void HideLabel(Label label)
        {
            label.Text = "";
            label.Visible = false;
        }

        private void FocusSection(string target)
        {
            hfFocusTarget.Value = target;
        }

        // ==========================================
        // CUSTOMER SEARCH
        // ==========================================

        protected void btnSearchCustomer_Click(
            object sender,
            EventArgs e)
        {
            HideMessages();
            pnlPreview.Visible = false;
            pnlCompleted.Visible = false;

            SelectedUserID = 0;
            pnlSelectedCustomer.Visible = false;
            lblSelectedCustomer.Text = "";

            string search =
                (txtCustomerSearch.Text ?? "").Trim();

            if (string.IsNullOrWhiteSpace(search))
            {
                pnlCustomerResults.Visible = false;

                ShowMessage(
                    "Enter a customer name or email.",
                    false,
                    MessageArea.Customer);
                return;
            }

            try
            {
                DataTable results = new DataTable();

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP (20)
                        UserID,
                        FullName,
                        Email,
                        IsAllowedToBorrow
                    FROM dbo.EUsers
                    WHERE Role = 1
                      AND
                      (
                           FullName LIKE '%' + @Search + '%'
                           OR FirstName LIKE '%' + @Search + '%'
                           OR LastName LIKE '%' + @Search + '%'
                           OR Email LIKE '%' + @Search + '%'
                      )
                    ORDER BY
                        FullName ASC,
                        UserID ASC;", con))
                {
                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar, 100).Value =
                        search;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(results);
                    }
                }

                gvCustomers.DataSource = results;
                gvCustomers.DataBind();

                pnlCustomerResults.Visible = true;

                lblCustomerEmpty.Visible =
                    results.Rows.Count == 0;

                FocusSection("walkinCustomer");
            }
            catch (Exception)
            {
                pnlCustomerResults.Visible = false;

                ShowMessage(
                    "Unable to search customers. Please try again.",
                    false,
                    MessageArea.Customer);
            }
        }

        // ==========================================
        // SELECT CUSTOMER
        // ==========================================

        protected void gvCustomers_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (e.CommandName != "SelectCustomer")
            {
                return;
            }

            HideMessages();
            pnlPreview.Visible = false;
            pnlCompleted.Visible = false;

            int userID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out userID) || userID <= 0)
            {
                ShowMessage(
                    "Invalid customer selection.",
                    false,
                    MessageArea.Customer);
                return;
            }

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT
                        UserID,
                        FullName,
                        Email,
                        IsAllowedToBorrow
                    FROM dbo.EUsers
                    WHERE UserID = @UserID
                      AND Role = 1;", con))
                {
                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value =
                        userID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            ShowMessage(
                                "The selected customer was not found.",
                                false,
                                MessageArea.Customer);
                            return;
                        }

                        if (!Convert.ToBoolean(
                            reader["IsAllowedToBorrow"]))
                        {
                            ShowMessage(
                                "This customer is restricted from borrowing.",
                                false,
                                MessageArea.Customer);
                            return;
                        }

                        SelectedUserID = userID;

                        lblSelectedCustomer.Text =
                            Server.HtmlEncode(
                                Convert.ToString(
                                    reader["FullName"])) +
                            " (" +
                            Server.HtmlEncode(
                                Convert.ToString(
                                    reader["Email"])) +
                            ")";
                    }
                }

                pnlSelectedCustomer.Visible = true;
                pnlCustomerResults.Visible = false;

                ShowMessage(
                    "Customer selected successfully.",
                    true,
                    MessageArea.Customer);
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to select the customer. Please try again.",
                    false,
                    MessageArea.Customer);
            }
        }

        // ==========================================
        // BOOK SEARCH
        // ==========================================

        protected void btnSearchBook_Click(
            object sender,
            EventArgs e)
        {
            HideMessages();
            pnlPreview.Visible = false;
            pnlCompleted.Visible = false;

            SelectedBookID = 0;
            pnlSelectedBook.Visible = false;
            lblSelectedBook.Text = "";

            string search =
                (txtBookSearch.Text ?? "").Trim();

            if (string.IsNullOrWhiteSpace(search))
            {
                pnlBookResults.Visible = false;

                ShowMessage(
                    "Enter a book title, author, or ISBN.",
                    false,
                    MessageArea.Book);
                return;
            }

            try
            {
                DataTable results = new DataTable();

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP (20)
                        BookID,
                        Title,
                        Author,
                        AvailableCopies
                    FROM dbo.EBook
                    WHERE IsArchived = 0
                      AND
                      (
                           Title LIKE '%' + @Search + '%'
                           OR Author LIKE '%' + @Search + '%'
                           OR ISBN LIKE '%' + @Search + '%'
                      )
                    ORDER BY
                        Title ASC,
                        BookID ASC;", con))
                {
                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar, 255).Value =
                        search;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(results);
                    }
                }

                gvBooks.DataSource = results;
                gvBooks.DataBind();

                pnlBookResults.Visible = true;

                lblBookEmpty.Visible =
                    results.Rows.Count == 0;

                FocusSection("walkinBook");
            }
            catch (Exception)
            {
                pnlBookResults.Visible = false;

                ShowMessage(
                    "Unable to search books. Please try again.",
                    false,
                    MessageArea.Book);
            }
        }

        // ==========================================
        // SELECT BOOK
        // ==========================================

        protected void gvBooks_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (e.CommandName != "SelectBook")
            {
                return;
            }

            HideMessages();
            pnlPreview.Visible = false;
            pnlCompleted.Visible = false;

            int bookID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out bookID) || bookID <= 0)
            {
                ShowMessage(
                    "Invalid book selection.",
                    false,
                    MessageArea.Book);
                return;
            }

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT
                        BookID,
                        Title,
                        Author,
                        AvailableCopies
                    FROM dbo.EBook
                    WHERE BookID = @BookID
                      AND IsArchived = 0;", con))
                {
                    cmd.Parameters.Add(
                        "@BookID",
                        SqlDbType.Int).Value =
                        bookID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            ShowMessage(
                                "The selected book was not found or is archived.",
                                false,
                                MessageArea.Book);
                            return;
                        }

                        int availableCopies =
                            Convert.ToInt32(
                                reader["AvailableCopies"]);

                        if (availableCopies <= 0)
                        {
                            ShowMessage(
                                "This book has no available copies.",
                                false,
                                MessageArea.Book);
                            return;
                        }

                        SelectedBookID = bookID;

                        lblSelectedBook.Text =
                            Server.HtmlEncode(
                                Convert.ToString(
                                    reader["Title"])) +
                            " — " +
                            Server.HtmlEncode(
                                Convert.ToString(
                                    reader["Author"]));
                    }
                }

                pnlSelectedBook.Visible = true;
                pnlBookResults.Visible = false;

                ShowMessage(
                    "Book selected successfully.",
                    true,
                    MessageArea.Book);
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to select the book. Please try again.",
                    false,
                    MessageArea.Book);
            }
        }

        // ==========================================
        // VERIFY BORROWING
        // ==========================================

        protected void btnVerify_Click(
            object sender,
            EventArgs e)
        {
            HideMessages();
            pnlPreview.Visible = false;
            pnlCompleted.Visible = false;

            if (SelectedUserID <= 0)
            {
                ShowMessage(
                    "Please select a customer first.",
                    false,
                    MessageArea.Verification);
                return;
            }

            if (SelectedBookID <= 0)
            {
                ShowMessage(
                    "Please select a book first.",
                    false,
                    MessageArea.Verification);
                return;
            }

            try
            {
                string customerName;
                string bookTitle;
                int availableCopies;
                string validationMessage;

                bool valid = ValidateBorrowing(
                    SelectedUserID,
                    SelectedBookID,
                    out customerName,
                    out bookTitle,
                    out availableCopies,
                    out validationMessage);

                if (!valid)
                {
                    ShowMessage(
                        validationMessage,
                        false,
                        MessageArea.Verification);
                    return;
                }

                lblCustomer.Text =
                    Server.HtmlEncode(customerName);

                lblBook.Text =
                    Server.HtmlEncode(bookTitle);

                lblAvailable.Text =
                    availableCopies.ToString();

                pnlPreview.Visible = true;

                FocusSection("pnlPreview");
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to verify borrowing. Please try again.",
                    false,
                    MessageArea.Verification);
            }
        }

        // ==========================================
        // SERVER-SIDE BORROW VALIDATION
        // ==========================================

        private bool ValidateBorrowing(
            int userID,
            int bookID,
            out string customerName,
            out string bookTitle,
            out int availableCopies,
            out string validationMessage)
        {
            customerName = "";
            bookTitle = "";
            availableCopies = 0;
            validationMessage = "";

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                con.Open();

                // Check customer eligibility.
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT
                        FullName,
                        IsAllowedToBorrow
                    FROM dbo.EUsers
                    WHERE UserID = @UserID
                      AND Role = 1;", con))
                {
                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value =
                        userID;

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            validationMessage =
                                "The selected customer no longer exists.";
                            return false;
                        }

                        if (!Convert.ToBoolean(
                            reader["IsAllowedToBorrow"]))
                        {
                            validationMessage =
                                "The customer is not allowed to borrow.";
                            return false;
                        }

                        customerName =
                            Convert.ToString(
                                reader["FullName"]);
                    }
                }

                // Check available book inventory.
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT
                        Title,
                        AvailableCopies
                    FROM dbo.EBook
                    WHERE BookID = @BookID
                      AND IsArchived = 0;", con))
                {
                    cmd.Parameters.Add(
                        "@BookID",
                        SqlDbType.Int).Value =
                        bookID;

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            validationMessage =
                                "The selected book is unavailable or archived.";
                            return false;
                        }

                        bookTitle =
                            Convert.ToString(
                                reader["Title"]);

                        availableCopies =
                            Convert.ToInt32(
                                reader["AvailableCopies"]);

                        if (availableCopies <= 0)
                        {
                            validationMessage =
                                "No available copies remain.";
                            return false;
                        }
                    }
                }

                // Prevent an existing active borrowing
                // or reservation for this same book.
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT COUNT(1)
                    FROM dbo.EBorrowLog
                    WHERE UserID = @UserID
                      AND BookID = @BookID
                      AND DateReturned IS NULL
                      AND
                      (
                          (
                              CollectionStatus = 'Pending'
                              AND Status = 'Borrowed'
                          )
                          OR
                          (
                              CollectionStatus = 'Collected'
                              AND Status IN ('Borrowed', 'Overdue')
                          )
                      );", con))
                {
                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value =
                        userID;

                    cmd.Parameters.Add(
                        "@BookID",
                        SqlDbType.Int).Value =
                        bookID;

                    int existing =
                        Convert.ToInt32(
                            cmd.ExecuteScalar());

                    if (existing > 0)
                    {
                        validationMessage =
                            "This customer already has an active loan " +
                            "or reservation for this book.";
                        return false;
                    }
                }
            }

            return true;
        }

        // ==========================================
        // CONFIRM WALK-IN BORROWING
        // ==========================================

        protected void btnConfirm_Click(
            object sender,
            EventArgs e)
        {
            HideMessages();
            pnlCompleted.Visible = false;

            if (!pnlPreview.Visible ||
                SelectedUserID <= 0 ||
                SelectedBookID <= 0)
            {
                ShowMessage(
                    "Please verify the customer and book first.",
                    false,
                    MessageArea.Verification);
                return;
            }

            int adminUserID;

            if (!int.TryParse(
                Convert.ToString(Session["UserID"]),
                out adminUserID))
            {
                ShowMessage(
                    "Your session has expired. Please log in again.",
                    false,
                    MessageArea.Confirmation);
                return;
            }

            btnConfirm.Enabled = false;

            try
            {
                int borrowLogID = 0;

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(
                    "dbo.EBorrowLog_WebWalkInBorrow",
                    con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@BookID",
                        SqlDbType.Int).Value =
                        SelectedBookID;

                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value =
                        SelectedUserID;

                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value =
                        adminUserID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            borrowLogID =
                                Convert.ToInt32(
                                    reader["BorrowLogID"]);
                        }
                    }
                }

                // Clear the verified selection only
                // AFTER successful database processing.
                ClearForm();

                if (borrowLogID > 0)
                {
                    ShowMessage(
                        "Walk-in borrowing recorded successfully. " +
                        "Borrowing ID: " +
                        borrowLogID +
                        ". The book is marked as collected, " +
                        "and the 7-day loan has started.",
                        true,
                        MessageArea.Completed);
                }
                else
                {
                    ShowMessage(
                        "Walk-in borrowing recorded successfully.",
                        true,
                        MessageArea.Completed);
                }
            }
            catch (SqlException ex)
            {
                ShowMessage(
                    GetBorrowingError(ex),
                    false,
                    MessageArea.Confirmation);
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to complete the borrowing transaction. " +
                    "Check the borrowing records before retrying.",
                    false,
                    MessageArea.Confirmation);
            }
            finally
            {
                btnConfirm.Enabled = true;
            }
        }

        // ==========================================
        // SQL ERROR MESSAGES
        // ==========================================

        private string GetBorrowingError(SqlException ex)
        {
            switch (ex.Number)
            {
                case 50401:
                    return "Only librarians can process walk-in borrowing.";

                case 50402:
                    return "The customer is not allowed to borrow.";

                case 50403:
                    return "The selected book was not found.";

                case 50404:
                    return "Archived books cannot be borrowed.";

                case 50405:
                    return "No available copies remain.";

                case 50406:
                    return "The customer already has an active loan " +
                           "or reservation for this book.";

                case 50407:
                    return "Unable to update the available book copies.";

                default:
                    return "Unable to complete borrowing. " +
                           "Please verify the selected records and try again.";
            }
        }

        // ==========================================
        // CLEAR SELECTION
        // ==========================================

        protected void btnClear_Click(
            object sender,
            EventArgs e)
        {
            ClearForm();
            FocusSection("walkinCustomer");
        }

        private void ClearForm()
        {
            SelectedUserID = 0;
            SelectedBookID = 0;

            txtCustomerSearch.Text = "";
            txtBookSearch.Text = "";

            gvCustomers.DataSource = null;
            gvCustomers.DataBind();

            gvBooks.DataSource = null;
            gvBooks.DataBind();

            pnlCustomerResults.Visible = false;
            pnlBookResults.Visible = false;

            pnlSelectedCustomer.Visible = false;
            pnlSelectedBook.Visible = false;

            lblSelectedCustomer.Text = "";
            lblSelectedBook.Text = "";

            lblCustomer.Text = "";
            lblBook.Text = "";
            lblAvailable.Text = "";

            lblCustomerEmpty.Visible = false;
            lblBookEmpty.Visible = false;

            pnlPreview.Visible = false;
            pnlCompleted.Visible = false;

            HideMessages();
        }
    }
}
