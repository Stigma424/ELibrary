
<%@ Page Title="Register"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Register.aspx.cs"
    Inherits="ELibrary.Register" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* ==========================================
   COASTAL MINIMAL — REGISTRATION UI-6C
========================================== */

.el-coast-register {
    max-width: 1080px;
    margin: 35px auto 65px;
    color: #123B4A;
}

.el-coast-register *,
.el-coast-register *::before,
.el-coast-register *::after {
    box-sizing: border-box;
}

.el-coast-register .cr-shell {
    display: grid;
    grid-template-columns: minmax(235px,.68fr) minmax(0,1.32fr);
    overflow: hidden;
    background: #FFFFFF;
    border: 1px solid #DCE9EB;
    border-radius: 21px;
    box-shadow: 0 16px 48px rgba(18,59,74,.055);
}

/* SIDE PANEL */

.el-coast-register .cr-side {
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    gap: 28px;
    overflow: hidden;
    padding: 35px 30px;
    background: linear-gradient(145deg,#D5EAEB,#EAF6F3);
    border-right: 1px solid #D2E7E8;
}

.el-coast-register .cr-side::after {
    content: "";
    position: absolute;
    bottom: -120px;
    right: -165px;
    width: 330px;
    height: 330px;
    border: 1px solid rgba(22,138,145,.16);
    border-radius: 50%;
    pointer-events: none;
}

.el-coast-register .cr-brand {
    display: flex;
    align-items: center;
    gap: 12px;
    color: #123B4A;
    font-size: 18px;
    font-weight: 850;
}

.el-coast-register .cr-brand-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 43px;
    height: 43px;
    border-radius: 11px;
    background: #123B4A;
    color: #FFFFFF;
    font-size: 21px;
}

.el-coast-register .cr-side-copy {
    position: relative;
    z-index: 1;
    padding: 55px 0;
}

.el-coast-register .cr-kicker {
    display: block;
    margin-bottom: 14px;
    color: #13787C;
    font-size: 10px;
    font-weight: 850;
    letter-spacing: .14em;
}

.el-coast-register .cr-side h2 {
    margin: 0 0 17px;
    color: #123B4A;
    font-size: clamp(25px,3vw,34px);
    font-weight: 850;
    line-height: 1.2;
    letter-spacing: -.035em;
}

.el-coast-register .cr-side p {
    margin: 0;
    color: #52737D;
    font-size: 12px;
    line-height: 1.9;
}

.el-coast-register .cr-side-note {
    position: relative;
    z-index: 1;
    color: #557783;
    font-size: 11px;
    line-height: 1.8;
}

/* FORM */

.el-coast-register .cr-main {
    padding: 39px 44px;
    min-width: 0;
}

.el-coast-register .cr-main h1 {
    margin: 0 0 9px;
    color: #123B4A;
    font-size: 30px;
    font-weight: 850;
    letter-spacing: -.035em;
}

.el-coast-register .cr-intro {
    margin: 0 0 27px;
    color: #647F89;
    font-size: 12px;
    line-height: 1.8;
}

.el-coast-register .cr-section {
    padding-top: 22px;
    margin-top: 22px;
    border-top: 1px solid #E5EFF0;
}

.el-coast-register .cr-section-title {
    display: flex;
    align-items: center;
    gap: 11px;
    margin-bottom: 19px;
    color: #123B4A;
    font-size: 14px;
    font-weight: 850;
}

.el-coast-register .cr-step {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 29px;
    height: 29px;
    border-radius: 9px;
    background: #EAF6F6;
    color: #13787C;
    font-size: 11px;
    font-weight: 850;
}

.el-coast-register .cr-grid {
    display: grid;
    grid-template-columns: repeat(2,minmax(0,1fr));
    gap: 16px;
}

.el-coast-register .cr-field {
    min-width: 0;
}

.el-coast-register .cr-field.full {
    grid-column: 1 / -1;
}

.el-coast-register .cr-label {
    display: block;
    margin-bottom: 8px;
    color: #375968;
    font-size: 12px;
    font-weight: 750;
}

.el-coast-register .cr-input {
    display: block;
    width: 100%;
    min-height: 45px;
    padding: 11px 13px;
    border: 1px solid #CFE1E4;
    border-radius: 9px;
    background: #F9FCFC;
    color: #123B4A;
    font-size: 12px;
    font-family: inherit;
}

.el-coast-register .cr-input:focus {
    outline: none;
    background: #FFFFFF;
    border-color: #168A91;
    box-shadow: 0 0 0 3px rgba(22,138,145,.12);
}

.el-coast-register textarea.cr-input {
    min-height: 95px;
    resize: vertical;
}

.el-coast-register .cr-help {
    display: block;
    margin-top: 7px;
    color: #647F89;
    font-size: 11px;
    line-height: 1.7;
}

.el-coast-register .cr-submit {
    width: 100%;
    min-height: 48px;
    margin-top: 27px;
    padding: 12px;
    border: 1px solid #168A91;
    border-radius: 10px;
    background: #168A91;
    color: #FFFFFF;
    font-size: 13px;
    font-weight: 850;
    cursor: pointer;
}

.el-coast-register .cr-submit:hover {
    background: #12757C;
    border-color: #12757C;
}

.el-coast-register .cr-message {
    display: block;
    margin-top: 15px;
    color: #9E3E39;
    font-size: 12px;
    line-height: 1.75;
}

.el-coast-register .cr-message:not(:empty) {
    padding: 13px 15px;
    border: 1px solid #F2D3CF;
    border-left: 4px solid #C34D46;
    border-radius: 9px;
    background: #FFF0EF;
}

.el-coast-register .cr-message:empty {
    display: none;
}

.el-coast-register .cr-login {
    margin-top: 23px;
    padding-top: 20px;
    border-top: 1px solid #E5EFF0;
    color: #647F89;
    font-size: 12px;
    text-align: center;
}

.el-coast-register .cr-login a {
    color: #168A91;
    font-weight: 800;
    text-decoration: none;
}

.el-coast-register .cr-login a:hover {
    text-decoration: underline;
}

@media(max-width:850px) {
    .el-coast-register .cr-shell {
        grid-template-columns: 1fr;
    }

    .el-coast-register .cr-side {
        padding: 27px;
        border-right: 0;
        border-bottom: 1px solid #D2E7E8;
    }

    .el-coast-register .cr-side-copy {
        padding: 20px 0 0;
    }

    .el-coast-register .cr-side h2 {
        font-size: 26px;
    }

    .el-coast-register .cr-side-note {
        display: none;
    }

    .el-coast-register .cr-main {
        padding: 34px 29px;
    }
}

@media(max-width:550px) {
    .el-coast-register {
        margin: 12px auto 30px;
    }

    .el-coast-register .cr-shell {
        border-radius: 14px;
    }

    .el-coast-register .cr-main {
        padding: 28px 21px;
    }

    .el-coast-register .cr-main h1 {
        font-size: 26px;
    }

    .el-coast-register .cr-grid {
        grid-template-columns: 1fr;
        gap: 14px;
    }

    .el-coast-register .cr-field.full {
        grid-column: auto;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="el-coast-register">

    <div class="cr-shell">

        <!-- BRAND / INTRODUCTION -->

        <aside class="cr-side">

            <div class="cr-brand">
                <span class="cr-brand-icon"
                    aria-hidden="true">&#128214;</span>
                ELibrary
            </div>

            <div class="cr-side-copy">

                <span class="cr-kicker">
                    JOIN OUR LIBRARY
                </span>

                <h2>
                    Your next chapter starts here.
                </h2>

                <p>
                    Create your ELibrary account
                    to reserve books, track your
                    borrowing activity, and discover
                    your next great read.
                </p>

            </div>

            <div class="cr-side-note">
                One account. Your entire library experience.
            </div>

        </aside>

        <!-- REGISTRATION FORM -->

        <section class="cr-main">

            <span class="cr-kicker">
                GET STARTED
            </span>

            <h1>Create your account</h1>

            <p class="cr-intro">
                Fill in your information below.
                Fields marked with an asterisk are required.
            </p>

            <asp:Panel
                ID="pnlRegister"
                runat="server"
                DefaultButton="btnRegister">

                <!-- PERSONAL INFORMATION -->

                <section class="cr-section">

                    <h2 class="cr-section-title">
                        <span class="cr-step">01</span>
                        Personal Information
                    </h2>

                    <div class="cr-grid">

                        <div class="cr-field">

                            <asp:Label
                                runat="server"
                                AssociatedControlID="txtFirstName"
                                CssClass="cr-label"
                                Text="First Name *" />

                            <asp:TextBox
                                ID="txtFirstName"
                                runat="server"
                                CssClass="cr-input"
                                MaxLength="100"
                                autocomplete="given-name"
                                placeholder="First name" />

                        </div>

                        <div class="cr-field">

                            <asp:Label
                                runat="server"
                                AssociatedControlID="txtMiddleName"
                                CssClass="cr-label"
                                Text="Middle Name (Optional)" />

                            <asp:TextBox
                                ID="txtMiddleName"
                                runat="server"
                                CssClass="cr-input"
                                MaxLength="100"
                                placeholder="Middle name" />

                        </div>

                        <div class="cr-field">

                            <asp:Label
                                runat="server"
                                AssociatedControlID="txtLastName"
                                CssClass="cr-label"
                                Text="Last Name *" />

                            <asp:TextBox
                                ID="txtLastName"
                                runat="server"
                                CssClass="cr-input"
                                MaxLength="100"
                                autocomplete="family-name"
                                placeholder="Last name" />

                        </div>

                        <div class="cr-field">

                            <asp:Label
                                runat="server"
                                AssociatedControlID="ddlGender"
                                CssClass="cr-label"
                                Text="Gender *" />

                            <asp:DropDownList
                                ID="ddlGender"
                                runat="server"
                                CssClass="cr-input" />

                        </div>

                    </div>

                </section>

                <!-- ACCOUNT INFORMATION -->

                <section class="cr-section">

                    <h2 class="cr-section-title">
                        <span class="cr-step">02</span>
                        Account Information
                    </h2>

                    <div class="cr-grid">

                        <div class="cr-field full">

                            <asp:Label
                                runat="server"
                                AssociatedControlID="txtEmail"
                                CssClass="cr-label"
                                Text="Email Address *" />

                            <asp:TextBox
                                ID="txtEmail"
                                runat="server"
                                CssClass="cr-input"
                                TextMode="Email"
                                MaxLength="100"
                                autocomplete="email"
                                placeholder="you@example.com" />

                        </div>

                        <div class="cr-field">

                            <asp:Label
                                runat="server"
                                AssociatedControlID="txtPassword"
                                CssClass="cr-label"
                                Text="Password *" />

                            <asp:TextBox
                                ID="txtPassword"
                                runat="server"
                                CssClass="cr-input"
                                TextMode="Password"
                                autocomplete="new-password"
                                placeholder="Create a password" />

                        </div>

                        <div class="cr-field">

                            <asp:Label
                                runat="server"
                                AssociatedControlID="txtConfirmPassword"
                                CssClass="cr-label"
                                Text="Confirm Password *" />

                            <asp:TextBox
                                ID="txtConfirmPassword"
                                runat="server"
                                CssClass="cr-input"
                                TextMode="Password"
                                autocomplete="new-password"
                                placeholder="Confirm password" />

                        </div>

                    </div>

                </section>

                <!-- CONTACT INFORMATION -->

                <section class="cr-section">

                    <h2 class="cr-section-title">
                        <span class="cr-step">03</span>
                        Contact Information
                    </h2>

                    <div class="cr-grid">

                        <div class="cr-field full">

                            <asp:Label
                                runat="server"
                                AssociatedControlID="txtAddress"
                                CssClass="cr-label"
                                Text="Complete Address *" />

                            <asp:TextBox
                                ID="txtAddress"
                                runat="server"
                                CssClass="cr-input"
                                TextMode="MultiLine"
                                Rows="3"
                                MaxLength="255"
                                placeholder="Enter your complete address" />

                        </div>

                        <div class="cr-field full">

                            <asp:Label
                                runat="server"
                                AssociatedControlID="txtContactNumber"
                                CssClass="cr-label"
                                Text="Contact Number *" />

                            <asp:TextBox
                                ID="txtContactNumber"
                                runat="server"
                                CssClass="cr-input"
                                MaxLength="30"
                                autocomplete="tel"
                                placeholder="Enter your contact number" />

                            <span class="cr-help">
                                Provide a number where
                                library staff can reach you.
                            </span>

                        </div>

                    </div>

                </section>

                <!-- REGISTER ACTION -->

                <asp:Button
                    ID="btnRegister"
                    runat="server"
                    Text="Create Account"
                    CssClass="cr-submit"
                    OnClick="btnRegister_Click" />

            </asp:Panel>

            <!-- LOCAL VALIDATION MESSAGE -->

            <asp:Label
                ID="lblMessage"
                runat="server"
                CssClass="cr-message"
                EnableViewState="false"
                role="alert" />

            <div class="cr-login">
                Already have an account?
                <a href="<%= ResolveUrl("~/Login.aspx") %>">
                    Sign in here
                </a>
            </div>

        </section>

    </div>

</div>

</asp:Content>
