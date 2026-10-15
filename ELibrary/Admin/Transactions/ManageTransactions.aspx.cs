
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

                return Session["UserID"] != null &&
                    int.TryParse(
                        Convert.ToString(Session["UserID"]),
                        out id)
                    ? id
                    : 0;
            }
        }

        // ==========================================
        // HISTORY SEARCH STATE
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
        // UNPAID SEARCH STATE
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
        // SELECTED RECEIPT
        // ==========================================

        private int SelectedReceiptID
        {
            get { return (int)(ViewState["SelectedReceiptID"] ?? 0); }
            set { ViewState["SelectedReceiptID"] = value; }
        }

        // ==========================================
        // PAGE LOAD
        // ==========================================

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session) ||
                AdminUserID <= 0)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadFeeTypes();
                LoadTransactions();
                LoadUnpaidFees();
            }

            hfFocusTarget.Value = "";
        }

        // ==========================================
        // LOCAL MESSAGES
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
            hfFocusTarget.Value = target;
        }

        private void FocusSection(string target)
        {
            if (string.IsNullOrEmpty(hfFocusTarget.Value))
            {
                hfFocusTarget.Value = target;
            }
        }

        // ==========================================
        // FEE TYPE FILTER OPTIONS
        // ==========================================

        private void LoadFeeTypes()
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                {
                    con.Open();

                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT DISTINCT FeeType
                          FROM dbo.EReceipt
                          WHERE FeeType IS NOT NULL
                            AND LTRIM(RTRIM(FeeType)) <> ''
                          ORDER BY FeeType;", con))
                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string feeType =
                                Convert.ToString(reader["FeeType"]);

                            ddlHistoryFee.Items.Add(
                                new ListItem(feeType, feeType));
                        }
                    }

                    using (SqlCommand cmd = new SqlCommand(
                        @"SELECT DISTINCT FeeType
                          FROM dbo.EReceipt
                          WHERE Balance > 0
                            AND FeeType IS NOT NULL
                            AND LTRIM(RTRIM(FeeType)) <> ''
                          ORDER BY FeeType;", con))
                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string feeType =
                                Convert.ToString(reader["FeeType"]);

                            ddlUnpaidFee.Items.Add(
                                new ListItem(feeType, feeType));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Unable to load fee types: " +
                    ex.Message,
                    MessageArea.Transactions);
            }
        }

        // ==========================================
        // LOAD TRANSACTION HISTORY
        // ==========================================

        private void LoadTransactions()
        {
            try
            {
                DataSet ds = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EReceipt_WebAdminSearch", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar, 255).Value =
                        DbValue(HistorySearch);

                    cmd.Parameters.Add(
                        "@FeeType",
                        SqlDbType.VarChar, 50).Value =
                        DbValue(HistoryFee);

                    cmd.Parameters.Add(
                        "@PaymentMethod",
                        SqlDbType.VarChar, 30).Value =
                        DbValue(HistoryMethod);

                    cmd.Parameters.Add(
                        "@Sort",
                        SqlDbType.VarChar, 20).Value =
                        HistorySort;

                    cmd.Parameters.Add(
                        "@PageNumber",
                        SqlDbType.Int).Value =
                        HistoryPage;

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
                        "Transaction search returned incomplete data.");
                }

                int count = ReadFilteredCount(ds);

                HistoryTotalPages =
                    CalculateTotalPages(count);

                if (HistoryPage > HistoryTotalPages)
                {
                    HistoryPage = HistoryTotalPages;
                    LoadTransactions();
                    return;
                }

                gvTransactions.DataSource =
                    ds.Tables[1];

                gvTransactions.DataBind();

                lblHistoryCount.Text =
                    BuildCountText(
                        count,
                        HistoryPage,
                        "transactions");

                lblHistoryPage.Text = string.Format(
                    "Page {0} of {1}",
                    HistoryPage,
                    HistoryTotalPages);

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
        // LOAD UNPAID FEES
        // ==========================================

        private void LoadUnpaidFees()
        {
            try
            {
                DataSet ds = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EReceipt_WebAdminUnpaidSearch", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar, 255).Value =
                        DbValue(UnpaidSearch);

                    cmd.Parameters.Add(
                        "@FeeType",
                        SqlDbType.VarChar, 50).Value =
                        DbValue(UnpaidFee);

                    cmd.Parameters.Add(
                        "@Sort",
                        SqlDbType.VarChar, 20).Value =
                        UnpaidSort;

                    cmd.Parameters.Add(
                        "@PageNumber",
                        SqlDbType.Int).Value =
                        UnpaidPage;

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
                        "Unpaid fee search returned incomplete data.");
                }

                int count = ReadFilteredCount(ds);

                UnpaidTotalPages =
                    CalculateTotalPages(count);

                if (UnpaidPage > UnpaidTotalPages)
                {
                    UnpaidPage = UnpaidTotalPages;
                    LoadUnpaidFees();
                    return;
                }

                gvUnpaid.DataSource = ds.Tables[1];
                gvUnpaid.DataBind();

                lblUnpaidCount.Text =
                    BuildCountText(
                        count,
                        UnpaidPage,
                        "unpaid fees");

                lblUnpaidPage.Text = string.Format(
                    "Page {0} of {1}",
                    UnpaidPage,
                    UnpaidTotalPages);

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
        // INDIVIDUAL PAYMENT HISTORY
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
                DataTable dt = new DataTable();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand(
                    "EReceiptPaymentHistory_WebAdminByReceipt",
                    con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@ReceiptID",
                        SqlDbType.Int).Value =
                        SelectedReceiptID;

                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value =
                        AdminUserID;

                    using (SqlDataAdapter da =
                        new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }

                gvPaymentHistory.DataSource = dt;
                gvPaymentHistory.DataBind();

                lblSelectedReceipt.Text =
                    "Receipt ID: " + SelectedReceiptID;

                lblPaymentHistoryMessage.Text =
                    dt.Rows.Count == 0
                    ? "No individual payments have been recorded for this receipt."
                    : string.Format(
                        "{0} individual payment(s) recorded.",
                        dt.Rows.Count);

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

        protected void btnViewHistory_Command(
            object sender,
            CommandEventArgs e)
        {
            if (e.CommandName != "ViewPayments")
            {
                return;
            }

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
        // TRANSACTION SEARCH EVENTS
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
            {
                HistoryPage--;
            }

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
            {
                HistoryPage++;
            }

            LoadTransactions();
            LoadUnpaidFees();
            LoadPaymentHistory();

            FocusSection("transactionHistory");
        }

        // ==========================================
        // UNPAID SEARCH EVENTS
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
            {
                UnpaidPage--;
            }

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
            {
                UnpaidPage++;
            }

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
            {
                return;
            }

            if (!AdminHelper.IsAdmin(Session) ||
                AdminUserID <= 0)
            {
                Response.Redirect("~/Login.aspx");
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
                "~/Admin/Transactions/PayTransactions.aspx?ReceiptID="
                + receiptID);
        }

        // ==========================================
        // UTILITY METHODS
        // ==========================================

        private object DbValue(string value)
        {
            return string.IsNullOrWhiteSpace(value)
                ? (object)DBNull.Value
                : value.Trim();
        }

        private int ReadFilteredCount(DataSet ds)
        {
            if (ds.Tables[0].Rows.Count == 0)
            {
                return 0;
            }

            return Convert.ToInt32(
                ds.Tables[0].Rows[0]["FilteredCount"]);
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
