using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ELibrary
{
    public partial class Register : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager
                .ConnectionStrings["ElibraryConnection"]
                .ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGenders();
                lblMessage.Text = "";
            }
        }

        private void LoadGenders()
        {
            ddlGender.Items.Clear();

            ddlGender.Items.Add(
                new System.Web.UI.WebControls.ListItem(
                    "-- Select Gender --",
                    ""));

            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                using (SqlCommand cmd =
                    new SqlCommand("EGender_Web", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            ddlGender.Items.Add(
                                new System.Web.UI.WebControls.ListItem(
                                    reader["GenderName"].ToString(),
                                    reader["GenderID"].ToString()));
                        }
                    }
                }
            }
        }

        protected void btnRegister_Click(
            object sender,
            EventArgs e)
        {
            lblMessage.Text = "";

            string firstName =
                txtFirstName.Text.Trim();

            string middleName =
                txtMiddleName.Text.Trim();

            string lastName =
                txtLastName.Text.Trim();

            string email =
                txtEmail.Text.Trim();

            string password =
                txtPassword.Text;

            string confirmPassword =
                txtConfirmPassword.Text;

            string address =
                txtAddress.Text.Trim();

            string contactNumber =
                txtContactNumber.Text.Trim();

            if (string.IsNullOrWhiteSpace(firstName))
            {
                lblMessage.Text =
                    "First name is required.";
                return;
            }

            if (string.IsNullOrWhiteSpace(lastName))
            {
                lblMessage.Text =
                    "Last name is required.";
                return;
            }

            if (string.IsNullOrWhiteSpace(email))
            {
                lblMessage.Text =
                    "Email is required.";
                return;
            }

            if (string.IsNullOrWhiteSpace(password))
            {
                lblMessage.Text =
                    "Password is required.";
                return;
            }

            if (password != confirmPassword)
            {
                lblMessage.Text =
                    "Passwords do not match.";
                return;
            }

            if (ddlGender.SelectedValue == "")
            {
                lblMessage.Text =
                    "Please select a gender.";
                return;
            }

            if (string.IsNullOrWhiteSpace(address))
            {
                lblMessage.Text =
                    "Address is required.";
                return;
            }

            if (string.IsNullOrWhiteSpace(contactNumber))
            {
                lblMessage.Text =
                    "Contact number is required.";
                return;
            }

            try
            {
                int genderID =
                    Convert.ToInt32(
                        ddlGender.SelectedValue);

                // --------------------------------
                // Check duplicate email
                // --------------------------------

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd =
                        new SqlCommand(
                            "EUsers_WebValidate",
                            con))
                    {
                        cmd.CommandType =
                            CommandType.StoredProcedure;

                        cmd.Parameters.Add(
                            "@UserID",
                            SqlDbType.Int).Value =
                            DBNull.Value;

                        cmd.Parameters.Add(
                            "@Email",
                            SqlDbType.VarChar,
                            100).Value = email;

                        con.Open();

                        object result =
                            cmd.ExecuteScalar();

                        if (result != null &&
                            Convert.ToInt32(result) == 0)
                        {
                            lblMessage.Text =
                                "This email is already registered.";
                            return;
                        }
                    }
                }

                // --------------------------------
                // Hash password
                // --------------------------------

                string hashedPassword =
                    PasswordHelper.HashPassword(password);

                // --------------------------------
                // Save user
                // --------------------------------

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd =
                        new SqlCommand(
                            "EUsers_WebSave",
                            con))
                    {
                        cmd.CommandType =
                            CommandType.StoredProcedure;

                        cmd.Parameters.Add(
                            "@UserID",
                            SqlDbType.Int).Value =
                            DBNull.Value;

                        cmd.Parameters.Add(
                            "@Email",
                            SqlDbType.VarChar,
                            100).Value = email;

                        cmd.Parameters.Add(
                            "@Password",
                            SqlDbType.VarChar,
                            255).Value =
                            hashedPassword;

                        cmd.Parameters.Add(
                            "@FirstName",
                            SqlDbType.VarChar,
                            100).Value =
                            firstName;

                        cmd.Parameters.Add(
                            "@MiddleName",
                            SqlDbType.VarChar,
                            100).Value =
                            string.IsNullOrWhiteSpace(
                                middleName)
                                ? (object)DBNull.Value
                                : middleName;

                        cmd.Parameters.Add(
                            "@LastName",
                            SqlDbType.VarChar,
                            100).Value =
                            lastName;

                        cmd.Parameters.Add(
                            "@GenderID",
                            SqlDbType.Int).Value =
                            genderID;

                        cmd.Parameters.Add(
                            "@Address",
                            SqlDbType.VarChar,
                            255).Value =
                            address;

                        cmd.Parameters.Add(
                            "@ContactNumber",
                            SqlDbType.VarChar,
                            30).Value =
                            contactNumber;

                        con.Open();

                        cmd.ExecuteNonQuery();
                    }
                }

                Response.Redirect(
                    "Login.aspx?registered=1");
            }
            catch (Exception ex)
            {
                lblMessage.Text =
                    "Registration failed: " +
                    ex.Message;
            }
        }
    }
}