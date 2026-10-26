
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary.Admin.Transactions
{
    public partial class CollectDeposits : Page
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

        private int AdminUserID
        {
            get
            {
                int id;

                return int.TryParse(
                    Convert.ToString(Session["UserID"]),
                    out id) && id > 0
                    ? id
                    : 0;
            }
        }

        private int SelectedBorrowID
        {
            get
            {
                return Convert.ToInt32(
                    ViewState["SelectedBorrowID"] ?? 0);
            }
            set
            {
                ViewState["SelectedBorrowID"] = value;
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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session) ||
                AdminUserID <= 0)
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                AppliedSearch = "";
                AppliedStatus = "All";
                CurrentPage = 1;
                SelectedBorrowID = 0;

                LoadDeposits();
            }
            else if (SelectedBorrowID > 0)
            {
                pnlSelected.Visible = true;
            }
        }

        private SqlCommand Procedure(
            string name,
            SqlConnection connection)
        {
            SqlCommand command =
                new SqlCommand(name, connection);

            command.CommandType =
                CommandType.StoredProcedure;

            command.CommandTimeout = 30;

            return command;
        }

        public string Peso(object value)
        {
            decimal amount =
                value == null || value == DBNull.Value
                ? 0m
                : Convert.ToDecimal(value);

            return "₱" + amount.ToString(
                "N2",
                CultureInfo.GetCultureInfo("en-PH"));
        }

        public string DisplayDate(object value)
        {
            if (value == null || value == DBNull.Value)
                return "Not assigned";

            return Convert.ToDateTime(value).ToString(
                "MMM dd, yyyy hh:mm tt");
        }

        private void ShowMessage(
            string message,
            bool success)
        {
            lblMessage.Text =
                HttpUtility.HtmlEncode(message);

            lblMessage.CssClass =
                success
                ? "dp-message success"
                : "dp-message error";

            lblMessage.Visible = true;
        }

        private void ShowActionMessage(
            string message,
            bool success)
        {
            lblActionMessage.Text =
                HttpUtility.HtmlEncode(message);

            lblActionMessage.CssClass =
                success
                ? "dp-message success"
                : "dp-message error";

            lblActionMessage.Visible = true;
            pnlSelected.Visible = true;
        }

        private void LoadDeposits()
        {
            try
            {
                DataSet data = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    Procedure(
                        "dbo.ESecurityDeposit_WebAdminSearch",
                        con))
                {
                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value = AdminUserID;

                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar, 255).Value =
                        string.IsNullOrWhiteSpace(AppliedSearch)
                        ? (object)DBNull.Value
                        : AppliedSearch;

                    cmd.Parameters.Add(
                        "@Status",
                        SqlDbType.VarChar, 20).Value =
                        AppliedStatus;

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
                        adapter.Fill(data);
                    }
                }

                if (data.Tables.Count < 2)
                    throw new InvalidOperationException(
                        "Deposit search returned incomplete results.");

                int count = 0;

                if (data.Tables[0].Rows.Count > 0)
                {
                    count = Convert.ToInt32(
                        data.Tables[0].Rows[0]["FilteredCount"]);
                }

                TotalPages = Math.Max(
                    1,
                    (int)Math.Ceiling(
                        count / (double)PageSize));

                if (CurrentPage > TotalPages)
                {
                    CurrentPage = TotalPages;
                    LoadDeposits();
                    return;
                }

                gvDeposits.DataSource = data.Tables[1];
                gvDeposits.DataBind();

                int first =
                    count == 0
                    ? 0
                    : (CurrentPage - 1) * PageSize + 1;

                int last = Math.Min(
                    CurrentPage * PageSize,
                    count);

                lblCount.Text = string.Format(
                    "Showing {0}–{1} of {2} reservations",
                    first, last, count);

                lblPage.Text = string.Format(
                    "Page {0} of {1}",
                    CurrentPage, TotalPages);

                btnPrevious.Visible = TotalPages > 1;
                btnNext.Visible = TotalPages > 1;

                btnPrevious.Enabled = CurrentPage > 1;
                btnNext.Enabled = CurrentPage < TotalPages;
            }
            catch (Exception)
            {
                gvDeposits.DataSource = null;
                gvDeposits.DataBind();

                lblCount.Text =
                    "Unable to load online reservations.";

                ShowMessage(
                    "Deposit search failed. Check the V2 " +
                    "stored procedures and database connection.",
                    false);
            }
        }

        protected void btnApply_Click(
            object sender,
            EventArgs e)
        {
            AppliedSearch =
                (txtSearch.Text ?? "").Trim();

            AppliedStatus = ddlStatus.SelectedValue;

            CurrentPage = 1;
            ClearSelection();
            LoadDeposits();
        }

        protected void btnClear_Click(
            object sender,
            EventArgs e)
        {
            txtSearch.Text = "";
            ddlStatus.SelectedValue = "All";

            AppliedSearch = "";
            AppliedStatus = "All";
            CurrentPage = 1;

            ClearSelection();
            LoadDeposits();
        }

        protected void btnRefresh_Click(
            object sender,
            EventArgs e)
        {
            ClearSelection();
            LoadDeposits();
        }

        protected void btnPrevious_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage > 1)
                CurrentPage--;

            ClearSelection();
            LoadDeposits();
        }

        protected void btnNext_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage < TotalPages)
                CurrentPage++;

            ClearSelection();
            LoadDeposits();
        }

        protected void gvDeposits_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (e.CommandName != "SelectDeposit")
                return;

            int borrowLogID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out borrowLogID) ||
                borrowLogID <= 0)
            {
                ShowMessage(
                    "Invalid reservation selection.",
                    false);
                return;
            }

            SelectedBorrowID = borrowLogID;

            ddlPaymentMethod.SelectedIndex = 0;
            txtReference.Text = "";
            chkConfirmed.Checked = false;
            lblActionMessage.Visible = false;

            LoadSelectedDeposit();
        }

        // All details originate from a stored procedure.
        private DataRow GetDepositDetails(int borrowLogID)
        {
            DataTable table = new DataTable();

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                Procedure(
                    "dbo.ESecurityDeposit_WebAdminOne",
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
                    "Reservation deposit was not found.");
            }

            return table.Rows[0];
        }

        private void LoadSelectedDeposit()
        {
            pnlDepositForm.Visible = false;
            lnkPayFee.Visible = false;

            if (SelectedBorrowID <= 0)
            {
                ClearSelection();
                return;
            }

            try
            {
                DataRow record =
                    GetDepositDetails(SelectedBorrowID);

                lblBorrowID.Text =
                    Convert.ToString(record["BorrowLogID"]);

                lblCustomer.Text =
                    HttpUtility.HtmlEncode(
                        Convert.ToString(record["FullName"]));

                lblBook.Text =
                    HttpUtility.HtmlEncode(
                        Convert.ToString(record["Title"]));

                lblDepositStatus.Text =
                    HttpUtility.HtmlEncode(
                        Convert.ToString(record["DepositStatus"]));

                lblDepositAmount.Text =
                    Peso(record["AmountRequired"]);

                lblFeeBalance.Text =
                    Peso(record["FeeBalance"]);

                lblExpiry.Text =
                    DisplayDate(
                        record["ReservationExpiresAt"]);

                bool canCollect =
                    Convert.ToBoolean(
                        record["CanCollectDeposit"]);

                decimal feeBalance =
                    Convert.ToDecimal(record["FeeBalance"]);

                int receiptID = 0;

                if (record["ReceiptID"] != DBNull.Value)
                {
                    receiptID =
                        Convert.ToInt32(record["ReceiptID"]);
                }

                // Existing V1 payment page, connected to V2.
                if (receiptID > 0 && feeBalance > 0)
                {
                    lnkPayFee.NavigateUrl =
                        "~/Admin/Transactions/PayTransactions.aspx" +
                        "?ReceiptID=" + receiptID;

                    lnkPayFee.Visible = true;
                }

                pnlDepositForm.Visible = canCollect;

                if (!canCollect)
                {
                    ShowActionMessage(
                        "This deposit cannot be collected. " +
                        "It may already be held or the " +
                        "reservation may have expired.",
                        false);
                }

                pnlSelected.Visible = true;
            }
            catch (Exception)
            {
                ClearSelection();

                ShowMessage(
                    "Unable to retrieve the selected " +
                    "deposit. Refresh the reservation list.",
                    false);
            }
        }

        protected void btnCollect_Click(
            object sender,
            EventArgs e)
        {
            if (SelectedBorrowID <= 0)
            {
                ShowActionMessage(
                    "Select a reservation first.",
                    false);
                return;
            }

            string method =
                ddlPaymentMethod.SelectedValue;

            if (method != "Cash" &&
                method != "GCash" &&
                method != "Card" &&
                method != "Bank Transfer")
            {
                ShowActionMessage(
                    "Select a valid deposit payment method.",
                    false);
                return;
            }

            string reference =
                (txtReference.Text ?? "").Trim();

            if (reference.Length > 100)
            {
                ShowActionMessage(
                    "Payment reference must not exceed " +
                    "100 characters.",
                    false);
                return;
            }

            if (method != "Cash" &&
                reference.Length == 0)
            {
                ShowActionMessage(
                    "Enter the verified transaction " +
                    "reference for non-cash payments.",
                    false);
                return;
            }

            if (!chkConfirmed.Checked)
            {
                ShowActionMessage(
                    "Confirm that the deposit has actually " +
                    "been received.",
                    false);
                return;
            }

            int borrowID = SelectedBorrowID;

            // Recheck the current deposit state through SQL.
            try
            {
                DataRow record = GetDepositDetails(borrowID);

                if (!Convert.ToBoolean(
                    record["CanCollectDeposit"]))
                {
                    LoadSelectedDeposit();

                    ShowActionMessage(
                        "This reservation is no longer " +
                        "eligible for deposit collection.",
                        false);
                    return;
                }
            }
            catch (Exception)
            {
                ShowActionMessage(
                    "Unable to verify the latest deposit state.",
                    false);
                return;
            }

            try
            {
                int transactionID = 0;
                decimal amountCollected = 0;

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    Procedure(
                        "dbo.ESecurityDeposit_WebCollect",
                        con))
                {
                    cmd.Parameters.Add(
                        "@BorrowLogID",
                        SqlDbType.Int).Value = borrowID;

                    cmd.Parameters.Add(
                        "@PaymentMethod",
                        SqlDbType.VarChar, 30).Value = method;

                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value = AdminUserID;

                    cmd.Parameters.Add(
                        "@ReferenceNo",
                        SqlDbType.VarChar, 100).Value =
                        reference.Length == 0
                        ? (object)DBNull.Value
                        : reference;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            throw new InvalidOperationException(
                                "No deposit confirmation returned.");
                        }

                        transactionID = Convert.ToInt32(
                            reader["DepositTransactionID"]);

                        amountCollected = Convert.ToDecimal(
                            reader["AmountCollected"]);
                    }
                }

                ClearSelection();
                LoadDeposits();

                ShowMessage(
                    "Security deposit of " +
                    Peso(amountCollected) +
                    " recorded for borrowing #" +
                    borrowID +
                    ". Deposit transaction #" +
                    transactionID +
                    ". The deposit is now held separately " +
                    "from borrowing-fee revenue.",
                    true);
            }
            catch (SqlException ex)
            {
                // Known SQL rejection: transaction procedure
                // handles rollback internally.
                LoadSelectedDeposit();

                ShowActionMessage(
                    "Deposit collection rejected: " +
                    ex.Message,
                    false);
            }
            catch (Exception)
            {
                // Do not automatically retry on an ambiguous
                // connection or response failure.
                pnlDepositForm.Visible = false;

                ShowActionMessage(
                    "The payment result could not be confirmed. " +
                    "Review deposit transactions before retrying.",
                    false);
            }
        }

        protected void btnClose_Click(
            object sender,
            EventArgs e)
        {
            ClearSelection();
        }

        private void ClearSelection()
        {
            SelectedBorrowID = 0;

            pnlSelected.Visible = false;
            pnlDepositForm.Visible = false;
            lnkPayFee.Visible = false;

            lblActionMessage.Visible = false;

            ddlPaymentMethod.SelectedIndex = 0;
            txtReference.Text = "";
            chkConfirmed.Checked = false;

            lblBorrowID.Text = "";
            lblCustomer.Text = "";
            lblBook.Text = "";
            lblDepositStatus.Text = "";
            lblDepositAmount.Text = "";
            lblFeeBalance.Text = "";
            lblExpiry.Text = "";
        }
    }
}
