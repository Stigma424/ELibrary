
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace ELibrary.Customer
{
    public partial class BorrowHistory : Page
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

        private string AppliedSort
        {
            get { return (string)(ViewState["AppliedSort"] ?? "Newest"); }
            set { ViewState["AppliedSort"] = value; }
        }

        private int CurrentPage
        {
            get { return (int)(ViewState["CurrentPage"] ?? 1); }
            set { ViewState["CurrentPage"] = value; }
        }

        private int TotalPages
        {
            get { return (int)(ViewState["TotalPages"] ?? 1); }
            set { ViewState["TotalPages"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsCustomer())
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadHistory();
            }
        }

        private bool IsCustomer()
        {
            if (Session["UserID"] == null ||
                Session["Role"] == null)
                return false;

            int role;
            int userID;

            return int.TryParse(
                    Convert.ToString(Session["Role"]), out role)
                && role == 1
                && int.TryParse(
                    Convert.ToString(Session["UserID"]), out userID)
                && userID > 0;
        }

        private int GetUserID()
        {
            return Convert.ToInt32(Session["UserID"]);
        }

        protected void btnApply_Click(object sender, EventArgs e)
        {
            AppliedSearch = (txtSearch.Text ?? "").Trim();
            AppliedStatus = ddlStatus.SelectedValue;
            AppliedSort = ddlSort.SelectedValue;

            CurrentPage = 1;
            LoadHistory();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlStatus.SelectedValue = "All";
            ddlSort.SelectedValue = "Newest";

            AppliedSearch = "";
            AppliedStatus = "All";
            AppliedSort = "Newest";

            CurrentPage = 1;
            LoadHistory();
        }

        private void LoadHistory()
        {
            try
            {
                DataSet ds = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebHistorySearch", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@UserID", SqlDbType.Int).Value =
                        GetUserID();

                    cmd.Parameters.Add(
                        "@Search", SqlDbType.NVarChar, 255).Value =
                        string.IsNullOrWhiteSpace(AppliedSearch)
                            ? (object)DBNull.Value
                            : AppliedSearch;

                    cmd.Parameters.Add(
                        "@Status", SqlDbType.VarChar, 20).Value =
                        AppliedStatus;

                    cmd.Parameters.Add(
                        "@Sort", SqlDbType.VarChar, 20).Value =
                        AppliedSort;

                    cmd.Parameters.Add(
                        "@PageNumber", SqlDbType.Int).Value =
                        CurrentPage;

                    cmd.Parameters.Add(
                        "@PageSize", SqlDbType.Int).Value =
                        PageSize;

                    using (SqlDataAdapter da =
                        new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count < 3)
                {
                    throw new InvalidOperationException(
                        "The history procedure returned incomplete data.");
                }

                DataTable summary = ds.Tables[0];
                DataTable counts = ds.Tables[1];
                DataTable records = ds.Tables[2];

                if (summary.Rows.Count > 0)
                {
                    DataRow row = summary.Rows[0];

                    lblHistoryCount.Text =
                        Convert.ToString(row["HistoryCount"]);

                    lblReturnedCount.Text =
                        Convert.ToString(row["ReturnedCount"]);

                    lblCancelledCount.Text =
                        Convert.ToString(row["CancelledCount"]);
                }
                else
                {
                    lblHistoryCount.Text = "0";
                    lblReturnedCount.Text = "0";
                    lblCancelledCount.Text = "0";
                }

                int filteredCount = 0;

                if (counts.Rows.Count > 0)
                {
                    filteredCount = Convert.ToInt32(
                        counts.Rows[0]["FilteredCount"]);
                }

                TotalPages = Math.Max(
                    1,
                    (int)Math.Ceiling(
                        filteredCount / (double)PageSize));

                if (CurrentPage > TotalPages)
                {
                    CurrentPage = TotalPages;
                    LoadHistory();
                    return;
                }

                gvHistory.DataSource = records;
                gvHistory.DataBind();

                int firstRecord = filteredCount == 0
                    ? 0
                    : ((CurrentPage - 1) * PageSize) + 1;

                int lastRecord = Math.Min(
                    CurrentPage * PageSize,
                    filteredCount);

                lblResults.Text = string.Format(
                    "Showing {0}–{1} of {2} matching records",
                    firstRecord,
                    lastRecord,
                    filteredCount);

                lblPageInfo.Text = string.Format(
                    "Page {0} of {1}",
                    CurrentPage,
                    TotalPages);

                btnPrevious.Enabled = CurrentPage > 1;
                btnNext.Enabled = CurrentPage < TotalPages;

                btnPrevious.Visible = TotalPages > 1;
                btnNext.Visible = TotalPages > 1;

                lblMessage.Text = "";
            }
            catch (Exception ex)
            {
                gvHistory.DataSource = null;
                gvHistory.DataBind();

                lblResults.Text = "Unable to load history.";
                lblPageInfo.Text = "Page 1 of 1";

                btnPrevious.Visible = false;
                btnNext.Visible = false;

                lblMessage.CssClass = "el-history-message";
                lblMessage.Text = Server.HtmlEncode(
                    "Unable to load history: " + ex.Message);
            }
        }

        protected void btnPrevious_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadHistory();
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            if (CurrentPage < TotalPages)
            {
                CurrentPage++;
                LoadHistory();
            }
        }

        protected string FormatHistoryDate(object value)
        {
            if (value == null || value == DBNull.Value)
                return "—";

            DateTime date;

            if (DateTime.TryParse(
                Convert.ToString(value), out date))
            {
                return date.ToString("MMM dd, yyyy");
            }

            return "—";
        }

        protected string GetStatusClass(object value)
        {
            string status = Convert.ToString(value)
                .ToLowerInvariant();

            if (status == "returned")
                return "el-history-pill returned";

            if (status == "cancelled")
                return "el-history-pill cancelled";

            if (status == "lost")
                return "el-history-pill lost";

            return "el-history-pill";
        }

        protected void btnCurrentBorrows_Click(
            object sender, EventArgs e)
        {
            Response.Redirect("~/Customer/MyBorrows.aspx");
        }
    }
}
