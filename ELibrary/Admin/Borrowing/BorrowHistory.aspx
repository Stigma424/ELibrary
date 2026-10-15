
<%@ Page Title="Borrowing History"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="BorrowHistory.aspx.cs"
    Inherits="ELibrary.Admin.Borrowing.BorrowHistory" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* ==========================================
   INTERNSHIPELIB - OCEAN TEAL
   UI-3F: ADMIN BORROWING HISTORY
========================================== */

.el-borrow-history {
    --bh-primary: #123B4A;
    --bh-accent: #168A91;
    --bh-accent-hover: #12757C;
    --bh-border: #DCE9EB;
    --bh-muted: #647F89;
    --bh-soft: #F5FAFA;
    --bh-danger: #B94E49;

    display: flex;
    flex-direction: column;
    gap: 22px;
    min-width: 0;
    padding-bottom: 28px;
    color: var(--bh-primary);
}

.el-borrow-history *,
.el-borrow-history *::before,
.el-borrow-history *::after {
    box-sizing: border-box;
}

/* ==========================================
   HEADER
========================================== */

.el-borrow-history .bh-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 16px;
    padding: 4px 0;
}

.el-borrow-history .bh-eyebrow {
    display: block;
    margin-bottom: 8px;
    color: var(--bh-accent);
    font-size: 10px;
    font-weight: 800;
    letter-spacing: .12em;
}

.el-borrow-history .bh-header h1 {
    margin: 0 0 7px;
    color: var(--bh-primary);
    font-size: 29px;
    font-weight: 800;
}

.el-borrow-history .bh-header p {
    margin: 0;
    color: var(--bh-muted);
    font-size: 12px;
    line-height: 1.7;
}

.el-borrow-history .bh-header-actions {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 9px;
}

/* ==========================================
   BUTTONS
========================================== */

.el-borrow-history .bh-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 40px;
    padding: 9px 15px;
    background: #FFFFFF;
    border: 1px solid var(--bh-border);
    border-radius: 9px;
    color: var(--bh-primary);
    font-size: 12px;
    font-weight: 750;
    line-height: 1.5;
    text-decoration: none;
    cursor: pointer;
    transition:
        background .2s ease,
        border-color .2s ease;
}

.el-borrow-history .bh-btn:hover {
    background: #EAF5F6;
    border-color: #B4DADD;
    color: var(--bh-primary);
    text-decoration: none;
}

.el-borrow-history .bh-btn-primary {
    background: var(--bh-accent);
    border-color: var(--bh-accent);
    color: #FFFFFF;
}

.el-borrow-history .bh-btn-primary:hover {
    background: var(--bh-accent-hover);
    border-color: var(--bh-accent-hover);
    color: #FFFFFF;
}

.el-borrow-history .bh-btn:disabled {
    opacity: .45;
    cursor: default;
}

/* ==========================================
   MAIN PANEL
========================================== */

.el-borrow-history .bh-panel {
    min-width: 0;
    padding: 23px;
    background: #FFFFFF;
    border: 1px solid var(--bh-border);
    border-radius: 14px;
    box-shadow: 0 3px 14px rgba(18,59,74,.035);
}

.el-borrow-history .bh-panel-head {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    flex-wrap: wrap;
    gap: 12px;
    margin-bottom: 20px;
}

.el-borrow-history .bh-panel-head h2 {
    margin: 0 0 6px;
    color: var(--bh-primary);
    font-size: 18px;
    font-weight: 800;
}

.el-borrow-history .bh-panel-head p {
    margin: 0;
    color: var(--bh-muted);
    font-size: 12px;
    line-height: 1.6;
}

.el-borrow-history .bh-tag {
    display: inline-flex;
    padding: 7px 11px;
    border-radius: 8px;
    background: #E9F6F6;
    color: #126E73;
    font-size: 11px;
    font-weight: 750;
}

/* ==========================================
   FILTERS
========================================== */

.el-borrow-history .bh-filters {
    display: grid;
    grid-template-columns:
        repeat(4, minmax(0,1fr));
    gap: 14px;
    padding: 17px;
    background: var(--bh-soft);
    border: 1px solid var(--bh-border);
    border-radius: 11px;
}

.el-borrow-history .bh-field {
    min-width: 0;
}

.el-borrow-history .bh-search {
    grid-column: span 2;
}

.el-borrow-history .bh-field label {
    display: block;
    margin-bottom: 7px;
    color: #375968;
    font-size: 12px;
    font-weight: 700;
}

.el-borrow-history .bh-field input,
.el-borrow-history .bh-field select {
    display: block;
    width: 100%;
    min-height: 41px;
    padding: 9px 12px;
    border: 1px solid #CFE1E4;
    border-radius: 8px;
    background: #FFFFFF;
    color: var(--bh-primary);
    font-size: 12px;
}

.el-borrow-history .bh-field input:focus,
.el-borrow-history .bh-field select:focus {
    outline: none;
    border-color: var(--bh-accent);
    box-shadow: 0 0 0 3px rgba(22,138,145,.12);
}

.el-borrow-history .bh-filter-actions {
    grid-column: 1 / -1;
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 9px;
}

.el-borrow-history .bh-filter-note {
    color: var(--bh-muted);
    font-size: 11px;
    line-height: 1.5;
}

/* ==========================================
   FILTER ERRORS
========================================== */

.el-borrow-history .br-message {
    display: block;
    margin: 15px 0;
    padding: 13px 16px;
    border: 1px solid #F2D3CF;
    border-left: 4px solid #C34D46;
    border-radius: 9px;
    background: #FFF0EF;
    color: #9E3E39;
    font-size: 12px;
    line-height: 1.7;
}

.el-borrow-history .br-message:empty {
    display: none;
}

/* ==========================================
   RESULT COUNT
========================================== */

.el-borrow-history .bh-result-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;
    margin: 17px 0 13px;
    color: var(--bh-muted);
    font-size: 12px;
}

/* ==========================================
   TABLE
========================================== */

.el-borrow-history .bh-table-wrap {
    width: 100%;
    overflow-x: auto;
    border: 1px solid var(--bh-border);
    border-radius: 10px;
    -webkit-overflow-scrolling: touch;
}

.el-borrow-history .bh-table {
    width: 100%;
    min-width: 790px;
    border-collapse: collapse;
    background: #FFFFFF;
    font-size: 12px;
}

.el-borrow-history .bh-table th {
    padding: 14px 12px;
    background: var(--bh-soft);
    border-bottom: 1px solid var(--bh-border);
    color: #496B75;
    font-size: 11px;
    font-weight: 800;
    text-align: left;
    white-space: nowrap;
}

.el-borrow-history .bh-table td {
    padding: 14px 12px;
    border-bottom: 1px solid #EDF3F4;
    color: #47616D;
    vertical-align: middle;
}

.el-borrow-history .bh-table tr:hover td {
    background: #F9FCFC;
}

.el-borrow-history .bh-record {
    display: flex;
    flex-direction: column;
    gap: 5px;
    min-width: 0;
}

.el-borrow-history .bh-record strong {
    color: var(--bh-primary);
    font-size: 12px;
    font-weight: 800;
    overflow-wrap: anywhere;
}

.el-borrow-history .bh-record small {
    color: var(--bh-muted);
    font-size: 11px;
    overflow-wrap: anywhere;
}

.el-borrow-history .bh-record-id {
    color: var(--bh-primary);
    font-weight: 800;
}

/* ==========================================
   STATUS BADGES
========================================== */

.el-borrow-history .br-pill {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 6px 10px;
    border-radius: 999px;
    background: #E7F5F5;
    color: #126E73;
    font-size: 11px;
    font-weight: 750;
    white-space: nowrap;
}

.el-borrow-history .br-pill.success {
    background: #E6F6EE;
    color: #237C62;
}

.el-borrow-history .br-pill.danger {
    background: #FCE9E7;
    color: #A63D39;
}

.el-borrow-history .br-pill.cancelled {
    background: #EDF2F4;
    color: #59717C;
}

/* ==========================================
   EXPANDABLE RECORD DETAILS
========================================== */

.el-borrow-history .bh-details {
    position: relative;
    min-width: 160px;
}

.el-borrow-history .bh-details summary {
    display: inline-flex;
    align-items: center;
    justify-content: space-between;
    gap: 13px;
    min-height: 34px;
    padding: 7px 11px;
    background: #EAF6F6;
    border: 1px solid #CDE7E9;
    border-radius: 8px;
    color: #126E73;
    font-size: 11px;
    font-weight: 750;
    cursor: pointer;
    list-style: none;
    white-space: nowrap;
}

.el-borrow-history .bh-details summary::-webkit-details-marker {
    display: none;
}

.el-borrow-history .bh-details summary::after {
    content: "⌄";
    font-size: 15px;
    line-height: 1;
}

.el-borrow-history .bh-details[open] summary::after {
    content: "⌃";
}

.el-borrow-history .bh-details summary:hover {
    background: #DDF0F1;
    border-color: #B6DADB;
}

.el-borrow-history .bh-details-content {
    width: min(520px, 74vw);
    max-width: 520px;
    margin-top: 12px;
    padding: 16px;
    background: #F7FBFB;
    border: 1px solid var(--bh-border);
    border-radius: 10px;
    box-shadow: 0 5px 15px rgba(18,59,74,.045);
}

.el-borrow-history .bh-details-title {
    display: block;
    margin-bottom: 14px;
    color: var(--bh-primary);
    font-size: 13px;
    font-weight: 800;
}

.el-borrow-history .bh-detail-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0,1fr));
    gap: 13px;
}

.el-borrow-history .bh-detail-item {
    display: flex;
    flex-direction: column;
    gap: 5px;
    min-width: 0;
}

.el-borrow-history .bh-detail-item.wide {
    grid-column: 1 / -1;
}

.el-borrow-history .bh-detail-item span {
    color: var(--bh-muted);
    font-size: 10px;
    font-weight: 700;
}

.el-borrow-history .bh-detail-item strong {
    color: var(--bh-primary);
    font-size: 12px;
    font-weight: 750;
    line-height: 1.5;
    overflow-wrap: anywhere;
    white-space: normal;
}

.el-borrow-history .bh-detail-item .bh-fee {
    color: var(--bh-danger);
}

.el-borrow-history .bh-details-divider {
    grid-column: 1 / -1;
    margin: 2px 0;
    border-top: 1px solid var(--bh-border);
}

.el-borrow-history .bh-details-note {
    margin: 14px 0 0;
    color: var(--bh-muted);
    font-size: 11px;
    line-height: 1.6;
}

/* ==========================================
   PAGINATION / FOOTNOTE
========================================== */

.el-borrow-history .bh-pager {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 12px;
    padding-top: 20px;
    color: var(--bh-muted);
    font-size: 12px;
}

.el-borrow-history .bh-info {
    padding: 15px 18px;
    border: 1px solid #D2E7E8;
    border-radius: 10px;
    background: #EAF6F6;
    color: #315D67;
    font-size: 12px;
    line-height: 1.7;
}

.el-borrow-history .bh-info strong {
    color: var(--bh-primary);
}

/* ==========================================
   RESPONSIVE
========================================== */

@media (max-width: 1100px) {
    .el-borrow-history .bh-filters {
        grid-template-columns: repeat(2, minmax(0,1fr));
    }

    .el-borrow-history .bh-search {
        grid-column: 1 / -1;
    }
}

@media (max-width: 650px) {
    .el-borrow-history .bh-header h1 {
        font-size: 24px;
    }

    .el-borrow-history .bh-panel {
        padding: 15px;
    }

    .el-borrow-history .bh-filters {
        grid-template-columns: 1fr;
        padding: 12px;
    }

    .el-borrow-history .bh-search {
        grid-column: auto;
    }

    .el-borrow-history .bh-header-actions {
        width: 100%;
    }

    .el-borrow-history .bh-header-actions .bh-btn {
        flex: 1;
    }

    .el-borrow-history .bh-filter-actions .bh-btn {
        flex: 1;
    }

    .el-borrow-history .bh-detail-grid {
        grid-template-columns: 1fr;
    }

    .el-borrow-history .bh-detail-item.wide,
    .el-borrow-history .bh-details-divider {
        grid-column: auto;
    }
}

@media (prefers-reduced-motion: reduce) {
    .el-borrow-history .bh-btn {
        transition: none;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="el-borrow-history">

    <!-- PAGE HEADER -->

    <header class="bh-header">

        <div>
            <span class="bh-eyebrow">
                ADMINISTRATION / BORROWING MANAGEMENT
            </span>

            <h1>Borrowing History</h1>

            <p>
                Review completed returns, lost books,
                cancelled reservations, and transaction details.
            </p>
        </div>

        <div class="bh-header-actions">

            <asp:Button
                ID="btnRefresh"
                runat="server"
                Text="↻ Refresh"
                CssClass="bh-btn bh-btn-primary"
                CausesValidation="false"
                OnClick="btnRefresh_Click" />

            <asp:HyperLink
                runat="server"
                NavigateUrl="~/Admin/Borrowing/ManageBorrows.aspx"
                CssClass="bh-btn"
                Text="Manage Borrowings" />

            <asp:HyperLink
                runat="server"
                NavigateUrl="~/Admin/Borrowing/OverdueBooks.aspx"
                CssClass="bh-btn"
                Text="Overdue Books" />

        </div>

    </header>

    <!-- HISTORY PANEL -->

    <section class="bh-panel">

        <div class="bh-panel-head">

            <div>
                <h2>Borrowing Records</h2>

                <p>
                    Find historical transactions and expand
                    individual records to view their details.
                </p>
            </div>

            <span class="bh-tag">
                Historical Records
            </span>

        </div>

        <!-- SEARCH FILTERS -->

        <asp:Panel
            ID="pnlFilters"
            runat="server"
            DefaultButton="btnApply"
            CssClass="bh-filters">

            <div class="bh-field bh-search">

                <asp:Label
                    runat="server"
                    AssociatedControlID="txtSearch"
                    Text="Search History" />

                <asp:TextBox
                    ID="txtSearch"
                    runat="server"
                    MaxLength="255"
                    autocomplete="off"
                    placeholder="Search ID, customer, email, book..." />

            </div>

            <div class="bh-field">

                <asp:Label
                    runat="server"
                    AssociatedControlID="ddlStatus"
                    Text="Record Status" />

                <asp:DropDownList
                    ID="ddlStatus"
                    runat="server">

                    <asp:ListItem
                        Text="All Statuses"
                        Value="All" />

                    <asp:ListItem
                        Text="Returned"
                        Value="Returned" />

                    <asp:ListItem
                        Text="Lost"
                        Value="Lost" />

                    <asp:ListItem
                        Text="Cancelled"
                        Value="Cancelled" />

                </asp:DropDownList>

            </div>

            <div class="bh-field">

                <asp:Label
                    runat="server"
                    AssociatedControlID="ddlSort"
                    Text="Sort By" />

                <asp:DropDownList
                    ID="ddlSort"
                    runat="server">

                    <asp:ListItem
                        Text="Default Order"
                        Value="Default" />

                    <asp:ListItem
                        Text="Recently Reserved"
                        Value="BorrowDesc" />

                    <asp:ListItem
                        Text="Oldest Reserved"
                        Value="BorrowAsc" />

                    <asp:ListItem
                        Text="Highest ID First"
                        Value="IDDesc" />

                    <asp:ListItem
                        Text="Lowest ID First"
                        Value="IDAsc" />

                </asp:DropDownList>

            </div>

            <div class="bh-field">

                <asp:Label
                    runat="server"
                    AssociatedControlID="txtDateFrom"
                    Text="Reserved From" />

                <asp:TextBox
                    ID="txtDateFrom"
                    runat="server"
                    TextMode="Date" />

            </div>

            <div class="bh-field">

                <asp:Label
                    runat="server"
                    AssociatedControlID="txtDateTo"
                    Text="Reserved To" />

                <asp:TextBox
                    ID="txtDateTo"
                    runat="server"
                    TextMode="Date" />

            </div>

            <div class="bh-filter-actions">

                <asp:Button
                    ID="btnApply"
                    runat="server"
                    Text="Apply Filters"
                    CssClass="bh-btn bh-btn-primary"
                    CausesValidation="false"
                    OnClick="btnApply_Click" />

                <asp:Button
                    ID="btnClearFilters"
                    runat="server"
                    Text="Clear"
                    CssClass="bh-btn"
                    CausesValidation="false"
                    OnClick="btnClearFilters_Click" />

                <span class="bh-filter-note">
                    Press Enter or Apply to search.
                </span>

            </div>

        </asp:Panel>

        <!-- LOCAL SEARCH AND VALIDATION ERRORS -->

        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="br-message"
            role="alert" />

        <!-- RESULT COUNT -->

        <div class="bh-result-bar">

            <asp:Label
                ID="lblResultCount"
                runat="server"
                Text="Showing borrowing history" />

            <span>
                Select View Details for full record information.
            </span>

        </div>

        <!-- HISTORY TABLE -->

        <div class="bh-table-wrap">

            <asp:GridView
                ID="gvHistory"
                runat="server"
                AutoGenerateColumns="False"
                GridLines="None"
                CssClass="bh-table"
                EmptyDataText="No borrowing history matches your filters.">

                <Columns>

                    <asp:TemplateField HeaderText="Borrow ID">
                        <ItemTemplate>

                            <span class="bh-record-id">
                                #<%#: Eval("BorrowLogID") %>
                            </span>

                        </ItemTemplate>
                    </asp:TemplateField>

                    

                    <asp:TemplateField HeaderText="Customer">
                        <ItemTemplate>

                            <div class="bh-record">

                                <strong>
                                    <%#: Eval("FullName") %>
                                </strong>

                                <small>
                                    <%#: Eval("Email") %>
                                </small>

                            </div>

                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Book">
                        <ItemTemplate>

                            <div class="bh-record">

                                <strong>
                                    <%#: Eval("Title") %>
                                </strong>

                            </div>

                        </ItemTemplate>
                    </asp:TemplateField>


                    <asp:TemplateField HeaderText="Reserved">
                        <ItemTemplate>

                            <%#: FormatHistoryDate(
                                Eval("DateBorrowed")) %>

                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>

                            <span class='<%# GetStatusClass(
                                Eval("DisplayStatus")) %>'>

                                <%#: Eval("DisplayStatus") %>

                            </span>

                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Details">
                        <ItemTemplate>

                            <details class="bh-details">

                                <summary>
                                    View Details
                                </summary>

                                <div class="bh-details-content">

                                    <strong class="bh-details-title">
                                        Borrowing #<%#: Eval("BorrowLogID") %>
                                    </strong>

                                    <div class="bh-detail-grid">


                                        <div class="bh-detail-item">

                                            <span>
                                                Date Reserved
                                            </span>

                                            <strong>
                                                <%#: FormatHistoryDate(
                                                    Eval("DateBorrowed")) %>
                                            </strong>

                                        </div>

                                        <div class="bh-detail-item">

                                            <span>
                                                Date Collected
                                            </span>

                                            <strong>
                                                <%#: FormatHistoryDate(
                                                    Eval("DateCollected")) %>
                                            </strong>

                                        </div>

                                        <!-- DUE DATE -->

                                        <div class="bh-detail-item">

                                            <span>
                                                Due Date
                                            </span>

                                            <strong>
                                                <%#: FormatHistoryDate(
                                                    Eval("DueDate")) %>
                                            </strong>

                                        </div>

                                        <!-- RETURNED -->

                                        <div class="bh-detail-item">

                                            <span>
                                                Date Returned
                                            </span>

                                            <strong>
                                                <%#: FormatHistoryDate(
                                                    Eval("DateReturned")) %>
                                            </strong>

                                        </div>

                                        <!-- CANCELLED -->

                                        <div class="bh-detail-item">

                                            <span>
                                                Date Cancelled
                                            </span>

                                            <strong>
                                                <%#: FormatHistoryDate(
                                                    Eval("DateCancelled")) %>
                                            </strong>

                                        </div>

                                        <!-- LOST DATE -->

                                        <div class="bh-detail-item">

                                            <span>
                                                Date Marked Lost
                                            </span>

                                            <strong>
                                                <%# Convert.ToString(
                                                    Eval("DisplayStatus")) == "Lost"
                                                    ? Server.HtmlEncode(
                                                        FormatHistoryDate(
                                                            Eval("LostDate")))
                                                    : "—" %>
                                            </strong>

                                        </div>

                                        <!-- CANCELLATION REASON -->

                                        <div class="bh-detail-item wide">

                                            <span>
                                                Cancellation Reason
                                            </span>

                                            <strong>
                                                <%# Convert.ToString(
                                                    Eval("DisplayStatus")) == "Cancelled"
                                                    ? Server.HtmlEncode(
                                                        Convert.ToString(
                                                            Eval("CancellationReason")))
                                                    : "—" %>
                                            </strong>

                                        </div>

                                        <div class="bh-details-divider"></div>

                                        <!-- LOSS REASON -->

                                        <div class="bh-detail-item wide">

                                            <span>
                                                Loss Reason
                                            </span>

                                            <strong>
                                                <%# Convert.ToString(
                                                    Eval("DisplayStatus")) == "Lost"
                                                    ? Server.HtmlEncode(
                                                        Convert.ToString(
                                                            Eval("LostReason")))
                                                    : "—" %>
                                            </strong>

                                        </div>

                                        <!-- REPLACEMENT FEE -->

                                        <div class="bh-detail-item">

                                            <span>
                                                Replacement Fee (PHP)
                                            </span>

                                            <strong class="bh-fee">
                                                <%# Convert.ToString(
                                                    Eval("DisplayStatus")) == "Lost"
                                                    && Eval("ReplacementFeeAmount") != DBNull.Value
                                                    ? "₱" +
                                                        Convert.ToDecimal(
                                                            Eval("ReplacementFeeAmount"))
                                                            .ToString("N2")
                                                    : "—" %>
                                            </strong>

                                        </div>

                                        <!-- RECORDED BY -->

                                        <div class="bh-detail-item">

                                            <span>
                                                Marked Lost By
                                            </span>

                                            <strong>
                                                <%# Convert.ToString(
                                                    Eval("DisplayStatus")) == "Lost"
                                                    ? Server.HtmlEncode(
                                                        string.IsNullOrWhiteSpace(
                                                            Convert.ToString(
                                                                Eval("MarkedLostByName")))
                                                            ? "Unknown librarian"
                                                            : Convert.ToString(
                                                                Eval("MarkedLostByName")))
                                                    : "—" %>
                                            </strong>

                                        </div>

                                    </div>

                                    <p class="bh-details-note">
                                        Replacement fees represent charges,
                                        not confirmed payments.
                                        Payment status is managed separately.
                                    </p>

                                </div>

                            </details>

                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

            </asp:GridView>

        </div>

        <!-- PAGINATION -->

        <div class="bh-pager">

            <asp:Button
                ID="btnPrevious"
                runat="server"
                Text="← Previous"
                CssClass="bh-btn"
                CausesValidation="false"
                OnClick="btnPrevious_Click" />

            <asp:Label
                ID="lblPageInfo"
                runat="server"
                Text="Page 1 of 1" />

            <asp:Button
                ID="btnNext"
                runat="server"
                Text="Next →"
                CssClass="bh-btn"
                CausesValidation="false"
                OnClick="btnNext_Click" />

        </div>

    </section>

    <!-- INFORMATION NOTE -->

    <aside class="bh-info">

        <strong>Borrowing History:</strong>
        This page displays completed borrowing records,
        including returned books, cancelled reservations,
        and customer-reported lost books.

        Replacement fees shown in the details represent
        charges recorded against customers. They do not
        confirm payment. Use the Transactions module
        to review payment information.

    </aside>

</div>

</asp:Content>
