<%@ Page Title="Refund Security Deposits"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="RefundDeposits.aspx.cs"
    Inherits="ELibrary.Admin.Transactions.RefundDeposits" %>

<asp:Content ID="HeadContent"
    ContentPlaceHolderID="head"
    runat="server">

<style>
.refund-page {
    max-width: 1200px;
    margin: 0 auto;
    color: #172b43;
}

.refund-heading {
    margin-bottom: 24px;
}

.refund-heading h1 {
    font-size: 28px;
    font-weight: 800;
    margin-bottom: 8px;
}

.refund-heading p {
    color: #718096;
    font-size: 13px;
}

.refund-panel {
    background: #fff;
    padding: 24px;
    border: 1px solid #e3eaf2;
    border-radius: 14px;
    margin-bottom: 20px;
}

.refund-filters {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    align-items: center;
}

.refund-filters input[type=text] {
    flex: 1;
    min-width: 220px;
}

.refund-filters select {
    min-width: 170px;
}

.refund-input {
    padding: 10px;
    border: 1px solid #dce4ed;
    border-radius: 8px;
    font-size: 13px;
}

.refund-btn {
    background: #2f6ba0;
    border: 0;
    color: white;
    padding: 10px 16px;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 700;
}

.refund-btn:hover {
    background: #255985;
}

.refund-btn:disabled {
    opacity: .5;
    cursor: not-allowed;
}

.refund-table-wrap {
    overflow-x: auto;
}

.refund-table {
    width: 100%;
    min-width: 960px;
    border-collapse: collapse;
    font-size: 12px;
}

.refund-table th {
    padding: 13px;
    text-align: left;
    background: #f5f8fc;
    color: #52667d;
}

.refund-table td {
    padding: 13px;
    vertical-align: top;
    border-bottom: 1px solid #e3eaf2;
}

.refund-table tr:hover td {
    background: #fafcff;
}

.refund-actions {
    display: flex;
    flex-direction: column;
    gap: 9px;
    min-width: 175px;
}

.refund-actions select,
.refund-actions input[type=text] {
    width: 100%;
}

.refund-check {
    display: block;
    font-size: 11px;
    line-height: 1.5;
}

.refund-muted {
    color: #718096;
    font-size: 11px;
}

.refund-money {
    font-weight: 800;
}

.refund-warning {
    color: #bc5555;
    font-weight: 700;
}

.refund-success {
    color: #238253;
    font-weight: 700;
}

.refund-message {
    display: block;
    margin-bottom: 15px;
    font-size: 13px;
    line-height: 1.6;
}

.refund-pager {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    margin-top: 20px;
}

@media (max-width: 600px) {
    .refund-panel {
        padding: 15px;
    }

    .refund-filters {
        flex-direction: column;
        align-items: stretch;
    }

    .refund-filters input[type=text],
    .refund-filters select {
        width: 100%;
    }
}
</style>
</asp:Content>

<asp:Content ID="MainPage"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="refund-page">

    <div class="refund-heading">
        <h1>Security Deposit Refunds</h1>
        <p>
            Review returned books, verify outstanding
            charges, and record confirmed refunds.
        </p>
    </div>

    <asp:Label
        ID="lblMessage"
        runat="server"
        CssClass="refund-message" />

    <div class="refund-panel">

        <div class="refund-filters">

            <asp:TextBox
                ID="txtSearch"
                runat="server"
                CssClass="refund-input"
                MaxLength="255"
                placeholder="Search customer, email, book or borrow ID" />

            <asp:DropDownList
                ID="ddlStatus"
                runat="server"
                CssClass="refund-input">

                <asp:ListItem
                    Text="Pending Refund"
                    Value="RefundPending" />

                <asp:ListItem
                    Text="Refunded"
                    Value="Refunded" />

                <asp:ListItem
                    Text="All"
                    Value="All" />

            </asp:DropDownList>

            <asp:Button
                ID="btnApply"
                runat="server"
                Text="Apply"
                CssClass="refund-btn"
                OnClick="btnApply_Click" />

            <asp:Button
                ID="btnReset"
                runat="server"
                Text="Reset"
                CssClass="refund-btn"
                OnClick="btnReset_Click" />

        </div>
    </div>

    <div class="refund-panel">

        <h3>Deposit Refund Records</h3>

        <div class="refund-table-wrap">

            <asp:GridView
                ID="gvRefunds"
                runat="server"
                AutoGenerateColumns="false"
                GridLines="None"
                CssClass="refund-table"
                DataKeyNames="BorrowLogID"
                OnRowCommand="gvRefunds_RowCommand"
                EmptyDataText="No refund records found.">

                <Columns>

                    <asp:BoundField
                        DataField="BorrowLogID"
                        HeaderText="Borrow ID" />

                    <asp:TemplateField HeaderText="Customer">
                        <ItemTemplate>
                            <strong>
                                <%#: Eval("FullName") %>
                            </strong>
                            <div class="refund-muted">
                                <%#: Eval("Email") %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Book">
                        <ItemTemplate>
                            <%#: Eval("Title") %>
                            <div class="refund-muted">
                                Returned:
                                <%# Eval("DateReturned",
                                    "{0:MMM dd, yyyy}") %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Deposit">
                        <ItemTemplate>
                            <div class="refund-money">
                                <%# string.Format(System.Globalization.CultureInfo.GetCultureInfo("en-PH"), "₱{0:N2}", Eval("AmountReceived")) %>
                            </div>
                            <div class="refund-muted">
                                Refunded:
                                <%# string.Format(System.Globalization.CultureInfo.GetCultureInfo("en-PH"), "₱{0:N2}", Eval("AmountRefunded")) %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Balance">
                        <ItemTemplate>
                            <span class='<%#
                                Convert.ToDecimal(
                                    Eval("OutstandingBalance")) > 0
                                ? "refund-warning"
                                : "refund-success" %>'>
                                <%# string.Format(System.Globalization.CultureInfo.GetCultureInfo("en-PH"), "₱{0:N2}", Eval("OutstandingBalance")) %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField
                        DataField="DepositStatus"
                        HeaderText="Status" />

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>

                            <asp:PlaceHolder
                                ID="phRefund"
                                runat="server"
                                Visible='<%#
                                    Convert.ToBoolean(
                                        Eval("CanRefund")) %>'>

                                <div class="refund-actions">

                                    <asp:DropDownList
                                        ID="ddlMethod"
                                        runat="server"
                                        CssClass="refund-input">

                                        <asp:ListItem
                                            Text="Select method"
                                            Value="" />

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

                                    <asp:TextBox
                                        ID="txtReference"
                                        runat="server"
                                        CssClass="refund-input"
                                        MaxLength="100"
                                        placeholder="Reference (optional)" />

                                    <asp:CheckBox
                                        ID="chkConfirmed"
                                        runat="server"
                                        CssClass="refund-check"
                                        Text=" I confirm that the refund was actually issued." />

                                    <asp:Button
                                        ID="btnRefund"
                                        runat="server"
                                        Text="Record Refund"
                                        CssClass="refund-btn"
                                        CommandName="Refund"
                                        CommandArgument='<%#
                                            Eval("BorrowLogID") %>'
                                        CausesValidation="false"
                                        OnClientClick="return confirm('Confirm that the full deposit amount has already been refunded to the customer?');" />

                                </div>

                            </asp:PlaceHolder>

                            <asp:Label
                                ID="lblUnavailable"
                                runat="server"
                                CssClass="refund-muted"
                                Visible='<%#
                                    !Convert.ToBoolean(
                                        Eval("CanRefund")) %>'
                                Text="No refund action available" />

                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

            </asp:GridView>

        </div>

        <div class="refund-pager">

            <asp:Button
                ID="btnPrevious"
                runat="server"
                Text="Previous"
                CssClass="refund-btn"
                OnClick="btnPrevious_Click" />

            <asp:Label
                ID="lblPage"
                runat="server" />

            <asp:Button
                ID="btnNext"
                runat="server"
                Text="Next"
                CssClass="refund-btn"
                OnClick="btnNext_Click" />

        </div>

    </div>

</div>

</asp:Content>