
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ELibrary
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int role = 0;

            if (Session["UserID"] != null &&
                Session["Role"] != null)
            {
                int.TryParse(
                    Convert.ToString(Session["Role"]),
                    out role);
            }

            bool isAdmin =
                Session["UserID"] != null &&
                role == 2 &&
                AdminHelper.IsAdmin(Session);

            bool isCustomer =
                Session["UserID"] != null &&
                role == 1;

            // ======================================
            // ADMIN LAYOUT: UNCHANGED
            // ======================================

            pnlAdminSidebar.Visible = isAdmin;
            pnlAdminHeader.Visible = isAdmin;
            pnlAdminToolbar.Visible = isAdmin;

            // ======================================
            // CUSTOMER / GUEST LAYOUT
            // ======================================

            pnlPublicHeader.Visible = !isAdmin;

            phGuestNavigation.Visible =
                !isAdmin && !isCustomer;

            phCustomerNavigation.Visible =
                isCustomer;

            pageBody.Attributes["class"] =
                isAdmin
                    ? "el-admin-mode"
                    : isCustomer
                        ? "el-customer-mode"
                        : "el-guest-mode";

            // ======================================
            // NAVIGATION
            // ======================================

            if (isAdmin)
            {
                HighlightActiveAdminLink();
            }

            if (isCustomer)
            {
                lnkPublicBrand.NavigateUrl =
                    "~/CustomerHome.aspx";

                HighlightActiveCustomerLink();
            }

            // ======================================
            // PROFILE PICTURE
            // ======================================

            if (isAdmin || isCustomer)
            {
                LoadHeaderProfileImage();
            }
        }

        // ==========================================
        // PROFILE IMAGE
        // ==========================================

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

            string connectionString =
                ConfigurationManager.ConnectionStrings[
                    "ElibraryConnection"].ConnectionString;

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand("EUsers_WebOne", con))
            {
                cmd.CommandType =
                    CommandType.StoredProcedure;

                cmd.Parameters.Add(
                    "@UserID", SqlDbType.Int)
                    .Value = userID;

                con.Open();

                using (SqlDataReader reader =
                    cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        imagePath =
                            Convert.ToString(
                                reader["ProfileImagePath"]);
                    }
                }
            }

            string resolvedPath =
                GetProfileImageUrl(imagePath);

            if (pnlAdminHeader.Visible)
            {
                imgAdminAvatar.ImageUrl =
                    resolvedPath;
            }

            if (phCustomerNavigation.Visible)
            {
                imgCustomerAvatar.ImageUrl =
                    resolvedPath;
            }
        }

        // ==========================================
        // ADMIN NAVIGATION: UNCHANGED
        // ==========================================


        private void HighlightActiveAdminLink()
        {
            string currentPath =
                VirtualPathUtility.ToAppRelative(
                    Request.Path).ToLowerInvariant();

            HyperLink[] adminLinks =
            {
        navAdminDashboard,
        navManageBooks,
        navManageGenres,
        navManageUsers,
        navManageBorrows,
        navWalkInBorrow,
        navOverdueBooks,
        navBorrowHistory,
        navTransactions,
        navArchivedBooks,
        navAuditLogs
    };

            foreach (HyperLink link in adminLinks)
            {
                string targetPath =
                    VirtualPathUtility.ToAppRelative(
                        ResolveUrl(link.NavigateUrl))
                    .ToLowerInvariant();

                if (currentPath == targetPath)
                {
                    link.CssClass =
                        "el-menu-link active";
                }
                else
                {
                    link.CssClass =
                        "el-menu-link";
                }
            }
        }


        // ==========================================
        // CUSTOMER NAVIGATION
        // ==========================================

        private void HighlightActiveCustomerLink()
        {
            string currentPath =
                VirtualPathUtility.ToAppRelative(
                    Request.Path).ToLowerInvariant();

            HyperLink[] customerLinks =
            {
                navCustomerDashboard,
                navCustomerBooks,
                navCustomerBorrows,
                navCustomerHistory,
                navCustomerTransactions,
                navCustomerProfile
            };

            foreach (HyperLink link in customerLinks)
            {
                string targetPath =
                    VirtualPathUtility.ToAppRelative(
                        ResolveUrl(link.NavigateUrl))
                    .ToLowerInvariant();

                if (currentPath == targetPath)
                {
                    link.CssClass =
                        "el-customer-nav-link active";
                }
                else
                {
                    link.CssClass =
                        "el-customer-nav-link";
                }
            }

            // Book details belong to Browse Books.
            if (currentPath ==
                "~/customer/bookdetails.aspx")
            {
                navCustomerBooks.CssClass =
                    "el-customer-nav-link active";
            }
        }
    }
}
