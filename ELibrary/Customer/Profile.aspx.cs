
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ELibrary.Customer
{
    public partial class Profile : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings[
                "ElibraryConnection"].ConnectionString;

        private int CurrentUserID
        {
            get
            {
                return Convert.ToInt32(Session["UserID"]);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int role;

            if (Session["Role"] == null ||
                !int.TryParse(
                    Convert.ToString(Session["Role"]),
                    out role) ||
                role != 1)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    LoadGenders();
                    LoadProfile();
                }
                catch (Exception)
                {
                    ShowError(
                        "Unable to load your profile.");
                    btnSave.Enabled = false;
                }
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

        // ==========================================
        // LOAD GENDERS
        // ==========================================

        private void LoadGenders()
        {
            ddlGender.Items.Clear();

            ddlGender.Items.Add(
                new ListItem(
                    "-- Select Gender --", ""));

            using (SqlConnection con =
                new SqlConnection(connectionString))
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
                            new ListItem(
                                Convert.ToString(
                                    reader["GenderName"]),
                                Convert.ToString(
                                    reader["GenderID"])));
                    }
                }
            }
        }

        // ==========================================
        // LOAD PROFILE
        // ==========================================

        private void LoadProfile()
        {
            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand("EUsers_WebOne", con))
            {
                cmd.CommandType =
                    CommandType.StoredProcedure;

                cmd.Parameters.Add(
                    "@UserID",
                    SqlDbType.Int).Value =
                    CurrentUserID;

                con.Open();

                using (SqlDataReader reader =
                    cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        ShowError("Profile not found.");
                        btnSave.Enabled = false;
                        return;
                    }

                    string email =
                        Convert.ToString(
                            reader["Email"]);

                    string firstName =
                        Convert.ToString(
                            reader["FirstName"]);

                    string middleName =
                        Convert.ToString(
                            reader["MiddleName"]);

                    string lastName =
                        Convert.ToString(
                            reader["LastName"]);

                    txtEmail.Text = email;
                    txtFirstName.Text = firstName;
                    txtMiddleName.Text = middleName;
                    txtLastName.Text = lastName;

                    txtAddress.Text =
                        Convert.ToString(
                            reader["Address"]);

                    txtContactNumber.Text =
                        Convert.ToString(
                            reader["ContactNumber"]);

                    string genderValue =
                        Convert.ToString(
                            reader["GenderID"]);

                    ListItem selectedGender =
                        ddlGender.Items.FindByValue(
                            genderValue);

                    if (selectedGender != null)
                    {
                        ddlGender.ClearSelection();
                        selectedGender.Selected = true;
                    }

                    string imagePath =
                        Convert.ToString(
                            reader["ProfileImagePath"]);

                    imgProfilePreview.ImageUrl =
                        GetProfileImageUrl(imagePath);

                    lblProfileName.Text =
                        Server.HtmlEncode(
                            firstName + " " + lastName);

                    lblProfileEmail.Text =
                        Server.HtmlEncode(email);
                }
            }
        }

        // ==========================================
        // SAVE PROFILE
        // ==========================================

        protected void btnSave_Click(
            object sender,
            EventArgs e)
        {
            lblMessage.Text = "";

            string email =
                txtEmail.Text.Trim();

            string firstName =
                txtFirstName.Text.Trim();

            string middleName =
                txtMiddleName.Text.Trim();

            string lastName =
                txtLastName.Text.Trim();

            string address =
                txtAddress.Text.Trim();

            string contact =
                txtContactNumber.Text.Trim();

            int genderID;

            if (string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(firstName) ||
                string.IsNullOrWhiteSpace(lastName) ||
                string.IsNullOrWhiteSpace(address) ||
                string.IsNullOrWhiteSpace(contact))
            {
                ShowError(
                    "Complete all required fields.");
                return;
            }

            if (!int.TryParse(
                ddlGender.SelectedValue,
                out genderID))
            {
                ShowError(
                    "Please select a gender.");
                return;
            }

            if (email.Length > 100 ||
                firstName.Length > 100 ||
                middleName.Length > 100 ||
                lastName.Length > 100 ||
                address.Length > 255 ||
                contact.Length > 30)
            {
                ShowError(
                    "One or more fields exceed " +
                    "the allowed length.");
                return;
            }

            string newProfileImagePath = null;

            try
            {
                // ----------------------------------
                // VALIDATE EMAIL
                // ----------------------------------

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EUsers_WebValidate", con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value =
                        CurrentUserID;

                    cmd.Parameters.Add(
                        "@Email",
                        SqlDbType.VarChar,
                        100).Value = email;

                    con.Open();

                    object result =
                        cmd.ExecuteScalar();

                    if (result != null &&
                        result != DBNull.Value &&
                        Convert.ToInt32(result) == 0)
                    {
                        ShowError(
                            "That email is already registered.");
                        return;
                    }
                }

                // ----------------------------------
                // UPLOAD IMAGE
                // ----------------------------------

                if (fuProfilePicture.HasFile)
                {
                    newProfileImagePath =
                        ImageUploadHelper.SaveImage(
                            fuProfilePicture,
                            "~/Uploads/ProfilePictures");
                }

                // ----------------------------------
                // UPDATE PROFILE
                // ----------------------------------

                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand(
                        "EUsers_WebUpdateOwnProfile",
                        con))
                {
                    cmd.CommandType =
                        CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@UserID",
                        SqlDbType.Int).Value =
                        CurrentUserID;

                    cmd.Parameters.Add(
                        "@Email",
                        SqlDbType.VarChar,
                        100).Value = email;

                    cmd.Parameters.Add(
                        "@FirstName",
                        SqlDbType.VarChar,
                        100).Value = firstName;

                    cmd.Parameters.Add(
                        "@MiddleName",
                        SqlDbType.VarChar,
                        100).Value =
                        string.IsNullOrWhiteSpace(middleName)
                        ? (object)DBNull.Value
                        : middleName;

                    cmd.Parameters.Add(
                        "@LastName",
                        SqlDbType.VarChar,
                        100).Value = lastName;

                    cmd.Parameters.Add(
                        "@GenderID",
                        SqlDbType.Int).Value = genderID;

                    cmd.Parameters.Add(
                        "@Address",
                        SqlDbType.VarChar,
                        255).Value = address;

                    cmd.Parameters.Add(
                        "@ContactNumber",
                        SqlDbType.VarChar,
                        30).Value = contact;

                    cmd.Parameters.Add(
                        "@ProfileImagePath",
                        SqlDbType.NVarChar,
                        500).Value =
                        string.IsNullOrEmpty(
                            newProfileImagePath)
                        ? (object)DBNull.Value
                        : newProfileImagePath;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                // ----------------------------------
                // UPDATE SESSION
                // ----------------------------------

                Session["FullName"] =
                    lastName + ", " + firstName +
                    (string.IsNullOrWhiteSpace(middleName)
                        ? ""
                        : " " +
                          middleName.Substring(0, 1) +
                          ".");

                // Refresh displayed profile details.
                LoadProfile();

                ShowSuccess(
                    "Your profile was updated successfully.");
            }
            catch (Exception ex)
            {
                // Delete an uploaded image only if
                // the database does not reference it.
                if (!string.IsNullOrEmpty(
                    newProfileImagePath))
                {
                    try
                    {
                        using (SqlConnection con =
                            new SqlConnection(connectionString))
                        using (SqlCommand cmd =
                            new SqlCommand(
                                "SELECT COUNT(*) " +
                                "FROM dbo.EUsers " +
                                "WHERE ProfileImagePath = @Path",
                                con))
                        {
                            cmd.Parameters.Add(
                                "@Path",
                                SqlDbType.NVarChar,
                                500).Value =
                                newProfileImagePath;

                            con.Open();

                            int referenceCount =
                                Convert.ToInt32(
                                    cmd.ExecuteScalar());

                            if (referenceCount == 0)
                            {
                                ImageUploadHelper.DeleteImage(
                                    newProfileImagePath);
                            }
                        }
                    }
                    catch
                    {
                        // Preserve original error.
                    }
                }

                ShowError(
                    "Unable to update profile: " +
                    ex.Message);
            }
        }

        // ==========================================
        // MESSAGES
        // ==========================================

        private void ShowError(string message)
        {
            lblMessage.CssClass =
                "el-profile-v2-message error";

            lblMessage.Text =
                Server.HtmlEncode(message);
        }

        private void ShowSuccess(string message)
        {
            lblMessage.CssClass =
                "el-profile-v2-message success";

            lblMessage.Text =
                Server.HtmlEncode(message);
        }
    }
}
