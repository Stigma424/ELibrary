
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;

namespace ELibrary.Customer
{
    public partial class BookDetails : System.Web.UI.Page
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

        private int BookID
        {
            get
            {
                int id;

                if (int.TryParse(
                    Request.QueryString["BookID"],
                    out id))
                {
                    return id;
                }

                return 0;
            }
        }

        protected void Page_Load(
            object sender,
            EventArgs e)
        {
            if (!IsCustomer())
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (BookID <= 0)
                {
                    ShowError("Invalid book.");
                    btnBorrow.Enabled = false;
                    return;
                }

                LoadBook();
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
        // LOAD BOOK DETAILS
        // ==========================================

        private void LoadBook()
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                {
                    con.Open();

                    using (SqlCommand cmd =
                        new SqlCommand(
                            "EBook_WebOne", con))
                    {
                        cmd.CommandType =
                            CommandType.StoredProcedure;

                        cmd.Parameters.Add(
                            "@BookID",
                            SqlDbType.Int).Value =
                            BookID;

                        using (SqlDataReader reader =
                            cmd.ExecuteReader())
                        {
                            if (!reader.Read())
                            {
                                ShowError("Book not found.");

                                btnBorrow.Enabled = false;
                                return;
                            }

                            lblTitle.Text =
                                Server.HtmlEncode(
                                    Convert.ToString(
                                        reader["Title"]));

                            lblAuthor.Text =
                                Server.HtmlEncode(
                                    Convert.ToString(
                                        reader["Author"]));

                            lblISBN.Text =
                                Server.HtmlEncode(
                                    Convert.ToString(
                                        reader["ISBN"]));

                            lblGenre.Text =
                                Server.HtmlEncode(
                                    Convert.ToString(
                                        reader["GenreName"]));

                            lblDescription.Text =
                                Server.HtmlEncode(
                                    Convert.ToString(
                                        reader["BookDesc"]));

                            lblTotalCopies.Text =
                                Convert.ToString(
                                    reader["TotalCopies"]);

                            int available =
                                Convert.ToInt32(
                                    reader["AvailableCopies"]);

                            lblAvailableCopies.Text =
                                available.ToString();

                            decimal fee =
                                Convert.ToDecimal(
                                    reader["BorrowingFee"]);

                            lblBorrowingFee.Text =
                                fee.ToString("N2");

                            bool archived =
                                Convert.ToBoolean(
                                    reader["IsArchived"]);

                            if (archived)
                            {
                                SetAvailability(
                                    "Archived", false);

                                btnBorrow.Enabled = false;
                            }
                            else if (available <= 0)
                            {
                                SetAvailability(
                                    "Unavailable", false);

                                btnBorrow.Enabled = false;
                            }
                            else
                            {
                                SetAvailability(
                                    "Available", true);

                                btnBorrow.Enabled = true;
                            }
                        }
                    }

                    // Load book cover

                    using (SqlCommand coverCmd =
                        new SqlCommand(@"
                            SELECT CoverImagePath
                            FROM dbo.EBook
                            WHERE BookID = @BookID;",
                            con))
                    {
                        coverCmd.Parameters.Add(
                            "@BookID",
                            SqlDbType.Int).Value =
                            BookID;

                        object cover =
                            coverCmd.ExecuteScalar();

                        imgBookCover.ImageUrl =
                            GetCoverUrl(cover);
                    }

                    // Check whether this customer already
                    // has a pending or active borrowing.

                    using (SqlCommand checkCmd =
                        new SqlCommand(@"
                            SELECT TOP (1)
                                CollectionStatus
                            FROM dbo.EBorrowLog
                            WHERE BookID = @BookID
                              AND UserID = @UserID
                              AND
                              (
                                  CollectionStatus = 'Pending'
                                  OR
                                  (
                                      CollectionStatus = 'Collected'
                                      AND Status IN
                                          ('Borrowed', 'Overdue')
                                  )
                              );",
                            con))
                    {
                        checkCmd.Parameters.Add(
                            "@BookID",
                            SqlDbType.Int).Value =
                            BookID;

                        checkCmd.Parameters.Add(
                            "@UserID",
                            SqlDbType.Int).Value =
                            Convert.ToInt32(
                                Session["UserID"]);

                        object existing =
                            checkCmd.ExecuteScalar();

                        if (existing != null &&
                            existing != DBNull.Value)
                        {
                            string collectionStatus =
                                Convert.ToString(existing);

                            btnBorrow.Enabled = false;

                            if (collectionStatus == "Pending")
                            {
                                SetAvailability(
                                    "Already Reserved",
                                    false);
                            }
                            else
                            {
                                SetAvailability(
                                    "Already Borrowed",
                                    false);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError(
                    "Unable to load book: " +
                    ex.Message);

                btnBorrow.Enabled = false;
            }
        }

        // ==========================================
        // AVAILABILITY DISPLAY
        // ==========================================

        private void SetAvailability(
            string status,
            bool available)
        {
            lblAvailabilityStatus.Text = status;

            lblAvailabilityStatus.CssClass =
                available
                    ? "el-catalog-status available"
                    : "el-catalog-status unavailable";
        }

        private string GetCoverUrl(object value)
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

        // ==========================================
        // RESERVE BOOK
        // ==========================================

        protected void btnBorrow_Click(
            object sender,
            EventArgs e)
        {
            if (!IsCustomer())
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (BookID <= 0)
            {
                ShowError("Invalid book.");
                btnBorrow.Enabled = false;
                return;
            }

            int userID =
                Convert.ToInt32(Session["UserID"]);

            try
            {
                int borrowLogID;

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EBorrowLog_WebPost", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@BookID",
                        SqlDbType.Int).Value =
                        BookID;

                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value =
                        userID;

                    con.Open();

                    object result =
                        cmd.ExecuteScalar();

                    if (result == null ||
                        result == DBNull.Value)
                    {
                        throw new InvalidOperationException(
                            "Reservation confirmation was not returned.");
                    }

                    borrowLogID =
                        Convert.ToInt32(result);
                }

                // Refresh availability and cover

                LoadBook();

                // Disable repeated reservation

                btnBorrow.Enabled = false;

                SetAvailability(
                    "Already Reserved", false);

                ShowSuccess(
                    "Book reserved successfully! " +
                    "Reservation ID: " +
                    borrowLogID +
                    ". Please collect the book from " +
                    "the library. Your 7-day borrowing " +
                    "period will begin when the " +
                    "librarian confirms collection.");
            }
            catch (SqlException ex)
            {
                LoadBook();
                ShowError(ex.Message);
            }
            catch (Exception ex)
            {
                LoadBook();

                ShowError(
                    "Unable to reserve the book: " +
                    ex.Message);
            }
        }

        // ==========================================
        // NAVIGATION
        // ==========================================

        protected void btnBack_Click(
            object sender,
            EventArgs e)
        {
            Response.Redirect(
                "~/Customer/Books.aspx");
        }

        // ==========================================
        // MESSAGES
        // ==========================================

        private void ShowError(string message)
        {
            lblMessage.ForeColor =
                Color.FromArgb(185, 45, 45);

            lblMessage.CssClass =
                "el-book-details-message error";

            lblMessage.Text =
                Server.HtmlEncode(message);
        }

        private void ShowSuccess(string message)
        {
            lblMessage.ForeColor =
                Color.FromArgb(28, 125, 80);

            lblMessage.CssClass =
                "el-book-details-message success";

            lblMessage.Text =
                Server.HtmlEncode(message);
        }
    }
}
