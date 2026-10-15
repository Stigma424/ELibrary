
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary.Admin.Borrowing
{
    public partial class ManageBorrows : Page
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
        // APPLIED SEARCH STATE
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

        private string AppliedStatus
        {
            get
            {
                return (string)(
                    ViewState["AppliedStatus"] ?? "All");
            }
            set
            {
                ViewState["AppliedStatus"] = value;
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

        private int AdminUserID
        {
            get
            {
                return Convert.ToInt32(Session["UserID"]);
            }
        }

        // ==========================================
        // SELECTED OPERATION STATE
        // ==========================================

        private int SelectedBorrowID
        {
            get
            {
                return (int)(
                    ViewState["SelectedBorrowID"] ?? 0);
            }
            set
            {
                ViewState["SelectedBorrowID"] = value;
            }
        }

        private string SelectedActionMode
        {
            get
            {
                return (string)(
                    ViewState["SelectedActionMode"] ?? "");
            }
            set
            {
                ViewState["SelectedActionMode"] = value;
            }
        }

        protected void Page_Load(
            object sender,
            EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            RemoveClosedStatusFilters();

            if (!IsPostBack)
            {
                CloseSelectedAction();
                ProcessOverdue();
                LoadBorrows();
            }
            else
            {
                RestoreSelectedActionVisibility();
            }

            hfFocusTarget.Value = "";
        }

        private void RemoveClosedStatusFilters()
        {
            string[] closedStatuses =
            {
                "Returned",
                "Cancelled",
                "Closed",
                "Lost"
            };

            foreach (string status in closedStatuses)
            {
                ListItem item =
                    ddlStatus.Items.FindByValue(status);

                if (item != null)
                {
                    ddlStatus.Items.Remove(item);
                }
            }

            if (!IsPostBack &&
                ddlStatus.Items.FindByValue("All") != null)
            {
                ddlStatus.SelectedValue = "All";
            }
        }

        // ==========================================
        // SECTION FOCUS / LOCAL MESSAGES
        // ==========================================

        private void FocusSection(string sectionID)
        {
            hfFocusTarget.Value = sectionID;
        }

        private void ShowMessage(
            string message,
            bool success)
        {
            lblMessage.Text =
                Server.HtmlEncode(message);

            lblMessage.CssClass = success
                ? "br-message success"
                : "br-message error";

            FocusSection("borrowingRecords");
        }

        private void ShowActionMessage(
            string message,
            bool success)
        {
            pnlSelectedAction.Visible = true;

            lblActionMessage.Text =
                Server.HtmlEncode(message);

            lblActionMessage.CssClass = success
                ? "br-message success"
                : "br-message error";

            FocusSection("pnlSelectedAction");
        }

        // ==========================================
        // SELECTED ACTION VISIBILITY
        // ==========================================

        private void RestoreSelectedActionVisibility()
        {
            string mode = SelectedActionMode;

            pnlSelectedAction.Visible =
                mode == "Cancel" ||
                mode == "Lost" ||
                mode == "Result";

            pnlCancellationForm.Visible =
                mode == "Cancel";

            pnlLostBookForm.Visible =
                mode == "Lost";
        }

        private void OpenSelectedAction(
            int borrowLogID,
            string mode)
        {
            SelectedBorrowID = borrowLogID;
            SelectedActionMode = mode;

            lblSelectedBorrowID.Text =
                borrowLogID.ToString();

            lblActionMessage.Text = "";

            txtCancellationReason.Text = "";
            txtReplacementFee.Text = "";
            txtLostReason.Text = "";

            if (mode == "Cancel")
            {
                lblActionTitle.Text =
                    "Cancel Reservation";

                lblActionDescription.Text =
                    "Provide a reason before cancelling " +
                    "the selected pending pickup.";
            }
            else if (mode == "Lost")
            {
                lblActionTitle.Text =
                    "Record Lost Book";

                lblActionDescription.Text =
                    "Record the replacement fee and reason " +
                    "for the selected active loan.";
            }

            RestoreSelectedActionVisibility();

            FocusSection("pnlSelectedAction");
        }

        private void ShowCompletedAction(
            int borrowLogID,
            string title,
            string message)
        {
            SelectedBorrowID = borrowLogID;
            SelectedActionMode = "Result";

            lblSelectedBorrowID.Text =
                borrowLogID.ToString();

            lblActionTitle.Text = title;

            lblActionDescription.Text =
                "This operation has been processed.";

            txtCancellationReason.Text = "";
            txtReplacementFee.Text = "";
            txtLostReason.Text = "";

            RestoreSelectedActionVisibility();

            ShowActionMessage(message, true);
        }

        private void CloseSelectedAction()
        {
            SelectedBorrowID = 0;
            SelectedActionMode = "";

            pnlSelectedAction.Visible = false;
            pnlCancellationForm.Visible = false;
            pnlLostBookForm.Visible = false;

            lblSelectedBorrowID.Text = "0";
            lblActionMessage.Text = "";

            txtCancellationReason.Text = "";
            txtReplacementFee.Text = "";
            txtLostReason.Text = "";
        }

        protected void btnCloseAction_Click(
            object sender,
            EventArgs e)
        {
            CloseSelectedAction();

            FocusSection("borrowingRecords");
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
                    ex.Message,
                    false);
            }
        }

        // ==========================================
        // LOAD ACTIVE BORROWINGS
        // ==========================================

        private void LoadBorrows()
        {
            try
            {
                DataSet ds = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebAdminSearch",
                        con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar,
                        255).Value =
                        string.IsNullOrWhiteSpace(
                            AppliedSearch)
                        ? (object)DBNull.Value
                        : AppliedSearch;

                    cmd.Parameters.Add(
                        "@Status",
                        SqlDbType.VarChar,
                        20).Value =
                        AppliedStatus;

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

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(ds);
                    }
                }

                if (ds.Tables.Count < 2)
                {
                    throw new InvalidOperationException(
                        "Borrow search returned incomplete data.");
                }

                int filteredCount =
                    ds.Tables[0].Rows.Count == 0
                    ? 0
                    : Convert.ToInt32(
                        ds.Tables[0]
                            .Rows[0]["FilteredCount"]);

                TotalPages = Math.Max(
                    1,
                    (int)Math.Ceiling(
                        filteredCount /
                        (double)PageSize));

                if (CurrentPage > TotalPages)
                {
                    CurrentPage = TotalPages;
                    LoadBorrows();
                    return;
                }

                gvBorrows.DataSource =
                    ds.Tables[1];

                gvBorrows.DataBind();

                int first = filteredCount == 0
                    ? 0
                    : (CurrentPage - 1) *
                        PageSize + 1;

                int last = Math.Min(
                    CurrentPage * PageSize,
                    filteredCount);

                lblResultCount.Text = string.Format(
                    "Showing {0}–{1} of {2} records",
                    first,
                    last,
                    filteredCount);

                lblPageInfo.Text = string.Format(
                    "Page {0} of {1}",
                    CurrentPage,
                    TotalPages);

                btnPrevious.Visible =
                    TotalPages > 1;

                btnNext.Visible =
                    TotalPages > 1;

                btnPrevious.Enabled =
                    CurrentPage > 1;

                btnNext.Enabled =
                    CurrentPage < TotalPages;
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to load borrowings: " +
                    ex.Message,
                    false);
            }
        }

        // ==========================================
        // FILTERS / PAGINATION
        // ==========================================

        protected void btnApply_Click(
            object sender,
            EventArgs e)
        {
            AppliedSearch =
                (txtSearch.Text ?? "").Trim();

            AppliedStatus =
                ddlStatus.SelectedValue;

            AppliedSort =
                ddlSort.SelectedValue;

            CurrentPage = 1;

            CloseSelectedAction();
            LoadBorrows();

            if (string.IsNullOrEmpty(
                hfFocusTarget.Value))
            {
                FocusSection("borrowingRecords");
            }
        }

        protected void btnClearFilters_Click(
            object sender,
            EventArgs e)
        {
            txtSearch.Text = "";

            ddlStatus.SelectedValue = "All";
            ddlSort.SelectedValue = "Default";

            AppliedSearch = "";
            AppliedStatus = "All";
            AppliedSort = "Default";

            CurrentPage = 1;

            CloseSelectedAction();
            LoadBorrows();

            if (string.IsNullOrEmpty(
                hfFocusTarget.Value))
            {
                FocusSection("borrowingRecords");
            }
        }

        protected void btnPrevious_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                CloseSelectedAction();
                LoadBorrows();
            }

            if (string.IsNullOrEmpty(
                hfFocusTarget.Value))
            {
                FocusSection("borrowingRecords");
            }
        }

        protected void btnNext_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage < TotalPages)
            {
                CurrentPage++;
                CloseSelectedAction();
                LoadBorrows();
            }

            if (string.IsNullOrEmpty(
                hfFocusTarget.Value))
            {
                FocusSection("borrowingRecords");
            }
        }

        protected void btnRefresh_Click(
            object sender,
            EventArgs e)
        {
            CloseSelectedAction();

            ProcessOverdue();
            LoadBorrows();

            if (string.IsNullOrEmpty(
                hfFocusTarget.Value))
            {
                FocusSection("borrowingRecords");
            }
        }

        // ==========================================
        // GRID COMMANDS
        // ==========================================

        protected void gvBorrows_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string command = e.CommandName;

            if (command != "ConfirmCollection" &&
                command != "OpenCancellation" &&
                command != "ConfirmReturn" &&
                command != "OpenLost")
            {
                return;
            }

            int borrowLogID;

            if (!int.TryParse(
                Convert.ToString(
                    e.CommandArgument),
                out borrowLogID) ||
                borrowLogID <= 0)
            {
                ShowMessage(
                    "Invalid borrowing ID.",
                    false);
                return;
            }

            if (command == "OpenCancellation")
            {
                OpenSelectedAction(
                    borrowLogID,
                    "Cancel");

                return;
            }

            if (command == "OpenLost")
            {
                OpenSelectedAction(
                    borrowLogID,
                    "Lost");

                return;
            }

            // Direct actions preserve their original
            // confirmation prompts and procedures.
            CloseSelectedAction();

            if (command == "ConfirmCollection")
            {
                ConfirmCollection(borrowLogID);
                return;
            }

            if (command == "ConfirmReturn")
            {
                ConfirmReturn(borrowLogID);
            }
        }

        // ==========================================
        // CONFIRM COLLECTION
        // ==========================================

        private void ConfirmCollection(int borrowLogID)
        {
            try
            {
                DateTime collectionDate;
                DateTime dueDate;

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebConfirmCollection",
                        con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@BorrowLogID",
                        SqlDbType.Int).Value =
                        borrowLogID;

                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value =
                        AdminUserID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            throw new InvalidOperationException(
                                "Collection confirmation " +
                                "was not returned.");
                        }

                        collectionDate =
                            Convert.ToDateTime(
                                reader["DateCollected"]);

                        dueDate =
                            Convert.ToDateTime(
                                reader["DueDate"]);
                    }
                }

                LoadBorrows();

                ShowMessage(
                    "Collection confirmed for reservation #" +
                    borrowLogID +
                    ". Collected: " +
                    collectionDate.ToString(
                        "MM/dd/yyyy hh:mm tt") +
                    ". Due date: " +
                    dueDate.ToString(
                        "MM/dd/yyyy hh:mm tt") +
                    ". No additional book copy was deducted.",
                    true);
            }
            catch (SqlException ex)
            {
                LoadBorrows();

                ShowMessage(
                    ex.Message,
                    false);
            }
            catch (Exception ex)
            {
                LoadBorrows();

                ShowMessage(
                    "Unable to confirm collection: " +
                    ex.Message,
                    false);
            }
        }

        // ==========================================
        // CANCEL RESERVATION
        // ==========================================

        protected void btnConfirmCancellation_Click(
            object sender,
            EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (SelectedActionMode != "Cancel" ||
                SelectedBorrowID <= 0)
            {
                ShowMessage(
                    "Please select a reservation first.",
                    false);
                return;
            }

            string reason =
                (txtCancellationReason.Text ?? "")
                    .Trim();

            if (string.IsNullOrWhiteSpace(reason))
            {
                ShowActionMessage(
                    "Please enter a cancellation reason.",
                    false);
                return;
            }

            if (reason.Length > 500)
            {
                ShowActionMessage(
                    "Cancellation reason cannot exceed " +
                    "500 characters.",
                    false);
                return;
            }

            CancelReservation(
                SelectedBorrowID,
                reason);
        }

        private void CancelReservation(
            int borrowLogID,
            string reason)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebCancelReservation",
                        con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@BorrowLogID",
                        SqlDbType.Int).Value =
                        borrowLogID;

                    cmd.Parameters.Add(
                        "@ActorUserID",
                        SqlDbType.Int).Value =
                        AdminUserID;

                    cmd.Parameters.Add(
                        "@CancellationReason",
                        SqlDbType.NVarChar,
                        500).Value =
                        reason;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadBorrows();

                ShowCompletedAction(
                    borrowLogID,
                    "Reservation Cancelled",
                    "Reservation #" +
                    borrowLogID +
                    " cancelled successfully. " +
                    "One available book copy was restored.");
            }
            catch (SqlException ex)
            {
                ShowActionMessage(
                    ex.Message,
                    false);
            }
            catch (Exception ex)
            {
                ShowActionMessage(
                    "Unable to cancel reservation: " +
                    ex.Message,
                    false);
            }
        }

        // ==========================================
        // CONFIRM RETURN
        // ==========================================

        private void ConfirmReturn(int borrowLogID)
        {
            try
            {
                int customerUserID;

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebOne",
                        con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@BorrowLogID",
                        SqlDbType.Int).Value =
                        borrowLogID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            ShowMessage(
                                "Borrowing record was not found.",
                                false);
                            return;
                        }

                        customerUserID =
                            Convert.ToInt32(
                                reader["UserID"]);
                    }
                }

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebPostReturn",
                        con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@BorrowLogID",
                        SqlDbType.Int).Value =
                        borrowLogID;

                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value =
                        customerUserID;

                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value =
                        AdminUserID;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadBorrows();

                ShowMessage(
                    "Book return confirmed successfully " +
                    "for borrowing #" +
                    borrowLogID +
                    ". One available copy was restored " +
                    "and applicable fees were processed.",
                    true);
            }
            catch (SqlException ex)
            {
                LoadBorrows();

                ShowMessage(
                    ex.Message,
                    false);
            }
            catch (Exception ex)
            {
                LoadBorrows();

                ShowMessage(
                    "Unable to confirm return: " +
                    ex.Message,
                    false);
            }
        }

        // ==========================================
        // LOST BOOK VALIDATION
        // ==========================================

        protected void btnConfirmLost_Click(
            object sender,
            EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (SelectedActionMode != "Lost" ||
                SelectedBorrowID <= 0)
            {
                ShowMessage(
                    "Please select an active borrowing first.",
                    false);
                return;
            }

            string reason =
                (txtLostReason.Text ?? "").Trim();

            string feeText =
                (txtReplacementFee.Text ?? "").Trim();

            if (string.IsNullOrWhiteSpace(reason))
            {
                ShowActionMessage(
                    "Please enter a reason for the lost book.",
                    false);
                return;
            }

            if (reason.Length > 500)
            {
                ShowActionMessage(
                    "Loss reason cannot exceed 500 characters.",
                    false);
                return;
            }

            decimal replacementFee;

            if (!decimal.TryParse(
                feeText,
                NumberStyles.AllowDecimalPoint,
                CultureInfo.InvariantCulture,
                out replacementFee))
            {
                ShowActionMessage(
                    "Enter a valid replacement fee, " +
                    "for example 500.00.",
                    false);
                return;
            }

            if (replacementFee <= 0 ||
                replacementFee > 99999999.99m)
            {
                ShowActionMessage(
                    "Replacement fee must be greater than zero " +
                    "and within the allowed amount.",
                    false);
                return;
            }

            if (decimal.Round(
                replacementFee,
                2) != replacementFee)
            {
                ShowActionMessage(
                    "Replacement fee can have at most " +
                    "two decimal places.",
                    false);
                return;
            }

            MarkCustomerBookLost(
                SelectedBorrowID,
                reason,
                replacementFee);
        }

        // ==========================================
        // PROCESS LOST BOOK
        // ==========================================

        private void MarkCustomerBookLost(
            int borrowLogID,
            string reason,
            decimal replacementFee)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebPostLost",
                        con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@BorrowLogID",
                        SqlDbType.Int).Value =
                        borrowLogID;

                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value =
                        AdminUserID;

                    cmd.Parameters.Add(
                        "@LostReason",
                        SqlDbType.NVarChar,
                        500).Value =
                        reason;

                    SqlParameter feeParameter =
                        cmd.Parameters.Add(
                            "@ReplacementFeeAmount",
                            SqlDbType.Decimal);

                    feeParameter.Precision = 10;
                    feeParameter.Scale = 2;

                    feeParameter.Value =
                        replacementFee;

                    con.Open();

                    // Existing SQL procedure manages:
                    // 1. Collected-loan validation
                    // 2. Duplicate-loss protection
                    // 3. Inventory adjustment
                    // 4. Lost-book metadata
                    // 5. Replacement fee
                    // 6. Audit trail and associated
                    //    receipt behavior
                    cmd.ExecuteNonQuery();
                }

                // Active-only search excludes lost loans.
                LoadBorrows();

                ShowCompletedAction(
                    borrowLogID,
                    "Lost Book Recorded",
                    "Borrowing #" +
                    borrowLogID +
                    " was marked lost successfully. " +
                    "Replacement fee recorded: PHP " +
                    replacementFee.ToString("N2") +
                    ". Total book copies decreased by one. " +
                    "Available copies were not deducted again. " +
                    "No payment was recorded.");
            }
            catch (SqlException ex)
            {
                ShowActionMessage(
                    "Unable to mark book as lost: " +
                    ex.Message,
                    false);
            }
            catch (Exception ex)
            {
                ShowActionMessage(
                    "Unable to mark book as lost: " +
                    ex.Message,
                    false);
            }
        }
    }
}
