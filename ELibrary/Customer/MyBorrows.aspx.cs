
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
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

        // ==========================================
        // APPLIED FILTER STATE
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

        private string AppliedReturn
        {
            get
            {
                return (string)(ViewState["AppliedReturn"] ?? "All");
            }
            set
            {
                ViewState["AppliedReturn"] = value;
            }
        }

        private string AppliedSort
        {
            get
            {
                return (string)(ViewState["AppliedSort"]
                    ?? "DueSoonest");
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
        // AUTHENTICATION
        // ==========================================

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsCustomer())
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                ProcessOverdue();
                LoadBorrows();
            }
        }

        private bool IsCustomer()
        {
            if (Session["UserID"] == null ||
                Session["Role"] == null)
            {
                return false;
            }

            int role;

            return int.TryParse(
                Convert.ToString(Session["Role"]),
                out role) && role == 1;
        }

        private int GetUserID()
        {
            return Convert.ToInt32(Session["UserID"]);
        }

        // ==========================================
        // OVERDUE PROCESSING
        // ==========================================

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
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch
            {
                // Do not block borrowing records
                // if overdue processing fails.
            }
        }

        // ==========================================
        // FILTERS
        // ==========================================

        protected void btnApply_Click(
            object sender, EventArgs e)
        {
            AppliedSearch = (txtSearch.Text ?? "").Trim();
            AppliedStatus = ddlStatus.SelectedValue;
            AppliedReturn = ddlReturn.SelectedValue;
            AppliedSort = ddlSort.SelectedValue;

            CurrentPage = 1;
            LoadBorrows();
        }

        protected void btnClear_Click(
            object sender, EventArgs e)
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
        // LOAD BORROWINGS
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
                        "EBorrowLog_WebMyBorrowsSearch", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@UserID", SqlDbType.Int).Value =
                        GetUserID();

                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.NVarChar, 255).Value =
                        string.IsNullOrWhiteSpace(AppliedSearch)
                            ? (object)DBNull.Value
                            : AppliedSearch;

                    cmd.Parameters.Add(
                        "@Status",
                        SqlDbType.VarChar, 20).Value =
                        AppliedStatus;

                    cmd.Parameters.Add(
                        "@ReturnFilter",
                        SqlDbType.VarChar, 20).Value =
                        AppliedReturn;

                    cmd.Parameters.Add(
                        "@Sort",
                        SqlDbType.VarChar, 20).Value =
                        AppliedSort;

                    cmd.Parameters.Add(
                        "@PageNumber", SqlDbType.Int).Value =
                        CurrentPage;

                    cmd.Parameters.Add(
                        "@PageSize", SqlDbType.Int).Value =
                        PageSize;

                    using (SqlDataAdapter da =
                        new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count < 3)
                {
                    throw new InvalidOperationException(
                        "Borrowing search returned incomplete data.");
                }

                DataTable summary = ds.Tables[0];
                DataTable counts = ds.Tables[1];
                DataTable records = ds.Tables[2];

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

                int filteredCount = 0;

                if (counts.Rows.Count > 0)
                {
                    filteredCount = Convert.ToInt32(
                        counts.Rows[0]["FilteredCount"]);
                }

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

                gvBorrows.DataSource = records;
                gvBorrows.DataBind();

                int firstRecord = filteredCount == 0
                    ? 0
                    : (CurrentPage - 1) * PageSize + 1;

                int lastRecord = Math.Min(
                    CurrentPage * PageSize,
                    filteredCount);

                lblResults.Text = string.Format(
                    "Showing {0}–{1} of {2} matching records",
                    firstRecord,
                    lastRecord,
                    filteredCount);

                lblPageInfo.Text = string.Format(
                    "Page {0} of {1}",
                    CurrentPage,
                    TotalPages);

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

                ShowError(
                    "Unable to load borrowings: " +
                    ex.Message);
            }
        }

        // ==========================================
        // PAGINATION
        // ==========================================

        protected void btnPrevious_Click(
            object sender, EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadBorrows();
            }
        }

        protected void btnNext_Click(
            object sender, EventArgs e)
        {
            if (CurrentPage < TotalPages)
            {
                CurrentPage++;
                LoadBorrows();
            }
        }

        // ==========================================
        // GRID ACTIONS
        // ==========================================

        protected void gvBorrows_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (!IsCustomer())
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (e.CommandName != "RequestReturn" &&
                e.CommandName != "CancelReservation")
            {
                return;
            }

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

            if (e.CommandName == "CancelReservation")
            {
                GridViewRow row = null;

                Control source =
                    e.CommandSource as Control;

                if (source != null)
                {
                    row = source.NamingContainer
                        as GridViewRow;
                }

                if (row == null)
                {
                    ShowError(
                        "Unable to identify the reservation.");
                    return;
                }

                TextBox txtReason =
                    row.FindControl("txtCancellationReason")
                    as TextBox;

                string reason = txtReason == null
                    ? ""
                    : (txtReason.Text ?? "").Trim();

                CancelReservation(borrowLogID, reason);
            }
        }

        // ==========================================
        // CANCEL PENDING RESERVATION
        // ==========================================

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
                        GetUserID();

                    cmd.Parameters.Add(
                        "@CancellationReason",
                        SqlDbType.NVarChar, 500).Value =
                        string.IsNullOrWhiteSpace(reason)
                            ? (object)DBNull.Value
                            : reason;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadBorrows();

                ShowSuccess(
                    "Reservation #" + borrowLogID +
                    " was cancelled successfully. " +
                    "One book copy is available again.");
            }
            catch (SqlException ex)
            {
                LoadBorrows();
                ShowError(ex.Message);
            }
            catch (Exception ex)
            {
                LoadBorrows();

                ShowError(
                    "Unable to cancel reservation: " +
                    ex.Message);
            }
        }

        // ==========================================
        // REQUEST RETURN
        // ==========================================

        private void RequestReturn(int borrowLogID)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebRequestReturn", con))
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
                        GetUserID();

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadBorrows();

                ShowSuccess(
                    "Return request submitted. " +
                    "Please bring the physical book " +
                    "to the librarian for confirmation.");
            }
            catch (SqlException ex)
            {
                LoadBorrows();
                ShowError(ex.Message);
            }
            catch (Exception ex)
            {
                LoadBorrows();

                ShowError(
                    "Unable to request return: " +
                    ex.Message);
            }
        }

        // ==========================================
        // DISPLAY HELPERS
        // ==========================================

        protected string FormatDate(object value)
        {
            if (value == null ||
                value == DBNull.Value)
            {
                return "Not assigned";
            }

            DateTime date;

            if (DateTime.TryParse(
                Convert.ToString(value), out date))
            {
                return date.ToString("MMM dd, yyyy");
            }

            return "Not assigned";
        }

        protected string GetCollectionDisplay(
            object collectionValue,
            object statusValue)
        {
            string collection =
                Convert.ToString(collectionValue);

            string status =
                Convert.ToString(statusValue);

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
            object collectionValue,
            object statusValue)
        {
            string collection =
                Convert.ToString(collectionValue);

            string status =
                Convert.ToString(statusValue);

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
            object dateValue,
            object statusValue)
        {
            DateTime dueDate;

            if (dateValue == null ||
                dateValue == DBNull.Value ||
                !DateTime.TryParse(
                    Convert.ToString(dateValue),
                    out dueDate))
            {
                return "";
            }

            string status =
                Convert.ToString(statusValue);

            if (dueDate.Date < DateTime.Today &&
                status != "Returned" &&
                status != "Cancelled")
            {
                return "el-records-due-overdue";
            }

            return "";
        }

        // ==========================================
        // NAVIGATION
        // ==========================================

        protected void btnHistory_Click(
            object sender, EventArgs e)
        {
            Response.Redirect(
                "~/Customer/BorrowHistory.aspx");
        }

        // ==========================================
        // MESSAGES
        // ==========================================

        private void ShowError(string message)
        {
            lblMessage.CssClass =
                "el-records-message error";

            lblMessage.Text =
                Server.HtmlEncode(message);
        }

        private void ShowSuccess(string message)
        {
            lblMessage.CssClass =
                "el-records-message success";

            lblMessage.Text =
                Server.HtmlEncode(message);
        }
    }
}
