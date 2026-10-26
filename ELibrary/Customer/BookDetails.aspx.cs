
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;

namespace ELibrary.Customer
{
    public partial class BookDetails : System.Web.UI.Page
    {
        // ==========================================
        // V2 DATABASE CONNECTION
        // ==========================================

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
                    out id) && id > 0)
                {
                    return id;
                }

                return 0;
            }
        }

        private int CustomerUserID
        {
            get
            {
                int id;

                if (int.TryParse(
                    Convert.ToString(Session["UserID"]),
                    out id) && id > 0)
                {
                    return id;
                }

                return 0;
            }
        }

        // ==========================================
        // PAGE LOAD
        // ==========================================

        protected void Page_Load(
            object sender,
            EventArgs e)
        {
            if (!IsCustomer())
            {
                Response.Redirect(
                    "~/Login.aspx",
                    false);

                Context.ApplicationInstance
                    .CompleteRequest();

                return;
            }

            if (!IsPostBack)
            {
                if (BookID <= 0)
                {
                    ShowError("Invalid book ID.");
                    btnBorrow.Enabled = false;
                    return;
                }

                LoadBook();
            }
        }

        private bool IsCustomer()
        {
            int role;

            return CustomerUserID > 0
                && Session["Role"] != null
                && int.TryParse(
                    Convert.ToString(Session["Role"]),
                    out role)
                && role == 1;
        }

        // ==========================================
        // STORED PROCEDURE HELPER
        // ==========================================

        private SqlCommand CreateProcedure(
            string procedureName,
            SqlConnection connection)
        {
            SqlCommand cmd =
                new SqlCommand(
                    procedureName,
                    connection);

            cmd.CommandType =
                CommandType.StoredProcedure;

            cmd.CommandTimeout = 30;

            return cmd;
        }

        // ==========================================
        // V2 RESERVATION PREVIEW
        // ==========================================

        private DataRow GetBookPreview()
        {
            DataTable table = new DataTable();

            using (SqlConnection con =
                new SqlConnection(ConnectionString))
            using (SqlCommand cmd =
                CreateProcedure(
                    "dbo.EBook_WebCustomerReservationPreview",
                    con))
            {
                cmd.Parameters.Add(
                    "@BookID",
                    SqlDbType.Int).Value = BookID;

                cmd.Parameters.Add(
                    "@UserID",
                    SqlDbType.Int).Value =
                    CustomerUserID;

                using (SqlDataAdapter adapter =
                    new SqlDataAdapter(cmd))
                {
                    adapter.Fill(table);
                }
            }

            if (table.Rows.Count == 0)
            {
                throw new InvalidOperationException(
                    "Book was not found.");
            }

            return table.Rows[0];
        }

        // ==========================================
        // DISPLAY BOOK AND UPFRONT COST
        // ==========================================

        private void LoadBook()
        {
            try
            {
                DataRow book = GetBookPreview();

                lblTitle.Text =
                    Server.HtmlEncode(
                        Convert.ToString(book["Title"]));

                lblAuthor.Text =
                    Server.HtmlEncode(
                        Convert.ToString(book["Author"]));

                lblISBN.Text =
                    Server.HtmlEncode(
                        Convert.ToString(book["ISBN"]));

                lblGenre.Text =
                    Server.HtmlEncode(
                        Convert.ToString(book["GenreName"]));

                lblDescription.Text =
                    Server.HtmlEncode(
                        Convert.ToString(book["BookDesc"]));

                lblTotalCopies.Text =
                    Convert.ToString(book["TotalCopies"]);

                lblAvailableCopies.Text =
                    Convert.ToString(
                        book["AvailableCopies"]);

                decimal borrowingFee =
                    Convert.ToDecimal(
                        book["BorrowingFee"]);

                decimal securityDeposit =
                    Convert.ToDecimal(
                        book["SecurityDeposit"]);

                decimal totalUpfront =
                    Convert.ToDecimal(
                        book["TotalUpfront"]);

                // Keep the approved V1 borrowing-fee
                // control and its original formatting.
                lblBorrowingFee.Text =
                    borrowingFee.ToString(
                        "N2",
                        CultureInfo.GetCultureInfo("en-PH"));

                imgBookCover.ImageUrl =
                    GetCoverUrl(
                        book["CoverImagePath"]);

                bool canReserve =
                    Convert.ToBoolean(
                        book["CanReserve"]);

                string availability =
                    Convert.ToString(
                        book["AvailabilityText"]);

                SetAvailability(
                    availability,
                    canReserve);

                btnBorrow.Enabled = canReserve;

                // Display the V2 financial explanation
                // using the existing page message area.
                // No V1 markup or control IDs are changed.
                if (canReserve)
                {
                    ShowInformation(
                        "Upfront payment: Borrowing fee " +
                        FormatPeso(borrowingFee) +
                        " + refundable security deposit " +
                        FormatPeso(securityDeposit) +
                        " = " +
                        FormatPeso(totalUpfront) +
                        ". Reserving the book does not " +
                        "record payment. Both amounts must " +
                        "be paid and verified before pickup.");
                }
                else
                {
                    ShowInformation(
                        "Reservation status: " +
                        availability +
                        ". Borrowing fee: " +
                        FormatPeso(borrowingFee) +
                        ". Refundable security deposit: " +
                        FormatPeso(securityDeposit) +
                        ".");
                }
            }
            catch (SqlException ex)
            {
                btnBorrow.Enabled = false;

                ShowError(
                    "Unable to load book details: " +
                    ex.Message);
            }
            catch (Exception)
            {
                btnBorrow.Enabled = false;

                ShowError(
                    "Unable to load the book. " +
                    "Please return to the catalog " +
                    "and try again.");
            }
        }

        // ==========================================
        // FORMAT CURRENCY
        // ==========================================

        private string FormatPeso(decimal amount)
        {
            return "₱" + amount.ToString(
                "N2",
                CultureInfo.GetCultureInfo("en-PH"));
        }

        // ==========================================
        // AVAILABILITY DISPLAY
        // ==========================================

        private void SetAvailability(
            string status,
            bool available)
        {
            lblAvailabilityStatus.Text =
                Server.HtmlEncode(status);

            lblAvailabilityStatus.CssClass =
                available
                    ? "el-catalog-status available"
                    : "el-catalog-status unavailable";
        }

        // ==========================================
        // BOOK COVER
        // ==========================================

        private string GetCoverUrl(object value)
        {
            string path =
                Convert.ToString(value);

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
                Response.Redirect(
                    "~/Login.aspx",
                    false);

                Context.ApplicationInstance
                    .CompleteRequest();

                return;
            }

            if (BookID <= 0)
            {
                ShowError("Invalid book ID.");
                btnBorrow.Enabled = false;
                return;
            }

            // The preview is informational.
            // EBorrowLog_WebPost must independently
            // validate stock and customer eligibility.
            try
            {
                DataRow preview =
                    GetBookPreview();

                if (!Convert.ToBoolean(
                    preview["CanReserve"]))
                {
                    btnBorrow.Enabled = false;

                    ShowError(
                        "Reservation unavailable: " +
                        Convert.ToString(
                            preview["AvailabilityText"]));

                    return;
                }
            }
            catch (Exception)
            {
                ShowError(
                    "Unable to verify book availability. " +
                    "No new reservation was submitted.");

                return;
            }

            // ======================================
            // CREATE RESERVATION — V2 PROCEDURE
            // ======================================

            try
            {
                int borrowLogID;

                using (SqlConnection con =
                    new SqlConnection(ConnectionString))
                using (SqlCommand cmd =
                    CreateProcedure(
                        "dbo.EBorrowLog_WebPost",
                        con))
                {
                    cmd.Parameters.Add(
                        "@BookID",
                        SqlDbType.Int).Value =
                        BookID;

                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value =
                        CustomerUserID;

                    con.Open();

                    object result =
                        cmd.ExecuteScalar();

                    if (result == null ||
                        result == DBNull.Value)
                    {
                        throw new InvalidOperationException(
                            "Reservation confirmation " +
                            "was not returned.");
                    }

                    borrowLogID =
                        Convert.ToInt32(result);
                }

                // The reservation is created but unpaid.
                // The SQL transaction reserves stock
                // and creates the required financial rows.

                LoadBook();

                btnBorrow.Enabled = false;

                SetAvailability(
                    "Already Reserved",
                    false);

                ShowSuccess(
                    "Book reserved successfully! " +
                    "Reservation ID: " +
                    borrowLogID +
                    ". Please pay the borrowing fee " +
                    "and refundable security deposit " +
                    "before collecting the book. " +
                    "The librarian must verify both " +
                    "payments and confirm pickup. " +
                    "Your seven-day borrowing period " +
                    "begins only after collection.");
            }
            catch (SqlException ex)
            {
                // SQL procedure validates stock,
                // duplicates, customer permissions,
                // and rolls back failed reservations.
                LoadBook();

                ShowError(ex.Message);
            }
            catch (Exception)
            {
                // An interrupted connection can leave
                // the result uncertain. Refresh rather
                // than automatically retry the insert.
                btnBorrow.Enabled = false;

                ShowError(
                    "The reservation result could not " +
                    "be confirmed. Review My Borrowings " +
                    "before attempting another reservation.");
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
                "~/Customer/Books.aspx",
                false);

            Context.ApplicationInstance
                .CompleteRequest();
        }

        // ==========================================
        // USER MESSAGES
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

        private void ShowInformation(string message)
        {
            lblMessage.ForeColor =
                Color.FromArgb(25, 107, 114);

            lblMessage.CssClass =
                "el-book-details-message";

            lblMessage.Text =
                Server.HtmlEncode(message);
        }
    }
}
