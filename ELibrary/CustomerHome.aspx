
<%@ Page Title="Customer Dashboard"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="CustomerHome.aspx.cs"
    Inherits="ELibrary.CustomerHome" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* ============================================
   INTERNSHIPELIB - COASTAL MINIMAL
   CUSTOMER HOMEPAGE UI-C2
============================================ */

.el-customer-mode .coastal-home {
    --ch-ink: #123B4A;
    --ch-teal: #168A91;
    --ch-hover: #12757C;
    --ch-muted: #647F89;
    --ch-border: #DCE9EB;
    --ch-soft: #F5FAFA;
    --ch-warm: #F0A65A;

    display: flex;
    flex-direction: column;
    gap: 34px;
    width: 100%;
    min-width: 0;
    color: var(--ch-ink);
}

.el-customer-mode .coastal-home *,
.el-customer-mode .coastal-home *::before,
.el-customer-mode .coastal-home *::after {
    box-sizing: border-box;
}

/* HERO */

.el-customer-mode .coastal-home .ch-hero {
    position: relative;
    display: grid;
    grid-template-columns: minmax(0, 1.35fr) minmax(220px, .65fr);
    align-items: center;
    gap: 20px;
    min-height: 330px;
    padding: clamp(25px, 4.5vw, 57px);
    border: 1px solid #D2E8E9;
    border-radius: 22px;
    background: linear-gradient(120deg, #DDEFF0 0%, #F0F8F7 100%);
    overflow: hidden;
}

.el-customer-mode .coastal-home .ch-hero::after {
    content: "";
    position: absolute;
    right: -100px;
    top: -125px;
    width: 365px;
    height: 365px;
    border: 1px solid rgba(22,138,145,.12);
    border-radius: 50%;
    pointer-events: none;
}

.el-customer-mode .coastal-home .ch-hero-content {
    position: relative;
    z-index: 2;
    min-width: 0;
}

.el-customer-mode .coastal-home .ch-eyebrow {
    display: block;
    margin-bottom: 16px;
    color: #13787C;
    font-size: 11px;
    font-weight: 850;
    letter-spacing: .14em;
    text-transform: uppercase;
}

.el-customer-mode .coastal-home .ch-hero h1 {
    max-width: 680px;
    margin: 0 0 18px;
    color: #123B4A;
    font-size: clamp(30px, 4.1vw, 49px);
    font-weight: 850;
    letter-spacing: -1.5px;
    line-height: 1.14;
    overflow-wrap: anywhere;
}

.el-customer-mode .coastal-home .ch-hero h1 .ch-name {
    color: #168A91;
}

.el-customer-mode .coastal-home .ch-hero-description {
    max-width: 560px;
    margin: 0 0 25px;
    color: #52737D;
    font-size: 14px;
    line-height: 1.9;
}

.el-customer-mode .coastal-home .ch-hero-actions {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 11px;
}

.el-customer-mode .coastal-home .ch-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 45px;
    padding: 11px 19px;
    border: 1px solid #C9DFE0;
    border-radius: 10px;
    background: #FFFFFF;
    color: #123B4A;
    font-size: 12px;
    font-weight: 800;
    text-decoration: none;
    transition: transform .17s, background .17s, border-color .17s;
}

.el-customer-mode .coastal-home .ch-btn:hover {
    transform: translateY(-2px);
    border-color: #A9D1D4;
    color: #123B4A;
    background: #F7FCFC;
    text-decoration: none;
}

.el-customer-mode .coastal-home .ch-btn-primary {
    background: #168A91;
    border-color: #168A91;
    color: #FFFFFF;
}

.el-customer-mode .coastal-home .ch-btn-primary:hover {
    background: #12757C;
    border-color: #12757C;
    color: #FFFFFF;
}

.el-customer-mode .coastal-home .ch-hero-visual {
    display: flex;
    position: relative;
    align-items: center;
    justify-content: center;
    min-height: 245px;
    z-index: 1;
}

.el-customer-mode .coastal-home .ch-visual-circle {
    position: absolute;
    width: 250px;
    height: 250px;
    border-radius: 50%;
    background: rgba(255,255,255,.42);
}

.el-customer-mode .coastal-home .ch-visual-book {
    position: absolute;
    bottom: 34px;
    width: 95px;
    height: 175px;
    border-radius: 5px 12px 12px 5px;
    box-shadow: 9px 13px 19px rgba(18,59,74,.14);
    transform-origin: bottom center;
}

.el-customer-mode .coastal-home .ch-book-one {
    left: calc(50% - 100px);
    transform: rotate(-18deg);
    background: #39717A;
}

.el-customer-mode .coastal-home .ch-book-two {
    left: calc(50% - 39px);
    bottom: 46px;
    transform: rotate(-4deg);
    background: #B7826D;
}

.el-customer-mode .coastal-home .ch-book-three {
    left: calc(50% + 22px);
    bottom: 29px;
    transform: rotate(14deg);
    background: #748D79;
}

.el-customer-mode .coastal-home .ch-visual-book::before {
    content: "";
    display: block;
    margin: 30px 15px 0;
    height: 3px;
    background: rgba(255,255,255,.8);
    box-shadow: 0 10px rgba(255,255,255,.5),
                0 20px rgba(255,255,255,.3);
}

.el-customer-mode .coastal-home .ch-visual-book::after {
    content: "";
    position: absolute;
    bottom: 17px;
    left: 15px;
    right: 15px;
    height: 1px;
    background: rgba(255,255,255,.5);
}

/* SECTION HEADERS */

.el-customer-mode .coastal-home .ch-section {
    display: flex;
    flex-direction: column;
    gap: 18px;
    min-width: 0;
}

.el-customer-mode .coastal-home .ch-heading {
    display: flex;
    align-items: end;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 13px;
}

.el-customer-mode .coastal-home .ch-section-label {
    display: block;
    margin-bottom: 7px;
    color: #168A91;
    font-size: 10px;
    font-weight: 850;
    letter-spacing: .12em;
}

.el-customer-mode .coastal-home .ch-heading h2 {
    margin: 0 0 6px;
    color: #123B4A;
    font-size: clamp(20px, 2.1vw, 25px);
    font-weight: 850;
    letter-spacing: -.5px;
}

.el-customer-mode .coastal-home .ch-heading p {
    margin: 0;
    color: #647F89;
    font-size: 12px;
    line-height: 1.6;
}

.el-customer-mode .coastal-home .ch-text-link {
    color: #13787C;
    font-size: 12px;
    font-weight: 800;
    text-decoration: none;
}

.el-customer-mode .coastal-home .ch-text-link:hover {
    color: #0F6065;
    text-decoration: underline;
}

/* STATS */

.el-customer-mode .coastal-home .ch-stats {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 14px;
}

.el-customer-mode .coastal-home .ch-stat {
    display: flex;
    flex-direction: column;
    gap: 13px;
    min-width: 0;
    padding: 20px;
    background: #FFFFFF;
    border: 1px solid #DCE9EB;
    border-radius: 15px;
    color: #123B4A;
    text-decoration: none;
    box-shadow: 0 3px 14px rgba(18,59,74,.025);
    transition: transform .17s, border-color .17s, box-shadow .17s;
}

.el-customer-mode .coastal-home .ch-stat:hover {
    transform: translateY(-3px);
    color: #123B4A;
    border-color: #BBDADC;
    box-shadow: 0 10px 25px rgba(18,59,74,.075);
    text-decoration: none;
}

.el-customer-mode .coastal-home .ch-stat-top {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.el-customer-mode .coastal-home .ch-stat-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 38px;
    height: 38px;
    border-radius: 11px;
    background: #E6F4F4;
    color: #14777D;
    font-size: 19px;
    font-weight: 800;
}

.el-customer-mode .coastal-home .ch-stat-icon.warm {
    background: #FFF2DF;
    color: #A56B1D;
}

.el-customer-mode .coastal-home .ch-stat-icon.danger {
    background: #FCEBE9;
    color: #B94E49;
}

.el-customer-mode .coastal-home .ch-stat-icon.purple {
    background: #F0EDFA;
    color: #7457A4;
}

.el-customer-mode .coastal-home .ch-stat-label {
    color: #647F89;
    font-size: 12px;
    font-weight: 700;
    line-height: 1.5;
}

.el-customer-mode .coastal-home .ch-stat-value {
    display: block;
    margin: 5px 0 4px;
    color: #123B4A;
    font-size: clamp(24px, 2.5vw, 32px);
    font-weight: 850;
    line-height: 1.15;
    overflow-wrap: anywhere;
}

.el-customer-mode .coastal-home .ch-stat small {
    color: #7B929A;
    font-size: 11px;
    line-height: 1.5;
}

.el-customer-mode .coastal-home .ch-stat.wide {
    grid-column: span 2;
    background: linear-gradient(105deg, #FFFFFF, #F1FAFA);
}

.el-customer-mode .coastal-home .ch-stat.wide
.ch-stat-value {
    color: #126F75;
}

/* BOOKS */

.el-customer-mode .coastal-home .ch-book-grid {
    display: grid;
    grid-template-columns: repeat(4, minmax(0,1fr));
    gap: 18px;
}

.el-customer-mode .coastal-home .ch-book-card {
    min-width: 0;
    overflow: hidden;
    background: #FFFFFF;
    border: 1px solid #DCE9EB;
    border-radius: 15px;
    transition: transform .18s, box-shadow .18s;
}

.el-customer-mode .coastal-home .ch-book-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 13px 29px rgba(18,59,74,.085);
}

.el-customer-mode .coastal-home .ch-cover-link {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 235px;
    padding: 21px;
    background: linear-gradient(145deg, #EDF5F3, #DCEBED);
}

.el-customer-mode .coastal-home .ch-cover-link img {
    display: block;
    max-width: 100%;
    width: auto;
    height: 100%;
    object-fit: contain;
    border-radius: 3px 7px 7px 3px;
    box-shadow: 5px 8px 13px rgba(18,59,74,.13);
}

.el-customer-mode .coastal-home .ch-book-info {
    display: flex;
    flex-direction: column;
    gap: 9px;
    padding: 17px;
    min-height: 163px;
}

.el-customer-mode .coastal-home .ch-genre {
    color: #168A91;
    font-size: 10px;
    font-weight: 850;
    letter-spacing: .06em;
    text-transform: uppercase;
}

.el-customer-mode .coastal-home .ch-book-info h3 {
    margin: 0;
    color: #123B4A;
    font-size: 14px;
    font-weight: 800;
    line-height: 1.55;
    overflow-wrap: anywhere;
}

.el-customer-mode .coastal-home .ch-book-info h3 a {
    color: inherit;
    text-decoration: none;
}

.el-customer-mode .coastal-home .ch-book-info h3 a:hover {
    color: #168A91;
}

.el-customer-mode .coastal-home .ch-author {
    margin: 0;
    color: #647F89;
    font-size: 11px;
    overflow-wrap: anywhere;
}

.el-customer-mode .coastal-home .ch-book-bottom {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 7px;
    margin-top: auto;
    flex-wrap: wrap;
}

.el-customer-mode .coastal-home .ch-book-bottom
.el-book-status {
    display: inline-block;
    padding: 6px 9px;
    border-radius: 7px;
    font-size: 10px;
    font-weight: 800;
}

.el-customer-mode .coastal-home .ch-book-bottom
.el-book-status.available {
    background: #E5F6EC;
    color: #237C62;
}

.el-customer-mode .coastal-home .ch-book-bottom
.el-book-status.unavailable {
    background: #FCE9E7;
    color: #A63D39;
}

.el-customer-mode .coastal-home .ch-book-link {
    color: #168A91;
    font-size: 11px;
    font-weight: 850;
    text-decoration: none;
}

.el-customer-mode .coastal-home .ch-book-link:hover {
    color: #0F6065;
}

/* SHORTCUTS */

.el-customer-mode .coastal-home .ch-actions-grid {
    display: grid;
    grid-template-columns: repeat(5, minmax(0,1fr));
    gap: 13px;
}

.el-customer-mode .coastal-home .ch-action-card {
    display: flex;
    flex-direction: column;
    gap: 10px;
    min-width: 0;
    min-height: 145px;
    padding: 18px;
    border: 1px solid #DCE9EB;
    border-radius: 14px;
    background: #FFFFFF;
    text-decoration: none;
    transition: transform .17s, border-color .17s;
}

.el-customer-mode .coastal-home .ch-action-card:hover {
    transform: translateY(-3px);
    border-color: #BBDADC;
    text-decoration: none;
}

.el-customer-mode .coastal-home .ch-action-icon {
    font-size: 22px;
    line-height: 1.4;
}

.el-customer-mode .coastal-home .ch-action-card strong {
    color: #123B4A;
    font-size: 12px;
    font-weight: 850;
}

.el-customer-mode .coastal-home .ch-action-card span {
    color: #647F89;
    font-size: 11px;
    line-height: 1.5;
}

.el-customer-mode .coastal-home .ch-action-card small {
    margin-top: auto;
    color: #168A91;
    font-size: 11px;
    font-weight: 850;
}

/* ERROR AND EMPTY STATES */

.el-customer-mode .coastal-home .ch-message {
    display: block;
    padding: 14px 16px;
    background: #FFF0EF;
    color: #9E3E39;
    border: 1px solid #F2D3CF;
    border-left: 4px solid #C34D46;
    border-radius: 10px;
    font-size: 12px;
    line-height: 1.7;
}

.el-customer-mode .coastal-home .ch-message:empty {
    display: none;
}

.el-customer-mode .coastal-home .ch-empty {
    padding: 34px 22px;
    border: 1px dashed #C8E0E2;
    border-radius: 14px;
    background: #FFFFFF;
    text-align: center;
}

.el-customer-mode .coastal-home .ch-empty-icon {
    display: block;
    margin-bottom: 9px;
    font-size: 34px;
}

.el-customer-mode .coastal-home .ch-empty h3 {
    color: #123B4A;
    font-size: 16px;
    font-weight: 800;
}

.el-customer-mode .coastal-home .ch-empty p {
    color: #647F89;
    font-size: 12px;
}

/* RESPONSIVE */

@media (max-width: 1100px) {
    .el-customer-mode .coastal-home .ch-stats {
        grid-template-columns: repeat(3, minmax(0,1fr));
    }

    .el-customer-mode .coastal-home .ch-book-grid {
        grid-template-columns: repeat(3, minmax(0,1fr));
    }

    .el-customer-mode .coastal-home .ch-actions-grid {
        grid-template-columns: repeat(3, minmax(0,1fr));
    }
}

@media (max-width: 750px) {
    .el-customer-mode .coastal-home .ch-hero {
        grid-template-columns: 1fr;
        min-height: 0;
    }

    .el-customer-mode .coastal-home .ch-hero-visual {
        display: none;
    }

    .el-customer-mode .coastal-home .ch-stats {
        grid-template-columns: repeat(2, minmax(0,1fr));
    }

    .el-customer-mode .coastal-home .ch-book-grid {
        grid-template-columns: repeat(2, minmax(0,1fr));
    }

    .el-customer-mode .coastal-home .ch-actions-grid {
        grid-template-columns: repeat(2, minmax(0,1fr));
    }
}

@media (max-width: 480px) {
    .el-customer-mode .coastal-home {
        gap: 28px;
    }

    .el-customer-mode .coastal-home .ch-hero {
        padding: 27px 22px;
        border-radius: 16px;
    }

    .el-customer-mode .coastal-home .ch-hero h1 {
        font-size: 31px;
        letter-spacing: -.9px;
    }

    .el-customer-mode .coastal-home .ch-hero-description {
        font-size: 12px;
    }

    .el-customer-mode .coastal-home .ch-hero-actions {
        flex-direction: column;
        align-items: stretch;
    }

    .el-customer-mode .coastal-home .ch-stats {
        gap: 10px;
    }

    .el-customer-mode .coastal-home .ch-stat {
        padding: 14px;
        gap: 9px;
    }

    .el-customer-mode .coastal-home .ch-stat-label {
        font-size: 11px;
    }

    .el-customer-mode .coastal-home .ch-stat-value {
        font-size: 25px;
    }

    .el-customer-mode .coastal-home .ch-book-grid {
        gap: 10px;
    }

    .el-customer-mode .coastal-home .ch-cover-link {
        height: 185px;
        padding: 14px;
    }

    .el-customer-mode .coastal-home .ch-book-info {
        padding: 12px;
    }

    .el-customer-mode .coastal-home .ch-book-info h3 {
        font-size: 12px;
    }

    .el-customer-mode .coastal-home .ch-actions-grid {
        grid-template-columns: 1fr;
    }

    .el-customer-mode .coastal-home .ch-action-card {
        min-height: 0;
    }
}

@media (prefers-reduced-motion: reduce) {
    .el-customer-mode .coastal-home .ch-btn,
    .el-customer-mode .coastal-home .ch-stat,
    .el-customer-mode .coastal-home .ch-book-card,
    .el-customer-mode .coastal-home .ch-action-card {
        transition: none;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="coastal-home">

    <!-- WELCOME HERO -->
    <section class="ch-hero">

        <div class="ch-hero-content">

            <span class="ch-eyebrow">
                WELCOME TO YOUR LIBRARY
            </span>

            <h1>
                Hello,
                <span class="ch-name">
                    <asp:Label ID="lblFullName"
                        runat="server" />
                </span>!
                Your next great read starts here.
            </h1>

            <p class="ch-hero-description">
                Discover new stories, find useful resources,
                and manage your library books in one simple place.
            </p>

            <div class="ch-hero-actions">
                <a href="<%= ResolveUrl("~/Customer/Books.aspx") %>"
                    class="ch-btn ch-btn-primary">
                    Explore Collection &rarr;
                </a>

                <a href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>"
                    class="ch-btn">
                    My Borrowings
                </a>
            </div>
        </div>

        <!-- DECORATIVE BOOKS -->
        <div class="ch-hero-visual" aria-hidden="true">
            <div class="ch-visual-circle"></div>
            <div class="ch-visual-book ch-book-one"></div>
            <div class="ch-visual-book ch-book-two"></div>
            <div class="ch-visual-book ch-book-three"></div>
        </div>
    </section>

    <!-- DASHBOARD ERRORS -->
    <asp:Label ID="lblMessage"
        runat="server"
        EnableViewState="false"
        CssClass="ch-message"
        role="alert" />

    <!-- BORROWING OVERVIEW -->
    <section class="ch-section">

        <div class="ch-heading">
            <div>
                <span class="ch-section-label">YOUR LIBRARY ACTIVITY</span>
                <h2>Your Reading Overview</h2>
                <p>
                    Keep track of your reservations,
                    active loans, and completed borrowings.
                </p>
            </div>

            <a class="ch-text-link"
                href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>">
                Manage Borrowings &rarr;
            </a>
        </div>

        <div class="ch-stats">

            <!-- PENDING PICKUPS -->
            <a class="ch-stat"
                href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>">

                <div class="ch-stat-top">
                    <span class="ch-stat-icon warm" aria-hidden="true">
                        &#9719;
                    </span>
                </div>

                <div>
                    <span class="ch-stat-label">Pending Pickups</span>
                    <strong class="ch-stat-value">
                        <asp:Label ID="lblPendingPickups"
                            runat="server" Text="0" />
                    </strong>
                    <small>Waiting to be collected</small>
                </div>
            </a>

            <!-- ACTIVE BORROWINGS -->
            <a class="ch-stat"
                href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>">

                <div class="ch-stat-top">
                    <span class="ch-stat-icon" aria-hidden="true">
                        &#9831;
                    </span>
                </div>

                <div>
                    <span class="ch-stat-label">Active Borrowings</span>
                    <strong class="ch-stat-value">
                        <asp:Label ID="lblActiveBorrowings"
                            runat="server" Text="0" />
                    </strong>
                    <small>Books currently borrowed</small>
                </div>
            </a>

            <!-- OVERDUE -->
            <a class="ch-stat"
                href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>">

                <div class="ch-stat-top">
                    <span class="ch-stat-icon danger" aria-hidden="true">
                        !
                    </span>
                </div>

                <div>
                    <span class="ch-stat-label">Overdue Books</span>
                    <strong class="ch-stat-value">
                        <asp:Label ID="lblOverdueBooks"
                            runat="server" Text="0" />
                    </strong>
                    <small>May need your attention</small>
                </div>
            </a>

            <!-- UNPAID BALANCE -->
            <a class="ch-stat"
                href="<%= ResolveUrl("~/Customer/MyTransactions.aspx") %>">

                <div class="ch-stat-top">
                    <span class="ch-stat-icon purple"
                        aria-hidden="true">₱</span>
                </div>

                <div>
                    <span class="ch-stat-label">Unpaid Balance</span>
                    <strong class="ch-stat-value">
                        ₱<asp:Label ID="lblUnpaidBalance"
                            runat="server" Text="0.00" />
                    </strong>
                    <small>Review your fees</small>
                </div>
            </a>

            <!-- PENDING RETURNS -->
            <a class="ch-stat"
                href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>">

                <div class="ch-stat-top">
                    <span class="ch-stat-icon warm"
                        aria-hidden="true">&#8630;</span>
                </div>

                <div>
                    <span class="ch-stat-label">Pending Returns</span>
                    <strong class="ch-stat-value">
                        <asp:Label ID="lblPendingReturns"
                            runat="server" Text="0" />
                    </strong>
                    <small>Awaiting return confirmation</small>
                </div>
            </a>

            <!-- RETURNED BOOKS -->
            <a class="ch-stat"
                href="<%= ResolveUrl("~/Customer/BorrowHistory.aspx") %>">

                <div class="ch-stat-top">
                    <span class="ch-stat-icon"
                        aria-hidden="true">&#10003;</span>
                </div>

                <div>
                    <span class="ch-stat-label">Returned Books</span>
                    <strong class="ch-stat-value">
                        <asp:Label ID="lblReturnedBooks"
                            runat="server" Text="0" />
                    </strong>
                    <small>Completed borrowings</small>
                </div>
            </a>

            <!-- CANCELLED RESERVATIONS -->
            <a class="ch-stat wide"
                href="<%= ResolveUrl("~/Customer/BorrowHistory.aspx") %>">

                <div class="ch-stat-top">
                    <span class="ch-stat-icon danger"
                        aria-hidden="true">&times;</span>
                </div>

                <div>
                    <span class="ch-stat-label">
                        Cancelled Reservations
                    </span>
                    <strong class="ch-stat-value">
                        <asp:Label ID="lblCancelledReservations"
                            runat="server" Text="0" />
                    </strong>
                    <small>
                        Reservations cancelled before collection
                    </small>
                </div>
            </a>

        </div>
    </section>

    <!-- FEATURED BOOKS -->
    <section class="ch-section">

        <div class="ch-heading">
            <div>
                <span class="ch-section-label">
                    DISCOVER SOMETHING NEW
                </span>

                <h2>Explore Our Collection</h2>
                <p>
                    Discover recently added books in our library.
                </p>
            </div>

            <a href="<%= ResolveUrl("~/Customer/Books.aspx") %>"
                class="ch-text-link">
                View All Books &rarr;
            </a>
        </div>

        <asp:Panel ID="pnlFeaturedBooks"
            runat="server">

            <div class="ch-book-grid">

                <asp:Repeater ID="rptFeaturedBooks"
                    runat="server">

                    <ItemTemplate>
                        <article class="ch-book-card">

                            <a class="ch-cover-link"
                                href='<%# GetBookDetailsUrl(
                                    Eval("BookID")) %>'>

                                <asp:Image runat="server"
                                    ImageUrl='<%# GetCoverUrl(
                                        Eval("CoverImagePath")) %>'
                                    AlternateText='<%# Eval("Title") %>'
                                    loading="lazy" />
                            </a>

                            <div class="ch-book-info">

                                <span class="ch-genre">
                                    <%#: Eval("GenreName") %>
                                </span>

                                <h3>
                                    <a href='<%# GetBookDetailsUrl(
                                        Eval("BookID")) %>'>
                                        <%#: Eval("Title") %>
                                    </a>
                                </h3>

                                <p class="ch-author">
                                    by <%#: Eval("Author") %>
                                </p>

                                <div class="ch-book-bottom">

                                    <span class='<%#
                                        GetAvailabilityClass(
                                            Eval("AvailableCopies")) %>'>

                                        <%# GetAvailabilityText(
                                            Eval("AvailableCopies")) %>
                                    </span>

                                    <a class="ch-book-link"
                                        href='<%# GetBookDetailsUrl(
                                            Eval("BookID")) %>'>
                                        Details &rarr;
                                    </a>
                                </div>
                            </div>
                        </article>
                    </ItemTemplate>
                </asp:Repeater>

            </div>
        </asp:Panel>

        <asp:Panel ID="pnlNoFeaturedBooks"
            runat="server"
            Visible="false"
            CssClass="ch-empty">

            <span class="ch-empty-icon" aria-hidden="true">
                &#128218;
            </span>

            <h3>No books available yet</h3>

            <p>
                New books will appear here once
                they are added to the catalog.
            </p>
        </asp:Panel>

    </section>

    <!-- QUICK SHORTCUTS -->
    <section class="ch-section">

        <div class="ch-heading">
            <div>
                <span class="ch-section-label">
                    EASY ACCESS
                </span>

                <h2>Quick Links</h2>
                <p>Everything you need, just a click away.</p>
            </div>
        </div>

        <div class="ch-actions-grid">

            <a class="ch-action-card"
                href="<%= ResolveUrl("~/Customer/Books.aspx") %>">
                <span class="ch-action-icon" aria-hidden="true">
                    &#128218;
                </span>
                <strong>Browse Books</strong>
                <span>Explore our library collection</span>
                <small>Browse &rarr;</small>
            </a>

            <a class="ch-action-card"
                href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>">
                <span class="ch-action-icon" aria-hidden="true">
                    &#128214;
                </span>
                <strong>My Borrowings</strong>
                <span>Track reservations and due dates</span>
                <small>View &rarr;</small>
            </a>

            <a class="ch-action-card"
                href="<%= ResolveUrl("~/Customer/BorrowHistory.aspx") %>">
                <span class="ch-action-icon" aria-hidden="true">
                    &#128340;
                </span>
                <strong>Borrowing History</strong>
                <span>Review completed borrowing records</span>
                <small>View &rarr;</small>
            </a>

            <a class="ch-action-card"
                href="<%= ResolveUrl("~/Customer/MyTransactions.aspx") %>">
                <span class="ch-action-icon" aria-hidden="true">
                    &#128179;
                </span>
                <strong>Transactions</strong>
                <span>Check fees and payment records</span>
                <small>View &rarr;</small>
            </a>

            <a class="ch-action-card"
                href="<%= ResolveUrl("~/Customer/Profile.aspx") %>">
                <span class="ch-action-icon" aria-hidden="true">
                    &#9787;
                </span>
                <strong>My Profile</strong>
                <span>Manage personal account details</span>
                <small>Manage &rarr;</small>
            </a>

        </div>
    </section>

</div>

</asp:Content>
