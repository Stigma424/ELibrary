
<%@ Page Title="My Borrowings"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="MyBorrows.aspx.cs"
    Inherits="ELibrary.Customer.MyBorrows"
    MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* =============================================
   INTERNSHIPELIB - COASTAL MINIMAL
   CUSTOMER MY BORROWINGS - UI-C4
============================================= */

.el-customer-mode .cb-page {
    --cb-ink: #123B4A;
    --cb-teal: #168A91;
    --cb-teal-dark: #12757C;
    --cb-muted: #647F89;
    --cb-border: #DCE9EB;
    --cb-soft: #F5FAFA;

    display: flex;
    flex-direction: column;
    gap: 25px;
    min-width: 0;
    padding-bottom: 35px;
    color: var(--cb-ink);
}

.el-customer-mode .cb-page *,
.el-customer-mode .cb-page *::before,
.el-customer-mode .cb-page *::after {
    box-sizing: border-box;
}

/* PAGE HEADER */

.el-customer-mode .cb-page .cb-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 20px;
    padding: 32px 36px;
    background: linear-gradient(115deg, #DDEFF0, #F5FAF8);
    border: 1px solid #D2E8E9;
    border-radius: 20px;
}

.el-customer-mode .cb-page .cb-eyebrow {
    display: block;
    margin-bottom: 11px;
    color: #13787C;
    font-size: 10px;
    font-weight: 850;
    letter-spacing: .13em;
}

.el-customer-mode .cb-page .cb-header h1 {
    margin: 0 0 10px;
    color: var(--cb-ink);
    font-size: clamp(28px, 3.6vw, 39px);
    font-weight: 850;
    letter-spacing: -.9px;
}

.el-customer-mode .cb-page .cb-header p {
    margin: 0;
    max-width: 565px;
    color: #52737D;
    font-size: 13px;
    line-height: 1.8;
}

/* BUTTONS */

.el-customer-mode .cb-page .cb-btn {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    min-height: 41px;
    padding: 10px 16px;
    background: #FFFFFF;
    border: 1px solid #CFE3E4;
    border-radius: 9px;
    color: var(--cb-ink);
    font-size: 12px;
    font-weight: 800;
    line-height: 1.5;
    text-decoration: none;
    cursor: pointer;
}

.el-customer-mode .cb-page .cb-btn:hover {
    background: #EAF6F6;
    border-color: #B3D5D8;
    color: var(--cb-ink);
    text-decoration: none;
}

.el-customer-mode .cb-page .cb-btn-primary {
    background: var(--cb-teal);
    border-color: var(--cb-teal);
    color: #FFFFFF;
}

.el-customer-mode .cb-page .cb-btn-primary:hover {
    background: var(--cb-teal-dark);
    border-color: var(--cb-teal-dark);
    color: #FFFFFF;
}

.el-customer-mode .cb-page .cb-btn:disabled {
    opacity: .48;
    cursor: default;
}

/* DASHBOARD METRICS */

.el-customer-mode .cb-page .cb-summary {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 14px;
}

.el-customer-mode .cb-page .cb-summary-card {
    display: flex;
    flex-direction: column;
    gap: 15px;
    min-width: 0;
    padding: 20px;
    border: 1px solid var(--cb-border);
    border-radius: 14px;
    background: #FFFFFF;
    box-shadow: 0 3px 14px rgba(18,59,74,.025);
}

.el-customer-mode .cb-page .cb-summary-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 42px;
    height: 42px;
    border-radius: 12px;
    color: #126E73;
    background: #EAF6F6;
    font-size: 21px;
    font-weight: 800;
}

.el-customer-mode .cb-page .cb-summary-icon.warm {
    color: #A56B1D;
    background: #FFF2DF;
}

.el-customer-mode .cb-page .cb-summary-icon.danger {
    color: #B94E49;
    background: #FCEBE9;
}

.el-customer-mode .cb-page .cb-summary-label {
    display: block;
    color: var(--cb-muted);
    font-size: 12px;
    font-weight: 700;
    line-height: 1.5;
}

.el-customer-mode .cb-page .cb-summary-value {
    display: block;
    margin-top: 5px;
    color: var(--cb-ink);
    font-size: 31px;
    font-weight: 850;
    line-height: 1.15;
}

/* MAIN PANEL */

.el-customer-mode .cb-page .cb-panel {
    min-width: 0;
    padding: 25px;
    border: 1px solid var(--cb-border);
    border-radius: 15px;
    background: #FFFFFF;
    box-shadow: 0 3px 14px rgba(18,59,74,.03);
}

.el-customer-mode .cb-page .cb-panel-heading {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 13px;
    margin-bottom: 20px;
}

.el-customer-mode .cb-page .cb-panel-heading h2 {
    margin: 0 0 7px;
    color: var(--cb-ink);
    font-size: 21px;
    font-weight: 850;
}

.el-customer-mode .cb-page .cb-panel-heading p {
    max-width: 650px;
    margin: 0;
    color: var(--cb-muted);
    font-size: 12px;
    line-height: 1.7;
}

/* FILTERS */

.el-customer-mode .cb-page .cb-filters {
    padding: 17px;
    border: 1px solid var(--cb-border);
    border-radius: 11px;
    background: var(--cb-soft);
}

.el-customer-mode .cb-page .cb-filter-grid {
    display: grid;
    grid-template-columns:
        minmax(200px, 2fr)
        repeat(3, minmax(135px, 1fr));
    gap: 14px;
    align-items: end;
}

.el-customer-mode .cb-page .cb-field {
    min-width: 0;
}

.el-customer-mode .cb-page .cb-field label {
    display: block;
    margin-bottom: 8px;
    color: #375968;
    font-size: 12px;
    font-weight: 750;
}

.el-customer-mode .cb-page .cb-input {
    display: block;
    width: 100%;
    min-height: 42px;
    padding: 10px 12px;
    border: 1px solid #CFE1E4;
    border-radius: 9px;
    background: #FFFFFF;
    color: var(--cb-ink);
    font-size: 12px;
}

.el-customer-mode .cb-page .cb-input:focus {
    outline: none;
    border-color: var(--cb-teal);
    box-shadow: 0 0 0 3px rgba(22,138,145,.12);
}

.el-customer-mode .cb-page .cb-filter-actions {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 9px;
    margin-top: 16px;
}

.el-customer-mode .cb-page .cb-filter-help {
    color: var(--cb-muted);
    font-size: 11px;
}

/* NOTIFICATIONS */

.el-customer-mode .cb-page .el-records-message {
    display: block;
    margin: 16px 0;
    font-size: 12px;
    line-height: 1.75;
}

.el-customer-mode .cb-page .el-records-message:empty {
    display: none;
}

.el-customer-mode .cb-page .el-records-message.success {
    padding: 14px 16px;
    border: 1px solid #C8E8D7;
    border-left: 4px solid #28845B;
    border-radius: 9px;
    background: #E9F7F1;
    color: #236747;
}

.el-customer-mode .cb-page .el-records-message.error {
    padding: 14px 16px;
    border: 1px solid #F2D3CF;
    border-left: 4px solid #C34D46;
    border-radius: 9px;
    background: #FFF0EF;
    color: #9E3E39;
}

/* RESULTS */

.el-customer-mode .cb-page .cb-results {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
    margin: 17px 0 13px;
    color: var(--cb-muted);
    font-size: 12px;
}

.el-customer-mode .cb-page .cb-table-wrap {
    overflow-x: auto;
    width: 100%;
    border: 1px solid var(--cb-border);
    border-radius: 10px;
    -webkit-overflow-scrolling: touch;
}

.el-customer-mode .cb-page .cb-table {
    width: 100%;
    min-width: 1000px;
    border-collapse: collapse;
    font-size: 12px;
    background: #FFFFFF;
}

.el-customer-mode .cb-page .cb-table th {
    padding: 14px 12px;
    border-bottom: 1px solid var(--cb-border);
    background: var(--cb-soft);
    color: #496B75;
    font-size: 11px;
    font-weight: 800;
    text-align: left;
    white-space: nowrap;
}

.el-customer-mode .cb-page .cb-table td {
    padding: 15px 12px;
    border-bottom: 1px solid #EDF3F4;
    vertical-align: middle;
    color: #47616D;
}

.el-customer-mode .cb-page .cb-table tr:hover td {
    background: #F9FCFC;
}

.el-customer-mode .cb-page .cb-record-id {
    color: var(--cb-ink);
    font-weight: 800;
    white-space: nowrap;
}

.el-customer-mode .cb-page .cb-book-cell {
    display: flex;
    flex-direction: column;
    gap: 6px;
    min-width: 175px;
}

.el-customer-mode .cb-page .cb-book-cell strong {
    color: var(--cb-ink);
    font-size: 12px;
    font-weight: 800;
    overflow-wrap: anywhere;
}

.el-customer-mode .cb-page .cb-book-cell small {
    color: var(--cb-muted);
    font-size: 11px;
    overflow-wrap: anywhere;
}

.el-customer-mode .cb-page .cb-book-cell .cb-fee {
    color: #126E73;
    font-size: 11px;
    font-weight: 750;
}

.el-customer-mode .cb-page .cb-date-cell {
    display: flex;
    flex-direction: column;
    gap: 6px;
    min-width: 110px;
}

.el-customer-mode .cb-page .cb-date-cell small {
    color: var(--cb-muted);
    font-size: 10px;
}

.el-customer-mode .cb-page .cb-date-cell strong {
    color: var(--cb-ink);
    font-size: 12px;
    font-weight: 750;
    white-space: nowrap;
}

.el-customer-mode .cb-page .el-records-due-overdue {
    color: #B94E49 !important;
    font-weight: 850;
}

/* EXISTING CODE-BEHIND STATUS CLASSES */

.el-customer-mode .cb-page .el-borrow-lifecycle,
.el-customer-mode .cb-page .el-records-status {
    display: inline-flex;
    align-items: center;
    padding: 7px 10px;
    border-radius: 999px;
    font-size: 11px;
    font-weight: 800;
    line-height: 1.4;
    white-space: nowrap;
}

.el-customer-mode .cb-page .el-borrow-lifecycle.pending,
.el-customer-mode .cb-page .el-records-status.pending {
    color: #986519;
    background: #FFF2D9;
}

.el-customer-mode .cb-page .el-borrow-lifecycle.collected,
.el-customer-mode .cb-page .el-records-status.active {
    color: #126E73;
    background: #EAF6F6;
}

.el-customer-mode .cb-page .el-borrow-lifecycle.cancelled,
.el-customer-mode .cb-page .el-records-status.overdue {
    color: #A63D39;
    background: #FCE9E7;
}

.el-customer-mode .cb-page .el-borrow-lifecycle.returned,
.el-customer-mode .cb-page .el-records-status.returned {
    color: #237C62;
    background: #E5F6EC;
}

/* ACTIONS */

.el-customer-mode .cb-page .cb-row-actions {
    display: flex;
    flex-direction: column;
    gap: 8px;
    width: 188px;
    max-width: 100%;
}

.el-customer-mode .cb-page .cb-reason {
    display: block;
    width: 100%;
    min-height: 38px;
    padding: 9px 11px;
    border: 1px solid #CFE1E4;
    border-radius: 8px;
    background: #FFFFFF;
    color: var(--cb-ink);
    font-size: 11px;
}

.el-customer-mode .cb-page .cb-reason:focus {
    outline: none;
    border-color: var(--cb-teal);
    box-shadow: 0 0 0 3px rgba(22,138,145,.12);
}

.el-customer-mode .cb-page .cb-row-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    min-height: 37px;
    padding: 8px 11px;
    border-radius: 8px;
    font-size: 11px;
    font-weight: 800;
    line-height: 1.5;
    white-space: normal;
    cursor: pointer;
}

.el-customer-mode .cb-page .cb-row-btn.cancel {
    color: #A63D39;
    border: 1px solid #F2D3CF;
    background: #FFF1EF;
}

.el-customer-mode .cb-page .cb-row-btn.cancel:hover {
    background: #FCE1DD;
}

.el-customer-mode .cb-page .cb-row-btn.return {
    color: #FFFFFF;
    background: var(--cb-teal);
    border: 1px solid var(--cb-teal);
}

.el-customer-mode .cb-page .cb-row-btn.return:hover {
    background: var(--cb-teal-dark);
    border-color: var(--cb-teal-dark);
}

.el-customer-mode .cb-page .cb-row-btn:disabled {
    opacity: .55;
    cursor: default;
}

.el-customer-mode .cb-page .cb-no-actions {
    color: var(--cb-muted);
    font-size: 11px;
}

/* FOOTNOTE */

.el-customer-mode .cb-page .cb-note {
    padding: 16px 18px;
    background: #EAF6F6;
    border: 1px solid #D2E7E8;
    border-radius: 11px;
    color: #315D67;
    font-size: 12px;
    line-height: 1.8;
}

.el-customer-mode .cb-page .cb-note strong {
    color: var(--cb-ink);
}

.el-customer-mode .cb-page .cb-pager {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
    gap: 12px;
    margin-top: 20px;
}

.el-customer-mode .cb-page .cb-page-info {
    color: var(--cb-muted);
    font-size: 12px;
    font-weight: 750;
}

.el-customer-mode .cb-page .cb-table-footer {
    margin-top: 18px;
    padding-top: 17px;
    border-top: 1px solid #EDF3F4;
    color: var(--cb-muted);
    font-size: 11px;
    line-height: 1.7;
}

/* RESPONSIVE */

@media (max-width: 1050px) {
    .el-customer-mode .cb-page .cb-summary {
        grid-template-columns: repeat(2, minmax(0,1fr));
    }

    .el-customer-mode .cb-page .cb-filter-grid {
        grid-template-columns: repeat(2, minmax(0,1fr));
    }
}

@media (max-width: 650px) {
    .el-customer-mode .cb-page .cb-header {
        padding: 24px 20px;
    }

    .el-customer-mode .cb-page .cb-header h1 {
        font-size: 29px;
    }

    .el-customer-mode .cb-page .cb-panel {
        padding: 16px;
    }

    .el-customer-mode .cb-page .cb-filter-grid {
        grid-template-columns: 1fr;
    }

    .el-customer-mode .cb-page .cb-filters {
        padding: 13px;
    }

    .el-customer-mode .cb-page .cb-filter-actions .cb-btn {
        flex: 1;
    }

    .el-customer-mode .cb-page .cb-summary {
        gap: 10px;
    }

    .el-customer-mode .cb-page .cb-summary-card {
        padding: 15px;
    }

    .el-customer-mode .cb-page .cb-summary-value {
        font-size: 26px;
    }

    .el-customer-mode .cb-page .cb-summary-label {
        font-size: 11px;
    }
}

@media (prefers-reduced-motion: reduce) {
    .el-customer-mode .cb-page .cb-btn {
        transition: none;
    }
}
</style>
</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="cb-page">

    <header class="cb-header">
        <div>
            <span class="cb-eyebrow">
                MY LIBRARY / BORROWINGS
            </span>

            <h1>My Borrowings</h1>

            <p>
                Manage your book reservations, track
                collection and due dates, and request returns.
            </p>
        </div>

        <a class="cb-btn cb-btn-primary"
            href="<%= ResolveUrl("~/Customer/Books.aspx") %>">
            + Browse Books
        </a>
    </header>

    <section class="cb-summary"
        aria-label="Borrowing overview">

        <div class="cb-summary-card">
            <div class="cb-summary-icon"
                 aria-hidden="true">&#128214;</div>

            <div>
                <span class="cb-summary-label">
                    Current Reservations &amp; Loans
                </span>

                <strong class="cb-summary-value">
                    <asp:Label
                        ID="lblTotalBorrows"
                        runat="server"
                        Text="0" />
                </strong>
            </div>
        </div>

        <div class="cb-summary-card">
            <div class="cb-summary-icon warm"
                 aria-hidden="true">&#9719;</div>

            <div>
                <span class="cb-summary-label">
                    Pending Pickups
                </span>

                <strong class="cb-summary-value">
                    <asp:Label
                        ID="lblPendingCount"
                        runat="server"
                        Text="0" />
                </strong>
            </div>
        </div>

        <div class="cb-summary-card">
            <div class="cb-summary-icon danger"
                 aria-hidden="true">!</div>

            <div>
                <span class="cb-summary-label">
                    Overdue Books
                </span>

                <strong class="cb-summary-value">
                    <asp:Label
                        ID="lblOverdueCount"
                        runat="server"
                        Text="0" />
                </strong>
            </div>
        </div>

        <div class="cb-summary-card">
            <div class="cb-summary-icon"
                 aria-hidden="true">&#8630;</div>

            <div>
                <span class="cb-summary-label">
                    Pending Return Requests
                </span>

                <strong class="cb-summary-value">
                    <asp:Label
                        ID="lblReturnPendingCount"
                        runat="server"
                        Text="0" />
                </strong>
            </div>
        </div>

    </section>

    <section class="cb-panel">

        <div class="cb-panel-heading">
            <div>
                <h2>Reservations &amp; Active Loans</h2>

                <p>
                    View pending pickups and collected books.
                    Returned and cancelled records can be
                    reviewed in Borrowing History.
                </p>
            </div>

            <asp:Button
                ID="btnHistory"
                runat="server"
                Text="View History →"
                CssClass="cb-btn"
                CausesValidation="false"
                OnClick="btnHistory_Click" />
        </div>

        <div class="cb-filters">
            <asp:Panel
                ID="pnlFilters"
                runat="server"
                DefaultButton="btnApply">

                <div class="cb-filter-grid">

                    <div class="cb-field">
                        <asp:Label
                            runat="server"
                            AssociatedControlID="txtSearch"
                            Text="Search Borrowings" />

                        <asp:TextBox
                            ID="txtSearch"
                            runat="server"
                            CssClass="cb-input"
                            MaxLength="255"
                            autocomplete="off"
                            placeholder="Title, author, Borrow ID..." />
                    </div>

                    <div class="cb-field">
                        <asp:Label
                            runat="server"
                            AssociatedControlID="ddlStatus"
                            Text="Borrow Status" />

                        <asp:DropDownList
                            ID="ddlStatus"
                            runat="server"
                            CssClass="cb-input">

                            <asp:ListItem
                                Text="All Active Records"
                                Value="All" />

                            <asp:ListItem
                                Text="Pending Pickup"
                                Value="PendingPickup" />

                            <asp:ListItem
                                Text="Active Loans"
                                Value="Active" />

                            <asp:ListItem
                                Text="Borrowed"
                                Value="Borrowed" />

                            <asp:ListItem
                                Text="Overdue"
                                Value="Overdue" />
                        </asp:DropDownList>
                    </div>

                    <div class="cb-field">
                        <asp:Label
                            runat="server"
                            AssociatedControlID="ddlReturn"
                            Text="Return Request" />

                        <asp:DropDownList
                            ID="ddlReturn"
                            runat="server"
                            CssClass="cb-input">

                            <asp:ListItem
                                Text="All Requests"
                                Value="All" />

                            <asp:ListItem
                                Text="Return Requested"
                                Value="Pending" />

                            <asp:ListItem
                                Text="Not Requested"
                                Value="NotRequested" />
                        </asp:DropDownList>
                    </div>

                    <div class="cb-field">
                        <asp:Label
                            runat="server"
                            AssociatedControlID="ddlSort"
                            Text="Sort By" />

                        <asp:DropDownList
                            ID="ddlSort"
                            runat="server"
                            CssClass="cb-input">

                            <asp:ListItem
                                Text="Due Soonest / Pending First"
                                Value="DueSoonest" />

                            <asp:ListItem
                                Text="Due Latest"
                                Value="DueLatest" />

                            <asp:ListItem
                                Text="Newest"
                                Value="Newest" />

                            <asp:ListItem
                                Text="Oldest"
                                Value="Oldest" />

                            <asp:ListItem
                                Text="Book Title (A-Z)"
                                Value="Title" />
                        </asp:DropDownList>
                    </div>

                </div>

                <div class="cb-filter-actions">

                    <asp:Button
                        ID="btnApply"
                        runat="server"
                        Text="Apply Filters"
                        CssClass="cb-btn cb-btn-primary"
                        CausesValidation="false"
                        OnClick="btnApply_Click" />

                    <asp:Button
                        ID="btnClear"
                        runat="server"
                        Text="Clear Filters"
                        CssClass="cb-btn"
                        CausesValidation="false"
                        OnClick="btnClear_Click" />

                    <span class="cb-filter-help">
                        Press Enter or Apply to search.
                    </span>
                </div>
            </asp:Panel>
        </div>

        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="el-records-message"
            role="status"
            aria-live="polite" />

        <div class="cb-results">
            <asp:Label
                ID="lblResults"
                runat="server"
                Text="Showing borrowings" />

            <span>
                Borrowing actions are available
                in each eligible record.
            </span>
        </div>
        <div class="cb-table-wrap">

            <asp:GridView
                ID="gvBorrows"
                runat="server"
                AutoGenerateColumns="False"
                CssClass="cb-table"
                GridLines="None"
                EmptyDataText="No active borrowing records match your search."
                OnRowCommand="gvBorrows_RowCommand">

                <Columns>

                    <asp:TemplateField HeaderText="Borrow ID">
                        <ItemTemplate>
                            <span class="cb-record-id">
                                #<%#: Eval("BorrowLogID") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Book">
                        <ItemTemplate>
                            <div class="cb-book-cell">

                                <strong>
                                    <%#: Eval("Title") %>
                                </strong>

                                <small>
                                    by <%#: Eval("Author") %>
                                </small>

                                <span class="cb-fee">
                                    Borrowing fee:
                                    ₱<%# Eval("BorrowingFee", "{0:N2}") %>
                                </span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Dates">
                        <ItemTemplate>
                            <div class="cb-date-cell">

                                <small>Reserved</small>
                                <strong>
                                    <%# FormatDate(Eval("DateBorrowed")) %>
                                </strong>

                                <small>Collected</small>
                                <strong>
                                    <%# FormatDate(Eval("DateCollected")) %>
                                </strong>

                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Due Date">
                        <ItemTemplate>
                            <div class="cb-date-cell">

                                <strong class='<%# GetDueDateClass(
                                    Eval("DueDate"),
                                    Eval("Status")) %>'>

                                    <%# FormatDate(Eval("DueDate")) %>
                                </strong>

                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Collection">
                        <ItemTemplate>
                            <span class='<%# GetCollectionClass(
                                Eval("CollectionStatus"),
                                Eval("Status")) %>'>

                                <%#: GetCollectionDisplay(
                                    Eval("CollectionStatus"),
                                    Eval("Status")) %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Loan Status">
                        <ItemTemplate>
                            <span class='<%# GetStatusClass(
                                Eval("Status")) %>'>

                                <%#: Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>

                            <asp:PlaceHolder
                                ID="phPending"
                                runat="server"
                                Visible='<%#
                                    Convert.ToString(
                                        Eval("CollectionStatus")) == "Pending"
                                    && Convert.ToString(
                                        Eval("Status")) == "Borrowed" %>'>

                                <div class="cb-row-actions">

                                    <asp:TextBox
                                        ID="txtCancellationReason"
                                        runat="server"
                                        CssClass="cb-reason"
                                        MaxLength="500"
                                        autocomplete="off"
                                        placeholder="Reason (optional)" />

                                    <asp:Button
                                        ID="btnCancelReservation"
                                        runat="server"
                                        Text="Cancel Reservation"
                                        CssClass="cb-row-btn cancel"
                                        CausesValidation="false"
                                        CommandName="CancelReservation"
                                        CommandArgument='<%# Eval("BorrowLogID") %>'
                                        OnClientClick="return confirm('Cancel this reservation? One book copy will become available again.');" />

                                </div>

                            </asp:PlaceHolder>

                            <asp:PlaceHolder
                                ID="phCollected"
                                runat="server"
                                Visible='<%#
                                    Convert.ToString(
                                        Eval("CollectionStatus")) == "Collected"
                                    && (
                                        Convert.ToString(
                                            Eval("Status")) == "Borrowed"
                                        || Convert.ToString(
                                            Eval("Status")) == "Overdue"
                                    ) %>'>

                                <div class="cb-row-actions">

                                    <asp:Button
                                        ID="btnRequestReturn"
                                        runat="server"
                                        Text='<%#
                                            Convert.ToBoolean(
                                                Eval("ReturnRequested"))
                                            ? "Pending Confirmation"
                                            : "Request Return" %>'
                                        Enabled='<%#
                                            !Convert.ToBoolean(
                                                Eval("ReturnRequested")) %>'
                                        CssClass="cb-row-btn return"
                                        CausesValidation="false"
                                        CommandName="RequestReturn"
                                        CommandArgument='<%# Eval("BorrowLogID") %>'
                                        OnClientClick="return confirm('Request to return this book?');" />

                                </div>

                            </asp:PlaceHolder>

                            <asp:PlaceHolder
                                ID="phClosed"
                                runat="server"
                                Visible='<%#
                                    Convert.ToString(
                                        Eval("CollectionStatus")) == "Cancelled"
                                    || Convert.ToString(
                                        Eval("Status")) == "Returned"
                                    || Convert.ToString(
                                        Eval("Status")) == "Lost" %>'>

                                <span class="cb-no-actions">
                                    No actions available
                                </span>

                            </asp:PlaceHolder>

                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

            </asp:GridView>

        </div>

        <div class="cb-pager">

            <asp:Button
                ID="btnPrevious"
                runat="server"
                Text="← Previous"
                CssClass="cb-btn"
                CausesValidation="false"
                OnClick="btnPrevious_Click" />

            <asp:Label
                ID="lblPageInfo"
                runat="server"
                CssClass="cb-page-info"
                Text="Page 1 of 1" />

            <asp:Button
                ID="btnNext"
                runat="server"
                Text="Next →"
                CssClass="cb-btn"
                CausesValidation="false"
                OnClick="btnNext_Click" />

        </div>

        <div class="cb-table-footer">
            You can cancel a reservation before collection.
            Once a book is collected, request its return here,
            then bring the physical book to the library
            for librarian confirmation.
        </div>

    </section>

    <aside class="cb-note">
        <strong>How borrowing works:</strong>
        Reserving a book holds one available copy.
        Your seven-day loan starts when a librarian
        confirms collection. A return request is not
        considered complete until the librarian receives
        and confirms the physical book.
    </aside>

</div>

</asp:Content>
