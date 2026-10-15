
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

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
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadDashboard();
            }
        }

        private void LoadDashboard()
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand("EDashboard_Admin", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            throw new InvalidOperationException(
                                "The dashboard returned no statistics.");
                        }

                        // ===================================
                        // PRIMARY METRICS
                        // ===================================

                        lblActiveBorrowings.Text =
                            Convert.ToString(
                                reader["ActiveBorrowings"]);

                        lblOverdueBooks.Text =
                            Convert.ToString(
                                reader["OverdueBooks"]);

                        lblPendingPickups.Text =
                            Convert.ToString(
                                reader["PendingPickups"]);

                        lblTotalUnpaidBalance.Text =
                            Convert.ToDecimal(
                                reader["TotalUnpaidBalance"])
                                .ToString("N2");

                        // ===================================
                        // ATTENTION REQUIRED
                        // ===================================

                        lblAttentionOverdue.Text =
                            Convert.ToString(
                                reader["OverdueBooks"]);

                        lblAttentionPickups.Text =
                            Convert.ToString(
                                reader["PendingPickups"]);

                        lblPendingReturns.Text =
                            Convert.ToString(
                                reader["PendingReturns"]);

                        // ===================================
                        // LIBRARY SNAPSHOT
                        // ===================================

                        lblTotalBooks.Text =
                            Convert.ToString(
                                reader["TotalBooks"]);

                        lblTotalCopies.Text =
                            Convert.ToString(
                                reader["TotalCopies"]);

                        lblAvailableCopies.Text =
                            Convert.ToString(
                                reader["AvailableCopies"]);

                        lblTotalCustomers.Text =
                            Convert.ToString(
                                reader["TotalCustomers"]);

                        // ===================================
                        // SECONDARY STATISTICS
                        // ===================================

                        lblCollectedLoans.Text =
                            Convert.ToString(
                                reader["CollectedLoans"]);

                        lblCancelledReservations.Text =
                            Convert.ToString(
                                reader["CancelledReservations"]);

                        lblArchivedBooks.Text =
                            Convert.ToString(
                                reader["ArchivedBooks"]);

                        lblSecondaryPendingReturns.Text =
                            Convert.ToString(
                                reader["PendingReturns"]);

                        lblMessage.Text = "";
                        lblMessage.CssClass = "od-message";
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.CssClass =
                    "od-message error";

                lblMessage.Text =
                    "Unable to load dashboard: " +
                    Server.HtmlEncode(ex.Message);
            }
        }

        protected void btnRefresh_Click(
            object sender,
            EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            LoadDashboard();
        }
    }
}
