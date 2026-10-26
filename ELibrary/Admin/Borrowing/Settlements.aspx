<%@ Page Title="Reservation and Lost Book Settlements"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Settlements.aspx.cs"
    Inherits="ELibrary.Admin.Borrowing.Settlements" %>

<asp:Content ID="MainPage"
    ContentPlaceHolderID="MainContent"
    runat="server">

<style>
.settle-page {
    max-width: 1250px;
    margin: 0 auto;
    color: #172b43;
}

.settle-heading {
    margin-bottom: 25px;
}

.settle-heading h1 {
    font-size: 28px;
    font-weight: 800;
    margin-bottom: 8px;
}

.settle-heading p {
    color: #718096;
    font-size: 13px;
    line-height: 1.7;
}

.settle-panel {
    background: #fff;
    border: 1px solid #e3eaf2;
    border-radius: 14px;
    padding: 24px;
    margin-bottom: 22px;
}

.settle-panel h2 {
    font-size: 19px;
    font-weight: 800;
    margin: 0 0 10px;
}

.settle-panel p {
    color: #718096;
    font-size: 13px;
    line-height: 1.7;
}

.settle-filters {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 12px;
    margin-bottom: 20px;
}

.settle-input {
    min-height: 42px;
    padding: 9px 12px;
    border: 1px solid #dce4ed;
    border-radius: 8px;
    background: #fff;
    color: #172b43;
    font-size: 13px;
}

.settle-search {
    flex: 1;
    min-width: 220px;
}

.settle-button {
    min-height: 42px;
    border: none;
    border-radius: 8px;
    background: #2f6ba0;
    padding: 10px 16px;
    color: #fff;
    font-size: 12px;
    font-weight: 700;
    cursor: pointer;
}

.settle-button:hover {
    background: #255985;
}

.settle-button:disabled {
    cursor: not-allowed;
    opacity: .5;
}

.settle-button-danger {
    background: #a94747;
}

.settle-button-danger:hover {
    background: #913535;
}

.settle-button-success {
    background: #238253;
}

.settle-button-success:hover {
    background: #196c43;
}

.settle-expiration {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
    margin-top: 20px;
}

.settle-expiration label {
    font-size: 12px;
    font-weight: 700;
}

.settle-expiration input[type=text] {
    width: 100px;
}

.settle-table-wrap {
    overflow-x: auto;
}

.settle-table {
    width: 100%;
    min-width: 1050px;
    border-collapse: collapse;
    font-size: 12px;
}

.settle-table th {
    padding: 14px 12px;
    background: #f5f8fc;
    text-align: left;
    color: #52667d;
    border-bottom: 1px solid #e3eaf2;
}

.settle-table td {
    padding: 14px 12px;
    vertical-align: middle;
    border-bottom: 1px solid #edf1f6;
    color: #53657a;
}

.settle-table tr:hover td {
    background: #fafcff;
}

.settle-table strong {
    color: #172b43;
}

.settle-money {
    font-weight: 800;
    white-space: nowrap;
}

.settle-danger {
    color: #ba4545;
    font-weight: 800;
}

.settle-success {
    color: #238253;
    font-weight: 800;
}

.settle-muted {
    color: #8290a1;
    font-size: 11px;
}

.settle-actions {
    display: flex;
    flex-direction: column;
    gap: 9px;
    min-width: 185px;
}

.settle-actions select,
.settle-actions input[type=text] {
    width: 100%;
}

.settle-confirm {
    font-size: 11px;
    line-height: 1.6;
}

.settle-message {
    display: block;
    margin: 15px 0;
    font-size: 13px;
    font-weight: 700;
}

.settle-pager {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    margin-top: 20px;
}

@media (max-width: 650px) {
    .settle-panel {
        padding: 15px;
    }

    .settle-filters {
        flex-direction: column;
        align-items: stretch;
    }

    .settle-search {
        width: 100%;
    }
}
</style>

<div class="settle-page">

    <div class="settle-heading">
        <h1>Reservation &amp; Lost-Book Settlements</h1>
        <p>
            Process expired unpaid reservations and
            refund eligible security deposits for lost books.
        </p>
    </div>

    <asp:Label
        ID="lblMessage"
        runat="server"
        CssClass="settle-message" />

    <div class="settle-panel">

        <h2>Expired Reservation Processing</h2>

        <p>
            Cancel online reservations that have passed
            their payment deadline and remain unpaid.
            The system validates each reservation before
            cancelling it.
        </p>

        <div class="settle-expiration">

            <label for="<%= txtBatchSize.ClientID %>">
                Batch size
            </label>

            <asp:TextBox
                ID="txtBatchSize"
                runat="server"
                Text="100"
                MaxLength="3"
                CssClass="settle-input" />

            <asp:Button
                ID="btnProcessExpired"
                runat="server"
                Text="Process Expired Reservations"
                CssClass="settle-button settle-button-danger"
                OnClick="btnProcessExpired_Click"
                OnClientClick="return confirm('Process eligible expired unpaid reservations? This will cancel qualifying reservations.');" />

        </div>

        <asp:Label
            ID="lblExpirationResult"
            runat="server"
            CssClass="settle-message" />

    </div>

    <div class="settle-panel">

        <h2>Lost-Book Security Deposit Settlements</h2>

        <p>
            A held deposit becomes refundable after all
            required fees, including the replacement fee,
            have been fully paid.
        </p>

        <div class="settle-filters">

            <asp:TextBox
                ID="txtSearch"
                runat="server"
                CssClass="settle-input settle-search"
                MaxLength="255"
                placeholder="Customer, book, email, or borrow ID" />

            <asp:DropDownList
                ID="ddlStatus"
                runat="server"
                CssClass="settle-input">

                <asp:ListItem
                    Text="All Settlements"
                    Value="All" />

                <asp:ListItem
                    Text="On Hold"
                    Value="OnHold" />

                <asp:ListItem
                    Text="Refunded"
                    Value="Refunded" />

            </asp:DropDownList>

            <asp:Button
                ID="btnApply"
                runat="server"
                Text="Apply"
                CssClass="settle-button"
                OnClick="btnApply_Click" />

            <asp:Button
                ID="btnReset"
                runat="server"
                Text="Reset"
                CssClass="settle-button"
                OnClick="btnReset_Click" />

        </div>

        <div class="settle-table-wrap">

            <asp:GridView
                ID="gvSettlements"
                runat="server"
                AutoGenerateColumns="false"
                GridLines="None"
                CssClass="settle-table"
                DataKeyNames="BorrowLogID"
                OnRowCommand="gvSettlements_RowCommand"
                EmptyDataText="No lost-book settlement records found.">

                <Columns>

                    <asp:BoundField
                        DataField="BorrowLogID"
                        HeaderText="Borrow ID" />

                    <asp:TemplateField HeaderText="Customer">
                        <ItemTemplate>
                            <strong>
                                <%#: Eval("FullName") %>
                            </strong>
                            <div class="settle-muted">
                                <%#: Eval("Email") %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Lost Book">
                        <ItemTemplate>
                            <strong>
                                <%#: Eval("Title") %>
                            </strong>
                            <div class="settle-muted">
                                <%# Eval("LostDate",
                                    "{0:MMM dd, yyyy}") %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Deposit">
                        <ItemTemplate>
                            <div class="settle-money">
                                <%# string.Format(System.Globalization.CultureInfo.GetCultureInfo("en-PH"), "₱{0:N2}", Eval("AmountReceived")) %>
                            </div>
                            <div class="settle-muted">
                                Refunded:
                                <%# string.Format(System.Globalization.CultureInfo.GetCultureInfo("en-PH"), "₱{0:N2}", Eval("AmountRefunded")) %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Unpaid Fees">
                        <ItemTemplate>
                            <span class='<%#
                                Convert.ToDecimal(
                                    Eval("OutstandingBalance")) > 0
                                ? "settle-danger"
                                : "settle-success" %>'>
                                <%# string.Format(System.Globalization.CultureInfo.GetCultureInfo("en-PH"), "₱{0:N2}", Eval("OutstandingBalance")) %>
                            </span>
                            <div class="settle-muted">
                                Replacement balance:
                                <%# string.Format(System.Globalization.CultureInfo.GetCultureInfo("en-PH"), "₱{0:N2}", Eval("ReplacementBalance")) %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField
                        DataField="DepositStatus"
                        HeaderText="Deposit Status" />

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>

                            <asp:PlaceHolder
                                ID="phSettle"
                                runat="server"
                                Visible='<%#
                                    Convert.ToBoolean(
                                        Eval("CanSettle")) %>'>

                                <div class="settle-actions">

                                    <asp:DropDownList
                                        ID="ddlRefundMethod"
                                        runat="server"
                                        CssClass="settle-input">

                                        <asp:ListItem
                                            Text="Select refund method"
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
                                        CssClass="settle-input"
                                        MaxLength="100"
                                        placeholder="Reference (optional)" />

                                    <asp:CheckBox
                                        ID="chkConfirmed"
                                        runat="server"
                                        CssClass="settle-confirm"
                                        Text=" I confirm the deposit was actually refunded." />

                                    <asp:Button
                                        ID="btnSettle"
                                        runat="server"
                                        Text="Record Settlement"
                                        CssClass="settle-button settle-button-success"
                                        CausesValidation="false"
                                        CommandName="Settle"
                                        CommandArgument='<%#
                                            Eval("BorrowLogID") %>'
                                        OnClientClick="return confirm('Confirm the deposit has already been refunded to the customer?');" />

                                </div>

                            </asp:PlaceHolder>

                            <asp:Label
                                ID="lblUnavailable"
                                runat="server"
                                CssClass="settle-muted"
                                Visible='<%#
                                    !Convert.ToBoolean(
                                        Eval("CanSettle")) %>'
                                Text="Not eligible for settlement" />

                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

            </asp:GridView>

        </div>

        <div class="settle-pager">

            <asp:Button
                ID="btnPrevious"
                runat="server"
                Text="Previous"
                CssClass="settle-button"
                OnClick="btnPrevious_Click" />

            <asp:Label
                ID="lblPage"
                runat="server" />

            <asp:Button
                ID="btnNext"
                runat="server"
                Text="Next"
                CssClass="settle-button"
                OnClick="btnNext_Click" />

        </div>

    </div>

</div>

</asp:Content>