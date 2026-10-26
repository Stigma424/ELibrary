using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;

namespace ELibrary.Transactions
{
    public partial class DepositLedger : Page
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

        private int CurrentUserID
        {
            get
            {
                int userID;

                if (!int.TryParse(
                    Convert.ToString(Session["UserID"]),
                    out userID))
                {
                    throw new InvalidOperationException(
                        "Invalid user session.");
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

        private string AppliedType
        {
            get
            {
                return Convert.ToString(
                    ViewState["AppliedType"] ?? "All");
            }
            set
            {
                ViewState["AppliedType"] = value;
            }
        }

        protected void Page_Load(
            object sender,
            EventArgs e)
        {
            int userID;

            if (!int.TryParse(
                Convert.ToString(Session["UserID"]),
                out userID))
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
                AppliedType = "All";

                LoadHistory();
            }
        }

        public string FormatMoney(object value)
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

        private void ShowError(string message)
        {
            lblMessage.Text =
                Server.HtmlEncode(message);
        }

        private void LoadHistory()
        {
            try
            {
                DataSet result = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "dbo.EDepositTransaction_WebHistorySearch",
                        con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.CommandTimeout = 30;

                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value =
                        CurrentUserID;

                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar,
                        255).Value =
                        string.IsNullOrWhiteSpace(
                            AppliedSearch)
                        ? (object)DBNull.Value
                        : AppliedSearch;

                    cmd.Parameters.Add(
                        "@TransactionType",
                        SqlDbType.VarChar,
                        20).Value =
                        AppliedType;

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
                        "Transaction history returned " +
                        "incomplete data.");
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
                    LoadHistory();
                    return;
                }

                gvHistory.DataSource =
                    result.Tables[1];

                gvHistory.DataBind();

                lblPage.Text =
                    "Page " + CurrentPage +
                    " of " + TotalPages +
                    " (" + count + " records)";

                btnPrevious.Enabled =
                    CurrentPage > 1;

                btnNext.Enabled =
                    CurrentPage < TotalPages;

                lblMessage.Text = "";
            }
            catch (SqlException ex)
            {
                gvHistory.DataSource = null;
                gvHistory.DataBind();

                ShowError(
                    "Unable to load deposit history: " +
                    ex.Message);
            }
            catch (Exception)
            {
                gvHistory.DataSource = null;
                gvHistory.DataBind();

                ShowError(
                    "Unable to load deposit transactions.");
            }
        }

        protected void btnApply_Click(
            object sender,
            EventArgs e)
        {
            AppliedSearch =
                (txtSearch.Text ?? "").Trim();

            AppliedType =
                ddlType.SelectedValue;

            CurrentPage = 1;

            LoadHistory();
        }

        protected void btnReset_Click(
            object sender,
            EventArgs e)
        {
            txtSearch.Text = "";

            ddlType.SelectedValue = "All";

            AppliedSearch = "";
            AppliedType = "All";

            CurrentPage = 1;

            LoadHistory();
        }

        protected void btnPrevious_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadHistory();
            }
        }

        protected void btnNext_Click(
            object sender,
            EventArgs e)
        {
            if (CurrentPage < TotalPages)
            {
                CurrentPage++;
                LoadHistory();
            }
        }
    }
}