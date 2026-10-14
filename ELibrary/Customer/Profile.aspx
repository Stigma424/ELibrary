
<%@ Page Title="My Profile"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Profile.aspx.cs"
    Inherits="ELibrary.Customer.Profile" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">
</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="el-profile-v2">

        <!-- PAGE HEADER -->
        <div class="el-profile-v2-heading">
            <div>
                <span class="el-section-eyebrow">
                    MY ACCOUNT
                </span>

                <h1>My Profile</h1>

                <p>
                    Manage your personal information
                    and profile picture.
                </p>
            </div>

            <a href="<%= ResolveUrl("~/CustomerHome.aspx") %>"
               class="el-profile-v2-back">
                ← Dashboard
            </a>
        </div>

        <!-- PROFILE SUMMARY -->
        <section class="el-profile-v2-summary">

            <div class="el-profile-v2-summary-banner"></div>

            <div class="el-profile-v2-summary-content">

                <div class="el-profile-v2-avatar-wrap">
                    <asp:Image
                        ID="imgProfilePreview"
                        runat="server"
                        CssClass="el-profile-v2-avatar"
                        AlternateText="My profile picture" />
                </div>

                <div class="el-profile-v2-identity">
                    <h2>
                        <asp:Label
                            ID="lblProfileName"
                            runat="server"
                            Text="My Account" />
                    </h2>

                    <p>
                        <asp:Label
                            ID="lblProfileEmail"
                            runat="server" />
                    </p>

                    <span class="el-profile-v2-account-type">
                        Library Member
                    </span>
                </div>

            </div>

        </section>

        <!-- MESSAGE -->
        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="el-profile-v2-message" />

        <!-- PROFILE FORM -->
        <div class="el-profile-v2-layout">

            <section class="el-profile-v2-main">

                <div class="el-profile-v2-section-heading">
                    <div>
                        <h2>Personal Information</h2>
                        <p>
                            Keep your account information
                            accurate and up to date.
                        </p>
                    </div>
                </div>

                <div class="el-profile-v2-form-grid">

                    <div class="el-profile-v2-field full-width">
                        <label for="<%= txtEmail.ClientID %>">
                            Email Address
                            <span>*</span>
                        </label>

                        <asp:TextBox
                            ID="txtEmail"
                            runat="server"
                            CssClass="form-control"
                            TextMode="Email"
                            MaxLength="100"
                            placeholder="Enter your email address" />
                    </div>

                    <div class="el-profile-v2-field">
                        <label for="<%= txtFirstName.ClientID %>">
                            First Name
                            <span>*</span>
                        </label>

                        <asp:TextBox
                            ID="txtFirstName"
                            runat="server"
                            CssClass="form-control"
                            MaxLength="100"
                            placeholder="First name" />
                    </div>

                    <div class="el-profile-v2-field">
                        <label for="<%= txtMiddleName.ClientID %>">
                            Middle Name
                            <small>(Optional)</small>
                        </label>

                        <asp:TextBox
                            ID="txtMiddleName"
                            runat="server"
                            CssClass="form-control"
                            MaxLength="100"
                            placeholder="Middle name" />
                    </div>

                    <div class="el-profile-v2-field">
                        <label for="<%= txtLastName.ClientID %>">
                            Last Name
                            <span>*</span>
                        </label>

                        <asp:TextBox
                            ID="txtLastName"
                            runat="server"
                            CssClass="form-control"
                            MaxLength="100"
                            placeholder="Last name" />
                    </div>

                    <div class="el-profile-v2-field">
                        <label for="<%= ddlGender.ClientID %>">
                            Gender
                            <span>*</span>
                        </label>

                        <asp:DropDownList
                            ID="ddlGender"
                            runat="server"
                            CssClass="form-select" />
                    </div>

                    <div class="el-profile-v2-field full-width">
                        <label for="<%= txtContactNumber.ClientID %>">
                            Contact Number
                            <span>*</span>
                        </label>

                        <asp:TextBox
                            ID="txtContactNumber"
                            runat="server"
                            CssClass="form-control"
                            MaxLength="30"
                            placeholder="Enter your contact number" />
                    </div>

                    <div class="el-profile-v2-field full-width">
                        <label for="<%= txtAddress.ClientID %>">
                            Address
                            <span>*</span>
                        </label>

                        <asp:TextBox
                            ID="txtAddress"
                            runat="server"
                            CssClass="form-control"
                            TextMode="MultiLine"
                            Rows="3"
                            MaxLength="255"
                            placeholder="Enter your complete address" />
                    </div>

                </div>

            </section>

            <!-- RIGHT SIDE -->
            <aside class="el-profile-v2-sidebar">

                <section class="el-profile-v2-photo-panel">

                    <div class="el-profile-v2-section-heading">
                        <h2>Profile Picture</h2>
                        <p>
                            Personalize your library account.
                        </p>
                    </div>

                    <div class="el-profile-v2-upload-icon">
                        📷
                    </div>

                    <label for="<%= fuProfilePicture.ClientID %>"
                           class="el-profile-v2-upload-label">
                        Choose a New Photo
                    </label>

                    <asp:FileUpload
                        ID="fuProfilePicture"
                        runat="server"
                        CssClass="form-control"
                        accept=".jpg,.jpeg,.png,image/jpeg,image/png" />

                    <p class="el-profile-v2-upload-note">
                        JPG or PNG only. Maximum file size:
                        2 MB. Leave blank to keep your
                        current picture.
                    </p>

                </section>

                <section class="el-profile-v2-help-panel">
                    <div class="el-profile-v2-help-icon">
                        <icon></icon>
                        ℹ
                    </div>

                    <h3>Account Information</h3>

                    <p>
                        Your personal information helps
                        the library manage your account
                        and borrowing records.
                    </p>

                    <p>
                        Changes to your profile do not
                        affect your existing borrowing
                        history.
                    </p>
                </section>

            </aside>

        </div>

        <!-- SAVE ACTIONS -->
        <div class="el-profile-v2-actions">

            <div>
                <strong>Ready to update your profile?</strong>
                <p>
                    Review your details before saving.
                </p>
            </div>

            <asp:Button
                ID="btnSave"
                runat="server"
                Text="Save Changes"
                CssClass="btn el-profile-v2-save-btn"
                OnClick="btnSave_Click" />

        </div>

    </div>

</asp:Content>
