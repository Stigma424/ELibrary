
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

namespace ELibrary
{
    public partial class AdminHome : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager
                .ConnectionStrings["ElibraryConnection"]
                .ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                LoadDashboard();
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

        private void LoadDashboard()
        {
            try
            {
                DataTable data = new DataTable();

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "dbo.EDashboard_Admin", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.CommandTimeout = 30;

                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(data);
                    }
                }

                if (data.Rows.Count == 0)
                {
                    throw new InvalidOperationException(
                        "Dashboard returned no records.");
                }

                DataRow row = data.Rows[0];

                lblActiveBorrowings.Text =
                    Number(row, "ActiveBorrowings");

                lblOverdueBooks.Text =
                    Number(row, "OverdueBooks");

                lblPendingPickups.Text =
                    Number(row, "PendingPickups");

                lblTotalUnpaidBalance.Text =
                    Convert.ToDecimal(
                        ReadValue(row, "TotalUnpaidBalance"))
                    .ToString(
                        "N2",
                        CultureInfo.GetCultureInfo("en-PH"));

                lblPendingReturns.Text =
                    Number(row, "PendingReturns");

                lblAwaitingPayment.Text =
                    Number(row, "ReservationsAwaitingPayment");

                lblPendingRefunds.Text =
                    Number(row, "PendingDepositRefunds");

                lblExpiredReservations.Text =
                    Number(row, "ExpiredReservations");

                lblDepositsHeld.Text =
                    Currency(row, "TotalDepositsHeld");

                lblDepositsRefunded.Text =
                    Currency(row, "TotalDepositsRefunded");

                lblDepositsOnHold.Text =
                    Number(row, "DepositsOnHold");

                lblTotalBooks.Text =
                    Number(row, "TotalBooks");

                lblAvailableCopies.Text =
                    Number(row, "AvailableCopies");

                lblTotalCustomers.Text =
                    Number(row, "TotalCustomers");

                lblArchivedBooks.Text =
                    Number(row, "ArchivedBooks");

                lblMessage.Text = "";
            }
            catch (Exception ex)
            {
                lblMessage.Text =
                    Server.HtmlEncode(
                        "Unable to load dashboard: " +
                        ex.Message);
            }
        }

        protected void btnRefresh_Click(
            object sender,
            EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
                return;

            LoadDashboard();
        }
    }
}
