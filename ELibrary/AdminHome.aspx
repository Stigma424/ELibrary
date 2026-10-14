
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
        .el-admin-dashboard-v2 {
            color: #172b43;
            padding: 4px 0 32px;
        }

        .el-admin-dashboard-v2 * {
            box-sizing: border-box;
        }

        .el-ad2-header,
        .el-ad2-section-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .el-ad2-header {
            margin-bottom: 25px;
        }

        .el-ad2-eyebrow {
            color: #3976a6;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .12em;
        }

        .el-ad2-header h1 {
            margin: 8px 0;
            font-size: 30px;
            font-weight: 800;
        }

        .el-ad2-header p,
        .el-ad2-section-heading p {
            color: #718096;
            font-size: 13px;
            line-height: 1.6;
            margin: 4px 0;
        }

        .el-ad2-refresh {
            padding: 12px 17px;
            border: 0;
            border-radius: 9px;
            background: #173f67;
            color: white;
            font-size: 12px;
            font-weight: 750;
            cursor: pointer;
        }

        .el-ad2-refresh:hover {
            background: #285e89;
        }

        .el-ad2-message {
            display: block;
            color: #bd4141;
            margin-bottom: 12px;
        }

        .el-ad2-message:empty {
            display: none;
        }

        .el-ad2-section,
        .el-ad2-quick-panel {
            margin-bottom: 28px;
        }

        .el-ad2-section-heading {
            margin-bottom: 16px;
        }

        .el-ad2-section-heading h2 {
            margin: 0;
            font-size: 19px;
            font-weight: 800;
        }

        .el-ad2-section-tag {
            background: #e9f1f9;
            color: #3976a6;
            padding: 7px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 800;
        }

        .el-ad2-stats-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
        }

        .el-ad2-stat-card {
            min-width: 0;
            padding: 22px;
            background: white;
            border: 1px solid #e4ebf3;
            border-radius: 13px;
            box-shadow: 0 3px 12px rgba(23,43,67,.025);
            transition: transform .2s, box-shadow .2s;
        }

        .el-ad2-stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 26px rgba(23,43,67,.065);
        }

        .el-ad2-stat-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
        }

        .el-ad2-stat-top span:first-child {
            color: #61748b;
            font-size: 12px;
            font-weight: 700;
        }

        .el-ad2-stat-icon {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: #eaf3fb;
            color: #2f6ba0;
            font-size: 21px;
        }

        .el-ad2-stat-icon.green {
            background: #e7f6ee;
            color: #21865a;
        }

        .el-ad2-stat-icon.red {
            background: #fceced;
            color: #c54b55;
        }

        .el-ad2-stat-icon.amber {
            background: #fff3df;
            color: #b87a21;
        }

        .el-ad2-stat-value {
            margin: 18px 0 9px;
            color: #142d49;
            font-size: 33px;
            font-weight: 800;
            overflow-wrap: anywhere;
        }

        .el-ad2-stat-footer {
            color: #8a98a9;
            font-size: 11px;
            line-height: 1.5;
        }

        .el-ad2-insights-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .el-ad2-insight-card {
            padding: 23px;
            background: white;
            border: 1px solid #e4ebf3;
            border-radius: 13px;
        }

        .el-ad2-insight-card span {
            display: block;
            color: #61748b;
            font-size: 12px;
            font-weight: 700;
        }

        .el-ad2-insight-card strong {
            display: block;
            margin: 12px 0 6px;
            color: #142d49;
            font-size: 29px;
        }

        .el-ad2-insight-card small {
            color: #8a98a9;
        }

        .el-ad2-quick-panel {
            padding: 24px;
            background: white;
            border: 1px solid #e4ebf3;
            border-radius: 14px;
        }

        .el-ad2-actions-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
        }

        .el-ad2-action {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 16px;
            background: #fafcfe;
            border: 1px solid #e8eef5;
            border-radius: 10px;
            color: #253e58;
            text-decoration: none;
            font-size: 12px;
            font-weight: 750;
        }

        .el-ad2-action:hover {
            background: #eef5fc;
            border-color: #cbdfee;
            color: #173f67;
            text-decoration: none;
        }

        .el-ad2-action-arrow {
            color: #8fa3b8;
            font-size: 17px;
        }

        @media(max-width:1150px) {
            .el-ad2-stats-grid {
                grid-template-columns: repeat(2,minmax(0,1fr));
            }

            .el-ad2-actions-grid {
                grid-template-columns: repeat(2,minmax(0,1fr));
            }
        }

        @media(max-width:650px) {
            .el-ad2-stats-grid,
            .el-ad2-insights-grid,
            .el-ad2-actions-grid {
                grid-template-columns: 1fr;
            }

            .el-ad2-quick-panel {
                padding: 18px;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="el-admin-dashboard-v2">

        <div class="el-ad2-header">
            <div>
                <span class="el-ad2-eyebrow">
                    ADMINISTRATION / OVERVIEW
                </span>

                <h1>Dashboard</h1>

                <p>
                    Monitor inventory, reservations,
                    borrowing activity, and finances.
                </p>
            </div>

            <asp:Button ID="btnRefresh"
                runat="server"
                Text="↻ Refresh Dashboard"
                CssClass="el-ad2-refresh"
                CausesValidation="false"
                OnClick="btnRefresh_Click" />
        </div>

        <asp:Label ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="el-ad2-message" />

        <section class="el-ad2-section">
            <div class="el-ad2-section-heading">
                <div>
                    <h2>Library Overview</h2>
                    <p>Collection and registered member statistics.</p>
                </div>
                <span class="el-ad2-section-tag">Inventory</span>
            </div>

            <div class="el-ad2-stats-grid">

                <div class="el-ad2-stat-card">
                    <div class="el-ad2-stat-top">
                        <span>Total Books</span>
                        <span class="el-ad2-stat-icon">📚</span>
                    </div>
                    <div class="el-ad2-stat-value">
                        <asp:Label ID="lblTotalBooks"
                            runat="server" Text="0" />
                    </div>
                    <div class="el-ad2-stat-footer">
                        Books in the catalog
                    </div>
                </div>

                <div class="el-ad2-stat-card">
                    <div class="el-ad2-stat-top">
                        <span>Total Copies</span>
                        <span class="el-ad2-stat-icon">▣</span>
                    </div>
                    <div class="el-ad2-stat-value">
                        <asp:Label ID="lblTotalCopies"
                            runat="server" Text="0" />
                    </div>
                    <div class="el-ad2-stat-footer">
                        Total book inventory
                    </div>
                </div>

                <div class="el-ad2-stat-card">
                    <div class="el-ad2-stat-top">
                        <span>Available Copies</span>
                        <span class="el-ad2-stat-icon green">✓</span>
                    </div>
                    <div class="el-ad2-stat-value">
                        <asp:Label ID="lblAvailableCopies"
                            runat="server" Text="0" />
                    </div>
                    <div class="el-ad2-stat-footer">
                        Available to reserve
                    </div>
                </div>

                <div class="el-ad2-stat-card">
                    <div class="el-ad2-stat-top">
                        <span>Total Customers</span>
                        <span class="el-ad2-stat-icon">♙</span>
                    </div>
                    <div class="el-ad2-stat-value">
                        <asp:Label ID="lblTotalCustomers"
                            runat="server" Text="0" />
                    </div>
                    <div class="el-ad2-stat-footer">
                        Registered library members
                    </div>
                </div>

            </div>
        </section>

        <section class="el-ad2-section">
            <div class="el-ad2-section-heading">
                <div>
                    <h2>Borrowing &amp; Reservations</h2>
                    <p>
                        Monitor pickup requests, collected loans,
                        overdue books, and cancellations.
                    </p>
                </div>
                <span class="el-ad2-section-tag">Circulation</span>
            </div>

            <div class="el-ad2-stats-grid">

                <div class="el-ad2-stat-card">
                    <div class="el-ad2-stat-top">
                        <span>Pending Pickups</span>
                        <span class="el-ad2-stat-icon amber">◷</span>
                    </div>
                    <div class="el-ad2-stat-value">
                        <asp:Label ID="lblPendingPickups"
                            runat="server" Text="0" />
                    </div>
                    <div class="el-ad2-stat-footer">
                        Reserved, awaiting collection
                    </div>
                </div>

                <div class="el-ad2-stat-card">
                    <div class="el-ad2-stat-top">
                        <span>Active Borrowings</span>
                        <span class="el-ad2-stat-icon">📖</span>
                    </div>
                    <div class="el-ad2-stat-value">
                        <asp:Label ID="lblActiveBorrowings"
                            runat="server" Text="0" />
                    </div>
                    <div class="el-ad2-stat-footer">
                        Collected and not yet returned
                    </div>
                </div>

                <div class="el-ad2-stat-card">
                    <div class="el-ad2-stat-top">
                        <span>Overdue Books</span>
                        <span class="el-ad2-stat-icon red">!</span>
                    </div>
                    <div class="el-ad2-stat-value">
                        <asp:Label ID="lblOverdueBooks"
                            runat="server" Text="0" />
                    </div>
                    <div class="el-ad2-stat-footer">
                        Collected books past their due dates
                    </div>
                </div>

                <div class="el-ad2-stat-card">
                    <div class="el-ad2-stat-top">
                        <span>Pending Returns</span>
                        <span class="el-ad2-stat-icon amber">↩</span>
                    </div>
                    <div class="el-ad2-stat-value">
                        <asp:Label ID="lblPendingReturns"
                            runat="server" Text="0" />
                    </div>
                    <div class="el-ad2-stat-footer">
                        Awaiting librarian confirmation
                    </div>
                </div>

                <div class="el-ad2-stat-card">
                    <div class="el-ad2-stat-top">
                        <span>Collected Loans</span>
                        <span class="el-ad2-stat-icon green">✓</span>
                    </div>
                    <div class="el-ad2-stat-value">
                        <asp:Label ID="lblCollectedLoans"
                            runat="server" Text="0" />
                    </div>
                    <div class="el-ad2-stat-footer">
                        Current physically borrowed books
                    </div>
                </div>

                <div class="el-ad2-stat-card">
                    <div class="el-ad2-stat-top">
                        <span>Cancelled Reservations</span>
                        <span class="el-ad2-stat-icon red">×</span>
                    </div>
                    <div class="el-ad2-stat-value">
                        <asp:Label ID="lblCancelledReservations"
                            runat="server" Text="0" />
                    </div>
                    <div class="el-ad2-stat-footer">
                        Cancelled before collection
                    </div>
                </div>

            </div>
        </section>

        <section class="el-ad2-section">
            <div class="el-ad2-section-heading">
                <div>
                    <h2>Additional Insights</h2>
                    <p>Archived collection and outstanding balances.</p>
                </div>
            </div>

            <div class="el-ad2-insights-grid">

                <div class="el-ad2-insight-card">
                    <span>Archived Books</span>
                    <strong>
                        <asp:Label ID="lblArchivedBooks"
                            runat="server" Text="0" />
                    </strong>
                    <small>Books currently in the archive</small>
                </div>

                <div class="el-ad2-insight-card">
                    <span>Total Unpaid Balance</span>
                    <strong>
                        &#8369;<asp:Label ID="lblTotalUnpaidBalance"
                            runat="server" Text="0.00" />
                    </strong>
                    <small>Outstanding library payments</small>
                </div>

            </div>
        </section>

        <section class="el-ad2-quick-panel">
            <div class="el-ad2-section-heading">
                <div>
                    <h2>Quick Management</h2>
                    <p>Access frequently used administration tools.</p>
                </div>
            </div>

            <div class="el-ad2-actions-grid">

                <asp:HyperLink runat="server"
                    NavigateUrl="~/Admin/Books/ManageBooks.aspx"
                    CssClass="el-ad2-action">
                    Manage Books
                    <span class="el-ad2-action-arrow">→</span>
                </asp:HyperLink>

                <asp:HyperLink runat="server"
                    NavigateUrl="~/Admin/Books/ManageGenres.aspx"
                    CssClass="el-ad2-action">
                    Manage Genres
                    <span class="el-ad2-action-arrow">→</span>
                </asp:HyperLink>

                <asp:HyperLink runat="server"
                    NavigateUrl="~/Admin/Users/ManageUsers.aspx"
                    CssClass="el-ad2-action">
                    Manage Users
                    <span class="el-ad2-action-arrow">→</span>
                </asp:HyperLink>

                <asp:HyperLink runat="server"
                    NavigateUrl="~/Admin/Borrowing/ManageBorrows.aspx"
                    CssClass="el-ad2-action">
                    Manage Borrowings &amp; Pickups
                    <span class="el-ad2-action-arrow">→</span>
                </asp:HyperLink>
                <asp:HyperLink runat="server"
                    NavigateUrl="~/Admin/Borrowing/WalkInBorrow.aspx"
                    CssClass="el-ad2-action">
                    Walk-in Borrowing
                    <span class="el-ad2-action-arrow">→</span>
                </asp:HyperLink>
                <asp:HyperLink runat="server"
                    NavigateUrl="~/Admin/Borrowing/OverdueBooks.aspx"
                    CssClass="el-ad2-action">
                    Overdue Books
                    <span class="el-ad2-action-arrow">→</span>
                </asp:HyperLink>

                <asp:HyperLink runat="server"
                    NavigateUrl="~/Admin/Borrowing/BorrowHistory.aspx"
                    CssClass="el-ad2-action">
                    Borrow History
                    <span class="el-ad2-action-arrow">→</span>
                </asp:HyperLink>

                <asp:HyperLink runat="server"
                    NavigateUrl="~/Admin/Transactions/ManageTransactions.aspx"
                    CssClass="el-ad2-action">
                    Transactions
                    <span class="el-ad2-action-arrow">→</span>
                </asp:HyperLink>

                <asp:HyperLink runat="server"
                    NavigateUrl="~/Admin/Archive/ArchivedBooks.aspx"
                    CssClass="el-ad2-action">
                    Archived Books
                    <span class="el-ad2-action-arrow">→</span>
                </asp:HyperLink>

                <asp:HyperLink runat="server"
                    NavigateUrl="~/Admin/Audit/AuditLogs.aspx"
                    CssClass="el-ad2-action">
                    Audit Logs
                    <span class="el-ad2-action-arrow">→</span>
                </asp:HyperLink>

            </div>
        </section>

    </div>
</asp:Content>
