
<%@ Page Title="Manage Transactions"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ManageTransactions.aspx.cs"
    Inherits="ELibrary.Admin.Transactions.ManageTransactions" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* ============================================
   INTERNSHIPELIB - OCEAN TEAL
   ADMIN FINANCIAL MANAGEMENT - UI-3H
============================================ */

.el-finance {
    --fin-primary: #123B4A;
    --fin-teal: #168A91;
    --fin-teal-hover: #12757C;
    --fin-muted: #647F89;
    --fin-border: #DCE9EB;
    --fin-soft: #F5FAFA;
    --fin-danger: #B94E49;

    display: flex;
    flex-direction: column;
    gap: 21px;
    min-width: 0;
    padding-bottom: 28px;
    color: var(--fin-primary);
}

.el-finance *,
.el-finance *::before,
.el-finance *::after {
    box-sizing: border-box;
}

.el-finance .fn-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
    padding: 4px 0;
}

.el-finance .fn-eyebrow {
    display: block;
    margin-bottom: 8px;
    color: var(--fin-teal);
    font-size: 10px;
    font-weight: 800;
    letter-spacing: .12em;
}

.el-finance .fn-header h1 {
    margin: 0 0 7px;
    color: var(--fin-primary);
    font-size: 29px;
    font-weight: 800;
}

.el-finance .fn-header p,
.el-finance .fn-panel-head p {
    margin: 0;
    color: var(--fin-muted);
    font-size: 12px;
    line-height: 1.7;
}

.el-finance .fn-top-links {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 9px;
}

.el-finance .fn-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 40px;
    padding: 9px 15px;
    border: 1px solid var(--fin-border);
    border-radius: 9px;
    background: #FFFFFF;
    color: var(--fin-primary);
    font-size: 12px;
    font-weight: 750;
    line-height: 1.5;
    text-decoration: none;
    cursor: pointer;
    white-space: nowrap;
}

.el-finance .fn-btn:hover {
    background: #EAF5F6;
    color: var(--fin-primary);
    border-color: #B4DADD;
    text-decoration: none;
}

.el-finance .fn-btn-primary {
    background: var(--fin-teal);
    border-color: var(--fin-teal);
    color: #FFFFFF;
}

.el-finance .fn-btn-primary:hover {
    background: var(--fin-teal-hover);
    border-color: var(--fin-teal-hover);
    color: #FFFFFF;
}

.el-finance .fn-btn:disabled {
    opacity: .45;
    cursor: default;
}

.el-finance .fn-panel {
    min-width: 0;
    padding: 23px;
    border: 1px solid var(--fin-border);
    border-radius: 14px;
    background: #FFFFFF;
    box-shadow: 0 3px 14px rgba(18,59,74,.035);
    scroll-margin-top: 100px;
}

.el-finance .fn-panel-head {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    flex-wrap: wrap;
    gap: 14px;
    margin-bottom: 19px;
}

.el-finance .fn-panel-head h2 {
    margin: 0 0 6px;
    color: var(--fin-primary);
    font-size: 18px;
    font-weight: 800;
}

.el-finance .fn-tag {
    display: inline-flex;
    padding: 7px 11px;
    border-radius: 8px;
    background: #E9F6F6;
    color: #126E73;
    font-size: 11px;
    font-weight: 750;
}

.el-finance .fn-tag.warning {
    color: #96601B;
    background: #FFF2D9;
}

/* SEARCH AND FILTERS */

.el-finance .fn-filters {
    display: grid;
    grid-template-columns:
        minmax(180px, 2fr)
        repeat(2, minmax(140px, 1fr));
    align-items: end;
    gap: 12px;
    padding: 16px;
    border: 1px solid var(--fin-border);
    border-radius: 11px;
    background: var(--fin-soft);
}

.el-finance .fn-field {
    min-width: 0;
}

.el-finance .fn-field label {
    display: block;
    margin-bottom: 7px;
    color: #375968;
    font-size: 12px;
    font-weight: 700;
}

.el-finance .fn-field input,
.el-finance .fn-field select {
    display: block;
    width: 100%;
    min-height: 41px;
    padding: 9px 12px;
    background: #FFFFFF;
    border: 1px solid #CFE1E4;
    border-radius: 8px;
    color: var(--fin-primary);
    font-size: 12px;
}

.el-finance .fn-field input:focus,
.el-finance .fn-field select:focus {
    outline: none;
    border-color: var(--fin-teal);
    box-shadow: 0 0 0 3px rgba(22,138,145,.12);
}

.el-finance .fn-filter-actions {
    grid-column: 1 / -1;
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 9px;
}

.el-finance .fn-search-note {
    color: var(--fin-muted);
    font-size: 11px;
}

/* CONTEXTUAL NOTIFICATIONS */

.el-finance .fn-message {
    display: block;
    margin: 16px 0;
    font-size: 12px;
    line-height: 1.7;
    scroll-margin-top: 105px;
}

.el-finance .fn-message:empty {
    display: none;
}

.el-finance .fn-message.error {
    padding: 13px 16px;
    color: #9E3E39;
    background: #FFF0EF;
    border: 1px solid #F2D3CF;
    border-left: 4px solid #C34D46;
    border-radius: 9px;
}

.el-finance .fn-message.success {
    padding: 13px 16px;
    color: #236747;
    background: #E9F7F1;
    border: 1px solid #C8E8D7;
    border-left: 4px solid #28845B;
    border-radius: 9px;
}

.el-finance .fn-message.info {
    padding: 13px 16px;
    color: #315D67;
    background: #EAF6F6;
    border: 1px solid #CDE7E9;
    border-left: 4px solid var(--fin-teal);
    border-radius: 9px;
}

/* RESULT TABLES */

.el-finance .fn-result-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
    flex-wrap: wrap;
    margin: 17px 0 13px;
    color: var(--fin-muted);
    font-size: 12px;
}

.el-finance .fn-table-wrap {
    width: 100%;
    overflow-x: auto;
    border: 1px solid var(--fin-border);
    border-radius: 10px;
    -webkit-overflow-scrolling: touch;
}

.el-finance .fn-table {
    width: 100%;
    min-width: 800px;
    border-collapse: collapse;
    background: #FFFFFF;
    font-size: 12px;
}

.el-finance .fn-table th {
    padding: 14px 12px;
    background: var(--fin-soft);
    border-bottom: 1px solid var(--fin-border);
    color: #496B75;
    font-size: 11px;
    font-weight: 800;
    text-align: left;
    white-space: nowrap;
}

.el-finance .fn-table td {
    padding: 14px 12px;
    color: #47616D;
    border-bottom: 1px solid #EDF3F4;
    vertical-align: middle;
}

.el-finance .fn-table tr:hover td {
    background: #F9FCFC;
}

.el-finance .fn-record {
    display: flex;
    flex-direction: column;
    gap: 5px;
    min-width: 130px;
}

.el-finance .fn-record strong {
    color: var(--fin-primary);
    font-size: 12px;
    font-weight: 800;
    overflow-wrap: anywhere;
}

.el-finance .fn-record small {
    color: var(--fin-muted);
    font-size: 11px;
    overflow-wrap: anywhere;
}

.el-finance .fn-money {
    font-weight: 800;
    color: var(--fin-primary);
    white-space: nowrap;
}

.el-finance .fn-money.unpaid {
    color: #A56B1D;
}

.el-finance .fn-money.paid {
    color: #237C62;
}

.el-finance .fn-row-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 34px;
    padding: 7px 12px;
    border: 1px solid #CDE7E9;
    border-radius: 8px;
    color: #126E73;
    background: #EAF6F6;
    font-size: 11px;
    font-weight: 750;
    cursor: pointer;
    white-space: nowrap;
}

.el-finance .fn-row-btn:hover {
    background: #DDF0F1;
    color: #0F6065;
}

.el-finance .fn-row-btn.pay {
    color: #FFFFFF;
    background: var(--fin-teal);
    border-color: var(--fin-teal);
}

.el-finance .fn-row-btn.pay:hover {
    background: var(--fin-teal-hover);
    color: #FFFFFF;
}

/* PAGINATION */

.el-finance .fn-pager {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 12px;
    flex-wrap: wrap;
    padding: 20px 0 0;
    color: var(--fin-muted);
    font-size: 12px;
}

/* RECEIPT DETAIL PANEL */

.el-finance .fn-details-panel {
    padding: 19px;
    margin-top: 20px;
    background: #F7FBFB;
    border: 1px solid #CDE4E6;
    border-radius: 11px;
    scroll-margin-top: 100px;
}

.el-finance .fn-details-title {
    color: var(--fin-primary);
    font-size: 16px;
    font-weight: 800;
}

.el-finance .fn-details-caption {
    display: block;
    margin-top: 6px;
    color: var(--fin-muted);
    font-size: 11px;
}

/* PAYMENT HELP */

.el-finance .fn-info {
    padding: 16px 18px;
    background: #EAF6F6;
    border: 1px solid #D2E7E8;
    border-radius: 10px;
    color: #315D67;
    font-size: 12px;
    line-height: 1.8;
}

.el-finance .fn-info strong {
    color: var(--fin-primary);
}

@media(max-width:1100px) {
    .el-finance .fn-filters {
        grid-template-columns: repeat(2, minmax(0,1fr));
    }

    .el-finance .fn-search-field {
        grid-column: 1 / -1;
    }
}

@media(max-width:650px) {
    .el-finance .fn-header h1 {
        font-size: 24px;
    }

    .el-finance .fn-panel {
        padding: 15px;
    }

    .el-finance .fn-filters {
        grid-template-columns: 1fr;
        padding: 12px;
    }

    .el-finance .fn-search-field {
        grid-column: auto;
    }

    .el-finance .fn-header .fn-top-links,
    .el-finance .fn-filter-actions {
        width: 100%;
    }

    .el-finance .fn-top-links .fn-btn,
    .el-finance .fn-filter-actions .fn-btn {
        flex: 1;
    }

    .el-finance .fn-details-panel {
        padding: 12px;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="el-finance">

    <!-- PAGE HEADER -->

    <header class="fn-header">
        <div>
            <span class="fn-eyebrow">
                ADMINISTRATION / FINANCIAL MANAGEMENT
            </span>

            <h1>Manage Transactions</h1>

            <p>
                Process outstanding fees and review
                customer payment records.
            </p>
        </div>

        <div class="fn-top-links">
            <asp:HyperLink
                runat="server"
                NavigateUrl="~/AdminHome.aspx"
                CssClass="fn-btn"
                Text="← Dashboard" />

            <a href="#transactionHistory"
               class="fn-btn">
                View Transaction History
            </a>
        </div>
    </header>

    <!-- UNPAID FEES FIRST -->

    <section id="unpaidFees"
        class="fn-panel">

        <div class="fn-panel-head">
            <div>
                <h2>Outstanding Payments</h2>
                <p>
                    Find unpaid receipts and record full
                    or partial payments.
                </p>
            </div>

            <span class="fn-tag warning">
                Payment Required
            </span>
        </div>

        <!-- UNPAID SEARCH -->

        <asp:Panel
            ID="pnlUnpaidFilters"
            runat="server"
            DefaultButton="btnUnpaidApply"
            CssClass="fn-filters">

            <div class="fn-field fn-search-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="txtUnpaidSearch"
                    Text="Search Unpaid Fees" />

                <asp:TextBox
                    ID="txtUnpaidSearch"
                    runat="server"
                    MaxLength="255"
                    autocomplete="off"
                    placeholder="Receipt, customer, book..." />
            </div>

            <div class="fn-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="ddlUnpaidFee"
                    Text="Fee Type" />

                <asp:DropDownList
                    ID="ddlUnpaidFee"
                    runat="server">
                    <asp:ListItem
                        Text="All Fee Types"
                        Value="" />
                </asp:DropDownList>
            </div>

            <div class="fn-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="ddlUnpaidSort"
                    Text="Sort By" />

                <asp:DropDownList
                    ID="ddlUnpaidSort"
                    runat="server">
                    <asp:ListItem Text="Default Order" Value="Default" />
                    <asp:ListItem Text="Highest Balance" Value="BalanceDesc" />
                    <asp:ListItem Text="Lowest Balance" Value="BalanceAsc" />
                    <asp:ListItem Text="Newest First" Value="DateDesc" />
                    <asp:ListItem Text="Oldest First" Value="DateAsc" />
                    <asp:ListItem Text="Highest ID First" Value="IDDesc" />
                </asp:DropDownList>
            </div>

            <div class="fn-filter-actions">
                <asp:Button
                    ID="btnUnpaidApply"
                    runat="server"
                    Text="Apply"
                    CssClass="fn-btn fn-btn-primary"
                    CausesValidation="false"
                    OnClick="btnUnpaidApply_Click" />

                <asp:Button
                    ID="btnUnpaidClear"
                    runat="server"
                    Text="Clear"
                    CssClass="fn-btn"
                    CausesValidation="false"
                    OnClick="btnUnpaidClear_Click" />

                <span class="fn-search-note">
                    Press Enter or Apply to search.
                </span>
            </div>

        </asp:Panel>

        <!-- LOCAL UNPAID FEES MESSAGE -->

        <asp:Label
            ID="lblUnpaidMessage"
            runat="server"
            EnableViewState="false"
            CssClass="fn-message"
            role="status"
            aria-live="polite" />

        <div class="fn-result-bar">
            <asp:Label
                ID="lblUnpaidCount"
                runat="server"
                Text="Showing unpaid fees" />

            <span>Balances greater than zero</span>
        </div>

        <div class="fn-table-wrap">
            <asp:GridView
                ID="gvUnpaid"
                runat="server"
                AutoGenerateColumns="False"
                GridLines="None"
                CssClass="fn-table"
                EmptyDataText="No unpaid fees match your filters.">

                <Columns>

                    <asp:TemplateField HeaderText="Receipt">
                        <ItemTemplate>
                            <div class="fn-record">
                                <strong>
                                    <%#: Eval("ReceiptNo") %>
                                </strong>

                                <small>
                                    ID: <%#: Eval("ReceiptID") %>
                                </small>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Customer">
                        <ItemTemplate>
                            <div class="fn-record">
                                <strong>
                                    <%#: Eval("FullName") %>
                                </strong>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Book / Fee">
                        <ItemTemplate>
                            <div class="fn-record">
                                <strong>
                                    <%#: Eval("Title") %>
                                </strong>

                                <small>
                                    <%#: Eval("FeeType") %>
                                </small>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Balance">
                        <ItemTemplate>
                            <span class="fn-money unpaid">
                                ₱<%# Convert.ToDecimal(
                                    Eval("Balance")).ToString("N2") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Amount Paid">
                        <ItemTemplate>
                            <span class="fn-money paid">
                                ₱<%# Convert.ToDecimal(
                                    Eval("AmountPaid")).ToString("N2") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Created">
                        <ItemTemplate>
                            <%# Eval("TransactionDate") == DBNull.Value
                                ? "—"
                                : Convert.ToDateTime(
                                    Eval("TransactionDate"))
                                    .ToString("MMM dd, yyyy") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:Button
                                ID="btnPay"
                                runat="server"
                                Text="Record Payment"
                                CssClass="fn-row-btn pay"
                                CommandName="PayFee"
                                CommandArgument='<%# Eval("ReceiptID") %>'
                                CausesValidation="false"
                                OnCommand="btnPay_Command" />
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

            </asp:GridView>
        </div>

        <div class="fn-pager">
            <asp:Button
                ID="btnUnpaidPrevious"
                runat="server"
                Text="← Previous"
                CssClass="fn-btn"
                CausesValidation="false"
                OnClick="btnUnpaidPrevious_Click" />

            <asp:Label
                ID="lblUnpaidPage"
                runat="server"
                Text="Page 1 of 1" />

            <asp:Button
                ID="btnUnpaidNext"
                runat="server"
                Text="Next →"
                CssClass="fn-btn"
                CausesValidation="false"
                OnClick="btnUnpaidNext_Click" />
        </div>

    </section>

    <!-- TRANSACTION HISTORY -->

    <section id="transactionHistory"
        class="fn-panel">

        <div class="fn-panel-head">
            <div>
                <h2>Transaction History</h2>
                <p>
                    Review receipts and open individual
                    payment records.
                </p>
            </div>

            <span class="fn-tag">
                Financial Records
            </span>
        </div>

        <!-- TRANSACTION SEARCH -->

        <asp:Panel
            ID="pnlHistoryFilters"
            runat="server"
            DefaultButton="btnHistoryApply"
            CssClass="fn-filters">

            <div class="fn-field fn-search-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="txtHistorySearch"
                    Text="Search Transactions" />

                <asp:TextBox
                    ID="txtHistorySearch"
                    runat="server"
                    MaxLength="255"
                    autocomplete="off"
                    placeholder="Receipt, customer, book..." />
            </div>

            <div class="fn-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="ddlHistoryFee"
                    Text="Fee Type" />

                <asp:DropDownList
                    ID="ddlHistoryFee"
                    runat="server">
                    <asp:ListItem
                        Text="All Fee Types"
                        Value="" />
                </asp:DropDownList>
            </div>

            <div class="fn-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="ddlHistoryMethod"
                    Text="Payment Method" />

                <asp:DropDownList
                    ID="ddlHistoryMethod"
                    runat="server">
                    <asp:ListItem Text="All Methods" Value="" />
                    <asp:ListItem Text="Cash" Value="Cash" />
                    <asp:ListItem Text="GCash" Value="GCash" />
                    <asp:ListItem Text="Card" Value="Card" />
                    <asp:ListItem Text="Bank Transfer" Value="Bank Transfer" />
                </asp:DropDownList>
            </div>

            <div class="fn-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="ddlHistorySort"
                    Text="Sort By" />

                <asp:DropDownList
                    ID="ddlHistorySort"
                    runat="server">
                    <asp:ListItem Text="Default Order" Value="Default" />
                    <asp:ListItem Text="Newest First" Value="DateDesc" />
                    <asp:ListItem Text="Oldest First" Value="DateAsc" />
                    <asp:ListItem Text="Highest Balance" Value="BalanceDesc" />
                    <asp:ListItem Text="Lowest Balance" Value="BalanceAsc" />
                    <asp:ListItem Text="Highest Payment" Value="PaidDesc" />
                    <asp:ListItem Text="Highest ID First" Value="IDDesc" />
                </asp:DropDownList>
            </div>

            <div class="fn-filter-actions">
                <asp:Button
                    ID="btnHistoryApply"
                    runat="server"
                    Text="Apply"
                    CssClass="fn-btn fn-btn-primary"
                    CausesValidation="false"
                    OnClick="btnHistoryApply_Click" />

                <asp:Button
                    ID="btnHistoryClear"
                    runat="server"
                    Text="Clear"
                    CssClass="fn-btn"
                    CausesValidation="false"
                    OnClick="btnHistoryClear_Click" />

                <span class="fn-search-note">
                    Press Enter or Apply to search.
                </span>
            </div>

        </asp:Panel>

        <!-- LOCAL TRANSACTION MESSAGE -->

        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="fn-message"
            role="status"
            aria-live="polite" />

        <div class="fn-result-bar">
            <asp:Label
                ID="lblHistoryCount"
                runat="server"
                Text="Showing transactions" />

            <span>
                Select View Payments to inspect a receipt.
            </span>
        </div>

        <div class="fn-table-wrap">
            <asp:GridView
                ID="gvTransactions"
                runat="server"
                AutoGenerateColumns="False"
                GridLines="None"
                CssClass="fn-table"
                EmptyDataText="No transactions match your filters.">

                <Columns>

                    <asp:TemplateField HeaderText="Receipt">
                        <ItemTemplate>
                            <div class="fn-record">
                                <strong>
                                    <%#: Eval("ReceiptNo") %>
                                </strong>
                                <small>
                                    ID: <%#: Eval("ReceiptID") %>
                                </small>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Customer">
                        <ItemTemplate>
                            <div class="fn-record">
                                <strong>
                                    <%#: Eval("FullName") %>
                                </strong>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Book / Fee">
                        <ItemTemplate>
                            <div class="fn-record">
                                <strong>
                                    <%#: Eval("Title") %>
                                </strong>
                                <small>
                                    <%#: Eval("FeeType") %>
                                </small>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Paid">
                        <ItemTemplate>
                            <span class="fn-money paid">
                                ₱<%# Convert.ToDecimal(
                                    Eval("AmountPaid")).ToString("N2") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Balance">
                        <ItemTemplate>
                            <span class="fn-money">
                                ₱<%# Convert.ToDecimal(
                                    Eval("Balance")).ToString("N2") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField
                        DataField="PaymentMethod"
                        HeaderText="Method"
                        NullDisplayText="—" />

                    <asp:TemplateField HeaderText="Date">
                        <ItemTemplate>
                            <%# Eval("TransactionDate") == DBNull.Value
                                ? "—"
                                : Convert.ToDateTime(
                                    Eval("TransactionDate"))
                                    .ToString("MMM dd, yyyy") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Details">
                        <ItemTemplate>
                            <asp:Button
                                ID="btnViewHistory"
                                runat="server"
                                Text="View Payments"
                                CssClass="fn-row-btn"
                                CommandName="ViewPayments"
                                CommandArgument='<%# Eval("ReceiptID") %>'
                                CausesValidation="false"
                                OnCommand="btnViewHistory_Command" />
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

            </asp:GridView>
        </div>

        <div class="fn-pager">
            <asp:Button
                ID="btnHistoryPrevious"
                runat="server"
                Text="← Previous"
                CssClass="fn-btn"
                CausesValidation="false"
                OnClick="btnHistoryPrevious_Click" />

            <asp:Label
                ID="lblHistoryPage"
                runat="server"
                Text="Page 1 of 1" />

            <asp:Button
                ID="btnHistoryNext"
                runat="server"
                Text="Next →"
                CssClass="fn-btn"
                CausesValidation="false"
                OnClick="btnHistoryNext_Click" />
        </div>

        <!-- INDIVIDUAL PAYMENT HISTORY -->

        <asp:Panel
            ID="pnlPaymentHistory"
            runat="server"
            Visible="false"
            ClientIDMode="Static"
            CssClass="fn-details-panel">

            <div class="fn-panel-head">
                <div>
                    <h3 class="fn-details-title">
                        Individual Payment History
                    </h3>

                    <asp:Label
                        ID="lblSelectedReceipt"
                        runat="server"
                        CssClass="fn-details-caption" />
                </div>

                <asp:Button
                    ID="btnClosePaymentHistory"
                    runat="server"
                    Text="Close Details"
                    CssClass="fn-btn"
                    CausesValidation="false"
                    OnClick="btnClosePaymentHistory_Click" />
            </div>

            <asp:Label
                ID="lblPaymentDetailsMessage"
                runat="server"
                EnableViewState="false"
                CssClass="fn-message"
                role="status"
                aria-live="polite" />

            <asp:Label
                ID="lblPaymentHistoryMessage"
                runat="server"
                CssClass="fn-details-caption" />

            <div class="fn-table-wrap">
                <asp:GridView
                    ID="gvPaymentHistory"
                    runat="server"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    CssClass="fn-table"
                    EmptyDataText="No individual payments recorded for this receipt.">

                    <Columns>
                        <asp:BoundField
                            DataField="PaymentID"
                            HeaderText="Payment ID" />

                        <asp:BoundField
                            DataField="AmountPaid"
                            HeaderText="Amount Paid"
                            DataFormatString="₱{0:N2}" />

                        <asp:BoundField
                            DataField="BalanceBefore"
                            HeaderText="Balance Before"
                            DataFormatString="₱{0:N2}" />

                        <asp:BoundField
                            DataField="BalanceAfter"
                            HeaderText="Balance After"
                            DataFormatString="₱{0:N2}" />

                        <asp:BoundField
                            DataField="PaymentMethod"
                            HeaderText="Method" />

                        <asp:BoundField
                            DataField="ProcessedBy"
                            HeaderText="Processed By" />

                        <asp:BoundField
                            DataField="PaymentDate"
                            HeaderText="Date"
                            DataFormatString="{0:MM/dd/yyyy hh:mm tt}" />
                    </Columns>

                </asp:GridView>
            </div>

        </asp:Panel>

    </section>

    <aside class="fn-info">
        <strong>Payment records:</strong>
        Receipt balances and amounts paid are retrieved from
        the database. View Payments shows individual payment
        entries, including partial payments and the librarian
        who processed each transaction.
    </aside>

</div>

<asp:HiddenField
    ID="hfFocusTarget"
    runat="server"
    ClientIDMode="Static" />

<script type="text/javascript">
(function () {
    var input = document.getElementById("hfFocusTarget");

    if (!input || !input.value) {
        return;
    }

    var target = document.getElementById(input.value);

    if (!target) {
        return;
    }

    window.requestAnimationFrame(function () {
        var reduced = window.matchMedia(
            "(prefers-reduced-motion: reduce)").matches;

        target.scrollIntoView({
            behavior: reduced ? "auto" : "smooth",
            block: "start"
        });
    });
})();
</script>

</asp:Content>
