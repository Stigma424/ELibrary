
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary.Customer
{
    public partial class Books : Page
    {
        private const int PageSize = 12;

        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["ElibraryConnection"]
                    .ConnectionString;
            }
        }

        // ==========================================
        // APPLIED FILTERS
        // ==========================================

        private string AppliedSearch
        {
            get { return (string)(ViewState["AppliedSearch"] ?? ""); }
            set { ViewState["AppliedSearch"] = value; }
        }

        private int? AppliedGenreID
        {
            get
            {
                object value = ViewState["AppliedGenreID"];
                return value == null ? (int?)null : (int)value;
            }
            set
            {
                ViewState["AppliedGenreID"] = value;
            }
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

        // ==========================================
        // PAGE LOAD
        // ==========================================

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsCustomer())
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadGenres();
                LoadBooks();
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
                out role) && role == 1;
        }

        // ==========================================
        // LOAD GENRES
        // ==========================================

        private void LoadGenres()
        {
            ddlGenre.Items.Clear();
            ddlGenre.Items.Add(
                new ListItem("All Genres", ""));

            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand("EGenre_Web", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            ddlGenre.Items.Add(
                                new ListItem(
                                    Convert.ToString(reader["GenreName"]),
                                    Convert.ToString(reader["GenreID"])));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError(
                    "Unable to load genres: " + ex.Message);
            }
        }

        // ==========================================
        // APPLY / CLEAR
        // ==========================================

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            AppliedSearch = (txtSearch.Text ?? "").Trim();

            int genreID;

            AppliedGenreID = int.TryParse(
                ddlGenre.SelectedValue,
                out genreID)
                ? (int?)genreID
                : null;

            CurrentPage = 1;
            LoadBooks();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlGenre.SelectedIndex = 0;

            AppliedSearch = "";
            AppliedGenreID = null;

            CurrentPage = 1;
            LoadBooks();
        }

        // ==========================================
        // DATABASE SEARCH AND PAGINATION
        // ==========================================

        private void LoadBooks()
        {
            try
            {
                DataSet ds = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBook_WebCatalogSearch", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@Search", SqlDbType.VarChar, 255).Value =
                        string.IsNullOrWhiteSpace(AppliedSearch)
                        ? (object)DBNull.Value
                        : AppliedSearch;

                    cmd.Parameters.Add(
                        "@GenreID", SqlDbType.Int).Value =
                        AppliedGenreID.HasValue
                        ? (object)AppliedGenreID.Value
                        : DBNull.Value;

                    cmd.Parameters.Add(
                        "@PageNumber", SqlDbType.Int).Value =
                        CurrentPage;

                    cmd.Parameters.Add(
                        "@PageSize", SqlDbType.Int).Value =
                        PageSize;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(ds);
                    }
                }

                if (ds.Tables.Count < 2)
                {
                    throw new Exception(
                        "The catalog procedure returned incomplete data.");
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

                // Handle deleted or archived books changing
                // the available number of pages.
                if (CurrentPage > TotalPages)
                {
                    CurrentPage = TotalPages;
                    LoadBooks();
                    return;
                }

                DataTable books = ds.Tables[1];

                rptBooks.DataSource = books;
                rptBooks.DataBind();

                bool hasBooks = books.Rows.Count > 0;

                pnlBookResults.Visible = hasBooks;
                pnlEmptyResults.Visible = !hasBooks;

                lblResultCount.Text = filteredCount == 1
                    ? "1 book found"
                    : filteredCount + " books found";

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
                rptBooks.DataSource = null;
                rptBooks.DataBind();

                pnlBookResults.Visible = false;
                pnlEmptyResults.Visible = true;

                lblResultCount.Text = "0 books found";
                lblPageInfo.Text = "Page 1 of 1";

                btnPrevious.Visible = false;
                btnNext.Visible = false;

                ShowError(
                    "Unable to load books: " + ex.Message);
            }
        }

        // ==========================================
        // PAGINATION
        // ==========================================

        protected void btnPrevious_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                LoadBooks();
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            if (CurrentPage < TotalPages)
            {
                CurrentPage++;
                LoadBooks();
            }
        }

        // ==========================================
        // DISPLAY HELPERS
        // ==========================================

        protected string GetCoverUrl(object value)
        {
            string path = Convert.ToString(value);

            if (string.IsNullOrWhiteSpace(path) ||
                !path.StartsWith(
                    "~/Uploads/BookCovers/",
                    StringComparison.OrdinalIgnoreCase))
            {
                return ResolveUrl(
                    "~/Content/Images/default-book.svg");
            }

            return ResolveUrl(path);
        }

        protected string GetBookDetailsUrl(object value)
        {
            int bookID;

            if (!int.TryParse(
                Convert.ToString(value),
                out bookID))
            {
                return ResolveUrl("~/Customer/Books.aspx");
            }

            return ResolveUrl(
                "~/Customer/BookDetails.aspx?BookID=" + bookID);
        }

        protected string GetAvailabilityText(object value)
        {
            int copies;

            if (!int.TryParse(
                Convert.ToString(value),
                out copies))
            {
                copies = 0;
            }

            return copies > 0
                ? "Available"
                : "Unavailable";
        }

        protected string GetAvailabilityClass(object value)
        {
            int copies;

            if (!int.TryParse(
                Convert.ToString(value),
                out copies))
            {
                copies = 0;
            }

            return copies > 0
                ? "el-catalog-status available"
                : "el-catalog-status unavailable";
        }

        // ==========================================
        // ERROR MESSAGE
        // ==========================================

        private void ShowError(string message)
        {
            lblMessage.CssClass =
                "el-catalog-message text-danger";

            lblMessage.Text =
                Server.HtmlEncode(message);
        }
    }
}
