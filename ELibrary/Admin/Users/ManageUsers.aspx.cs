
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace ELibrary.Admin.Users
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        private const int PageSize = 10;

        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings[
                "ElibraryConnection"].ConnectionString;

        // ==========================================
        // VIEW STATE
        // ==========================================

        private bool EditorOpen
        {
            get
            {
                return (bool)(ViewState["EditorOpen"] ?? false);
            }
            set
            {
                ViewState["EditorOpen"] = value;
                pnlUserEditor.Visible = value;
            }
        }

        private string AppliedSearch
        {
            get { return (string)(ViewState["AppliedSearch"] ?? ""); }
            set { ViewState["AppliedSearch"] = value; }
        }

        private int? AppliedRole
        {
            get
            {
                object value = ViewState["AppliedRole"];
                return value == null ? (int?)null : (int)value;
            }
            set { ViewState["AppliedRole"] = value; }
        }

        private string AppliedBorrowing
        {
            get
            {
                return (string)(ViewState["AppliedBorrowing"] ?? "All");
            }
            set { ViewState["AppliedBorrowing"] = value; }
        }

        private string AppliedSort
        {
            get
            {
                return (string)(ViewState["AppliedSort"] ?? "Newest");
            }
            set { ViewState["AppliedSort"] = value; }
        }

        private int CurrentPage
        {
            get { return (int)(ViewState["CurrentPage"] ?? 1); }
            set { ViewState["CurrentPage"] = value; }
        }

        private int TotalPages
        {
            get { return (int)(ViewState["TotalPages"] ?? 1); }
            set { ViewState["TotalPages"] = value; }
        }

        // ==========================================
        // PAGE LOAD
        // ==========================================

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AdminHelper.IsAdmin(Session))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadGenders();
                ClearForm();
                EditorOpen = false;
                RefreshUsers();
            }
            else
            {
                pnlUserEditor.Visible = EditorOpen;
            }

            hfFocusTarget.Value = "";
        }

        // ==========================================
        // CONTEXTUAL MESSAGES
        // ==========================================

        private void ShowDirectoryMessage(string message, bool success)
        {
            lblMessage.Text = Server.HtmlEncode(message);
            lblMessage.CssClass = success
                ? "u-message success"
                : "u-message error";

            hfFocusTarget.Value = "userDirectory";
        }

        private void ShowEditorMessage(string message, bool success)
        {
            EditorOpen = true;

            lblEditorMessage.Text = Server.HtmlEncode(message);
            lblEditorMessage.CssClass = success
                ? "u-message success"
                : "u-message error";

            hfFocusTarget.Value = "pnlUserEditor";
        }

        private void FocusSection(string sectionID)
        {
            if (string.IsNullOrEmpty(hfFocusTarget.Value))
            {
                hfFocusTarget.Value = sectionID;
            }
        }

        // ==========================================
        // PROFILE IMAGE URL
        // ==========================================

        protected string GetProfileImageUrl(object value)
        {
            string path = Convert.ToString(value);

            if (!string.IsNullOrWhiteSpace(path) &&
                path.StartsWith(
                    "~/Uploads/ProfilePictures/",
                    StringComparison.OrdinalIgnoreCase) &&
                path.IndexOf("..", StringComparison.Ordinal) < 0 &&
                path.IndexOf('\\') < 0)
            {
                return ResolveUrl(path);
            }

            return ResolveUrl(
                "~/Content/Images/default-avatar.svg");
        }

        // ==========================================
        // LOAD GENDERS
        // ==========================================

        private void LoadGenders()
        {
            ddlGender.Items.Clear();
            ddlGender.Items.Add(
                new ListItem("-- Select Gender --", ""));

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand("EGender_Web", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ddlGender.Items.Add(
                            new ListItem(
                                Convert.ToString(reader["GenderName"]),
                                Convert.ToString(reader["GenderID"])));
                    }
                }
            }
        }

        // ==========================================
        // SEARCH AND FILTER
        // ==========================================

        protected void btnApply_Click(object sender, EventArgs e)
        {
            AppliedSearch = (txtSearch.Text ?? "").Trim();

            int role;
            AppliedRole = int.TryParse(
                ddlFilterRole.SelectedValue, out role)
                ? (int?)role
                : null;

            AppliedBorrowing = ddlFilterBorrowing.SelectedValue;
            AppliedSort = ddlSort.SelectedValue;
            CurrentPage = 1;

            RefreshUsers();
            FocusSection("userDirectory");
        }

        protected void btnClearFilters_Click(
            object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlFilterRole.SelectedValue = "";
            ddlFilterBorrowing.SelectedValue = "All";
            ddlSort.SelectedValue = "Newest";

            AppliedSearch = "";
            AppliedRole = null;
            AppliedBorrowing = "All";
            AppliedSort = "Newest";
            CurrentPage = 1;

            RefreshUsers();
            FocusSection("userDirectory");
        }

        protected void btnPrevious_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1)
            {
                CurrentPage--;
                RefreshUsers();
            }

            FocusSection("userDirectory");
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            if (CurrentPage < TotalPages)
            {
                CurrentPage++;
                RefreshUsers();
            }

            FocusSection("userDirectory");
        }

        private void RefreshUsers()
        {
            try
            {
                LoadUsers();
            }
            catch (Exception ex)
            {
                ShowDirectoryMessage(
                    "Unable to load users: " + ex.Message,
                    false);
            }
        }

        private void LoadUsers()
        {
            DataSet ds = new DataSet();

            using (SqlConnection con =
                new SqlConnection(connectionString))
            using (SqlCommand cmd =
                new SqlCommand("EUsers_WebAdminSearch", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(
                    "@Search", SqlDbType.VarChar, 255).Value =
                    string.IsNullOrWhiteSpace(AppliedSearch)
                    ? (object)DBNull.Value
                    : AppliedSearch;

                cmd.Parameters.Add(
                    "@Role", SqlDbType.Int).Value =
                    AppliedRole.HasValue
                    ? (object)AppliedRole.Value
                    : DBNull.Value;

                cmd.Parameters.Add(
                    "@Borrowing", SqlDbType.VarChar, 20).Value =
                    AppliedBorrowing;

                cmd.Parameters.Add(
                    "@Sort", SqlDbType.VarChar, 20).Value =
                    AppliedSort;

                cmd.Parameters.Add(
                    "@PageNumber", SqlDbType.Int).Value =
                    CurrentPage;

                cmd.Parameters.Add(
                    "@PageSize", SqlDbType.Int).Value =
                    PageSize;

                using (SqlDataAdapter adapter =
                    new SqlDataAdapter(cmd))
                {
                    adapter.Fill(ds);
                }
            }

            if (ds.Tables.Count < 2)
            {
                throw new InvalidOperationException(
                    "User search returned incomplete data.");
            }

            int filteredCount = 0;

            if (ds.Tables[0].Rows.Count > 0)
            {
                filteredCount = Convert.ToInt32(
                    ds.Tables[0].Rows[0]["FilteredCount"]);
            }

            TotalPages = Math.Max(
                1,
                (int)Math.Ceiling(
                    filteredCount / (double)PageSize));

            if (CurrentPage > TotalPages)
            {
                CurrentPage = TotalPages;
                LoadUsers();
                return;
            }

            gvUsers.DataSource = ds.Tables[1];
            gvUsers.DataBind();

            int first = filteredCount == 0
                ? 0
                : (CurrentPage - 1) * PageSize + 1;

            int last = Math.Min(
                CurrentPage * PageSize,
                filteredCount);

            lblResultCount.Text = string.Format(
                "Showing {0}–{1} of {2} users",
                first, last, filteredCount);

            lblPageInfo.Text = string.Format(
                "Page {0} of {1}",
                CurrentPage, TotalPages);

            btnPrevious.Visible = TotalPages > 1;
            btnNext.Visible = TotalPages > 1;
            btnPrevious.Enabled = CurrentPage > 1;
            btnNext.Enabled = CurrentPage < TotalPages;
        }

        // ==========================================
        // OPEN / CLOSE USER EDITOR
        // ==========================================

        protected void btnCreateUser_Click(object sender, EventArgs e)
        {
            ClearForm();
            EditorOpen = true;
            lblEditorMessage.Text = "";
            lblEditorTitle.Text = "Add New User";

            FocusSection("pnlUserEditor");
        }

        protected void btnCloseEditor_Click(object sender, EventArgs e)
        {
            ClearForm();
            EditorOpen = false;
            lblEditorMessage.Text = "";

            FocusSection("userDirectory");
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            EditorOpen = true;
            lblEditorMessage.Text = "";

            FocusSection("pnlUserEditor");
        }

        private void ClearForm()
        {
            hfUserID.Value = "0";

            txtEmail.Text = "";
            txtFirstName.Text = "";
            txtMiddleName.Text = "";
            txtLastName.Text = "";
            txtAddress.Text = "";
            txtContactNumber.Text = "";
            txtPassword.Text = "";

            if (ddlGender.Items.Count > 0)
            {
                ddlGender.SelectedIndex = 0;
            }

            ddlRole.SelectedValue = "1";
            chkAllowedToBorrow.Checked = true;

            imgProfilePreview.ImageUrl = ResolveUrl(
                "~/Content/Images/default-avatar.svg");

            lblPasswordNote.Text =
                "A password is required for new users. " +
                "Leave blank when editing to retain the existing password.";

            btnSave.Text = "Save User";
            lblEditorTitle.Text = "Add New User";
        }

        // ==========================================
        // SAVE USER
        // ==========================================

        protected void btnSave_Click(object sender, EventArgs e)
        {
            EditorOpen = true;
            lblEditorMessage.Text = "";

            int userID;

            if (!int.TryParse(hfUserID.Value, out userID) ||
                userID < 0)
            {
                ShowEditorMessage("Invalid user ID.", false);
                return;
            }

            string email = (txtEmail.Text ?? "").Trim();
            string firstName = (txtFirstName.Text ?? "").Trim();
            string middleName = (txtMiddleName.Text ?? "").Trim();
            string lastName = (txtLastName.Text ?? "").Trim();
            string address = (txtAddress.Text ?? "").Trim();
            string contact = (txtContactNumber.Text ?? "").Trim();

            int genderID;
            int role;

            if (string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(firstName) ||
                string.IsNullOrWhiteSpace(lastName) ||
                string.IsNullOrWhiteSpace(address) ||
                string.IsNullOrWhiteSpace(contact))
            {
                ShowEditorMessage(
                    "Complete all required fields.", false);
                return;
            }

            if (email.Length > 100 ||
                firstName.Length > 100 ||
                middleName.Length > 100 ||
                lastName.Length > 100 ||
                address.Length > 255 ||
                contact.Length > 30)
            {
                ShowEditorMessage(
                    "One or more fields are too long.", false);
                return;
            }

            if (!int.TryParse(
                ddlGender.SelectedValue, out genderID))
            {
                ShowEditorMessage("Select a gender.", false);
                return;
            }

            if (!int.TryParse(
                ddlRole.SelectedValue, out role) ||
                (role != 1 && role != 2))
            {
                ShowEditorMessage("Select a valid role.", false);
                return;
            }

            // Prevent an admin from removing their own role.
            if (userID > 0 &&
                userID == Convert.ToInt32(Session["UserID"]) &&
                role != 2)
            {
                ShowEditorMessage(
                    "You cannot remove your own administrator role.",
                    false);
                return;
            }

            string passwordHash = null;

            if (userID == 0)
            {
                if (string.IsNullOrWhiteSpace(txtPassword.Text))
                {
                    ShowEditorMessage(
                        "A password is required for a new user.",
                        false);
                    return;
                }

                passwordHash =
                    PasswordHelper.HashPassword(txtPassword.Text);
            }
            else if (!string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                // Blank password preserves the existing password.
                passwordHash =
                    PasswordHelper.HashPassword(txtPassword.Text);
            }

            string newProfileImagePath = null;

            try
            {
                // Validate duplicate email.
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand("EUsers_WebValidate", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@UserID", SqlDbType.Int).Value =
                        userID == 0
                        ? (object)DBNull.Value : userID;

                    cmd.Parameters.Add(
                        "@Email", SqlDbType.VarChar, 100).Value =
                        email;

                    con.Open();

                    object result = cmd.ExecuteScalar();

                    if (result != null &&
                        result != DBNull.Value &&
                        Convert.ToInt32(result) == 0)
                    {
                        ShowEditorMessage(
                            "That email is already registered.",
                            false);
                        return;
                    }
                }

                // Existing profile upload helper.
                if (fuProfilePicture.HasFile)
                {
                    newProfileImagePath =
                        ImageUploadHelper.SaveImage(
                            fuProfilePicture,
                            "~/Uploads/ProfilePictures");
                }

                // Save through existing stored procedure.
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand("EUsers_WebSave", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@UserID", SqlDbType.Int).Value =
                        userID == 0
                        ? (object)DBNull.Value : userID;

                    cmd.Parameters.Add(
                        "@Email", SqlDbType.VarChar, 100).Value =
                        email;

                    cmd.Parameters.Add(
                        "@Password", SqlDbType.VarChar, 255).Value =
                        passwordHash == null
                        ? (object)DBNull.Value : passwordHash;

                    cmd.Parameters.Add(
                        "@FirstName", SqlDbType.VarChar, 100).Value =
                        firstName;

                    cmd.Parameters.Add(
                        "@MiddleName", SqlDbType.VarChar, 100).Value =
                        string.IsNullOrWhiteSpace(middleName)
                        ? (object)DBNull.Value : middleName;

                    cmd.Parameters.Add(
                        "@LastName", SqlDbType.VarChar, 100).Value =
                        lastName;

                    cmd.Parameters.Add(
                        "@GenderID", SqlDbType.Int).Value =
                        genderID;

                    cmd.Parameters.Add(
                        "@Address", SqlDbType.VarChar, 255).Value =
                        address;

                    cmd.Parameters.Add(
                        "@ContactNumber", SqlDbType.VarChar, 30).Value =
                        contact;

                    cmd.Parameters.Add(
                        "@IsAllowedToBorrow", SqlDbType.Bit).Value =
                        chkAllowedToBorrow.Checked;

                    cmd.Parameters.Add(
                        "@Role", SqlDbType.Int).Value =
                        role;

                    cmd.Parameters.Add(
                        "@ProfileImagePath",
                        SqlDbType.NVarChar, 500).Value =
                        string.IsNullOrEmpty(newProfileImagePath)
                        ? (object)DBNull.Value
                        : newProfileImagePath;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                ClearForm();
                EditorOpen = true;

                RefreshUsers();

                ShowEditorMessage(
                    userID == 0
                    ? "User created successfully."
                    : "User updated successfully.",
                    true);
            }
            catch (Exception ex)
            {
                // Remove uploaded images only when they
                // were not referenced by a saved user.
                if (!string.IsNullOrEmpty(newProfileImagePath))
                {
                    try
                    {
                        using (SqlConnection con =
                            new SqlConnection(connectionString))
                        using (SqlCommand cmd =
                            new SqlCommand(
                                "SELECT COUNT(*) FROM dbo.EUsers " +
                                "WHERE ProfileImagePath = @Path",
                                con))
                        {
                            cmd.Parameters.Add(
                                "@Path",
                                SqlDbType.NVarChar, 500).Value =
                                newProfileImagePath;

                            con.Open();

                            if (Convert.ToInt32(
                                cmd.ExecuteScalar()) == 0)
                            {
                                ImageUploadHelper.DeleteImage(
                                    newProfileImagePath);
                            }
                        }
                    }
                    catch
                    {
                        // Preserve original database error.
                    }
                }

                ShowEditorMessage(
                    "Unable to save user: " + ex.Message,
                    false);
            }
        }

        // ==========================================
        // GRID COMMANDS
        // ==========================================

        protected void gvUsers_RowCommand(
            object sender,
            GridViewCommandEventArgs e)
        {
            if (e.CommandName != "EditUser" &&
                e.CommandName != "DeleteUser")
            {
                return;
            }

            int userID;

            if (!int.TryParse(
                Convert.ToString(e.CommandArgument),
                out userID) || userID <= 0)
            {
                ShowDirectoryMessage(
                    "Invalid user ID.", false);
                return;
            }

            if (e.CommandName == "EditUser")
            {
                LoadUser(userID);
                return;
            }

            if (userID == Convert.ToInt32(Session["UserID"]))
            {
                ShowDirectoryMessage(
                    "You cannot delete your own account.",
                    false);
                return;
            }

            DeleteUser(userID);
        }

        // ==========================================
        // LOAD SELECTED USER
        // ==========================================

        private void LoadUser(int userID)
        {
            lblEditorMessage.Text = "";

            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand("EUsers_WebOne", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@UserID", SqlDbType.Int).Value =
                        userID;

                    con.Open();

                    using (SqlDataReader reader =
                        cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            ShowDirectoryMessage(
                                "User not found.", false);
                            return;
                        }

                        hfUserID.Value =
                            Convert.ToString(reader["UserID"]);

                        txtEmail.Text =
                            Convert.ToString(reader["Email"]);

                        txtFirstName.Text =
                            Convert.ToString(reader["FirstName"]);

                        txtMiddleName.Text =
                            reader["MiddleName"] == DBNull.Value
                            ? ""
                            : Convert.ToString(reader["MiddleName"]);

                        txtLastName.Text =
                            Convert.ToString(reader["LastName"]);

                        txtAddress.Text =
                            Convert.ToString(reader["Address"]);

                        txtContactNumber.Text =
                            Convert.ToString(reader["ContactNumber"]);

                        string genderValue =
                            Convert.ToString(reader["GenderID"]);

                        if (ddlGender.Items.FindByValue(
                            genderValue) != null)
                        {
                            ddlGender.SelectedValue = genderValue;
                        }

                        ddlRole.SelectedValue =
                            Convert.ToString(reader["Role"]);

                        chkAllowedToBorrow.Checked =
                            Convert.ToBoolean(
                                reader["IsAllowedToBorrow"]);

                        imgProfilePreview.ImageUrl =
                            GetProfileImageUrl(
                                reader["ProfileImagePath"]);

                        txtPassword.Text = "";

                        lblPasswordNote.Text =
                            "Leave blank to retain the current password.";

                        btnSave.Text = "Update User";
                        lblEditorTitle.Text = "Edit User";
                    }
                }

                EditorOpen = true;
                hfFocusTarget.Value = "pnlUserEditor";
            }
            catch (Exception ex)
            {
                ShowDirectoryMessage(
                    "Unable to load user: " + ex.Message,
                    false);
            }
        }

        // ==========================================
        // DELETE USER
        // ==========================================

        private void DeleteUser(int userID)
        {
            try
            {
                using (SqlConnection con =
                    new SqlConnection(connectionString))
                using (SqlCommand cmd =
                    new SqlCommand("EUsers_WebDelete", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(
                        "@UserID", SqlDbType.Int).Value =
                        userID;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                int editingID;

                if (int.TryParse(hfUserID.Value, out editingID) &&
                    editingID == userID)
                {
                    ClearForm();
                    EditorOpen = false;
                }

                RefreshUsers();

                ShowDirectoryMessage(
                    "User deleted successfully.", true);
            }
            catch (Exception ex)
            {
                ShowDirectoryMessage(
                    "Unable to delete user: " + ex.Message,
                    false);
            }
        }
    }
}
