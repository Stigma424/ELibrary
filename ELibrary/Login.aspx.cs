
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ELibrary
{
    public partial class Login : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager
                .ConnectionStrings["ElibraryConnection"]
                .ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // ==========================================
            // REDIRECT USERS WHO ARE ALREADY LOGGED IN
            // ==========================================

            int userID;
            int role;

            bool hasValidUserID =
                int.TryParse(
                    Convert.ToString(Session["UserID"]),
                    out userID) &&
                userID > 0;

            bool hasValidRole =
                int.TryParse(
                    Convert.ToString(Session["Role"]),
                    out role);

            if (hasValidUserID && hasValidRole)
            {
                if (role == 2 &&
                    AdminHelper.IsAdmin(Session))
                {
                    RedirectTo("~/AdminHome.aspx");
                    return;
                }

                if (role == 1)
                {
                    RedirectTo("~/CustomerHome.aspx");
                    return;
                }
            }

            // ==========================================
            // INITIAL LOGIN PAGE LOAD
            // ==========================================

            if (!IsPostBack)
            {
                lblMessage.Text = "";

                if (Request.QueryString["registered"] == "1")
                {
                    lblMessage.Text =
                        "Registration successful. " +
                        "You can now log in.";
                }
            }
        }

        // ==========================================
        // LOGIN
        // ==========================================

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "";

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrWhiteSpace(email))
            {
                lblMessage.Text =
                    "Please enter your email.";
                return;
            }

            if (string.IsNullOrWhiteSpace(password))
            {
                lblMessage.Text =
                    "Please enter your password.";
                return;
            }

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand("EUsers_WebLogin", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@Email",
                        SqlDbType.VarChar,
                        100).Value = email;

                    con.Open();

                    int userID;
                    int role;
                    string fullName;
                    bool isAllowedToBorrow;

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            lblMessage.Text =
                                "Invalid email or password.";
                            return;
                        }

                        string storedPassword =
                            Convert.ToString(
                                reader["Password"]);

                        bool passwordCorrect =
                            PasswordHelper.VerifyPassword(
                                password,
                                storedPassword);

                        if (!passwordCorrect)
                        {
                            lblMessage.Text =
                                "Invalid email or password.";
                            return;
                        }

                        userID =
                            Convert.ToInt32(
                                reader["UserID"]);

                        fullName =
                            Convert.ToString(
                                reader["FullName"]);

                        role =
                            Convert.ToInt32(
                                reader["Role"]);

                        isAllowedToBorrow =
                            Convert.ToBoolean(
                                reader["IsAllowedToBorrow"]);
                    }

                    // Only supported account roles
                    // can establish an authenticated session.

                    if (role != 1 && role != 2)
                    {
                        lblMessage.Text =
                            "This account does not have " +
                            "a valid access role.";
                        return;
                    }

                    // ==================================
                    // CREATE SESSION
                    // ==================================

                    Session["UserID"] = userID;
                    Session["FullName"] = fullName;
                    Session["Role"] = role;
                    Session["IsAllowedToBorrow"] =
                        isAllowedToBorrow;

                    // ==================================
                    // REDIRECT BY ROLE
                    // ==================================

                    if (role == 2)
                    {
                        RedirectTo("~/AdminHome.aspx");
                        return;
                    }

                    RedirectTo("~/CustomerHome.aspx");
                }
            }
            catch (SqlException)
            {
                lblMessage.Text =
                    "Unable to connect to the database. " +
                    "Please try again.";
            }
            catch (InvalidOperationException)
            {
                lblMessage.Text =
                    "Login is temporarily unavailable. " +
                    "Please try again.";
            }
        }

        // ==========================================
        // SAFE REDIRECT
        // ==========================================

        private void RedirectTo(string destination)
        {
            Response.Redirect(
                ResolveUrl(destination),
                false);

            Context.ApplicationInstance
                .CompleteRequest();
        }
    }
}
