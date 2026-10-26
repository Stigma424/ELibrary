<%@ Page Title="Deposit Transaction History"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="DepositLedger.aspx.cs"
    Inherits="ELibrary.Transactions.DepositLedger" %>

<asp:Content ID="HeadContent"
    ContentPlaceHolderID="head"
    runat="server">

<style>
.deposit-ledger {
    max-width: 1250px;
    margin: 0 auto;
    color: #172b43;
}

.deposit-ledger-heading {
    margin-bottom: 25px;
}

.deposit-ledger-heading h1 {
    margin: 0 0 8px;
    font-size: 28px;
    font-weight: 800;
}

.deposit-ledger-heading p {
    margin: 0;
    font-size: 13px;
    color: #718096;
    line-height: 1.7;
}

.deposit-ledger-panel {
    background: #fff;
    border: 1px solid #e3eaf2;
    border-radius: 14px;
    padding: 24px;
    margin-bottom: 20px;
}

.deposit-ledger-filters {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    align-items: center;
}

.deposit-ledger-input {
    min-height: 42px;
    padding: 9px 12px;
    font-size: 13px;
    border: 1px solid #dce4ed;
    border-radius: 8px;
    background: #fff;
    color: #172b43;
}

.deposit-ledger-search {
    flex: 1;
    min-width: 220px;
}

.deposit-ledger-btn {
    min-height: 42px;
    padding: 10px 16px;
    border: none;
    border-radius: 8px;
    background: #2f6ba0;
    color: #fff;
    font-weight: 700;
    font-size: 12px;
    cursor: pointer;
}

.deposit-ledger-btn:hover {
    background: #255985;
}

.deposit-ledger-btn:disabled {
    opacity: .45;
    cursor: not-allowed;
}

.deposit-ledger-table-wrap {
    width: 100%;
    overflow-x: auto;
}

.deposit-ledger-table {
    width: 100%;
    min-width: 900px;
    border-collapse: collapse;
    font-size: 12px;
}

.deposit-ledger-table th {
    text-align: left;
    padding: 14px;
    background: #f5f8fc;
    color: #52667d;
    border-bottom: 1px solid #e3eaf2;
}

.deposit-ledger-table td {
    padding: 14px;
    vertical-align: middle;
    border-bottom: 1px solid #edf1f6;
    color: #53657a;
}

.deposit-ledger-table tr:hover td {
    background: #fafcff;
}

.deposit-ledger-table strong {
    color: #172b43;
}

.deposit-ledger-muted {
    color: #8290a1;
    font-size: 11px;
}

.deposit-ledger-amount {
    font-weight: 800;
    color: #172b43;
    white-space: nowrap;
}

.deposit-ledger-type {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 8px;
    font-size: 11px;
    font-weight: 800;
    background: #eaf2fc;
    color: #2f6ba0;
}

.deposit-ledger-type.refund {
    background: #e6f7ed;
    color: #238253;
}

.deposit-ledger-pager {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin-top: 20px;
}

.deposit-ledger-message {
    display: block;
    margin-bottom: 15px;
    color: #b92d2d;
    font-size: 13px;
}

.deposit-ledger-message:empty {
    display: none;
}

@media (max-width: 650px) {
    .deposit-ledger-panel {
        padding: 15px;
    }

    .deposit-ledger-filters {
        flex-direction: column;
        align-items: stretch;
    }

    .deposit-ledger-search {
        width: 100%;
    }

    .deposit-ledger-pager {
        flex-wrap: wrap;
    }
}
</style>

</asp:Content>

<asp:Content ID="MainPage"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="deposit-ledger">

    <div class="deposit-ledger-heading">

        <h1>Security Deposit Transactions</h1>

        <p>
            View security deposit collections,
            refunds, and transaction references.
        </p>

    </div>

    <asp:Label
        ID="lblMessage"
        runat="server"
        CssClass="deposit-ledger-message" />

    <div class="deposit-ledger-panel">

        <div class="deposit-ledger-filters">

            <asp:TextBox
                ID="txtSearch"
                runat="server"
                CssClass="deposit-ledger-input deposit-ledger-search"
                MaxLength="255"
                placeholder="Search customer, book, borrow ID or reference" />

            <asp:DropDownList
                ID="ddlType"
                runat="server"
                CssClass="deposit-ledger-input">

                <asp:ListItem
                    Text="All Transactions"
                    Value="All" />

                <asp:ListItem
                    Text="Collections"
                    Value="Collection" />

                <asp:ListItem
                    Text="Refunds"
                    Value="Refund" />

            </asp:DropDownList>

            <asp:Button
                ID="btnApply"
                runat="server"
                CssClass="deposit-ledger-btn"
                Text="Apply"
                OnClick="btnApply_Click" />

            <asp:Button
                ID="btnReset"
                runat="server"
                CssClass="deposit-ledger-btn"
                Text="Reset"
                OnClick="btnReset_Click" />

        </div>

    </div>

    <div class="deposit-ledger-panel">

        <div class="deposit-ledger-table-wrap">

            <asp:GridView
                ID="gvHistory"
                runat="server"
                AutoGenerateColumns="false"
                GridLines="None"
                CssClass="deposit-ledger-table"
                EmptyDataText="No deposit transactions found.">

                <Columns>

                    <asp:BoundField
                        DataField="DepositTransactionID"
                        HeaderText="Transaction ID" />

                    <asp:BoundField
                        DataField="BorrowLogID"
                        HeaderText="Borrow ID" />

                    <asp:TemplateField HeaderText="Customer">
                        <ItemTemplate>
                            <strong>
                                <%#: Eval("CustomerName") %>
                            </strong>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Book">
                        <ItemTemplate>
                            <%#: Eval("BookTitle") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Type">
                        <ItemTemplate>

                            <span class='<%#
                                "deposit-ledger-type " +
                                (Convert.ToString(
                                    Eval("TransactionType"))
                                    == "Refund"
                                ? "refund" : "") %>'>

                                <%#: Eval("TransactionType") %>

                            </span>

                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Amount">
                        <ItemTemplate>
                            <span class="deposit-ledger-amount">
                                <%# string.Format(System.Globalization.CultureInfo.GetCultureInfo("en-PH"), "₱{0:N2}", Eval("Amount")) %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField
                        DataField="PaymentMethod"
                        HeaderText="Method" />

                    <asp:TemplateField HeaderText="Reference">
                        <ItemTemplate>
                            <%#: Eval("ReferenceNo") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Processed By">
                        <ItemTemplate>
                            <%#: Eval("ProcessedBy") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField
                        DataField="TransactionDate"
                        HeaderText="Date"
                        DataFormatString="{0:MMM dd, yyyy hh:mm tt}"
                        HtmlEncode="true" />

                </Columns>

            </asp:GridView>

        </div>

        <div class="deposit-ledger-pager">

            <asp:Button
                ID="btnPrevious"
                runat="server"
                Text="Previous"
                CssClass="deposit-ledger-btn"
                OnClick="btnPrevious_Click" />

            <asp:Label
                ID="lblPage"
                runat="server" />

            <asp:Button
                ID="btnNext"
                runat="server"
                Text="Next"
                CssClass="deposit-ledger-btn"
                OnClick="btnNext_Click" />

        </div>

    </div>

</div>

</asp:Content>
