<%@ Page Title="Home"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Default.aspx.cs"
    Inherits="ELibrary.Default" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

    <style>
        .el-home {
            color: #172b43;
            font-family: inherit;
        }

        .el-home * {
            box-sizing: border-box;
        }

        .el-home a {
            text-decoration: none;
        }

        .el-home-hero {
            position: relative;
            overflow: hidden;
            display: grid;
            grid-template-columns: 1.15fr 0.85fr;
            align-items: center;
            gap: 36px;
            min-height: 490px;
            padding: 64px 60px;
            background: linear-gradient(
                125deg,
                #102c4b 0%,
                #173f67 60%,
                #285e89 100%
            );
            border-radius: 22px;
            color: #fff;
        }

        .el-home-hero::before {
            content: "";
            position: absolute;
            width: 430px;
            height: 430px;
            right: -160px;
            top: -180px;
            border-radius: 50%;
            border: 1px solid rgba(255,255,255,.13);
            box-shadow:
                0 0 0 55px rgba(255,255,255,.025),
                0 0 0 110px rgba(255,255,255,.02);
            pointer-events: none;
        }

        .el-home-copy {
            position: relative;
            z-index: 1;
        }

        .el-home-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            padding: 8px 13px;
            background: rgba(255,255,255,.1);
            border: 1px solid rgba(255,255,255,.17);
            border-radius: 30px;
            font-size: 11px;
            font-weight: 750;
            letter-spacing: .12em;
            text-transform: uppercase;
            color: #dbeaf8;
        }

        .el-home-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #88c8ed;
        }

        .el-home-hero h1 {
            margin: 25px 0 18px;
            max-width: 650px;
            font-size: clamp(36px, 4.4vw, 61px);
            line-height: 1.1;
            letter-spacing: -.045em;
            font-weight: 800;
            color: #fff;
        }

        .el-home-hero h1 span {
            color: #a8d8f5;
        }

        .el-home-hero p {
            max-width: 500px;
            color: #c7d9e9;
            font-size: 15px;
            line-height: 1.85;
            margin: 0;
        }

        .el-home-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 32px;
        }

        .el-home-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            min-height: 48px;
            padding: 13px 22px;
            border-radius: 9px;
            font-size: 13px;
            font-weight: 750;
            transition: transform .2s, background .2s;
        }

        .el-home-btn:hover {
            transform: translateY(-2px);
        }

        .el-home-btn-light {
            background: #fff;
            color: #173f67;
        }

        .el-home-btn-light:hover {
            background: #eaf4fc;
            color: #173f67;
        }

        .el-home-btn-outline {
            background: rgba(255,255,255,.07);
            color: #fff;
            border: 1px solid rgba(255,255,255,.3);
        }

        .el-home-btn-outline:hover {
            background: rgba(255,255,255,.15);
            color: #fff;
        }

        .el-home-visual {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 340px;
        }

        .el-home-book-scene {
            position: relative;
            width: 310px;
            height: 330px;
        }

        .el-home-orbit {
            position: absolute;
            inset: 10px;
            border: 1px solid rgba(255,255,255,.12);
            border-radius: 50%;
        }

        .el-home-orbit::after {
            content: "";
            position: absolute;
            inset: 35px;
            border: 1px dashed rgba(255,255,255,.12);
            border-radius: 50%;
        }

        .el-home-book {
            position: absolute;
            width: 152px;
            height: 210px;
            top: 62px;
            left: 78px;
            border-radius: 7px 13px 13px 7px;
            background: linear-gradient(
                135deg,
                #f4f7fc,
                #d7e8f7
            );
            box-shadow:
                15px 18px 35px rgba(0,0,0,.22),
                inset -8px 0 0 rgba(20,65,110,.1);
            transform: rotate(-10deg);
        }

        .el-home-book::before {
            content: "";
            position: absolute;
            left: 14px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: rgba(21,64,105,.16);
        }

        .el-home-book::after {
            content: "";
            position: absolute;
            width: 70px;
            height: 70px;
            top: 48px;
            left: 40px;
            border: 2px solid #729cc2;
            border-radius: 50%;
        }

        .el-home-book-line {
            position: absolute;
            left: 43px;
            width: 65px;
            height: 5px;
            background: #9cb9d2;
            border-radius: 5px;
        }

        .el-home-book-line.one {
            top: 136px;
        }

        .el-home-book-line.two {
            top: 151px;
            width: 49px;
        }

        .el-home-book-back {
            position: absolute;
            width: 152px;
            height: 210px;
            top: 73px;
            left: 103px;
            border-radius: 7px 13px 13px 7px;
            background: #4d85b3;
            transform: rotate(9deg);
            box-shadow: 10px 18px 30px rgba(0,0,0,.15);
        }

        .el-home-floating {
            position: absolute;
            display: flex;
            align-items: center;
            gap: 9px;
            padding: 11px 14px;
            border: 1px solid rgba(255,255,255,.25);
            background: rgba(255,255,255,.13);
            backdrop-filter: blur(8px);
            border-radius: 11px;
            color: #fff;
            font-size: 12px;
            font-weight: 650;
            box-shadow: 0 10px 25px rgba(0,0,0,.08);
        }

        .el-home-floating.top {
            top: 30px;
            right: -22px;
        }

        .el-home-floating.bottom {
            bottom: 22px;
            left: -25px;
        }

        .el-home-floating svg {
            width: 18px;
            height: 18px;
            stroke: currentColor;
            fill: none;
            stroke-width: 1.8;
        }

        .el-home-features {
            padding: 55px 0 30px;
        }

        .el-home-section-head {
            text-align: center;
            margin-bottom: 28px;
        }

        .el-home-section-head span {
            color: #3976a6;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .12em;
            text-transform: uppercase;
        }

        .el-home-section-head h2 {
            margin: 10px 0;
            color: #172b43;
            font-size: 28px;
            font-weight: 800;
            letter-spacing: -.03em;
        }

        .el-home-section-head p {
            color: #728399;
            font-size: 14px;
        }

        .el-home-feature-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
        }

        .el-home-feature {
            background: #fff;
            border: 1px solid #e4ebf3;
            border-radius: 14px;
            padding: 26px;
            transition: transform .2s, box-shadow .2s;
        }

        .el-home-feature:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 28px rgba(23,43,67,.07);
        }

        .el-home-feature-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 48px;
            height: 48px;
            margin-bottom: 19px;
            background: #eaf3fb;
            color: #2e6d9d;
            border-radius: 12px;
        }

        .el-home-feature-icon svg {
            width: 23px;
            height: 23px;
            fill: none;
            stroke: currentColor;
            stroke-width: 1.8;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .el-home-feature h3 {
            margin: 0 0 10px;
            font-size: 16px;
            font-weight: 750;
        }

        .el-home-feature p {
            margin: 0;
            color: #718096;
            font-size: 13px;
            line-height: 1.8;
        }

        .el-home-bottom {
            margin: 25px 0 10px;
            padding: 28px 34px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            border: 1px solid #e4ebf3;
            border-radius: 14px;
            background: #f7fafc;
        }

        .el-home-bottom h3 {
            font-size: 19px;
            font-weight: 750;
            margin: 0 0 7px;
        }

        .el-home-bottom p {
            font-size: 13px;
            color: #718096;
            margin: 0;
        }

        .el-home-bottom .el-home-btn {
            background: #173f67;
            color: #fff;
            white-space: nowrap;
        }

        .el-home-bottom .el-home-btn:hover {
            background: #285e89;
        }

        @media (max-width: 900px) {
            .el-home-hero {
                grid-template-columns: 1fr;
                padding: 48px 34px;
            }

            .el-home-visual {
                min-height: 270px;
            }

            .el-home-feature-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 600px) {
            .el-home-hero {
                padding: 38px 24px;
                border-radius: 15px;
            }

            .el-home-hero h1 {
                font-size: 36px;
            }

            .el-home-visual {
                display: none;
            }

            .el-home-actions {
                flex-direction: column;
            }

            .el-home-btn {
                width: 100%;
            }

            .el-home-bottom {
                flex-direction: column;
                align-items: stretch;
                padding: 24px;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="el-home">

        <section class="el-home-hero">

            <div class="el-home-copy">

                <div class="el-home-eyebrow">
                    <span class="el-home-dot"></span>
                    Your Digital Library
                </div>

                <h1>
                    A better way to
                    <span>discover, borrow, and read.</span>
                </h1>

                <p>
                    Explore your next great read with E-Library.
                    Browse books, manage borrowings, and stay
                    on top of your library activity—all in one
                    simple, organized space.
                </p>

                <div class="el-home-actions">

                    <a href="<%= ResolveUrl("~/Login.aspx") %>"
                       class="el-home-btn el-home-btn-light">
                        Sign In
                        <span aria-hidden="true">→</span>
                    </a>

                    <a href="<%= ResolveUrl("~/Register.aspx") %>"
                       class="el-home-btn el-home-btn-outline">
                        Create an Account
                    </a>

                </div>

            </div>

            <div class="el-home-visual" aria-hidden="true">

                <div class="el-home-book-scene">

                    <div class="el-home-orbit"></div>

                    <div class="el-home-book-back"></div>

                    <div class="el-home-book">
                        <span class="el-home-book-line one"></span>
                        <span class="el-home-book-line two"></span>
                    </div>

                    <div class="el-home-floating top">
                        <svg viewBox="0 0 24 24">
                            <path d="M4 5h16v14H4z"/>
                            <path d="M8 9h8M8 13h6"/>
                        </svg>
                        Digital Collection
                    </div>

                    <div class="el-home-floating bottom">
                        <svg viewBox="0 0 24 24">
                            <path d="M5 12l5 5L20 7"/>
                        </svg>
                        Easy Book Tracking
                    </div>

                </div>

            </div>

        </section>

        <section class="el-home-features">

            <div class="el-home-section-head">

                <span>Everything in one place</span>

                <h2>Your library, simplified.</h2>

                <p>
                    All the essentials for a smoother borrowing experience.
                </p>

            </div>

            <div class="el-home-feature-grid">

                <div class="el-home-feature">

                    <div class="el-home-feature-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M4 5.5C4 4.7 4.7 4 5.5 4H11v16H5.5A1.5 1.5 0 0 0 4 21z"/>
                            <path d="M20 5.5c0-.8-.7-1.5-1.5-1.5H13v16h5.5A1.5 1.5 0 0 1 20 21z"/>
                            <path d="M12 4v16"/>
                        </svg>
                    </div>

                    <h3>Discover Books</h3>

                    <p>
                        Explore the library catalog and find books
                        that match your interests.
                    </p>

                </div>

                <div class="el-home-feature">

                    <div class="el-home-feature-icon">
                        <svg viewBox="0 0 24 24">
                            <rect x="3" y="5" width="18" height="16" rx="2"/>
                            <path d="M7 3v4M17 3v4M3 10h18"/>
                            <path d="M8 15l2.5 2.5L16 12"/>
                        </svg>
                    </div>

                    <h3>Manage Borrowings</h3>

                    <p>
                        Keep track of borrowed books, due dates,
                        and return information.
                    </p>

                </div>

                <div class="el-home-feature">

                    <div class="el-home-feature-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M5 3h14v18l-3-2-4 2-4-2-3 2z"/>
                            <path d="M9 8h6M9 12h6"/>
                        </svg>
                    </div>

                    <h3>Stay Organized</h3>

                    <p>
                        View your borrowing history and transactions
                        whenever you need them.
                    </p>

                </div>

            </div>

        </section>

        <section class="el-home-bottom">

            <div>
                <h3>Ready to start reading?</h3>
                <p>
                    Create your account and explore what the library offers.
                </p>
            </div>

            <a href="<%= ResolveUrl("~/Register.aspx") %>"
               class="el-home-btn">
                Get Started
                <span aria-hidden="true">→</span>
            </a>

        </section>

    </div>

</asp:Content>