
<%@ Page Title="Reports &amp; Analytics"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Reports.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Reports" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>
    .rd-final{max-width:1400px;margin:0 auto;color:#123B4A}
    .rd-final *{box-sizing:border-box}
    .rd-eyebrow{display:block;color:#168A91;font-size:11px;font-weight:800;letter-spacing:1.4px;margin-bottom:8px}
    .rd-final h1{font-size:31px;font-weight:850;margin:0 0 9px}
    .rd-intro{font-size:13px;color:#647F89;line-height:1.8;margin:0 0 25px}
    .rd-banner{display:flex;justify-content:space-between;align-items:center;gap:15px;flex-wrap:wrap;border-radius:14px;background:linear-gradient(110deg,#123B4A,#17616A);color:#fff;padding:24px;margin-bottom:30px}
    .rd-banner strong{display:block;font-size:16px;color:#fff;margin-bottom:6px}
    .rd-banner p{font-size:12px;color:#D7ECEF;margin:0}
    .rd-count{background:rgba(255,255,255,.13);padding:10px 14px;border-radius:9px;color:#B8FFF0;font-size:12px;font-weight:800}
    .rd-section{margin-bottom:32px}
    .rd-section h2{font-size:19px;font-weight:850;margin:0 0 6px}
    .rd-description{font-size:12px;color:#647F89;margin:0 0 17px}
    .rd-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px}
    .rd-card{display:flex;flex-direction:column;min-width:0;background:#fff;border:1px solid #DCE9EB;border-radius:14px;padding:23px}
    .rd-top{display:flex;align-items:center;justify-content:space-between;gap:10px;margin-bottom:16px}
    .rd-icon{width:43px;height:43px;display:flex;align-items:center;justify-content:center;border-radius:10px;background:#EAF6F6;color:#168A91;font-size:22px;font-weight:800}
    .rd-status{background:#E5F6EC;color:#238253;border-radius:8px;padding:6px 10px;font-size:10px;font-weight:800}
    .rd-card h3{font-size:16px;font-weight:850;margin:0 0 8px}
    .rd-card p{font-size:12px;line-height:1.75;color:#647F89;flex:1;margin:0 0 18px}
    .rd-open{display:inline-flex;align-self:flex-start;background:#168A91;color:#fff!important;border-radius:9px;padding:10px 16px;font-size:12px;font-weight:800;text-decoration:none}
    .rd-open:hover{background:#12757C;color:#fff!important}
    .rd-note{padding:20px;background:#F4F9FA;border:1px solid #DCE9EB;border-radius:13px;color:#647F89;font-size:12px;line-height:1.8}
    @media(max-width:800px){.rd-grid{grid-template-columns:1fr}}
    @media(max-width:550px){.rd-final h1{font-size:25px}.rd-card{padding:18px}}
</style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">

<div class="rd-final">

    <span class="rd-eyebrow">ADMINISTRATION / REPORTING</span>
    <h1>Reports &amp; Analytics</h1>

    <p class="rd-intro">
        Generate printable library reports for borrowing,
        financial monitoring, inventory, security deposits,
        and system administration.
    </p>

    <div class="rd-banner">
        <div>
            <strong>ELibrary Reporting Workspace</strong>
            <p>
                Independent reporting pages with
                SQL Server stored procedures and RDLC local processing.
            </p>
        </div>
        <span class="rd-count">15 of 15 Reports Supplied</span>
    </div>

    <!-- BORROWING AND RESERVATIONS -->

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
                <p>Borrowing transactions, returns, cancellations, losses and collection status.</p>
                <asp:HyperLink ID="lnkBorrowingActivity" runat="server"
                    NavigateUrl="~/Admin/Reports/Borrowing/BorrowingActivity.aspx"
                    CssClass="rd-open" Text="Open Report &#8594;" />
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#8986;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>
                <h3>Overdue Books</h3>
                <p>Current overdue borrowings, responsible customers and days overdue.</p>
                <a class="rd-open" href="<%= ResolveUrl("~/Admin/Reports/Borrowing/OverdueBooks.aspx") %>">
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9786;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>
                <h3>Customer Borrowing History</h3>
                <p>Customer borrowing records, channels and loan outcomes.</p>
                <a class="rd-open" href="<%= ResolveUrl("~/Admin/Reports/Borrowing/CustomerBorrowing.aspx") %>">
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#8644;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>
                <h3>Reservation Conversion</h3>
                <p>Online reservation pickups, cancellations, expirations and conversion rates.</p>
                <a class="rd-open" href="<%= ResolveUrl("~/Admin/Reports/Borrowing/ReservationConversion.aspx") %>">
                    Open Report &#8594;
                </a>
            </article>

        </div>
    </section>

    <!-- FINANCIAL -->

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
                <p>Borrowing, late and replacement fee payments and refunds.</p>
                <a class="rd-open" href="<%= ResolveUrl("~/Admin/Reports/Finance/FeeCollections.aspx") %>">
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#8645;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>
                <h3>Customer Outstanding Balances</h3>
                <p>Unpaid borrowing-related receipts and currently outstanding amounts.</p>
                <a class="rd-open" href="<%= ResolveUrl("~/Admin/Reports/Finance/CustomerBalances.aspx") %>">
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#10006;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>
                <h3>Lost Book Settlements</h3>
                <p>Lost-book replacement charges, payments and settlement balances.</p>
                <a class="rd-open" href="<%= ResolveUrl("~/Admin/Reports/Finance/LostBookSettlements.aspx") %>">
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#8599;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>
                <h3>Collection Trends</h3>
                <p>Daily, weekly and monthly fee payments, refunds and net collections.</p>
                <a class="rd-open" href="<%= ResolveUrl("~/Admin/Reports/Finance/CollectionTrends.aspx") %>">
                    Open Report &#8594;
                </a>
            </article>

        </div>
    </section>

    <!-- INVENTORY -->

    <section class="rd-section">
        <h2>Inventory &amp; Popularity</h2>
        <p class="rd-description">
            Stock availability and book/genre borrowing demand.
        </p>

        <div class="rd-grid">

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9638;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>
                <h3>Expanded Book Inventory</h3>
                <p>Stock levels, availability, genres, ISBNs and archived titles.</p>
                <a class="rd-open" href="<%= ResolveUrl("~/Admin/Reports/Inventory/BookInventory.aspx") %>">
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9733;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>
                <h3>Most Borrowed Books</h3>
                <p>Book popularity based on collected borrowing transactions.</p>
                <a class="rd-open" href="<%= ResolveUrl("~/Admin/Reports/Inventory/MostBorrowedBooks.aspx") %>">
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9776;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>
                <h3>Genre Popularity</h3>
                <p>Genre rankings, borrowed titles and confirmed loan demand.</p>
                <a class="rd-open" href="<%= ResolveUrl("~/Admin/Reports/Inventory/GenrePopularity.aspx") %>">
                    Open Report &#8594;
                </a>
            </article>

        </div>
    </section>

    <!-- SECURITY DEPOSITS -->

    <section class="rd-section">
        <h2>Security Deposits</h2>
        <p class="rd-description">
            Refundable deposits, recorded transactions and current balances.
        </p>

        <div class="rd-grid">

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9670;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>
                <h3>Security Deposit Transactions</h3>
                <p>Deposit collections and refunds, transaction methods and staff.</p>
                <a class="rd-open" href="<%= ResolveUrl("~/Admin/Reports/Deposits/SecurityDeposits.aspx") %>">
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#10003;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>
                <h3>Deposit Refund Status</h3>
                <p>Current received, refunded and held deposit amounts and statuses.</p>
                <a class="rd-open" href="<%= ResolveUrl("~/Admin/Reports/Deposits/DepositRefundStatus.aspx") %>">
                    Open Report &#8594;
                </a>
            </article>

        </div>
    </section>

    <!-- ADMINISTRATION -->

    <section class="rd-section">
        <h2>Administration &amp; Auditing</h2>
        <p class="rd-description">
            Librarian actions and system-wide recorded audit events.
        </p>

        <div class="rd-grid">

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9881;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>
                <h3>Librarian Activity</h3>
                <p>Recorded actions associated with librarian accounts.</p>
                <a class="rd-open" href="<%= ResolveUrl("~/Admin/Reports/Audit/LibrarianActivity.aspx") %>">
                    Open Report &#8594;
                </a>
            </article>

            <article class="rd-card">
                <div class="rd-top">
                    <span class="rd-icon">&#9776;</span>
                    <span class="rd-status">AVAILABLE</span>
                </div>
                <h3>Audit Trail Summary</h3>
                <p>System-wide audit events with actor, role, category and date filters.</p>
                <a class="rd-open" href="<%= ResolveUrl("~/Admin/Reports/Audit/AuditTrailSummary.aspx") %>">
                    Open Report &#8594;
                </a>
            </article>

        </div>
    </section>

    <div class="rd-note">
        The reporting module contains 15 independent RDLC reports.
        Each report uses its own ASP.NET Web Form, code-behind
        and read-only SQL Server stored procedure.
        Typed XSD DataSets are not required.
        Deposits are reported separately from fee collections.
        Profit/Loss is excluded.
    </div>

</div>

</asp:Content>
