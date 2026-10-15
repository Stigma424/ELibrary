
<%@ Page Title="My Transactions"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="MyTransactions.aspx.cs"
    Inherits="ELibrary.Customer.MyTransactions" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* ==========================================
   COASTAL MINIMAL - MY TRANSACTIONS UI-C5B
========================================== */

.el-customer-mode .coast-transactions {
    --t-ink:#123B4A;
    --t-teal:#168A91;
    --t-muted:#647F89;
    --t-border:#DCE9EB;
    display:flex;
    flex-direction:column;
    gap:23px;
    min-width:0;
    width:100%;
    padding-bottom:35px;
    color:var(--t-ink);
}
.el-customer-mode .coast-transactions * {
    box-sizing:border-box;
}
.el-customer-mode .coast-transactions .t-header {
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:18px;
    flex-wrap:wrap;
    padding:32px 36px;
    border:1px solid #D2E8E9;
    border-radius:20px;
    background:linear-gradient(115deg,#DDEFF0,#F5FAF8);
}
.el-customer-mode .coast-transactions .t-eyebrow {
    display:block;
    margin-bottom:10px;
    color:#13787C;
    font-size:10px;
    font-weight:850;
    letter-spacing:.13em;
}
.el-customer-mode .coast-transactions h1 {
    margin:0 0 9px;
    color:var(--t-ink);
    font-size:clamp(28px,3.6vw,39px);
    font-weight:850;
}
.el-customer-mode .coast-transactions .t-header p,
.el-customer-mode .coast-transactions .t-panel-head p {
    margin:0;
    color:#52737D;
    font-size:12px;
    line-height:1.8;
}
.el-customer-mode .coast-transactions .t-btn {
    display:inline-flex;
    align-items:center;
    justify-content:center;
    min-height:41px;
    padding:10px 16px;
    border:1px solid #CFE3E4;
    border-radius:9px;
    background:white;
    color:var(--t-ink);
    font-size:12px;
    font-weight:800;
    text-decoration:none;
    cursor:pointer;
}
.el-customer-mode .coast-transactions .t-btn:hover {
    background:#EAF6F6;
    color:var(--t-ink);
    text-decoration:none;
}
.el-customer-mode .coast-transactions .t-btn.primary {
    background:var(--t-teal);
    border-color:var(--t-teal);
    color:white;
}
.el-customer-mode .coast-transactions .t-btn.primary:hover {
    background:#12757C;
    color:white;
}
.el-customer-mode .coast-transactions .t-summary {
    display:grid;
    grid-template-columns:repeat(4,minmax(0,1fr));
    gap:14px;
}
.el-customer-mode .coast-transactions .t-stat {
    min-width:0;
    display:flex;
    flex-direction:column;
    gap:12px;
    padding:20px;
    background:white;
    border:1px solid var(--t-border);
    border-radius:14px;
}
.el-customer-mode .coast-transactions .t-stat.highlight {
    background:linear-gradient(115deg,#E4F4F4,#F4FAF9);
    border-color:#C5E4E5;
}
.el-customer-mode .coast-transactions .t-stat-icon {
    display:flex;
    align-items:center;
    justify-content:center;
    width:40px;
    height:40px;
    border-radius:11px;
    background:#EAF6F6;
    color:#168A91;
    font-size:20px;
}
.el-customer-mode .coast-transactions .t-stat-icon.warm {
    background:#FFF2DF;
    color:#A56B1D;
}
.el-customer-mode .coast-transactions .t-stat-label {
    color:var(--t-muted);
    font-size:12px;
    font-weight:700;
    line-height:1.5;
}
.el-customer-mode .coast-transactions .t-stat-value {
    color:var(--t-ink);
    font-size:clamp(20px,2.5vw,29px);
    font-weight:850;
    overflow-wrap:anywhere;
}
.el-customer-mode .coast-transactions .t-panel {
    padding:24px;
    min-width:0;
    background:white;
    border:1px solid var(--t-border);
    border-radius:15px;
}
.el-customer-mode .coast-transactions .t-panel-head {
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:12px;
    flex-wrap:wrap;
    margin-bottom:19px;
}
.el-customer-mode .coast-transactions .t-panel-head h2 {
    margin:0 0 6px;
    color:var(--t-ink);
    font-size:21px;
    font-weight:850;
}
.el-customer-mode .coast-transactions .t-filters {
    padding:17px;
    border:1px solid var(--t-border);
    border-radius:11px;
    background:#F5FAFA;
}
.el-customer-mode .coast-transactions .t-filter-grid {
    display:grid;
    grid-template-columns:minmax(190px,2fr) repeat(3,minmax(125px,1fr));
    gap:13px;
}
.el-customer-mode .coast-transactions .t-field {
    min-width:0;
}
.el-customer-mode .coast-transactions .t-field label {
    display:block;
    margin-bottom:7px;
    color:#375968;
    font-size:12px;
    font-weight:750;
}
.el-customer-mode .coast-transactions .t-input {
    display:block;
    width:100%;
    min-height:42px;
    padding:10px 12px;
    border:1px solid #CFE1E4;
    border-radius:9px;
    background:white;
    color:var(--t-ink);
    font-size:12px;
}
.el-customer-mode .coast-transactions .t-input:focus {
    outline:none;
    border-color:var(--t-teal);
    box-shadow:0 0 0 3px rgba(22,138,145,.12);
}
.el-customer-mode .coast-transactions .t-actions {
    display:flex;
    flex-wrap:wrap;
    align-items:center;
    gap:9px;
    margin-top:15px;
}
.el-customer-mode .coast-transactions .t-help {
    color:var(--t-muted);
    font-size:11px;
}
.el-customer-mode .coast-transactions .el-records-message {
    display:block;
    margin:15px 0;
    font-size:12px;
    line-height:1.75;
}
.el-customer-mode .coast-transactions .el-records-message:empty {
    display:none;
}
.el-customer-mode .coast-transactions .el-records-message.error:not(:empty) {
    padding:13px 16px;
    border:1px solid #F2D3CF;
    border-left:4px solid #C34D46;
    border-radius:9px;
    background:#FFF0EF;
    color:#9E3E39;
}
.el-customer-mode .coast-transactions .t-results {
    display:flex;
    justify-content:space-between;
    align-items:center;
    flex-wrap:wrap;
    gap:10px;
    margin:17px 0 13px;
    color:var(--t-muted);
    font-size:12px;
}
.el-customer-mode .coast-transactions .t-table-wrap {
    width:100%;
    overflow-x:auto;
    border:1px solid var(--t-border);
    border-radius:10px;
}
.el-customer-mode .coast-transactions .t-table {
    width:100%;
    min-width:950px;
    border-collapse:collapse;
    background:white;
    font-size:12px;
}
.el-customer-mode .coast-transactions .t-table th {
    padding:14px 12px;
    border-bottom:1px solid var(--t-border);
    background:#F5FAFA;
    color:#496B75;
    font-size:11px;
    font-weight:800;
    text-align:left;
    white-space:nowrap;
}
.el-customer-mode .coast-transactions .t-table td {
    padding:15px 12px;
    border-bottom:1px solid #EDF3F4;
    color:#47616D;
    vertical-align:middle;
}
.el-customer-mode .coast-transactions .t-table tr:hover td {
    background:#F9FCFC;
}
.el-customer-mode .coast-transactions .t-record {
    display:flex;
    flex-direction:column;
    gap:5px;
    min-width:135px;
}
.el-customer-mode .coast-transactions .t-record strong {
    color:var(--t-ink);
    font-size:12px;
    overflow-wrap:anywhere;
}
.el-customer-mode .coast-transactions .t-record small {
    color:var(--t-muted);
    font-size:11px;
}
.el-customer-mode .coast-transactions .t-money {
    color:var(--t-ink);
    font-weight:850;
    white-space:nowrap;
}
.el-customer-mode .coast-transactions .el-records-balance-unpaid {
    color:#A56B1D;
    font-weight:850;
    white-space:nowrap;
}
.el-customer-mode .coast-transactions .el-records-balance-paid {
    color:#237C62;
    font-weight:850;
    white-space:nowrap;
}
.el-customer-mode .coast-transactions .el-tx-status {
    display:inline-flex;
    align-items:center;
    padding:7px 11px;
    border-radius:999px;
    font-size:11px;
    font-weight:800;
    white-space:nowrap;
}
.el-customer-mode .coast-transactions .el-tx-status-paid {
    color:#237C62;
    background:#E6F6EE;
}
.el-customer-mode .coast-transactions .el-tx-status-unpaid {
    color:#A63D39;
    background:#FCE9E7;
}
.el-customer-mode .coast-transactions .el-tx-status-partial {
    color:#986519;
    background:#FFF2D9;
}
.el-customer-mode .coast-transactions .t-view {
    display:inline-flex;
    justify-content:center;
    align-items:center;
    min-height:35px;
    padding:8px 12px;
    border:1px solid #CDE7E9;
    border-radius:8px;
    background:#EAF6F6;
    color:#126E73;
    font-size:11px;
    font-weight:800;
    cursor:pointer;
    white-space:nowrap;
}
.el-customer-mode .coast-transactions .t-view:hover {
    background:#DDF0F1;
    color:#0F6065;
}
.el-customer-mode .coast-transactions .t-pager td {
    padding:14px;
    text-align:center;
}
.el-customer-mode .coast-transactions .t-pager table {
    margin:0 auto;
}
.el-customer-mode .coast-transactions .t-pager a,
.el-customer-mode .coast-transactions .t-pager span {
    display:inline-block;
    margin:3px;
    padding:7px 11px;
    border:1px solid #CFE3E4;
    border-radius:8px;
    color:#126E73;
    text-decoration:none;
}
.el-customer-mode .coast-transactions .t-pager span {
    color:white;
    background:#168A91;
    border-color:#168A91;
}
.el-customer-mode .coast-transactions .t-payment-panel {
    margin-top:23px;
    padding:20px;
    background:#F7FBFB;
    border:1px solid #CDE4E6;
    border-radius:12px;
    scroll-margin-top:110px;
}
.el-customer-mode .coast-transactions .t-payment-header {
    display:flex;
    justify-content:space-between;
    align-items:center;
    flex-wrap:wrap;
    gap:12px;
    margin-bottom:17px;
}
.el-customer-mode .coast-transactions .t-payment-header h3 {
    margin:0 0 5px;
    font-size:17px;
    font-weight:850;
    color:var(--t-ink);
}
.el-customer-mode .coast-transactions .t-payment-caption {
    color:var(--t-muted);
    font-size:11px;
}
.el-customer-mode .coast-transactions .t-footer {
    margin-top:17px;
    padding-top:16px;
    border-top:1px solid #EDF3F4;
    color:var(--t-muted);
    font-size:11px;
    line-height:1.8;
}
.el-customer-mode .coast-transactions .t-bottom-links {
    display:flex;
    flex-wrap:wrap;
    gap:10px;
}
@media(max-width:1100px) {
    .el-customer-mode .coast-transactions .t-summary {
        grid-template-columns:repeat(2,minmax(0,1fr));
    }
    .el-customer-mode .coast-transactions .t-filter-grid {
        grid-template-columns:repeat(2,minmax(0,1fr));
    }
}
@media(max-width:600px) {
    .el-customer-mode .coast-transactions .t-header {
        padding:25px 20px;
    }
    .el-customer-mode .coast-transactions .t-stat {
        padding:15px;
    }
    .el-customer-mode .coast-transactions .t-summary {
        gap:10px;
    }
    .el-customer-mode .coast-transactions .t-panel {
        padding:15px;
    }
    .el-customer-mode .coast-transactions .t-filters {
        padding:12px;
    }
    .el-customer-mode .coast-transactions .t-filter-grid {
        grid-template-columns:1fr;
    }
    .el-customer-mode .coast-transactions .t-actions .t-btn {
        flex:1;
    }
    .el-customer-mode .coast-transactions .t-payment-panel {
        padding:12px;
    }
}
</style>
</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="coast-transactions">

    <!-- HEADER -->
    <header class="t-header">
        <div>
            <span class="t-eyebrow">PAYMENTS &amp; FEES</span>
            <h1>My Transactions</h1>
            <p>Track library fees, outstanding balances,
               and recorded payments.</p>
        </div>

        <a class="t-btn primary"
            href="<%= ResolveUrl("~/Customer/Books.aspx") %>">
            Browse Books →
        </a>
    </header>

    <!-- OVERVIEW -->
    <section class="t-summary"
        aria-label="Transaction summary">

        <div class="t-stat highlight">
            <div class="t-stat-icon warm"
                aria-hidden="true">₱</div>
            <span class="t-stat-label">Outstanding Balance</span>
            <strong class="t-stat-value">
                ₱<asp:Label ID="lblOutstandingBalance"
                    runat="server" Text="0.00" />
            </strong>
        </div>

        <div class="t-stat">
            <div class="t-stat-icon"
                aria-hidden="true">✓</div>
            <span class="t-stat-label">Total Payments Recorded</span>
            <strong class="t-stat-value">
                ₱<asp:Label ID="lblTotalPaid"
                    runat="server" Text="0.00" />
            </strong>
        </div>

        <div class="t-stat">
            <div class="t-stat-icon warm"
                aria-hidden="true">◷</div>
            <span class="t-stat-label">
                Unpaid / Partial Transactions
            </span>
            <strong class="t-stat-value">
                <asp:Label ID="lblUnpaidCount"
                    runat="server" Text="0" />
            </strong>
        </div>

        <div class="t-stat">
            <div class="t-stat-icon"
                aria-hidden="true">▤</div>
            <span class="t-stat-label">Total Transactions</span>
            <strong class="t-stat-value">
                <asp:Label ID="lblTransactionCount"
                    runat="server" Text="0" />
            </strong>
        </div>

    </section>

    <!-- TRANSACTION LIST -->
    <section class="t-panel">

        <div class="t-panel-head">
            <div>
                <h2>Transaction History</h2>
                <p>Review payment status, fees, and
                   individual receipt payments.</p>
            </div>
        </div>

        <!-- FILTERS -->
        <div class="t-filters">

            <asp:Panel ID="pnlFilters"
                runat="server"
                DefaultButton="btnSearch">

                <div class="t-filter-grid">

                    <div class="t-field">
                        <asp:Label runat="server"
                            AssociatedControlID="txtSearch"
                            Text="Search Transactions" />

                        <asp:TextBox ID="txtSearch"
                            runat="server"
                            CssClass="t-input"
                            MaxLength="255"
                            autocomplete="off"
                            placeholder="Receipt, book or fee..." />
                    </div>

                    <div class="t-field">
                        <asp:Label runat="server"
                            AssociatedControlID="ddlStatus"
                            Text="Payment Status" />

                        <asp:DropDownList ID="ddlStatus"
                            runat="server"
                            CssClass="t-input">

                            <asp:ListItem Text="All Statuses" Value="All" />
                            <asp:ListItem Text="Paid" Value="Paid" />
                            <asp:ListItem Text="Unpaid" Value="Unpaid" />
                            <asp:ListItem Text="Partially Paid" Value="Partial" />

                        </asp:DropDownList>
                    </div>

                    <div class="t-field">
                        <asp:Label runat="server"
                            AssociatedControlID="ddlMethod"
                            Text="Payment Method" />

                        <asp:DropDownList ID="ddlMethod"
                            runat="server"
                            CssClass="t-input">

                            <asp:ListItem Text="All Methods" Value="All" />
                            <asp:ListItem Text="Cash" Value="Cash" />
                            <asp:ListItem Text="GCash" Value="GCash" />
                            <asp:ListItem Text="Card" Value="Card" />
                            <asp:ListItem Text="Bank Transfer" Value="Bank Transfer" />
                            <asp:ListItem Text="Not Set" Value="Not Set" />

                        </asp:DropDownList>
                    </div>

                    <div class="t-field">
                        <asp:Label runat="server"
                            AssociatedControlID="ddlSort"
                            Text="Sort By" />

                        <asp:DropDownList ID="ddlSort"
                            runat="server"
                            CssClass="t-input">

                            <asp:ListItem Text="Newest First" Value="Newest" />
                            <asp:ListItem Text="Oldest First" Value="Oldest" />

                        </asp:DropDownList>
                    </div>

                </div>

                <div class="t-actions">

                    <asp:Button ID="btnSearch"
                        runat="server"
                        Text="Apply Filters"
                        CssClass="t-btn primary"
                        CausesValidation="false"
                        OnClick="btnSearch_Click" />

                    <asp:Button ID="btnClear"
                        runat="server"
                        Text="Clear Filters"
                        CssClass="t-btn"
                        CausesValidation="false"
                        OnClick="btnClear_Click" />

                    <span class="t-help">
                        Press Enter or Apply to search.
                    </span>

                </div>

            </asp:Panel>

        </div>

        <!-- LOCAL ERRORS -->
        <asp:Label ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="el-records-message"
            role="alert" />

        <div class="t-results">
            <asp:Label ID="lblResultCount"
                runat="server"
                Text="Showing transactions" />

            <span>Payment status reflects the remaining balance.</span>
        </div>

        <!-- TRANSACTION TABLE -->
        <div class="t-table-wrap">

            <asp:GridView ID="gvTransactions"
                runat="server"
                AutoGenerateColumns="False"
                GridLines="None"
                CssClass="t-table"
                EmptyDataText="No transactions match your filters."
                AllowPaging="true"
                PageSize="10"
                OnPageIndexChanging="gvTransactions_PageIndexChanging">

                <PagerStyle CssClass="t-pager" />

                <Columns>

                    <asp:TemplateField HeaderText="Receipt">
                        <ItemTemplate>
                            <div class="t-record">
                                <strong>
                                    <%#: Eval("ReceiptNo") %>
                                </strong>
                                <small>
                                    ID: <%#: Eval("ReceiptID") %>
                                </small>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Book / Fee">
                        <ItemTemplate>
                            <div class="t-record">
                                <strong>
                                    <%#: Eval("Title") %>
                                </strong>
                                <small>
                                    <%#: Eval("FeeType") %>
                                </small>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Amount Paid">
                        <ItemTemplate>
                            <span class="t-money">
                                ₱<%# Eval("AmountPaid","{0:N2}") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Balance">
                        <ItemTemplate>
                            <span class='<%# GetBalanceClass(
                                Eval("Balance")) %>'>
                                ₱<%# Eval("Balance","{0:N2}") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='<%# GetPaymentStatusClass(
                                Eval("Balance"),
                                Eval("AmountPaid")) %>'>

                                <%#: GetPaymentStatus(
                                    Eval("Balance"),
                                    Eval("AmountPaid")) %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Method / Date">
                        <ItemTemplate>
                            <div class="t-record">
                                <strong>
                                    <%#: Eval("PaymentMethod") == DBNull.Value
                                        ? "—"
                                        : Eval("PaymentMethod") %>
                                </strong>
                                <small>
                                    <%# Eval("TransactionDate") == DBNull.Value
                                        ? "—"
                                        : Convert.ToDateTime(
                                            Eval("TransactionDate"))
                                            .ToString("MMM dd, yyyy") %>
                                </small>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Details">
                        <ItemTemplate>
                            <asp:Button ID="btnViewPayments"
                                runat="server"
                                Text="View Payments"
                                CssClass="t-view"
                                CommandName="ViewPayments"
                                CommandArgument='<%# Eval("ReceiptID") %>'
                                CausesValidation="false"
                                OnCommand="btnViewPayments_Command" />
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

            </asp:GridView>

        </div>

        <!-- INDIVIDUAL PAYMENT HISTORY -->
        <asp:Panel ID="pnlPaymentHistory"
            runat="server"
            Visible="false"
            ClientIDMode="Static"
            CssClass="t-payment-panel">

            <div class="t-payment-header">
                <div>
                    <h3>Individual Payment History</h3>

                    <asp:Label ID="lblSelectedReceipt"
                        runat="server"
                        CssClass="t-payment-caption" />
                </div>

                <asp:Button ID="btnClosePaymentHistory"
                    runat="server"
                    Text="Close Details"
                    CssClass="t-btn"
                    CausesValidation="false"
                    OnClick="btnClosePaymentHistory_Click" />
            </div>

            <asp:Label ID="lblPaymentHistoryMessage"
                runat="server"
                CssClass="t-payment-caption" />

            <div class="t-table-wrap">

                <asp:GridView ID="gvPaymentHistory"
                    runat="server"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    CssClass="t-table"
                    EmptyDataText="No payments recorded for this receipt.">

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
                            HeaderText="Payment Method" />

                        <asp:BoundField
                            DataField="PaymentDate"
                            HeaderText="Payment Date"
                            DataFormatString="{0:MMM dd, yyyy hh:mm tt}" />

                    </Columns>

                </asp:GridView>

            </div>
        </asp:Panel>

        <div class="t-footer">
            Transaction amounts and payment histories are
            retrieved from library records. If a balance
            remains unpaid, coordinate with the librarian
            regarding payment arrangements.
        </div>

    </section>

    <!-- NAVIGATION -->
    <div class="t-bottom-links">

        <asp:HyperLink ID="lnkBooks"
            runat="server"
            NavigateUrl="~/Customer/Books.aspx"
            CssClass="t-btn primary"
            Text="Browse Books" />

        <asp:HyperLink ID="lnkBorrows"
            runat="server"
            NavigateUrl="~/Customer/MyBorrows.aspx"
            CssClass="t-btn"
            Text="My Borrowings" />

    </div>

</div>

<script type="text/javascript">
(function () {
    var panel = document.getElementById("pnlPaymentHistory");
    if (!panel) return;

    var trigger = document.activeElement;
    if (trigger && trigger.id &&
        trigger.id.indexOf("btnViewPayments") !== -1) {

        panel.scrollIntoView({
            behavior: window.matchMedia(
                "(prefers-reduced-motion: reduce)").matches
                ? "auto" : "smooth",
            block: "start"
        });
    }
})();
</script>

</asp:Content>
