
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

                return receiptID;
            }
        }

        private int AdminUserID
        {
            get
            {
                int userID;

                if (Session["UserID"] == null ||
                    !int.TryParse(
                        Session["UserID"].ToString(),
                        out userID))
                {
                    return 0;
                }

                return userID;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session) ||
                AdminUserID <= 0)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (ReceiptID <= 0)
            {
                Response.Redirect(
                    "~/Admin/Transactions/ManageTransactions.aspx");

                return;
            }

            if (!IsPostBack)
            {
                LoadReceipt();
            }
        }

        private void LoadReceipt()
        {
            lblMessage.Text = "";

            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd =
                        new SqlCommand(
                            "EReceipt_WebOne",
                            con))
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
                                lblMessage.Text =
                                    "Payment record was not found.";

                                btnRecordPayment.Enabled = false;
                                return;
                            }

                            lblCustomer.Text =
                                HttpUtility.HtmlEncode(
                                    reader["FullName"].ToString());

                            lblBook.Text =
                                HttpUtility.HtmlEncode(
                                    reader["Title"].ToString());

                            lblFeeType.Text =
                                HttpUtility.HtmlEncode(
                                    reader["FeeType"].ToString());

                            decimal balance =
                                Convert.ToDecimal(
                                    reader["Balance"]);

                            lblBalance.Text =
                                balance.ToString("N2");

                            txtAmountPaid.Text =
                                balance.ToString("0.00",
                                    CultureInfo.InvariantCulture);

                            if (balance <= 0)
                            {
                                lblMessage.Text =
                                    "This payment has already been settled.";

                                btnRecordPayment.Enabled = false;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text =
                    "Unable to load payment record: " +
                    HttpUtility.HtmlEncode(ex.Message);

                btnRecordPayment.Enabled = false;
            }
        }

        protected void btnRecordPayment_Click(
            object sender,
            EventArgs e)
        {
            lblMessage.Text = "";

            if (!AdminHelper.IsAdmin(Session) ||
                AdminUserID <= 0)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            decimal amountPaid;

            if (!decimal.TryParse(
                    txtAmountPaid.Text,
                    NumberStyles.Number,
                    CultureInfo.InvariantCulture,
                    out amountPaid))
            {
                lblMessage.Text =
                    "Please enter a valid payment amount.";

                return;
            }

            if (amountPaid <= 0)
            {
                lblMessage.Text =
                    "Payment amount must be greater than zero.";

                return;
            }

            if (decimal.Round(amountPaid, 2) != amountPaid)
            {
                lblMessage.Text =
                    "Payment amount must have no more than two decimal places.";

                return;
            }

            string paymentMethod =
                ddlPaymentMethod.SelectedValue;

            if (paymentMethod != "Cash" &&
                paymentMethod != "GCash" &&
                paymentMethod != "Card" &&
                paymentMethod != "Bank Transfer")
            {
                lblMessage.Text =
                    "Please select a valid payment method.";

                return;
            }

            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd =
                        new SqlCommand(
                            "EReceipt_WebPost",
                            con))
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

                        // Identifies the librarian
                        // who processed the payment.
                        cmd.Parameters.Add(
                            "@AdminUserID",
                            SqlDbType.Int).Value =
                            AdminUserID;

                        con.Open();

                        cmd.ExecuteScalar();
                    }
                }

                Response.Redirect(
                    "~/Admin/Transactions/ManageTransactions.aspx",
                    false);

                Context.ApplicationInstance.CompleteRequest();
            }
            catch (SqlException ex)
            {
                lblMessage.Text =
                    HttpUtility.HtmlEncode(ex.Message);
            }
            catch (Exception ex)
            {
                lblMessage.Text =
                    "Unable to record payment: " +
                    HttpUtility.HtmlEncode(ex.Message);
            }
        }

        protected void btnCancel_Click(
            object sender,
            EventArgs e)
        {
            Response.Redirect(
                "~/Admin/Transactions/ManageTransactions.aspx",
                false);

            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
