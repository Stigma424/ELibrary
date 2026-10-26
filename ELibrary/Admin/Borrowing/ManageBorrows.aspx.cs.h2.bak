
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

        // All database operations use stored procedures.
        // Web.config points this connection to ELibrary000_V2.
        private string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings[
                    "ElibraryConnection"].ConnectionString;
            }
        }

        private string AppliedSearch
        {
            get
            {
                return Convert.ToString(
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
                return Convert.ToString(
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
                return Convert.ToString(
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
                return Convert.ToInt32(
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
                return Convert.ToInt32(
                    ViewState["TotalPages"] ?? 1);
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
                int userID;

                if (!int.TryParse(
                    Convert.ToString(Session["UserID"]),
                    out userID))
                {
                    throw new InvalidOperationException(
                        "Administrator session is invalid.");
                }

                return userID;
            }
        }

        // ==========================================
        // PAGE INITIALIZATION
        // ==========================================

        protected void Page_Load(
            object sender,
            EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                AppliedSearch = "";
                AppliedStatus = "All";
                AppliedSort = "Default";
                CurrentPage = 1;

                ProcessOverdue();
                LoadBorrows();
            }
        }

        // ==========================================
        // UI HELPERS
        // ==========================================

        private void ShowMessage(
            string message,
            bool success)
        {
            lblMessage.CssClass = success
                ? "br-message text-success"
                : "br-message text-danger";

            lblMessage.Text =
                Server.HtmlEncode(message);
        }

        public string Money(object value)
        {
            decimal amount =
                value == null || value == DBNull.Value
                ? 0m
                : Convert.ToDecimal(value);

            return "₱" + amount.ToString(
                "N2",
                CultureInfo.GetCultureInfo("en-PH"));
        }

        private SqlCommand CreateProcedure(
            string procedureName,
            SqlConnection connection)
        {
            SqlCommand cmd =
                new SqlCommand(procedureName, connection);

            cmd.CommandType =
                CommandType.StoredProcedure;

            cmd.CommandTimeout = 30;

            return cmd;
        }

        private static void AddDecimalParameter(
            SqlCommand command,
            string name,
            decimal value)
        {
            SqlParameter parameter =
                command.Parameters.Add(
                    name,
                    SqlDbType.Decimal);

            parameter.Precision = 10;
            parameter.Scale = 2;
            parameter.Value = value;
        }

        private void ExecuteProcedure(
            string procedureName,
            Action<SqlCommand> configure)
        {
            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                CreateProcedure(procedureName, con))
            {
                configure(cmd);

                con.Open();

                cmd.ExecuteNonQuery();
            }
        }

        // ==========================================
        // OVERDUE PROCESSING
        // ==========================================

        private void ProcessOverdue()
        {
            try
            {
                ExecuteProcedure(
                    "dbo.EBorrowLog_WebProcessOverdue",
                    cmd =>
                    {
                        // Existing V1 procedure is preserved.
                    });
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to update overdue borrowing statuses.",
                    false);
            }
        }

        // ==========================================
        // DATABASE SEARCH AND PAGINATION
        // ==========================================

        private void LoadBorrows()
        {
            try
            {
                DataSet results = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    CreateProcedure(
                        "dbo.EBorrowLog_WebAdminSearch",
                        con))
                {
                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar,
                        255).Value =
                        string.IsNullOrWhiteSpace(AppliedSearch)
                        ? (object)DBNull.Value
                        : AppliedSearch;

                    cmd.Parameters.Add(
                        "@Status",
                        SqlDbType.VarChar,
                        20).Value = AppliedStatus;

                    cmd.Parameters.Add(
                        "@Sort",
                        SqlDbType.VarChar,
                        20).Value = AppliedSort;

                    cmd.Parameters.Add(
                        "@PageNumber",
                        SqlDbType.Int).Value = CurrentPage;

                    cmd.Parameters.Add(
                        "@PageSize",
                        SqlDbType.Int).Value = PageSize;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(results);
                    }
                }

                if (results.Tables.Count < 2)
                {
                    throw new InvalidOperationException(
                        "Admin search returned incomplete data.");
                }

                int filteredCount = 0;

                if (results.Tables[0].Rows.Count > 0)
                {
                    filteredCount = Convert.ToInt32(
                        results.Tables[0].Rows[0][
                            "FilteredCount"]);
                }

                TotalPages = Math.Max(
                    1,
                    (int)Math.Ceiling(
                        filteredCount / (double)PageSize));

                // The selected page may become invalid after
                // cancellation, return, or filter changes.
                if (CurrentPage > TotalPages)
                {
                    CurrentPage = TotalPages;
                    LoadBorrows();
                    return;
                }

                gvBorrows.DataSource =
                    results.Tables[1];

                gvBorrows.DataBind();

                int first =
                    filteredCount == 0
                    ? 0
                    : (CurrentPage - 1) * PageSize + 1;

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

                btnPrevious.Visible = TotalPages > 1;
                btnNext.Visible = TotalPages > 1;

                btnPrevious.Enabled = CurrentPage > 1;
                btnNext.Enabled = CurrentPage < TotalPages;
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to load borrowing records. " +
                    "Check the V2 admin-search procedure.",
                    false);
            }
        }

        // ==========================================
        // SEARCH / FILTER BUTTONS
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

            LoadBorrows();
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

            LoadBorrows();
        }

        protected void btnRefresh_Click(
            object sender,
            EventArgs e)
        {
            ProcessOverdue();

            LoadBorrows();
        }

        // ==========================================
        // PAGINATION
        // ==========================================

        protected void btnPrevious_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage <= 1)
                return;

            CurrentPage--;

            LoadBorrows();
        }

        protected void btnNext_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage >= TotalPages)
                return;

            CurrentPage++;

            LoadBorrows();
        }

        // ==========================================
        // READ ACTION INFORMATION
        // ==========================================

        private DataRow GetActionInfo(
            int borrowLogID)
        {
            DataTable table = new DataTable();

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                CreateProcedure(
                    "dbo.EBorrowLog_WebAdminActionInfo",
                    con))
            {
                cmd.Parameters.Add(
                    "@BorrowLogID",
                    SqlDbType.Int).Value = borrowLogID;

                cmd.Parameters.Add(
                    "@AdminUserID",
                    SqlDbType.Int).Value = AdminUserID;

                using (SqlDataAdapter adapter =
                    new SqlDataAdapter(cmd))
                {
                    adapter.Fill(table);
                }
            }

            if (table.Rows.Count != 1)
            {
                throw new InvalidOperationException(
                    "Borrowing action information was not found.");
            }

            return table.Rows[0];
        }

        // ==========================================
        // GRID ACTION ROUTING
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

            string action = e.CommandName;

            if (action != "ConfirmCollection" &&
                action != "CancelReservation" &&
                action != "ConfirmReturn" &&
                action != "MarkLost")
            {
                return;
            }

            int borrowLogID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out borrowLogID) ||
                borrowLogID <= 0)
            {
                ShowMessage(
                    "Invalid borrowing ID.",
                    false);
                return;
            }

            if (action == "ConfirmCollection")
            {
                ConfirmCollection(borrowLogID);
                return;
            }

            if (action == "ConfirmReturn")
            {
                ConfirmReturn(borrowLogID);
                return;
            }

            // Row controls are used only for actions
            // requiring additional librarian input.
            Control source =
                e.CommandSource as Control;

            GridViewRow row =
                source == null
                ? null
                : source.NamingContainer as GridViewRow;

            if (row == null)
            {
                ShowMessage(
                    "Unable to identify the borrowing row.",
                    false);
                return;
            }

            if (action == "CancelReservation")
            {
                TextBox reasonBox =
                    row.FindControl(
                        "txtCancellationReason") as TextBox;

                string reason =
                    reasonBox == null
                    ? ""
                    : (reasonBox.Text ?? "").Trim();

                if (reason.Length == 0 ||
                    reason.Length > 500)
                {
                    ShowMessage(
                        "A cancellation reason is required " +
                        "(maximum 500 characters).",
                        false);
                    return;
                }

                CancelReservation(
                    borrowLogID,
                    reason,
                    row);

                return;
            }

            if (action == "MarkLost")
            {
                TextBox reasonBox =
                    row.FindControl("txtLostReason")
                    as TextBox;

                TextBox feeBox =
                    row.FindControl("txtReplacementFee")
                    as TextBox;

                string reason =
                    reasonBox == null
                    ? ""
                    : (reasonBox.Text ?? "").Trim();

                decimal replacementFee = 0m;

                if (reason.Length == 0 ||
                    reason.Length > 500)
                {
                    ShowMessage(
                        "Enter a lost-book reason, " +
                        "up to 500 characters.",
                        false);
                    return;
                }

                bool validFee =
                    feeBox != null &&
                    decimal.TryParse(
                        (feeBox.Text ?? "").Trim(),
                        NumberStyles.AllowDecimalPoint,
                        CultureInfo.InvariantCulture,
                        out replacementFee);

                if (!validFee)
                {
                    ShowMessage(
                        "Enter a valid replacement fee, " +
                        "such as 500.00.",
                        false);
                    return;
                }

                if (replacementFee <= 0 ||
                    replacementFee > 99999999.99m ||
                    decimal.Round(
                        replacementFee, 2) != replacementFee)
                {
                    ShowMessage(
                        "Replacement fee must be positive " +
                        "and have at most two decimal places.",
                        false);
                    return;
                }

                MarkLost(
                    borrowLogID,
                    reason,
                    replacementFee);
            }
        }

        // ==========================================
        // CONFIRM ONLINE COLLECTION
        // ==========================================

        private void ConfirmCollection(
            int borrowLogID)
        {
            try
            {
                DataRow actionInfo =
                    GetActionInfo(borrowLogID);

                bool canCollect =
                    Convert.ToBoolean(
                        actionInfo["CanConfirmCollection"]);

                if (!canCollect)
                {
                    ShowMessage(
                        "Collection is blocked. " +
                        "The customer must fully pay the " +
                        "borrowing fee and refundable deposit.",
                        false);
                    return;
                }

                DateTime collectionDate;
                DateTime dueDate;

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    CreateProcedure(
                        "dbo.EBorrowLog_WebConfirmCollection",
                        con))
                {
                    cmd.Parameters.Add(
                        "@BorrowLogID",
                        SqlDbType.Int).Value = borrowLogID;

                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value = AdminUserID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            throw new InvalidOperationException(
                                "No collection result was returned.");
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
                    "Collection confirmed for borrowing #" +
                    borrowLogID +
                    ". Collected: " +
                    collectionDate.ToString(
                        "MM/dd/yyyy hh:mm tt") +
                    ". Due date: " +
                    dueDate.ToString(
                        "MM/dd/yyyy hh:mm tt") +
                    ". The seven-day loan has started.",
                    true);
            }
            catch (SqlException ex)
            {
                LoadBorrows();

                ShowMessage(
                    "Collection rejected: " + ex.Message,
                    false);
            }
            catch (Exception)
            {
                LoadBorrows();

                ShowMessage(
                    "Collection could not be confirmed. " +
                    "Review the borrowing record before retrying.",
                    false);
            }
        }

        // ==========================================
        // UNPAID AND PAID CANCELLATIONS
        // ==========================================

        private void CancelReservation(
            int borrowLogID,
            string reason,
            GridViewRow row)
        {
            try
            {
                DataRow actionInfo =
                    GetActionInfo(borrowLogID);

                bool paid =
                    Convert.ToBoolean(
                        actionInfo["RequiresPaidCancellation"]);

                bool canCancelUnpaid =
                    Convert.ToBoolean(
                        actionInfo["CanCancelUnpaid"]);

                if (!paid && !canCancelUnpaid)
                {
                    ShowMessage(
                        "This reservation cannot be cancelled " +
                        "in its current state.",
                        false);
                    return;
                }

                string procedure = paid
                    ? "dbo.EBorrowLog_WebCancelPaidReservation"
                    : "dbo.EBorrowLog_WebCancelReservation";

                string refundMethod = "";
                string refundReference = "";

                if (paid)
                {
                    DropDownList methodControl =
                        row.FindControl("ddlRefundMethod")
                        as DropDownList;

                    TextBox referenceControl =
                        row.FindControl("txtRefundReference")
                        as TextBox;

                    CheckBox confirmationControl =
                        row.FindControl("chkRefundConfirmed")
                        as CheckBox;

                    if (methodControl == null ||
                        confirmationControl == null)
                    {
                        ShowMessage(
                            "Refund controls are not available. " +
                            "Refresh the borrowing list.",
                            false);
                        return;
                    }

                    refundMethod =
                        methodControl.SelectedValue;

                    if (refundMethod != "Cash" &&
                        refundMethod != "GCash" &&
                        refundMethod != "Card" &&
                        refundMethod != "Bank Transfer")
                    {
                        ShowMessage(
                            "Select a valid refund method.",
                            false);
                        return;
                    }

                    if (!confirmationControl.Checked)
                    {
                        ShowMessage(
                            "Confirm that the received money " +
                            "was actually refunded.",
                            false);
                        return;
                    }

                    refundReference =
                        referenceControl == null
                        ? ""
                        : (referenceControl.Text ?? "").Trim();

                    if (refundReference.Length > 100)
                    {
                        ShowMessage(
                            "Refund reference must not exceed " +
                            "100 characters.",
                            false);
                        return;
                    }
                }

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    CreateProcedure(procedure, con))
                {
                    cmd.Parameters.Add(
                        "@BorrowLogID",
                        SqlDbType.Int).Value = borrowLogID;

                    cmd.Parameters.Add(
                        "@CancellationReason",
                        SqlDbType.NVarChar,
                        500).Value = reason;

                    if (paid)
                    {
                        cmd.Parameters.Add(
                            "@AdminUserID",
                            SqlDbType.Int).Value = AdminUserID;

                        cmd.Parameters.Add(
                            "@RefundMethod",
                            SqlDbType.VarChar,
                            30).Value = refundMethod;

                        cmd.Parameters.Add(
                            "@ReferenceNo",
                            SqlDbType.VarChar,
                            100).Value =
                            refundReference.Length == 0
                            ? (object)DBNull.Value
                            : refundReference;
                    }
                    else
                    {
                        cmd.Parameters.Add(
                            "@ActorUserID",
                            SqlDbType.Int).Value = AdminUserID;
                    }

                    con.Open();

                    cmd.ExecuteNonQuery();
                }

                LoadBorrows();

                ShowMessage(
                    paid
                    ? "Paid reservation cancelled. " +
                      "The verified refunds were recorded " +
                      "and reserved stock was released."
                    : "Unpaid reservation cancelled " +
                      "and reserved stock was released.",
                    true);
            }
            catch (SqlException ex)
            {
                LoadBorrows();

                ShowMessage(
                    "Cancellation rejected: " + ex.Message,
                    false);
            }
            catch (Exception)
            {
                LoadBorrows();

                ShowMessage(
                    "Unable to cancel the reservation. " +
                    "Review its latest financial status.",
                    false);
            }
        }

        // ==========================================
        // CONFIRM PHYSICAL BOOK RETURN
        // ==========================================

        private void ConfirmReturn(
            int borrowLogID)
        {
            try
            {
                DataRow actionInfo =
                    GetActionInfo(borrowLogID);

                if (!Convert.ToBoolean(
                    actionInfo["CanReturn"]))
                {
                    ShowMessage(
                        "Only active, physically collected " +
                        "books can be returned.",
                        false);
                    return;
                }

                int customerUserID =
                    Convert.ToInt32(
                        actionInfo["UserID"]);

                decimal lateFee = 0m;
                int daysOverdue = 0;

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    CreateProcedure(
                        "dbo.EBorrowLog_WebPostReturn",
                        con))
                {
                    cmd.Parameters.Add(
                        "@BorrowLogID",
                        SqlDbType.Int).Value = borrowLogID;

                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value =
                        customerUserID;

                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value = AdminUserID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lateFee =
                                Convert.ToDecimal(
                                    reader["LateFee"]);

                            daysOverdue =
                                Convert.ToInt32(
                                    reader["DaysOverdue"]);
                        }
                    }
                }

                LoadBorrows();

                ShowMessage(
                    "Book return confirmed for borrowing #" +
                    borrowLogID +
                    ". Overdue days: " + daysOverdue +
                    ". Late fee: " + Money(lateFee) +
                    ". The borrowing fee was not charged again. " +
                    "The deposit is awaiting refund processing.",
                    true);
            }
            catch (SqlException ex)
            {
                LoadBorrows();

                ShowMessage(
                    "Return rejected: " + ex.Message,
                    false);
            }
            catch (Exception)
            {
                LoadBorrows();

                ShowMessage(
                    "Unable to confirm the return. " +
                    "Check the borrowing record before retrying.",
                    false);
            }
        }

        // ==========================================
        // MARK LOST BOOK
        // ==========================================

        private void MarkLost(
            int borrowLogID,
            string reason,
            decimal replacementFee)
        {
            try
            {
                DataRow actionInfo =
                    GetActionInfo(borrowLogID);

                if (!Convert.ToBoolean(
                    actionInfo["CanMarkLost"]))
                {
                    ShowMessage(
                        "Only active collected books can " +
                        "be marked lost.",
                        false);
                    return;
                }

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    CreateProcedure(
                        "dbo.EBorrowLog_WebPostLost",
                        con))
                {
                    cmd.Parameters.Add(
                        "@BorrowLogID",
                        SqlDbType.Int).Value = borrowLogID;

                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value = AdminUserID;

                    cmd.Parameters.Add(
                        "@LostReason",
                        SqlDbType.NVarChar,
                        500).Value = reason;

                    AddDecimalParameter(
                        cmd,
                        "@ReplacementFeeAmount",
                        replacementFee);

                    con.Open();

                    cmd.ExecuteNonQuery();
                }

                LoadBorrows();

                ShowMessage(
                    "Borrowing #" + borrowLogID +
                    " was marked lost. Replacement fee: " +
                    Money(replacementFee) +
                    ". Total book copies were reduced by one, " +
                    "and the refundable security deposit " +
                    "was placed on hold.",
                    true);
            }
            catch (SqlException ex)
            {
                LoadBorrows();

                ShowMessage(
                    "Lost-book action rejected: " + ex.Message,
                    false);
            }
            catch (Exception)
            {
                LoadBorrows();

                ShowMessage(
                    "Unable to mark this borrowing as lost. " +
                    "Check the borrowing record before retrying.",
                    false);
            }
        }
    }
}
