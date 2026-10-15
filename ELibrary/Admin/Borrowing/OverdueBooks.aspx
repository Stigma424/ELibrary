<%@ Page Title="Overdue Books"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="OverdueBooks.aspx.cs"
    Inherits="ELibrary.Admin.Borrowing.OverdueBooks" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* ==============================================
   INTERNSHIPELIB - OCEAN TEAL
   ADMIN OVERDUE BOOKS
============================================== */

.el-overdue-page {
    --ov-primary: #123B4A;
    --ov-accent: #168A91;
    --ov-hover: #12757C;
    --ov-muted: #647F89;
    --ov-border: #DCE9EB;
    --ov-soft: #F5FAFA;
    --ov-danger: #B94E49;
    --ov-warning: #A56B1D;

    display: flex;
    flex-direction: column;
    gap: 22px;
    min-width: 0;
    color: var(--ov-primary);
}

.el-overdue-page *,
.el-overdue-page *::before,
.el-overdue-page *::after {
    box-sizing: border-box;
}

.el-overdue-page .ov-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 16px;
    padding: 4px 0;
}

.el-overdue-page .ov-eyebrow {
    display: block;
    margin-bottom: 8px;
    color: var(--ov-accent);
    font-size: 10px;
    font-weight: 800;
    letter-spacing: .12em;
}

.el-overdue-page .ov-header h1 {
    margin: 0 0 7px;
    color: var(--ov-primary);
    font-size: 29px;
    font-weight: 800;
}

.el-overdue-page .ov-header p {
    margin: 0;
    color: var(--ov-muted);
    font-size: 12px;
    line-height: 1.7;
}

.el-overdue-page .ov-header-actions {
    display: flex;
    gap: 9px;
    flex-wrap: wrap;
}

.el-overdue-page .ov-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 40px;
    padding: 9px 15px;
    border: 1px solid var(--ov-border);
    border-radius: 9px;
    background: #FFFFFF;
    color: var(--ov-primary);
    font-size: 12px;
    font-weight: 750;
    line-height: 1.5;
    text-decoration: none;
    cursor: pointer;
    transition: background .2s, border-color .2s;
}

.el-overdue-page .ov-btn:hover {
    color: var(--ov-primary);
    background: #EAF5F6;
    border-color: #B4DADD;
    text-decoration: none;
}

.el-overdue-page .ov-btn-primary {
    color: #FFFFFF;
    background: var(--ov-accent);
    border-color: var(--ov-accent);
}

.el-overdue-page .ov-btn-primary:hover {
    color: #FFFFFF;
    background: var(--ov-hover);
    border-color: var(--ov-hover);
}

.el-overdue-page .ov-btn:disabled {
    opacity: .45;
    cursor: default;
}

.el-overdue-page .ov-panel {
    min-width: 0;
    padding: 23px;
    background: #FFFFFF;
    border: 1px solid var(--ov-border);
    border-radius: 14px;
    box-shadow: 0 3px 14px rgba(18,59,74,.035);
}

.el-overdue-page .ov-panel-head {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 12px;
    flex-wrap: wrap;
    margin-bottom: 19px;
}

.el-overdue-page .ov-panel-head h2 {
    margin: 0 0 6px;
    color: var(--ov-primary);
    font-size: 18px;
    font-weight: 800;
}

.el-overdue-page .ov-panel-head p {
    margin: 0;
    color: var(--ov-muted);
    font-size: 12px;
    line-height: 1.6;
}

.el-overdue-page .ov-tag {
    display: inline-flex;
    align-items: center;
    padding: 7px 11px;
    border-radius: 8px;
    background: #FCE9E7;
    color: #A63D39;
    font-size: 11px;
    font-weight: 750;
}

.el-overdue-page .ov-filters {
    display: grid;
    grid-template-columns:
        minmax(200px, 2fr)
        repeat(2, minmax(140px, 1fr))
        auto;
    gap: 12px;
    align-items: end;
    padding: 16px;
    background: var(--ov-soft);
    border: 1px solid var(--ov-border);
    border-radius: 11px;
}

.el-overdue-page .ov-field {
    min-width: 0;
}

.el-overdue-page .ov-field label {
    display: block;
    margin-bottom: 7px;
    color: #375968;
    font-size: 12px;
    font-weight: 700;
}

.el-overdue-page .ov-field input,
.el-overdue-page .ov-field select {
    display: block;
    width: 100%;
    min-height: 41px;
    padding: 9px 12px;
    background: #FFFFFF;
    border: 1px solid #CFE1E4;
    border-radius: 8px;
    color: var(--ov-primary);
    font-size: 12px;
}

.el-overdue-page .ov-field input:focus,
.el-overdue-page .ov-field select:focus {
    outline: none;
    border-color: var(--ov-accent);
    box-shadow: 0 0 0 3px rgba(22,138,145,.12);
}

.el-overdue-page .ov-filter-actions {
    display: flex;
    align-items: center;
    gap: 8px;
}

.el-overdue-page .ov-result-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 10px;
    margin: 16px 0 13px;
    color: var(--ov-muted);
    font-size: 12px;
}

.el-overdue-page .ov-message {
    display: block;
    margin-bottom: 16px;
    color: #9E3E39;
    font-size: 12px;
    line-height: 1.7;
}

.el-overdue-page .ov-message:empty {
    display: none;
}

.el-overdue-page .ov-message.error {
    padding: 13px 16px;
    background: #FFF0EF;
    border: 1px solid #F2D3CF;
    border-left: 4px solid #C34D46;
    border-radius: 8px;
}

.el-overdue-page .ov-table-wrap {
    width: 100%;
    overflow-x: auto;
    border: 1px solid var(--ov-border);
    border-radius: 10px;
    -webkit-overflow-scrolling: touch;
}

.el-overdue-page .ov-table {
    width: 100%;
    min-width: 850px;
    border-collapse: collapse;
    background: #FFFFFF;
    font-size: 12px;
}

.el-overdue-page .ov-table th {
    padding: 14px 12px;
    background: var(--ov-soft);
    border-bottom: 1px solid var(--ov-border);
    color: #496B75;
    font-size: 11px;
    font-weight: 800;
    text-align: left;
    white-space: nowrap;
}

.el-overdue-page .ov-table td {
    padding: 14px 12px;
    border-bottom: 1px solid #EDF3F4;
    color: #47616D;
    vertical-align: middle;
}

.el-overdue-page .ov-table tr:hover td {
    background: #F9FCFC;
}

.el-overdue-page .ov-record {
    display: flex;
    flex-direction: column;
    gap: 5px;
    min-width: 125px;
}

.el-overdue-page .ov-record strong {
    color: var(--ov-primary);
    font-size: 12px;
    font-weight: 800;
    overflow-wrap: anywhere;
}

.el-overdue-page .ov-record small {
    color: var(--ov-muted);
    font-size: 11px;
    overflow-wrap: anywhere;
}

.el-overdue-page .ov-days {
    display: inline-block;
    padding: 6px 10px;
    background: #FFF2D9;
    border-radius: 8px;
    color: #96601B;
    font-size: 11px;
    font-weight: 800;
    white-space: nowrap;
}

.el-overdue-page .ov-days.severe {
    color: #A63D39;
    background: #FCE9E7;
}

.el-overdue-page .ov-fee {
    color: var(--ov-danger);
    font-weight: 800;
    white-space: nowrap;
}

.el-overdue-page .ov-pill {
    display: inline-block;
    padding: 6px 10px;
    color: #A63D39;
    background: #FCE9E7;
    border-radius: 999px;
    font-size: 11px;
    font-weight: 750;
    white-space: nowrap;
}

.el-overdue-page .ov-pager {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 12px;
    padding: 20px 0 0;
    color: var(--ov-muted);
    font-size: 12px;
}

.el-overdue-page .ov-info {
    padding: 16px 19px;
    border: 1px solid #D2E7E8;
    border-radius: 11px;
    background: #EAF6F6;
    color: #315D67;
    font-size: 12px;
    line-height: 1.8;
}

.el-overdue-page .ov-info strong {
    color: var(--ov-primary);
}

@media (max-width: 1200px) {
    .el-overdue-page .ov-filters {
        grid-template-columns: repeat(2, minmax(0,1fr));
    }

    .el-overdue-page .ov-search {
        grid-column: 1 / -1;
    }

    .el-overdue-page .ov-filter-actions {
        grid-column: 1 / -1;
    }
}

@media (max-width: 650px) {
    .el-overdue-page .ov-header h1 {
        font-size: 24px;
    }

    .el-overdue-page .ov-panel {
        padding: 15px;
    }

    .el-overdue-page .ov-filters {
        grid-template-columns: 1fr;
        padding: 12px;
    }

    .el-overdue-page .ov-search,
    .el-overdue-page .ov-filter-actions {
        grid-column: auto;
    }

    .el-overdue-page .ov-header-actions {
        width: 100%;
    }

    .el-overdue-page .ov-header-actions .ov-btn {
        flex: 1;
    }

    .el-overdue-page .ov-filter-actions .ov-btn {
        flex: 1;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="el-overdue-page">

    <!-- PAGE HEADER -->
    <header class="ov-header">
        <div>
            <span class="ov-eyebrow">
                ADMINISTRATION / BORROWING MANAGEMENT
            </span>

            <h1>Overdue Books</h1>

            <p>
                Monitor overdue loans, identify outstanding
                returns, and review estimated late fees.
            </p>
        </div>

        <div class="ov-header-actions">
            <asp:Button
                ID="btnRefresh"
                runat="server"
                Text="↻ Refresh"
                CssClass="ov-btn ov-btn-primary"
                CausesValidation="false"
                OnClick="btnRefresh_Click" />

            <asp:HyperLink
                ID="lnkManage"
                runat="server"
                NavigateUrl="~/Admin/Borrowing/ManageBorrows.aspx"
                CssClass="ov-btn"
                Text="Manage Borrowings" />

            <asp:HyperLink
                ID="lnkHistory"
                runat="server"
                NavigateUrl="~/Admin/Borrowing/BorrowHistory.aspx"
                CssClass="ov-btn"
                Text="Borrowing History" />
        </div>
    </header>

    <!-- OVERDUE RESULTS -->
    <section class="ov-panel">

        <div class="ov-panel-head">
            <div>
                <h2>Overdue Records</h2>
                <p>
                    Filter loans by overdue duration,
                    customer, or book information.
                </p>
            </div>

            <span class="ov-tag">
                Past-Due Loans
            </span>
        </div>

        <!-- FILTERS -->
        <asp:Panel
            ID="pnlFilters"
            runat="server"
            DefaultButton="btnApply"
            CssClass="ov-filters">

            <div class="ov-field ov-search">
                <asp:Label
                    runat="server"
                    AssociatedControlID="txtSearch"
                    Text="Search Overdue Books" />

                <asp:TextBox
                    ID="txtSearch"
                    runat="server"
                    MaxLength="255"
                    autocomplete="off"
                    placeholder="Borrow ID, customer, email, book..." />
            </div>

            <div class="ov-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="ddlDuration"
                    Text="Days Overdue" />

                <asp:DropDownList
                    ID="ddlDuration"
                    runat="server">

                    <asp:ListItem
                        Text="All Durations"
                        Value="All" />

                    <asp:ListItem
                        Text="1–7 Days"
                        Value="1-7" />

                    <asp:ListItem
                        Text="8–14 Days"
                        Value="8-14" />

                    <asp:ListItem
                        Text="15–30 Days"
                        Value="15-30" />

                    <asp:ListItem
                        Text="31+ Days"
                        Value="31+" />
                </asp:DropDownList>
            </div>

            <div class="ov-field">
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
                        Text="Most Overdue First"
                        Value="DaysDesc" />

                    <asp:ListItem
                        Text="Least Overdue First"
                        Value="DaysAsc" />

                    <asp:ListItem
                        Text="Due Date (Earliest)"
                        Value="DueAsc" />

                    <asp:ListItem
                        Text="Due Date (Latest)"
                        Value="DueDesc" />

                    <asp:ListItem
                        Text="Highest ID First"
                        Value="IDDesc" />
                </asp:DropDownList>
            </div>

            <div class="ov-filter-actions">
                <asp:Button
                    ID="btnApply"
                    runat="server"
                    Text="Apply"
                    CssClass="ov-btn ov-btn-primary"
                    CausesValidation="false"
                    OnClick="btnApply_Click" />

                <asp:Button
                    ID="btnClearFilters"
                    runat="server"
                    Text="Clear"
                    CssClass="ov-btn"
                    CausesValidation="false"
                    OnClick="btnClearFilters_Click" />
            </div>

        </asp:Panel>

        <!-- LOCAL ERRORS -->
        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="ov-message error"
            role="alert" />

        <div class="ov-result-bar">
            <asp:Label
                ID="lblResultCount"
                runat="server"
                Text="Showing overdue records" />

            <span>
                Press Enter or Apply to search and filter.
            </span>
        </div>

        <!-- COMPACT TABLE -->
        <div class="ov-table-wrap">
            <asp:GridView
                ID="gvOverdue"
                runat="server"
                AutoGenerateColumns="False"
                GridLines="None"
                CssClass="ov-table"
                EmptyDataText="No overdue records match your filters.">

                <Columns>

                    <asp:BoundField
                        DataField="BorrowLogID"
                        HeaderText="Borrow ID" />

                    <asp:TemplateField HeaderText="Customer">
                        <ItemTemplate>
                            <div class="ov-record">
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
                            <div class="ov-record">
                                <strong>
                                    <%#: Eval("Title") %>
                                </strong>
                                <small>
                                    <%#: Eval("Author") %>
                                </small>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Borrowed / Due">
                        <ItemTemplate>
                            <div class="ov-record">
                                <small>
                                    Borrowed:
                                    <%# Eval("DateBorrowed") == DBNull.Value
                                        ? "—"
                                        : Convert.ToDateTime(
                                            Eval("DateBorrowed"))
                                            .ToString("MMM dd, yyyy") %>
                                </small>

                                <strong>
                                    Due:
                                    <%# Eval("DueDate") == DBNull.Value
                                        ? "—"
                                        : Convert.ToDateTime(
                                            Eval("DueDate"))
                                            .ToString("MMM dd, yyyy") %>
                                </strong>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Overdue">
                        <ItemTemplate>
                            <span class='<%#
                                Convert.ToInt32(Eval("DaysOverdue")) >= 8
                                    ? "ov-days severe"
                                    : "ov-days" %>'>

                                <%#: Eval("DaysOverdue") %>
                                day(s)

                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Estimated Fee">
                        <ItemTemplate>
                            <strong class="ov-fee">
                                ₱<%# Convert.ToDecimal(
                                    Eval("EstimatedLateFee"))
                                    .ToString("N2") %>
                            </strong>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class="ov-pill">
                                <%#: Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>
        </div>

        <!-- PAGINATION -->
        <div class="ov-pager">
            <asp:Button
                ID="btnPrevious"
                runat="server"
                Text="← Previous"
                CssClass="ov-btn"
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
                CssClass="ov-btn"
                CausesValidation="false"
                OnClick="btnNext_Click" />
        </div>

    </section>

    <!-- POLICY EXPLANATION -->
    <aside class="ov-info">
        <strong>Late-fee information:</strong>
        The displayed amount is an estimate provided by
        the borrowing system. Actual fees are determined
        by the applicable borrowing and return procedures.
        Use Manage Borrowings to process returned books.
    </aside>

</div>

</asp:Content>
