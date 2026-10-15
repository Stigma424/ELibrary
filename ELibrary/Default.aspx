
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
/* ==========================================
   INTERNSHIPELIB — COASTAL MINIMAL
   PUBLIC LANDING PAGE UI-6A
========================================== */

.el-public-coast {
    --pc-ink: #123B4A;
    --pc-teal: #168A91;
    --pc-teal-dark: #12757C;
    --pc-muted: #647F89;
    --pc-border: #DCE9EB;

    display: flex;
    flex-direction: column;
    gap: 66px;
    min-width: 0;
    width: 100%;
    padding: 24px 0 55px;
    color: var(--pc-ink);
}

.el-public-coast *,
.el-public-coast *::before,
.el-public-coast *::after {
    box-sizing: border-box;
}

.el-public-coast a {
    text-decoration: none;
}

.el-public-coast .pc-eyebrow {
    display: inline-flex;
    align-items: center;
    gap: 9px;
    color: #13787C;
    font-size: 11px;
    font-weight: 850;
    letter-spacing: .13em;
    text-transform: uppercase;
}

.el-public-coast .pc-dot {
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: #168A91;
}

.el-public-coast .pc-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 9px;
    min-height: 47px;
    padding: 12px 21px;
    border: 1px solid #CFE1E4;
    border-radius: 10px;
    background: #FFFFFF;
    color: var(--pc-ink);
    font-size: 13px;
    font-weight: 800;
    transition: background .18s, transform .18s;
}

.el-public-coast .pc-btn:hover {
    transform: translateY(-2px);
    background: #F6FCFC;
    color: var(--pc-ink);
}

.el-public-coast .pc-btn-primary {
    background: var(--pc-teal);
    color: #FFFFFF;
    border-color: var(--pc-teal);
}

.el-public-coast .pc-btn-primary:hover {
    background: var(--pc-teal-dark);
    border-color: var(--pc-teal-dark);
    color: #FFFFFF;
}

/* HERO */

.el-public-coast .pc-hero {
    position: relative;
    display: grid;
    grid-template-columns: minmax(0,1.2fr) minmax(260px,.8fr);
    align-items: center;
    gap: 32px;
    min-height: 460px;
    padding: clamp(32px,5vw,65px);
    border: 1px solid #D2E8E9;
    border-radius: 24px;
    overflow: hidden;
    background: linear-gradient(118deg,#DDEFF0,#F1F9F7);
}

.el-public-coast .pc-hero-copy {
    position: relative;
    z-index: 2;
}

.el-public-coast .pc-hero h1 {
    margin: 22px 0 21px;
    max-width: 680px;
    color: var(--pc-ink);
    font-size: clamp(38px,4.8vw,60px);
    font-weight: 850;
    letter-spacing: -.045em;
    line-height: 1.11;
}

.el-public-coast .pc-hero h1 span {
    color: var(--pc-teal);
}

.el-public-coast .pc-hero p {
    max-width: 545px;
    margin: 0;
    color: #52737D;
    font-size: 14px;
    line-height: 1.9;
}

.el-public-coast .pc-hero-actions {
    display: flex;
    gap: 11px;
    flex-wrap: wrap;
    margin-top: 29px;
}

.el-public-coast .pc-hero-note {
    display: block;
    margin-top: 20px;
    font-size: 11px;
    color: #688790;
}

/* DECORATIVE BOOK SCENE */

.el-public-coast .pc-art {
    position: relative;
    min-height: 310px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.el-public-coast .pc-art-ring {
    position: absolute;
    width: 310px;
    height: 310px;
    border: 1px solid rgba(22,138,145,.17);
    border-radius: 50%;
    box-shadow: 0 0 0 42px rgba(255,255,255,.22);
}

.el-public-coast .pc-book {
    position: absolute;
    bottom: 52px;
    width: 117px;
    height: 213px;
    border-radius: 5px 11px 11px 5px;
    box-shadow: 10px 17px 26px rgba(18,59,74,.17);
}

.el-public-coast .pc-book::before {
    content: "";
    display: block;
    height: 2px;
    width: 65%;
    margin: 48px auto 0;
    background: rgba(255,255,255,.78);
    box-shadow: 0 14px rgba(255,255,255,.48),
                0 28px rgba(255,255,255,.28);
}

.el-public-coast .pc-book::after {
    content: "";
    position: absolute;
    bottom: 22px;
    left: 21px;
    right: 21px;
    height: 1px;
    background: rgba(255,255,255,.56);
}

.el-public-coast .pc-book-one {
    left: calc(50% - 115px);
    background: #397480;
    transform: rotate(-18deg);
}

.el-public-coast .pc-book-two {
    left: calc(50% - 38px);
    bottom: 62px;
    background: #B17F6C;
    transform: rotate(-2deg);
}

.el-public-coast .pc-book-three {
    left: calc(50% + 38px);
    background: #718C78;
    transform: rotate(15deg);
}

.el-public-coast .pc-floating {
    position: absolute;
    padding: 12px 15px;
    border: 1px solid #D4E8E8;
    border-radius: 11px;
    background: rgba(255,255,255,.93);
    box-shadow: 0 12px 24px rgba(18,59,74,.08);
    font-size: 11px;
    font-weight: 800;
    color: #315F69;
}

.el-public-coast .pc-floating.top {
    top: 18px;
    right: 0;
}

.el-public-coast .pc-floating.bottom {
    bottom: 18px;
    left: 0;
}

/* FEATURES */

.el-public-coast .pc-section-head {
    text-align: center;
    margin-bottom: 27px;
}

.el-public-coast .pc-section-head h2 {
    margin: 11px 0 10px;
    color: var(--pc-ink);
    font-size: clamp(25px,3vw,33px);
    font-weight: 850;
    letter-spacing: -.035em;
}

.el-public-coast .pc-section-head p {
    margin: 0;
    color: var(--pc-muted);
    font-size: 13px;
    line-height: 1.8;
}

.el-public-coast .pc-feature-grid {
    display: grid;
    grid-template-columns: repeat(3,minmax(0,1fr));
    gap: 17px;
}

.el-public-coast .pc-feature {
    padding: 27px;
    border: 1px solid var(--pc-border);
    border-radius: 15px;
    background: #FFFFFF;
    transition: transform .18s,box-shadow .18s;
}

.el-public-coast .pc-feature:hover {
    transform: translateY(-3px);
    box-shadow: 0 12px 28px rgba(18,59,74,.075);
}

.el-public-coast .pc-feature-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 47px;
    height: 47px;
    margin-bottom: 18px;
    border-radius: 12px;
    background: #EAF6F6;
    color: #168A91;
    font-size: 23px;
}

.el-public-coast .pc-feature h3 {
    margin: 0 0 10px;
    color: var(--pc-ink);
    font-size: 16px;
    font-weight: 850;
}

.el-public-coast .pc-feature p {
    margin: 0;
    color: var(--pc-muted);
    font-size: 12px;
    line-height: 1.85;
}

/* HOW IT WORKS */

.el-public-coast .pc-steps {
    padding: 30px;
    border: 1px solid var(--pc-border);
    border-radius: 17px;
    background: #FFFFFF;
}

.el-public-coast .pc-step-grid {
    display: grid;
    grid-template-columns: repeat(3,minmax(0,1fr));
    gap: 25px;
}

.el-public-coast .pc-step {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.el-public-coast .pc-step-number {
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 9px;
    background: #EAF6F6;
    color: #13787C;
    font-size: 12px;
    font-weight: 850;
}

.el-public-coast .pc-step strong {
    color: var(--pc-ink);
    font-size: 13px;
}

.el-public-coast .pc-step p {
    margin: 0;
    color: var(--pc-muted);
    font-size: 12px;
    line-height: 1.8;
}

/* FINAL CTA */

.el-public-coast .pc-bottom {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 25px;
    flex-wrap: wrap;
    padding: 30px 35px;
    border: 1px solid #CDE7E9;
    border-radius: 16px;
    background: #EAF6F6;
}

.el-public-coast .pc-bottom h2 {
    margin: 0 0 8px;
    color: var(--pc-ink);
    font-size: 22px;
    font-weight: 850;
}

.el-public-coast .pc-bottom p {
    margin: 0;
    color: #557783;
    font-size: 12px;
}

@media(max-width:900px) {
    .el-public-coast .pc-hero {
        grid-template-columns: 1fr;
        min-height: 0;
    }

    .el-public-coast .pc-art {
        display: none;
    }
}

@media(max-width:700px) {
    .el-public-coast {
        gap: 43px;
        padding-top: 10px;
    }

    .el-public-coast .pc-hero {
        padding: 36px 25px;
        border-radius: 17px;
    }

    .el-public-coast .pc-hero h1 {
        font-size: 38px;
    }

    .el-public-coast .pc-feature-grid,
    .el-public-coast .pc-step-grid {
        grid-template-columns: 1fr;
        gap: 13px;
    }

    .el-public-coast .pc-feature {
        padding: 22px;
    }

    .el-public-coast .pc-hero-actions,
    .el-public-coast .pc-bottom {
        flex-direction: column;
        align-items: stretch;
    }

    .el-public-coast .pc-bottom {
        padding: 25px;
    }

    .el-public-coast .pc-hero-actions .pc-btn,
    .el-public-coast .pc-bottom .pc-btn {
        width: 100%;
    }
}

@media(prefers-reduced-motion:reduce) {
    .el-public-coast .pc-btn,
    .el-public-coast .pc-feature {
        transition: none;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="el-public-coast">

    <!-- WELCOME HERO -->

    <section class="pc-hero">
        <div class="pc-hero-copy">

            <span class="pc-eyebrow">
                <span class="pc-dot"></span>
                WELCOME TO ELIBRARY
            </span>

            <h1>
                A world of books,
                <span>waiting for you.</span>
            </h1>

            <p>
                Discover inspiring reads, explore our library
                collection, and manage your borrowing experience
                in one simple, organized space.
            </p>

            <div class="pc-hero-actions">

                <a href="<%= ResolveUrl("~/Login.aspx") %>"
                   class="pc-btn pc-btn-primary">
                    Sign In to Explore &rarr;
                </a>

                <a href="<%= ResolveUrl("~/Register.aspx") %>"
                   class="pc-btn">
                    Create an Account
                </a>

            </div>

            <span class="pc-hero-note">
                Your library journey begins with a free account.
            </span>
        </div>

        <!-- DECORATIVE BOOK ILLUSTRATION -->

        <div class="pc-art" aria-hidden="true">
            <div class="pc-art-ring"></div>
            <div class="pc-book pc-book-one"></div>
            <div class="pc-book pc-book-two"></div>
            <div class="pc-book pc-book-three"></div>

            <div class="pc-floating top">
                Discover New Stories
            </div>

            <div class="pc-floating bottom">
                Track Your Borrowings
            </div>
        </div>
    </section>

    <!-- FEATURE SHOWCASE -->

    <section aria-labelledby="pcFeaturesTitle">

        <div class="pc-section-head">
            <span class="pc-eyebrow">
                EVERYTHING IN ONE PLACE
            </span>

            <h2 id="pcFeaturesTitle">
                Your library, made simpler.
            </h2>

            <p>
                Everything you need for a smoother
                reading and borrowing experience.
            </p>
        </div>

        <div class="pc-feature-grid">

            <article class="pc-feature">
                <div class="pc-feature-icon" aria-hidden="true">
                    &#128218;
                </div>

                <h3>Discover Books</h3>

                <p>
                    Explore the collection, discover new titles,
                    and check book availability.
                </p>
            </article>

            <article class="pc-feature">
                <div class="pc-feature-icon" aria-hidden="true">
                    &#128278;
                </div>

                <h3>Easy Reservations</h3>

                <p>
                    Reserve available books online and collect
                    them from the library.
                </p>
            </article>

            <article class="pc-feature">
                <div class="pc-feature-icon" aria-hidden="true">
                    &#128340;
                </div>

                <h3>Stay Organized</h3>

                <p>
                    Track your borrowings, review due dates,
                    and view your payment history.
                </p>
            </article>

        </div>
    </section>

    <!-- STEPS -->

    <section class="pc-steps"
        aria-labelledby="pcStepsTitle">

        <div class="pc-section-head">
            <span class="pc-eyebrow">GET STARTED</span>

            <h2 id="pcStepsTitle">
                How ELibrary works
            </h2>

            <p>
                Three simple steps to start your reading journey.
            </p>
        </div>

        <div class="pc-step-grid">

            <div class="pc-step">
                <span class="pc-step-number">01</span>
                <strong>Create Your Account</strong>
                <p>
                    Register with your personal details
                    to access your library dashboard.
                </p>
            </div>

            <div class="pc-step">
                <span class="pc-step-number">02</span>
                <strong>Find and Reserve Books</strong>
                <p>
                    Browse available titles and place
                    reservations for library pickup.
                </p>
            </div>

            <div class="pc-step">
                <span class="pc-step-number">03</span>
                <strong>Collect and Read</strong>
                <p>
                    Collect your book at the library.
                    A librarian confirms collection
                    before your borrowing period begins.
                </p>
            </div>

        </div>
    </section>

    <!-- CALL TO ACTION -->

    <section class="pc-bottom">

        <div>
            <h2>Ready to find your next great read?</h2>

            <p>
                Join ELibrary and start exploring
                the library collection today.
            </p>
        </div>

        <a href="<%= ResolveUrl("~/Register.aspx") %>"
           class="pc-btn pc-btn-primary">
            Get Started &rarr;
        </a>

    </section>

</div>

</asp:Content>
