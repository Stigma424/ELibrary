
<%@ Page Title="Admin Dashboard"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="AdminHome.aspx.cs"
    Inherits="ELibrary.AdminHome" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
.ad-home {
    --ad-ink: #123B4A;
    --ad-teal: #168A91;
    --ad-muted: #647F89;
    --ad-border: #DCE9EB;
    color: var(--ad-ink);
    max-width: 1400px;
    margin: 0 auto;
}

.ad-home * {
    box-sizing: border-box;
}

.ad-hero {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 24px;
    padding: 29px 32px;
    border-radius: 17px;
    background: linear-gradient(115deg, #123B4A, #17616A);
    color: #FFFFFF;
    margin-bottom: 24px;
}

.ad-eyebrow {
    color: #ADE6E5;
    letter-spacing: 1.6px;
    font-weight: 800;
    font-size: 10px;
}

.ad-hero h1 {
    margin: 9px 0;
    font-size: 30px;
    font-weight: 850;
    color: #FFFFFF;
}

.ad-hero p {
    font-size: 12px;
    line-height: 1.7;
    margin: 0;
    color: #D9ECEF;
}

.ad-refresh {
    padding: 11px 17px;
    background: #FFFFFF;
    color: #123B4A;
    border-radius: 9px;
    border: none;
    font-weight: 800;
    font-size: 12px;
    cursor: pointer;
    white-space: nowrap;
}

.ad-refresh:hover {
    background: #E3F5F3;
}

.ad-metrics {
    display: grid;
    grid-template-columns: repeat(4, minmax(0,1fr));
    gap: 15px;
    margin-bottom: 26px;
}

.ad-metric {
    background: #FFFFFF;
    border: 1px solid var(--ad-border);
    border-radius: 13px;
    padding: 22px;
    min-width: 0;
}

.ad-metric-label {
    color: var(--ad-muted);
    font-size: 12px;
    font-weight: 650;
}

.ad-metric-value {
    font-size: 30px;
    line-height: 1.2;
    margin: 12px 0 7px;
    font-weight: 850;
    overflow-wrap: anywhere;
}

.ad-metric-note {
    color: #80949D;
    font-size: 11px;
}

.ad-metric.teal .ad-metric-value {
    color: var(--ad-teal);
}

.ad-metric.warning .ad-metric-value {
    color: #B36A22;
}

.ad-metric.danger .ad-metric-value {
    color: #B94E49;
}

.ad-metric.money .ad-metric-value {
    font-size: 25px;
}

.ad-columns {
    display: grid;
    grid-template-columns: minmax(0,1.15fr) minmax(0,1fr);
    gap: 17px;
    margin-bottom: 24px;
}

.ad-panel {
    background: #FFFFFF;
    border: 1px solid var(--ad-border);
    border-radius: 14px;
    padding: 23px;
    min-width: 0;
}

.ad-panel-head {
    margin-bottom: 16px;
}

.ad-panel-head h2 {
    font-size: 18px;
    font-weight: 800;
    margin: 0 0 6px;
}

.ad-panel-head p {
    font-size: 11px;
    color: var(--ad-muted);
    margin: 0;
}

.ad-action-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    padding: 14px 0;
    border-bottom: 1px solid #EDF2F4;
    color: var(--ad-ink);
    text-decoration: none;
}

.ad-action-row:last-child {
    border-bottom: none;
}

.ad-action-row:hover {
    color: var(--ad-teal);
}

.ad-action-row strong {
    display: block;
    font-size: 12px;
}

.ad-action-row small {
    font-size: 10px;
    color: var(--ad-muted);
}

.ad-count {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 37px;
    padding: 7px 10px;
    background: #EAF6F6;
    color: #12757C;
    border-radius: 9px;
    font-size: 13px;
    font-weight: 800;
}

.ad-finance-row {
    padding: 15px 0;
    border-bottom: 1px solid #EDF2F4;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
}

.ad-finance-row:last-child {
    border-bottom: none;
}

.ad-finance-row span {
    color: var(--ad-muted);
    font-size: 12px;
}

.ad-finance-row strong {
    font-size: 16px;
    font-weight: 800;
    white-space: nowrap;
}

.ad-finance-note {
    padding: 12px;
    border-radius: 8px;
    background: #F2F8F9;
    color: #617C85;
    font-size: 11px;
    line-height: 1.6;
    margin-top: 13px;
}

.ad-section-title {
    margin: 0 0 16px;
    font-size: 18px;
    font-weight: 800;
}

.ad-inventory {
    display: grid;
    grid-template-columns: repeat(4, minmax(0,1fr));
    gap: 10px;
}

.ad-inventory-item {
    padding: 15px 12px;
    background: #F4F9FA;
    border-radius: 10px;
    text-align: center;
}

.ad-inventory-item strong {
    display: block;
    font-size: 22px;
    font-weight: 850;
}

.ad-inventory-item span {
    display: block;
    font-size: 10px;
    color: var(--ad-muted);
    margin-top: 5px;
}

.ad-quick-actions {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.ad-quick-actions a {
    text-decoration: none;
    color: #12757C;
    background: #EDF7F7;
    border: 1px solid #D2E9EA;
    border-radius: 9px;
    padding: 11px 14px;
    font-size: 11px;
    font-weight: 750;
}

.ad-quick-actions a:hover {
    background: #DDF0F0;
}

.ad-message {
    display: block;
    color: #B94E49;
    font-size: 12px;
    margin-bottom: 15px;
}

.ad-message:empty {
    display: none;
}

@media (max-width: 1150px) {
    .ad-metrics {
        grid-template-columns: repeat(2,1fr);
    }
}

@media (max-width: 800px) {
    .ad-columns {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 550px) {
    .ad-hero {
        flex-direction: column;
        align-items: flex-start;
        padding: 24px;
    }

    .ad-hero h1 {
        font-size: 25px;
    }

    .ad-metrics {
        grid-template-columns: 1fr 1fr;
    }

    .ad-metric {
        padding: 16px;
    }

    .ad-metric-value {
        font-size: 25px;
    }

    .ad-metric.money .ad-metric-value {
        font-size: 20px;
    }

    .ad-inventory {
        grid-template-columns: repeat(2,1fr);
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="ad-home">

    <div class="ad-hero">
        <div>
            <span class="ad-eyebrow">
                ADMINISTRATION / OVERVIEW
            </span>

            <h1>Library Overview</h1>

            <p>
                Monitor daily library activity and identify
                operations requiring attention.
            </p>
        </div>

        <asp:Button ID="btnRefresh"
            runat="server"
            CssClass="ad-refresh"
            Text="↻ Refresh"
            OnClick="btnRefresh_Click" />
    </div>

    <asp:Label ID="lblMessage"
        runat="server"
        CssClass="ad-message" />

    <!-- FOUR PRIMARY METRICS -->

    <div class="ad-metrics">
        <div class="ad-metric teal">
            <div class="ad-metric-label">
                Active Borrowings
            </div>
            <div class="ad-metric-value">
                <asp:Label ID="lblActiveBorrowings"
                    runat="server" Text="0" />
            </div>
            <div class="ad-metric-note">
                Books currently on loan
            </div>
        </div>

        <div class="ad-metric danger">
            <div class="ad-metric-label">
                Overdue Books
            </div>
            <div class="ad-metric-value">
                <asp:Label ID="lblOverdueBooks"
                    runat="server" Text="0" />
            </div>
            <div class="ad-metric-note">
                Require follow-up
            </div>
        </div>

        <div class="ad-metric warning">
            <div class="ad-metric-label">
                Pending Collections
            </div>
            <div class="ad-metric-value">
                <asp:Label ID="lblPendingPickups"
                    runat="server" Text="0" />
            </div>
            <div class="ad-metric-note">
                Awaiting customer pickup
            </div>
        </div>

        <div class="ad-metric money">
            <div class="ad-metric-label">
                Outstanding Fees
            </div>
            <div class="ad-metric-value">
                ₱<asp:Label ID="lblTotalUnpaidBalance"
                    runat="server" Text="0.00" />
            </div>
            <div class="ad-metric-note">
                Unpaid receipt balances
            </div>
        </div>
    </div>

    <!-- ACTIONS AND FINANCE -->

    <div class="ad-columns">
        <section class="ad-panel">
            <div class="ad-panel-head">
                <h2>Requires Attention</h2>
                <p>Operations requiring librarian action</p>
            </div>

            <a class="ad-action-row"
                href="<%= ResolveUrl("~/Admin/Borrowing/ManageBorrows.aspx") %>">
                <div>
                    <strong>Return Requests</strong>
                    <small>Confirm returned books</small>
                </div>
                <span class="ad-count">
                    <asp:Label ID="lblPendingReturns"
                        runat="server" Text="0" />
                </span>
            </a>

            <a class="ad-action-row"
                href="<%= ResolveUrl("~/Admin/Transactions/ManageTransactions.aspx") %>">
                <div>
                    <strong>Reservations Awaiting Payment</strong>
                    <small>Check unpaid reservations</small>
                </div>
                <span class="ad-count">
                    <asp:Label ID="lblAwaitingPayment"
                        runat="server" Text="0" />
                </span>
            </a>

            <a class="ad-action-row"
                href="<%= ResolveUrl("~/Admin/Transactions/RefundDeposits.aspx") %>">
                <div>
                    <strong>Pending Deposit Refunds</strong>
                    <small>Review refund eligibility</small>
                </div>
                <span class="ad-count">
                    <asp:Label ID="lblPendingRefunds"
                        runat="server" Text="0" />
                </span>
            </a>

            <a class="ad-action-row"
                href="<%= ResolveUrl("~/Admin/Borrowing/Settlements.aspx") %>">
                <div>
                    <strong>Expired Reservations</strong>
                    <small>Process eligible expirations</small>
                </div>
                <span class="ad-count">
                    <asp:Label ID="lblExpiredReservations"
                        runat="server" Text="0" />
                </span>
            </a>
        </section>

        <section class="ad-panel">
            <div class="ad-panel-head">
                <h2>Finance &amp; Deposits</h2>
                <p>Security deposit position</p>
            </div>

            <div class="ad-finance-row">
                <span>Deposits Currently Held</span>
                <strong>
                    <asp:Label ID="lblDepositsHeld"
                        runat="server" Text="₱0.00" />
                </strong>
            </div>

            <div class="ad-finance-row">
                <span>Total Deposits Refunded</span>
                <strong>
                    <asp:Label ID="lblDepositsRefunded"
                        runat="server" Text="₱0.00" />
                </strong>
            </div>

            <div class="ad-finance-row">
                <span>Deposits On Hold</span>
                <strong>
                    <asp:Label ID="lblDepositsOnHold"
                        runat="server" Text="0" />
                </strong>
            </div>

            <div class="ad-finance-note">
                Security deposits are refundable obligations.
                They are tracked separately from borrowing
                fees and library revenue.
            </div>

            <div style="margin-top:17px">
                <a class="ad-quick-actions"
                    href="<%= ResolveUrl("~/Admin/Transactions/DepositLedger.aspx") %>"
                    style="color:#168A91;text-decoration:none;font-size:12px;font-weight:800">
                    View Deposit Ledger →
                </a>
            </div>
        </section>
    </div>

    <!-- LIBRARY SNAPSHOT -->

    <section class="ad-panel" style="margin-bottom:24px">
        <h2 class="ad-section-title">
            Library at a Glance
        </h2>

        <div class="ad-inventory">
            <div class="ad-inventory-item">
                <strong>
                    <asp:Label ID="lblTotalBooks"
                        runat="server" Text="0" />
                </strong>
                <span>Book Titles</span>
            </div>

            <div class="ad-inventory-item">
                <strong>
                    <asp:Label ID="lblAvailableCopies"
                        runat="server" Text="0" />
                </strong>
                <span>Available Copies</span>
            </div>

            <div class="ad-inventory-item">
                <strong>
                    <asp:Label ID="lblTotalCustomers"
                        runat="server" Text="0" />
                </strong>
                <span>Registered Customers</span>
            </div>

            <div class="ad-inventory-item">
                <strong>
                    <asp:Label ID="lblArchivedBooks"
                        runat="server" Text="0" />
                </strong>
                <span>Archived Titles</span>
            </div>
        </div>
    </section>

    <!-- QUICK LINKS -->

    <section class="ad-panel">
        <h2 class="ad-section-title">Quick Actions</h2>

        <div class="ad-quick-actions">
            <a href="<%= ResolveUrl("~/Admin/Borrowing/ManageBorrows.aspx") %>">
                Manage Borrowings
            </a>

            <a href="<%= ResolveUrl("~/Admin/Borrowing/WalkInBorrow.aspx") %>">
                Walk-in Borrowing
            </a>

            <a href="<%= ResolveUrl("~/Admin/Transactions/CollectDeposits.aspx") %>">
                Collect Deposits
            </a>

            <a href="<%= ResolveUrl("~/Admin/Transactions/RefundDeposits.aspx") %>">
                Refund Deposits
            </a>

            <a href="<%= ResolveUrl("~/Admin/Borrowing/BorrowHistory.aspx") %>">
                Borrow History
            </a>
        </div>
    </section>
</div>

</asp:Content>
