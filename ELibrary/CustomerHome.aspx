
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
.ch-home {
    --ch-ink: #123B4A;
    --ch-teal: #168A91;
    --ch-muted: #647F89;
    --ch-border: #DCE9EB;
    color: var(--ch-ink);
    max-width: 1350px;
    margin: 0 auto;
}

.ch-home * {
    box-sizing: border-box;
}

.ch-hero {
    background: linear-gradient(110deg,#123B4A,#17616A);
    color: #FFFFFF;
    padding: 32px;
    border-radius: 17px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 20px;
    margin-bottom: 24px;
}

.ch-eyebrow {
    color: #B3F4E9;
    font-size: 10px;
    font-weight: 800;
    letter-spacing: 1.5px;
}

.ch-hero h1 {
    margin: 9px 0;
    color: #FFFFFF;
    font-weight: 850;
    font-size: 30px;
}

.ch-hero p {
    font-size: 12px;
    color: #DBF3F3;
    line-height: 1.8;
    max-width: 510px;
    margin: 0;
}

.ch-hero-actions {
    display: flex;
    gap: 9px;
    flex-wrap: wrap;
}

.ch-main-button {
    padding: 12px 16px;
    background: #FFFFFF;
    color: #123B4A;
    font-size: 12px;
    text-decoration: none;
    border-radius: 9px;
    font-weight: 800;
    white-space: nowrap;
}

.ch-main-button:hover {
    background: #E3F5F3;
    color: #123B4A;
}

.ch-overview {
    display: grid;
    grid-template-columns: repeat(4,minmax(0,1fr));
    gap: 13px;
    margin-bottom: 24px;
}

.ch-overview-item {
    background: #FFFFFF;
    border: 1px solid var(--ch-border);
    border-radius: 12px;
    padding: 19px;
    min-width: 0;
}

.ch-overview-label {
    font-size: 11px;
    font-weight: 650;
    color: var(--ch-muted);
}

.ch-overview-value {
    font-size: 28px;
    font-weight: 850;
    margin-top: 12px;
    overflow-wrap: anywhere;
}

.ch-overview-item.teal .ch-overview-value {
    color: var(--ch-teal);
}

.ch-overview-item.warning .ch-overview-value {
    color: #B46C28;
}

.ch-overview-item.danger .ch-overview-value {
    color: #B94E49;
}

.ch-overview-item.money .ch-overview-value {
    font-size: 23px;
}

.ch-columns {
    display: grid;
    grid-template-columns: minmax(0,1.1fr) minmax(0,1fr);
    gap: 16px;
    margin-bottom: 28px;
}

.ch-panel {
    padding: 23px;
    border: 1px solid var(--ch-border);
    border-radius: 14px;
    background: #FFFFFF;
    min-width: 0;
}

.ch-panel h2 {
    font-size: 18px;
    font-weight: 800;
    margin: 0 0 6px;
}

.ch-panel-subtitle {
    font-size: 11px;
    color: var(--ch-muted);
    margin-bottom: 16px;
}

.ch-info-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
    border-bottom: 1px solid #EDF2F4;
    padding: 14px 0;
}

.ch-info-row:last-child {
    border-bottom: none;
}

.ch-info-row span {
    font-size: 12px;
    color: var(--ch-muted);
}

.ch-info-row strong {
    font-size: 15px;
    font-weight: 850;
    white-space: nowrap;
}

.ch-panel-link {
    display: inline-flex;
    margin-top: 13px;
    color: var(--ch-teal);
    text-decoration: none;
    font-size: 12px;
    font-weight: 800;
}

.ch-panel-link:hover {
    color: #12757C;
}

.ch-quick-actions {
    display: grid;
    grid-template-columns: repeat(2,minmax(0,1fr));
    gap: 10px;
}

.ch-quick {
    padding: 14px;
    border-radius: 10px;
    background: #F3F9FA;
    border: 1px solid #E0EDEF;
    text-decoration: none;
}

.ch-quick strong {
    color: var(--ch-ink);
    font-size: 12px;
    display: block;
}

.ch-quick small {
    font-size: 10px;
    color: var(--ch-muted);
    display: block;
    margin-top: 6px;
}

.ch-quick:hover {
    background: #EAF6F6;
    border-color: #B6DADB;
}

.ch-books-section {
    margin-top: 15px;
}

.ch-section-head {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    margin-bottom: 16px;
}

.ch-section-head h2 {
    font-size: 20px;
    margin: 0;
    font-weight: 800;
}

.ch-section-head a {
    font-size: 12px;
    text-decoration: none;
    color: var(--ch-teal);
    font-weight: 800;
}

.ch-books {
    display: grid;
    grid-template-columns: repeat(4,minmax(0,1fr));
    gap: 15px;
}

.ch-book {
    border: 1px solid var(--ch-border);
    background: #FFFFFF;
    border-radius: 13px;
    overflow: hidden;
    min-width: 0;
    display: flex;
    flex-direction: column;
}

.ch-book-cover {
    height: 165px;
    padding: 17px;
    background: #EAF3F4;
    display: flex;
    align-items: center;
    justify-content: center;
}

.ch-book-cover img {
    max-width: 100%;
    max-height: 140px;
    object-fit: contain;
}

.ch-book-content {
    padding: 17px;
    display: flex;
    flex-direction: column;
    flex: 1;
}

.ch-book-genre {
    color: var(--ch-teal);
    font-size: 10px;
    font-weight: 800;
    text-transform: uppercase;
}

.ch-book-title {
    font-size: 13px;
    font-weight: 850;
    margin: 7px 0;
}

.ch-book-author {
    font-size: 11px;
    color: var(--ch-muted);
    margin-bottom: 14px;
}

.ch-book-bottom {
    margin-top: auto;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
}

.ch-book-bottom a {
    font-size: 11px;
    font-weight: 800;
    color: var(--ch-teal);
    text-decoration: none;
}

.ch-status {
    padding: 5px 7px;
    border-radius: 7px;
    background: #E6F7ED;
    color: #238253;
    font-weight: 750;
    font-size: 10px;
}

.ch-status.unavailable {
    background: #FFF0F0;
    color: #B94E49;
}

.ch-empty {
    background: #FFFFFF;
    border: 1px solid var(--ch-border);
    border-radius: 13px;
    padding: 30px;
    text-align: center;
    font-size: 12px;
    color: var(--ch-muted);
}

.ch-message {
    display: block;
    color: #B94E49;
    font-size: 12px;
    margin-bottom: 13px;
}

.ch-message:empty {
    display: none;
}

@media (max-width: 1100px) {
    .ch-overview,
    .ch-books {
        grid-template-columns: repeat(2,1fr);
    }
}

@media (max-width: 780px) {
    .ch-hero {
        flex-direction: column;
        align-items: flex-start;
    }

    .ch-columns {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 480px) {
    .ch-hero {
        padding: 24px;
    }

    .ch-hero h1 {
        font-size: 25px;
    }

    .ch-overview,
    .ch-quick-actions {
        grid-template-columns: repeat(2,minmax(0,1fr));
    }

    .ch-overview-item {
        padding: 14px;
    }

    .ch-overview-value {
        font-size: 24px;
    }

    .ch-overview-item.money .ch-overview-value {
        font-size: 19px;
    }

    .ch-books {
        grid-template-columns: 1fr;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="ch-home">

    <div class="ch-hero">
        <div>
            <span class="ch-eyebrow">
                MY LIBRARY ACCOUNT
            </span>

            <h1>
                Welcome back,
                <asp:Label ID="lblFullName"
                    runat="server" Text="Customer" />
            </h1>

            <p>
                Manage your books, track upcoming returns,
                and keep your library account up to date.
            </p>
        </div>

        <div class="ch-hero-actions">
            <a class="ch-main-button"
                href="<%= ResolveUrl("~/Customer/Books.aspx") %>">
                Browse Books
            </a>
        </div>
    </div>

    <asp:Label ID="lblMessage"
        runat="server"
        CssClass="ch-message" />

    <!-- PRIMARY OVERVIEW -->

    <div class="ch-overview">
        <div class="ch-overview-item teal">
            <div class="ch-overview-label">
                Books On Loan
            </div>
            <div class="ch-overview-value">
                <asp:Label ID="lblActiveBorrowings"
                    runat="server" Text="0" />
            </div>
        </div>

        <div class="ch-overview-item warning">
            <div class="ch-overview-label">
                Pending Pickup
            </div>
            <div class="ch-overview-value">
                <asp:Label ID="lblPendingPickups"
                    runat="server" Text="0" />
            </div>
        </div>

        <div class="ch-overview-item danger">
            <div class="ch-overview-label">
                Overdue Books
            </div>
            <div class="ch-overview-value">
                <asp:Label ID="lblOverdueBooks"
                    runat="server" Text="0" />
            </div>
        </div>

        <div class="ch-overview-item money">
            <div class="ch-overview-label">
                Outstanding Fees
            </div>
            <div class="ch-overview-value">
                ₱<asp:Label ID="lblUnpaidBalance"
                    runat="server" Text="0.00" />
            </div>
        </div>
    </div>

    <!-- PERSONAL ACCOUNT PANELS -->

    <div class="ch-columns">

        <section class="ch-panel">
            <h2>Payments &amp; Deposits</h2>
            <div class="ch-panel-subtitle">
                Your current security deposit status
            </div>

            <div class="ch-info-row">
                <span>Security Deposits Held</span>
                <strong>
                    <asp:Label ID="lblDepositsHeld"
                        runat="server" Text="₱0.00" />
                </strong>
            </div>

            <div class="ch-info-row">
                <span>Pending Refunds</span>
                <strong>
                    <asp:Label ID="lblPendingRefunds"
                        runat="server" Text="0" />
                </strong>
            </div>

            <div class="ch-info-row">
                <span>Total Deposits Refunded</span>
                <strong>
                    <asp:Label ID="lblTotalRefunded"
                        runat="server" Text="₱0.00" />
                </strong>
            </div>

            <div class="ch-info-row">
                <span>Reservations Awaiting Payment</span>
                <strong>
                    <asp:Label ID="lblUnpaidReservations"
                        runat="server" Text="0" />
                </strong>
            </div>

            <a class="ch-panel-link"
                href="<%= ResolveUrl("~/Admin/Transactions/DepositLedger.aspx") %>">
                View Deposit History →
            </a>
        </section>

        <section class="ch-panel">
            <h2>My Library Activity</h2>

            <div class="ch-panel-subtitle">
                Recent borrowing status summary
            </div>

            <div class="ch-info-row">
                <span>Return Requests Pending</span>
                <strong>
                    <asp:Label ID="lblPendingReturns"
                        runat="server" Text="0" />
                </strong>
            </div>

            <div class="ch-info-row">
                <span>Books Returned</span>
                <strong>
                    <asp:Label ID="lblReturnedBooks"
                        runat="server" Text="0" />
                </strong>
            </div>

            <div class="ch-info-row">
                <span>Cancelled Reservations</span>
                <strong>
                    <asp:Label ID="lblCancelledReservations"
                        runat="server" Text="0" />
                </strong>
            </div>

            <a class="ch-panel-link"
                href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>">
                View My Borrowings →
            </a>
        </section>
    </div>

    <!-- QUICK ACTIONS -->

    <section class="ch-panel" style="margin-bottom:28px">
        <h2>Quick Actions</h2>
        <div class="ch-panel-subtitle">
            Navigate to your frequently used pages
        </div>

        <div class="ch-quick-actions">
            <a class="ch-quick"
                href="<%= ResolveUrl("~/Customer/Books.aspx") %>">
                <strong>Browse Books</strong>
                <small>Discover available books</small>
            </a>

            <a class="ch-quick"
                href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>">
                <strong>My Borrowings</strong>
                <small>Manage reservations and returns</small>
            </a>

            <a class="ch-quick"
                href="<%= ResolveUrl("~/Customer/MyTransactions.aspx") %>">
                <strong>Transactions</strong>
                <small>Check fees and payment history</small>
            </a>

            <a class="ch-quick"
                href="<%= ResolveUrl("~/Customer/BorrowHistory.aspx") %>">
                <strong>Borrowing History</strong>
                <small>Review completed activity</small>
            </a>
        </div>
    </section>

    <!-- FEATURED BOOKS -->

    <section class="ch-books-section">

        <div class="ch-section-head">
            <h2>Explore the Library</h2>

            <a href="<%= ResolveUrl("~/Customer/Books.aspx") %>">
                View All Books →
            </a>
        </div>

        <asp:Panel ID="pnlFeaturedBooks"
            runat="server"
            CssClass="ch-books">

            <asp:Repeater ID="rptFeaturedBooks"
                runat="server">

                <ItemTemplate>
                    <div class="ch-book">

                        <div class="ch-book-cover">
                            <img
                                src='<%# GetCoverUrl(Eval("CoverImagePath")) %>'
                                alt="Book cover" />
                        </div>

                        <div class="ch-book-content">

                            <span class="ch-book-genre">
                                <%#: Eval("GenreName") %>
                            </span>

                            <h3 class="ch-book-title">
                                <%#: Eval("Title") %>
                            </h3>

                            <div class="ch-book-author">
                                <%#: Eval("Author") %>
                            </div>

                            <div class="ch-book-bottom">

                                <span class='<%# GetAvailabilityClass(Eval("AvailableCopies")) %>'>
                                    <%# GetAvailabilityText(Eval("AvailableCopies")) %>
                                </span>

                                <a href='<%# GetBookDetailsUrl(Eval("BookID")) %>'>
                                    Details
                                </a>

                            </div>
                        </div>
                    </div>
                </ItemTemplate>

            </asp:Repeater>
        </asp:Panel>

        <asp:Panel ID="pnlNoFeaturedBooks"
            runat="server"
            CssClass="ch-empty">

            No featured books are currently available.

        </asp:Panel>
    </section>
</div>

</asp:Content>
