using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary.Admin.Borrowing
{
    public partial class Settlements : Page
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
                        "Invalid librarian session.");
                }

                return userID;
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
                CurrentPage = 1;
                AppliedSearch = "";
                AppliedStatus = "All";

                LoadSettlements();
            }
        }

        private SqlCommand CreateProcedure(
            string procedureName,
            SqlConnection con)
        {
            SqlCommand cmd =
                new SqlCommand(procedureName, con);

            cmd.CommandType =
                CommandType.StoredProcedure;

            cmd.CommandTimeout = 60;

            return cmd;
        }

        public string Money(object value)
        {
            decimal amount = 0m;

            if (value != null &&
                value != DBNull.Value)
            {
                amount = Convert.ToDecimal(value);
            }

            return "₱" + amount.ToString(
                "N2",
                CultureInfo.GetCultureInfo("en-PH"));
        }

        private void ShowMessage(
            string message,
            bool success)
        {
            lblMessage.CssClass =
                success
                ? "settle-message settle-success"
                : "settle-message settle-danger";

            lblMessage.Text =
                Server.HtmlEncode(message);
        }

        private void LoadSettlements()
        {
            try
            {
                DataSet result = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    CreateProcedure(
                        "dbo.ESecurityDeposit_WebLostSettlementSearch",
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
                        "Settlement search returned incomplete data.");
                }

                int recordCount = 0;

                if (result.Tables[0].Rows.Count > 0)
                {
                    recordCount = Convert.ToInt32(
                        result.Tables[0].Rows[0][
                            "FilteredCount"]);
                }

                TotalPages = Math.Max(
                    1,
                    (int)Math.Ceiling(
                        recordCount / (double)PageSize));

                if (CurrentPage > TotalPages)
                {
                    CurrentPage = TotalPages;
                    LoadSettlements();
                    return;
                }

                gvSettlements.DataSource =
                    result.Tables[1];

                gvSettlements.DataBind();

                lblPage.Text =
                    "Page " + CurrentPage +
                    " of " + TotalPages +
                    " (" + recordCount + " records)";

                btnPrevious.Enabled =
                    CurrentPage > 1;

                btnNext.Enabled =
                    CurrentPage < TotalPages;
            }
            catch (SqlException ex)
            {
                gvSettlements.DataSource = null;
                gvSettlements.DataBind();

                ShowMessage(
                    "Unable to load settlements: " +
                    ex.Message, false);
            }
            catch (Exception)
            {
                gvSettlements.DataSource = null;
                gvSettlements.DataBind();

                ShowMessage(
                    "Unable to load settlement records.",
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

            LoadSettlements();
        }

        protected void btnReset_Click(
            object sender,
            EventArgs e)
        {
            txtSearch.Text = "";

            ddlStatus.SelectedValue = "All";

            AppliedSearch = "";
            AppliedStatus = "All";

            CurrentPage = 1;

            LoadSettlements();
        }

        protected void btnPrevious_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadSettlements();
            }
        }

        protected void btnNext_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage < TotalPages)
            {
                CurrentPage++;
                LoadSettlements();
            }
        }

        protected void btnProcessExpired_Click(
            object sender,
            EventArgs e)
        {
            int batchSize;

            if (!int.TryParse(
                (txtBatchSize.Text ?? "").Trim(),
                out batchSize))
            {
                ShowMessage(
                    "Enter a valid batch size.",
                    false);

                return;
            }

            if (batchSize < 1 || batchSize > 500)
            {
                ShowMessage(
                    "Batch size must be between 1 and 500.",
                    false);

                return;
            }

            try
            {
                int cancelledCount = 0;

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    CreateProcedure(
                        "dbo.EBorrowLog_WebProcessExpiredReservations",
                        con))
                {
                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value =
                        AdminUserID;

                    cmd.Parameters.Add(
                        "@BatchSize",
                        SqlDbType.Int).Value =
                        batchSize;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            throw new InvalidOperationException(
                                "Expiration procedure returned " +
                                "no summary.");
                        }

                        cancelledCount =
                            Convert.ToInt32(
                                reader["ReservationsCancelled"]);
                    }
                }

                lblExpirationResult.CssClass =
                    "settle-message settle-success";

                lblExpirationResult.Text =
                    Server.HtmlEncode(
                        "Processing completed. " +
                        cancelledCount +
                        " eligible reservations cancelled.");

                LoadSettlements();
            }
            catch (SqlException ex)
            {
                lblExpirationResult.CssClass =
                    "settle-message settle-danger";

                lblExpirationResult.Text =
                    Server.HtmlEncode(
                        "Expiration processing rejected: " +
                        ex.Message);
            }
            catch (Exception)
            {
                lblExpirationResult.CssClass =
                    "settle-message settle-danger";

                lblExpirationResult.Text =
                    "Unable to confirm expiration processing. " +
                    "Review reservation records before retrying.";
            }
        }

        protected void gvSettlements_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (e.CommandName != "Settle")
                return;

            int borrowLogID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out borrowLogID))
            {
                ShowMessage(
                    "Invalid borrowing ID.",
                    false);

                return;
            }

            Control source =
                e.CommandSource as Control;

            GridViewRow row =
                source == null
                ? null
                : source.NamingContainer as GridViewRow;

            if (row == null ||
                row.RowType !=
                DataControlRowType.DataRow)
            {
                ShowMessage(
                    "Unable to locate settlement controls.",
                    false);

                return;
            }

            DropDownList ddlMethod =
                row.FindControl("ddlRefundMethod")
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
                    "Settlement controls are incomplete.",
                    false);

                return;
            }

            string method = ddlMethod.SelectedValue;

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
                    "Confirm that the security deposit " +
                    "was actually refunded.",
                    false);

                return;
            }

            string reference =
                (txtReference.Text ?? "").Trim();

            if (reference.Length > 100)
            {
                ShowMessage(
                    "Reference must not exceed 100 characters.",
                    false);

                return;
            }

            ProcessSettlement(
                borrowLogID,
                method,
                reference);
        }

        private void ProcessSettlement(
            int borrowLogID,
            string refundMethod,
            string reference)
        {
            try
            {
                decimal amountRefunded = 0m;
                int depositID = 0;
                bool resultReceived = false;

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    CreateProcedure(
                        "dbo.ESecurityDeposit_WebSettleLost",
                        con))
                {
                    cmd.Parameters.Add(
                        "@BorrowLogID",
                        SqlDbType.Int).Value =
                        borrowLogID;

                    cmd.Parameters.Add(
                        "@AdminUserID",
                        SqlDbType.Int).Value =
                        AdminUserID;

                    cmd.Parameters.Add(
                        "@RefundMethod",
                        SqlDbType.VarChar,
                        30).Value =
                        refundMethod;

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
                            amountRefunded =
                                Convert.ToDecimal(
                                    reader["AmountRefunded"]);

                            depositID =
                                Convert.ToInt32(
                                    reader["DepositID"]);

                            resultReceived = true;
                        }
                    }
                }

                LoadSettlements();

                if (resultReceived)
                {
                    ShowMessage(
                        "Lost-book deposit settlement recorded. " +
                        "Borrow ID: " + borrowLogID +
                        ". Deposit ID: " + depositID +
                        ". Amount refunded: " +
                        Money(amountRefunded) + ".",
                        true);
                }
                else
                {
                    ShowMessage(
                        "The settlement procedure returned no " +
                        "confirmation. Check deposit transaction " +
                        "history before attempting another refund.",
                        false);
                }
            }
            catch (SqlException ex)
            {
                LoadSettlements();

                ShowMessage(
                    "Settlement rejected: " + ex.Message,
                    false);
            }
            catch (Exception)
            {
                LoadSettlements();

                ShowMessage(
                    "Unable to confirm settlement completion. " +
                    "Check the deposit ledger before retrying.",
                    false);
            }
        }
    }
}