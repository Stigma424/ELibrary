
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary.Admin.Borrowing
{
    public partial class WalkInBorrow : Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings[
                "ElibraryConnection"].ConnectionString;

        private int SelectedUserID
        {
            get
            {
                return ViewState["SelectedUserID"] == null
                    ? 0
                    : Convert.ToInt32(
                        ViewState["SelectedUserID"]);
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
                return ViewState["SelectedBookID"] == null
                    ? 0
                    : Convert.ToInt32(
                        ViewState["SelectedBookID"]);
            }
            set
            {
                ViewState["SelectedBookID"] = value;
            }
        }

        private bool PaymentPreviewVerified
        {
            get
            {
                return ViewState["PaymentPreviewVerified"] != null
                    && Convert.ToBoolean(
                        ViewState["PaymentPreviewVerified"]);
            }
            set
            {
                ViewState["PaymentPreviewVerified"] = value;
            }
        }

        private enum MessageArea
        {
            Customer,
            Book,
            Verification,
            Payment,
            Completed
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
                ClearForm();
            }

            hfFocusTarget.Value = "";
        }

        private string FormatPeso(decimal value)
        {
            return "₱" + value.ToString(
                "N2",
                CultureInfo.GetCultureInfo("en-PH"));
        }

        private void HideMessage(Label label)
        {
            label.Text = "";
            label.Visible = false;
        }

        private void HideMessages()
        {
            HideMessage(lblCustomerMessage);
            HideMessage(lblBookMessage);
            HideMessage(lblVerifyMessage);
            HideMessage(lblMessage);
            HideMessage(lblCompletedMessage);
        }

        private void ShowMessage(
            string message,
            bool success,
            MessageArea area)
        {
            Label target;
            string focus;

            switch (area)
            {
                case MessageArea.Customer:
                    target = lblCustomerMessage;
                    focus = "walkinCustomer";
                    break;

                case MessageArea.Book:
                    target = lblBookMessage;
                    focus = "walkinBook";
                    break;

                case MessageArea.Verification:
                    target = lblVerifyMessage;
                    focus = "walkinVerify";
                    break;

                case MessageArea.Completed:
                    pnlCompleted.Visible = true;
                    target = lblCompletedMessage;
                    focus = "pnlCompleted";
                    break;

                default:
                    pnlPreview.Visible = true;
                    target = lblMessage;
                    focus = "pnlPreview";
                    break;
            }

            target.Text = Server.HtmlEncode(message);
            target.CssClass = success
                ? "wi-message success"
                : "wi-message error";
            target.Visible = true;

            hfFocusTarget.Value = focus;
        }

        private void InvalidatePreview()
        {
            PaymentPreviewVerified = false;

            pnlPreview.Visible = false;
            pnlCompleted.Visible = false;

            chkPaymentConfirmed.Checked = false;
            ddlPaymentMethod.SelectedIndex = 0;

            txtAmountReceived.Text = "";
            txtReferenceNo.Text = "";
        }

        // =========================================
        // SEARCH CUSTOMERS
        // =========================================

        protected void btnSearchCustomer_Click(
            object sender,
            EventArgs e)
        {
            HideMessages();
            InvalidatePreview();

            SelectedUserID = 0;
            pnlSelectedCustomer.Visible = false;
            lblSelectedCustomer.Text = "";

            string search =
                (txtCustomerSearch.Text ?? "").Trim();

            if (search.Length == 0)
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
                    ORDER BY FullName, UserID;", con))
                {
                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar,
                        100).Value = search;

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

                hfFocusTarget.Value = "walkinCustomer";
            }
            catch (Exception)
            {
                pnlCustomerResults.Visible = false;

                ShowMessage(
                    "Unable to retrieve customers.",
                    false,
                    MessageArea.Customer);
            }
        }

        // =========================================
        // SELECT CUSTOMER
        // =========================================

        protected void gvCustomers_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (e.CommandName != "SelectCustomer")
                return;

            HideMessages();
            InvalidatePreview();

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
                        FullName,
                        Email,
                        IsAllowedToBorrow
                    FROM dbo.EUsers
                    WHERE UserID = @UserID
                      AND Role = 1;", con))
                {
                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value = userID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            ShowMessage(
                                "Customer not found.",
                                false,
                                MessageArea.Customer);
                            return;
                        }

                        if (!Convert.ToBoolean(
                            reader["IsAllowedToBorrow"]))
                        {
                            ShowMessage(
                                "This customer is not allowed to borrow.",
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
                    "Unable to select customer.",
                    false,
                    MessageArea.Customer);
            }
        }

        // =========================================
        // SEARCH BOOKS
        // =========================================

        protected void btnSearchBook_Click(
            object sender,
            EventArgs e)
        {
            HideMessages();
            InvalidatePreview();

            SelectedBookID = 0;
            pnlSelectedBook.Visible = false;
            lblSelectedBook.Text = "";

            string search =
                (txtBookSearch.Text ?? "").Trim();

            if (search.Length == 0)
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
                    ORDER BY Title, BookID;", con))
                {
                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar,
                        255).Value = search;

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

                hfFocusTarget.Value = "walkinBook";
            }
            catch (Exception)
            {
                pnlBookResults.Visible = false;

                ShowMessage(
                    "Unable to retrieve books.",
                    false,
                    MessageArea.Book);
            }
        }

        // =========================================
        // SELECT BOOK
        // =========================================

        protected void gvBooks_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (e.CommandName != "SelectBook")
                return;

            HideMessages();
            InvalidatePreview();

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
                        Title,
                        Author,
                        AvailableCopies
                    FROM dbo.EBook
                    WHERE BookID = @BookID
                      AND IsArchived = 0;", con))
                {
                    cmd.Parameters.Add(
                        "@BookID",
                        SqlDbType.Int).Value = bookID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            ShowMessage(
                                "Book not found or archived.",
                                false,
                                MessageArea.Book);
                            return;
                        }

                        if (Convert.ToInt32(
                            reader["AvailableCopies"]) <= 0)
                        {
                            ShowMessage(
                                "No available copies remain.",
                                false,
                                MessageArea.Book);
                            return;
                        }

                        SelectedBookID = bookID;

                        lblSelectedBook.Text =
                            Server.HtmlEncode(
                                Convert.ToString(reader["Title"])) +
                            " — " +
                            Server.HtmlEncode(
                                Convert.ToString(reader["Author"]));
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
                    "Unable to select book.",
                    false,
                    MessageArea.Book);
            }
        }

        // =========================================
        // VERIFY CUSTOMER, BOOK, AND PRICES
        // =========================================

        private bool ValidateBorrowing(
            int userID,
            int bookID,
            out string customerName,
            out string bookTitle,
            out int availableCopies,
            out decimal borrowingFee,
            out decimal depositAmount,
            out string message)
        {
            customerName = "";
            bookTitle = "";
            availableCopies = 0;
            borrowingFee = 0;
            depositAmount = 0;
            message = "";

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT FullName, IsAllowedToBorrow
                    FROM dbo.EUsers
                    WHERE UserID = @UserID
                      AND Role = 1;", con))
                {
                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value = userID;

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            message = "Customer not found.";
                            return false;
                        }

                        if (!Convert.ToBoolean(
                            reader["IsAllowedToBorrow"]))
                        {
                            message =
                                "Customer is restricted from borrowing.";
                            return false;
                        }

                        customerName =
                            Convert.ToString(reader["FullName"]);
                    }
                }

                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT
                        Title,
                        AvailableCopies,
                        BorrowingFee
                    FROM dbo.EBook
                    WHERE BookID = @BookID
                      AND IsArchived = 0;", con))
                {
                    cmd.Parameters.Add(
                        "@BookID",
                        SqlDbType.Int).Value = bookID;

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            message = "Book not found or archived.";
                            return false;
                        }

                        bookTitle =
                            Convert.ToString(reader["Title"]);

                        availableCopies =
                            Convert.ToInt32(
                                reader["AvailableCopies"]);

                        borrowingFee =
                            Convert.ToDecimal(reader["BorrowingFee"]);
                    }
                }

                if (availableCopies <= 0)
                {
                    message = "No available copies remain.";
                    return false;
                }

                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT COUNT(*)
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
                              AND Status IN ('Borrowed','Overdue')
                          )
                      );", con))
                {
                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value = userID;

                    cmd.Parameters.Add(
                        "@BookID",
                        SqlDbType.Int).Value = bookID;

                    int existing =
                        Convert.ToInt32(cmd.ExecuteScalar());

                    if (existing > 0)
                    {
                        message =
                            "Customer already has an active loan " +
                            "or reservation for this book.";
                        return false;
                    }
                }

                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT DecimalValue
                    FROM dbo.ELibrarySettings
                    WHERE SettingKey = 'SecurityDeposit';", con))
                {
                    object result = cmd.ExecuteScalar();

                    if (result == null ||
                        result == DBNull.Value)
                    {
                        message =
                            "Security deposit configuration is missing.";
                        return false;
                    }

                    depositAmount = Convert.ToDecimal(result);
                }
            }

            if (borrowingFee < 0 || depositAmount <= 0)
            {
                message = "Invalid borrowing fee or deposit.";
                return false;
            }

            return true;
        }

        protected void btnVerify_Click(
            object sender,
            EventArgs e)
        {
            HideMessages();
            InvalidatePreview();

            if (SelectedUserID <= 0 ||
                SelectedBookID <= 0)
            {
                ShowMessage(
                    "Select both a customer and a book.",
                    false,
                    MessageArea.Verification);
                return;
            }

            try
            {
                string customerName;
                string bookTitle;
                string message;
                int availableCopies;
                decimal borrowingFee;
                decimal depositAmount;

                bool valid = ValidateBorrowing(
                    SelectedUserID,
                    SelectedBookID,
                    out customerName,
                    out bookTitle,
                    out availableCopies,
                    out borrowingFee,
                    out depositAmount,
                    out message);

                if (!valid)
                {
                    ShowMessage(
                        message,
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

                lblBorrowingFee.Text =
                    FormatPeso(borrowingFee);

                lblSecurityDeposit.Text =
                    FormatPeso(depositAmount);

                lblTotalDue.Text =
                    FormatPeso(borrowingFee + depositAmount);

                PaymentPreviewVerified = true;
                pnlPreview.Visible = true;

                hfFocusTarget.Value = "pnlPreview";
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to verify borrowing details.",
                    false,
                    MessageArea.Verification);
            }
        }

        // =========================================
        // CONFIRM PAYMENT AND WALK-IN BORROWING
        // =========================================

        protected void btnConfirm_Click(
            object sender,
            EventArgs e)
        {
            HideMessages();

            if (!PaymentPreviewVerified ||
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
                out adminUserID) ||
                adminUserID <= 0)
            {
                ShowMessage(
                    "Administrator session is invalid.",
                    false,
                    MessageArea.Payment);
                return;
            }

            string method = ddlPaymentMethod.SelectedValue;

            if (method != "Cash" &&
                method != "GCash" &&
                method != "Card" &&
                method != "Bank Transfer")
            {
                ShowMessage(
                    "Select a valid payment method.",
                    false,
                    MessageArea.Payment);
                return;
            }

            decimal receivedAmount;

            if (!decimal.TryParse(
                (txtAmountReceived.Text ?? "").Trim(),
                NumberStyles.AllowDecimalPoint,
                CultureInfo.InvariantCulture,
                out receivedAmount) ||
                receivedAmount <= 0)
            {
                ShowMessage(
                    "Enter a valid positive payment amount, " +
                    "such as 245.00.",
                    false,
                    MessageArea.Payment);
                return;
            }

            if (!chkPaymentConfirmed.Checked)
            {
                ShowMessage(
                    "Confirm that payment was actually received.",
                    false,
                    MessageArea.Payment);
                return;
            }

            string referenceNo =
                (txtReferenceNo.Text ?? "").Trim();

            if (referenceNo.Length > 100)
            {
                ShowMessage(
                    "Payment reference exceeds 100 characters.",
                    false,
                    MessageArea.Payment);
                return;
            }

            // V2 administrator account must actually exist.
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT COUNT(*)
                    FROM dbo.EUsers
                    WHERE UserID = @UserID
                      AND Role = 2;", con))
                {
                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value = adminUserID;

                    con.Open();

                    if (Convert.ToInt32(
                        cmd.ExecuteScalar()) != 1)
                    {
                        ShowMessage(
                            "The administrator account is not " +
                            "registered in the V2 database.",
                            false,
                            MessageArea.Payment);
                        return;
                    }
                }
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to verify administrator access.",
                    false,
                    MessageArea.Payment);
                return;
            }

            // Recalculate before final confirmation.
            // SQL procedure independently validates prices,
            // inventory and payments inside its transaction.
            try
            {
                string customerName;
                string bookTitle;
                string message;
                int availableCopies;
                decimal borrowingFee;
                decimal depositAmount;

                bool valid = ValidateBorrowing(
                    SelectedUserID,
                    SelectedBookID,
                    out customerName,
                    out bookTitle,
                    out availableCopies,
                    out borrowingFee,
                    out depositAmount,
                    out message);

                if (!valid)
                {
                    InvalidatePreview();

                    ShowMessage(
                        message,
                        false,
                        MessageArea.Verification);
                    return;
                }

                decimal expectedAmount =
                    borrowingFee + depositAmount;

                if (receivedAmount != expectedAmount)
                {
                    InvalidatePreview();

                    ShowMessage(
                        "Payment amount does not match the " +
                        "current total of " +
                        FormatPeso(expectedAmount) +
                        ". Verify the borrowing again.",
                        false,
                        MessageArea.Verification);
                    return;
                }
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to recheck the payment amount.",
                    false,
                    MessageArea.Payment);
                return;
            }

            // Prevent another submission on this page once
            // the procedure reports a successful transaction.
            PaymentPreviewVerified = false;

            try
            {
                int borrowLogID = 0;
                int receiptID = 0;
                decimal borrowingFee = 0;
                decimal depositAmount = 0;
                decimal totalPaid = 0;
                DateTime dueDate = DateTime.MinValue;

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(
                    "dbo.EBorrowLog_WebWalkInBorrow", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

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

                    cmd.Parameters.Add(
                        "@PaymentMethod",
                        SqlDbType.VarChar,
                        30).Value = method;

                    SqlParameter amount =
                        cmd.Parameters.Add(
                            "@AmountReceived",
                            SqlDbType.Decimal);

                    amount.Precision = 10;
                    amount.Scale = 2;
                    amount.Value = receivedAmount;

                    cmd.Parameters.Add(
                        "@ReferenceNo",
                        SqlDbType.VarChar,
                        100).Value =
                        referenceNo.Length == 0
                            ? (object)DBNull.Value
                            : referenceNo;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            borrowLogID =
                                Convert.ToInt32(
                                    reader["BorrowLogID"]);

                            receiptID =
                                Convert.ToInt32(
                                    reader["ReceiptID"]);

                            borrowingFee =
                                Convert.ToDecimal(
                                    reader["BorrowingFee"]);

                            depositAmount =
                                Convert.ToDecimal(
                                    reader["SecurityDeposit"]);

                            totalPaid =
                                Convert.ToDecimal(
                                    reader["TotalPaid"]);

                            dueDate =
                                Convert.ToDateTime(
                                    reader["DueDate"]);
                        }
                    }
                }

                if (borrowLogID <= 0)
                {
                    pnlPreview.Visible = false;

                    ShowMessage(
                        "No confirmation was returned. " +
                        "Check the borrowing records before retrying.",
                        false,
                        MessageArea.Completed);
                    return;
                }

                ClearForm();

                ShowMessage(
                    "Walk-in borrowing completed. " +
                    "Borrow ID: " + borrowLogID +
                    ". Receipt ID: " + receiptID +
                    ". Total received: " + FormatPeso(totalPaid) +
                    " (borrowing fee " + FormatPeso(borrowingFee) +
                    "; refundable deposit " +
                    FormatPeso(depositAmount) + "). " +
                    "Due: " + dueDate.ToString(
                        "MMM dd, yyyy hh:mm tt") + ".",
                    true,
                    MessageArea.Completed);
            }
            catch (SqlException ex)
            {
                // A stored procedure error rolls back its SQL
                // transaction, including stock and deposit changes.
                // Restore preview eligibility for recoverable errors.
                PaymentPreviewVerified = true;

                ShowMessage(
                    GetBorrowingError(ex),
                    false,
                    MessageArea.Payment);
            }
            catch (Exception)
            {
                // Connection or response failure may be ambiguous:
                // a commit could have succeeded even if the response
                // was lost. Require a new verification rather than
                // blindly allowing another payment submission.
                InvalidatePreview();

                ShowMessage(
                    "Unable to confirm the result. Check " +
                    "borrowing records before attempting again.",
                    false,
                    MessageArea.Verification);
            }
        }

        private string GetBorrowingError(SqlException ex)
        {
            switch (ex.Number)
            {
                case 52501:
                    return "Only librarians may process walk-in borrowing.";

                case 52502:
                    return "Customer is not eligible to borrow.";

                case 52503:
                    return "Invalid payment method.";

                case 52504:
                    return "Payment amount must be positive.";

                case 52505:
                    return "The selected book was not found.";

                case 52506:
                    return "Archived books cannot be borrowed.";

                case 52507:
                    return "No available copies remain.";

                case 52508:
                    return "The borrowing fee is invalid.";

                case 52509:
                    return "Customer already has an active " +
                           "reservation or loan for this book.";

                case 52510:
                    return "Security deposit setting is invalid.";

                case 52511:
                    return "Payment does not match the full " +
                           "borrowing fee plus security deposit.";

                case 52512:
                    return "Unable to update book inventory.";

                default:
                    return "Borrowing was rejected. " +
                           "Review the transaction before retrying.";
            }
        }

        // =========================================
        // CLEAR FORM
        // =========================================

        protected void btnClear_Click(
            object sender,
            EventArgs e)
        {
            ClearForm();
            hfFocusTarget.Value = "walkinCustomer";
        }

        private void ClearForm()
        {
            SelectedUserID = 0;
            SelectedBookID = 0;
            PaymentPreviewVerified = false;

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

            lblBorrowingFee.Text = "";
            lblSecurityDeposit.Text = "";
            lblTotalDue.Text = "";

            ddlPaymentMethod.SelectedIndex = 0;
            txtAmountReceived.Text = "";
            txtReferenceNo.Text = "";
            chkPaymentConfirmed.Checked = false;

            lblCustomerEmpty.Visible = false;
            lblBookEmpty.Visible = false;

            pnlPreview.Visible = false;
            pnlCompleted.Visible = false;

            HideMessages();
        }
    }
}
