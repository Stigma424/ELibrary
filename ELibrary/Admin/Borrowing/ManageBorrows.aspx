
<%@ Page Title="Manage Borrowings"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ManageBorrows.aspx.cs"
    Inherits="ELibrary.Admin.Borrowing.ManageBorrows" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* ==============================================
   INTERNSHIPELIB - OCEAN TEAL
   MANAGE BORROWINGS UI-3C
============================================== */

.el-admin-borrowing {
    --br-primary: #123B4A;
    --br-accent: #168A91;
    --br-hover: #12757C;
    --br-muted: #647F89;
    --br-border: #DCE9EB;
    --br-soft: #F5FAFA;
    --br-danger: #B94E49;
    color: var(--br-primary);
    display: flex;
    flex-direction: column;
    gap: 21px;
    min-width: 0;
}

.el-admin-borrowing * {
    box-sizing: border-box;
}

.el-admin-borrowing .br-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 15px;
    padding: 4px 0;
}

.el-admin-borrowing .br-eyebrow {
    display: block;
    color: var(--br-accent);
    font-size: 10px;
    font-weight: 800;
    letter-spacing: .12em;
    margin-bottom: 8px;
}

.el-admin-borrowing .br-header h1 {
    font-size: 29px;
    font-weight: 800;
    margin: 0 0 7px;
    color: var(--br-primary);
}

.el-admin-borrowing .br-header p,
.el-admin-borrowing .br-panel-head p {
    color: var(--br-muted);
    font-size: 12px;
    line-height: 1.7;
    margin: 0;
}

.el-admin-borrowing .br-links {
    display: flex;
    gap: 9px;
    flex-wrap: wrap;
}

.el-admin-borrowing .br-btn {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    min-height: 40px;
    padding: 9px 15px;
    color: var(--br-primary);
    border: 1px solid var(--br-border);
    border-radius: 9px;
    background: #FFFFFF;
    font-size: 12px;
    font-weight: 750;
    text-decoration: none;
    cursor: pointer;
    transition: background .2s, border-color .2s;
}

.el-admin-borrowing .br-btn:hover {
    background: #EAF5F6;
    border-color: #B4DADD;
    color: var(--br-primary);
}

.el-admin-borrowing .br-btn-primary {
    background: var(--br-accent);
    border-color: var(--br-accent);
    color: #FFFFFF;
}

.el-admin-borrowing .br-btn-primary:hover {
    color: #FFFFFF;
    background: var(--br-hover);
    border-color: var(--br-hover);
}

.el-admin-borrowing .br-btn:disabled {
    opacity: .45;
    cursor: default;
}

.el-admin-borrowing .br-panel {
    min-width: 0;
    padding: 23px;
    border-radius: 14px;
    background: #FFFFFF;
    border: 1px solid var(--br-border);
    box-shadow: 0 3px 14px rgba(18,59,74,.035);
    scroll-margin-top: 95px;
}

.el-admin-borrowing .br-panel-head {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    flex-wrap: wrap;
    gap: 13px;
    margin-bottom: 19px;
}

.el-admin-borrowing .br-panel-head h2 {
    margin: 0 0 5px;
    font-size: 18px;
    font-weight: 800;
    color: var(--br-primary);
}

.el-admin-borrowing .br-tag {
    display: inline-flex;
    padding: 7px 11px;
    border-radius: 8px;
    background: #E9F6F6;
    color: #126E73;
    font-size: 11px;
    font-weight: 750;
}

.el-admin-borrowing .br-filters {
    display: grid;
    grid-template-columns:
        minmax(200px, 2fr)
        repeat(2, minmax(150px, 1fr))
        auto;
    align-items: end;
    gap: 12px;
    padding: 16px;
    background: var(--br-soft);
    border: 1px solid var(--br-border);
    border-radius: 11px;
}

.el-admin-borrowing .br-field {
    min-width: 0;
}

.el-admin-borrowing .br-field label {
    display: block;
    color: #375968;
    font-size: 12px;
    font-weight: 700;
    margin-bottom: 7px;
}

.el-admin-borrowing .br-field input,
.el-admin-borrowing .br-field select,
.el-admin-borrowing .br-field textarea {
    display: block;
    width: 100%;
    min-height: 41px;
    padding: 9px 12px;
    border: 1px solid #CFE1E4;
    border-radius: 8px;
    background: #FFFFFF;
    color: var(--br-primary);
    font-size: 12px;
}

.el-admin-borrowing .br-field textarea {
    min-height: 105px;
    resize: vertical;
}

.el-admin-borrowing .br-field input:focus,
.el-admin-borrowing .br-field select:focus,
.el-admin-borrowing .br-field textarea:focus {
    outline: none;
    border-color: var(--br-accent);
    box-shadow: 0 0 0 3px rgba(22,138,145,.12);
}

.el-admin-borrowing .br-filter-actions {
    display: flex;
    gap: 8px;
    align-items: center;
}

.el-admin-borrowing .br-result-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;
    margin: 15px 0 13px;
    color: var(--br-muted);
    font-size: 12px;
}

.el-admin-borrowing .br-table-scroll {
    width: 100%;
    overflow-x: auto;
    border: 1px solid var(--br-border);
    border-radius: 10px;
    -webkit-overflow-scrolling: touch;
}

.el-admin-borrowing .br-table {
    width: 100%;
    min-width: 880px;
    border-collapse: collapse;
    background: #FFFFFF;
    font-size: 12px;
}

.el-admin-borrowing .br-table th {
    text-align: left;
    padding: 14px 12px;
    background: var(--br-soft);
    color: #496B75;
    border-bottom: 1px solid var(--br-border);
    font-size: 11px;
    font-weight: 800;
    white-space: nowrap;
}

.el-admin-borrowing .br-table td {
    padding: 14px 12px;
    vertical-align: middle;
    border-bottom: 1px solid #EDF3F4;
    color: #47616D;
}

.el-admin-borrowing .br-table tr:hover td {
    background: #F9FCFC;
}

.el-admin-borrowing .br-record-main {
    display: flex;
    flex-direction: column;
    gap: 5px;
    min-width: 155px;
}

.el-admin-borrowing .br-record-main strong {
    color: var(--br-primary);
    font-size: 12px;
    font-weight: 800;
    overflow-wrap: anywhere;
}

.el-admin-borrowing .br-record-main small {
    color: var(--br-muted);
    font-size: 11px;
    overflow-wrap: anywhere;
}

.el-admin-borrowing .br-pill {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 999px;
    color: #126E73;
    background: #E7F5F5;
    font-size: 11px;
    font-weight: 750;
    white-space: nowrap;
}

.el-admin-borrowing .br-pill.warning {
    color: #96601B;
    background: #FFF2D9;
}

.el-admin-borrowing .br-pill.danger {
    color: #A63D39;
    background: #FCE9E7;
}

.el-admin-borrowing .br-pill.success {
    color: #237C62;
    background: #E6F6EE;
}

.el-admin-borrowing .br-pill.neutral {
    color: #59717C;
    background: #EDF2F4;
}

.el-admin-borrowing .br-row-actions {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 7px;
    min-width: 170px;
}

.el-admin-borrowing .br-action {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 32px;
    padding: 7px 10px;
    border: 1px solid #CDE7E9;
    border-radius: 7px;
    color: #126E73;
    background: #E9F6F6;
    font-size: 11px;
    font-weight: 750;
    line-height: 1.4;
    text-decoration: none;
    cursor: pointer;
    white-space: nowrap;
}

.el-admin-borrowing .br-action:hover {
    background: #DDF0F1;
    color: #0F6065;
}

.el-admin-borrowing .br-action.success {
    color: #237C62;
    background: #E6F6EE;
    border-color: #C8E8D7;
}

.el-admin-borrowing .br-action.danger {
    color: #B94E49;
    background: #FFF4F3;
    border-color: #F2D8D5;
}

.el-admin-borrowing .br-action.danger:hover {
    background: #FBE7E5;
}

.el-admin-borrowing .br-muted {
    color: #82969D;
    font-size: 11px;
}

.el-admin-borrowing .br-pager {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 12px;
    padding: 20px 0 0;
    font-size: 12px;
    color: var(--br-muted);
}

/* LOCAL OPERATION FEEDBACK */

.el-admin-borrowing .br-message {
    display: block;
    font-size: 12px;
    line-height: 1.7;
    margin-bottom: 16px;
    scroll-margin-top: 100px;
}

.el-admin-borrowing .br-message:empty {
    display: none;
}

.el-admin-borrowing .br-message.success {
    padding: 13px 16px;
    color: #236747;
    background: #E9F7F1;
    border: 1px solid #C8E8D7;
    border-left: 4px solid #28845B;
    border-radius: 8px;
}

.el-admin-borrowing .br-message.error {
    padding: 13px 16px;
    color: #9E3E39;
    background: #FFF0EF;
    border: 1px solid #F2D3CF;
    border-left: 4px solid #C34D46;
    border-radius: 8px;
}

/* SELECTED OPERATION FORM */

.el-admin-borrowing .br-operation-header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 15px;
    margin-bottom: 18px;
}

.el-admin-borrowing .br-operation-record {
    padding: 14px 16px;
    margin-bottom: 17px;
    background: var(--br-soft);
    border: 1px solid var(--br-border);
    border-radius: 9px;
    font-size: 12px;
    color: var(--br-muted);
}

.el-admin-borrowing .br-operation-record strong {
    color: var(--br-primary);
    font-size: 15px;
}

.el-admin-borrowing .br-operation-form {
    max-width: 620px;
}

.el-admin-borrowing .br-operation-form .br-field {
    margin-bottom: 17px;
}

.el-admin-borrowing .br-warning {
    padding: 14px 16px;
    margin-bottom: 18px;
    color: #875C29;
    background: #FFF8EF;
    border: 1px solid #F2D9C0;
    border-radius: 9px;
    font-size: 12px;
    line-height: 1.7;
}

.el-admin-borrowing .br-danger-warning {
    color: #934642;
    background: #FFF5F3;
    border-color: #F1D8D5;
}

.el-admin-borrowing .br-operation-actions {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
    padding-top: 7px;
}

.el-admin-borrowing .br-help {
    display: block;
    margin-top: 7px;
    color: var(--br-muted);
    font-size: 11px;
    line-height: 1.6;
}

@media(max-width:1200px) {
    .el-admin-borrowing .br-filters {
        grid-template-columns: repeat(2, minmax(0,1fr));
    }

    .el-admin-borrowing .br-filter-actions {
        grid-column: 1 / -1;
    }
}

@media(max-width:650px) {
    .el-admin-borrowing .br-header h1 {
        font-size: 24px;
    }

    .el-admin-borrowing .br-panel {
        padding: 15px;
    }

    .el-admin-borrowing .br-filters {
        grid-template-columns: 1fr;
    }

    .el-admin-borrowing .br-filter-actions {
        grid-column: auto;
    }

    .el-admin-borrowing .br-links,
    .el-admin-borrowing .br-operation-actions {
        width: 100%;
    }

    .el-admin-borrowing .br-links .br-btn,
    .el-admin-borrowing .br-operation-actions .br-btn {
        flex: 1;
    }
}

@media(prefers-reduced-motion:reduce) {
    .el-admin-borrowing .br-btn {
        transition: none;
    }
}
</style>
</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="el-admin-borrowing">

    <!-- PAGE HEADER -->

    <header class="br-header">
        <div>
            <span class="br-eyebrow">
                ADMINISTRATION / BORROWING MANAGEMENT
            </span>

            <h1>Manage Borrowings</h1>

            <p>
                Process pickups, confirm returns, and
                manage active library loans.
            </p>
        </div>

        <div class="br-links">
            <asp:Button
                ID="btnRefresh"
                runat="server"
                Text="↻ Refresh"
                CssClass="br-btn br-btn-primary"
                CausesValidation="false"
                OnClick="btnRefresh_Click" />

            <asp:HyperLink
                ID="lnkOverdue"
                runat="server"
                NavigateUrl="~/Admin/Borrowing/OverdueBooks.aspx"
                CssClass="br-btn"
                Text="Overdue Books" />

            <asp:HyperLink
                ID="lnkHistory"
                runat="server"
                NavigateUrl="~/Admin/Borrowing/BorrowHistory.aspx"
                CssClass="br-btn"
                Text="Borrowing History" />
        </div>
    </header>

    <!-- BORROWING RECORDS -->

    <section id="borrowingRecords" class="br-panel">

        <div class="br-panel-head">
            <div>
                <h2>Reservations &amp; Active Loans</h2>
                <p>
                    Select a borrowing to process its
                    collection, return, cancellation, or loss.
                </p>
            </div>

            <span class="br-tag">
                Active Operations
            </span>
        </div>

        <!-- LIST / DIRECT ACTION NOTIFICATIONS -->

        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="br-message"
            role="status"
            aria-live="polite" />

        <!-- SEARCH -->

        <asp:Panel
            ID="pnlFilters"
            runat="server"
            DefaultButton="btnApply"
            CssClass="br-filters">

            <div class="br-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="txtSearch"
                    Text="Search Borrowings" />

                <asp:TextBox
                    ID="txtSearch"
                    runat="server"
                    MaxLength="255"
                    autocomplete="off"
                    placeholder="ID, customer, email or book..." />
            </div>

            <div class="br-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="ddlStatus"
                    Text="Borrow Status" />

                <asp:DropDownList
                    ID="ddlStatus"
                    runat="server">

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

                    <asp:ListItem
                        Text="Return Requested"
                        Value="ReturnRequested" />

                    <asp:ListItem
                        Text="No Return Request"
                        Value="NoReturnRequest" />

                </asp:DropDownList>
            </div>

            <div class="br-field">
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
                        Text="Highest ID First"
                        Value="IDDesc" />

                    <asp:ListItem
                        Text="Lowest ID First"
                        Value="IDAsc" />

                    <asp:ListItem
                        Text="Due Date (Earliest)"
                        Value="DueAsc" />

                    <asp:ListItem
                        Text="Due Date (Latest)"
                        Value="DueDesc" />

                </asp:DropDownList>
            </div>

            <div class="br-filter-actions">
                <asp:Button
                    ID="btnApply"
                    runat="server"
                    Text="Apply"
                    CssClass="br-btn br-btn-primary"
                    CausesValidation="false"
                    OnClick="btnApply_Click" />

                <asp:Button
                    ID="btnClearFilters"
                    runat="server"
                    Text="Clear"
                    CssClass="br-btn"
                    CausesValidation="false"
                    OnClick="btnClearFilters_Click" />
            </div>
        </asp:Panel>

        <div class="br-result-bar">
            <asp:Label
                ID="lblResultCount"
                runat="server"
                Text="Showing borrowings" />

            <span>
                Press Enter or Apply to search and filter.
            </span>
        </div>

        <!-- COMPACT BORROWING TABLE -->

        <div class="br-table-scroll">

            <asp:GridView
                ID="gvBorrows"
                runat="server"
                AutoGenerateColumns="False"
                GridLines="None"
                CssClass="br-table"
                EmptyDataText="No matching active borrowings found."
                OnRowCommand="gvBorrows_RowCommand">

                <Columns>

                    <asp:BoundField
                        DataField="BorrowLogID"
                        HeaderText="Borrow ID" />

                    <asp:TemplateField HeaderText="Customer">
                        <ItemTemplate>
                            <div class="br-record-main">
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
                            <div class="br-record-main">
                                <strong>
                                    <%#: Eval("Title") %>
                                </strong>

                                <small>
                                    <%#: Eval("Author") %>
                                </small>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Dates">
                        <ItemTemplate>
                            <div class="br-record-main">
                                <small>
                                    Reserved:
                                    <%# Convert.ToDateTime(
                                        Eval("DateBorrowed"))
                                        .ToString("MMM dd, yyyy") %>
                                </small>

                                <small>
                                    Due:
                                    <%# Eval("DueDate") == DBNull.Value
                                        ? "Not assigned"
                                        : Convert.ToDateTime(
                                            Eval("DueDate"))
                                            .ToString("MMM dd, yyyy") %>
                                </small>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Collection">
                        <ItemTemplate>
                            <span class='<%#
                                Convert.ToString(
                                    Eval("CollectionStatus")) == "Pending"
                                ? "br-pill warning"
                                : Convert.ToString(
                                    Eval("CollectionStatus")) == "Cancelled"
                                ? "br-pill danger"
                                : "br-pill success" %>'>
                                <%#: Eval("CollectionStatus") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Loan">
                        <ItemTemplate>
                            <span class='<%#
                                Convert.ToString(
                                    Eval("Status")) == "Overdue"
                                ? "br-pill danger"
                                : "br-pill" %>'>
                                <%#: Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Return">
                        <ItemTemplate>
                            <asp:Label
                                ID="lblReturnStatus"
                                runat="server"
                                CssClass="br-pill neutral"
                                Text='<%#
                                    Convert.ToString(
                                        Eval("CollectionStatus")) == "Pending"
                                    ? "Awaiting Pickup"
                                    : Convert.ToString(
                                        Eval("CollectionStatus")) == "Cancelled"
                                    ? "N/A"
                                    : Convert.ToString(
                                        Eval("Status")) == "Returned"
                                    ? "Completed"
                                    : Convert.ToBoolean(
                                        Eval("ReturnRequested"))
                                    ? "Requested"
                                    : "Not Requested" %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="br-row-actions">

                                <!-- PENDING PICKUP -->
                                <asp:PlaceHolder
                                    ID="phPending"
                                    runat="server"
                                    Visible='<%#
                                        Convert.ToString(
                                            Eval("CollectionStatus")) == "Pending"
                                        && Convert.ToString(
                                            Eval("Status")) == "Borrowed" %>'>

                                    <asp:Button
                                        ID="btnConfirmCollection"
                                        runat="server"
                                        Text="Collect"
                                        CssClass="br-action"
                                        CommandName="ConfirmCollection"
                                        CommandArgument='<%# Eval("BorrowLogID") %>'
                                        CausesValidation="false"
                                        OnClientClick="return confirm('Confirm that the customer collected this book? The borrowing period will begin now.');" />

                                    <asp:Button
                                        ID="btnOpenCancel"
                                        runat="server"
                                        Text="Cancel"
                                        CssClass="br-action danger"
                                        CommandName="OpenCancellation"
                                        CommandArgument='<%# Eval("BorrowLogID") %>'
                                        CausesValidation="false" />

                                </asp:PlaceHolder>

                                <!-- COLLECTED ACTIVE LOANS -->
                                <asp:PlaceHolder
                                    ID="phActive"
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

                                    <asp:Button
                                        ID="btnConfirmReturn"
                                        runat="server"
                                        Text="Return"
                                        CssClass="br-action success"
                                        CommandName="ConfirmReturn"
                                        CommandArgument='<%# Eval("BorrowLogID") %>'
                                        CausesValidation="false"
                                        OnClientClick="return confirm('Confirm that the physical book has been returned?');" />

                                    <asp:Button
                                        ID="btnOpenLost"
                                        runat="server"
                                        Text="Mark Lost"
                                        CssClass="br-action danger"
                                        CommandName="OpenLost"
                                        CommandArgument='<%# Eval("BorrowLogID") %>'
                                        CausesValidation="false" />

                                </asp:PlaceHolder>

                                <asp:Label
                                    ID="lblClosed"
                                    runat="server"
                                    CssClass="br-muted"
                                    Text="No actions"
                                    Visible='<%#
                                        Convert.ToString(
                                            Eval("CollectionStatus")) == "Cancelled"
                                        || (
                                            Convert.ToString(
                                                Eval("Status")) != "Borrowed"
                                            && Convert.ToString(
                                                Eval("Status")) != "Overdue"
                                        ) %>' />

                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>

        </div>

        <!-- PAGINATION -->

        <div class="br-pager">
            <asp:Button
                ID="btnPrevious"
                runat="server"
                Text="← Previous"
                CssClass="br-btn"
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
                CssClass="br-btn"
                CausesValidation="false"
                OnClick="btnNext_Click" />
        </div>

    </section>

    <!-- SELECTED ACTION PANEL -->

    <asp:Panel
        ID="pnlSelectedAction"
        runat="server"
        Visible="false"
        ClientIDMode="Static"
        CssClass="br-panel">

        <div class="br-operation-header">

            <div class="br-panel-head" style="margin-bottom:0;">
                <div>
                    <h2>
                        <asp:Label
                            ID="lblActionTitle"
                            runat="server"
                            Text="Selected Borrowing Action" />
                    </h2>

                    <p>
                        <asp:Label
                            ID="lblActionDescription"
                            runat="server" />
                    </p>
                </div>
            </div>

            <asp:Button
                ID="btnCloseAction"
                runat="server"
                Text="Close"
                CssClass="br-btn"
                CausesValidation="false"
                OnClick="btnCloseAction_Click" />
        </div>

        <div class="br-operation-record">
            Selected Borrowing
            <strong>
                #<asp:Label
                    ID="lblSelectedBorrowID"
                    runat="server"
                    Text="0" />
            </strong>
        </div>

        <!-- NOTIFICATION BESIDE SELECTED ACTION -->

        <asp:Label
            ID="lblActionMessage"
            runat="server"
            EnableViewState="false"
            CssClass="br-message"
            role="status"
            aria-live="polite" />

        <!-- CANCELLATION FORM -->

        <asp:Panel
            ID="pnlCancellationForm"
            runat="server"
            Visible="false"
            CssClass="br-operation-form">

            <div class="br-field">
                <label for="<%= txtCancellationReason.ClientID %>">
                    Cancellation Reason *
                </label>

                <asp:TextBox
                    ID="txtCancellationReason"
                    runat="server"
                    TextMode="MultiLine"
                    Rows="4"
                    MaxLength="500"
                    placeholder="Explain why this reservation is being cancelled" />

                <small class="br-help">
                    The reason will be recorded with the cancellation.
                </small>
            </div>

            <div class="br-warning">
                Cancelling this reservation will restore
                one available book copy. Confirm that the
                selected record is the correct reservation.
            </div>

            <div class="br-operation-actions">

                <asp:Button
                    ID="btnConfirmCancellation"
                    runat="server"
                    Text="Confirm Cancellation"
                    CssClass="br-btn br-btn-primary"
                    CausesValidation="false"
                    OnClick="btnConfirmCancellation_Click"
                    OnClientClick="return confirm('Cancel this reservation and restore one available copy?');" />

                <asp:Button
                    ID="btnCancelCancellation"
                    runat="server"
                    Text="Back to Borrowings"
                    CssClass="br-btn"
                    CausesValidation="false"
                    OnClick="btnCloseAction_Click" />

            </div>

        </asp:Panel>

        <!-- LOST BOOK FORM -->

        <asp:Panel
            ID="pnlLostBookForm"
            runat="server"
            Visible="false"
            CssClass="br-operation-form">

            <div class="br-field">
                <label for="<%= txtReplacementFee.ClientID %>">
                    Replacement Fee (PHP) *
                </label>

                <asp:TextBox
                    ID="txtReplacementFee"
                    runat="server"
                    MaxLength="15"
                    autocomplete="off"
                    placeholder="e.g. 500.00" />

                <small class="br-help">
                    Enter an amount greater than zero,
                    with up to two decimal places.
                </small>
            </div>

            <div class="br-field">
                <label for="<%= txtLostReason.ClientID %>">
                    Loss Reason *
                </label>

                <asp:TextBox
                    ID="txtLostReason"
                    runat="server"
                    TextMode="MultiLine"
                    Rows="4"
                    MaxLength="500"
                    placeholder="Describe how the book was lost" />
            </div>

            <div class="br-warning br-danger-warning">
                Marking a borrowed book as lost permanently
                decreases total inventory by one. Available
                copies will not be deducted again.
                A replacement fee will be recorded,
                but no payment is collected by this action.
            </div>

            <div class="br-operation-actions">

                <asp:Button
                    ID="btnConfirmLost"
                    runat="server"
                    Text="Confirm Lost Book"
                    CssClass="br-btn br-btn-primary"
                    CausesValidation="false"
                    OnClick="btnConfirmLost_Click"
                    OnClientClick="return confirm('Mark this borrowed book as LOST and record its replacement fee?');" />

                <asp:Button
                    ID="btnCancelLost"
                    runat="server"
                    Text="Back to Borrowings"
                    CssClass="br-btn"
                    CausesValidation="false"
                    OnClick="btnCloseAction_Click" />

            </div>
        </asp:Panel>

    </asp:Panel>

</div>

<!-- SCROLL TO THE RELEVANT SECTION -->

<asp:HiddenField
    ID="hfFocusTarget"
    runat="server"
    ClientIDMode="Static" />

<script type="text/javascript">
(function () {
    var input = document.getElementById('hfFocusTarget');

    if (!input || !input.value) {
        return;
    }

    var target = document.getElementById(input.value);

    if (!target) {
        return;
    }

    window.requestAnimationFrame(function () {
        target.scrollIntoView({
            behavior: window.matchMedia(
                '(prefers-reduced-motion: reduce)').matches
                ? 'auto' : 'smooth',
            block: 'start'
        });
    });
})();
</script>

</asp:Content>
