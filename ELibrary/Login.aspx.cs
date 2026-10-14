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
            if (!IsPostBack)
            {
                lblMessage.Text = "";

                if (Request.QueryString["registered"] == "1")
                {
                    lblMessage.Text =
                        "Registration successful. You can now log in.";
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "";

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrWhiteSpace(email))
            {
                lblMessage.Text = "Please enter your email.";
                return;
            }

            if (string.IsNullOrWhiteSpace(password))
            {
                lblMessage.Text = "Please enter your password.";
                return;
            }

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd =
                        new SqlCommand("EUsers_WebLogin", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100)
                            .Value = email;

                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (!reader.Read())
                            {
                                lblMessage.Text =
                                    "Invalid email or password.";
                                return;
                            }

                            int userID =
                                Convert.ToInt32(reader["UserID"]);

                            string storedPassword =
                                reader["Password"].ToString();

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

                            string fullName =
                                reader["FullName"].ToString();

                            int role =
                                Convert.ToInt32(reader["Role"]);

                            bool isAllowedToBorrow =
                                Convert.ToBoolean(
                                    reader["IsAllowedToBorrow"]);

                            Session["UserID"] = userID;
                            Session["FullName"] = fullName;
                            Session["Role"] = role;
                            Session["IsAllowedToBorrow"] =
                                isAllowedToBorrow;

                            if (role == 2)
                            {
                                Response.Redirect(
                                    "AdminHome.aspx");
                            }
                            else if (role == 1)
                            {
                                Response.Redirect(
                                    "CustomerHome.aspx");
                            }
                            else
                            {
                                Response.Redirect("~/Login.aspx");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text =
                    "Login failed: " + ex.Message;
            }
        }
    }
}