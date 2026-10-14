using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace ELibrary.Customer
{
    public partial class MyTransactions : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ElibraryConnection"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsCustomer())
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
                LoadTransactions();
        }

        private bool IsCustomer()
        {
            if (Session["UserID"] == null || Session["Role"] == null)
                return false;

            int role;
            return int.TryParse(Convert.ToString(Session["Role"]), out role) && role == 1;
        }

        private string AppliedSearch
        {
            get { return (string)(ViewState["AppliedSearch"] ?? ""); }
            set { ViewState["AppliedSearch"] = value; }
        }

        private string AppliedStatus
        {
            get { return (string)(ViewState["AppliedStatus"] ?? "All"); }
            set { ViewState["AppliedStatus"] = value; }
        }

        private string AppliedMethod
        {
            get { return (string)(ViewState["AppliedMethod"] ?? "All"); }
            set { ViewState["AppliedMethod"] = value; }
        }

        private string AppliedSort
        {
            get { return (string)(ViewState["AppliedSort"] ?? "Newest"); }
            set { ViewState["AppliedSort"] = value; }
        }

        private DataTable GetTransactions()
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand("EReceipt_WebMyTransactions", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    da.Fill(dt);
            }

            return dt;
        }

        private static decimal Money(DataRow row, string column)
        {
            return row[column] == DBNull.Value ? 0m : Convert.ToDecimal(row[column]);
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
                    decimal paid = Money(row, "AmountPaid");
                    decimal balance = Money(row, "Balance");
                    totalPaid += paid;
                    outstanding += balance;
                    if (balance > 0m) unpaidCount++;
                }

                lblTransactionCount.Text = all.Rows.Count.ToString("N0");
                lblTotalPaid.Text = totalPaid.ToString("N2");
                lblOutstandingBalance.Text = outstanding.ToString("N2");
                lblUnpaidCount.Text = unpaidCount.ToString("N0");

                string search = AppliedSearch;
                string status = AppliedStatus;
                string method = AppliedMethod;

                var rows = all.AsEnumerable().Where(row =>
                {
                    bool matchesSearch = search.Length == 0 ||
                        ContainsText(row, "ReceiptNo", search) ||
                        ContainsText(row, "Title", search) ||
                        ContainsText(row, "FeeType", search);

                    decimal balance = Money(row, "Balance");
                    decimal paid = Money(row, "AmountPaid");
                    bool matchesStatus = status == "All" ||
                        (status == "Paid" && balance <= 0m) ||
                        (status == "Unpaid" && balance > 0m && paid <= 0m) ||
                        (status == "Partial" && balance > 0m && paid > 0m);

                    string recordedMethod = row["PaymentMethod"] == DBNull.Value
                        ? "" : Convert.ToString(row["PaymentMethod"]);
                    bool matchesMethod = method == "All" ||
                        (method == "Not Set" && string.IsNullOrWhiteSpace(recordedMethod)) ||
                        string.Equals(method, recordedMethod, StringComparison.OrdinalIgnoreCase);

                    return matchesSearch && matchesStatus && matchesMethod;
                });

                rows = AppliedSort == "Oldest"
                    ? rows.OrderBy(r => DateValue(r)).ThenBy(r => Convert.ToInt32(r["ReceiptID"]))
                    : rows.OrderByDescending(r => DateValue(r)).ThenByDescending(r => Convert.ToInt32(r["ReceiptID"]));

                DataTable filtered = all.Clone();
                foreach (DataRow row in rows)
                    filtered.ImportRow(row);

                if (gvTransactions.PageIndex >= Math.Max(1, (filtered.Rows.Count + gvTransactions.PageSize - 1) / gvTransactions.PageSize))
                    gvTransactions.PageIndex = 0;

                gvTransactions.DataSource = filtered;
                gvTransactions.DataBind();
                lblResultCount.Text = string.Format("Showing {0:N0} of {1:N0} transactions", filtered.Rows.Count, all.Rows.Count);
                lblMessage.Text = "";
            }
            catch (Exception)
            {
                gvTransactions.DataSource = null;
                gvTransactions.DataBind();
                lblMessage.CssClass = "el-records-message error";
                lblMessage.Text = "Unable to load your transaction records.";
            }
        }

        private static bool ContainsText(DataRow row, string column, string search)
        {
            return row.Table.Columns.Contains(column) && row[column] != DBNull.Value &&
                Convert.ToString(row[column]).IndexOf(search, StringComparison.OrdinalIgnoreCase) >= 0;
        }

        private static DateTime DateValue(DataRow row)
        {
            return row["TransactionDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(row["TransactionDate"]);
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            AppliedSearch = (txtSearch.Text ?? "").Trim();
            AppliedStatus = ddlStatus.SelectedValue;
            AppliedMethod = ddlMethod.SelectedValue;
            AppliedSort = ddlSort.SelectedValue;
            gvTransactions.PageIndex = 0;
            LoadTransactions();
        }

        protected void btnClear_Click(object sender, EventArgs e)
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
        }

        protected void gvTransactions_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            gvTransactions.PageIndex = e.NewPageIndex;
            LoadTransactions();
        }

        protected string GetBalanceClass(object value)
        {
            decimal balance;
            if (!decimal.TryParse(Convert.ToString(value), out balance))
                return "el-records-money";
            return balance > 0m ? "el-records-balance-unpaid" : "el-records-balance-paid";
        }

        protected string GetPaymentStatus(object balanceValue, object paidValue)
        {
            decimal balance = ToDecimal(balanceValue);
            decimal paid = ToDecimal(paidValue);
            if (balance <= 0m) return "Paid";
            return paid > 0m ? "Partially Paid" : "Unpaid";
        }

        protected string GetPaymentStatusClass(object balanceValue, object paidValue)
        {
            string status = GetPaymentStatus(balanceValue, paidValue);
            if (status == "Paid") return "el-tx-status el-tx-status-paid";
            if (status == "Partially Paid") return "el-tx-status el-tx-status-partial";
            return "el-tx-status el-tx-status-unpaid";
        }

        private static decimal ToDecimal(object value)
        {
            return value == null || value == DBNull.Value ? 0m : Convert.ToDecimal(value);
        }
    }
}
