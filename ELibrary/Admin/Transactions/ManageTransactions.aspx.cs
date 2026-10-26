
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ELibrary.Admin.Transactions
{
    public partial class ManageTransactions : System.Web.UI.Page
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
                    out id) && id > 0 ? id : 0;
            }
        }

        // ==========================================
        // HISTORY FILTER STATE
        // ==========================================

        private string HistorySearch
        {
            get { return (string)(ViewState["HistorySearch"] ?? ""); }
            set { ViewState["HistorySearch"] = value; }
        }

        private string HistoryFee
        {
            get { return (string)(ViewState["HistoryFee"] ?? ""); }
            set { ViewState["HistoryFee"] = value; }
        }

        private string HistoryMethod
        {
            get { return (string)(ViewState["HistoryMethod"] ?? ""); }
            set { ViewState["HistoryMethod"] = value; }
        }

        private string HistorySort
        {
            get { return (string)(ViewState["HistorySort"] ?? "Default"); }
            set { ViewState["HistorySort"] = value; }
        }

        private int HistoryPage
        {
            get { return (int)(ViewState["HistoryPage"] ?? 1); }
            set { ViewState["HistoryPage"] = value; }
        }

        private int HistoryTotalPages
        {
            get { return (int)(ViewState["HistoryTotalPages"] ?? 1); }
            set { ViewState["HistoryTotalPages"] = value; }
        }

        // ==========================================
        // UNPAID FILTER STATE
        // ==========================================

        private string UnpaidSearch
        {
            get { return (string)(ViewState["UnpaidSearch"] ?? ""); }
            set { ViewState["UnpaidSearch"] = value; }
        }

        private string UnpaidFee
        {
            get { return (string)(ViewState["UnpaidFee"] ?? ""); }
            set { ViewState["UnpaidFee"] = value; }
        }

        private string UnpaidSort
        {
            get { return (string)(ViewState["UnpaidSort"] ?? "Default"); }
            set { ViewState["UnpaidSort"] = value; }
        }

        private int UnpaidPage
        {
            get { return (int)(ViewState["UnpaidPage"] ?? 1); }
            set { ViewState["UnpaidPage"] = value; }
        }

        private int UnpaidTotalPages
        {
            get { return (int)(ViewState["UnpaidTotalPages"] ?? 1); }
            set { ViewState["UnpaidTotalPages"] = value; }
        }

        // ==========================================
        // SELECTED PAYMENT HISTORY
        // ==========================================

        private int SelectedReceiptID
        {
            get { return (int)(ViewState["SelectedReceiptID"] ?? 0); }
            set { ViewState["SelectedReceiptID"] = value; }
        }

        // ==========================================
        // PAGE INITIALIZATION
        // ==========================================

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
                LoadFeeTypes();
                LoadTransactions();
                LoadUnpaidFees();

                string paymentSuccess = Session["PaymentSuccessMessage"] as string;
                Session.Remove("PaymentSuccessMessage");
                if (!string.IsNullOrWhiteSpace(paymentSuccess))
                    ShowMessage(paymentSuccess, MessageArea.Transactions);
            }

            hfFocusTarget.Value = "";
        }

        // ==========================================
        // MESSAGES
        // ==========================================

        private enum MessageArea
        {
            Transactions,
            Unpaid,
            PaymentDetails
        }

        private void ShowMessage(
            string message,
            MessageArea area)
        {
            Label label;
            string target;

            switch (area)
            {
                case MessageArea.Unpaid:
                    label = lblUnpaidMessage;
                    target = "unpaidFees";
                    break;

                case MessageArea.PaymentDetails:
                    label = lblPaymentDetailsMessage;
                    target = "pnlPaymentHistory";
                    break;

                default:
                    label = lblMessage;
                    target = "transactionHistory";
                    break;
            }

            label.Text = Server.HtmlEncode(message);
            label.CssClass = "fn-message error";

            FocusSection(target);
        }

        private void FocusSection(string target)
        {
            if (string.IsNullOrEmpty(hfFocusTarget.Value))
            {
                hfFocusTarget.Value = target;
            }
        }

        private SqlCommand Procedure(
            string name,
            SqlConnection connection)
        {
            SqlCommand command =
                new SqlCommand(name, connection);

            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 30;

            return command;
        }

        // ==========================================
        // FEE TYPES — STORED PROCEDURE ONLY
        // ==========================================

        private void LoadFeeTypes()
        {
            try
            {
                DataSet data = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd = Procedure(
                    "dbo.EReceipt_WebAdminFeeTypes", con))
                {
                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value = AdminUserID;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(data);
                    }
                }

                if (data.Tables.Count != 2)
                {
                    throw new InvalidOperationException(
                        "Fee filter procedure must return two result sets.");
                }

                ddlHistoryFee.Items.Clear();
                ddlHistoryFee.Items.Add(
                    new ListItem("All Fee Types", ""));

                foreach (DataRow row in data.Tables[0].Rows)
                {
                    string feeType =
                        Convert.ToString(row["FeeType"]);

                    ddlHistoryFee.Items.Add(
                        new ListItem(feeType, feeType));
                }

                ddlUnpaidFee.Items.Clear();
                ddlUnpaidFee.Items.Add(
                    new ListItem("All Fee Types", ""));

                foreach (DataRow row in data.Tables[1].Rows)
                {
                    string feeType =
                        Convert.ToString(row["FeeType"]);

                    ddlUnpaidFee.Items.Add(
                        new ListItem(feeType, feeType));
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to load fee types: " + ex.Message,
                    MessageArea.Transactions);
            }
        }

        // ==========================================
        // TRANSACTION HISTORY — SERVER PAGINATION
        // ==========================================

        private void LoadTransactions()
        {
            try
            {
                DataSet data = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd = Procedure(
                    "dbo.EReceipt_WebAdminSearch", con))
                {
                    cmd.Parameters.Add(
                        "@Search", SqlDbType.VarChar, 255)
                        .Value = DbValue(HistorySearch);

                    cmd.Parameters.Add(
                        "@FeeType", SqlDbType.VarChar, 50)
                        .Value = DbValue(HistoryFee);

                    cmd.Parameters.Add(
                        "@PaymentMethod", SqlDbType.VarChar, 30)
                        .Value = DbValue(HistoryMethod);

                    cmd.Parameters.Add(
                        "@Sort", SqlDbType.VarChar, 20)
                        .Value = HistorySort;

                    cmd.Parameters.Add(
                        "@PageNumber", SqlDbType.Int)
                        .Value = HistoryPage;

                    cmd.Parameters.Add(
                        "@PageSize", SqlDbType.Int)
                        .Value = PageSize;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(data);
                    }
                }

                if (data.Tables.Count < 2)
                {
                    throw new InvalidOperationException(
                        "Transaction search returned incomplete data.");
                }

                int count = ReadFilteredCount(data);
                HistoryTotalPages = CalculateTotalPages(count);

                if (HistoryPage > HistoryTotalPages)
                {
                    HistoryPage = HistoryTotalPages;
                    LoadTransactions();
                    return;
                }

                gvTransactions.DataSource = data.Tables[1];
                gvTransactions.DataBind();

                lblHistoryCount.Text = BuildCountText(
                    count, HistoryPage, "transactions");

                lblHistoryPage.Text = string.Format(
                    "Page {0} of {1}",
                    HistoryPage, HistoryTotalPages);

                btnHistoryPrevious.Visible =
                    HistoryTotalPages > 1;

                btnHistoryNext.Visible =
                    HistoryTotalPages > 1;

                btnHistoryPrevious.Enabled =
                    HistoryPage > 1;

                btnHistoryNext.Enabled =
                    HistoryPage < HistoryTotalPages;
            }
            catch (Exception ex)
            {
                gvTransactions.DataSource = null;
                gvTransactions.DataBind();

                lblHistoryCount.Text =
                    "Unable to load transactions.";

                btnHistoryPrevious.Visible = false;
                btnHistoryNext.Visible = false;

                ShowMessage(
                    "Unable to load transactions: " +
                    ex.Message,
                    MessageArea.Transactions);
            }
        }

        // ==========================================
        // OUTSTANDING FEES — SERVER PAGINATION
        // ==========================================

        private void LoadUnpaidFees()
        {
            try
            {
                DataSet data = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd = Procedure(
                    "dbo.EReceipt_WebAdminUnpaidSearch", con))
                {
                    cmd.Parameters.Add(
                        "@Search", SqlDbType.VarChar, 255)
                        .Value = DbValue(UnpaidSearch);

                    cmd.Parameters.Add(
                        "@FeeType", SqlDbType.VarChar, 50)
                        .Value = DbValue(UnpaidFee);

                    cmd.Parameters.Add(
                        "@Sort", SqlDbType.VarChar, 20)
                        .Value = UnpaidSort;

                    cmd.Parameters.Add(
                        "@PageNumber", SqlDbType.Int)
                        .Value = UnpaidPage;

                    cmd.Parameters.Add(
                        "@PageSize", SqlDbType.Int)
                        .Value = PageSize;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(data);
                    }
                }

                if (data.Tables.Count < 2)
                {
                    throw new InvalidOperationException(
                        "Unpaid fee search returned incomplete data.");
                }

                int count = ReadFilteredCount(data);
                UnpaidTotalPages = CalculateTotalPages(count);

                if (UnpaidPage > UnpaidTotalPages)
                {
                    UnpaidPage = UnpaidTotalPages;
                    LoadUnpaidFees();
                    return;
                }

                gvUnpaid.DataSource = data.Tables[1];
                gvUnpaid.DataBind();

                lblUnpaidCount.Text = BuildCountText(
                    count, UnpaidPage, "unpaid fees");

                lblUnpaidPage.Text = string.Format(
                    "Page {0} of {1}",
                    UnpaidPage, UnpaidTotalPages);

                btnUnpaidPrevious.Visible =
                    UnpaidTotalPages > 1;

                btnUnpaidNext.Visible =
                    UnpaidTotalPages > 1;

                btnUnpaidPrevious.Enabled =
                    UnpaidPage > 1;

                btnUnpaidNext.Enabled =
                    UnpaidPage < UnpaidTotalPages;
            }
            catch (Exception ex)
            {
                gvUnpaid.DataSource = null;
                gvUnpaid.DataBind();

                lblUnpaidCount.Text =
                    "Unable to load unpaid fees.";

                btnUnpaidPrevious.Visible = false;
                btnUnpaidNext.Visible = false;

                ShowMessage(
                    "Unable to load unpaid fees: " +
                    ex.Message,
                    MessageArea.Unpaid);
            }
        }

        // ==========================================
        // INDIVIDUAL RECEIPT PAYMENT HISTORY
        // ==========================================

        private void LoadPaymentHistory()
        {
            if (SelectedReceiptID <= 0)
            {
                pnlPaymentHistory.Visible = false;
                return;
            }

            try
            {
                DataTable table = new DataTable();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd = Procedure(
                    "dbo.EReceiptPaymentHistory_WebAdminByReceipt",
                    con))
                {
                    cmd.Parameters.Add(
                        "@ReceiptID", SqlDbType.Int)
                        .Value = SelectedReceiptID;

                    cmd.Parameters.Add(
                        "@AdminUserID", SqlDbType.Int)
                        .Value = AdminUserID;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(table);
                    }
                }

                gvPaymentHistory.DataSource = table;
                gvPaymentHistory.DataBind();

                lblSelectedReceipt.Text =
                    "Receipt ID: " + SelectedReceiptID;

                lblPaymentHistoryMessage.Text =
                    table.Rows.Count == 0
                    ? "No individual payments have been recorded for this receipt."
                    : string.Format(
                        "{0} individual payment(s) recorded.",
                        table.Rows.Count);

                pnlPaymentHistory.Visible = true;
            }
            catch (Exception ex)
            {
                gvPaymentHistory.DataSource = null;
                gvPaymentHistory.DataBind();

                lblSelectedReceipt.Text =
                    "Receipt ID: " + SelectedReceiptID;

                lblPaymentHistoryMessage.Text = "";
                pnlPaymentHistory.Visible = true;

                ShowMessage(
                    "Unable to load payment history: " +
                    ex.Message,
                    MessageArea.PaymentDetails);
            }
        }

        // ==========================================
        // PAYMENT HISTORY BUTTONS
        // ==========================================

        protected void btnViewHistory_Command(
            object sender,
            CommandEventArgs e)
        {
            if (e.CommandName != "ViewPayments")
                return;

            int receiptID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out receiptID) || receiptID <= 0)
            {
                ShowMessage(
                    "Invalid receipt ID.",
                    MessageArea.Transactions);
                return;
            }

            SelectedReceiptID = receiptID;

            LoadTransactions();
            LoadUnpaidFees();
            LoadPaymentHistory();

            FocusSection("pnlPaymentHistory");
        }

        protected void btnClosePaymentHistory_Click(
            object sender,
            EventArgs e)
        {
            SelectedReceiptID = 0;
            pnlPaymentHistory.Visible = false;

            LoadTransactions();
            LoadUnpaidFees();

            FocusSection("transactionHistory");
        }

        // ==========================================
        // HISTORY FILTER ACTIONS
        // ==========================================

        protected void btnHistoryApply_Click(
            object sender,
            EventArgs e)
        {
            HistorySearch =
                (txtHistorySearch.Text ?? "").Trim();

            HistoryFee =
                ddlHistoryFee.SelectedValue;

            HistoryMethod =
                ddlHistoryMethod.SelectedValue;

            HistorySort =
                ddlHistorySort.SelectedValue;

            HistoryPage = 1;

            LoadTransactions();
            LoadUnpaidFees();
            LoadPaymentHistory();

            FocusSection("transactionHistory");
        }

        protected void btnHistoryClear_Click(
            object sender,
            EventArgs e)
        {
            txtHistorySearch.Text = "";

            ddlHistoryFee.SelectedValue = "";
            ddlHistoryMethod.SelectedValue = "";
            ddlHistorySort.SelectedValue = "Default";

            HistorySearch = "";
            HistoryFee = "";
            HistoryMethod = "";
            HistorySort = "Default";

            HistoryPage = 1;

            LoadTransactions();
            LoadUnpaidFees();
            LoadPaymentHistory();

            FocusSection("transactionHistory");
        }

        protected void btnHistoryPrevious_Click(
            object sender,
            EventArgs e)
        {
            if (HistoryPage > 1)
                HistoryPage--;

            LoadTransactions();
            LoadUnpaidFees();
            LoadPaymentHistory();

            FocusSection("transactionHistory");
        }

        protected void btnHistoryNext_Click(
            object sender,
            EventArgs e)
        {
            if (HistoryPage < HistoryTotalPages)
                HistoryPage++;

            LoadTransactions();
            LoadUnpaidFees();
            LoadPaymentHistory();

            FocusSection("transactionHistory");
        }

        // ==========================================
        // UNPAID FILTER ACTIONS
        // ==========================================

        protected void btnUnpaidApply_Click(
            object sender,
            EventArgs e)
        {
            UnpaidSearch =
                (txtUnpaidSearch.Text ?? "").Trim();

            UnpaidFee =
                ddlUnpaidFee.SelectedValue;

            UnpaidSort =
                ddlUnpaidSort.SelectedValue;

            UnpaidPage = 1;

            LoadTransactions();
            LoadUnpaidFees();
            LoadPaymentHistory();

            FocusSection("unpaidFees");
        }

        protected void btnUnpaidClear_Click(
            object sender,
            EventArgs e)
        {
            txtUnpaidSearch.Text = "";
            ddlUnpaidFee.SelectedValue = "";
            ddlUnpaidSort.SelectedValue = "Default";

            UnpaidSearch = "";
            UnpaidFee = "";
            UnpaidSort = "Default";

            UnpaidPage = 1;

            LoadTransactions();
            LoadUnpaidFees();
            LoadPaymentHistory();

            FocusSection("unpaidFees");
        }

        protected void btnUnpaidPrevious_Click(
            object sender,
            EventArgs e)
        {
            if (UnpaidPage > 1)
                UnpaidPage--;

            LoadTransactions();
            LoadUnpaidFees();
            LoadPaymentHistory();

            FocusSection("unpaidFees");
        }

        protected void btnUnpaidNext_Click(
            object sender,
            EventArgs e)
        {
            if (UnpaidPage < UnpaidTotalPages)
                UnpaidPage++;

            LoadTransactions();
            LoadUnpaidFees();
            LoadPaymentHistory();

            FocusSection("unpaidFees");
        }

        // ==========================================
        // RECORD PAYMENT NAVIGATION
        // ==========================================

        protected void btnPay_Command(
            object sender,
            CommandEventArgs e)
        {
            if (e.CommandName != "PayFee")
                return;

            if (!AdminHelper.IsAdmin(Session) ||
                AdminUserID <= 0)
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            int receiptID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out receiptID) || receiptID <= 0)
            {
                ShowMessage(
                    "Invalid receipt ID.",
                    MessageArea.Unpaid);
                return;
            }

            Response.Redirect(
                "~/Admin/Transactions/PayTransactions.aspx?ReceiptID=" +
                receiptID);
        }

        // ==========================================
        // SHARED UTILITY METHODS
        // ==========================================

        private object DbValue(string value)
        {
            return string.IsNullOrWhiteSpace(value)
                ? (object)DBNull.Value
                : value.Trim();
        }

        private int ReadFilteredCount(DataSet data)
        {
            if (data.Tables[0].Rows.Count == 0)
                return 0;

            return Convert.ToInt32(
                data.Tables[0].Rows[0]["FilteredCount"]);
        }

        private int CalculateTotalPages(int count)
        {
            return Math.Max(
                1,
                (int)Math.Ceiling(
                    count / (double)PageSize));
        }

        private string BuildCountText(
            int count,
            int page,
            string recordType)
        {
            int first = count == 0
                ? 0
                : (page - 1) * PageSize + 1;

            int last = Math.Min(
                page * PageSize,
                count);

            return string.Format(
                "Showing {0}–{1} of {2} {3}",
                first,
                last,
                count,
                recordType);
        }
    }
}
