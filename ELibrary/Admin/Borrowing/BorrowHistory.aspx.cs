
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

namespace ELibrary.Admin.Borrowing
{
    public partial class BorrowHistory : System.Web.UI.Page
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
            get { return (string)(ViewState["AppliedSort"] ?? "Default"); }
            set { ViewState["AppliedSort"] = value; }
        }

        private DateTime? AppliedDateFrom
        {
            get
            {
                object value = ViewState["AppliedDateFrom"];
                return value == null
                    ? (DateTime?)null
                    : (DateTime)value;
            }
            set { ViewState["AppliedDateFrom"] = value; }
        }

        private DateTime? AppliedDateTo
        {
            get
            {
                object value = ViewState["AppliedDateTo"];
                return value == null
                    ? (DateTime?)null
                    : (DateTime)value;
            }
            set { ViewState["AppliedDateTo"] = value; }
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
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadHistory();
            }
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
                        "EBorrowLog_WebAdminHistorySearch", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@Search", SqlDbType.VarChar, 255).Value =
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
                        "@DateFrom", SqlDbType.Date).Value =
                        AppliedDateFrom.HasValue
                            ? (object)AppliedDateFrom.Value.Date
                            : DBNull.Value;

                    cmd.Parameters.Add(
                        "@DateTo", SqlDbType.Date).Value =
                        AppliedDateTo.HasValue
                            ? (object)AppliedDateTo.Value.Date
                            : DBNull.Value;

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

                if (ds.Tables.Count < 2)
                {
                    throw new InvalidOperationException(
                        "History search returned incomplete data.");
                }

                int filteredCount = 0;

                if (ds.Tables[0].Rows.Count > 0)
                {
                    filteredCount = Convert.ToInt32(
                        ds.Tables[0].Rows[0]["FilteredCount"]);
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

                gvHistory.DataSource = ds.Tables[1];
                gvHistory.DataBind();

                int first = filteredCount == 0
                    ? 0
                    : (CurrentPage - 1) * PageSize + 1;

                int last = Math.Min(
                    CurrentPage * PageSize,
                    filteredCount);

                lblResultCount.Text = string.Format(
                    "Showing {0}–{1} of {2} history records",
                    first, last, filteredCount);

                lblPageInfo.Text = string.Format(
                    "Page {0} of {1}",
                    CurrentPage, TotalPages);

                btnPrevious.Visible = TotalPages > 1;
                btnNext.Visible = TotalPages > 1;

                btnPrevious.Enabled = CurrentPage > 1;
                btnNext.Enabled = CurrentPage < TotalPages;

                lblMessage.Text = "";
            }
            catch (Exception ex)
            {
                gvHistory.DataSource = null;
                gvHistory.DataBind();

                lblResultCount.Text = "Unable to load history.";
                lblPageInfo.Text = "Page 1 of 1";

                btnPrevious.Visible = false;
                btnNext.Visible = false;

                ShowMessage(
                    "Unable to load borrowing history: " +
                    ex.Message);
            }
        }

        protected void btnApply_Click(object sender, EventArgs e)
        {
            DateTime? dateFrom;
            DateTime? dateTo;

            if (!TryReadDate(
                txtDateFrom.Text, "Reserved From", out dateFrom))
                return;

            if (!TryReadDate(
                txtDateTo.Text, "Reserved To", out dateTo))
                return;

            if (dateFrom.HasValue && dateTo.HasValue &&
                dateFrom.Value > dateTo.Value)
            {
                ShowMessage(
                    "Reserved From cannot be later than Reserved To.");
                return;
            }

            AppliedSearch = (txtSearch.Text ?? "").Trim();
            AppliedStatus = ddlStatus.SelectedValue;
            AppliedSort = ddlSort.SelectedValue;

            AppliedDateFrom = dateFrom;
            AppliedDateTo = dateTo;

            CurrentPage = 1;
            LoadHistory();
        }

        private bool TryReadDate(
            string input,
            string fieldName,
            out DateTime? result)
        {
            result = null;

            if (string.IsNullOrWhiteSpace(input))
                return true;

            DateTime parsedDate;

            if (!DateTime.TryParseExact(
                input.Trim(),
                "yyyy-MM-dd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out parsedDate))
            {
                ShowMessage(
                    fieldName + " must be a valid date.");
                return false;
            }

            if (fieldName == "Reserved To" &&
                parsedDate.Date == DateTime.MaxValue.Date)
            {
                ShowMessage(
                    "Reserved To must be earlier than 9999-12-31.");
                return false;
            }

            result = parsedDate.Date;
            return true;
        }

        protected void btnClearFilters_Click(
            object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlStatus.SelectedValue = "All";
            ddlSort.SelectedValue = "Default";

            txtDateFrom.Text = "";
            txtDateTo.Text = "";

            AppliedSearch = "";
            AppliedStatus = "All";
            AppliedSort = "Default";

            AppliedDateFrom = null;
            AppliedDateTo = null;

            CurrentPage = 1;
            LoadHistory();
        }

        protected void btnPrevious_Click(
            object sender, EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadHistory();
            }
        }

        protected void btnNext_Click(
            object sender, EventArgs e)
        {
            if (CurrentPage < TotalPages)
            {
                CurrentPage++;
                LoadHistory();
            }
        }

        protected void btnRefresh_Click(
            object sender, EventArgs e)
        {
            LoadHistory();
        }

        protected string FormatHistoryDate(object value)
        {
            if (value == null || value == DBNull.Value)
                return "—";

            DateTime date;

            if (DateTime.TryParse(
                Convert.ToString(value), out date))
            {
                return date.ToString("MM/dd/yyyy hh:mm tt");
            }

            return "—";
        }

        protected string GetStatusClass(object value)
        {
            string status = Convert.ToString(value);

            if (status == "Returned")
                return "br-pill success";

            if (status == "Lost")
                return "br-pill danger";

            if (status == "Cancelled")
                return "br-pill cancelled";

            return "br-pill";
        }

        private void ShowMessage(string message)
        {
            lblMessage.CssClass = "br-message";
            lblMessage.Text = Server.HtmlEncode(message);
        }
    }
}
