
<%@ Page Title="Reports &amp; Analytics"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Reports.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Reports" %>

<asp:Content ID="HeadContent"
    ContentPlaceHolderID="head"
    runat="server">

<style>
    .rd-final{
        max-width:1400px;
        margin:0 auto;
        color:#123B4A;
    }

    .rd-final *{
        box-sizing:border-box;
    }

    .rd-eyebrow{
        display:block;
        color:#168A91;
        font-size:11px;
        font-weight:800;
        letter-spacing:1.4px;
        margin-bottom:8px;
    }

    .rd-final h1{
        font-size:31px;
        font-weight:850;
        margin:0 0 9px;
    }

    .rd-intro{
        font-size:13px;
        color:#647F89;
        line-height:1.8;
        margin:0 0 25px;
    }

    .rd-banner{
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:15px;
        flex-wrap:wrap;
        border-radius:14px;
        background:linear-gradient(110deg,#123B4A,#17616A);
        color:#fff;
        padding:24px;
        margin-bottom:30px;
    }

    .rd-banner strong{
        display:block;
        font-size:16px;
        color:#fff;
        margin-bottom:6px;
    }

    .rd-banner p{
        font-size:12px;
        color:#D7ECEF;
        margin:0;
    }

    .rd-count{
        background:rgba(255,255,255,.13);
        padding:10px 14px;
        border-radius:9px;
        color:#B8FFF0;
        font-size:12px;
        font-weight:800;
    }

    /* CONSOLIDATED REPORT */

    .rd-master{
        position:relative;
        overflow:hidden;
        background:#fff;
        border:1px solid #CCE4E5;
        border-radius:17px;
        padding:28px;
        margin-bottom:33px;
        box-shadow:0 5px 24px rgba(18,59,74,.05);
    }

    .rd-master::before{
        content:"";
        position:absolute;
        top:0;
        left:0;
        right:0;
        height:5px;
        background:linear-gradient(90deg,#168A91,#72CBC5);
    }

    .rd-master-top{
        display:flex;
        align-items:flex-start;
        justify-content:space-between;
        gap:20px;
        margin-bottom:20px;
    }

    .rd-master-label{
        display:inline-flex;
        align-items:center;
        border-radius:7px;
        background:#EAF6F6;
        color:#168A91;
        padding:7px 11px;
        font-size:10px;
        font-weight:850;
        letter-spacing:1px;
        margin-bottom:12px;
    }

    .rd-master h2{
        font-size:23px;
        font-weight:850;
        color:#123B4A;
        margin:0 0 11px;
    }

    .rd-master-description{
        color:#647F89;
        font-size:13px;
        line-height:1.8;
        margin:0;
        max-width:780px;
    }

    .rd-master-icon{
        display:flex;
        align-items:center;
        justify-content:center;
        width:64px;
        height:64px;
        flex-shrink:0;
        border-radius:15px;
        background:#EAF6F6;
        color:#168A91;
        font-size:31px;
        font-weight:800;
    }

    .rd-master-features{
        display:grid;
        grid-template-columns:repeat(4,minmax(0,1fr));
        gap:11px;
        margin:23px 0;
    }

    .rd-master-feature{
        background:#F4F9FA;
        border:1px solid #E2EEEF;
        border-radius:10px;
        padding:13px 14px;
        min-width:0;
    }

    .rd-master-feature strong{
        display:block;
        color:#123B4A;
        font-size:12px;
        font-weight:850;
        margin-bottom:5px;
    }

    .rd-master-feature span{
        display:block;
        color:#647F89;
        font-size:11px;
        line-height:1.6;
    }

    .rd-master-bottom{
        display:flex;
        align-items:center;
        justify-content:space-between;
        flex-wrap:wrap;
        gap:16px;
    }

    .rd-master-note{
        color:#647F89;
        font-size:11px;
        line-height:1.7;
        margin:0;
    }

    .rd-master-open{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        background:#168A91;
        color:#fff!important;
        text-decoration:none;
        font-size:13px;
        font-weight:850;
        padding:13px 21px;
        border-radius:10px;
        white-space:nowrap;
    }

    .rd-master-open:hover{
        background:#12757C;
        color:#fff!important;
    }

    /* INDIVIDUAL REPORTS */

    .rd-section{
        margin-bottom:32px;
    }

    .rd-section h2{
        font-size:19px;
        font-weight:850;
        margin:0 0 6px;
    }

    .rd-description{
        font-size:12px;
        color:#647F89;
        margin:0 0 17px;
        line-height:1.7;
    }

    .rd-grid{
        display:grid;
        grid-template-columns:repeat(2,minmax(0,1fr));
        gap:16px;
    }

    .rd-card{
        display:flex;
        flex-direction:column;
        min-width:0;
        background:#fff;
        border:1px solid #DCE9EB;
        border-radius:14px;
        padding:23px;
        transition:border-color .15s,box-shadow .15s;
    }

    .rd-card:hover{
        border-color:#9BCACC;
        box-shadow:0 5px 18px rgba(18,59,74,.05);
    }

    .rd-top{
        display:flex;
        align-items:center;
        justify-content:space-between;
        gap:10px;
        margin-bottom:16px;
    }

    .rd-icon{
        width:43px;
        height:43px;
        display:flex;
        align-items:center;
        justify-content:center;
        border-radius:10px;
        background:#EAF6F6;
        color:#168A91;
        font-size:22px;
        font-weight:800;
    }

    .rd-status{
        background:#E5F6EC;
        color:#238253;
        border-radius:8px;
        padding:6px 10px;
        font-size:10px;
        font-weight:800;
    }

    .rd-card h3{
        font-size:16px;
        font-weight:850;
        margin:0 0 8px;
    }

    .rd-card p{
        font-size:12px;
        line-height:1.75;
        color:#647F89;
        flex:1;
        margin:0 0 18px;
    }

    .rd-open{
        display:inline-flex;
        align-self:flex-start;
        background:#168A91;
        color:#fff!important;
        border-radius:9px;
        padding:10px 16px;
        font-size:12px;
        font-weight:800;
        text-decoration:none;
    }

    .rd-open:hover{
        background:#12757C;
        color:#fff!important;
    }

    .rd-note{
        padding:20px;
        background:#F4F9FA;
        border:1px solid #DCE9EB;
        border-radius:13px;
        color:#647F89;
        font-size:12px;
        line-height:1.8;
    }

    @media(max-width:1050px){
        .rd-master-features{
            grid-template-columns:repeat(2,minmax(0,1fr));
        }
    }

    @media(max-width:800px){
        .rd-grid{
            grid-template-columns:1fr;
        }
    }

    @media(max-width:550px){
        .rd-final h1{
            font-size:25px;
        }

        .rd-master{
            padding:21px;
        }

        .rd-master h2{
            font-size:20px;
        }

        .rd-master-icon{
            display:none;
        }

        .rd-master-features{
            grid-template-columns:1fr;
        }

        .rd-master-open{
            width:100%;
        }

        .rd-card{
            padding:18px;
        }

        .rd-banner{
            padding:20px;
        }
    }
</style>

</asp:Content>

<asp:Content ID="MainBlock"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="rd-final">

    <span class="rd-eyebrow">
        ADMINISTRATION / REPORTING
    </span>

    <h1>Reports &amp; Analytics</h1>

    <p class="rd-intro">
        Generate individual and consolidated library reports
        covering borrowing performance, financial monitoring,
        book inventory, refundable security deposits,
        and system administration.
    </p>

    <div class="rd-banner">
        <div>
            <strong>ELibrary Reporting Workspace</strong>
            <p>
                SQL Server reporting with RDLC processing,
                visual analytics and printable reports.
            </p>
        </div>

        <span class="rd-count">
            15 Individual + 1 Consolidated
        </span>
    </div>

    <!-- =========================================
         FEATURED CONSOLIDATED REPORT
         ========================================= -->

    <section class="rd-master">

        <div class="rd-master-top">

            <div>
                <span class="rd-master-label">
                    CONSOLIDATED REPORT GENERATOR
                </span>

                <h2>
                    Library Performance Report
                </h2>

                <p class="rd-master-description">
                    Generate one comprehensive management report
                    containing library borrowing statistics,
                    reservation conversion, financial collections,
                    inventory summaries, book and genre popularity,
                    refundable security deposits, and audit activity.
                </p>
            </div>

            <div class="rd-master-icon">
                &#9783;
            </div>

        </div>

        <div class="rd-master-features">

            <div class="rd-master-feature">
                <strong>Monthly</strong>
                <span>
                    Review a selected month of
                    library activity.
                </span>
            </div>

            <div class="rd-master-feature">
                <strong>Quarterly</strong>
                <span>
                    Review a three-month
                    reporting period.
                </span>
            </div>

            <div class="rd-master-feature">
                <strong>Yearly</strong>
                <span>
                    Summarize annual
                    library performance.
                </span>
            </div>

            <div class="rd-master-feature">
                <strong>Custom Range</strong>
                <span>
                    Define a specific
                    reporting period.
                </span>
            </div>

        </div>

        <div class="rd-master-bottom">

            <p class="rd-master-note">
                Includes KPI summaries, monthly charts,
                popularity rankings and administrative statistics.
                Export using the ReportViewer PDF or Excel options.
            </p>

            <a class="rd-master-open"
               href='<%= ResolveUrl("~/Admin/Reports/Consolidated/LibraryPerformance.aspx") %>'>
                Generate Performance Report &#8594;
            </a>

        </div>

    </section>

    <!-- =========================================
         BORROWING & RESERVATIONS
         ========================================= -->

    <section class="rd-section">

        <h2>Borrowing &amp; Reservations</h2>

        <p class="rd-description">
            Borrowing activity, overdue books, customer history
            and online reservation performance.
        </p>

        <div class="rd-grid">

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9783;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Borrowing Activity</h3>

                <p>
                    Borrowing transactions, returns,
                    cancellations, losses and collection status.
                </p>

                <asp:HyperLink
                    ID="lnkBorrowingActivity"
                    runat="server"
                    NavigateUrl="~/Admin/Reports/Borrowing/BorrowingActivity.aspx"
                    CssClass="rd-open"
                    Text="Open Report &#8594;" />
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#8986;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Overdue Books</h3>

                <p>
                    Current overdue borrowings,
                    responsible customers and days overdue.
                </p>

                <a class="rd-open"
                   href='<%= ResolveUrl("~/Admin/Reports/Borrowing/OverdueBooks.aspx") %>'>
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9786;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Customer Borrowing History</h3>

                <p>
                    Customer borrowing records,
                    channels and loan outcomes.
                </p>

                <a class="rd-open"
                   href='<%= ResolveUrl("~/Admin/Reports/Borrowing/CustomerBorrowing.aspx") %>'>
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#8644;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Reservation Conversion</h3>

                <p>
                    Online reservation pickups,
                    cancellations, expirations and conversion rates.
                </p>

                <a class="rd-open"
                   href='<%= ResolveUrl("~/Admin/Reports/Borrowing/ReservationConversion.aspx") %>'>
                    Open Report &#8594;
                </a>
            </article>

        </div>
    </section>

    <!-- =========================================
         FINANCIAL REPORTS
         ========================================= -->

    <section class="rd-section">

        <h2>Financial &amp; Settlements</h2>

        <p class="rd-description">
            Fee payments, refunds, outstanding balances
            and lost-book settlements.
        </p>

        <div class="rd-grid">

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#8369;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Fee Collections</h3>

                <p>
                    Borrowing, late and replacement
                    fee payments and refunds.
                </p>

                <a class="rd-open"
                   href='<%= ResolveUrl("~/Admin/Reports/Finance/FeeCollections.aspx") %>'>
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#8645;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Customer Outstanding Balances</h3>

                <p>
                    Unpaid borrowing-related receipts
                    and currently outstanding amounts.
                </p>

                <a class="rd-open"
                   href='<%= ResolveUrl("~/Admin/Reports/Finance/CustomerBalances.aspx") %>'>
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#10006;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Lost Book Settlements</h3>

                <p>
                    Lost-book replacement charges,
                    payments and settlement balances.
                </p>

                <a class="rd-open"
                   href='<%= ResolveUrl("~/Admin/Reports/Finance/LostBookSettlements.aspx") %>'>
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#8599;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Collection Trends</h3>

                <p>
                    Daily, weekly and monthly fee payments,
                    refunds and net collections.
                </p>

                <a class="rd-open"
                   href='<%= ResolveUrl("~/Admin/Reports/Finance/CollectionTrends.aspx") %>'>
                    Open Report &#8594;
                </a>
            </article>

        </div>
    </section>

    <!-- =========================================
         INVENTORY & POPULARITY
         ========================================= -->

    <section class="rd-section">

        <h2>Inventory &amp; Popularity</h2>

        <p class="rd-description">
            Stock availability and book or genre borrowing demand.
        </p>

        <div class="rd-grid">

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9638;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Expanded Book Inventory</h3>

                <p>
                    Stock levels, availability,
                    genres, ISBNs and archived titles.
                </p>

                <a class="rd-open"
                   href='<%= ResolveUrl("~/Admin/Reports/Inventory/BookInventory.aspx") %>'>
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9733;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Most Borrowed Books</h3>

                <p>
                    Book popularity based on
                    collected borrowing transactions.
                </p>

                <a class="rd-open"
                   href='<%= ResolveUrl("~/Admin/Reports/Inventory/MostBorrowedBooks.aspx") %>'>
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9776;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Genre Popularity</h3>

                <p>
                    Genre rankings, borrowed titles
                    and confirmed loan demand.
                </p>

                <a class="rd-open"
                   href='<%= ResolveUrl("~/Admin/Reports/Inventory/GenrePopularity.aspx") %>'>
                    Open Report &#8594;
                </a>
            </article>

        </div>
    </section>

    <!-- =========================================
         SECURITY DEPOSITS
         ========================================= -->

    <section class="rd-section">

        <h2>Security Deposits</h2>

        <p class="rd-description">
            Refundable deposits, recorded transactions
            and current balances.
        </p>

        <div class="rd-grid">

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9670;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Security Deposit Transactions</h3>

                <p>
                    Deposit collections and refunds,
                    transaction methods and staff.
                </p>

                <a class="rd-open"
                   href='<%= ResolveUrl("~/Admin/Reports/Deposits/SecurityDeposits.aspx") %>'>
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#10003;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Deposit Refund Status</h3>

                <p>
                    Current received, refunded
                    and held deposit amounts and statuses.
                </p>

                <a class="rd-open"
                   href='<%= ResolveUrl("~/Admin/Reports/Deposits/DepositRefundStatus.aspx") %>'>
                    Open Report &#8594;
                </a>
            </article>

        </div>
    </section>

    <!-- =========================================
         ADMINISTRATION & AUDITING
         ========================================= -->

    <section class="rd-section">

        <h2>Administration &amp; Auditing</h2>

        <p class="rd-description">
            Librarian actions and system-wide
            recorded audit events.
        </p>

        <div class="rd-grid">

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9881;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Librarian Activity</h3>

                <p>
                    Recorded actions associated
                    with librarian accounts.
                </p>

                <a class="rd-open"
                   href='<%= ResolveUrl("~/Admin/Reports/Audit/LibrarianActivity.aspx") %>'>
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9776;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>

                <h3>Audit Trail Summary</h3>

                <p>
                    System-wide audit events with
                    actor, role, category and date filters.
                </p>

                <a class="rd-open"
                   href='<%= ResolveUrl("~/Admin/Reports/Audit/AuditTrailSummary.aspx") %>'>
                    Open Report &#8594;
                </a>
            </article>

        </div>
    </section>

    <!-- =========================================
         REPORTING INFORMATION
         ========================================= -->

    <div class="rd-note">
        <strong>ELibrary Reporting System</strong>
        <p>
            The reporting module contains 15 independent RDLC reports
            and one consolidated Library Performance Report.
            Reports use ASP.NET Web Forms, SQL Server and
            RDLC local processing.
        </p>
        <p>
            Reporting-period activity and current account snapshots
            are presented separately. Refundable security deposits
            are excluded from fee collection income.
        </p>
    </div>

</div>

</asp:Content>
