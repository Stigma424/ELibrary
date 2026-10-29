
using System;
using System.Web.UI;

namespace ELibrary
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int userID;
            int role;

            bool validUserID = int.TryParse(
                Convert.ToString(Session["UserID"]),
                out userID
            );

            bool validRole = int.TryParse(
                Convert.ToString(Session["Role"]),
                out role
            );

            // No authenticated session:
            // display the public Default.aspx homepage.
            if (!validUserID ||
                !validRole ||
                userID <= 0)
            {
                return;
            }

            // Administrator:
            // redirect to the administrator dashboard.
            if (role == 2 &&
                AdminHelper.IsAdmin(Session))
            {
                Response.Redirect(
                    "~/AdminHome.aspx",
                    false
                );

                Context.ApplicationInstance
                    .CompleteRequest();

                return;
            }

            // Customer:
            // redirect to the customer dashboard.
            if (role == 1)
            {
                Response.Redirect(
                    "~/CustomerHome.aspx",
                    false
                );

                Context.ApplicationInstance
                    .CompleteRequest();

                return;
            }

            // Unknown roles do not receive a
            // privileged dashboard redirect.
        }
    }
}
