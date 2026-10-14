
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ELibrary
{
    public partial class CustomerHome : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager
                .ConnectionStrings["ElibraryConnection"]
                .ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            int role;
            int userID;

            if (Session["UserID"] == null ||
                Session["Role"] == null ||
                !int.TryParse(
                    Convert.ToString(Session["Role"]),
                    out role) ||
                role != 1 ||
                !int.TryParse(
                    Convert.ToString(Session["UserID"]),
                    out userID) ||
                userID <= 0)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadDashboard();
                LoadFeaturedBooks();
            }
        }

        private void LoadDashboard()
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand("EDashboard_Customer", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@UserID", SqlDbType.Int).Value =
                        Convert.ToInt32(Session["UserID"]);

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblFullName.Text =
                                Server.HtmlEncode(
                                    Convert.ToString(reader["FullName"]));

                            lblActiveBorrowings.Text =
                                Convert.ToString(
                                    reader["ActiveBorrowings"]);

                            lblOverdueBooks.Text =
                                Convert.ToString(
                                    reader["OverdueBooks"]);

                            lblPendingReturns.Text =
                                Convert.ToString(
                                    reader["PendingReturns"]);

                            lblReturnedBooks.Text =
                                Convert.ToString(
                                    reader["ReturnedBooks"]);

                            lblPendingPickups.Text =
                                Convert.ToString(
                                    reader["PendingPickups"]);

                            lblCancelledReservations.Text =
                                Convert.ToString(
                                    reader["CancelledReservations"]);

                            decimal unpaidBalance = 0;

                            if (reader["UnpaidBalance"] != DBNull.Value)
                            {
                                unpaidBalance = Convert.ToDecimal(
                                    reader["UnpaidBalance"]);
                            }

                            lblUnpaidBalance.Text =
                                unpaidBalance.ToString("N2");

                            lblMessage.Text = "";
                        }
                        else
                        {
                            ShowError("Customer account not found.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError(
                    "Unable to load dashboard: " + ex.Message);
            }
        }

        private void LoadFeaturedBooks()
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand(@"
                        SELECT TOP (8)
                            B.BookID,
                            B.Title,
                            B.Author,
                            B.CoverImagePath,
                            B.AvailableCopies,
                            G.GenreName
                        FROM dbo.EBook AS B
                        INNER JOIN dbo.EGenre AS G
                            ON B.GenreID = G.GenreID
                        WHERE B.IsArchived = 0
                        ORDER BY B.BookID DESC;", con))
                {
                    DataTable table = new DataTable();

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(table);
                    }

                    rptFeaturedBooks.DataSource = table;
                    rptFeaturedBooks.DataBind();

                    pnlFeaturedBooks.Visible =
                        table.Rows.Count > 0;

                    pnlNoFeaturedBooks.Visible =
                        table.Rows.Count == 0;
                }
            }
            catch (Exception ex)
            {
                pnlFeaturedBooks.Visible = false;
                pnlNoFeaturedBooks.Visible = true;

                ShowError(
                    "Unable to load featured books: " +
                    ex.Message);
            }
        }

        private void ShowError(string message)
        {
            lblMessage.CssClass =
                "el-customer-message text-danger";

            lblMessage.Text =
                Server.HtmlEncode(message);
        }

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
                Convert.ToString(value), out bookID))
            {
                return ResolveUrl("~/Customer/Books.aspx");
            }

            return ResolveUrl(
                "~/Customer/BookDetails.aspx?BookID=" + bookID);
        }

        protected string GetAvailabilityText(object value)
        {
            int availableCopies;

            if (!int.TryParse(
                Convert.ToString(value), out availableCopies))
            {
                availableCopies = 0;
            }

            return availableCopies > 0
                ? "Available"
                : "Unavailable";
        }

        protected string GetAvailabilityClass(object value)
        {
            int availableCopies;

            if (!int.TryParse(
                Convert.ToString(value), out availableCopies))
            {
                availableCopies = 0;
            }

            return availableCopies > 0
                ? "el-book-status available"
                : "el-book-status unavailable";
        }
    }
}
