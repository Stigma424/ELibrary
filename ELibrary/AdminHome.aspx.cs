
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
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            throw new InvalidOperationException(
                                "The dashboard returned no statistics.");
                        }

                        lblTotalBooks.Text =
                            Convert.ToString(reader["TotalBooks"]);

                        lblTotalCopies.Text =
                            Convert.ToString(reader["TotalCopies"]);

                        lblAvailableCopies.Text =
                            Convert.ToString(reader["AvailableCopies"]);

                        lblTotalCustomers.Text =
                            Convert.ToString(reader["TotalCustomers"]);

                        lblActiveBorrowings.Text =
                            Convert.ToString(reader["ActiveBorrowings"]);

                        lblOverdueBooks.Text =
                            Convert.ToString(reader["OverdueBooks"]);

                        lblPendingReturns.Text =
                            Convert.ToString(reader["PendingReturns"]);

                        lblArchivedBooks.Text =
                            Convert.ToString(reader["ArchivedBooks"]);

                        lblTotalUnpaidBalance.Text =
                            Convert.ToDecimal(
                                reader["TotalUnpaidBalance"]).ToString("N2");

                        lblPendingPickups.Text =
                            Convert.ToString(reader["PendingPickups"]);

                        lblCollectedLoans.Text =
                            Convert.ToString(reader["CollectedLoans"]);

                        lblCancelledReservations.Text =
                            Convert.ToString(reader["CancelledReservations"]);

                        lblMessage.Text = "";
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.CssClass =
                    "el-ad2-message text-danger";

                lblMessage.Text =
                    "Unable to load dashboard: " +
                    Server.HtmlEncode(ex.Message);
            }
        }

        protected void btnRefresh_Click(
            object sender, EventArgs e)
        {
            LoadDashboard();
        }
    }
}
