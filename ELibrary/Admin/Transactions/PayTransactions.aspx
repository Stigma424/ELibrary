
<%@ Page Title="Record Payment"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="PayTransactions.aspx.cs"
    Inherits="ELibrary.Admin.Transactions.PayTransaction" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* ==========================================
   INTERNSHIPELIB - OCEAN TEAL
   RECORD PAYMENT
========================================== */

.el-payment-page {
    --pay-primary: #123B4A;
    --pay-accent: #168A91;
    --pay-hover: #12757C;
    --pay-muted: #647F89;
    --pay-border: #DCE9EB;
    --pay-soft: #F5FAFA;

    display: flex;
    flex-direction: column;
    gap: 22px;
    max-width: 990px;
    margin: 0 auto;
    padding-bottom: 36px;
    color: var(--pay-primary);
}

.el-payment-page *,
.el-payment-page *::before,
.el-payment-page *::after {
    box-sizing: border-box;
}

.el-payment-page .pay-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 15px;
    padding: 4px 0;
}

.el-payment-page .pay-eyebrow {
    display: block;
    margin-bottom: 8px;
    color: var(--pay-accent);
    font-size: 10px;
    font-weight: 800;
    letter-spacing: .12em;
}

.el-payment-page .pay-header h1 {
    margin: 0 0 7px;
    color: var(--pay-primary);
    font-size: 29px;
    font-weight: 800;
}

.el-payment-page .pay-header p,
.el-payment-page .pay-panel-head p {
    margin: 0;
    color: var(--pay-muted);
    font-size: 12px;
    line-height: 1.7;
}

.el-payment-page .pay-card {
    background: #FFFFFF;
    border: 1px solid var(--pay-border);
    border-radius: 14px;
    padding: 25px;
    box-shadow: 0 3px 14px rgba(18,59,74,.035);
}

.el-payment-page .pay-panel-head {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 14px;
    flex-wrap: wrap;
    margin-bottom: 22px;
}

.el-payment-page .pay-panel-head h2 {
    margin: 0 0 6px;
    font-size: 18px;
    font-weight: 800;
    color: var(--pay-primary);
}

.el-payment-page .pay-tag {
    display: inline-flex;
    padding: 7px 11px;
    background: #EAF6F6;
    border-radius: 8px;
    color: #126E73;
    font-size: 11px;
    font-weight: 750;
}

.el-payment-page .pay-summary {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 12px;
}

.el-payment-page .pay-summary-item {
    min-width: 0;
    padding: 17px;
    background: var(--pay-soft);
    border: 1px solid var(--pay-border);
    border-radius: 10px;
}

.el-payment-page .pay-summary-label {
    display: block;
    margin-bottom: 7px;
    color: var(--pay-muted);
    font-size: 11px;
    font-weight: 700;
}

.el-payment-page .pay-summary-value {
    display: block;
    color: var(--pay-primary);
    font-size: 13px;
    font-weight: 800;
    line-height: 1.6;
    overflow-wrap: anywhere;
}

.el-payment-page .pay-balance {
    margin: 19px 0 25px;
    padding: 20px 22px;
    background: #EAF6F6;
    border: 1px solid #CBE4E6;
    border-radius: 11px;
}

.el-payment-page .pay-balance-label {
    display: block;
    margin-bottom: 9px;
    color: #315D67;
    font-size: 12px;
    font-weight: 700;
}

.el-payment-page .pay-balance-amount {
    display: block;
    color: var(--pay-primary);
    font-size: clamp(26px, 4vw, 36px);
    font-weight: 850;
    line-height: 1.2;
    overflow-wrap: anywhere;
}

.el-payment-page .pay-balance-note {
    display: block;
    margin-top: 8px;
    color: #54777D;
    font-size: 11px;
    line-height: 1.6;
}

.el-payment-page .pay-section-title {
    margin: 0 0 17px;
    color: var(--pay-primary);
    font-size: 16px;
    font-weight: 800;
}

.el-payment-page .pay-form-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0,1fr));
    gap: 17px;
}

.el-payment-page .pay-field {
    min-width: 0;
}

.el-payment-page .pay-field label {
    display: block;
    margin-bottom: 8px;
    color: #375968;
    font-size: 12px;
    font-weight: 750;
}

.el-payment-page .pay-input {
    display: block;
    width: 100%;
    min-height: 44px;
    padding: 11px 13px;
    border: 1px solid #CFE1E4;
    border-radius: 9px;
    color: var(--pay-primary);
    background: #FFFFFF;
    font-size: 13px;
}

.el-payment-page .pay-input:focus {
    outline: none;
    border-color: var(--pay-accent);
    box-shadow: 0 0 0 3px rgba(22,138,145,.12);
}

.el-payment-page .pay-help {
    display: block;
    margin-top: 8px;
    color: var(--pay-muted);
    font-size: 11px;
    line-height: 1.6;
}

.el-payment-page .pay-validator {
    display: block;
    margin-top: 8px;
    color: #A43E39;
    font-size: 11px;
    line-height: 1.6;
}

.el-payment-page .pay-actions {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;
    margin-top: 22px;
    padding-top: 20px;
    border-top: 1px solid #EDF3F4;
}

.el-payment-page .pay-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 42px;
    padding: 10px 19px;
    background: #FFFFFF;
    color: var(--pay-primary);
    border: 1px solid var(--pay-border);
    border-radius: 9px;
    font-size: 12px;
    font-weight: 750;
    line-height: 1.5;
    text-decoration: none;
    cursor: pointer;
}

.el-payment-page .pay-btn:hover {
    background: #EAF5F6;
    color: var(--pay-primary);
    border-color: #B4DADD;
    text-decoration: none;
}

.el-payment-page .pay-btn-primary {
    background: var(--pay-accent);
    color: #FFFFFF;
    border-color: var(--pay-accent);
}

.el-payment-page .pay-btn-primary:hover {
    background: var(--pay-hover);
    border-color: var(--pay-hover);
    color: #FFFFFF;
}

.el-payment-page .pay-btn:disabled {
    opacity: .5;
    cursor: not-allowed;
}

.el-payment-page .pay-message {
    display: block;
    margin-bottom: 17px;
    padding: 14px 17px;
    border-radius: 9px;
    font-size: 12px;
    line-height: 1.7;
}

.el-payment-page .pay-message.error {
    color: #9E3E39;
    background: #FFF0EF;
    border: 1px solid #F2D3CF;
    border-left: 4px solid #C34D46;
}

.el-payment-page .pay-message.success {
    color: #236747;
    background: #E9F7F1;
    border: 1px solid #C8E8D7;
    border-left: 4px solid #28845B;
}

.el-payment-page .pay-message.info {
    color: #315D67;
    background: #EAF6F6;
    border: 1px solid #CDE7E9;
    border-left: 4px solid #168A91;
}

.el-payment-page .pay-note {
    padding: 15px 18px;
    background: #FFF8EF;
    color: #875C29;
    border: 1px solid #F2D9C0;
    border-radius: 10px;
    font-size: 12px;
    line-height: 1.8;
}

@media(max-width:650px) {
    .el-payment-page .pay-header h1 {
        font-size: 24px;
    }

    .el-payment-page .pay-card {
        padding: 16px;
    }

    .el-payment-page .pay-summary,
    .el-payment-page .pay-form-grid {
        grid-template-columns: 1fr;
    }

    .el-payment-page .pay-actions {
        align-items: stretch;
        flex-direction: column;
    }

    .el-payment-page .pay-actions .pay-btn {
        width: 100%;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="el-payment-page">

    <!-- HEADER -->

    <header class="pay-header">

        <div>
            <span class="pay-eyebrow">
                ADMINISTRATION / FINANCIAL MANAGEMENT
            </span>

            <h1>Record Payment</h1>

            <p>
                Review the outstanding fee and record
                a customer payment securely.
            </p>
        </div>

        <asp:HyperLink
            runat="server"
            NavigateUrl="~/Admin/Transactions/ManageTransactions.aspx"
            CssClass="pay-btn"
            Text="← Manage Transactions" />

    </header>

    <!-- PAYMENT PANEL -->

    <section class="pay-card">

        <div class="pay-panel-head">

            <div>
                <h2>Receipt Information</h2>

                <p>
                    Verify the customer, book, and fee
                    before recording a payment.
                </p>
            </div>

            <span class="pay-tag">
                Payment Processing
            </span>

        </div>

        <!-- RECEIPT SUMMARY -->

        <div class="pay-summary">

            <div class="pay-summary-item">
                <span class="pay-summary-label">
                    Customer
                </span>

                <strong class="pay-summary-value">
                    <asp:Label
                        ID="lblCustomer"
                        runat="server" />
                </strong>
            </div>

            <div class="pay-summary-item">
                <span class="pay-summary-label">
                    Book
                </span>

                <strong class="pay-summary-value">
                    <asp:Label
                        ID="lblBook"
                        runat="server" />
                </strong>
            </div>

            <div class="pay-summary-item">
                <span class="pay-summary-label">
                    Fee Type
                </span>

                <strong class="pay-summary-value">
                    <asp:Label
                        ID="lblFeeType"
                        runat="server" />
                </strong>
            </div>

            <div class="pay-summary-item">
                <span class="pay-summary-label">
                    Receipt ID
                </span>

                <strong class="pay-summary-value">
                    <asp:Label
                        ID="lblReceiptID"
                        runat="server" />
                </strong>
            </div>

        </div>

        <!-- OUTSTANDING BALANCE -->

        <div class="pay-balance">

            <span class="pay-balance-label">
                Outstanding Balance
            </span>

            <strong class="pay-balance-amount">
                ₱<asp:Label
                    ID="lblBalance"
                    runat="server"
                    Text="0.00" />
            </strong>

            <span class="pay-balance-note">
                Enter a payment amount not exceeding
                the remaining balance.
            </span>

        </div>

        <!-- PAYMENT FORM -->

        <h3 class="pay-section-title">
            Payment Details
        </h3>

        <!-- LOCAL PAYMENT NOTIFICATIONS -->

        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            Visible="false"
            CssClass="pay-message"
            role="status"
            aria-live="polite" />

        <asp:Panel
            ID="pnlPaymentFields"
            runat="server">

            <div class="pay-form-grid">

                <div class="pay-field">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtAmountPaid"
                        Text="Amount Paid (PHP) *" />

                    <asp:TextBox
                        ID="txtAmountPaid"
                        runat="server"
                        CssClass="pay-input"
                        TextMode="Number"
                        step="0.01"
                        min="0.01"
                        autocomplete="off"
                        placeholder="0.00" />

                    <asp:RequiredFieldValidator
                        ID="rfvAmountPaid"
                        runat="server"
                        ControlToValidate="txtAmountPaid"
                        ErrorMessage="Payment amount is required."
                        CssClass="pay-validator"
                        Display="Dynamic"
                        ValidationGroup="Payment" />

                    <small class="pay-help">
                        Partial payments are allowed.
                        Amounts must have at most two decimal places.
                    </small>

                </div>

                <div class="pay-field">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlPaymentMethod"
                        Text="Payment Method *" />

                    <asp:DropDownList
                        ID="ddlPaymentMethod"
                        runat="server"
                        CssClass="pay-input">

                        <asp:ListItem
                            Text="Cash"
                            Value="Cash" />

                        <asp:ListItem
                            Text="GCash"
                            Value="GCash" />

                        <asp:ListItem
                            Text="Card"
                            Value="Card" />

                        <asp:ListItem
                            Text="Bank Transfer"
                            Value="Bank Transfer" />

                    </asp:DropDownList>

                    <small class="pay-help">
                        Choose the method actually used
                        by the customer.
                    </small>

                </div>

            </div>

        </asp:Panel>

        <!-- ACTION BUTTONS -->

        <div class="pay-actions">

            <asp:Button
                ID="btnRecordPayment"
                runat="server"
                Text="Confirm Payment"
                CssClass="pay-btn pay-btn-primary"
                ValidationGroup="Payment"
                OnClick="btnRecordPayment_Click"
                OnClientClick="return confirm('Record this payment against the selected receipt?');"
                UseSubmitBehavior="true" />

            <asp:Button
                ID="btnCancel"
                runat="server"
                Text="Back to Transactions"
                CssClass="pay-btn"
                CausesValidation="false"
                OnClick="btnCancel_Click" />

        </div>

    </section>

    <!-- PAYMENT POLICY -->

    <aside class="pay-note">

        <strong>Payment reminder:</strong>
        Confirm the amount and payment method before
        submitting. The recorded payment will be
        associated with the selected receipt and
        librarian account.

        For GCash, Card, or Bank Transfer, this page
        records the payment method; it does not
        independently verify an external transfer.

    </aside>

</div>

</asp:Content>
