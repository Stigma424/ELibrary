using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary.Admin.Transactions
{
    public partial class RefundDeposits : Page
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
                int userID;

                if (!int.TryParse(
                    Convert.ToString(Session["UserID"]),
                    out userID))
                {
                    throw new InvalidOperationException(
                        "Administrator session is invalid.");
                }

                return userID;
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
                    ViewState["AppliedStatus"]
                    ?? "RefundPending");
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

        protected void Page_Load(
            object sender,
            EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect(
                    "~/Login.aspx", false);

                Context.ApplicationInstance
                    .CompleteRequest();

                return;
            }

            if (!IsPostBack)
            {
                AppliedSearch = "";
                AppliedStatus = "RefundPending";
                CurrentPage = 1;

                LoadRefunds();
            }
        }

        private SqlCommand CreateProcedure(
            string name,
            SqlConnection connection)
        {
            SqlCommand cmd =
                new SqlCommand(name, connection);

            cmd.CommandType =
                CommandType.StoredProcedure;

            cmd.CommandTimeout = 30;

            return cmd;
        }

        private void ShowMessage(
            string message,
            bool success)
        {
            lblMessage.CssClass = success
                ? "refund-message refund-success"
                : "refund-message refund-warning";

            lblMessage.Text =
                Server.HtmlEncode(message);
        }

        public string Money(object value)
        {
            decimal amount =
                value == null || value == DBNull.Value
                ? 0m
                : Convert.ToDecimal(value);

            return "₱" + amount.ToString(
                "N2",
                CultureInfo.GetCultureInfo("en-PH"));
        }

        private void LoadRefunds()
        {
            try
            {
                DataSet result = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    CreateProcedure(
                        "dbo.ESecurityDeposit_WebRefundSearch",
                        con))
                {
                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value =
                        AdminUserID;

                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar,
                        255).Value =
                        string.IsNullOrWhiteSpace(
                            AppliedSearch)
                        ? (object)DBNull.Value
                        : AppliedSearch;

                    cmd.Parameters.Add(
                        "@Status",
                        SqlDbType.VarChar,
                        20).Value =
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
                        adapter.Fill(result);
                    }
                }

                if (result.Tables.Count < 2)
                {
                    throw new InvalidOperationException(
                        "Refund search returned incomplete data.");
                }

                int count = 0;

                if (result.Tables[0].Rows.Count > 0)
                {
                    count = Convert.ToInt32(
                        result.Tables[0].Rows[0][
                            "FilteredCount"]);
                }

                TotalPages = Math.Max(
                    1,
                    (int)Math.Ceiling(
                        count / (double)PageSize));

                if (CurrentPage > TotalPages)
                {
                    CurrentPage = TotalPages;
                    LoadRefunds();
                    return;
                }

                gvRefunds.DataSource =
                    result.Tables[1];

                gvRefunds.DataBind();

                lblPage.Text =
                    "Page " + CurrentPage +
                    " of " + TotalPages +
                    " (" + count + " records)";

                btnPrevious.Enabled =
                    CurrentPage > 1;

                btnNext.Enabled =
                    CurrentPage < TotalPages;
            }
            catch (SqlException ex)
            {
                ShowMessage(
                    "Unable to load refunds: " +
                    ex.Message, false);
            }
            catch (Exception)
            {
                ShowMessage(
                    "Unable to load refund records.",
                    false);
            }
        }

        protected void btnApply_Click(
            object sender,
            EventArgs e)
        {
            AppliedSearch =
                (txtSearch.Text ?? "").Trim();

            AppliedStatus =
                ddlStatus.SelectedValue;

            CurrentPage = 1;

            LoadRefunds();
        }

        protected void btnReset_Click(
            object sender,
            EventArgs e)
        {
            txtSearch.Text = "";
            ddlStatus.SelectedValue =
                "RefundPending";

            AppliedSearch = "";
            AppliedStatus = "RefundPending";

            CurrentPage = 1;

            LoadRefunds();
        }

        protected void btnPrevious_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadRefunds();
            }
        }

        protected void btnNext_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage < TotalPages)
            {
                CurrentPage++;
                LoadRefunds();
            }
        }

        protected void gvRefunds_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (e.CommandName != "Refund")
                return;

            int borrowLogID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out borrowLogID))
            {
                ShowMessage(
                    "Invalid borrowing record.",
                    false);

                return;
            }

            Control source =
                e.CommandSource as Control;

            GridViewRow row =
                source == null
                ? null
                : source.NamingContainer
                    as GridViewRow;

            if (row == null ||
                row.RowType !=
                DataControlRowType.DataRow)
            {
                ShowMessage(
                    "Unable to locate refund controls.",
                    false);

                return;
            }

            DropDownList ddlMethod =
                row.FindControl("ddlMethod")
                    as DropDownList;

            TextBox txtReference =
                row.FindControl("txtReference")
                    as TextBox;

            CheckBox chkConfirmed =
                row.FindControl("chkConfirmed")
                    as CheckBox;

            if (ddlMethod == null ||
                txtReference == null ||
                chkConfirmed == null)
            {
                ShowMessage(
                    "Refund form is incomplete.",
                    false);

                return;
            }

            string method =
                ddlMethod.SelectedValue;

            if (method != "Cash" &&
                method != "GCash" &&
                method != "Card" &&
                method != "Bank Transfer")
            {
                ShowMessage(
                    "Select a valid refund method.",
                    false);

                return;
            }

            if (!chkConfirmed.Checked)
            {
                ShowMessage(
                    "Confirm that the refund was " +
                    "actually issued before recording it.",
                    false);

                return;
            }

            string reference =
                (txtReference.Text ?? "").Trim();

            if (reference.Length > 100)
            {
                ShowMessage(
                    "Reference exceeds 100 characters.",
                    false);

                return;
            }

            ProcessRefund(
                borrowLogID,
                method,
                reference);
        }

        private void ProcessRefund(
            int borrowLogID,
            string method,
            string reference)
        {
            try
            {
                decimal refundedAmount = 0m;
                int transactionID = 0;
                bool resultReceived = false;

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    CreateProcedure(
                        "dbo.ESecurityDeposit_WebRefund",
                        con))
                {
                    cmd.Parameters.Add(
                        "@BorrowLogID",
                        SqlDbType.Int).Value =
                        borrowLogID;

                    cmd.Parameters.Add(
                        "@PaymentMethod",
                        SqlDbType.VarChar,
                        30).Value =
                        method;

                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value =
                        AdminUserID;

                    cmd.Parameters.Add(
                        "@ReferenceNo",
                        SqlDbType.VarChar,
                        100).Value =
                        string.IsNullOrWhiteSpace(reference)
                        ? (object)DBNull.Value
                        : reference;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            refundedAmount =
                                Convert.ToDecimal(
                                    reader["AmountRefunded"]);

                            transactionID =
                                Convert.ToInt32(
                                    reader["DepositTransactionID"]);

                            resultReceived = true;
                        }
                    }
                }

                LoadRefunds();

                if (resultReceived)
                {
                    ShowMessage(
                        "Security deposit refund recorded. " +
                        "Borrow ID: " + borrowLogID +
                        ". Refunded: " +
                        Money(refundedAmount) +
                        ". Transaction ID: " +
                        transactionID + ".",
                        true);
                }
                else
                {
                    ShowMessage(
                        "Refund procedure completed, but " +
                        "no confirmation record was returned. " +
                        "Check the transaction ledger before " +
                        "attempting another refund.",
                        false);
                }
            }
            catch (SqlException ex)
            {
                LoadRefunds();

                ShowMessage(
                    "Refund rejected: " + ex.Message,
                    false);
            }
            catch (Exception)
            {
                LoadRefunds();

                ShowMessage(
                    "Unable to confirm refund completion. " +
                    "Check the deposit and transaction " +
                    "history before retrying.",
                    false);
            }
        }
    }
}