
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

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

            if (!int.TryParse(
                    Convert.ToString(Session["Role"]),
                    out role) ||
                role != 1 ||
                !int.TryParse(
                    Convert.ToString(Session["UserID"]),
                    out userID) ||
                userID <= 0)
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                LoadDashboard(userID);
                LoadFeaturedBooks();
            }
        }

        private static object ReadValue(
            DataRow row,
            string column)
        {
            if (!row.Table.Columns.Contains(column))
            {
                throw new InvalidOperationException(
                    "Dashboard procedure is missing column: " +
                    column);
            }

            return row[column] == DBNull.Value
                ? 0
                : row[column];
        }

        private static string Number(
            DataRow row,
            string column)
        {
            long value =
                Convert.ToInt64(ReadValue(row, column));

            return value.ToString("N0");
        }

        private static string Currency(
            DataRow row,
            string column)
        {
            decimal value =
                Convert.ToDecimal(ReadValue(row, column));

            return "₱" + value.ToString(
                "N2",
                CultureInfo.GetCultureInfo("en-PH"));
        }

        private void LoadDashboard(int userID)
        {
            try
            {
                DataTable data = new DataTable();

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "dbo.EDashboard_Customer", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.CommandTimeout = 30;

                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value = userID;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(data);
                    }
                }

                if (data.Rows.Count == 0)
                {
                    throw new InvalidOperationException(
                        "Customer dashboard returned no data.");
                }

                DataRow row = data.Rows[0];

                lblFullName.Text =
                    Server.HtmlEncode(
                        Convert.ToString(
                            ReadValue(row, "FullName")));

                lblActiveBorrowings.Text =
                    Number(row, "ActiveBorrowings");

                lblPendingPickups.Text =
                    Number(row, "PendingPickups");

                lblOverdueBooks.Text =
                    Number(row, "OverdueBooks");

                lblUnpaidBalance.Text =
                    Convert.ToDecimal(
                        ReadValue(row, "UnpaidBalance"))
                    .ToString(
                        "N2",
                        CultureInfo.GetCultureInfo("en-PH"));

                lblDepositsHeld.Text =
                    Currency(row, "MyDepositsHeld");

                lblPendingRefunds.Text =
                    Number(row, "MyPendingRefunds");

                lblTotalRefunded.Text =
                    Currency(row, "MyTotalRefunded");

                lblUnpaidReservations.Text =
                    Number(row, "MyUnpaidReservations");

                lblPendingReturns.Text =
                    Number(row, "PendingReturns");

                lblReturnedBooks.Text =
                    Number(row, "ReturnedBooks");

                lblCancelledReservations.Text =
                    Number(row, "CancelledReservations");

                lblMessage.Text = "";
            }
            catch (Exception ex)
            {
                ShowError(
                    "Unable to load dashboard: " +
                    ex.Message);
            }
        }

        private void LoadFeaturedBooks()
        {
            try
            {
                DataSet result = new DataSet();

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "dbo.EBook_WebCatalogSearch", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.CommandTimeout = 30;

                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar,
                        255).Value = DBNull.Value;

                    cmd.Parameters.Add(
                        "@GenreID",
                        SqlDbType.Int).Value = DBNull.Value;

                    cmd.Parameters.Add(
                        "@PageNumber",
                        SqlDbType.Int).Value = 1;

                    cmd.Parameters.Add(
                        "@PageSize",
                        SqlDbType.Int).Value = 4;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(result);
                    }
                }

                if (result.Tables.Count < 2)
                {
                    throw new InvalidOperationException(
                        "Book catalog returned incomplete data.");
                }

                DataTable books = result.Tables[1];

                rptFeaturedBooks.DataSource = books;
                rptFeaturedBooks.DataBind();

                pnlFeaturedBooks.Visible =
                    books.Rows.Count > 0;

                pnlNoFeaturedBooks.Visible =
                    books.Rows.Count == 0;
            }
            catch (Exception ex)
            {
                rptFeaturedBooks.DataSource = null;
                rptFeaturedBooks.DataBind();

                pnlFeaturedBooks.Visible = false;
                pnlNoFeaturedBooks.Visible = true;

                ShowError(
                    "Unable to load featured books: " +
                    ex.Message);
            }
        }

        private void ShowError(string message)
        {
            lblMessage.Text =
                Server.HtmlEncode(message);

            lblMessage.CssClass = "ch-message";
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
                Convert.ToString(value),
                out bookID))
            {
                return ResolveUrl(
                    "~/Customer/Books.aspx");
            }

            return ResolveUrl(
                "~/Customer/BookDetails.aspx?BookID=" +
                bookID);
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
                ? "ch-status"
                : "ch-status unavailable";
        }
    }
}
