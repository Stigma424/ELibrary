
<%@ Page Title="Walk-in Borrowing"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="WalkInBorrow.aspx.cs"
    Inherits="ELibrary.Admin.Borrowing.WalkInBorrow" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
.el-walkin {
    --wi-ink:#123B4A;
    --wi-teal:#168A91;
    --wi-muted:#647F89;
    --wi-border:#DCE9EB;
    --wi-mist:#F0F8F9;
    max-width:1160px;
    margin:0 auto;
    padding:18px 0 50px;
    color:var(--wi-ink);
}
.el-walkin * { box-sizing:border-box; }
.el-walkin .wi-header {
    display:flex;
    align-items:flex-start;
    justify-content:space-between;
    flex-wrap:wrap;
    gap:16px;
    margin-bottom:25px;
}
.el-walkin .wi-eyebrow {
    font-size:11px;
    font-weight:800;
    color:var(--wi-teal);
    letter-spacing:1.5px;
    text-transform:uppercase;
}
.el-walkin h1 {
    font-size:clamp(27px,4vw,37px);
    font-weight:800;
    margin:9px 0;
    color:var(--wi-ink);
}
.el-walkin h2 {
    font-size:20px;
    font-weight:800;
    margin:0 0 5px;
    color:var(--wi-ink);
}
.el-walkin p {
    color:var(--wi-muted);
    line-height:1.65;
    margin:0;
}
.el-walkin .wi-steps {
    display:flex;
    flex-wrap:wrap;
    gap:8px;
    margin:22px 0;
}
.el-walkin .wi-steps span {
    background:#E8F4F4;
    color:#146F76;
    padding:9px 13px;
    border-radius:8px;
    font-size:12px;
    font-weight:800;
}
.el-walkin .wi-card {
    background:#fff;
    border:1px solid var(--wi-border);
    border-radius:17px;
    padding:25px;
    margin-bottom:18px;
    box-shadow:0 5px 22px rgba(18,59,74,.04);
}
.el-walkin .wi-card-head {
    display:flex;
    align-items:flex-start;
    gap:14px;
    margin-bottom:23px;
}
.el-walkin .wi-step {
    background:#E3F3F2;
    color:#168A91;
    min-width:43px;
    height:43px;
    display:flex;
    align-items:center;
    justify-content:center;
    border-radius:12px;
    font-size:14px;
    font-weight:800;
}
.el-walkin .wi-search-row {
    display:flex;
    align-items:flex-end;
    gap:12px;
}
.el-walkin .wi-field {
    display:flex;
    flex-direction:column;
    gap:7px;
    flex:1;
    min-width:0;
}
.el-walkin .wi-field label,
.el-walkin .wi-label {
    font-weight:700;
    font-size:13px;
    color:var(--wi-ink);
}
.el-walkin .wi-input {
    border:1px solid #CFDFE2;
    border-radius:10px;
    background:#fff;
    color:var(--wi-ink);
    font-size:14px;
    padding:12px 14px;
    width:100%;
    min-height:45px;
    outline:none;
}
.el-walkin .wi-input:focus {
    border-color:var(--wi-teal);
    box-shadow:0 0 0 3px rgba(22,138,145,.12);
}
.el-walkin .wi-btn,
.el-walkin .wi-select-btn {
    display:inline-flex;
    align-items:center;
    justify-content:center;
    border:1px solid var(--wi-border);
    background:#fff;
    color:var(--wi-ink);
    border-radius:10px;
    padding:12px 17px;
    font-size:13px;
    font-weight:800;
    cursor:pointer;
    text-decoration:none;
    min-height:44px;
}
.el-walkin .wi-btn-primary {
    color:#fff;
    border-color:var(--wi-teal);
    background:var(--wi-teal);
}
.el-walkin .wi-btn-primary:hover,
.el-walkin .wi-select-btn:hover {
    background:#12757C;
    color:#fff;
}
.el-walkin .wi-select-btn {
    background:#E8F5F4;
    color:#12757C;
    border-color:#CEE6E5;
    min-height:34px;
    padding:8px 12px;
}
.el-walkin .wi-actions {
    display:flex;
    align-items:center;
    gap:10px;
    flex-wrap:wrap;
    margin-top:18px;
}
.el-walkin .wi-help {
    color:var(--wi-muted);
    font-size:12px;
    margin-top:10px;
}
.el-walkin .wi-table-wrap {
    margin-top:19px;
    overflow-x:auto;
    border:1px solid var(--wi-border);
    border-radius:12px;
}
.el-walkin .wi-table {
    width:100%;
    border-collapse:collapse;
    min-width:500px;
    font-size:13px;
}
.el-walkin .wi-table th {
    text-align:left;
    padding:13px;
    background:#F0F8F9;
    color:var(--wi-ink);
}
.el-walkin .wi-table td {
    padding:13px;
    border-top:1px solid var(--wi-border);
    vertical-align:middle;
}
.el-walkin .wi-selected {
    display:flex;
    flex-direction:column;
    gap:5px;
    margin-top:17px;
    border:1px solid #C8E8E4;
    background:#EDFAF7;
    border-radius:11px;
    padding:14px 17px;
    color:var(--wi-ink);
}
.el-walkin .wi-selected strong {
    color:#168A91;
    font-size:12px;
}
.el-walkin .wi-message {
    display:block;
    margin:13px 0;
    border-radius:10px;
    padding:13px 15px;
    font-size:13px;
    line-height:1.6;
}
.el-walkin .wi-message.success {
    background:#E7F8EE;
    color:#246B49;
}
.el-walkin .wi-message.error {
    background:#FFF0ED;
    color:#A33F31;
}
.el-walkin .wi-empty {
    display:block;
    padding:17px 0;
    color:var(--wi-muted);
}
.el-walkin .wi-review-grid {
    display:grid;
    grid-template-columns:repeat(2,minmax(0,1fr));
    gap:12px;
    margin-bottom:22px;
}
.el-walkin .wi-review-item {
    border:1px solid var(--wi-border);
    background:#F8FCFC;
    border-radius:12px;
    padding:15px;
    min-width:0;
}
.el-walkin .wi-review-item span {
    display:block;
    color:var(--wi-muted);
    font-size:12px;
    margin-bottom:7px;
}
.el-walkin .wi-review-item strong {
    overflow-wrap:anywhere;
}
.el-walkin .wi-payment {
    background:#F0F8F9;
    border:1px solid #D7EAEA;
    border-radius:14px;
    padding:20px;
    margin-top:15px;
}
.el-walkin .wi-payment-row {
    display:flex;
    justify-content:space-between;
    gap:14px;
    margin-bottom:13px;
}
.el-walkin .wi-payment-row span {
    color:var(--wi-muted);
}
.el-walkin .wi-payment-total {
    border-top:1px solid #CEDFE2;
    padding-top:15px;
    margin-top:13px;
    font-weight:800;
    font-size:19px;
}
.el-walkin .wi-payment-grid {
    display:grid;
    grid-template-columns:repeat(2,minmax(0,1fr));
    gap:15px;
    margin-top:20px;
}
.el-walkin .wi-check {
    display:flex;
    align-items:flex-start;
    gap:10px;
    margin-top:20px;
    padding:15px;
    border-radius:11px;
    background:#FFF8EC;
    border:1px solid #F6E5C7;
    font-size:13px;
    line-height:1.6;
}
.el-walkin .wi-check input {
    margin-top:3px;
    accent-color:var(--wi-teal);
}
.el-walkin .wi-note {
    color:var(--wi-muted);
    font-size:12px;
    margin-top:10px;
    line-height:1.6;
}
.el-walkin .wi-complete {
    border-color:#BFE4D7;
}
@media(max-width:700px) {
    .el-walkin { padding:10px 0 32px; }
    .el-walkin .wi-card { padding:18px; border-radius:14px; }
    .el-walkin .wi-search-row { flex-direction:column; align-items:stretch; }
    .el-walkin .wi-review-grid,
    .el-walkin .wi-payment-grid { grid-template-columns:1fr; }
    .el-walkin .wi-actions { flex-direction:column; align-items:stretch; }
    .el-walkin .wi-actions .wi-btn { width:100%; }
    .el-walkin .wi-header > .wi-btn { width:100%; }
    .el-walkin .wi-card-head { gap:10px; }
    .el-walkin .wi-step { min-width:37px; height:37px; }
    .el-walkin h2 { font-size:18px; }
}
</style>
</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="el-walkin">

    <header class="wi-header">
        <div>
            <span class="wi-eyebrow">
                ADMINISTRATION / V2 BORROWING
            </span>
            <h1>Walk-in Borrowing</h1>
            <p>
                Find a customer, select a book, collect payment,
                and create a seven-day loan.
            </p>
        </div>

        <asp:HyperLink
            runat="server"
            NavigateUrl="~/Admin/Borrowing/ManageBorrows.aspx"
            CssClass="wi-btn"
            Text="← Manage Borrowings" />
    </header>

    <div class="wi-steps">
        <span>01 Customer</span>
        <span>02 Book</span>
        <span>03 Verification</span>
        <span>04 Payment</span>
    </div>

    <!-- CUSTOMER SEARCH -->

    <section id="walkinCustomer" class="wi-card">

        <div class="wi-card-head">
            <span class="wi-step">01</span>
            <div>
                <h2>Select Customer</h2>
                <p>Search registered customers in V2.</p>
            </div>
        </div>

        <asp:Panel ID="pnlCustomerSearch"
            runat="server"
            DefaultButton="btnSearchCustomer">

            <div class="wi-search-row">
                <div class="wi-field">
                    <asp:Label runat="server"
                        AssociatedControlID="txtCustomerSearch"
                        Text="Customer name or email" />
                    <asp:TextBox
                        ID="txtCustomerSearch"
                        runat="server"
                        CssClass="wi-input"
                        MaxLength="100" />
                </div>

                <asp:Button
                    ID="btnSearchCustomer"
                    runat="server"
                    Text="Search Customer"
                    CssClass="wi-btn wi-btn-primary"
                    CausesValidation="false"
                    OnClick="btnSearchCustomer_Click" />
            </div>
        </asp:Panel>

        <div class="wi-help">
            Search runs only when Enter or Search Customer is pressed.
        </div>

        <asp:Label ID="lblCustomerMessage"
            runat="server" Visible="false"
            EnableViewState="false" />

        <asp:Panel ID="pnlCustomerResults"
            runat="server" Visible="false">

            <div class="wi-table-wrap">
                <asp:GridView ID="gvCustomers"
                    runat="server"
                    AutoGenerateColumns="false"
                    DataKeyNames="UserID"
                    CssClass="wi-table"
                    GridLines="None"
                    OnRowCommand="gvCustomers_RowCommand">
                    <Columns>

                        <asp:BoundField
                            DataField="FullName"
                            HeaderText="Customer" />

                        <asp:BoundField
                            DataField="Email"
                            HeaderText="Email" />

                        <asp:TemplateField HeaderText="Eligibility">
                            <ItemTemplate>
                                <%# Convert.ToBoolean(Eval("IsAllowedToBorrow"))
                                    ? "Allowed" : "Restricted" %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button runat="server"
                                    Text="Select"
                                    CommandName="SelectCustomer"
                                    CommandArgument='<%# Eval("UserID") %>'
                                    CssClass="wi-select-btn"
                                    CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>

            <asp:Label ID="lblCustomerEmpty"
                runat="server"
                Visible="false"
                CssClass="wi-empty"
                Text="No matching customers found." />
        </asp:Panel>

        <asp:Panel ID="pnlSelectedCustomer"
            runat="server"
            Visible="false"
            CssClass="wi-selected">
            <strong>Selected customer</strong>
            <asp:Label ID="lblSelectedCustomer"
                runat="server" />
        </asp:Panel>

    </section>

    <!-- BOOK SEARCH -->

    <section id="walkinBook" class="wi-card">

        <div class="wi-card-head">
            <span class="wi-step">02</span>
            <div>
                <h2>Select Book</h2>
                <p>Search active books with available stock.</p>
            </div>
        </div>

        <asp:Panel ID="pnlBookSearch"
            runat="server"
            DefaultButton="btnSearchBook">

            <div class="wi-search-row">
                <div class="wi-field">
                    <asp:Label runat="server"
                        AssociatedControlID="txtBookSearch"
                        Text="Book title, author or ISBN" />

                    <asp:TextBox ID="txtBookSearch"
                        runat="server"
                        CssClass="wi-input"
                        MaxLength="255" />
                </div>

                <asp:Button ID="btnSearchBook"
                    runat="server"
                    Text="Search Book"
                    CssClass="wi-btn wi-btn-primary"
                    CausesValidation="false"
                    OnClick="btnSearchBook_Click" />
            </div>
        </asp:Panel>

        <div class="wi-help">
            Search executes only after Enter or Search Book.
        </div>

        <asp:Label ID="lblBookMessage"
            runat="server"
            EnableViewState="false"
            Visible="false" />

        <asp:Panel ID="pnlBookResults"
            runat="server"
            Visible="false">

            <div class="wi-table-wrap">
                <asp:GridView ID="gvBooks"
                    runat="server"
                    AutoGenerateColumns="false"
                    DataKeyNames="BookID"
                    CssClass="wi-table"
                    GridLines="None"
                    OnRowCommand="gvBooks_RowCommand">
                    <Columns>

                        <asp:BoundField DataField="Title"
                            HeaderText="Book Title" />

                        <asp:BoundField DataField="Author"
                            HeaderText="Author" />

                        <asp:BoundField DataField="AvailableCopies"
                            HeaderText="Available" />

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button runat="server"
                                    Text="Select"
                                    CommandName="SelectBook"
                                    CommandArgument='<%# Eval("BookID") %>'
                                    CssClass="wi-select-btn"
                                    CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>

            <asp:Label ID="lblBookEmpty"
                runat="server"
                Visible="false"
                CssClass="wi-empty"
                Text="No matching books found." />
        </asp:Panel>

        <asp:Panel ID="pnlSelectedBook"
            runat="server"
            Visible="false"
            CssClass="wi-selected">
            <strong>Selected book</strong>
            <asp:Label ID="lblSelectedBook"
                runat="server" />
        </asp:Panel>

    </section>

    <!-- VERIFICATION -->

    <section id="walkinVerify" class="wi-card">

        <div class="wi-card-head">
            <span class="wi-step">03</span>
            <div>
                <h2>Verify Borrowing</h2>
                <p>
                    Confirm eligibility and retrieve the current
                    borrowing fee from SQL Server.
                </p>
            </div>
        </div>

        <asp:Label ID="lblVerifyMessage"
            runat="server"
            EnableViewState="false"
            Visible="false" />

        <div class="wi-actions">

            <asp:Button ID="btnVerify"
                runat="server"
                Text="Verify Customer &amp; Book"
                CssClass="wi-btn wi-btn-primary"
                CausesValidation="false"
                OnClick="btnVerify_Click" />

            <asp:Button ID="btnClear"
                runat="server"
                Text="Clear Selection"
                CssClass="wi-btn"
                CausesValidation="false"
                OnClick="btnClear_Click" />

        </div>
    </section>

    <!-- PAYMENT PANEL -->

    <asp:Panel ID="pnlPreview"
        runat="server"
        Visible="false"
        CssClass="wi-card"
        ClientIDMode="Static">

        <div class="wi-card-head">
            <span class="wi-step">04</span>
            <div>
                <h2>Payment & Confirmation</h2>
                <p>
                    Verify the full amount before handing
                    the book to the customer.
                </p>
            </div>
        </div>

        <asp:Label ID="lblMessage"
            runat="server"
            EnableViewState="false"
            Visible="false" />

        <div class="wi-review-grid">

            <div class="wi-review-item">
                <span>Customer</span>
                <strong><asp:Label ID="lblCustomer"
                    runat="server" /></strong>
            </div>

            <div class="wi-review-item">
                <span>Book</span>
                <strong><asp:Label ID="lblBook"
                    runat="server" /></strong>
            </div>

            <div class="wi-review-item">
                <span>Available copies</span>
                <strong><asp:Label ID="lblAvailable"
                    runat="server" /></strong>
            </div>

            <div class="wi-review-item">
                <span>Loan period</span>
                <strong>7 days from collection</strong>
            </div>

        </div>

        <div class="wi-payment">

            <h2>Payment Summary</h2>

            <div class="wi-payment-row">
                <span>Borrowing fee</span>
                <strong>
                    <asp:Label ID="lblBorrowingFee"
                        runat="server" />
                </strong>
            </div>

            <div class="wi-payment-row">
                <span>Refundable security deposit</span>
                <strong>
                    <asp:Label ID="lblSecurityDeposit"
                        runat="server" />
                </strong>
            </div>

            <div class="wi-payment-row wi-payment-total">
                <span>Total required</span>
                <strong>
                    <asp:Label ID="lblTotalDue"
                        runat="server" />
                </strong>
            </div>

            <div class="wi-payment-grid">

                <div class="wi-field">
                    <asp:Label runat="server"
                        AssociatedControlID="ddlPaymentMethod"
                        Text="Payment Method" />

                    <asp:DropDownList ID="ddlPaymentMethod"
                        runat="server"
                        CssClass="wi-input">
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

                <div class="wi-field">
                    <asp:Label runat="server"
                        AssociatedControlID="txtAmountReceived"
                        Text="Amount Received (₱)" />

                    <asp:TextBox ID="txtAmountReceived"
                        runat="server"
                        CssClass="wi-input"
                        MaxLength="15"
                        placeholder="e.g. 245.00" />
                </div>

                <div class="wi-field">
                    <asp:Label runat="server"
                        AssociatedControlID="txtReferenceNo"
                        Text="Reference Number (optional for cash)" />

                    <asp:TextBox ID="txtReferenceNo"
                        runat="server"
                        CssClass="wi-input"
                        MaxLength="100"
                        placeholder="Verified payment reference" />
                </div>

            </div>

            <label class="wi-check">
                <asp:CheckBox ID="chkPaymentConfirmed"
                    runat="server" />
                <span>
                    I confirm that I have received and verified
                    the full payment displayed above, including
                    the refundable ₱200 security deposit.
                </span>
            </label>

            <div class="wi-note">
                The final amount will be recalculated using
                SQL Server. The customer will receive the
                book only after the transaction succeeds.
                Card, GCash and bank payments must be
                verified outside this system.
            </div>

        </div>

        <div class="wi-actions">
            <asp:Button ID="btnConfirm"
                runat="server"
                Text="Confirm Payment &amp; Borrowing"
                CssClass="wi-btn wi-btn-primary"
                CausesValidation="false"
                OnClick="btnConfirm_Click"
                OnClientClick="return confirm('Has the full payment actually been received? This action will create the loan and deposit records.');" />
        </div>

    </asp:Panel>

    <!-- SUCCESS -->

    <asp:Panel ID="pnlCompleted"
        runat="server"
        Visible="false"
        CssClass="wi-card wi-complete"
        ClientIDMode="Static">

        <h2>Walk-in Borrowing Result</h2>

        <asp:Label ID="lblCompletedMessage"
            runat="server"
            EnableViewState="false"
            Visible="false" />

        <div class="wi-actions">

            <asp:HyperLink
                runat="server"
                NavigateUrl="~/Admin/Borrowing/ManageBorrows.aspx"
                CssClass="wi-btn"
                Text="View Borrowing Records" />

        </div>

    </asp:Panel>

</div>

<asp:HiddenField ID="hfFocusTarget"
    runat="server"
    ClientIDMode="Static" />

<script type="text/javascript">
    (function () {
        var focus = document.getElementById('hfFocusTarget');
        if (!focus || !focus.value) return;

        var target = document.getElementById(focus.value);
        if (!target) return;

        requestAnimationFrame(function () {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        });
    })();
</script>

</asp:Content>
