
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

                return userID;
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
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (ReceiptID <= 0)
            {
                ReturnToTransactions();
                return;
            }

            if (!IsPostBack)
            {
                lblReceiptID.Text = ReceiptID.ToString();

                LoadReceipt(true);
            }
        }

        // ==========================================
        // LOCAL NOTIFICATIONS
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

        // ==========================================
        // READ CURRENT RECEIPT
        // ==========================================

        private decimal ReadCurrentBalance()
        {
            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                new SqlCommand("EReceipt_WebOne", con))
            {
                cmd.CommandType =
                    CommandType.StoredProcedure;

                cmd.Parameters.Add(
                    "@ReceiptID",
                    SqlDbType.Int).Value =
                    ReceiptID;

                con.Open();

                using (SqlDataReader reader =
                    cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        throw new InvalidOperationException(
                            "The selected receipt was not found.");
                    }

                    return Convert.ToDecimal(
                        reader["Balance"]);
                }
            }
        }

        private void LoadReceipt(
            bool setDefaultAmount)
        {
            HideMessage();

            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand("EReceipt_WebOne", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@ReceiptID",
                        SqlDbType.Int).Value =
                        ReceiptID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            SetPaymentAvailability(false);

                            ShowMessage(
                                "The selected receipt was not found.",
                                "error");
                            return;
                        }

                        lblCustomer.Text =
                            HttpUtility.HtmlEncode(
                                Convert.ToString(
                                    reader["FullName"]));

                        lblBook.Text =
                            HttpUtility.HtmlEncode(
                                Convert.ToString(
                                    reader["Title"]));

                        lblFeeType.Text =
                            HttpUtility.HtmlEncode(
                                Convert.ToString(
                                    reader["FeeType"]));

                        decimal balance =
                            Convert.ToDecimal(
                                reader["Balance"]);

                        lblBalance.Text =
                            balance.ToString("N2");

                        if (setDefaultAmount)
                        {
                            txtAmountPaid.Text =
                                balance > 0
                                ? balance.ToString(
                                    "0.00",
                                    CultureInfo.InvariantCulture)
                                : "";
                        }

                        if (balance <= 0)
                        {
                            SetPaymentAvailability(false);

                            ShowMessage(
                                "This receipt has already been settled.",
                                "info");
                        }
                        else
                        {
                            SetPaymentAvailability(true);
                        }
                    }
                }
            }
            catch (Exception)
            {
                SetPaymentAvailability(false);

                ShowMessage(
                    "Unable to load payment information. " +
                    "Return to Manage Transactions and try again.",
                    "error");
            }
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
                Response.Redirect("~/Login.aspx");
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
                    "Invalid receipt. Return to Manage Transactions.",
                    "error");
                return;
            }

            // ======================================
            // VALIDATE AMOUNT
            // ======================================

            decimal amountPaid;

            if (!decimal.TryParse(
                (txtAmountPaid.Text ?? "").Trim(),
                NumberStyles.AllowDecimalPoint,
                CultureInfo.InvariantCulture,
                out amountPaid))
            {
                ShowMessage(
                    "Enter a valid payment amount, such as 250.00.",
                    "error");
                return;
            }

            if (amountPaid <= 0)
            {
                ShowMessage(
                    "Payment amount must be greater than zero.",
                    "error");
                return;
            }

            if (amountPaid > 99999999.99m)
            {
                ShowMessage(
                    "Payment amount exceeds the allowed maximum.",
                    "error");
                return;
            }

            if (decimal.Round(amountPaid, 2) != amountPaid)
            {
                ShowMessage(
                    "Payment amount cannot exceed two decimal places.",
                    "error");
                return;
            }

            // ======================================
            // VALIDATE METHOD
            // ======================================

            string paymentMethod =
                ddlPaymentMethod.SelectedValue;

            if (paymentMethod != "Cash" &&
                paymentMethod != "GCash" &&
                paymentMethod != "Card" &&
                paymentMethod != "Bank Transfer")
            {
                ShowMessage(
                    "Please select a valid payment method.",
                    "error");
                return;
            }

            // ======================================
            // CHECK CURRENT BALANCE
            // ======================================

            decimal currentBalance;

            try
            {
                currentBalance = ReadCurrentBalance();
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to verify the current outstanding " +
                    "balance. Please try again.",
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
                    currentBalance.ToString("N2");

                ShowMessage(
                    "Payment exceeds the current outstanding " +
                    "balance of PHP " +
                    currentBalance.ToString("N2") +
                    ". Please adjust the amount.",
                    "error");
                return;
            }

            // ======================================
            // DATABASE PAYMENT
            // ======================================

            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand("EReceipt_WebPost", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

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

                    // The stored procedure is responsible
                    // for the atomic database transaction,
                    // outstanding balance, and payment log.
                    cmd.ExecuteScalar();
                }
            }
            catch (SqlException ex)
            {
                // Refresh from SQL because the balance
                // may have changed since page load.
                try
                {
                    LoadReceipt(false);
                }
                catch
                {
                    // Retain the original payment error.
                }

                ShowMessage(
                    "Unable to record payment: " +
                    ex.Message,
                    "error");

                return;
            }
            catch (Exception)
            {
                ShowMessage(
                    "The payment result could not be confirmed. " +
                    "Check Manage Transactions and the individual " +
                    "payment history before retrying.",
                    "error");

                SetPaymentAvailability(false);
                return;
            }

            // ======================================
            // SUCCESS
            // ======================================

            // The procedure completed successfully.
            // Disable resubmission on this page.
            SetPaymentAvailability(false);
            txtAmountPaid.Text = "";

            string confirmation =
                "Payment of PHP " +
                amountPaid.ToString("N2") +
                " recorded successfully using " +
                paymentMethod +
                ".";

            try
            {
                decimal remainingBalance =
                    ReadCurrentBalance();

                lblBalance.Text =
                    remainingBalance.ToString("N2");

                confirmation +=
                    " Remaining balance: PHP " +
                    remainingBalance.ToString("N2") +
                    ".";
            }
            catch (Exception)
            {
                confirmation +=
                    " Return to Manage Transactions " +
                    "to review the updated balance.";
            }

            ShowMessage(
                confirmation,
                "success");
        }

        // ==========================================
        // CANCEL / RETURN
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

            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
