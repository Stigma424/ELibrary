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
        .el-register {
            max-width: 1000px;
            margin: 30px auto 50px;
            color: #172b43;
        }

        .el-register * {
            box-sizing: border-box;
        }

        .el-register-shell {
            display: grid;
            grid-template-columns: 260px minmax(0, 1fr);
            overflow: hidden;
            background: #fff;
            border: 1px solid #e4ebf3;
            border-radius: 19px;
            box-shadow: 0 18px 55px rgba(20,48,79,.06);
        }

        .el-register-side {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 35px 28px;
            background: linear-gradient(
                155deg, #102c4b, #245780
            );
            color: #fff;
        }

        .el-register-brand {
            display: flex;
            align-items: center;
            gap: 11px;
            font-size: 17px;
            font-weight: 800;
        }

        .el-register-brand-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 42px;
            height: 42px;
            border: 1px solid rgba(255,255,255,.23);
            background: rgba(255,255,255,.12);
            border-radius: 11px;
        }

        .el-register-brand-icon svg {
            width: 22px;
            height: 22px;
            stroke: currentColor;
            fill: none;
            stroke-width: 1.8;
        }

        .el-register-side-content {
            padding: 55px 0;
        }

        .el-register-kicker {
            color: #a8d8f5;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .13em;
            text-transform: uppercase;
        }

        .el-register-side h2 {
            margin: 15px 0;
            color: #fff;
            font-size: 29px;
            line-height: 1.2;
            font-weight: 800;
            letter-spacing: -.035em;
        }

        .el-register-side p {
            margin: 0;
            color: #c7d9e9;
            font-size: 13px;
            line-height: 1.85;
        }

        .el-register-side-note {
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,.16);
            color: #c7d9e9;
            font-size: 12px;
            line-height: 1.8;
        }

        .el-register-main {
            padding: 40px 45px;
        }

        .el-register-main-kicker {
            display: block;
            color: #3976a6;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .13em;
            text-transform: uppercase;
            margin-bottom: 10px;
        }

        .el-register-main h1 {
            margin: 0 0 9px;
            font-size: 29px;
            font-weight: 800;
            letter-spacing: -.035em;
        }

        .el-register-intro {
            margin: 0 0 29px;
            color: #718096;
            font-size: 13px;
            line-height: 1.75;
        }

        .el-register-section {
            margin-top: 25px;
            padding-top: 22px;
            border-top: 1px solid #e9eef4;
        }

        .el-register-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 19px;
            color: #172b43;
            font-size: 14px;
            font-weight: 800;
        }

        .el-register-step {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 25px;
            height: 25px;
            border-radius: 7px;
            background: #eaf3fb;
            color: #2e6d9d;
            font-size: 11px;
            font-weight: 800;
        }

        .el-register-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .el-register-field {
            min-width: 0;
        }

        .el-register-field.full {
            grid-column: 1 / -1;
        }

        .el-register-label {
            display: block;
            margin-bottom: 8px;
            color: #334c67;
            font-size: 12px;
            font-weight: 750;
        }

        .el-register-input {
            display: block;
            width: 100%;
            min-height: 45px;
            padding: 11px 13px;
            border: 1px solid #dbe5ef;
            border-radius: 8px;
            background: #fafcfe;
            color: #172b43;
            font-size: 13px;
            font-family: inherit;
            transition: border-color .2s, box-shadow .2s;
        }

        .el-register-input:focus {
            outline: none;
            background: #fff;
            border-color: #3976a6;
            box-shadow: 0 0 0 3px rgba(57,118,166,.12);
        }

        .el-register-input::placeholder {
            color: #a1afbe;
        }

        .el-register textarea.el-register-input {
            min-height: 95px;
            resize: vertical;
        }

        .el-register-help {
            display: block;
            margin-top: 7px;
            color: #91a0b1;
            font-size: 11px;
            line-height: 1.5;
        }

        .el-register-submit {
            width: 100%;
            min-height: 49px;
            margin-top: 28px;
            border: 0;
            border-radius: 9px;
            background: #173f67;
            color: #fff;
            font-size: 14px;
            font-weight: 750;
            cursor: pointer;
            transition: background .2s, transform .2s;
        }

        .el-register-submit:hover {
            background: #285e89;
            transform: translateY(-1px);
        }

        .el-register-message {
            display: block;
            margin-top: 15px;
            color: #b34242;
            font-size: 13px;
            line-height: 1.6;
        }

        .el-register-message:empty {
            display: none;
        }

        .el-register-login {
            margin-top: 24px;
            padding-top: 20px;
            border-top: 1px solid #e9eef4;
            text-align: center;
            color: #718096;
            font-size: 13px;
        }

        .el-register-login a {
            color: #2e6d9d;
            font-weight: 750;
            text-decoration: none;
        }

        .el-register-login a:hover {
            text-decoration: underline;
        }

        @media (max-width: 850px) {
            .el-register-shell {
                grid-template-columns: 1fr;
            }

            .el-register-side {
                padding: 28px;
            }

            .el-register-side-content {
                padding: 24px 0 0;
            }

            .el-register-side h2 {
                font-size: 25px;
            }

            .el-register-side-note {
                display: none;
            }

            .el-register-main {
                padding: 35px 28px;
            }
        }

        @media (max-width: 550px) {
            .el-register {
                margin: 10px auto 25px;
            }

            .el-register-shell {
                border-radius: 13px;
            }

            .el-register-main {
                padding: 28px 21px;
            }

            .el-register-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .el-register-field.full {
                grid-column: auto;
            }

            .el-register-main h1 {
                font-size: 25px;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="el-register">

        <div class="el-register-shell">

            <aside class="el-register-side">

                <div class="el-register-brand">

                    <span class="el-register-brand-icon">
                        <svg viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M4 5h7v15H4z"/>
                            <path d="M13 5h7v15h-7z"/>
                            <path d="M11 7l2-2M11 20l2-2"/>
                        </svg>
                    </span>

                    E-Library

                </div>

                <div class="el-register-side-content">

                    <span class="el-register-kicker">
                        Join our library
                    </span>

                    <h2>
                        A world of books awaits.
                    </h2>

                    <p>
                        Create your account to explore the
                        collection, borrow books, and manage
                        your library activity with ease.
                    </p>

                </div>

                <div class="el-register-side-note">
                    One account. Your entire library experience.
                </div>

            </aside>

            <main class="el-register-main">

                <span class="el-register-main-kicker">
                    Get started
                </span>

                <h1>Create your account</h1>

                <p class="el-register-intro">
                    Fill in your details below to become a member
                    of E-Library.
                </p>

                <asp:Panel
                    ID="pnlRegister"
                    runat="server"
                    DefaultButton="btnRegister">

                    <!-- PERSONAL INFORMATION -->

                    <div class="el-register-section">

                        <div class="el-register-section-title">
                            <span class="el-register-step">01</span>
                            Personal Information
                        </div>

                        <div class="el-register-grid">

                            <div class="el-register-field">

                                <asp:Label
                                    runat="server"
                                    AssociatedControlID="txtFirstName"
                                    CssClass="el-register-label"
                                    Text="First Name *" />

                                <asp:TextBox
                                    ID="txtFirstName"
                                    runat="server"
                                    CssClass="el-register-input"
                                    MaxLength="100"
                                    placeholder="First name" />

                            </div>

                            <div class="el-register-field">

                                <asp:Label
                                    runat="server"
                                    AssociatedControlID="txtMiddleName"
                                    CssClass="el-register-label"
                                    Text="Middle Name (Optional)" />

                                <asp:TextBox
                                    ID="txtMiddleName"
                                    runat="server"
                                    CssClass="el-register-input"
                                    MaxLength="100"
                                    placeholder="Middle name" />

                            </div>

                            <div class="el-register-field">

                                <asp:Label
                                    runat="server"
                                    AssociatedControlID="txtLastName"
                                    CssClass="el-register-label"
                                    Text="Last Name *" />

                                <asp:TextBox
                                    ID="txtLastName"
                                    runat="server"
                                    CssClass="el-register-input"
                                    MaxLength="100"
                                    placeholder="Last name" />

                            </div>

                            <div class="el-register-field">

                                <asp:Label
                                    runat="server"
                                    AssociatedControlID="ddlGender"
                                    CssClass="el-register-label"
                                    Text="Gender *" />

                                <asp:DropDownList
                                    ID="ddlGender"
                                    runat="server"
                                    CssClass="el-register-input" />

                            </div>

                        </div>

                    </div>

                    <!-- ACCOUNT INFORMATION -->

                    <div class="el-register-section">

                        <div class="el-register-section-title">
                            <span class="el-register-step">02</span>
                            Account Information
                        </div>

                        <div class="el-register-grid">

                            <div class="el-register-field full">

                                <asp:Label
                                    runat="server"
                                    AssociatedControlID="txtEmail"
                                    CssClass="el-register-label"
                                    Text="Email Address *" />

                                <asp:TextBox
                                    ID="txtEmail"
                                    runat="server"
                                    CssClass="el-register-input"
                                    TextMode="Email"
                                    MaxLength="100"
                                    placeholder="you@example.com"
                                    autocomplete="email" />

                            </div>

                            <div class="el-register-field">

                                <asp:Label
                                    runat="server"
                                    AssociatedControlID="txtPassword"
                                    CssClass="el-register-label"
                                    Text="Password *" />

                                <asp:TextBox
                                    ID="txtPassword"
                                    runat="server"
                                    CssClass="el-register-input"
                                    TextMode="Password"
                                    placeholder="Create a password"
                                    autocomplete="new-password" />

                            </div>

                            <div class="el-register-field">

                                <asp:Label
                                    runat="server"
                                    AssociatedControlID="txtConfirmPassword"
                                    CssClass="el-register-label"
                                    Text="Confirm Password *" />

                                <asp:TextBox
                                    ID="txtConfirmPassword"
                                    runat="server"
                                    CssClass="el-register-input"
                                    TextMode="Password"
                                    placeholder="Confirm password"
                                    autocomplete="new-password" />

                            </div>

                        </div>

                    </div>

                    <!-- CONTACT INFORMATION -->

                    <div class="el-register-section">

                        <div class="el-register-section-title">
                            <span class="el-register-step">03</span>
                            Contact Information
                        </div>

                        <div class="el-register-grid">

                            <div class="el-register-field full">

                                <asp:Label
                                    runat="server"
                                    AssociatedControlID="txtAddress"
                                    CssClass="el-register-label"
                                    Text="Address *" />

                                <asp:TextBox
                                    ID="txtAddress"
                                    runat="server"
                                    CssClass="el-register-input"
                                    TextMode="MultiLine"
                                    Rows="3"
                                    MaxLength="255"
                                    placeholder="Enter your complete address" />

                            </div>

                            <div class="el-register-field full">

                                <asp:Label
                                    runat="server"
                                    AssociatedControlID="txtContactNumber"
                                    CssClass="el-register-label"
                                    Text="Contact Number *" />

                                <asp:TextBox
                                    ID="txtContactNumber"
                                    runat="server"
                                    CssClass="el-register-input"
                                    MaxLength="30"
                                    placeholder="Enter your contact number"
                                    autocomplete="tel" />

                                <span class="el-register-help">
                                    Provide a contact number where the
                                    library can reach you.
                                </span>

                            </div>

                        </div>

                    </div>

                    <asp:Button
                        ID="btnRegister"
                        runat="server"
                        Text="Create Account"
                        CssClass="el-register-submit"
                        OnClick="btnRegister_Click" />

                </asp:Panel>

                <asp:Label
                    ID="lblMessage"
                    runat="server"
                    CssClass="el-register-message"
                    EnableViewState="false" />

                <div class="el-register-login">
                    Already have an account?
                    <a href="<%= ResolveUrl("~/Login.aspx") %>">
                        Sign in here
                    </a>
                </div>

            </main>

        </div>

    </div>

</asp:Content>