
<%@ Page Title="Login"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Login.aspx.cs"
    Inherits="ELibrary.Login" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* ==========================================
   COASTAL MINIMAL — LOGIN UI-6B
========================================== */

.el-coast-login {
    max-width: 1050px;
    margin: 35px auto 65px;
    color: #123B4A;
}

.el-coast-login * {
    box-sizing: border-box;
}

.el-coast-login .cl-shell {
    display: grid;
    grid-template-columns: .9fr 1.1fr;
    min-height: 580px;
    overflow: hidden;
    background: #FFFFFF;
    border: 1px solid #DCE9EB;
    border-radius: 21px;
    box-shadow: 0 16px 48px rgba(18,59,74,.065);
}

/* INTRO PANEL */

.el-coast-login .cl-intro {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    position: relative;
    overflow: hidden;
    padding: 43px;
    background: linear-gradient(145deg,#D5EAEB,#E9F5F3);
    border-right: 1px solid #D2E7E8;
}

.el-coast-login .cl-intro::after {
    content: "";
    position: absolute;
    right: -120px;
    bottom: -150px;
    width: 350px;
    height: 350px;
    border: 1px solid rgba(22,138,145,.16);
    border-radius: 50%;
    box-shadow: 0 0 0 55px rgba(255,255,255,.18);
    pointer-events: none;
}

.el-coast-login .cl-brand {
    display: flex;
    align-items: center;
    gap: 12px;
    color: #123B4A;
    font-size: 18px;
    font-weight: 850;
}

.el-coast-login .cl-brand-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 44px;
    height: 44px;
    border-radius: 12px;
    background: #123B4A;
    color: #FFFFFF;
    font-size: 22px;
}

.el-coast-login .cl-intro-copy {
    position: relative;
    z-index: 1;
    padding: 45px 0;
}

.el-coast-login .cl-kicker {
    display: block;
    margin-bottom: 15px;
    color: #13787C;
    font-size: 11px;
    font-weight: 850;
    letter-spacing: .14em;
}

.el-coast-login .cl-intro h2 {
    max-width: 360px;
    margin: 0 0 17px;
    color: #123B4A;
    font-size: clamp(29px,3vw,40px);
    font-weight: 850;
    letter-spacing: -.04em;
    line-height: 1.18;
}

.el-coast-login .cl-intro p {
    max-width: 360px;
    margin: 0;
    color: #52737D;
    font-size: 13px;
    line-height: 1.9;
}

.el-coast-login .cl-side-note {
    position: relative;
    z-index: 1;
    color: #547782;
    font-size: 11px;
}

/* SIGN-IN FORM */

.el-coast-login .cl-main {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 54px;
}

.el-coast-login .cl-form {
    width: 100%;
    max-width: 390px;
}

.el-coast-login .cl-form h1 {
    margin: 0 0 10px;
    color: #123B4A;
    font-size: 32px;
    font-weight: 850;
    letter-spacing: -.035em;
}

.el-coast-login .cl-form-description {
    margin: 0 0 30px;
    color: #647F89;
    font-size: 13px;
    line-height: 1.8;
}

.el-coast-login .cl-field {
    margin-bottom: 19px;
}

.el-coast-login .cl-label {
    display: block;
    margin-bottom: 9px;
    color: #375968;
    font-size: 12px;
    font-weight: 750;
}

.el-coast-login .cl-input {
    display: block;
    width: 100%;
    min-height: 49px;
    padding: 12px 14px;
    border: 1px solid #CFE1E4;
    border-radius: 10px;
    background: #F9FCFC;
    color: #123B4A;
    font-size: 13px;
}

.el-coast-login .cl-input:focus {
    outline: none;
    background: #FFFFFF;
    border-color: #168A91;
    box-shadow: 0 0 0 3px rgba(22,138,145,.12);
}

.el-coast-login .cl-submit {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    min-height: 48px;
    margin-top: 6px;
    padding: 12px;
    border: 1px solid #168A91;
    border-radius: 10px;
    background: #168A91;
    color: #FFFFFF;
    font-size: 13px;
    font-weight: 850;
    cursor: pointer;
}

.el-coast-login .cl-submit:hover {
    background: #12757C;
    border-color: #12757C;
}

.el-coast-login .cl-message {
    display: block;
    margin: 14px 0 0;
    font-size: 12px;
    line-height: 1.75;
}

.el-coast-login .cl-message:empty {
    display: none;
}

.el-coast-login .cl-message:not(:empty) {
    padding: 13px 15px;
    border-radius: 9px;
}

.el-coast-login .cl-message.error {
    background: #FFF0EF;
    border: 1px solid #F2D3CF;
    border-left: 4px solid #C34D46;
    color: #9E3E39;
}

.el-coast-login .cl-message.success {
    background: #E9F7F1;
    border: 1px solid #C8E8D7;
    border-left: 4px solid #28845B;
    color: #236747;
}

.el-coast-login .cl-separator {
    display: flex;
    align-items: center;
    gap: 12px;
    margin: 30px 0 22px;
    color: #9BAEB4;
    font-size: 11px;
}

.el-coast-login .cl-separator::before,
.el-coast-login .cl-separator::after {
    content: "";
    flex: 1;
    height: 1px;
    background: #E2EDEE;
}

.el-coast-login .cl-bottom {
    text-align: center;
    color: #647F89;
    font-size: 12px;
}

.el-coast-login .cl-bottom a {
    color: #168A91;
    font-weight: 800;
    text-decoration: none;
}

.el-coast-login .cl-bottom a:hover {
    text-decoration: underline;
}

@media(max-width:850px) {
    .el-coast-login .cl-shell {
        grid-template-columns: 1fr;
    }

    .el-coast-login .cl-intro {
        padding: 28px;
        min-height: 220px;
        border-right: 0;
        border-bottom: 1px solid #D2E7E8;
    }

    .el-coast-login .cl-intro-copy {
        padding: 25px 0 0;
    }

    .el-coast-login .cl-intro h2 {
        font-size: 28px;
    }

    .el-coast-login .cl-side-note {
        display: none;
    }

    .el-coast-login .cl-main {
        padding: 40px 30px;
    }
}

@media(max-width:500px) {
    .el-coast-login {
        margin: 12px auto 30px;
    }

    .el-coast-login .cl-shell {
        border-radius: 14px;
    }

    .el-coast-login .cl-intro {
        padding: 25px;
    }

    .el-coast-login .cl-main {
        padding: 33px 23px;
    }

    .el-coast-login .cl-form h1 {
        font-size: 27px;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="el-coast-login">

    <div class="cl-shell">

        <!-- WELCOME SIDE -->

        <aside class="cl-intro">

            <div class="cl-brand">
                <span class="cl-brand-icon"
                    aria-hidden="true">&#128214;</span>
                ELibrary
            </div>

            <div class="cl-intro-copy">

                <span class="cl-kicker">
                    YOUR READING SPACE
                </span>

                <h2>
                    Welcome back to your library.
                </h2>

                <p>
                    Sign in to discover books,
                    manage your reservations,
                    track due dates, and continue
                    your reading journey.
                </p>

            </div>

            <div class="cl-side-note">
                Discover more. Read more. Learn more.
            </div>

        </aside>

        <!-- LOGIN FORM -->

        <section class="cl-main">

            <div class="cl-form">

                <span class="cl-kicker">
                    WELCOME BACK
                </span>

                <h1>Sign in</h1>

                <p class="cl-form-description">
                    Enter your account details to
                    access your ELibrary workspace.
                </p>

                <asp:Panel
                    ID="pnlLogin"
                    runat="server"
                    DefaultButton="btnLogin">

                    <div class="cl-field">

                        <asp:Label
                            ID="lblEmail"
                            runat="server"
                            AssociatedControlID="txtEmail"
                            CssClass="cl-label"
                            Text="Email Address" />

                        <asp:TextBox
                            ID="txtEmail"
                            runat="server"
                            CssClass="cl-input"
                            TextMode="Email"
                            MaxLength="100"
                            autocomplete="username"
                            placeholder="you@example.com" />

                    </div>

                    <div class="cl-field">

                        <asp:Label
                            ID="lblPassword"
                            runat="server"
                            AssociatedControlID="txtPassword"
                            CssClass="cl-label"
                            Text="Password" />

                        <asp:TextBox
                            ID="txtPassword"
                            runat="server"
                            CssClass="cl-input"
                            TextMode="Password"
                            autocomplete="current-password"
                            placeholder="Enter your password" />

                    </div>

                    <asp:Button
                        ID="btnLogin"
                        runat="server"
                        Text="Sign In"
                        CssClass="cl-submit"
                        OnClick="btnLogin_Click" />

                </asp:Panel>

                <!-- CONTEXTUAL LOGIN RESULT -->

                <asp:Label
                    ID="lblMessage"
                    runat="server"
                    CssClass="cl-message"
                    EnableViewState="false"
                    role="status"
                    aria-live="polite" />

                <div class="cl-separator">
                    New to ELibrary?
                </div>

                <div class="cl-bottom">
                    Don't have an account?
                    <a href="<%= ResolveUrl("~/Register.aspx") %>">
                        Create an account
                    </a>
                </div>

            </div>

        </section>

    </div>

</div>

<script type="text/javascript">
(function () {
    var message = document.getElementById(
        '<%= lblMessage.ClientID %>');

    if (!message || !message.textContent.trim()) {
        return;
    }

    var isRegistrationSuccess =
        new URLSearchParams(window.location.search)
            .get('registered') === '1' &&
        message.textContent.indexOf(
            'Registration successful.') !== -1;

    message.classList.add(
        isRegistrationSuccess ? 'success' : 'error');
})();
</script>

</asp:Content>
