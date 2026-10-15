
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
        /* =========================================
           UI-2 - OCEAN TEAL ADMIN DASHBOARD
           Scoped to this page only
        ========================================= */

        .el-ocean-dashboard {
            --dash-primary: #123B4A;
            --dash-teal: #168A91;
            --dash-teal-dark: #12757C;
            --dash-background: #F0F8F9;
            --dash-surface: #FFFFFF;
            --dash-border: #DCE9EB;
            --dash-text: #173544;
            --dash-muted: #647F89;
            --dash-gold: #F0A65A;
            --dash-danger: #B94E49;
            --dash-success: #237C62;

            display: flex;
            flex-direction: column;
            gap: 24px;
            width: 100%;
            min-width: 0;
            padding-bottom: 35px;
            color: var(--dash-text);
        }

        .el-ocean-dashboard *,
        .el-ocean-dashboard *::before,
        .el-ocean-dashboard *::after {
            box-sizing: border-box;
        }

        /* HEADER */

        .el-ocean-dashboard .od-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 18px;
            padding: 5px 0 3px;
        }

        .el-ocean-dashboard .od-eyebrow {
            display: block;
            color: var(--dash-teal);
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .12em;
            margin-bottom: 8px;
        }

        .el-ocean-dashboard .od-header h1 {
            color: var(--dash-primary);
            font-size: clamp(25px, 3vw, 32px);
            font-weight: 800;
            margin: 0 0 8px;
            line-height: 1.2;
        }

        .el-ocean-dashboard .od-header p {
            margin: 0;
            color: var(--dash-muted);
            font-size: 13px;
            line-height: 1.7;
        }

        .el-ocean-dashboard .od-refresh {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 41px;
            padding: 10px 17px;
            background: var(--dash-surface);
            border: 1px solid var(--dash-border);
            border-radius: 9px;
            color: var(--dash-primary);
            font-size: 12px;
            font-weight: 750;
            cursor: pointer;
            transition: background .2s, border-color .2s;
        }

        .el-ocean-dashboard .od-refresh:hover {
            background: #E5F4F5;
            border-color: #B5D9DC;
        }

        /* MESSAGES */

        .el-ocean-dashboard .od-message {
            display: block;
            color: var(--dash-danger);
            font-size: 12px;
            line-height: 1.6;
        }

        .el-ocean-dashboard .od-message:empty {
            display: none;
        }

        .el-ocean-dashboard .od-message.error {
            padding: 13px 16px;
            background: #FFF1F0;
            border: 1px solid #F2D5D1;
            border-radius: 10px;
        }

        /* SUMMARY CARDS */

        .el-ocean-dashboard .od-metrics {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 15px;
        }

        .el-ocean-dashboard .od-metric {
            min-width: 0;
            display: flex;
            flex-direction: column;
            gap: 15px;
            padding: 22px;
            background: var(--dash-surface);
            border: 1px solid var(--dash-border);
            border-radius: 14px;
            box-shadow: 0 3px 14px rgba(18,59,74,.035);
            text-decoration: none;
            color: inherit;
            transition: transform .2s, box-shadow .2s;
        }

        .el-ocean-dashboard .od-metric:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 22px rgba(18,59,74,.075);
            color: inherit;
        }

        .el-ocean-dashboard .od-metric-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
        }

        .el-ocean-dashboard .od-metric-label {
            color: var(--dash-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .el-ocean-dashboard .od-metric-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            flex-shrink: 0;
            border-radius: 11px;
            background: #E6F5F5;
            color: var(--dash-teal);
            font-size: 20px;
        }

        .el-ocean-dashboard .od-metric-value {
            color: var(--dash-primary);
            font-size: clamp(25px, 2.5vw, 33px);
            font-weight: 800;
            line-height: 1.2;
            overflow-wrap: anywhere;
        }

        .el-ocean-dashboard .od-metric-note {
            color: var(--dash-muted);
            font-size: 11px;
            line-height: 1.6;
        }

        .el-ocean-dashboard .od-metric-danger .od-metric-icon {
            background: #FCEDEC;
            color: var(--dash-danger);
        }

        .el-ocean-dashboard .od-metric-danger .od-metric-value {
            color: var(--dash-danger);
        }

        .el-ocean-dashboard .od-metric-warning .od-metric-icon {
            background: #FFF3E1;
            color: #A56B1D;
        }

        .el-ocean-dashboard .od-metric-warning .od-metric-value {
            color: #96601B;
        }

        /* GENERAL SECTIONS */

        .el-ocean-dashboard .od-content-grid {
            display: grid;
            grid-template-columns:
                minmax(0, 1.15fr)
                minmax(0, 1fr);
            gap: 20px;
            align-items: stretch;
        }

        .el-ocean-dashboard .od-panel {
            min-width: 0;
            padding: 23px;
            background: var(--dash-surface);
            border: 1px solid var(--dash-border);
            border-radius: 14px;
            box-shadow: 0 3px 14px rgba(18,59,74,.03);
        }

        .el-ocean-dashboard .od-panel-head {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 19px;
        }

        .el-ocean-dashboard .od-panel-head h2 {
            margin: 0 0 6px;
            color: var(--dash-primary);
            font-size: 17px;
            font-weight: 800;
        }

        .el-ocean-dashboard .od-panel-head p {
            margin: 0;
            color: var(--dash-muted);
            font-size: 12px;
            line-height: 1.6;
        }

        .el-ocean-dashboard .od-mini-link {
            flex-shrink: 0;
            color: var(--dash-teal);
            font-size: 11px;
            font-weight: 750;
            text-decoration: none;
            white-space: nowrap;
        }

        .el-ocean-dashboard .od-mini-link:hover {
            color: var(--dash-teal-dark);
            text-decoration: underline;
        }

        /* ACTION-REQUIRED ROWS */

        .el-ocean-dashboard .od-attention-list {
            display: flex;
            flex-direction: column;
        }

        .el-ocean-dashboard .od-attention-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 13px;
            min-width: 0;
            padding: 15px 0;
            border-bottom: 1px solid #EDF3F4;
            text-decoration: none;
            color: inherit;
        }

        .el-ocean-dashboard .od-attention-item:first-child {
            padding-top: 4px;
        }

        .el-ocean-dashboard .od-attention-item:last-child {
            border-bottom: none;
            padding-bottom: 3px;
        }

        .el-ocean-dashboard .od-attention-item:hover {
            color: var(--dash-teal-dark);
        }

        .el-ocean-dashboard .od-attention-left {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 0;
        }

        .el-ocean-dashboard .od-attention-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            width: 40px;
            height: 40px;
            background: #E6F5F5;
            border-radius: 10px;
            color: var(--dash-teal);
            font-size: 17px;
            font-weight: 800;
        }

        .el-ocean-dashboard .od-attention-icon.danger {
            background: #FCEDEC;
            color: var(--dash-danger);
        }

        .el-ocean-dashboard .od-attention-icon.warning {
            background: #FFF3E1;
            color: #A56B1D;
        }

        .el-ocean-dashboard .od-attention-copy {
            display: flex;
            flex-direction: column;
            gap: 4px;
            min-width: 0;
        }

        .el-ocean-dashboard .od-attention-copy strong {
            color: var(--dash-primary);
            font-size: 12px;
            font-weight: 750;
        }

        .el-ocean-dashboard .od-attention-copy small {
            color: var(--dash-muted);
            font-size: 11px;
            line-height: 1.5;
        }

        .el-ocean-dashboard .od-attention-count {
            flex-shrink: 0;
            min-width: 42px;
            padding: 7px 10px;
            background: #EAF6F6;
            color: #126E73;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 800;
            text-align: center;
        }

        .el-ocean-dashboard .od-attention-count.danger {
            background: #FCEDEC;
            color: var(--dash-danger);
        }

        .el-ocean-dashboard .od-attention-count.warning {
            background: #FFF3E1;
            color: #96601B;
        }

        /* LIBRARY SNAPSHOT */

        .el-ocean-dashboard .od-snapshot-list {
            display: flex;
            flex-direction: column;
            gap: 0;
        }

        .el-ocean-dashboard .od-snapshot-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding: 13px 0;
            border-bottom: 1px solid #EDF3F4;
        }

        .el-ocean-dashboard .od-snapshot-row:first-child {
            padding-top: 3px;
        }

        .el-ocean-dashboard .od-snapshot-row:last-child {
            border-bottom: none;
        }

        .el-ocean-dashboard .od-snapshot-label {
            color: var(--dash-muted);
            font-size: 12px;
        }

        .el-ocean-dashboard .od-snapshot-value {
            color: var(--dash-primary);
            font-size: 15px;
            font-weight: 800;
            text-align: right;
        }

        .el-ocean-dashboard .od-snapshot-value.success {
            color: var(--dash-success);
        }

        /* SECONDARY METRICS */

        .el-ocean-dashboard .od-secondary-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px;
        }

        .el-ocean-dashboard .od-secondary-card {
            min-width: 0;
            padding: 18px;
            background: #FFFFFF;
            border: 1px solid var(--dash-border);
            border-radius: 12px;
        }

        .el-ocean-dashboard .od-secondary-label {
            display: block;
            margin-bottom: 12px;
            color: var(--dash-muted);
            font-size: 11px;
            font-weight: 700;
        }

        .el-ocean-dashboard .od-secondary-value {
            display: block;
            color: var(--dash-primary);
            font-size: 25px;
            font-weight: 800;
            line-height: 1.2;
            overflow-wrap: anywhere;
        }

        .el-ocean-dashboard .od-secondary-note {
            display: block;
            margin-top: 8px;
            color: var(--dash-muted);
            font-size: 10px;
            line-height: 1.5;
        }

        /* QUICK MANAGEMENT */

        .el-ocean-dashboard .od-actions {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
        }

        .el-ocean-dashboard .od-action {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 0;
            padding: 15px;
            background: #F7FBFB;
            border: 1px solid #E2EDEE;
            border-radius: 10px;
            color: var(--dash-primary);
            text-decoration: none;
            transition: background .2s, border-color .2s;
        }

        .el-ocean-dashboard .od-action:hover {
            background: #EAF6F6;
            border-color: #B9DCDF;
            color: var(--dash-teal-dark);
            text-decoration: none;
        }

        .el-ocean-dashboard .od-action-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            width: 37px;
            height: 37px;
            border-radius: 9px;
            background: #E3F3F4;
            color: var(--dash-teal);
            font-size: 18px;
        }

        .el-ocean-dashboard .od-action-name {
            min-width: 0;
            flex: 1;
            font-size: 12px;
            font-weight: 750;
            line-height: 1.5;
        }

        .el-ocean-dashboard .od-action-arrow {
            margin-left: auto;
            color: #83A6AA;
            font-size: 17px;
        }

        /* FOOTER */

        .el-ocean-dashboard .od-footnote {
            color: var(--dash-muted);
            font-size: 11px;
            line-height: 1.6;
            text-align: right;
        }

        /* RESPONSIVE */

        @media (max-width: 1250px) {
            .el-ocean-dashboard .od-metrics,
            .el-ocean-dashboard .od-secondary-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 950px) {
            .el-ocean-dashboard .od-content-grid {
                grid-template-columns: 1fr;
            }

            .el-ocean-dashboard .od-actions {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 600px) {
            .el-ocean-dashboard {
                gap: 17px;
            }

            .el-ocean-dashboard .od-header {
                align-items: flex-start;
            }

            .el-ocean-dashboard .od-refresh {
                width: 100%;
            }

            .el-ocean-dashboard .od-metrics {
                gap: 10px;
            }

            .el-ocean-dashboard .od-metric {
                padding: 15px;
                gap: 12px;
            }

            .el-ocean-dashboard .od-metric-icon {
                width: 33px;
                height: 33px;
                font-size: 16px;
            }

            .el-ocean-dashboard .od-metric-label {
                font-size: 11px;
            }

            .el-ocean-dashboard .od-metric-value {
                font-size: 23px;
            }

            .el-ocean-dashboard .od-panel {
                padding: 17px;
            }

            .el-ocean-dashboard .od-actions {
                grid-template-columns: 1fr;
            }

            .el-ocean-dashboard .od-secondary-card {
                padding: 15px;
            }

            .el-ocean-dashboard .od-secondary-value {
                font-size: 22px;
            }
        }

        @media (max-width: 370px) {
            .el-ocean-dashboard .od-metrics,
            .el-ocean-dashboard .od-secondary-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .el-ocean-dashboard .od-metric,
            .el-ocean-dashboard .od-action,
            .el-ocean-dashboard .od-refresh {
                transition: none;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="el-ocean-dashboard">

        <!-- DASHBOARD HEADER -->

        <header class="od-header">
            <div>
                <span class="od-eyebrow">
                    ADMINISTRATION / OVERVIEW
                </span>

                <h1>Dashboard</h1>

                <p>
                    Your library at a glance. Monitor important
                    activities and manage daily operations.
                </p>
            </div>

            <asp:Button
                ID="btnRefresh"
                runat="server"
                Text="↻ Refresh Dashboard"
                CssClass="od-refresh"
                CausesValidation="false"
                OnClick="btnRefresh_Click" />
        </header>

        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="od-message" />

        <!-- PRIMARY OPERATIONAL METRICS -->

        <section class="od-metrics"
            aria-label="Key library statistics">

            <asp:HyperLink
                runat="server"
                NavigateUrl="~/Admin/Borrowing/ManageBorrows.aspx"
                CssClass="od-metric">

                <div class="od-metric-top">
                    <span class="od-metric-label">
                        Active Borrowings
                    </span>
                    <span class="od-metric-icon"
                        aria-hidden="true">▤</span>
                </div>

                <div class="od-metric-value">
                    <asp:Label
                        ID="lblActiveBorrowings"
                        runat="server"
                        Text="0" />
                </div>

                <span class="od-metric-note">
                    Collected and not yet returned
                </span>

            </asp:HyperLink>

            <asp:HyperLink
                runat="server"
                NavigateUrl="~/Admin/Borrowing/OverdueBooks.aspx"
                CssClass="od-metric od-metric-danger">

                <div class="od-metric-top">
                    <span class="od-metric-label">
                        Overdue Books
                    </span>
                    <span class="od-metric-icon"
                        aria-hidden="true">!</span>
                </div>

                <div class="od-metric-value">
                    <asp:Label
                        ID="lblOverdueBooks"
                        runat="server"
                        Text="0" />
                </div>

                <span class="od-metric-note">
                    Loans past their due dates
                </span>

            </asp:HyperLink>

            <asp:HyperLink
                runat="server"
                NavigateUrl="~/Admin/Borrowing/ManageBorrows.aspx"
                CssClass="od-metric od-metric-warning">

                <div class="od-metric-top">
                    <span class="od-metric-label">
                        Pending Pickups
                    </span>
                    <span class="od-metric-icon"
                        aria-hidden="true">◷</span>
                </div>

                <div class="od-metric-value">
                    <asp:Label
                        ID="lblPendingPickups"
                        runat="server"
                        Text="0" />
                </div>

                <span class="od-metric-note">
                    Reservations awaiting collection
                </span>

            </asp:HyperLink>

            <asp:HyperLink
                runat="server"
                NavigateUrl="~/Admin/Transactions/ManageTransactions.aspx"
                CssClass="od-metric">

                <div class="od-metric-top">
                    <span class="od-metric-label">
                        Outstanding Fees
                    </span>
                    <span class="od-metric-icon"
                        aria-hidden="true">₱</span>
                </div>

                <div class="od-metric-value">
                    ₱<asp:Label
                        ID="lblTotalUnpaidBalance"
                        runat="server"
                        Text="0.00" />
                </div>

                <span class="od-metric-note">
                    Total remaining customer balances
                </span>

            </asp:HyperLink>

        </section>

        <!-- ATTENTION / LIBRARY SNAPSHOT -->

        <section class="od-content-grid">

            <!-- ATTENTION REQUIRED -->

            <div class="od-panel">

                <div class="od-panel-head">
                    <div>
                        <h2>Attention Required</h2>
                        <p>
                            Items librarians may need to process.
                        </p>
                    </div>
                </div>

                <div class="od-attention-list">

                    <asp:HyperLink
                        runat="server"
                        NavigateUrl="~/Admin/Borrowing/OverdueBooks.aspx"
                        CssClass="od-attention-item">

                        <div class="od-attention-left">
                            <span class="od-attention-icon danger"
                                aria-hidden="true">!</span>

                            <span class="od-attention-copy">
                                <strong>Overdue Returns</strong>
                                <small>Books past their due dates</small>
                            </span>
                        </div>

                        <span class="od-attention-count danger">
                            <asp:Label
                                ID="lblAttentionOverdue"
                                runat="server"
                                Text="0" />
                        </span>

                    </asp:HyperLink>

                    <asp:HyperLink
                        runat="server"
                        NavigateUrl="~/Admin/Borrowing/ManageBorrows.aspx"
                        CssClass="od-attention-item">

                        <div class="od-attention-left">
                            <span class="od-attention-icon warning"
                                aria-hidden="true">◷</span>

                            <span class="od-attention-copy">
                                <strong>Pending Pickups</strong>
                                <small>Reserved books awaiting pickup</small>
                            </span>
                        </div>

                        <span class="od-attention-count warning">
                            <asp:Label
                                ID="lblAttentionPickups"
                                runat="server"
                                Text="0" />
                        </span>

                    </asp:HyperLink>

                    <asp:HyperLink
                        runat="server"
                        NavigateUrl="~/Admin/Borrowing/ManageBorrows.aspx"
                        CssClass="od-attention-item">

                        <div class="od-attention-left">
                            <span class="od-attention-icon"
                                aria-hidden="true">↩</span>

                            <span class="od-attention-copy">
                                <strong>Pending Returns</strong>
                                <small>
                                    Waiting for librarian confirmation
                                </small>
                            </span>
                        </div>

                        <span class="od-attention-count">
                            <asp:Label
                                ID="lblPendingReturns"
                                runat="server"
                                Text="0" />
                        </span>

                    </asp:HyperLink>

                </div>

            </div>

            <!-- LIBRARY INVENTORY -->

            <div class="od-panel">

                <div class="od-panel-head">
                    <div>
                        <h2>Library Snapshot</h2>
                        <p>
                            Inventory and membership at a glance.
                        </p>
                    </div>

                    <asp:HyperLink
                        runat="server"
                        NavigateUrl="~/Admin/Books/ManageBooks.aspx"
                        CssClass="od-mini-link"
                        Text="Manage Books →" />
                </div>

                <div class="od-snapshot-list">

                    <div class="od-snapshot-row">
                        <span class="od-snapshot-label">
                            Catalog Books
                        </span>
                        <strong class="od-snapshot-value">
                            <asp:Label
                                ID="lblTotalBooks"
                                runat="server"
                                Text="0" />
                        </strong>
                    </div>

                    <div class="od-snapshot-row">
                        <span class="od-snapshot-label">
                            Total Book Copies
                        </span>
                        <strong class="od-snapshot-value">
                            <asp:Label
                                ID="lblTotalCopies"
                                runat="server"
                                Text="0" />
                        </strong>
                    </div>

                    <div class="od-snapshot-row">
                        <span class="od-snapshot-label">
                            Available Copies
                        </span>
                        <strong class="od-snapshot-value success">
                            <asp:Label
                                ID="lblAvailableCopies"
                                runat="server"
                                Text="0" />
                        </strong>
                    </div>

                    <div class="od-snapshot-row">
                        <span class="od-snapshot-label">
                            Registered Customers
                        </span>
                        <strong class="od-snapshot-value">
                            <asp:Label
                                ID="lblTotalCustomers"
                                runat="server"
                                Text="0" />
                        </strong>
                    </div>

                </div>

            </div>

        </section>

        <!-- SECONDARY STATISTICS -->

        <section aria-label="Additional library statistics">

            <div class="od-secondary-grid">

                <div class="od-secondary-card">
                    <span class="od-secondary-label">
                        Collected Loans
                    </span>
                    <strong class="od-secondary-value">
                        <asp:Label
                            ID="lblCollectedLoans"
                            runat="server"
                            Text="0" />
                    </strong>
                    <span class="od-secondary-note">
                        Current physically borrowed books
                    </span>
                </div>

                <div class="od-secondary-card">
                    <span class="od-secondary-label">
                        Cancelled Reservations
                    </span>
                    <strong class="od-secondary-value">
                        <asp:Label
                            ID="lblCancelledReservations"
                            runat="server"
                            Text="0" />
                    </strong>
                    <span class="od-secondary-note">
                        Reservations cancelled before collection
                    </span>
                </div>

                <div class="od-secondary-card">
                    <span class="od-secondary-label">
                        Archived Books
                    </span>
                    <strong class="od-secondary-value">
                        <asp:Label
                            ID="lblArchivedBooks"
                            runat="server"
                            Text="0" />
                    </strong>
                    <span class="od-secondary-note">
                        Collection records in the archive
                    </span>
                </div>

                <div class="od-secondary-card">
                    <span class="od-secondary-label">
                        Pending Return Requests
                    </span>
                    <strong class="od-secondary-value">
                        <asp:Label
                            ID="lblSecondaryPendingReturns"
                            runat="server"
                            Text="0" />
                    </strong>
                    <span class="od-secondary-note">
                        Return confirmations to review
                    </span>
                </div>

            </div>

        </section>

        <!-- QUICK MANAGEMENT -->

        <section class="od-panel">

            <div class="od-panel-head">
                <div>
                    <h2>Quick Management</h2>
                    <p>
                        Open frequently used library management tools.
                    </p>
                </div>
            </div>

            <div class="od-actions">

                <asp:HyperLink
                    runat="server"
                    NavigateUrl="~/Admin/Books/ManageBooks.aspx"
                    CssClass="od-action">

                    <span class="od-action-icon"
                        aria-hidden="true">▣</span>

                    <span class="od-action-name">
                        Manage Books
                    </span>

                    <span class="od-action-arrow">→</span>

                </asp:HyperLink>

                <asp:HyperLink
                    runat="server"
                    NavigateUrl="~/Admin/Borrowing/ManageBorrows.aspx"
                    CssClass="od-action">

                    <span class="od-action-icon"
                        aria-hidden="true">▤</span>

                    <span class="od-action-name">
                        Manage Borrowings
                    </span>

                    <span class="od-action-arrow">→</span>

                </asp:HyperLink>

                <asp:HyperLink
                    runat="server"
                    NavigateUrl="~/Admin/Borrowing/WalkInBorrow.aspx"
                    CssClass="od-action">

                    <span class="od-action-icon"
                        aria-hidden="true">＋</span>

                    <span class="od-action-name">
                        Walk-in Borrowing
                    </span>

                    <span class="od-action-arrow">→</span>

                </asp:HyperLink>

                <asp:HyperLink
                    runat="server"
                    NavigateUrl="~/Admin/Transactions/ManageTransactions.aspx"
                    CssClass="od-action">

                    <span class="od-action-icon"
                        aria-hidden="true">₱</span>

                    <span class="od-action-name">
                        Transactions
                    </span>

                    <span class="od-action-arrow">→</span>

                </asp:HyperLink>

                <asp:HyperLink
                    runat="server"
                    NavigateUrl="~/Admin/Users/ManageUsers.aspx"
                    CssClass="od-action">

                    <span class="od-action-icon"
                        aria-hidden="true">♙</span>

                    <span class="od-action-name">
                        Manage Users
                    </span>

                    <span class="od-action-arrow">→</span>

                </asp:HyperLink>

                <asp:HyperLink
                    runat="server"
                    NavigateUrl="~/Admin/Borrowing/BorrowHistory.aspx"
                    CssClass="od-action">

                    <span class="od-action-icon"
                        aria-hidden="true">↺</span>

                    <span class="od-action-name">
                        Borrow History
                    </span>

                    <span class="od-action-arrow">→</span>

                </asp:HyperLink>

                <asp:HyperLink
                    runat="server"
                    NavigateUrl="~/Admin/Books/ManageGenres.aspx"
                    CssClass="od-action">

                    <span class="od-action-icon"
                        aria-hidden="true">≡</span>

                    <span class="od-action-name">
                        Manage Genres
                    </span>

                    <span class="od-action-arrow">→</span>

                </asp:HyperLink>

                <asp:HyperLink
                    runat="server"
                    NavigateUrl="~/Admin/Archive/ArchiveBooks.aspx"
                    CssClass="od-action">

                    <span class="od-action-icon"
                        aria-hidden="true">▥</span>

                    <span class="od-action-name">
                        Archived Books
                    </span>

                    <span class="od-action-arrow">→</span>

                </asp:HyperLink>

                <asp:HyperLink
                    runat="server"
                    NavigateUrl="~/Admin/Audit/AuditLogs.aspx"
                    CssClass="od-action">

                    <span class="od-action-icon"
                        aria-hidden="true">☷</span>

                    <span class="od-action-name">
                        Audit Logs
                    </span>

                    <span class="od-action-arrow">→</span>

                </asp:HyperLink>

            </div>

        </section>

        <div class="od-footnote">
            Dashboard values reflect the latest completed data refresh.
        </div>

    </div>

</asp:Content>
