
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary.Customer
{
    public partial class MyTransactions : Page
    {
        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["ElibraryConnection"]
                    .ConnectionString;
            }
        }

        private int CustomerUserID
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

        private string AppliedMethod
        {
            get
            {
                return (string)(
                    ViewState["AppliedMethod"] ?? "All");
            }
            set
            {
                ViewState["AppliedMethod"] = value;
            }
        }

        private string AppliedSort
        {
            get
            {
                return (string)(
                    ViewState["AppliedSort"] ?? "Newest");
            }
            set
            {
                ViewState["AppliedSort"] = value;
            }
        }

        private int SelectedReceiptID
        {
            get
            {
                return (int)(
                    ViewState["SelectedReceiptID"] ?? 0);
            }
            set
            {
                ViewState["SelectedReceiptID"] = value;
            }
        }

        protected void Page_Load(
            object sender,
            EventArgs e)
        {
            // Register before any GridView data binding.
            gvTransactions.RowDataBound +=
                gvTransactions_RowDataBound;

            if (!IsCustomer())
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadTransactions();
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
                out role) &&
                role == 1 &&
                CustomerUserID > 0;
        }

        private DataTable GetTransactions()
        {
            DataTable dt = new DataTable();

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                new SqlCommand(
                    "EReceipt_WebMyTransactions", con))
            {
                cmd.CommandType =
                    CommandType.StoredProcedure;

                cmd.Parameters.Add(
                    "@UserID",
                    SqlDbType.Int).Value =
                    CustomerUserID;

                using (SqlDataAdapter da =
                    new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }
            }

            return dt;
        }

        private static decimal Money(
            DataRow row,
            string column)
        {
            if (!row.Table.Columns.Contains(column) ||
                row[column] == DBNull.Value)
            {
                return 0m;
            }

            return Convert.ToDecimal(row[column]);
        }

        private static decimal ToDecimal(
            object value)
        {
            return value == null ||
                   value == DBNull.Value
                ? 0m
                : Convert.ToDecimal(value);
        }

        private static bool IsCancelledNoPayment(
            DataRow row)
        {
            if (!row.Table.Columns.Contains(
                "BorrowStatus"))
            {
                return false;
            }

            string borrowStatus =
                Convert.ToString(
                    row["BorrowStatus"]);

            return string.Equals(
                    borrowStatus,
                    "Cancelled",
                    StringComparison.OrdinalIgnoreCase)
                && Money(row, "AmountPaid") == 0m
                && Money(row, "Balance") == 0m;
        }

        private static bool IsCancelledNoPayment(
            DataRowView row)
        {
            return IsCancelledNoPayment(row.Row);
        }

        private static string DisplayPaymentStatus(
            DataRow row)
        {
            if (IsCancelledNoPayment(row))
            {
                return "Cancelled — No payment collected";
            }

            decimal paid = Money(row, "AmountPaid");
            decimal balance = Money(row, "Balance");

            if (balance <= 0m)
            {
                return "Paid";
            }

            return paid > 0m
                ? "Partially Paid"
                : "Unpaid";
        }

        private void LoadTransactions()
        {
            try
            {
                DataTable all = GetTransactions();

                decimal totalPaid = 0m;
                decimal outstanding = 0m;
                int unpaidCount = 0;

                foreach (DataRow row in all.Rows)
                {
                    decimal paid =
                        Money(row, "AmountPaid");

                    decimal balance =
                        Money(row, "Balance");

                    totalPaid += paid;
                    outstanding += balance;

                    if (balance > 0m)
                    {
                        unpaidCount++;
                    }
                }

                lblTransactionCount.Text =
                    all.Rows.Count.ToString("N0");

                lblTotalPaid.Text =
                    totalPaid.ToString("N2");

                lblOutstandingBalance.Text =
                    outstanding.ToString("N2");

                lblUnpaidCount.Text =
                    unpaidCount.ToString("N0");

                string search = AppliedSearch;
                string status = AppliedStatus;
                string method = AppliedMethod;

                var rows = all.AsEnumerable()
                    .Where(row =>
                    {
                        bool matchesSearch =
                            search.Length == 0 ||
                            ContainsText(
                                row, "ReceiptNo", search) ||
                            ContainsText(
                                row, "Title", search) ||
                            ContainsText(
                                row, "FeeType", search);

                        decimal balance =
                            Money(row, "Balance");

                        decimal paid =
                            Money(row, "AmountPaid");

                        bool canceledNoPayment =
                            IsCancelledNoPayment(row);

                        bool matchesStatus =
                            status == "All" ||
                            (
                                status == "Paid" &&
                                balance <= 0m &&
                                !canceledNoPayment
                            ) ||
                            (
                                status == "Unpaid" &&
                                balance > 0m &&
                                paid <= 0m
                            ) ||
                            (
                                status == "Partial" &&
                                balance > 0m &&
                                paid > 0m
                            );

                        string recordedMethod =
                            row["PaymentMethod"] ==
                                DBNull.Value
                            ? ""
                            : Convert.ToString(
                                row["PaymentMethod"]);

                        bool matchesMethod =
                            method == "All" ||
                            (
                                method == "Not Set" &&
                                string.IsNullOrWhiteSpace(
                                    recordedMethod)
                            ) ||
                            string.Equals(
                                method,
                                recordedMethod,
                                StringComparison.OrdinalIgnoreCase);

                        return matchesSearch &&
                               matchesStatus &&
                               matchesMethod;
                    });

                rows = AppliedSort == "Oldest"
                    ? rows.OrderBy(
                            r => DateValue(r))
                          .ThenBy(
                            r => Convert.ToInt32(
                                r["ReceiptID"]))
                    : rows.OrderByDescending(
                            r => DateValue(r))
                          .ThenByDescending(
                            r => Convert.ToInt32(
                                r["ReceiptID"]));

                DataTable filtered = all.Clone();

                foreach (DataRow row in rows)
                {
                    filtered.ImportRow(row);
                }

                int totalPages = Math.Max(
                    1,
                    (
                        filtered.Rows.Count +
                        gvTransactions.PageSize - 1
                    ) / gvTransactions.PageSize);

                if (gvTransactions.PageIndex >=
                    totalPages)
                {
                    gvTransactions.PageIndex = 0;
                }

                gvTransactions.DataSource = filtered;
                gvTransactions.DataBind();

                lblResultCount.Text = string.Format(
                    "Showing {0:N0} of {1:N0} transactions",
                    filtered.Rows.Count,
                    all.Rows.Count);

                lblMessage.Text = "";
            }
            catch (Exception)
            {
                gvTransactions.DataSource = null;
                gvTransactions.DataBind();

                lblMessage.CssClass =
                    "el-records-message error";

                lblMessage.Text =
                    "Unable to load your transaction records.";
            }
        }

        private void gvTransactions_RowDataBound(
            object sender,
            GridViewRowEventArgs e)
        {
            if (e.Row.RowType !=
                DataControlRowType.DataRow)
            {
                return;
            }

            DataRowView data =
                e.Row.DataItem as DataRowView;

            if (data == null ||
                !IsCancelledNoPayment(data))
            {
                return;
            }

            /*
             * Existing ASPX table columns:
             * 0 Receipt
             * 1 Book / Fee
             * 2 Amount Paid
             * 3 Balance
             * 4 Status
             * 5 Method / Date
             *
             * Replace only the rendered status.
             * Do not change underlying amounts.
             */

            if (e.Row.Cells.Count <= 4)
            {
                return;
            }

            TableCell statusCell =
                e.Row.Cells[4];

            statusCell.Controls.Clear();

            Literal statusLabel = new Literal();

            statusLabel.Text =
                "<span class=\"el-tx-status " +
                "el-tx-status-unpaid\">" +
                HttpUtility.HtmlEncode(
                    "Cancelled — No payment collected") +
                "</span>";

            statusCell.Controls.Add(statusLabel);
        }

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
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EReceiptPaymentHistory_WebCustomerByReceipt",
                        con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@ReceiptID",
                        SqlDbType.Int).Value =
                        SelectedReceiptID;

                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value =
                        CustomerUserID;

                    using (SqlDataAdapter da =
                        new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }

                gvPaymentHistory.DataSource = dt;
                gvPaymentHistory.DataBind();

                lblSelectedReceipt.Text =
                    "Receipt ID: " +
                    SelectedReceiptID;

                lblPaymentHistoryMessage.Text =
                    dt.Rows.Count == 0
                    ? "No individual payments have been recorded for this receipt."
                    : string.Format(
                        "{0} individual payment(s) recorded.",
                        dt.Rows.Count);

                pnlPaymentHistory.Visible = true;
            }
            catch (Exception)
            {
                SelectedReceiptID = 0;

                pnlPaymentHistory.Visible = false;

                lblMessage.CssClass =
                    "el-records-message error";

                lblMessage.Text =
                    "Unable to load payment history for this receipt.";
            }
        }

        private static bool ContainsText(
            DataRow row,
            string column,
            string search)
        {
            return row.Table.Columns.Contains(column) &&
                row[column] != DBNull.Value &&
                Convert.ToString(
                    row[column]).IndexOf(
                    search,
                    StringComparison.OrdinalIgnoreCase) >= 0;
        }

        private static DateTime DateValue(
            DataRow row)
        {
            return row["TransactionDate"] ==
                DBNull.Value
                ? DateTime.MinValue
                : Convert.ToDateTime(
                    row["TransactionDate"]);
        }

        protected void btnSearch_Click(
            object sender,
            EventArgs e)
        {
            AppliedSearch =
                (txtSearch.Text ?? "").Trim();

            AppliedStatus =
                ddlStatus.SelectedValue;

            AppliedMethod =
                ddlMethod.SelectedValue;

            AppliedSort =
                ddlSort.SelectedValue;

            gvTransactions.PageIndex = 0;

            LoadTransactions();
            LoadPaymentHistory();
        }

        protected void btnClear_Click(
            object sender,
            EventArgs e)
        {
            txtSearch.Text = "";

            ddlStatus.SelectedValue = "All";
            ddlMethod.SelectedValue = "All";
            ddlSort.SelectedValue = "Newest";

            AppliedSearch = "";
            AppliedStatus = "All";
            AppliedMethod = "All";
            AppliedSort = "Newest";

            gvTransactions.PageIndex = 0;

            LoadTransactions();
            LoadPaymentHistory();
        }

        protected void gvTransactions_PageIndexChanging(
            object sender,
            GridViewPageEventArgs e)
        {
            gvTransactions.PageIndex =
                e.NewPageIndex;

            LoadTransactions();
            LoadPaymentHistory();
        }

        protected void btnViewPayments_Command(
            object sender,
            CommandEventArgs e)
        {
            if (e.CommandName != "ViewPayments")
            {
                return;
            }

            int receiptID;

            if (!int.TryParse(
                Convert.ToString(
                    e.CommandArgument),
                out receiptID) ||
                receiptID <= 0)
            {
                lblMessage.Text =
                    "Invalid receipt ID.";

                return;
            }

            SelectedReceiptID = receiptID;

            LoadTransactions();
            LoadPaymentHistory();
        }

        protected void btnClosePaymentHistory_Click(
            object sender,
            EventArgs e)
        {
            SelectedReceiptID = 0;
            pnlPaymentHistory.Visible = false;

            LoadTransactions();
        }

        protected string GetBalanceClass(
            object value)
        {
            decimal balance;

            if (!decimal.TryParse(
                Convert.ToString(value),
                out balance))
            {
                return "el-records-money";
            }

            return balance > 0m
                ? "el-records-balance-unpaid"
                : "el-records-balance-paid";
        }

        /*
         * The existing ASPX bindings still use these
         * methods for ordinary receipts.
         * Canceled zero-payment rows are specifically
         * handled in RowDataBound.
         */

        protected string GetPaymentStatus(
            object balanceValue,
            object paidValue)
        {
            decimal balance =
                ToDecimal(balanceValue);

            decimal paid =
                ToDecimal(paidValue);

            if (balance <= 0m)
            {
                return "Paid";
            }

            return paid > 0m
                ? "Partially Paid"
                : "Unpaid";
        }

        protected string GetPaymentStatusClass(
            object balanceValue,
            object paidValue)
        {
            string status =
                GetPaymentStatus(
                    balanceValue,
                    paidValue);

            if (status == "Paid")
            {
                return "el-tx-status el-tx-status-paid";
            }

            if (status == "Partially Paid")
            {
                return "el-tx-status el-tx-status-partial";
            }

            return "el-tx-status el-tx-status-unpaid";
        }
    }
}
