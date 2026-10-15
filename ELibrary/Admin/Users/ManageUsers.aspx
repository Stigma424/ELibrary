
<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs"
    Inherits="ELibrary.Admin.Users.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style>
/* OCEAN TEAL — ADMIN MANAGE USERS */
.el-users-v3 {
    --u-ink:#123B4A;
    --u-teal:#168A91;
    --u-hover:#12757C;
    --u-muted:#647F89;
    --u-border:#DCE9EB;
    --u-soft:#F5FAFA;
    --u-danger:#B94E49;
    display:flex;
    flex-direction:column;
    gap:21px;
    min-width:0;
    padding-bottom:30px;
    color:var(--u-ink);
}
.el-users-v3 * { box-sizing:border-box; }
.el-users-v3 .u-heading {
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:15px;
    flex-wrap:wrap;
}
.el-users-v3 .u-eyebrow {
    color:var(--u-teal);
    font-size:10px;
    font-weight:800;
    letter-spacing:.12em;
}
.el-users-v3 h1 {
    margin:7px 0;
    color:var(--u-ink);
    font-size:29px;
    font-weight:800;
}
.el-users-v3 .u-heading p,
.el-users-v3 .u-panel-head p {
    color:var(--u-muted);
    font-size:12px;
    line-height:1.7;
    margin:0;
}
.el-users-v3 .u-btn {
    display:inline-flex;
    align-items:center;
    justify-content:center;
    min-height:40px;
    padding:9px 15px;
    background:white;
    border:1px solid var(--u-border);
    border-radius:9px;
    color:var(--u-ink);
    text-decoration:none;
    font-size:12px;
    font-weight:750;
    cursor:pointer;
}
.el-users-v3 .u-btn:hover {
    background:#EAF5F6;
    border-color:#B4DADD;
    color:var(--u-ink);
}
.el-users-v3 .u-btn-primary {
    color:white;
    background:var(--u-teal);
    border-color:var(--u-teal);
}
.el-users-v3 .u-btn-primary:hover {
    color:white;
    background:var(--u-hover);
    border-color:var(--u-hover);
}
.el-users-v3 .u-btn:disabled {opacity:.45;cursor:default;}
.el-users-v3 .u-panel {
    min-width:0;
    padding:23px;
    background:white;
    border:1px solid var(--u-border);
    border-radius:14px;
    box-shadow:0 3px 14px rgba(18,59,74,.035);
    scroll-margin-top:100px;
}
.el-users-v3 .u-panel-head {
    display:flex;
    justify-content:space-between;
    align-items:flex-start;
    flex-wrap:wrap;
    gap:14px;
    margin-bottom:19px;
}
.el-users-v3 .u-panel-head h2 {
    color:var(--u-ink);
    font-size:18px;
    font-weight:800;
    margin:0 0 5px;
}
.el-users-v3 .u-tag {
    display:inline-block;
    padding:7px 11px;
    background:#E9F6F6;
    color:#126E73;
    border-radius:8px;
    font-size:11px;
    font-weight:750;
}
.el-users-v3 .u-filters {
    display:grid;
    grid-template-columns:minmax(180px,2fr) repeat(3,minmax(125px,1fr)) auto;
    gap:12px;
    align-items:end;
    padding:16px;
    background:var(--u-soft);
    border:1px solid var(--u-border);
    border-radius:11px;
}
.el-users-v3 .u-field {min-width:0;}
.el-users-v3 .u-field label {
    display:block;
    margin-bottom:7px;
    font-size:12px;
    font-weight:700;
    color:#375968;
}
.el-users-v3 .u-input {
    display:block;
    width:100%;
    min-height:41px;
    padding:9px 12px;
    font-size:12px;
    border:1px solid #CFE1E4;
    border-radius:8px;
    color:var(--u-ink);
    background:white;
}
.el-users-v3 textarea.u-input {min-height:90px;resize:vertical;}
.el-users-v3 .u-input:focus {
    outline:none;
    border-color:var(--u-teal);
    box-shadow:0 0 0 3px rgba(22,138,145,.12);
}
.el-users-v3 .u-filter-actions {display:flex;gap:8px;}
.el-users-v3 .u-result-bar {
    display:flex;
    justify-content:space-between;
    gap:12px;
    flex-wrap:wrap;
    font-size:12px;
    color:var(--u-muted);
    margin:16px 0 12px;
}
.el-users-v3 .u-table-wrap {
    overflow-x:auto;
    border:1px solid var(--u-border);
    border-radius:10px;
}
.el-users-v3 .u-table {
    min-width:850px;
    width:100%;
    border-collapse:collapse;
    font-size:12px;
}
.el-users-v3 .u-table th {
    background:var(--u-soft);
    color:#496B75;
    font-size:11px;
    font-weight:800;
    text-align:left;
    padding:14px 12px;
    border-bottom:1px solid var(--u-border);
    white-space:nowrap;
}
.el-users-v3 .u-table td {
    color:#47616D;
    padding:13px 12px;
    border-bottom:1px solid #EDF3F4;
    vertical-align:middle;
}
.el-users-v3 .u-table tr:hover td {background:#F9FCFC;}
.el-users-v3 .u-person {display:flex;align-items:center;gap:11px;}
.el-users-v3 .u-avatar {
    width:40px;
    height:40px;
    object-fit:cover;
    border:1px solid #CCE5E7;
    border-radius:50%;
    background:#EAF6F6;
    flex-shrink:0;
}
.el-users-v3 .u-person-copy {display:flex;flex-direction:column;gap:4px;}
.el-users-v3 .u-person-copy strong {
    color:var(--u-ink);
    font-size:12px;
    overflow-wrap:anywhere;
}
.el-users-v3 .u-person-copy small {
    color:var(--u-muted);
    font-size:11px;
    overflow-wrap:anywhere;
}
.el-users-v3 .u-pill {
    display:inline-flex;
    padding:6px 10px;
    border-radius:999px;
    font-size:11px;
    font-weight:750;
    white-space:nowrap;
}
.el-users-v3 .u-pill.admin {background:#E4F0F7;color:#315C79;}
.el-users-v3 .u-pill.customer {background:#EAF6F6;color:#126E73;}
.el-users-v3 .u-pill.allowed {background:#E6F6EE;color:#237C62;}
.el-users-v3 .u-pill.restricted {background:#FCE9E7;color:#A63D39;}
.el-users-v3 .u-row-actions {display:flex;gap:7px;flex-wrap:wrap;}
.el-users-v3 .u-row-action {
    padding:7px 11px;
    border:1px solid #CDE7E9;
    border-radius:7px;
    color:#126E73;
    background:#E9F6F6;
    text-decoration:none;
    font-size:11px;
    font-weight:750;
}
.el-users-v3 .u-row-action:hover {background:#DDF0F1;color:#0F6065;}
.el-users-v3 .u-row-action.danger {
    color:#B94E49;
    background:#FFF4F3;
    border-color:#F2D8D5;
}
.el-users-v3 .u-pager {
    display:flex;
    justify-content:center;
    align-items:center;
    gap:12px;
    padding-top:19px;
    font-size:12px;
    color:var(--u-muted);
}
.el-users-v3 .u-message {
    display:block;
    margin-bottom:16px;
    font-size:12px;
    line-height:1.7;
}
.el-users-v3 .u-message:empty {display:none;}
.el-users-v3 .u-message.success {
    padding:13px 16px;
    background:#E9F7F1;
    border:1px solid #C8E8D7;
    border-left:4px solid #28845B;
    border-radius:9px;
    color:#236747;
}
.el-users-v3 .u-message.error {
    padding:13px 16px;
    background:#FFF0EF;
    border:1px solid #F2D3CF;
    border-left:4px solid #C34D46;
    border-radius:9px;
    color:#9E3E39;
}
.el-users-v3 .u-editor-grid {
    display:grid;
    grid-template-columns:minmax(0,1fr) 235px;
    align-items:start;
    gap:23px;
}
.el-users-v3 .u-form-grid {
    display:grid;
    grid-template-columns:repeat(2,minmax(0,1fr));
    gap:16px;
}
.el-users-v3 .u-full {grid-column:1/-1;}
.el-users-v3 .u-section-title {
    font-size:14px;
    font-weight:800;
    color:var(--u-ink);
    margin:0 0 14px;
}
.el-users-v3 .u-section-separated {
    padding-top:20px;
    margin-top:23px;
    border-top:1px solid #EDF3F4;
}
.el-users-v3 .u-photo {
    padding:17px;
    background:var(--u-soft);
    border:1px solid var(--u-border);
    border-radius:11px;
}
.el-users-v3 .u-photo-preview {
    display:flex;
    justify-content:center;
    align-items:center;
    padding:16px;
    margin:15px 0;
    background:white;
    border:1px dashed #BCD6D9;
    border-radius:10px;
}
.el-users-v3 .u-photo-image {
    width:125px;
    height:125px;
    border-radius:50%;
    object-fit:cover;
}
.el-users-v3 .u-help {
    display:block;
    margin-top:7px;
    color:var(--u-muted);
    font-size:11px;
    line-height:1.6;
}
.el-users-v3 .u-permission {
    padding:15px 17px;
    background:#EAF6F6;
    border:1px solid #CDE7E9;
    border-radius:10px;
    font-size:12px;
}
.el-users-v3 .u-permission label {font-weight:750;}
.el-users-v3 .u-form-actions {
    display:flex;
    align-items:center;
    justify-content:space-between;
    flex-wrap:wrap;
    gap:15px;
    margin-top:20px;
    padding-top:20px;
    border-top:1px solid #EDF3F4;
}
.el-users-v3 .u-form-buttons {display:flex;flex-wrap:wrap;gap:9px;}
@media(max-width:1250px) {
    .el-users-v3 .u-filters {grid-template-columns:repeat(2,minmax(0,1fr));}
    .el-users-v3 .u-search {grid-column:1/-1;}
}
@media(max-width:850px) {
    .el-users-v3 .u-editor-grid {grid-template-columns:1fr;}
}
@media(max-width:650px) {
    .el-users-v3 h1 {font-size:24px;}
    .el-users-v3 .u-panel {padding:15px;}
    .el-users-v3 .u-filters,
    .el-users-v3 .u-form-grid {grid-template-columns:1fr;}
    .el-users-v3 .u-search,
    .el-users-v3 .u-full {grid-column:auto;}
    .el-users-v3 .u-filter-actions,
    .el-users-v3 .u-form-buttons {width:100%;}
    .el-users-v3 .u-filter-actions .u-btn,
    .el-users-v3 .u-form-buttons .u-btn {flex:1;}
}
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div class="el-users-v3">

    <header class="u-heading">
        <div>
            <span class="u-eyebrow">ADMINISTRATION / USER MANAGEMENT</span>
            <h1>Manage Users</h1>
            <p>Manage library accounts, roles, and borrowing permissions.</p>
        </div>

        <asp:Button ID="btnCreateUser" runat="server"
            Text="+ Add User" CssClass="u-btn u-btn-primary"
            CausesValidation="false" OnClick="btnCreateUser_Click" />
    </header>

    <!-- USER DIRECTORY -->

    <section id="userDirectory" class="u-panel">
        <div class="u-panel-head">
            <div>
                <h2>Registered Users</h2>
                <p>Find an account to edit or delete.</p>
            </div>
            <span class="u-tag">User Directory</span>
        </div>

        <asp:Label ID="lblMessage" runat="server"
            EnableViewState="false" CssClass="u-message"
            role="status" aria-live="polite" />

        <asp:Panel ID="pnlUserFilters" runat="server"
            DefaultButton="btnApply" CssClass="u-filters">

            <div class="u-field u-search">
                <asp:Label runat="server"
                    AssociatedControlID="txtSearch" Text="Search Users" />
                <asp:TextBox ID="txtSearch" runat="server"
                    CssClass="u-input" MaxLength="255"
                    autocomplete="off"
                    placeholder="Name, email, contact, or user ID" />
            </div>

            <div class="u-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlFilterRole" Text="Role" />
                <asp:DropDownList ID="ddlFilterRole"
                    runat="server" CssClass="u-input">
                    <asp:ListItem Text="All Roles" Value="" />
                    <asp:ListItem Text="Librarian / Admin" Value="2" />
                    <asp:ListItem Text="Customer" Value="1" />
                </asp:DropDownList>
            </div>

            <div class="u-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlFilterBorrowing" Text="Borrowing" />
                <asp:DropDownList ID="ddlFilterBorrowing"
                    runat="server" CssClass="u-input">
                    <asp:ListItem Text="All Permissions" Value="All" />
                    <asp:ListItem Text="Allowed" Value="Allowed" />
                    <asp:ListItem Text="Restricted" Value="Restricted" />
                </asp:DropDownList>
            </div>

            <div class="u-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlSort" Text="Sort By" />
                <asp:DropDownList ID="ddlSort"
                    runat="server" CssClass="u-input">
                    <asp:ListItem Text="Newest First" Value="Newest" />
                    <asp:ListItem Text="Oldest First" Value="Oldest" />
                    <asp:ListItem Text="Name (A–Z)" Value="NameAsc" />
                    <asp:ListItem Text="Name (Z–A)" Value="NameDesc" />
                    <asp:ListItem Text="Email (A–Z)" Value="EmailAsc" />
                </asp:DropDownList>
            </div>

            <div class="u-filter-actions">
                <asp:Button ID="btnApply" runat="server"
                    Text="Apply" CssClass="u-btn u-btn-primary"
                    CausesValidation="false" OnClick="btnApply_Click" />
                <asp:Button ID="btnClearFilters" runat="server"
                    Text="Clear" CssClass="u-btn"
                    CausesValidation="false" OnClick="btnClearFilters_Click" />
            </div>
        </asp:Panel>

        <div class="u-result-bar">
            <asp:Label ID="lblResultCount" runat="server"
                Text="Showing users" />
            <span>Press Enter or Apply to search and filter.</span>
        </div>

        <div class="u-table-wrap">
            <asp:GridView ID="gvUsers" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="UserID"
                CssClass="u-table"
                GridLines="None"
                EmptyDataText="No users match your filters."
                OnRowCommand="gvUsers_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="User">
                        <ItemTemplate>
                            <div class="u-person">
                                <asp:Image runat="server"
                                    CssClass="u-avatar"
                                    ImageUrl='<%# GetProfileImageUrl(Eval("ProfileImagePath")) %>'
                                    AlternateText="Profile picture" />
                                <div class="u-person-copy">
                                    <strong><%#: Eval("FullName") %></strong>
                                    <small><%#: Eval("Email") %></small>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="UserID" HeaderText="ID" />
                    <asp:BoundField DataField="GenderName" HeaderText="Gender" />
                    <asp:BoundField DataField="ContactNumber" HeaderText="Contact" />

                    <asp:TemplateField HeaderText="Role">
                        <ItemTemplate>
                            <span class='<%# Convert.ToString(Eval("Role")) == "2"
                                ? "u-pill admin" : "u-pill customer" %>'>
                                <%# Convert.ToString(Eval("Role")) == "2"
                                    ? "Librarian / Admin" : "Customer" %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Borrowing">
                        <ItemTemplate>
                            <span class='<%# Convert.ToBoolean(Eval("IsAllowedToBorrow"))
                                ? "u-pill allowed" : "u-pill restricted" %>'>
                                <%# Convert.ToBoolean(Eval("IsAllowedToBorrow"))
                                    ? "Allowed" : "Restricted" %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="u-row-actions">
                                <asp:LinkButton ID="btnEdit" runat="server"
                                    Text="Edit" CssClass="u-row-action"
                                    CommandName="EditUser"
                                    CommandArgument='<%# Eval("UserID") %>'
                                    CausesValidation="false" />
                                <asp:LinkButton ID="btnDelete" runat="server"
                                    Text="Delete" CssClass="u-row-action danger"
                                    CommandName="DeleteUser"
                                    CommandArgument='<%# Eval("UserID") %>'
                                    CausesValidation="false"
                                    OnClientClick="return confirm('Delete this user? This may be prevented if their account has related records.');" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <div class="u-pager">
            <asp:Button ID="btnPrevious" runat="server"
                Text="← Previous" CssClass="u-btn"
                CausesValidation="false" OnClick="btnPrevious_Click" />
            <asp:Label ID="lblPageInfo" runat="server"
                Text="Page 1 of 1" />
            <asp:Button ID="btnNext" runat="server"
                Text="Next →" CssClass="u-btn"
                CausesValidation="false" OnClick="btnNext_Click" />
        </div>
    </section>

    <!-- EDITOR: OPEN ONLY FOR CREATE OR EDIT -->

    <asp:Panel ID="pnlUserEditor" runat="server"
        Visible="false" ClientIDMode="Static"
        CssClass="u-panel">

        <div class="u-panel-head">
            <div>
                <h2><asp:Label ID="lblEditorTitle" runat="server"
                    Text="Add New User" /></h2>
                <p>Update account details and borrowing eligibility.</p>
            </div>
            <span class="u-tag">Account Information</span>
        </div>

        <asp:Label ID="lblEditorMessage" runat="server"
            EnableViewState="false" CssClass="u-message"
            role="status" aria-live="polite" />

        <asp:HiddenField ID="hfUserID" runat="server" Value="0" />

        <div class="u-editor-grid">
            <div>
                <h3 class="u-section-title">Personal Information</h3>

                <div class="u-form-grid">
                    <div class="u-field u-full">
                        <asp:Label runat="server"
                            AssociatedControlID="txtEmail"
                            Text="Email Address *" />
                        <asp:TextBox ID="txtEmail" runat="server"
                            CssClass="u-input" TextMode="Email"
                            MaxLength="100" placeholder="Email address" />
                    </div>

                    <div class="u-field">
                        <asp:Label runat="server"
                            AssociatedControlID="txtFirstName"
                            Text="First Name *" />
                        <asp:TextBox ID="txtFirstName" runat="server"
                            CssClass="u-input" MaxLength="100" />
                    </div>

                    <div class="u-field">
                        <asp:Label runat="server"
                            AssociatedControlID="txtMiddleName"
                            Text="Middle Name" />
                        <asp:TextBox ID="txtMiddleName" runat="server"
                            CssClass="u-input" MaxLength="100" />
                    </div>

                    <div class="u-field">
                        <asp:Label runat="server"
                            AssociatedControlID="txtLastName"
                            Text="Last Name *" />
                        <asp:TextBox ID="txtLastName" runat="server"
                            CssClass="u-input" MaxLength="100" />
                    </div>

                    <div class="u-field">
                        <asp:Label runat="server"
                            AssociatedControlID="ddlGender"
                            Text="Gender *" />
                        <asp:DropDownList ID="ddlGender" runat="server"
                            CssClass="u-input" />
                    </div>

                    <div class="u-field">
                        <asp:Label runat="server"
                            AssociatedControlID="txtContactNumber"
                            Text="Contact Number *" />
                        <asp:TextBox ID="txtContactNumber" runat="server"
                            CssClass="u-input" MaxLength="30" />
                    </div>

                    <div class="u-field u-full">
                        <asp:Label runat="server"
                            AssociatedControlID="txtAddress"
                            Text="Address *" />
                        <asp:TextBox ID="txtAddress" runat="server"
                            CssClass="u-input" TextMode="MultiLine"
                            Rows="3" MaxLength="255" />
                    </div>
                </div>

                <h3 class="u-section-title u-section-separated">
                    Account Settings
                </h3>

                <div class="u-form-grid">
                    <div class="u-field">
                        <asp:Label runat="server"
                            AssociatedControlID="ddlRole"
                            Text="Account Role *" />
                        <asp:DropDownList ID="ddlRole" runat="server"
                            CssClass="u-input">
                            <asp:ListItem Text="Customer" Value="1" />
                            <asp:ListItem Text="Librarian / Admin" Value="2" />
                        </asp:DropDownList>
                    </div>

                    <div class="u-field">
                        <asp:Label runat="server"
                            AssociatedControlID="txtPassword"
                            Text="Password" />
                        <asp:TextBox ID="txtPassword" runat="server"
                            CssClass="u-input" TextMode="Password"
                            autocomplete="new-password" />
                        <asp:Label ID="lblPasswordNote"
                            runat="server" CssClass="u-help"
                            Text="A password is required for a new user." />
                    </div>

                    <div class="u-full">
                        <div class="u-permission">
                            <asp:CheckBox ID="chkAllowedToBorrow"
                                runat="server"
                                Text=" Allow this user to borrow books" />
                            <small class="u-help">
                                Controls whether the account can borrow library books.
                            </small>
                        </div>
                    </div>
                </div>
            </div>

            <aside class="u-photo">
                <h3 class="u-section-title">Profile Picture</h3>
                <span class="u-help">
                    Optional. Keep the field empty to retain the current photo.
                </span>

                <div class="u-photo-preview">
                    <asp:Image ID="imgProfilePreview" runat="server"
                        CssClass="u-photo-image"
                        AlternateText="Profile preview" />
                </div>

                <div class="u-field">
                    <asp:Label runat="server"
                        AssociatedControlID="fuProfilePicture"
                        Text="Choose Image" />
                    <asp:FileUpload ID="fuProfilePicture" runat="server"
                        CssClass="u-input"
                        accept=".jpg,.jpeg,.png,image/jpeg,image/png" />
                </div>

                <small class="u-help">
                    JPG or PNG, maximum 2 MB.
                </small>
            </aside>
        </div>

        <div class="u-form-actions">
            <small class="u-help">Fields marked * are required.</small>

            <div class="u-form-buttons">
                <asp:Button ID="btnClear" runat="server"
                    Text="Clear Form" CssClass="u-btn"
                    CausesValidation="false" OnClick="btnClear_Click" />

                <asp:Button ID="btnCloseEditor" runat="server"
                    Text="Close" CssClass="u-btn"
                    CausesValidation="false" OnClick="btnCloseEditor_Click" />

                <asp:Button ID="btnSave" runat="server"
                    Text="Save User" CssClass="u-btn u-btn-primary"
                    CausesValidation="false" OnClick="btnSave_Click" />
            </div>
        </div>
    </asp:Panel>

</div>

<asp:HiddenField ID="hfFocusTarget" runat="server"
    ClientIDMode="Static" />

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
                    alert('Select a JPG or PNG image.');
                    upload.value = '';
                    return;
                }

                if (file.size > 2 * 1024 * 1024) {
                    alert('Image must not exceed 2 MB.');
                    upload.value = '';
                    return;
                }

                var reader = new FileReader();
                reader.onload = function (e) {
                    preview.src = e.target.result;
                };
                reader.readAsDataURL(file);
            });
        }

        var focus = document.getElementById('hfFocusTarget');
        if (focus && focus.value) {
            var section = document.getElementById(focus.value);
            if (section) {
                requestAnimationFrame(function () {
                    section.scrollIntoView({
                        behavior: window.matchMedia(
                            '(prefers-reduced-motion: reduce)').matches
                            ? 'auto' : 'smooth',
                        block: 'start'
                    });
                });
            }
        }
    })();
</script>

</asp:Content>
