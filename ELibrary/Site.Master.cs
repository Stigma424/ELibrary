
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace ELibrary
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int role = 0;
            int userID = 0;

            int.TryParse(
                Convert.ToString(Session["Role"]),
                out role);

            int.TryParse(
                Convert.ToString(Session["UserID"]),
                out userID);

            bool isAdmin =
                userID > 0 &&
                role == 2 &&
                AdminHelper.IsAdmin(Session);

            bool isCustomer =
                userID > 0 &&
                role == 1;

            pnlAdminSidebar.Visible = isAdmin;
            pnlAdminHeader.Visible = isAdmin;
            pnlAdminToolbar.Visible = isAdmin;

            pnlPublicHeader.Visible = !isAdmin;

            phGuestNavigation.Visible =
                !isAdmin && !isCustomer;

            phCustomerNavigation.Visible = isCustomer;

            pageBody.Attributes["class"] =
                isAdmin
                    ? "el-admin-mode"
                    : isCustomer
                        ? "el-customer-mode"
                        : "el-guest-mode";

            if (isCustomer)
            {
                lnkPublicBrand.NavigateUrl =
                    "~/CustomerHome.aspx";
            }

            if ((isAdmin || isCustomer) && !IsPostBack)
            {
                LoadHeaderProfileImage();
            }
        }

        private string GetProfileImageUrl(string path)
        {
            if (string.IsNullOrWhiteSpace(path) ||
                !path.StartsWith(
                    "~/Uploads/ProfilePictures/",
                    StringComparison.OrdinalIgnoreCase))
            {
                return ResolveUrl(
                    "~/Content/Images/default-avatar.svg");
            }

            return ResolveUrl(path);
        }

        private void LoadHeaderProfileImage()
        {
            int userID;

            if (!int.TryParse(
                Convert.ToString(Session["UserID"]),
                out userID))
            {
                return;
            }

            string imagePath = null;

            try
            {
                string connectionString =
                    ConfigurationManager
                    .ConnectionStrings["ElibraryConnection"]
                    .ConnectionString;

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "dbo.EUsers_WebOne", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value = userID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int index = -1;

                            try
                            {
                                index = reader.GetOrdinal(
                                    "ProfileImagePath");
                            }
                            catch (IndexOutOfRangeException)
                            {
                                index = -1;
                            }

                            if (index >= 0 &&
                                !reader.IsDBNull(index))
                            {
                                imagePath =
                                    Convert.ToString(
                                        reader[index]);
                            }
                        }
                    }
                }
            }
            catch (SqlException)
            {
                // Use default avatar if lookup fails.
            }
            catch (InvalidOperationException)
            {
                // Use default avatar if lookup fails.
            }

            string imageUrl =
                GetProfileImageUrl(imagePath);

            if (isAdminHeaderVisible())
            {
                imgAdminAvatar.ImageUrl = imageUrl;
            }

            if (phCustomerNavigation.Visible)
            {
                imgCustomerAvatar.ImageUrl = imageUrl;
            }
        }

        private bool isAdminHeaderVisible()
        {
            return pnlAdminHeader.Visible;
        }
    }
}
