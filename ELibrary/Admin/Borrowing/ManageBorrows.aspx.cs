
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
                return ConfigurationManager.ConnectionStrings[
                    "ElibraryConnection"].ConnectionString;
            }
        }

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

        private string AppliedStatus
        {
            get
            {
                return (string)(ViewState["AppliedStatus"] ?? "All");
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

        private int AdminUserID
        {
            get
            {
                return Convert.ToInt32(Session["UserID"]);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            RemoveClosedStatusFilters();

            if (!IsPostBack)
            {
                ProcessOverdue();
                LoadBorrows();
            }
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

        private void ShowMessage(
            string message,
            bool success)
        {
            lblMessage.CssClass = success
                ? "br-message text-success"
                : "br-message text-danger";

            lblMessage.Text = Server.HtmlEncode(message);
        }

        private void ProcessOverdue()
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebProcessOverdue", con))
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

        private void LoadBorrows()
        {
            try
            {
                DataSet ds = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebAdminSearch", con))
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

                    using (SqlDataAdapter da =
                        new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
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
                            ds.Tables[0].Rows[0]["FilteredCount"]);

                TotalPages = Math.Max(
                    1,
                    (int)Math.Ceiling(
                        filteredCount / (double)PageSize));

                if (CurrentPage > TotalPages)
                {
                    CurrentPage = TotalPages;
                    LoadBorrows();
                    return;
                }

                gvBorrows.DataSource = ds.Tables[1];
                gvBorrows.DataBind();

                int first = filteredCount == 0
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
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to load borrowings: " +
                    ex.Message,
                    false);
            }
        }

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

        protected void btnPrevious_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadBorrows();
            }
        }

        protected void btnNext_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage < TotalPages)
            {
                CurrentPage++;
                LoadBorrows();
            }
        }

        protected void btnRefresh_Click(
            object sender,
            EventArgs e)
        {
            ProcessOverdue();
            LoadBorrows();
        }

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
                command != "CancelReservation" &&
                command != "ConfirmReturn" &&
                command != "MarkLost")
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

            if (command == "ConfirmCollection")
            {
                ConfirmCollection(borrowLogID);
                return;
            }

            if (command == "CancelReservation")
            {
                Control source =
                    e.CommandSource as Control;

                GridViewRow row = source == null
                    ? null
                    : source.NamingContainer as GridViewRow;

                if (row == null)
                {
                    ShowMessage(
                        "Unable to identify the reservation row.",
                        false);
                    return;
                }

                TextBox txtReason =
                    row.FindControl("txtCancellationReason")
                    as TextBox;

                string reason = txtReason == null
                    ? ""
                    : (txtReason.Text ?? "").Trim();

                if (string.IsNullOrWhiteSpace(reason))
                {
                    ShowMessage(
                        "Please enter a cancellation reason.",
                        false);
                    return;
                }

                CancelReservation(
                    borrowLogID,
                    reason);
                return;
            }

            if (command == "ConfirmReturn")
            {
                ConfirmReturn(borrowLogID);
                return;
            }

            if (command == "MarkLost")
            {
                Control source =
                    e.CommandSource as Control;

                GridViewRow row = source == null
                    ? null
                    : source.NamingContainer as GridViewRow;

                if (row == null)
                {
                    ShowMessage(
                        "Unable to identify the borrowing row.",
                        false);
                    return;
                }

                TextBox txtReason =
                    row.FindControl("txtLostReason")
                    as TextBox;

                TextBox txtFee =
                    row.FindControl("txtReplacementFee")
                    as TextBox;

                string reason = txtReason == null
                    ? ""
                    : (txtReason.Text ?? "").Trim();

                string feeText = txtFee == null
                    ? ""
                    : (txtFee.Text ?? "").Trim();

                if (string.IsNullOrWhiteSpace(reason))
                {
                    ShowMessage(
                        "Please enter a reason for the lost book.",
                        false);
                    return;
                }

                if (reason.Length > 500)
                {
                    ShowMessage(
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
                    ShowMessage(
                        "Enter a valid replacement fee, for example 500.00.",
                        false);
                    return;
                }

                if (replacementFee <= 0 ||
                    replacementFee > 99999999.99m)
                {
                    ShowMessage(
                        "Replacement fee must be greater than zero " +
                        "and within the allowed amount.",
                        false);
                    return;
                }

                if (decimal.Round(
                    replacementFee,
                    2) != replacementFee)
                {
                    ShowMessage(
                        "Replacement fee can have at most two decimal places.",
                        false);
                    return;
                }

                MarkCustomerBookLost(
                    borrowLogID,
                    reason,
                    replacementFee);
            }
        }

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
                        "EBorrowLog_WebConfirmCollection", con))
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
                                "Collection confirmation was not returned.");
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
                ShowMessage(ex.Message, false);
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
                        "EBorrowLog_WebCancelReservation", con))
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

                ShowMessage(
                    "Reservation #" +
                    borrowLogID +
                    " cancelled successfully. " +
                    "One available book copy was restored.",
                    true);
            }
            catch (SqlException ex)
            {
                LoadBorrows();
                ShowMessage(ex.Message, false);
            }
            catch (Exception ex)
            {
                LoadBorrows();
                ShowMessage(
                    "Unable to cancel reservation: " +
                    ex.Message,
                    false);
            }
        }

        private void ConfirmReturn(int borrowLogID)
        {
            try
            {
                int customerUserID;

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebOne", con))
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
                        "EBorrowLog_WebPostReturn", con))
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
                    "Book return confirmed successfully. " +
                    "One available copy was restored, " +
                    "and applicable fees were processed.",
                    true);
            }
            catch (SqlException ex)
            {
                LoadBorrows();
                ShowMessage(ex.Message, false);
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

        // ============================================
        // PHASE 8H - BATCH 5
        // CUSTOMER LOST BOOK
        // ============================================

        private void MarkCustomerBookLost(
            int borrowLogID,
            string reason,
            decimal replacementFee)
        {
            try
            {
                if (!AdminHelper.IsAdmin(Session))
                {
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebPostLost", con))
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
                    feeParameter.Value = replacementFee;

                    con.Open();

                    // SQL performs the complete operation:
                    // - validates the collected loan
                    // - prevents duplicate loss processing
                    // - decreases TotalCopies by one
                    // - leaves AvailableCopies unchanged
                    // - records loss details and replacement fee
                    // - creates an audit record
                    cmd.ExecuteNonQuery();
                }

                // The active-only search excludes Status='Lost'.
                LoadBorrows();

                ShowMessage(
                    "Borrowing #" +
                    borrowLogID +
                    " was marked lost successfully. " +
                    "Replacement fee recorded: PHP " +
                    replacementFee.ToString("N2") +
                    ". Total book copies decreased by one. " +
                    "Available copies were not deducted again. " +
                    "No payment has been recorded.",
                    true);
            }
            catch (SqlException ex)
            {
                LoadBorrows();

                ShowMessage(
                    "Unable to mark book as lost: " +
                    ex.Message,
                    false);
            }
            catch (Exception ex)
            {
                LoadBorrows();

                ShowMessage(
                    "Unable to mark book as lost: " +
                    ex.Message,
                    false);
            }
        }
    }
}
