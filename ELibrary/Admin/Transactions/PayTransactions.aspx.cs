
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;

namespace ELibrary.Admin.Transactions
{
    public partial class PayTransaction : System.Web.UI.Page
    {
        // ==========================================
        // SHARED V2 DATABASE CONNECTION
        // ==========================================

        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["ElibraryConnection"]
                    .ConnectionString;
            }
        }

        private int ReceiptID
        {
            get
            {
                int receiptID;

                if (!int.TryParse(
                    Request.QueryString["ReceiptID"],
                    out receiptID))
                {
                    return 0;
                }

                return receiptID > 0 ? receiptID : 0;
            }
        }

        private int AdminUserID
        {
            get
            {
                int userID;

                if (Session["UserID"] == null ||
                    !int.TryParse(
                        Convert.ToString(Session["UserID"]),
                        out userID))
                {
                    return 0;
                }

                return userID > 0 ? userID : 0;
            }
        }

        // ==========================================
        // PAGE LOAD
        // ==========================================

        protected void Page_Load(
            object sender,
            EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session) ||
                AdminUserID <= 0)
            {
                Response.Redirect(
                    "~/Login.aspx",
                    false);

                Context.ApplicationInstance
                    .CompleteRequest();

                return;
            }

            if (ReceiptID <= 0)
            {
                ReturnToTransactions();
                return;
            }

            if (!IsPostBack)
            {
                lblReceiptID.Text =
                    ReceiptID.ToString();

                LoadReceipt(true);
            }
        }

        // ==========================================
        // MESSAGE HELPERS
        // ==========================================

        private void ShowMessage(
            string message,
            string type)
        {
            lblMessage.Text =
                HttpUtility.HtmlEncode(message);

            lblMessage.CssClass =
                "pay-message " + type;

            lblMessage.Visible = true;
        }

        private void HideMessage()
        {
            lblMessage.Text = "";
            lblMessage.Visible = false;
        }

        private void SetPaymentAvailability(
            bool enabled)
        {
            btnRecordPayment.Enabled = enabled;
            pnlPaymentFields.Enabled = enabled;
        }

        private string FormatMoney(decimal amount)
        {
            return amount.ToString(
                "N2",
                CultureInfo.GetCultureInfo("en-PH"));
        }

        // ==========================================
        // STORED PROCEDURE HELPER
        // ==========================================

        private SqlCommand CreateProcedure(
            string procedureName,
            SqlConnection connection)
        {
            SqlCommand command =
                new SqlCommand(
                    procedureName,
                    connection);

            command.CommandType =
                CommandType.StoredProcedure;

            command.CommandTimeout = 30;

            return command;
        }

        // ==========================================
        // READ PAYMENT CONTEXT
        // ==========================================

        private DataRow GetPaymentContext()
        {
            DataTable table = new DataTable();

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                CreateProcedure(
                    "dbo.EReceipt_WebPaymentContext",
                    con))
            {
                cmd.Parameters.Add(
                    "@ReceiptID",
                    SqlDbType.Int).Value =
                    ReceiptID;

                cmd.Parameters.Add(
                    "@AdminUserID",
                    SqlDbType.Int).Value =
                    AdminUserID;

                using (SqlDataAdapter adapter =
                    new SqlDataAdapter(cmd))
                {
                    adapter.Fill(table);
                }
            }

            if (table.Rows.Count != 1)
            {
                throw new InvalidOperationException(
                    "The selected receipt was not found.");
            }

            return table.Rows[0];
        }

        // ==========================================
        // CURRENT BALANCE
        // ==========================================

        private decimal ReadCurrentBalance()
        {
            DataRow context = GetPaymentContext();

            return Convert.ToDecimal(
                context["Balance"]);
        }

        // ==========================================
        // DISPLAY CURRENT RECEIPT
        // ==========================================

        private void LoadReceipt(
            bool setDefaultAmount)
        {
            HideMessage();

            try
            {
                DataRow context =
                    GetPaymentContext();

                lblCustomer.Text =
                    HttpUtility.HtmlEncode(
                        Convert.ToString(
                            context["FullName"]));

                lblBook.Text =
                    HttpUtility.HtmlEncode(
                        Convert.ToString(
                            context["Title"]));

                string feeType =
                    Convert.ToString(
                        context["FeeType"]);

                lblFeeType.Text =
                    HttpUtility.HtmlEncode(feeType);

                lblReceiptID.Text =
                    ReceiptID.ToString();

                decimal balance =
                    Convert.ToDecimal(
                        context["Balance"]);

                lblBalance.Text =
                    FormatMoney(balance);

                if (setDefaultAmount)
                {
                    txtAmountPaid.Text =
                        balance > 0
                        ? balance.ToString(
                            "0.00",
                            CultureInfo.InvariantCulture)
                        : "";
                }

                bool canPay =
                    Convert.ToBoolean(
                        context["CanRecordPayment"]);

                if (!canPay)
                {
                    SetPaymentAvailability(false);

                    ShowMessage(
                        Convert.ToString(
                            context["PaymentMessage"]),
                        "info");

                    return;
                }

                SetPaymentAvailability(true);

                string collectionStatus =
                    Convert.ToString(
                        context["CollectionStatus"]);

                string borrowChannel =
                    Convert.ToString(
                        context["BorrowChannel"]);

                // V2: a borrowing fee can be paid
                // before physical book collection.
                if (collectionStatus == "Pending" &&
                    borrowChannel == "Online" &&
                    feeType == "Borrowing Fee")
                {
                    decimal depositRequired =
                        Convert.ToDecimal(
                            context["DepositRequired"]);

                    decimal depositReceived =
                        Convert.ToDecimal(
                            context["DepositReceived"]);

                    ShowMessage(
                        "Online reservation: the borrowing " +
                        "fee is payable before pickup. " +
                        "Security deposit required: PHP " +
                        FormatMoney(depositRequired) +
                        ". Deposit received: PHP " +
                        FormatMoney(depositReceived) +
                        ". Deposit payments are recorded " +
                        "separately under Collect Security Deposits.",
                        "info");

                    return;
                }

                if (collectionStatus == "Collected")
                {
                    // This includes outstanding late
                    // and replacement fees.
                    ShowMessage(
                        "This receipt is eligible for payment. " +
                        "Any refundable security deposit is " +
                        "managed separately from this fee.",
                        "info");
                }
            }
            catch (SqlException ex)
            {
                SetPaymentAvailability(false);

                ShowMessage(
                    "Unable to load payment details: " +
                    ex.Message,
                    "error");
            }
            catch (Exception)
            {
                SetPaymentAvailability(false);

                ShowMessage(
                    "Unable to load payment information. " +
                    "Return to Manage Transactions and " +
                    "review the receipt.",
                    "error");
            }
        }

        // ==========================================
        // VALIDATE AMOUNT
        // ==========================================

        private bool TryReadPaymentAmount(
            out decimal amountPaid)
        {
            amountPaid = 0m;

            if (!decimal.TryParse(
                (txtAmountPaid.Text ?? "").Trim(),
                NumberStyles.AllowDecimalPoint,
                CultureInfo.InvariantCulture,
                out amountPaid))
            {
                ShowMessage(
                    "Enter a valid payment amount, " +
                    "such as 250.00.",
                    "error");

                return false;
            }

            if (amountPaid <= 0)
            {
                ShowMessage(
                    "Payment amount must be greater than zero.",
                    "error");

                return false;
            }

            if (amountPaid > 99999999.99m)
            {
                ShowMessage(
                    "Payment amount exceeds the allowed maximum.",
                    "error");

                return false;
            }

            if (decimal.Round(
                amountPaid, 2) != amountPaid)
            {
                ShowMessage(
                    "Payment amount cannot exceed " +
                    "two decimal places.",
                    "error");

                return false;
            }

            return true;
        }

        // ==========================================
        // VALIDATE PAYMENT METHOD
        // ==========================================

        private bool IsValidPaymentMethod(
            string method)
        {
            return method == "Cash" ||
                   method == "GCash" ||
                   method == "Card" ||
                   method == "Bank Transfer";
        }

        // ==========================================
        // RECORD PAYMENT
        // ==========================================

        protected void btnRecordPayment_Click(
            object sender,
            EventArgs e)
        {
            HideMessage();

            if (!AdminHelper.IsAdmin(Session) ||
                AdminUserID <= 0)
            {
                Response.Redirect(
                    "~/Login.aspx",
                    false);

                Context.ApplicationInstance
                    .CompleteRequest();

                return;
            }

            if (!Page.IsValid)
            {
                ShowMessage(
                    "Please correct the payment information.",
                    "error");

                return;
            }

            if (ReceiptID <= 0)
            {
                ShowMessage(
                    "Invalid receipt. Return to " +
                    "Manage Transactions.",
                    "error");

                return;
            }

            decimal amountPaid;

            if (!TryReadPaymentAmount(
                out amountPaid))
            {
                return;
            }

            string paymentMethod =
                ddlPaymentMethod.SelectedValue;

            if (!IsValidPaymentMethod(paymentMethod))
            {
                ShowMessage(
                    "Please select a valid payment method.",
                    "error");

                return;
            }

            // ======================================
            // RECHECK PAYMENT ELIGIBILITY
            // ======================================

            DataRow context;

            try
            {
                context = GetPaymentContext();
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to verify the receipt's " +
                    "latest status. No payment was submitted.",
                    "error");

                return;
            }

            bool canPay =
                Convert.ToBoolean(
                    context["CanRecordPayment"]);

            decimal currentBalance =
                Convert.ToDecimal(
                    context["Balance"]);

            if (!canPay)
            {
                LoadReceipt(false);

                ShowMessage(
                    Convert.ToString(
                        context["PaymentMessage"]),
                    "error");

                return;
            }

            if (currentBalance <= 0)
            {
                lblBalance.Text = "0.00";
                txtAmountPaid.Text = "";

                SetPaymentAvailability(false);

                ShowMessage(
                    "This receipt has already been settled. " +
                    "No additional payment was recorded.",
                    "info");

                return;
            }

            if (amountPaid > currentBalance)
            {
                lblBalance.Text =
                    FormatMoney(currentBalance);

                ShowMessage(
                    "Payment exceeds the current " +
                    "outstanding balance of PHP " +
                    FormatMoney(currentBalance) +
                    ". Please adjust the amount.",
                    "error");

                return;
            }

            // ======================================
            // EXECUTE V2 PAYMENT PROCEDURE
            // ======================================

            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    CreateProcedure(
                        "dbo.EReceipt_WebPost",
                        con))
                {
                    cmd.Parameters.Add(
                        "@ReceiptID",
                        SqlDbType.Int).Value =
                        ReceiptID;

                    SqlParameter amountParameter =
                        cmd.Parameters.Add(
                            "@AmountPaid",
                            SqlDbType.Decimal);

                    amountParameter.Precision = 10;
                    amountParameter.Scale = 2;
                    amountParameter.Value = amountPaid;

                    cmd.Parameters.Add(
                        "@PaymentMethod",
                        SqlDbType.VarChar,
                        30).Value =
                        paymentMethod;

                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value =
                        AdminUserID;

                    con.Open();

                    // SQL Server performs the atomic update,
                    // payment history and audit logging.
                    cmd.ExecuteScalar();
                }
            }
            catch (SqlException ex)
            {
                // A SQL rejection is handled by the V2
                // payment procedure's transaction.
                LoadReceipt(false);

                ShowMessage(
                    "Payment rejected: " +
                    ex.Message,
                    "error");

                return;
            }
            catch (Exception)
            {
                // The outcome of an interrupted SQL
                // connection may be uncertain.
                // Do not automatically resubmit payment.
                SetPaymentAvailability(false);

                ShowMessage(
                    "The payment result could not be " +
                    "confirmed. Review the receipt's " +
                    "payment history before retrying.",
                    "error");

                return;
            }

            // ======================================
            // SUCCESS
            // ======================================

            SetPaymentAvailability(false);
            txtAmountPaid.Text = "";

            string confirmation =
                "Payment of PHP " +
                FormatMoney(amountPaid) +
                " recorded successfully using " +
                paymentMethod + ".";

            try
            {
                DataRow updated =
                    GetPaymentContext();

                decimal remainingBalance =
                    Convert.ToDecimal(
                        updated["Balance"]);

                lblBalance.Text =
                    FormatMoney(remainingBalance);

                confirmation +=
                    " Remaining balance: PHP " +
                    FormatMoney(remainingBalance) +
                    ".";

                string feeType =
                    Convert.ToString(
                        updated["FeeType"]);

                string collectionStatus =
                    Convert.ToString(
                        updated["CollectionStatus"]);

                if (feeType == "Borrowing Fee" &&
                    collectionStatus == "Pending")
                {
                    decimal depositRequired =
                        Convert.ToDecimal(
                            updated["DepositRequired"]);

                    decimal depositReceived =
                        Convert.ToDecimal(
                            updated["DepositReceived"]);

                    if (remainingBalance == 0 &&
                        depositReceived == depositRequired &&
                        depositRequired > 0)
                    {
                        confirmation +=
                            " Both upfront payment requirements " +
                            "are satisfied. The reservation is " +
                            "ready for librarian pickup confirmation.";
                    }
                    else
                    {
                        confirmation +=
                            " The customer must complete both " +
                            "the borrowing fee and security " +
                            "deposit before pickup.";
                    }
                }
            }
            catch (Exception)
            {
                confirmation +=
                    " Return to Manage Transactions " +
                    "to review the updated balance.";
            }

            Session["PaymentSuccessMessage"] = confirmation;
            ReturnToTransactions();
        }

        // ==========================================
        // BACK TO MANAGE TRANSACTIONS
        // ==========================================

        protected void btnCancel_Click(
            object sender,
            EventArgs e)
        {
            ReturnToTransactions();
        }

        private void ReturnToTransactions()
        {
            Response.Redirect(
                "~/Admin/Transactions/ManageTransactions.aspx",
                false);

            Context.ApplicationInstance
                .CompleteRequest();
        }
    }
}
