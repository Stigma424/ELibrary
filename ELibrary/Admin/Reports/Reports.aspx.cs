
using System;
using System.Web.UI;

namespace ELibrary.Admin.Reports
{
    public partial class Reports : Page
    {
        protected void Page_Load(
            object sender,
            EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect(
                    "~/Login.aspx",
                    false);

                Context.ApplicationInstance
                    .CompleteRequest();

                return;
            }
        }
    }
}
