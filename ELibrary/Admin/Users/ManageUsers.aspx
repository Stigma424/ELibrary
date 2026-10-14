
<%@ Page Title="Manage Users"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ManageUsers.aspx.cs"
    Inherits="ELibrary.Admin.Users.ManageUsers" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

    <style>
        .el-admin-users .el-au-filterbar {
            display: grid;
            grid-template-columns:
                minmax(180px, 2fr)
                minmax(130px, 1fr)
                minmax(140px, 1fr)
                minmax(140px, 1fr)
                auto;
            gap: 12px;
            align-items: end;
            margin-bottom: 10px;
            padding: 16px;
            border: 1px solid #e4ebf3;
            border-radius: 10px;
            background: #f8fafc;
        }

        .el-admin-users .el-au-filterbar label {
            display: block;
            margin-bottom: 6px;
            color: #43566b;
            font-size: 11px;
            font-weight: 700;
        }

        .el-admin-users .el-au-filterbar input,
        .el-admin-users .el-au-filterbar select {
            width: 100%;
            height: 40px;
            padding: 8px 11px;
            border: 1px solid #dce5ee;
            border-radius: 8px;
            background: #fff;
            color: #172b43;
            font-size: 12px;
        }

        .el-admin-users .el-au-filter-actions {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .el-admin-users .el-au-filter-actions .el-au-btn {
            height: 40px;
            white-space: nowrap;
        }

        .el-admin-users .el-au-filter-count {
            display: block;
            margin: 0 0 12px;
            color: #718096;
            font-size: 12px;
        }

        .el-admin-users .el-au-filter-note {
            margin: 0 0 12px;
            color: #718096;
            font-size: 12px;
        }

        .el-admin-users .el-au-pager {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 12px;
            padding: 18px 0 4px;
        }

        .el-admin-users .el-au-pager .el-au-btn:disabled {
            opacity: .45;
            cursor: default;
        }

        .el-admin-users .el-au-page-info {
            color: #61748e;
            font-size: 13px;
        }
    </style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="el-admin-users">

        <!-- PAGE HEADER -->
        <div class="el-au-header">
            <div>
                <span class="el-au-eyebrow">
                    ADMINISTRATION / USER MANAGEMENT
                </span>

                <h1>Manage Users</h1>

                <p>
                    View registered members, manage accounts,
                    and update library permissions.
                </p>
            </div>

            <a href="#userEditor"
               class="el-au-btn el-au-btn-primary">
                + Create User
            </a>
        </div>

        <!-- FEEDBACK -->
        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="el-au-message" />

        <!-- USER DIRECTORY -->
        <section class="el-au-panel">

            <div class="el-au-panel-heading">
                <div>
                    <h2>Registered Users</h2>
                    <p>
                        Select Edit to update an account
                        or Delete to remove a user.
                    </p>
                </div>

                <span class="el-au-chip">
                    User Directory
                </span>
            </div>

            <!-- SEARCH AND FILTER -->
            <asp:Panel
                ID="pnlUserFilters"
                runat="server"
                DefaultButton="btnApply"
                CssClass="el-au-filterbar">

                <div>
                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtSearch"
                        Text="Search Users" />

                    <asp:TextBox
                        ID="txtSearch"
                        runat="server"
                        CssClass="form-control"
                        MaxLength="255"
                        placeholder="Search name, email, ID or contact..."
                        autocomplete="off" />
                </div>

                <div>
                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlFilterRole"
                        Text="Role" />

                    <asp:DropDownList
                        ID="ddlFilterRole"
                        runat="server"
                        CssClass="form-control">

                        <asp:ListItem Text="All Roles" Value="" />
                        <asp:ListItem Text="Librarian / Admin" Value="2" />
                        <asp:ListItem Text="Customer" Value="1" />

                    </asp:DropDownList>
                </div>

                <div>
                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlFilterBorrowing"
                        Text="Borrowing" />

                    <asp:DropDownList
                        ID="ddlFilterBorrowing"
                        runat="server"
                        CssClass="form-control">

                        <asp:ListItem Text="All Permissions" Value="All" />
                        <asp:ListItem Text="Allowed" Value="Allowed" />
                        <asp:ListItem Text="Restricted" Value="Restricted" />

                    </asp:DropDownList>
                </div>

                <div>
                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlSort"
                        Text="Sort By" />

                    <asp:DropDownList
                        ID="ddlSort"
                        runat="server"
                        CssClass="form-control">

                        <asp:ListItem Text="Newest First" Value="Newest" />
                        <asp:ListItem Text="Oldest First" Value="Oldest" />
                        <asp:ListItem Text="Name (A–Z)" Value="NameAsc" />
                        <asp:ListItem Text="Name (Z–A)" Value="NameDesc" />
                        <asp:ListItem Text="Email (A–Z)" Value="EmailAsc" />

                    </asp:DropDownList>
                </div>

                <div class="el-au-filter-actions">

                    <asp:Button
                        ID="btnApply"
                        runat="server"
                        Text="Apply"
                        CssClass="el-au-btn el-au-btn-primary"
                        CausesValidation="false"
                        OnClick="btnApply_Click" />

                    <asp:Button
                        ID="btnClearFilters"
                        runat="server"
                        Text="Clear"
                        CssClass="el-au-btn el-au-btn-light"
                        CausesValidation="false"
                        OnClick="btnClearFilters_Click" />

                </div>

            </asp:Panel>

            <p class="el-au-filter-note">
                Press Enter or click Apply to search and filter users.
            </p>

            <asp:Label
                ID="lblResultCount"
                runat="server"
                CssClass="el-au-filter-count"
                Text="Showing users" />

            <!-- USER TABLE -->
            <div class="el-au-table-wrap">

                <asp:GridView
                    ID="gvUsers"
                    runat="server"
                    AutoGenerateColumns="False"
                    DataKeyNames="UserID"
                    CssClass="el-au-table"
                    GridLines="None"
                    EmptyDataText="No users match your search or filters."
                    OnRowCommand="gvUsers_RowCommand">

                    <Columns>

                        <asp:TemplateField HeaderText="User">
                            <ItemTemplate>
                                <div class="el-au-user-cell">

                                    <asp:Image
                                        runat="server"
                                        CssClass="el-au-avatar-small"
                                        ImageUrl='<%# GetProfileImageUrl(Eval("ProfileImagePath")) %>'
                                        AlternateText="Profile picture" />

                                    <div class="el-au-user-details">
                                        <strong>
                                            <%#: Eval("FullName") %>
                                        </strong>
                                        <small>
                                            <%#: Eval("Email") %>
                                        </small>
                                    </div>

                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField
                            DataField="UserID"
                            HeaderText="ID" />

                        <asp:BoundField
                            DataField="GenderName"
                            HeaderText="Gender" />

                        <asp:BoundField
                            DataField="ContactNumber"
                            HeaderText="Contact" />

                        <asp:TemplateField HeaderText="Role">
                            <ItemTemplate>

                                <span class='<%# Convert.ToString(Eval("Role")) == "2"
                                    ? "el-au-role admin"
                                    : "el-au-role customer" %>'>

                                    <%# Convert.ToString(Eval("Role")) == "2"
                                        ? "Librarian / Admin"
                                        : "Customer" %>

                                </span>

                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Borrowing">
                            <ItemTemplate>

                                <span class='<%# Convert.ToBoolean(Eval("IsAllowedToBorrow"))
                                    ? "el-au-status allowed"
                                    : "el-au-status restricted" %>'>

                                    <%# Convert.ToBoolean(Eval("IsAllowedToBorrow"))
                                        ? "Allowed"
                                        : "Restricted" %>

                                </span>

                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>

                                <div class="el-au-row-actions">

                                    <asp:LinkButton
                                        ID="btnEdit"
                                        runat="server"
                                        Text="Edit"
                                        CssClass="el-au-action"
                                        CommandName="EditUser"
                                        CommandArgument='<%# Eval("UserID") %>'
                                        CausesValidation="false" />

                                    <asp:LinkButton
                                        ID="btnDelete"
                                        runat="server"
                                        Text="Delete"
                                        CssClass="el-au-action danger"
                                        CommandName="DeleteUser"
                                        CommandArgument='<%# Eval("UserID") %>'
                                        CausesValidation="false"
                                        OnClientClick="return confirm('Delete this user?');" />

                                </div>

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

            <!-- PAGINATION -->
            <div class="el-au-pager">

                <asp:Button
                    ID="btnPrevious"
                    runat="server"
                    Text="← Previous"
                    CssClass="el-au-btn el-au-btn-light"
                    CausesValidation="false"
                    OnClick="btnPrevious_Click" />

                <asp:Label
                    ID="lblPageInfo"
                    runat="server"
                    CssClass="el-au-page-info"
                    Text="Page 1 of 1" />

                <asp:Button
                    ID="btnNext"
                    runat="server"
                    Text="Next →"
                    CssClass="el-au-btn el-au-btn-light"
                    CausesValidation="false"
                    OnClick="btnNext_Click" />

            </div>

        </section>

        <!-- CREATE / EDIT USER -->
        <section class="el-au-panel el-au-editor"
                 id="userEditor">

            <div class="el-au-panel-heading">
                <div>
                    <h2>Create / Edit User</h2>
                    <p>
                        Enter personal information,
                        account details, and permissions.
                    </p>
                </div>

                <span class="el-au-chip">
                    Account Information
                </span>
            </div>

            <asp:HiddenField
                ID="hfUserID"
                runat="server"
                Value="0" />

            <div class="el-au-editor-layout">

                <!-- MAIN FORM -->
                <div class="el-au-form-main">

                    <div class="el-au-section-title">
                        <h3>Personal Information</h3>
                        <p>Basic details of the library member.</p>
                    </div>

                    <div class="el-au-form-grid">

                        <div class="el-au-field el-au-full">
                            <label for="<%= txtEmail.ClientID %>">
                                Email Address *
                            </label>

                            <asp:TextBox
                                ID="txtEmail"
                                runat="server"
                                CssClass="form-control"
                                TextMode="Email"
                                MaxLength="100"
                                placeholder="Enter email address" />
                        </div>

                        <div class="el-au-field">
                            <label for="<%= txtFirstName.ClientID %>">
                                First Name *
                            </label>

                            <asp:TextBox
                                ID="txtFirstName"
                                runat="server"
                                CssClass="form-control"
                                MaxLength="100"
                                placeholder="First name" />
                        </div>

                        <div class="el-au-field">
                            <label for="<%= txtMiddleName.ClientID %>">
                                Middle Name
                            </label>

                            <asp:TextBox
                                ID="txtMiddleName"
                                runat="server"
                                CssClass="form-control"
                                MaxLength="100"
                                placeholder="Optional" />
                        </div>

                        <div class="el-au-field">
                            <label for="<%= txtLastName.ClientID %>">
                                Last Name *
                            </label>

                            <asp:TextBox
                                ID="txtLastName"
                                runat="server"
                                CssClass="form-control"
                                MaxLength="100"
                                placeholder="Last name" />
                        </div>

                        <div class="el-au-field">
                            <label for="<%= ddlGender.ClientID %>">
                                Gender *
                            </label>

                            <asp:DropDownList
                                ID="ddlGender"
                                runat="server"
                                CssClass="form-control" />
                        </div>

                        <div class="el-au-field">
                            <label for="<%= txtContactNumber.ClientID %>">
                                Contact Number *
                            </label>

                            <asp:TextBox
                                ID="txtContactNumber"
                                runat="server"
                                CssClass="form-control"
                                MaxLength="30"
                                placeholder="Contact number" />
                        </div>

                        <div class="el-au-field el-au-full">
                            <label for="<%= txtAddress.ClientID %>">
                                Address *
                            </label>

                            <asp:TextBox
                                ID="txtAddress"
                                runat="server"
                                CssClass="form-control"
                                TextMode="MultiLine"
                                Rows="3"
                                MaxLength="255"
                                placeholder="Enter complete address" />
                        </div>

                    </div>

                    <!-- ACCOUNT SETTINGS -->
                    <div class="el-au-section-title el-au-section-separated">
                        <h3>Account Settings</h3>
                        <p>
                            Configure access level and borrowing eligibility.
                        </p>
                    </div>

                    <div class="el-au-form-grid">

                        <div class="el-au-field">
                            <label for="<%= ddlRole.ClientID %>">
                                Account Role *
                            </label>

                            <asp:DropDownList
                                ID="ddlRole"
                                runat="server"
                                CssClass="form-control">

                                <asp:ListItem
                                    Text="Customer"
                                    Value="1" />

                                <asp:ListItem
                                    Text="Librarian / Admin"
                                    Value="2" />

                            </asp:DropDownList>
                        </div>

                        <div class="el-au-field">
                            <label for="<%= txtPassword.ClientID %>">
                                Password
                            </label>

                            <asp:TextBox
                                ID="txtPassword"
                                runat="server"
                                CssClass="form-control"
                                TextMode="Password"
                                placeholder="Enter password" />
                        </div>

                        <div class="el-au-full">
                            <asp:Label
                                ID="lblPasswordNote"
                                runat="server"
                                CssClass="el-au-help"
                                Text="For new users, enter a password. Existing passwords are not displayed." />
                        </div>

                        <div class="el-au-full">
                            <div class="el-au-permission-box">

                                <asp:CheckBox
                                    ID="chkAllowedToBorrow"
                                    runat="server"
                                    Text=" Allow this user to borrow books" />

                                <p>
                                    Controls whether this account
                                    is eligible to borrow books
                                    from the library.
                                </p>

                            </div>
                        </div>

                    </div>

                </div>

                <!-- PROFILE IMAGE -->
                <aside class="el-au-photo-panel">

                    <h3>Profile Picture</h3>

                    <p>
                        Upload a picture to identify
                        this library member.
                    </p>

                    <div class="el-au-photo-preview">
                        <asp:Image
                            ID="imgProfilePreview"
                            runat="server"
                            CssClass="el-au-avatar-large"
                            AlternateText="User profile picture" />
                    </div>

                    <label for="<%= fuProfilePicture.ClientID %>">
                        Choose profile image
                    </label>

                    <asp:FileUpload
                        ID="fuProfilePicture"
                        runat="server"
                        CssClass="form-control"
                        accept=".jpg,.jpeg,.png,image/jpeg,image/png" />

                    <small>
                        JPG or PNG only. Maximum 2 MB.
                        Leave blank to keep the existing picture.
                    </small>

                </aside>

            </div>

            <div class="el-au-editor-actions">

                <span>
                    Fields marked * are required.
                </span>

                <div class="el-au-button-group">

                    <asp:Button
                        ID="btnClear"
                        runat="server"
                        Text="Clear Form"
                        CssClass="el-au-btn el-au-btn-light"
                        CausesValidation="false"
                        OnClick="btnClear_Click" />

                    <asp:Button
                        ID="btnSave"
                        runat="server"
                        Text="Save User"
                        CssClass="el-au-btn el-au-btn-primary"
                        OnClick="btnSave_Click" />

                </div>

            </div>

        </section>

    </div>

    <!-- PROFILE PICTURE PREVIEW + EDITOR SCROLL -->
    <script type="text/javascript">
        (function () {
            var upload = document.getElementById(
                '<%= fuProfilePicture.ClientID %>');

            var preview = document.getElementById(
                '<%= imgProfilePreview.ClientID %>');

            if (upload && preview) {
                upload.addEventListener('change', function () {
                    var file = upload.files && upload.files[0];

                    if (!file) return;

                    if (file.type !== 'image/jpeg' &&
                        file.type !== 'image/png') {
                        alert('Please choose a JPG or PNG image.');
                        upload.value = '';
                        return;
                    }

                    if (file.size > 2 * 1024 * 1024) {
                        alert('Image must not exceed 2 MB.');
                        upload.value = '';
                        return;
                    }

                    var reader = new FileReader();

                    reader.onload = function (event) {
                        preview.src = event.target.result;
                    };

                    reader.readAsDataURL(file);
                });
            }

            var editor = document.getElementById('userEditor');

            var userId = document.getElementById(
                '<%= hfUserID.ClientID %>');

            if (editor && userId &&
                userId.value !== '0' &&
                userId.value !== '') {

                editor.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        })();
    </script>

</asp:Content>
