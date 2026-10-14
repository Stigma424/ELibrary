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
        .el-tx {
            color: #172b43;
        }

        .el-tx * {
            box-sizing: border-box;
        }

        .el-tx-header {
            margin-bottom: 24px;
        }

        .el-tx-eyebrow {
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .12em;
            color: #2f6ba0;
        }

        .el-tx h1 {
            font-size: 29px;
            font-weight: 750;
            margin: 7px 0;
        }

        .el-tx-header p,
        .el-tx-panel-head p {
            color: #718096;
            margin: 5px 0 0;
        }

        .el-tx-panel {
            background: #fff;
            border: 1px solid #e4ebf3;
            border-radius: 13px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 3px 14px rgba(23,43,67,.04);
        }

        .el-tx-panel-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 18px;
        }

        .el-tx-panel-head h2 {
            font-size: 19px;
            font-weight: 750;
            margin: 0;
        }

        .el-tx-tag {
            background: #eaf1f9;
            color: #2f6ba0;
            padding: 6px 11px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 750;
        }

        .el-tx-tag.warning {
            background: #fff1ce;
            color: #8a6100;
        }

        .el-tx-filters {
            display: grid;
            grid-template-columns:
                minmax(200px,2fr)
                repeat(2,minmax(140px,1fr))
                auto;
            gap: 12px;
            align-items: end;
            padding: 16px;
            background: #f8fafc;
            border: 1px solid #e4ebf3;
            border-radius: 10px;
        }

        .el-tx-field {
            min-width: 0;
        }

        .el-tx-field label {
            display: block;
            margin-bottom: 7px;
            color: #43566b;
            font-size: 12px;
            font-weight: 700;
        }

        .el-tx-field input,
        .el-tx-field select {
            display: block;
            width: 100%;
            min-height: 40px;
            padding: 9px 11px;
            background: #fff;
            color: #172b43;
            border: 1px solid #dce5ee;
            border-radius: 8px;
            font-size: 13px;
        }

        .el-tx-field input:focus,
        .el-tx-field select:focus {
            outline: none;
            border-color: #2f6ba0;
            box-shadow: 0 0 0 3px rgba(47,107,160,.12);
        }

        .el-tx-filter-actions {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .el-tx-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 40px;
            padding: 9px 15px;
            border: 1px solid #dce5ee;
            border-radius: 8px;
            background: #fff;
            color: #172b43;
            font-size: 13px;
            font-weight: 650;
            cursor: pointer;
            white-space: nowrap;
        }

        .el-tx-btn:hover {
            background: #f1f6fb;
        }

        .el-tx-btn-primary {
            background: #2f6ba0;
            color: #fff;
            border-color: #2f6ba0;
        }

        .el-tx-btn-primary:hover {
            background: #235680;
            color: #fff;
        }

        .el-tx-btn:disabled {
            opacity: .45;
            cursor: default;
        }

        .el-tx-count {
            display: block;
            margin: 12px 0;
            font-size: 12px;
            color: #718096;
        }

        .el-tx-table-wrap {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        .el-tx-table {
            width: 100%;
            min-width: 950px;
            border-collapse: collapse;
            font-size: 13px;
        }

        .el-tx-table th {
            background: #f4f7fb;
            color: #52647a;
            text-align: left;
            text-transform: uppercase;
            font-size: 11px;
            letter-spacing: .04em;
            padding: 13px 12px;
            white-space: nowrap;
            border-bottom: 1px solid #e4ebf3;
        }

        .el-tx-table td {
            padding: 13px 12px;
            border-bottom: 1px solid #edf1f5;
            vertical-align: middle;
        }

        .el-tx-table tr:hover td {
            background: #f9fbfe;
        }

        .el-tx-pay {
            background: #e6f7ec;
            color: #237c4e;
            border: 1px solid #ccebd9;
            border-radius: 7px;
            padding: 8px 15px;
            font-size: 12px;
            font-weight: 750;
            cursor: pointer;
        }

        .el-tx-pay:hover {
            background: #d5efdf;
        }

        .el-tx-message {
            display: block;
            margin-bottom: 14px;
            color: #bd4141;
        }

        .el-tx-message:empty {
            display: none;
        }

        .el-tx-pager {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            padding: 18px 0 4px;
        }

        .el-tx-page-info {
            font-size: 13px;
            color: #61748e;
        }

        @media(max-width:1100px) {
            .el-tx-filters {
                grid-template-columns:
                    repeat(2,minmax(0,1fr));
            }

            .el-tx-filter-actions {
                grid-column: 1 / -1;
            }
        }

        @media(max-width:600px) {
            .el-tx h1 {
                font-size: 24px;
            }

            .el-tx-panel {
                padding: 14px;
            }

            .el-tx-filters {
                grid-template-columns: 1fr;
                padding: 12px;
            }

            .el-tx-filter-actions {
                grid-column: auto;
                flex-wrap: wrap;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="el-tx">

        <div class="el-tx-header">
            <span class="el-tx-eyebrow">
                ADMINISTRATION / FINANCIAL MANAGEMENT
            </span>

            <h1>Manage Transactions</h1>

            <p>
                Monitor transaction history and outstanding customer fees.
            </p>
        </div>

        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="el-tx-message" />

        <!-- ===================================== -->
        <!-- TRANSACTION HISTORY -->
        <!-- ===================================== -->

        <section class="el-tx-panel">

            <div class="el-tx-panel-head">
                <div>
                    <h2>Transaction History</h2>
                    <p>Search and review recorded transactions.</p>
                </div>

                <span class="el-tx-tag">
                    TRANSACTION RECORDS
                </span>
            </div>

            <asp:Panel
                ID="pnlHistoryFilters"
                runat="server"
                DefaultButton="btnHistoryApply"
                CssClass="el-tx-filters">

                <div class="el-tx-field">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtHistorySearch"
                        Text="Search Transactions" />

                    <asp:TextBox
                        ID="txtHistorySearch"
                        runat="server"
                        MaxLength="255"
                        placeholder="Search receipt, customer, book..."
                        autocomplete="off" />

                </div>

                <div class="el-tx-field">

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

                <div class="el-tx-field">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlHistoryMethod"
                        Text="Payment Method" />

                    <asp:DropDownList
                        ID="ddlHistoryMethod"
                        runat="server">

                        <asp:ListItem
                            Text="All Methods"
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

                </div>

                <div class="el-tx-field">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlHistorySort"
                        Text="Sort By" />

                    <asp:DropDownList
                        ID="ddlHistorySort"
                        runat="server">

                        <asp:ListItem
                            Text="Default Order"
                            Value="Default" />

                        <asp:ListItem
                            Text="Newest First"
                            Value="DateDesc" />

                        <asp:ListItem
                            Text="Oldest First"
                            Value="DateAsc" />

                        <asp:ListItem
                            Text="Highest Balance"
                            Value="BalanceDesc" />

                        <asp:ListItem
                            Text="Lowest Balance"
                            Value="BalanceAsc" />

                        <asp:ListItem
                            Text="Highest Payment"
                            Value="PaidDesc" />

                        <asp:ListItem
                            Text="Highest ID First"
                            Value="IDDesc" />

                    </asp:DropDownList>

                </div>

                <div class="el-tx-filter-actions">

                    <asp:Button
                        ID="btnHistoryApply"
                        runat="server"
                        Text="Apply"
                        CssClass="el-tx-btn el-tx-btn-primary"
                        CausesValidation="false"
                        OnClick="btnHistoryApply_Click" />

                    <asp:Button
                        ID="btnHistoryClear"
                        runat="server"
                        Text="Clear Filters"
                        CssClass="el-tx-btn"
                        CausesValidation="false"
                        OnClick="btnHistoryClear_Click" />

                </div>

            </asp:Panel>

            <p class="el-tx-count">
                Press Enter or click Apply to search and filter.
            </p>

            <asp:Label
                ID="lblHistoryCount"
                runat="server"
                CssClass="el-tx-count" />

            <div class="el-tx-table-wrap">

                <asp:GridView
                    ID="gvTransactions"
                    runat="server"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    CssClass="el-tx-table"
                    EmptyDataText="No transactions match your filters.">

                    <Columns>

                        <asp:BoundField
                            DataField="ReceiptID"
                            HeaderText="ID" />

                        <asp:BoundField
                            DataField="ReceiptNo"
                            HeaderText="Receipt No." />

                        <asp:BoundField
                            DataField="FullName"
                            HeaderText="Customer" />

                        <asp:BoundField
                            DataField="Title"
                            HeaderText="Book" />

                        <asp:BoundField
                            DataField="FeeType"
                            HeaderText="Fee Type" />

                        <asp:BoundField
                            DataField="Balance"
                            HeaderText="Balance"
                            DataFormatString="₱{0:N2}" />

                        <asp:BoundField
                            DataField="AmountPaid"
                            HeaderText="Amount Paid"
                            DataFormatString="₱{0:N2}" />

                        <asp:BoundField
                            DataField="PaymentMethod"
                            HeaderText="Payment Method"
                            NullDisplayText="—" />

                        <asp:BoundField
                            DataField="TransactionDate"
                            HeaderText="Transaction Date"
                            DataFormatString="{0:MM/dd/yyyy hh:mm tt}" />

                    </Columns>

                </asp:GridView>

            </div>

            <div class="el-tx-pager">

                <asp:Button
                    ID="btnHistoryPrevious"
                    runat="server"
                    Text="← Previous"
                    CssClass="el-tx-btn"
                    CausesValidation="false"
                    OnClick="btnHistoryPrevious_Click" />

                <asp:Label
                    ID="lblHistoryPage"
                    runat="server"
                    CssClass="el-tx-page-info"
                    Text="Page 1 of 1" />

                <asp:Button
                    ID="btnHistoryNext"
                    runat="server"
                    Text="Next →"
                    CssClass="el-tx-btn"
                    CausesValidation="false"
                    OnClick="btnHistoryNext_Click" />

            </div>

        </section>

        <!-- ===================================== -->
        <!-- UNPAID FEES -->
        <!-- ===================================== -->

        <section class="el-tx-panel">

            <div class="el-tx-panel-head">
                <div>
                    <h2>Unpaid Fees</h2>
                    <p>
                        Track outstanding balances and record payments.
                    </p>
                </div>

                <span class="el-tx-tag warning">
                    OUTSTANDING PAYMENTS
                </span>
            </div>

            <asp:Panel
                ID="pnlUnpaidFilters"
                runat="server"
                DefaultButton="btnUnpaidApply"
                CssClass="el-tx-filters">

                <div class="el-tx-field">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtUnpaidSearch"
                        Text="Search Unpaid Fees" />

                    <asp:TextBox
                        ID="txtUnpaidSearch"
                        runat="server"
                        MaxLength="255"
                        placeholder="Search receipt, customer, book..."
                        autocomplete="off" />

                </div>

                <div class="el-tx-field">

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

                <div class="el-tx-field">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlUnpaidSort"
                        Text="Sort By" />

                    <asp:DropDownList
                        ID="ddlUnpaidSort"
                        runat="server">

                        <asp:ListItem
                            Text="Default Order"
                            Value="Default" />

                        <asp:ListItem
                            Text="Highest Balance"
                            Value="BalanceDesc" />

                        <asp:ListItem
                            Text="Lowest Balance"
                            Value="BalanceAsc" />

                        <asp:ListItem
                            Text="Newest First"
                            Value="DateDesc" />

                        <asp:ListItem
                            Text="Oldest First"
                            Value="DateAsc" />

                        <asp:ListItem
                            Text="Highest ID First"
                            Value="IDDesc" />

                    </asp:DropDownList>

                </div>

                <div class="el-tx-filter-actions">

                    <asp:Button
                        ID="btnUnpaidApply"
                        runat="server"
                        Text="Apply"
                        CssClass="el-tx-btn el-tx-btn-primary"
                        CausesValidation="false"
                        OnClick="btnUnpaidApply_Click" />

                    <asp:Button
                        ID="btnUnpaidClear"
                        runat="server"
                        Text="Clear Filters"
                        CssClass="el-tx-btn"
                        CausesValidation="false"
                        OnClick="btnUnpaidClear_Click" />

                </div>

            </asp:Panel>

            <p class="el-tx-count">
                Press Enter or click Apply to search and filter.
            </p>

            <asp:Label
                ID="lblUnpaidCount"
                runat="server"
                CssClass="el-tx-count" />

            <div class="el-tx-table-wrap">

                <asp:GridView
                    ID="gvUnpaid"
                    runat="server"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    CssClass="el-tx-table"
                    EmptyDataText="No unpaid fees match your filters.">

                    <Columns>

                        <asp:BoundField
                            DataField="ReceiptID"
                            HeaderText="Receipt ID" />

                        <asp:BoundField
                            DataField="ReceiptNo"
                            HeaderText="Receipt No." />

                        <asp:BoundField
                            DataField="FullName"
                            HeaderText="Customer" />

                        <asp:BoundField
                            DataField="Title"
                            HeaderText="Book" />

                        <asp:BoundField
                            DataField="FeeType"
                            HeaderText="Fee Type" />

                        <asp:BoundField
                            DataField="Balance"
                            HeaderText="Outstanding Balance"
                            DataFormatString="₱{0:N2}" />

                        <asp:BoundField
                            DataField="AmountPaid"
                            HeaderText="Amount Paid"
                            DataFormatString="₱{0:N2}" />

                        <asp:BoundField
                            DataField="TransactionDate"
                            HeaderText="Transaction Date"
                            DataFormatString="{0:MM/dd/yyyy hh:mm tt}" />

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>

                                <asp:Button
                                    ID="btnPay"
                                    runat="server"
                                    Text="Pay"
                                    CssClass="el-tx-pay"
                                    CommandName="PayFee"
                                    CommandArgument='<%# Eval("ReceiptID") %>'
                                    CausesValidation="false"
                                    OnCommand="btnPay_Command" />

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

            <div class="el-tx-pager">

                <asp:Button
                    ID="btnUnpaidPrevious"
                    runat="server"
                    Text="← Previous"
                    CssClass="el-tx-btn"
                    CausesValidation="false"
                    OnClick="btnUnpaidPrevious_Click" />

                <asp:Label
                    ID="lblUnpaidPage"
                    runat="server"
                    CssClass="el-tx-page-info"
                    Text="Page 1 of 1" />

                <asp:Button
                    ID="btnUnpaidNext"
                    runat="server"
                    Text="Next →"
                    CssClass="el-tx-btn"
                    CausesValidation="false"
                    OnClick="btnUnpaidNext_Click" />

            </div>

        </section>

    </div>

</asp:Content>