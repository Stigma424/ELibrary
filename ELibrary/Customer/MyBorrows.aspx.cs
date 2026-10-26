
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary.Customer
{
    public partial class MyBorrows : Page
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

        private string AppliedSearch
        {
            get { return Convert.ToString(ViewState["AppliedSearch"] ?? ""); }
            set { ViewState["AppliedSearch"] = value; }
        }

        private string AppliedStatus
        {
            get { return Convert.ToString(ViewState["AppliedStatus"] ?? "All"); }
            set { ViewState["AppliedStatus"] = value; }
        }

        private string AppliedReturn
        {
            get { return Convert.ToString(ViewState["AppliedReturn"] ?? "All"); }
            set { ViewState["AppliedReturn"] = value; }
        }

        private string AppliedSort
        {
            get { return Convert.ToString(ViewState["AppliedSort"] ?? "DueSoonest"); }
            set { ViewState["AppliedSort"] = value; }
        }

        private int CurrentPage
        {
            get { return Convert.ToInt32(ViewState["CurrentPage"] ?? 1); }
            set { ViewState["CurrentPage"] = value; }
        }

        private int TotalPages
        {
            get { return Convert.ToInt32(ViewState["TotalPages"] ?? 1); }
            set { ViewState["TotalPages"] = value; }
        }

        private bool IsCustomer()
        {
            int userID;
            int role;

            return Session["UserID"] != null
                && Session["Role"] != null
                && int.TryParse(
                    Convert.ToString(Session["UserID"]), out userID)
                && userID > 0
                && int.TryParse(
                    Convert.ToString(Session["Role"]), out role)
                && role == 1;
        }

        private int GetUserID()
        {
            return Convert.ToInt32(Session["UserID"]);
        }

        // Attach the extra V2 display to the existing GridView.
        // No change to the original ASPX is required.
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            gvBorrows.RowDataBound += gvBorrows_RowDataBound;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsCustomer())
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                ProcessOverdue();
                LoadBorrows();
            }
        }

        private SqlCommand Procedure(
            string name, SqlConnection connection)
        {
            SqlCommand command = new SqlCommand(name, connection);
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 30;
            return command;
        }

        private void ProcessOverdue()
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    Procedure("dbo.EBorrowLog_WebProcessOverdue", con))
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch
            {
                // The list remains available if overdue processing fails.
            }
        }

        // ==========================================
        // SEARCH AND FILTERS
        // ==========================================

        protected void btnApply_Click(object sender, EventArgs e)
        {
            AppliedSearch = (txtSearch.Text ?? "").Trim();
            AppliedStatus = ddlStatus.SelectedValue;
            AppliedReturn = ddlReturn.SelectedValue;
            AppliedSort = ddlSort.SelectedValue;
            CurrentPage = 1;
            LoadBorrows();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlStatus.SelectedValue = "All";
            ddlReturn.SelectedValue = "All";
            ddlSort.SelectedValue = "DueSoonest";

            AppliedSearch = "";
            AppliedStatus = "All";
            AppliedReturn = "All";
            AppliedSort = "DueSoonest";
            CurrentPage = 1;
            LoadBorrows();
        }

        // ==========================================
        // SERVER-SIDE BORROWING SEARCH
        // ==========================================

        private void LoadBorrows()
        {
            try
            {
                DataSet data = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    Procedure("dbo.EBorrowLog_WebMyBorrowsSearch", con))
                {
                    cmd.Parameters.Add(
                        "@UserID", SqlDbType.Int).Value = GetUserID();

                    cmd.Parameters.Add(
                        "@Search", SqlDbType.NVarChar, 255).Value =
                        string.IsNullOrWhiteSpace(AppliedSearch)
                        ? (object)DBNull.Value : AppliedSearch;

                    cmd.Parameters.Add(
                        "@Status", SqlDbType.VarChar, 20).Value =
                        AppliedStatus;

                    cmd.Parameters.Add(
                        "@ReturnFilter", SqlDbType.VarChar, 20).Value =
                        AppliedReturn;

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
                        adapter.Fill(data);
                    }
                }

                if (data.Tables.Count < 3)
                    throw new InvalidOperationException(
                        "Borrowing search returned incomplete data.");

                DataTable summary = data.Tables[0];
                DataTable counts = data.Tables[1];
                DataTable records = data.Tables[2];

                if (summary.Rows.Count > 0)
                {
                    DataRow row = summary.Rows[0];

                    lblTotalBorrows.Text =
                        Convert.ToString(row["TotalBorrows"]);

                    lblOverdueCount.Text =
                        Convert.ToString(row["OverdueCount"]);

                    lblPendingCount.Text =
                        Convert.ToString(row["PendingCount"]);

                    lblReturnPendingCount.Text =
                        Convert.ToString(row["ReturnPendingCount"]);
                }
                else
                {
                    lblTotalBorrows.Text = "0";
                    lblOverdueCount.Text = "0";
                    lblPendingCount.Text = "0";
                    lblReturnPendingCount.Text = "0";
                }

                int filteredCount = counts.Rows.Count > 0
                    ? Convert.ToInt32(counts.Rows[0]["FilteredCount"])
                    : 0;

                TotalPages = Math.Max(
                    1,
                    (int)Math.Ceiling(filteredCount / (double)PageSize));

                if (CurrentPage > TotalPages)
                {
                    CurrentPage = TotalPages;
                    LoadBorrows();
                    return;
                }

                gvBorrows.DataSource = records;
                gvBorrows.DataBind();

                int first = filteredCount == 0
                    ? 0 : (CurrentPage - 1) * PageSize + 1;

                int last = Math.Min(
                    CurrentPage * PageSize, filteredCount);

                lblResults.Text = string.Format(
                    "Showing {0}–{1} of {2} matching records",
                    first, last, filteredCount);

                lblPageInfo.Text = string.Format(
                    "Page {0} of {1}", CurrentPage, TotalPages);

                btnPrevious.Enabled = CurrentPage > 1;
                btnNext.Enabled = CurrentPage < TotalPages;
                btnPrevious.Visible = TotalPages > 1;
                btnNext.Visible = TotalPages > 1;
            }
            catch (Exception ex)
            {
                gvBorrows.DataSource = null;
                gvBorrows.DataBind();

                lblResults.Text = "Unable to load results.";
                lblPageInfo.Text = "Page 1 of 1";

                btnPrevious.Visible = false;
                btnNext.Visible = false;

                ShowError("Unable to load borrowings: " + ex.Message);
            }
        }

        // ==========================================
        // V2 PAYMENT INFORMATION IN EXISTING ROW
        // ==========================================

        private void gvBorrows_RowDataBound(
            object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow)
                return;

            DataRowView record = e.Row.DataItem as DataRowView;
            if (record == null)
                return;

            // The V1 Book column is index 1.
            // Preserve its existing title, author and fee.
            if (e.Row.Cells.Count < 2)
                return;

            string collection =
                Convert.ToString(record["CollectionStatus"]);

            string channel =
                Convert.ToString(record["BorrowChannel"]);

            decimal fee =
                Convert.ToDecimal(record["BorrowingFeeSnapshot"]);

            decimal feePaid =
                Convert.ToDecimal(record["BorrowingFeePaid"]);

            decimal feeBalance =
                Convert.ToDecimal(record["BorrowingFeeBalance"]);

            decimal depositRequired =
                Convert.ToDecimal(record["DepositRequired"]);

            decimal depositReceived =
                Convert.ToDecimal(record["DepositReceived"]);

            string depositStatus =
                Convert.ToString(record["DepositStatus"]);

            string paymentStatus =
                Convert.ToString(record["UpfrontPaymentStatus"]);

            bool ready =
                Convert.ToBoolean(record["ReadyForPickup"]);

            bool staffCancellation =
                Convert.ToBoolean(record["RequiresStaffCancellation"]);

            bool expired =
                Convert.ToBoolean(record["ReservationExpired"]);

            string statusText;

            if (collection == "Pending")
            {
                if (expired)
                    statusText = "Reservation deadline expired";
                else if (ready)
                    statusText = "Ready for pickup";
                else
                    statusText = "Complete payment before pickup";
            }
            else
            {
                statusText = "Book already collected";
            }

            string content =
                "<div style='margin-top:12px;padding:11px;" +
                "background:#F3FAFA;border:1px solid #DCE9EB;" +
                "border-radius:9px;font-size:12px;line-height:1.8'>" +

                "<strong style='color:#168A91'>" +
                "V2 Payment Details</strong>" +

                "<div>Channel: " +
                HttpUtility.HtmlEncode(channel) + "</div>" +

                "<div>Borrowing Fee: " + Money(fee) + "</div>" +
                "<div>Fee Paid: " + Money(feePaid) + "</div>" +
                "<div>Fee Balance: " + Money(feeBalance) + "</div>" +

                "<div>Refundable Deposit: " +
                Money(depositRequired) + "</div>" +

                "<div>Deposit Received: " +
                Money(depositReceived) + "</div>" +

                "<div>Deposit Status: " +
                HttpUtility.HtmlEncode(depositStatus) + "</div>" +

                "<div>Upfront Payment: " +
                HttpUtility.HtmlEncode(paymentStatus) + "</div>";

            if (collection == "Pending")
            {
                content +=
                    "<div style='font-weight:700;margin-top:6px'>" +
                    HttpUtility.HtmlEncode(statusText) + "</div>";

                if (record["ReservationExpiresAt"] != DBNull.Value)
                {
                    content +=
                        "<div>Reservation Deadline: " +
                        Convert.ToDateTime(
                            record["ReservationExpiresAt"])
                            .ToString("MMM dd, yyyy hh:mm tt") +
                        "</div>";
                }

                if (staffCancellation)
                {
                    content +=
                        "<div style='color:#986320;margin-top:5px'>" +
                        "Payments have been received. " +
                        "Cancellation requires librarian-assisted " +
                        "refund processing.</div>";

                    // Prevent a customer from attempting
                    // the unpaid cancellation action.
                    Button cancel = e.Row.FindControl(
                        "btnCancelReservation") as Button;

                    if (cancel != null)
                    {
                        cancel.Enabled = false;
                        cancel.ToolTip =
                            "Contact the librarian for refund and cancellation.";
                        cancel.Text = "Contact Librarian to Cancel";
                    }
                }
            }

            content += "</div>";

            e.Row.Cells[1].Controls.Add(
                new LiteralControl(content));
        }

        private string Money(decimal value)
        {
            return "₱" + value.ToString(
                "N2", CultureInfo.GetCultureInfo("en-PH"));
        }

        // ==========================================
        // PAGINATION
        // ==========================================

        protected void btnPrevious_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadBorrows();
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            if (CurrentPage < TotalPages)
            {
                CurrentPage++;
                LoadBorrows();
            }
        }

        // ==========================================
        // GRID COMMANDS
        // ==========================================

        protected void gvBorrows_RowCommand(
            object sender, GridViewCommandEventArgs e)
        {
            if (!IsCustomer())
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (e.CommandName != "RequestReturn" &&
                e.CommandName != "CancelReservation")
                return;

            int borrowLogID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out borrowLogID) || borrowLogID <= 0)
            {
                ShowError("Invalid borrowing ID.");
                return;
            }

            if (e.CommandName == "RequestReturn")
            {
                RequestReturn(borrowLogID);
                return;
            }

            GridViewRow row = null;
            Control source = e.CommandSource as Control;

            if (source != null)
                row = source.NamingContainer as GridViewRow;

            if (row == null)
            {
                ShowError("Unable to identify the reservation.");
                return;
            }

            TextBox reasonBox =
                row.FindControl("txtCancellationReason") as TextBox;

            string reason = reasonBox == null
                ? "" : (reasonBox.Text ?? "").Trim();

            if (reason.Length > 500)
            {
                ShowError("Cancellation reason exceeds 500 characters.");
                return;
            }

            CancelReservation(borrowLogID, reason);
        }

        // ==========================================
        // UNPAID RESERVATION CANCELLATION
        // ==========================================

        private void CancelReservation(
            int borrowLogID, string reason)
        {
            try
            {
                // The V2 procedure independently rejects
                // cancellation if money was received.
                // Paid cancellation belongs to librarians.
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    Procedure("dbo.EBorrowLog_WebCancelReservation", con))
                {
                    cmd.Parameters.Add(
                        "@BorrowLogID", SqlDbType.Int).Value =
                        borrowLogID;

                    cmd.Parameters.Add(
                        "@ActorUserID", SqlDbType.Int).Value =
                        GetUserID();

                    cmd.Parameters.Add(
                        "@CancellationReason",
                        SqlDbType.NVarChar, 500).Value =
                        string.IsNullOrWhiteSpace(reason)
                        ? (object)DBNull.Value : reason;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadBorrows();

                ShowSuccess(
                    "Reservation #" + borrowLogID +
                    " cancelled successfully. " +
                    "The reserved book copy has been released.");
            }
            catch (SqlException ex)
            {
                LoadBorrows();
                ShowError(ex.Message);
            }
            catch (Exception)
            {
                LoadBorrows();
                ShowError(
                    "Unable to confirm cancellation. " +
                    "Refresh the list before retrying.");
            }
        }

        // ==========================================
        // EXISTING V1 RETURN REQUEST
        // ==========================================

        private void RequestReturn(int borrowLogID)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    Procedure("dbo.EBorrowLog_WebRequestReturn", con))
                {
                    cmd.Parameters.Add(
                        "@BorrowLogID", SqlDbType.Int).Value =
                        borrowLogID;

                    cmd.Parameters.Add(
                        "@UserID", SqlDbType.Int).Value =
                        GetUserID();

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadBorrows();

                ShowSuccess(
                    "Return request submitted. " +
                    "Please bring the physical book to the " +
                    "librarian for confirmation. Your refundable " +
                    "deposit will be processed separately " +
                    "after any outstanding fees are settled.");
            }
            catch (SqlException ex)
            {
                LoadBorrows();
                ShowError(ex.Message);
            }
            catch (Exception)
            {
                LoadBorrows();
                ShowError(
                    "Unable to request the return. " +
                    "Refresh your borrowing records.");
            }
        }

        // ==========================================
        // ORIGINAL V1 DISPLAY HELPERS
        // ==========================================

        protected string FormatDate(object value)
        {
            if (value == null || value == DBNull.Value)
                return "Not assigned";

            DateTime date;
            return DateTime.TryParse(Convert.ToString(value), out date)
                ? date.ToString("MMM dd, yyyy")
                : "Not assigned";
        }

        protected string GetCollectionDisplay(
            object collectionValue, object statusValue)
        {
            string collection = Convert.ToString(collectionValue);
            string status = Convert.ToString(statusValue);

            if (collection == "Pending")
                return "Pending Pickup";
            if (collection == "Cancelled")
                return "Cancelled";
            if (status == "Returned")
                return "Returned";
            if (collection == "Collected")
                return "Collected";

            return collection;
        }

        protected string GetCollectionClass(
            object collectionValue, object statusValue)
        {
            string collection = Convert.ToString(collectionValue);
            string status = Convert.ToString(statusValue);

            if (collection == "Pending")
                return "el-borrow-lifecycle pending";
            if (collection == "Cancelled")
                return "el-borrow-lifecycle cancelled";
            if (status == "Returned")
                return "el-borrow-lifecycle returned";

            return "el-borrow-lifecycle collected";
        }

        protected string GetStatusClass(object value)
        {
            string status =
                Convert.ToString(value).ToLowerInvariant();

            if (status.Contains("overdue"))
                return "el-records-status overdue";
            if (status.Contains("cancel"))
                return "el-records-status returned";
            if (status.Contains("return"))
                return "el-records-status returned";
            if (status.Contains("pending"))
                return "el-records-status pending";

            return "el-records-status active";
        }

        protected string GetDueDateClass(
            object dateValue, object statusValue)
        {
            DateTime dueDate;

            if (dateValue == null ||
                dateValue == DBNull.Value ||
                !DateTime.TryParse(
                    Convert.ToString(dateValue), out dueDate))
            {
                return "";
            }

            string status = Convert.ToString(statusValue);

            if (dueDate.Date < DateTime.Today &&
                status != "Returned" &&
                status != "Cancelled")
            {
                return "el-records-due-overdue";
            }

            return "";
        }

        // ==========================================
        // ORIGINAL V1 NAVIGATION
        // ==========================================

        protected void btnHistory_Click(object sender, EventArgs e)
        {
            Response.Redirect(
                "~/Customer/BorrowHistory.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        // ==========================================
        // MESSAGES
        // ==========================================

        private void ShowError(string message)
        {
            lblMessage.CssClass = "el-records-message error";
            lblMessage.Text = Server.HtmlEncode(message);
        }

        private void ShowSuccess(string message)
        {
            lblMessage.CssClass = "el-records-message success";
            lblMessage.Text = Server.HtmlEncode(message);
        }
    }
}
