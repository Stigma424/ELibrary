
<%@ Page Title="My Profile"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Profile.aspx.cs"
    Inherits="ELibrary.Customer.Profile" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* ==========================================
   INTERNSHIPELIB - COASTAL MINIMAL
   CUSTOMER PROFILE - UI-C6
========================================== */

.el-customer-mode .coast-profile {
    --cp-ink: #123B4A;
    --cp-teal: #168A91;
    --cp-teal-dark: #12757C;
    --cp-muted: #647F89;
    --cp-border: #DCE9EB;
    --cp-soft: #F5FAFA;

    display: flex;
    flex-direction: column;
    gap: 24px;
    width: 100%;
    min-width: 0;
    padding-bottom: 35px;
    color: var(--cp-ink);
}

.el-customer-mode .coast-profile *,
.el-customer-mode .coast-profile *::before,
.el-customer-mode .coast-profile *::after {
    box-sizing: border-box;
}

/* HEADER */

.el-customer-mode .coast-profile .cp-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 16px;
}

.el-customer-mode .coast-profile .cp-eyebrow {
    display: block;
    margin-bottom: 9px;
    color: var(--cp-teal);
    font-size: 10px;
    font-weight: 850;
    letter-spacing: .13em;
}

.el-customer-mode .coast-profile .cp-header h1 {
    margin: 0 0 8px;
    color: var(--cp-ink);
    font-size: clamp(28px, 3.5vw, 38px);
    font-weight: 850;
    letter-spacing: -.8px;
}

.el-customer-mode .coast-profile .cp-header p {
    margin: 0;
    color: var(--cp-muted);
    font-size: 12px;
    line-height: 1.8;
}

/* BUTTONS */

.el-customer-mode .coast-profile .cp-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 43px;
    padding: 10px 19px;
    border: 1px solid #CFE3E4;
    border-radius: 10px;
    background: #FFFFFF;
    color: var(--cp-ink);
    font-size: 12px;
    font-weight: 800;
    line-height: 1.5;
    text-decoration: none;
    cursor: pointer;
}

.el-customer-mode .coast-profile .cp-btn:hover {
    color: var(--cp-ink);
    background: #EAF6F6;
    border-color: #B4DADD;
    text-decoration: none;
}

.el-customer-mode .coast-profile .cp-btn-primary {
    color: #FFFFFF;
    background: var(--cp-teal);
    border-color: var(--cp-teal);
}

.el-customer-mode .coast-profile .cp-btn-primary:hover {
    color: #FFFFFF;
    background: var(--cp-teal-dark);
    border-color: var(--cp-teal-dark);
}

.el-customer-mode .coast-profile .cp-btn:disabled {
    opacity: .5;
    cursor: not-allowed;
}

/* PROFILE SUMMARY */

.el-customer-mode .coast-profile .cp-summary {
    position: relative;
    overflow: hidden;
    border: 1px solid var(--cp-border);
    border-radius: 17px;
    background: #FFFFFF;
}

.el-customer-mode .coast-profile .cp-banner {
    height: 115px;
    background: linear-gradient(
        115deg,
        #CFE8EA 0%,
        #DDEFF0 55%,
        #ECF7F5 100%
    );
}

.el-customer-mode .coast-profile .cp-banner::after {
    content: "";
    position: absolute;
    top: -95px;
    right: -30px;
    width: 280px;
    height: 280px;
    border: 1px solid rgba(22,138,145,.16);
    border-radius: 50%;
    pointer-events: none;
}

.el-customer-mode .coast-profile .cp-summary-content {
    display: flex;
    align-items: flex-end;
    gap: 20px;
    flex-wrap: wrap;
    min-width: 0;
    padding: 0 28px 26px;
}

.el-customer-mode .coast-profile .cp-avatar-frame {
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    width: 122px;
    height: 122px;
    margin-top: -48px;
    padding: 5px;
    border-radius: 50%;
    background: #FFFFFF;
    box-shadow: 0 6px 20px rgba(18,59,74,.10);
}

.el-customer-mode .coast-profile .cp-avatar {
    width: 100%;
    height: 100%;
    display: block;
    border: 1px solid #CDE5E6;
    border-radius: 50%;
    object-fit: cover;
    background: #EAF6F6;
}

.el-customer-mode .coast-profile .cp-identity {
    min-width: 0;
    flex: 1;
    padding-bottom: 4px;
}

.el-customer-mode .coast-profile .cp-identity h2 {
    margin: 0 0 6px;
    color: var(--cp-ink);
    font-size: 23px;
    font-weight: 850;
    overflow-wrap: anywhere;
}

.el-customer-mode .coast-profile .cp-identity p {
    margin: 0 0 11px;
    color: var(--cp-muted);
    font-size: 12px;
    overflow-wrap: anywhere;
}

.el-customer-mode .coast-profile .cp-role {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    padding: 7px 11px;
    border-radius: 999px;
    background: #EAF6F6;
    color: #126E73;
    font-size: 11px;
    font-weight: 800;
}

/* FORM LAYOUT */

.el-customer-mode .coast-profile .cp-layout {
    display: grid;
    grid-template-columns: minmax(0, 1fr) 290px;
    align-items: start;
    gap: 20px;
}

.el-customer-mode .coast-profile .cp-panel {
    min-width: 0;
    padding: 26px;
    border: 1px solid var(--cp-border);
    border-radius: 15px;
    background: #FFFFFF;
    box-shadow: 0 3px 15px rgba(18,59,74,.025);
}

.el-customer-mode .coast-profile .cp-panel-heading {
    margin-bottom: 22px;
}

.el-customer-mode .coast-profile .cp-panel-heading h2 {
    margin: 0 0 7px;
    color: var(--cp-ink);
    font-size: 19px;
    font-weight: 850;
}

.el-customer-mode .coast-profile .cp-panel-heading p {
    margin: 0;
    color: var(--cp-muted);
    font-size: 12px;
    line-height: 1.75;
}

.el-customer-mode .coast-profile .cp-form-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 18px;
}

.el-customer-mode .coast-profile .cp-field {
    min-width: 0;
}

.el-customer-mode .coast-profile .cp-field.full {
    grid-column: 1 / -1;
}

.el-customer-mode .coast-profile .cp-field label {
    display: block;
    margin-bottom: 8px;
    color: #375968;
    font-size: 12px;
    font-weight: 750;
}

.el-customer-mode .coast-profile .cp-required {
    color: #B94E49;
}

.el-customer-mode .coast-profile .cp-optional {
    color: var(--cp-muted);
    font-size: 11px;
    font-weight: 500;
}

.el-customer-mode .coast-profile .cp-input {
    display: block;
    width: 100%;
    min-height: 44px;
    padding: 11px 13px;
    border: 1px solid #CFE1E4;
    border-radius: 9px;
    background: #FFFFFF;
    color: var(--cp-ink);
    font-size: 12px;
    line-height: 1.5;
}

.el-customer-mode .coast-profile textarea.cp-input {
    min-height: 105px;
    resize: vertical;
}

.el-customer-mode .coast-profile .cp-input:focus {
    outline: none;
    border-color: var(--cp-teal);
    box-shadow: 0 0 0 3px rgba(22,138,145,.12);
}

.el-customer-mode .coast-profile .cp-field-help {
    display: block;
    margin-top: 7px;
    color: var(--cp-muted);
    font-size: 11px;
    line-height: 1.6;
}

/* PHOTO PANEL */

.el-customer-mode .coast-profile .cp-sidebar {
    display: flex;
    flex-direction: column;
    gap: 18px;
    min-width: 0;
}

.el-customer-mode .coast-profile .cp-photo-display {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 165px;
    margin-bottom: 17px;
    padding: 18px;
    border: 1px dashed #C9E2E4;
    border-radius: 12px;
    background: #F5FAFA;
}

.el-customer-mode .coast-profile .cp-photo-preview {
    display: block;
    width: 128px;
    height: 128px;
    border: 3px solid #FFFFFF;
    border-radius: 50%;
    object-fit: cover;
    background: #EAF6F6;
    box-shadow: 0 3px 13px rgba(18,59,74,.10);
}

.el-customer-mode .coast-profile .cp-upload-label {
    display: block;
    margin-bottom: 8px;
    color: #375968;
    font-size: 12px;
    font-weight: 750;
}

.el-customer-mode .coast-profile .cp-file {
    display: block;
    width: 100%;
    max-width: 100%;
    padding: 10px;
    border: 1px solid #CFE1E4;
    border-radius: 9px;
    background: #FFFFFF;
    color: var(--cp-ink);
    font-size: 11px;
}

.el-customer-mode .coast-profile .cp-upload-note {
    margin: 11px 0 0;
    color: var(--cp-muted);
    font-size: 11px;
    line-height: 1.8;
}

.el-customer-mode .coast-profile .cp-info-panel {
    padding: 19px;
    border: 1px solid #D2E7E8;
    border-radius: 12px;
    background: #EAF6F6;
    color: #315D67;
}

.el-customer-mode .coast-profile .cp-info-panel h3 {
    margin: 0 0 9px;
    color: var(--cp-ink);
    font-size: 14px;
    font-weight: 850;
}

.el-customer-mode .coast-profile .cp-info-panel p {
    margin: 0 0 12px;
    font-size: 11px;
    line-height: 1.8;
}

.el-customer-mode .coast-profile .cp-info-panel p:last-child {
    margin-bottom: 0;
}

/* SAVE ACTIONS AND NOTIFICATIONS */

.el-customer-mode .coast-profile .cp-save-panel {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 20px;
    flex-wrap: wrap;
    padding: 21px 25px;
    border: 1px solid var(--cp-border);
    border-radius: 14px;
    background: #FFFFFF;
}

.el-customer-mode .coast-profile .cp-save-panel h2 {
    margin: 0 0 6px;
    color: var(--cp-ink);
    font-size: 15px;
    font-weight: 850;
}

.el-customer-mode .coast-profile .cp-save-panel p {
    margin: 0;
    color: var(--cp-muted);
    font-size: 11px;
    line-height: 1.7;
}

.el-customer-mode .coast-profile .cp-save-actions {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
}

.el-customer-mode .coast-profile .el-profile-v2-message {
    display: block;
    margin: 0;
    font-size: 12px;
    line-height: 1.75;
}

.el-customer-mode .coast-profile
.el-profile-v2-message:not(:empty) {
    padding: 14px 17px;
    border-radius: 10px;
}

.el-customer-mode .coast-profile
.el-profile-v2-message.success:not(:empty) {
    background: #E9F7F1;
    border: 1px solid #C8E8D7;
    border-left: 4px solid #28845B;
    color: #236747;
}

.el-customer-mode .coast-profile
.el-profile-v2-message.error:not(:empty) {
    background: #FFF0EF;
    border: 1px solid #F2D3CF;
    border-left: 4px solid #C34D46;
    color: #9E3E39;
}

/* RESPONSIVE */

@media (max-width: 1050px) {
    .el-customer-mode .coast-profile .cp-layout {
        grid-template-columns: minmax(0, 1fr) 255px;
        gap: 14px;
    }
}

@media (max-width: 800px) {
    .el-customer-mode .coast-profile .cp-layout {
        grid-template-columns: 1fr;
    }

    .el-customer-mode .coast-profile .cp-sidebar {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        align-items: stretch;
    }
}

@media (max-width: 600px) {
    .el-customer-mode .coast-profile .cp-banner {
        height: 90px;
    }

    .el-customer-mode .coast-profile .cp-summary-content {
        padding: 0 19px 20px;
        gap: 14px;
    }

    .el-customer-mode .coast-profile .cp-avatar-frame {
        width: 96px;
        height: 96px;
        margin-top: -35px;
    }

    .el-customer-mode .coast-profile .cp-identity h2 {
        font-size: 19px;
    }

    .el-customer-mode .coast-profile .cp-panel {
        padding: 18px;
    }

    .el-customer-mode .coast-profile .cp-form-grid {
        grid-template-columns: 1fr;
        gap: 15px;
    }

    .el-customer-mode .coast-profile .cp-field.full {
        grid-column: auto;
    }

    .el-customer-mode .coast-profile .cp-sidebar {
        display: flex;
        flex-direction: column;
    }

    .el-customer-mode .coast-profile .cp-save-panel {
        padding: 18px;
        align-items: stretch;
    }

    .el-customer-mode .coast-profile .cp-save-actions,
    .el-customer-mode .coast-profile .cp-save-actions .cp-btn {
        width: 100%;
    }
}

@media (prefers-reduced-motion: reduce) {
    .el-customer-mode .coast-profile .cp-btn {
        transition: none;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="coast-profile">

    <!-- PAGE HEADER -->

    <header class="cp-header">
        <div>
            <span class="cp-eyebrow">
                MY LIBRARY / ACCOUNT
            </span>

            <h1>My Profile</h1>

            <p>
                Keep your personal information and
                profile picture up to date.
            </p>
        </div>

        <a class="cp-btn"
           href="<%= ResolveUrl("~/CustomerHome.aspx") %>">
            ← Dashboard
        </a>
    </header>

    <!-- PROFILE SUMMARY -->

    <section class="cp-summary"
        aria-label="My account summary">

        <div class="cp-banner"></div>

        <div class="cp-summary-content">

            <div class="cp-avatar-frame">
                <asp:Image
                    ID="imgProfilePreview"
                    runat="server"
                    CssClass="cp-avatar"
                    AlternateText="My profile picture" />
            </div>

            <div class="cp-identity">

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

                <span class="cp-role">
                    Library Member
                </span>

            </div>

        </div>

    </section>

    <!-- PERSONAL INFORMATION AND PROFILE IMAGE -->

    <div class="cp-layout">

        <section class="cp-panel">

            <div class="cp-panel-heading">
                <h2>Personal Information</h2>

                <p>
                    Review and update your account details.
                    Fields marked with an asterisk are required.
                </p>
            </div>

            <div class="cp-form-grid">

                <!-- EMAIL -->

                <div class="cp-field full">

                    <asp:Label runat="server"
                        AssociatedControlID="txtEmail"
                        Text="Email Address *" />

                    <asp:TextBox
                        ID="txtEmail"
                        runat="server"
                        CssClass="cp-input"
                        TextMode="Email"
                        MaxLength="100"
                        autocomplete="email"
                        placeholder="Enter your email address" />

                </div>

                <!-- FIRST NAME -->

                <div class="cp-field">

                    <asp:Label runat="server"
                        AssociatedControlID="txtFirstName"
                        Text="First Name *" />

                    <asp:TextBox
                        ID="txtFirstName"
                        runat="server"
                        CssClass="cp-input"
                        MaxLength="100"
                        autocomplete="given-name"
                        placeholder="First name" />

                </div>

                <!-- MIDDLE NAME -->

                <div class="cp-field">

                    <asp:Label runat="server"
                        AssociatedControlID="txtMiddleName"
                        Text="Middle Name (Optional)" />

                    <asp:TextBox
                        ID="txtMiddleName"
                        runat="server"
                        CssClass="cp-input"
                        MaxLength="100"
                        placeholder="Middle name" />

                </div>

                <!-- LAST NAME -->

                <div class="cp-field">

                    <asp:Label runat="server"
                        AssociatedControlID="txtLastName"
                        Text="Last Name *" />

                    <asp:TextBox
                        ID="txtLastName"
                        runat="server"
                        CssClass="cp-input"
                        MaxLength="100"
                        autocomplete="family-name"
                        placeholder="Last name" />

                </div>

                <!-- GENDER -->

                <div class="cp-field">

                    <asp:Label runat="server"
                        AssociatedControlID="ddlGender"
                        Text="Gender *" />

                    <asp:DropDownList
                        ID="ddlGender"
                        runat="server"
                        CssClass="cp-input" />

                </div>

                <!-- CONTACT -->

                <div class="cp-field full">

                    <asp:Label runat="server"
                        AssociatedControlID="txtContactNumber"
                        Text="Contact Number *" />

                    <asp:TextBox
                        ID="txtContactNumber"
                        runat="server"
                        CssClass="cp-input"
                        MaxLength="30"
                        autocomplete="tel"
                        placeholder="Enter your contact number" />

                </div>

                <!-- ADDRESS -->

                <div class="cp-field full">

                    <asp:Label runat="server"
                        AssociatedControlID="txtAddress"
                        Text="Complete Address *" />

                    <asp:TextBox
                        ID="txtAddress"
                        runat="server"
                        CssClass="cp-input"
                        TextMode="MultiLine"
                        Rows="3"
                        MaxLength="255"
                        placeholder="Enter your complete address" />

                </div>

            </div>

        </section>

        <!-- SIDEBAR -->

        <aside class="cp-sidebar">

            <!-- PROFILE PICTURE -->

            <section class="cp-panel">

                <div class="cp-panel-heading">
                    <h2>Profile Picture</h2>

                    <p>
                        Personalize your library account.
                    </p>
                </div>

                <div class="cp-photo-display">

                    <img
                        id="cpPhotoPreview"
                        class="cp-photo-preview"
                        alt="Selected profile photo preview"
                        src="<%= ResolveUrl("~/Content/Images/default-avatar.svg") %>" />

                </div>

                <asp:Label
                    runat="server"
                    AssociatedControlID="fuProfilePicture"
                    CssClass="cp-upload-label"
                    Text="Choose a New Photo" />

                <asp:FileUpload
                    ID="fuProfilePicture"
                    runat="server"
                    CssClass="cp-file"
                    accept=".jpg,.jpeg,.png,image/jpeg,image/png" />

                <p class="cp-upload-note">
                    JPG or PNG only, up to 2 MB.
                    Leave this field empty to keep
                    your current profile picture.
                </p>

                <p id="cpFileWarning"
                   class="cp-field-help"
                   role="status"
                   aria-live="polite"></p>

            </section>

            <!-- ACCOUNT INFORMATION -->

            <section class="cp-info-panel">

                <h3>About Your Account</h3>

                <p>
                    Your contact details help librarians
                    manage borrowing records and
                    communicate about your reservations.
                </p>

                <p>
                    Updating your profile information
                    does not remove your existing
                    borrowing history.
                </p>

            </section>

        </aside>

    </div>

    <!-- SAVE / LOCAL NOTIFICATION -->

    <section class="cp-save-panel">

        <div>
            <h2>Ready to save your changes?</h2>
            <p>
                Review your details before updating your profile.
            </p>
        </div>

        <div class="cp-save-actions">

            <asp:Button
                ID="btnSave"
                runat="server"
                Text="Save Changes"
                CssClass="cp-btn cp-btn-primary"
                OnClick="btnSave_Click" />

        </div>

    </section>

    <asp:Label
        ID="lblMessage"
        runat="server"
        EnableViewState="false"
        CssClass="el-profile-v2-message"
        role="status"
        aria-live="polite" />

</div>

<script type="text/javascript">
(function () {
    var fileInput = document.getElementById(
        '<%= fuProfilePicture.ClientID %>');

    var preview = document.getElementById(
        'cpPhotoPreview');

    var currentPhoto = document.getElementById(
        '<%= imgProfilePreview.ClientID %>');

    var warning = document.getElementById(
        'cpFileWarning');

    if (!fileInput || !preview) {
        return;
    }

    if (currentPhoto && currentPhoto.src) {
        preview.src = currentPhoto.src;
    }

    fileInput.addEventListener('change', function () {
        warning.textContent = '';

        var file = fileInput.files &&
            fileInput.files.length
            ? fileInput.files[0]
            : null;

        if (!file) {
            if (currentPhoto && currentPhoto.src) {
                preview.src = currentPhoto.src;
            }
            return;
        }

        var validType =
            file.type === 'image/jpeg' ||
            file.type === 'image/png';

        var validSize =
            file.size <= 2 * 1024 * 1024;

        if (!validType || !validSize) {
            warning.textContent =
                'Choose a JPG or PNG image under 2 MB.';

            fileInput.value = '';

            if (currentPhoto && currentPhoto.src) {
                preview.src = currentPhoto.src;
            }
            return;
        }

        var reader = new FileReader();

        reader.onload = function (event) {
            preview.src = event.target.result;
        };

        reader.readAsDataURL(file);
    });
})();
</script>

</asp:Content>
