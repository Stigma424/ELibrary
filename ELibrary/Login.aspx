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
        .el-login {
            max-width: 1050px;
            margin: 30px auto 45px;
            color: #172b43;
        }

        .el-login * {
            box-sizing: border-box;
        }

        .el-login-shell {
            display: grid;
            grid-template-columns: .9fr 1.1fr;
            overflow: hidden;
            min-height: 570px;
            background: #fff;
            border: 1px solid #e4ebf3;
            border-radius: 20px;
            box-shadow: 0 18px 55px rgba(20,48,79,.07);
        }

        .el-login-side {
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 46px;
            background: linear-gradient(
                145deg, #102c4b, #245780
            );
            color: #fff;
        }

        .el-login-side::after {
            content: "";
            position: absolute;
            width: 350px;
            height: 350px;
            right: -190px;
            bottom: -170px;
            border: 1px solid rgba(255,255,255,.17);
            border-radius: 50%;
            box-shadow:
                0 0 0 60px rgba(255,255,255,.025),
                0 0 0 120px rgba(255,255,255,.02);
        }

        .el-login-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 18px;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .el-login-brand-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 43px;
            height: 43px;
            border: 1px solid rgba(255,255,255,.23);
            background: rgba(255,255,255,.12);
            border-radius: 12px;
        }

        .el-login-brand-icon svg {
            width: 23px;
            height: 23px;
            stroke: currentColor;
            fill: none;
            stroke-width: 1.8;
        }

        .el-login-side-copy {
            position: relative;
            z-index: 1;
            padding: 35px 0;
        }

        .el-login-kicker {
            display: block;
            margin-bottom: 16px;
            color: #a8d8f5;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .15em;
            text-transform: uppercase;
        }

        .el-login-side h2 {
            margin: 0 0 18px;
            max-width: 350px;
            color: #fff;
            font-size: 38px;
            line-height: 1.16;
            letter-spacing: -.04em;
            font-weight: 800;
        }

        .el-login-side p {
            max-width: 340px;
            margin: 0;
            color: #c8dceb;
            font-size: 14px;
            line-height: 1.85;
        }

        .el-login-side-footer {
            position: relative;
            z-index: 1;
            font-size: 12px;
            color: #b8d1e5;
        }

        .el-login-main {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 55px 58px;
        }

        .el-login-form {
            width: 100%;
            max-width: 385px;
        }

        .el-login-form-kicker {
            display: block;
            color: #3976a6;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .13em;
            text-transform: uppercase;
            margin-bottom: 12px;
        }

        .el-login-form h1 {
            margin: 0 0 9px;
            color: #172b43;
            font-size: 30px;
            font-weight: 800;
            letter-spacing: -.035em;
        }

        .el-login-form-intro {
            margin: 0 0 32px;
            color: #718096;
            font-size: 14px;
            line-height: 1.7;
        }

        .el-login-field {
            margin-bottom: 21px;
        }

        .el-login-label {
            display: block;
            margin-bottom: 9px;
            color: #334c67;
            font-size: 13px;
            font-weight: 750;
        }

        .el-login-input {
            display: block;
            width: 100%;
            height: 49px;
            padding: 12px 14px;
            border: 1px solid #dbe5ef;
            border-radius: 9px;
            background: #fafcfe;
            color: #172b43;
            font-size: 14px;
            transition: border-color .2s, box-shadow .2s;
        }

        .el-login-input:focus {
            outline: none;
            background: #fff;
            border-color: #3976a6;
            box-shadow: 0 0 0 3px rgba(57,118,166,.12);
        }

        .el-login-input::placeholder {
            color: #a1afbe;
        }

        .el-login-submit {
            width: 100%;
            min-height: 49px;
            margin-top: 7px;
            border: 0;
            border-radius: 9px;
            background: #173f67;
            color: #fff;
            font-size: 14px;
            font-weight: 750;
            cursor: pointer;
            transition: background .2s, transform .2s;
        }

        .el-login-submit:hover {
            background: #285e89;
            transform: translateY(-1px);
        }

        .el-login-message {
            display: block;
            margin-top: 17px;
            color: #b34242;
            font-size: 13px;
            line-height: 1.6;
        }

        .el-login-message:empty {
            display: none;
        }

        .el-login-divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 29px 0 23px;
            color: #99a7b6;
            font-size: 12px;
        }

        .el-login-divider::before,
        .el-login-divider::after {
            content: "";
            height: 1px;
            flex: 1;
            background: #e6edf4;
        }

        .el-login-register {
            text-align: center;
            font-size: 13px;
            color: #718096;
        }

        .el-login-register a {
            color: #2e6d9d;
            font-weight: 750;
            text-decoration: none;
        }

        .el-login-register a:hover {
            text-decoration: underline;
        }

        @media (max-width: 850px) {
            .el-login-shell {
                grid-template-columns: 1fr;
            }

            .el-login-side {
                min-height: 230px;
                padding: 30px;
            }

            .el-login-side-copy {
                padding: 24px 0 8px;
            }

            .el-login-side h2 {
                font-size: 28px;
            }

            .el-login-side-footer {
                display: none;
            }

            .el-login-main {
                padding: 42px 28px;
            }
        }

        @media (max-width: 500px) {
            .el-login {
                margin: 10px auto 25px;
            }

            .el-login-shell {
                border-radius: 13px;
            }

            .el-login-side {
                padding: 25px;
            }

            .el-login-main {
                padding: 35px 23px;
            }

            .el-login-form h1 {
                font-size: 26px;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="el-login">

        <div class="el-login-shell">

            <div class="el-login-side">

                <div class="el-login-brand">

                    <span class="el-login-brand-icon">
                        <svg viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M4 5h7v15H4z"/>
                            <path d="M13 5h7v15h-7z"/>
                            <path d="M11 7l2-2M11 20l2-2"/>
                        </svg>
                    </span>

                    E-Library

                </div>

                <div class="el-login-side-copy">

                    <span class="el-login-kicker">
                        Your reading space
                    </span>

                    <h2>
                        Your next chapter starts here.
                    </h2>

                    <p>
                        Sign in to explore the library, manage
                        your borrowed books, and stay connected
                        to your reading journey.
                    </p>

                </div>

                <div class="el-login-side-footer">
                    Discover more. Read more. Learn more.
                </div>

            </div>

            <div class="el-login-main">

                <div class="el-login-form">

                    <span class="el-login-form-kicker">
                        Welcome back
                    </span>

                    <h1>Sign in</h1>

                    <p class="el-login-form-intro">
                        Enter your account details to continue
                        to your library.
                    </p>

                    <asp:Panel
                        ID="pnlLogin"
                        runat="server"
                        DefaultButton="btnLogin">

                        <div class="el-login-field">

                            <asp:Label
                                ID="lblEmail"
                                runat="server"
                                AssociatedControlID="txtEmail"
                                CssClass="el-login-label"
                                Text="Email Address" />

                            <asp:TextBox
                                ID="txtEmail"
                                runat="server"
                                CssClass="el-login-input"
                                TextMode="Email"
                                MaxLength="100"
                                placeholder="you@example.com"
                                autocomplete="username" />

                        </div>

                        <div class="el-login-field">

                            <asp:Label
                                ID="lblPassword"
                                runat="server"
                                AssociatedControlID="txtPassword"
                                CssClass="el-login-label"
                                Text="Password" />

                            <asp:TextBox
                                ID="txtPassword"
                                runat="server"
                                CssClass="el-login-input"
                                TextMode="Password"
                                placeholder="Enter your password"
                                autocomplete="current-password" />

                        </div>

                        <asp:Button
                            ID="btnLogin"
                            runat="server"
                            Text="Sign In"
                            CssClass="el-login-submit"
                            OnClick="btnLogin_Click" />

                    </asp:Panel>

                    <asp:Label
                        ID="lblMessage"
                        runat="server"
                        CssClass="el-login-message"
                        EnableViewState="false" />

                    <div class="el-login-divider">
                        New to E-Library?
                    </div>

                    <div class="el-login-register">
                        Don't have an account?
                        <a href="<%= ResolveUrl("~/Register.aspx") %>">
                            Create an account
                        </a>
                    </div>

                </div>

            </div>

        </div>

    </div>

</asp:Content>