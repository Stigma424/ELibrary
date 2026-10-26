
<%@ Page Title="Collect Security Deposits"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="CollectDeposits.aspx.cs"
    Inherits="ELibrary.Admin.Transactions.CollectDeposits" %>

<asp:Content ID="HeadContent"
    ContentPlaceHolderID="head"
    runat="server">

<style>
.el-deposit {
    --dp-primary: #123B4A;
    --dp-accent: #168A91;
    --dp-muted: #647F89;
    --dp-border: #DCE9EB;
    --dp-soft: #F5FAFA;
    color: var(--dp-primary);
    max-width: 1160px;
    margin: 0 auto;
    padding: 12px 0 50px;
}
.el-deposit * {
    box-sizing: border-box;
}
.el-deposit .dp-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 16px;
    margin-bottom: 24px;
}
.el-deposit .dp-eyebrow {
    font-size: 11px;
    letter-spacing: .12em;
    font-weight: 800;
    color: var(--dp-accent);
}
.el-deposit h1 {
    font-size: clamp(27px, 4vw, 34px);
    font-weight: 800;
    margin: 8px 0;
}
.el-deposit h2 {
    font-size: 19px;
    margin: 0 0 8px;
    font-weight: 800;
}
.el-deposit p {
    margin: 0;
    color: var(--dp-muted);
    line-height: 1.7;
    font-size: 13px;
}
.el-deposit .dp-card {
    background: #fff;
    border: 1px solid var(--dp-border);
    border-radius: 15px;
    padding: 23px;
    margin-bottom: 18px;
    box-shadow: 0 4px 19px rgba(18,59,74,.04);
}
.el-deposit .dp-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 41px;
    padding: 10px 15px;
    border: 1px solid var(--dp-border);
    border-radius: 9px;
    background: #fff;
    color: var(--dp-primary);
    font-size: 12px;
    font-weight: 800;
    text-decoration: none;
    cursor: pointer;
}
.el-deposit .dp-btn-primary {
    background: var(--dp-accent);
    border-color: var(--dp-accent);
    color: #fff;
}
.el-deposit .dp-btn-primary:hover {
    background: #12757C;
    color: #fff;
}
.el-deposit .dp-btn:disabled {
    opacity: .5;
    cursor: not-allowed;
}
.el-deposit .dp-search {
    display: grid;
    grid-template-columns: minmax(0, 2fr) minmax(140px, 1fr) auto;
    align-items: end;
    gap: 13px;
    margin-top: 20px;
}
.el-deposit .dp-field {
    min-width: 0;
}
.el-deposit .dp-field label {
    display: block;
    font-size: 12px;
    font-weight: 800;
    margin-bottom: 8px;
    color: var(--dp-primary);
}
.el-deposit .dp-input {
    width: 100%;
    min-height: 44px;
    padding: 10px 13px;
    border: 1px solid #CFDFE2;
    border-radius: 9px;
    background: #fff;
    font-size: 13px;
    color: var(--dp-primary);
}
.el-deposit .dp-input:focus {
    outline: none;
    border-color: var(--dp-accent);
    box-shadow: 0 0 0 3px rgba(22,138,145,.12);
}
.el-deposit .dp-actions {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 9px;
    margin-top: 16px;
}
.el-deposit .dp-table-wrap {
    width: 100%;
    overflow-x: auto;
    border: 1px solid var(--dp-border);
    border-radius: 11px;
    margin-top: 17px;
}
.el-deposit .dp-table {
    min-width: 920px;
    width: 100%;
    border-collapse: collapse;
    font-size: 12px;
}
.el-deposit .dp-table th {
    text-align: left;
    padding: 13px;
    background: #EFF8F9;
    color: var(--dp-primary);
    white-space: nowrap;
}
.el-deposit .dp-table td {
    padding: 13px;
    border-top: 1px solid #EDF2F3;
    vertical-align: middle;
}
.el-deposit .dp-table strong {
    color: var(--dp-primary);
}
.el-deposit .dp-muted {
    font-size: 12px;
    color: var(--dp-muted);
    line-height: 1.7;
}
.el-deposit .dp-pill {
    display: inline-block;
    font-size: 11px;
    font-weight: 800;
    padding: 6px 9px;
    border-radius: 18px;
    background: #E6F6F3;
    color: #14746E;
}
.el-deposit .dp-pill.pending {
    background: #FFF1D9;
    color: #92651D;
}
.el-deposit .dp-summary {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 12px;
    margin: 18px 0;
}
.el-deposit .dp-summary-item {
    background: var(--dp-soft);
    border: 1px solid var(--dp-border);
    border-radius: 10px;
    padding: 15px;
}
.el-deposit .dp-summary-item span {
    display: block;
    font-size: 11px;
    color: var(--dp-muted);
    margin-bottom: 6px;
}
.el-deposit .dp-summary-item strong {
    display: block;
    overflow-wrap: anywhere;
}
.el-deposit .dp-total {
    padding: 18px;
    background: #EAF6F6;
    border: 1px solid #CBE4E6;
    border-radius: 11px;
    margin: 15px 0;
}
.el-deposit .dp-total span {
    color: #426F75;
    display: block;
    margin-bottom: 7px;
    font-size: 12px;
}
.el-deposit .dp-total strong {
    font-size: 30px;
    color: var(--dp-primary);
}
.el-deposit .dp-payment-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 14px;
    margin-top: 20px;
}
.el-deposit .dp-confirm {
    display: block;
    margin-top: 20px;
    background: #FFF8EA;
    border: 1px solid #F0DEB8;
    border-radius: 10px;
    padding: 14px;
    font-size: 12px;
    line-height: 1.7;
}
.el-deposit .dp-message {
    display: block;
    padding: 13px 15px;
    border-radius: 9px;
    margin: 15px 0;
    font-size: 13px;
    line-height: 1.6;
}
.el-deposit .dp-message.success {
    background: #E7F7ED;
    color: #246B49;
}
.el-deposit .dp-message.error {
    background: #FFF0ED;
    color: #A23E33;
}
.el-deposit .dp-pager {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 12px;
    margin-top: 18px;
}
.el-deposit .dp-note {
    background: #FFF8EB;
    border: 1px solid #F1DFC2;
    color: #835D2C;
    border-radius: 11px;
    padding: 16px;
    font-size: 12px;
    line-height: 1.8;
}
@media(max-width:720px) {
    .el-deposit .dp-card {
        padding: 17px;
    }
    .el-deposit .dp-search,
    .el-deposit .dp-summary,
    .el-deposit .dp-payment-grid {
        grid-template-columns: 1fr;
    }
    .el-deposit .dp-actions .dp-btn {
        flex: 1;
    }
}
</style>

</asp:Content>

<asp:Content ID="MainContent"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="el-deposit">

    <header class="dp-header">
        <div>
            <span class="dp-eyebrow">
                ADMINISTRATION / VERSION 2
            </span>
            <h1>Collect Security Deposits</h1>
            <p>
                Record refundable deposits for online
                reservations before book collection.
            </p>
        </div>

        <asp:HyperLink
            runat="server"
            NavigateUrl="~/Admin/Transactions/ManageTransactions.aspx"
            CssClass="dp-btn"
            Text="← Manage Transactions" />
    </header>

    <asp:Label ID="lblMessage"
        runat="server"
        Visible="false"
        EnableViewState="false" />

    <section class="dp-card">

        <h2>Find Online Reservations</h2>
        <p>
            Search by reservation ID, customer, email,
            title or author. Search only runs when
            you press Enter or Apply.
        </p>

        <asp:Panel ID="pnlSearch"
            runat="server"
            DefaultButton="btnApply">

            <div class="dp-search">

                <div class="dp-field">
                    <asp:Label runat="server"
                        AssociatedControlID="txtSearch"
                        Text="Search reservations" />
                    <asp:TextBox ID="txtSearch"
                        runat="server"
                        CssClass="dp-input"
                        MaxLength="255" />
                </div>

                <div class="dp-field">
                    <asp:Label runat="server"
                        AssociatedControlID="ddlStatus"
                        Text="Deposit status" />

                    <asp:DropDownList ID="ddlStatus"
                        runat="server"
                        CssClass="dp-input">

                        <asp:ListItem Value="All"
                            Text="All pending reservations" />
                        <asp:ListItem Value="Required"
                            Text="Deposit required" />
                        <asp:ListItem Value="Held"
                            Text="Deposit collected" />
                    </asp:DropDownList>
                </div>

                <asp:Button ID="btnApply"
                    runat="server"
                    Text="Apply"
                    CssClass="dp-btn dp-btn-primary"
                    CausesValidation="false"
                    OnClick="btnApply_Click" />

            </div>
        </asp:Panel>

        <div class="dp-actions">
            <asp:Button ID="btnClear"
                runat="server"
                Text="Clear Filters"
                CssClass="dp-btn"
                CausesValidation="false"
                OnClick="btnClear_Click" />

            <asp:Button ID="btnRefresh"
                runat="server"
                Text="Refresh"
                CssClass="dp-btn"
                CausesValidation="false"
                OnClick="btnRefresh_Click" />
        </div>

        <div class="dp-pager">
            <asp:Label ID="lblCount"
                runat="server"
                CssClass="dp-muted" />
        </div>

        <div class="dp-table-wrap">

            <asp:GridView ID="gvDeposits"
                runat="server"
                AutoGenerateColumns="false"
                GridLines="None"
                CssClass="dp-table"
                EmptyDataText="No matching online reservations."
                OnRowCommand="gvDeposits_RowCommand">

                <Columns>

                    <asp:BoundField
                        DataField="BorrowLogID"
                        HeaderText="Borrow ID" />

                    <asp:TemplateField HeaderText="Customer">
                        <ItemTemplate>
                            <strong><%#: Eval("FullName") %></strong>
                            <div class="dp-muted">
                                <%#: Eval("Email") %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Book">
                        <ItemTemplate>
                            <strong><%#: Eval("Title") %></strong>
                            <div class="dp-muted">
                                <%#: Eval("Author") %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Borrowing Fee">
                        <ItemTemplate>
                            <div>
                                Balance:
                                <strong>
                                    <%# string.Format(System.Globalization.CultureInfo.GetCultureInfo("en-PH"), "₱{0:N2}", Eval("FeeBalance")) %>
                                </strong>
                            </div>
                            <div class="dp-muted">
                                Paid: <%# string.Format(System.Globalization.CultureInfo.GetCultureInfo("en-PH"), "₱{0:N2}", Eval("FeePaid")) %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Security Deposit">
                        <ItemTemplate>
                            <strong>
                                <%# string.Format(System.Globalization.CultureInfo.GetCultureInfo("en-PH"), "₱{0:N2}", Eval("AmountRequired")) %>
                            </strong>
                            <div>
                                Received:
                                <%# string.Format(System.Globalization.CultureInfo.GetCultureInfo("en-PH"), "₱{0:N2}", Eval("AmountReceived")) %>
                            </div>
                            <span class='<%#
                                Convert.ToString(Eval("DepositStatus")) == "Held"
                                ? "dp-pill"
                                : "dp-pill pending" %>'>
                                <%#: Eval("DepositStatus") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Expiry">
                        <ItemTemplate>
                            <%# Eval("ReservationExpiresAt", "{0:MMM dd, yyyy hh:mm tt}") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:Button runat="server"
                                Text="View Payment"
                                CommandName="SelectDeposit"
                                CommandArgument='<%# Eval("BorrowLogID") %>'
                                CssClass="dp-btn dp-btn-primary"
                                CausesValidation="false" />
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>
        </div>

        <div class="dp-pager">
            <asp:Button ID="btnPrevious"
                runat="server"
                Text="Previous"
                CssClass="dp-btn"
                CausesValidation="false"
                OnClick="btnPrevious_Click" />

            <asp:Label ID="lblPage"
                runat="server"
                CssClass="dp-muted" />

            <asp:Button ID="btnNext"
                runat="server"
                Text="Next"
                CssClass="dp-btn"
                CausesValidation="false"
                OnClick="btnNext_Click" />
        </div>
    </section>

    <asp:Panel ID="pnlSelected"
        runat="server"
        Visible="false"
        CssClass="dp-card"
        ClientIDMode="Static">

        <h2>Deposit Payment Details</h2>
        <p>
            Verify the customer and reservation before
            recording money received.
        </p>

        <asp:Label ID="lblActionMessage"
            runat="server"
            Visible="false"
            EnableViewState="false" />

        <div class="dp-summary">

            <div class="dp-summary-item">
                <span>Borrowing ID</span>
                <strong>
                    <asp:Label ID="lblBorrowID"
                        runat="server" />
                </strong>
            </div>

            <div class="dp-summary-item">
                <span>Customer</span>
                <strong>
                    <asp:Label ID="lblCustomer"
                        runat="server" />
                </strong>
            </div>

            <div class="dp-summary-item">
                <span>Book</span>
                <strong>
                    <asp:Label ID="lblBook"
                        runat="server" />
                </strong>
            </div>

            <div class="dp-summary-item">
                <span>Current Deposit Status</span>
                <strong>
                    <asp:Label ID="lblDepositStatus"
                        runat="server" />
                </strong>
            </div>

            <div class="dp-summary-item">
                <span>Outstanding Borrowing Fee</span>
                <strong>
                    <asp:Label ID="lblFeeBalance"
                        runat="server" />
                </strong>
            </div>

            <div class="dp-summary-item">
                <span>Reservation Deadline</span>
                <strong>
                    <asp:Label ID="lblExpiry"
                        runat="server" />
                </strong>
            </div>

        </div>

        <div class="dp-total">
            <span>Refundable Security Deposit</span>
            <strong>
                <asp:Label ID="lblDepositAmount"
                    runat="server" />
            </strong>
        </div>

        <asp:HyperLink ID="lnkPayFee"
            runat="server"
            Visible="false"
            CssClass="dp-btn"
            Text="Record Borrowing Fee Payment" />

        <asp:Panel ID="pnlDepositForm"
            runat="server"
            Visible="false">

            <div class="dp-payment-grid">

                <div class="dp-field">
                    <asp:Label runat="server"
                        AssociatedControlID="ddlPaymentMethod"
                        Text="Deposit payment method" />

                    <asp:DropDownList ID="ddlPaymentMethod"
                        runat="server"
                        CssClass="dp-input">

                        <asp:ListItem Value=""
                            Text="Select payment method" />
                        <asp:ListItem Value="Cash"
                            Text="Cash" />
                        <asp:ListItem Value="GCash"
                            Text="GCash" />
                        <asp:ListItem Value="Card"
                            Text="Card" />
                        <asp:ListItem Value="Bank Transfer"
                            Text="Bank Transfer" />
                    </asp:DropDownList>
                </div>

                <div class="dp-field">
                    <asp:Label runat="server"
                        AssociatedControlID="txtReference"
                        Text="Payment reference" />

                    <asp:TextBox ID="txtReference"
                        runat="server"
                        CssClass="dp-input"
                        MaxLength="100"
                        placeholder="Required for non-cash payments" />
                </div>

            </div>

            <label class="dp-confirm">
                <asp:CheckBox ID="chkConfirmed"
                    runat="server" />
                I confirm that the complete refundable
                security deposit has actually been received
                and the payment method has been verified.
            </label>

            <div class="dp-actions">
                <asp:Button ID="btnCollect"
                    runat="server"
                    Text="Record Security Deposit"
                    CssClass="dp-btn dp-btn-primary"
                    CausesValidation="false"
                    OnClick="btnCollect_Click"
                    OnClientClick="return confirm('Has the complete security deposit actually been received and verified?');" />

                <asp:Button ID="btnClose"
                    runat="server"
                    Text="Close"
                    CssClass="dp-btn"
                    CausesValidation="false"
                    OnClick="btnClose_Click" />
            </div>

        </asp:Panel>

    </asp:Panel>

    <aside class="dp-note">
        <strong>Financial separation:</strong>
        Borrowing fees are recorded using the existing
        receipt payment page. Security deposits are held
        separately and are not library revenue.
        This page records verified payments only;
        it does not execute an external bank or GCash transfer.
    </aside>

</div>

</asp:Content>
