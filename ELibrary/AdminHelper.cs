using System;

namespace ELibrary
{
    public static class AdminHelper
    {
        public static bool IsAdmin(System.Web.SessionState.HttpSessionState session)
        {
            if (session["UserID"] == null)
                return false;

            if (session["Role"] == null)
                return false;

            int role;

            if (!int.TryParse(
                session["Role"].ToString(),
                out role))
            {
                return false;
            }

            return role == 2;
        }
    }
}