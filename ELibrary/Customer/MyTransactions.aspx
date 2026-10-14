<%@ Page Title="My Transactions"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="MyTransactions.aspx.cs"
    Inherits="ELibrary.Customer.MyTransactions" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <style>
        .el-records-page {
            width: 100%;
            max-width: 1450px;
            margin: 0 auto;
            padding: 24px 28px 45px;
            box-sizing: border-box;
        }

        .el-records-page *,
        .el-records-page *::before,
        .el-records-page *::after {
            box-sizing: border-box;
        }

        .el-records-heading {
            margin-bottom: 26px;
        }

        .el-records-panel {
            background: #ffffff;
            border: 1px solid #e0e8f1;
            border-radius: 15px;
            padding: 26px;
            margin: 24px 0;
            box-shadow: 0 4px 18px rgba(20,45,75,.04);
        }

        .el-records-panel-heading {
            margin-bottom: 22px;
        }

        .el-tx-summary {
            display: grid;
            grid-template-columns: repeat(4, minmax(0,1fr));
            gap: 14px;
            margin: 22px 0 28px;
        }

        .el-tx-card {
            background: #fff;
            border: 1px solid #dce5f0;
            border-radius: 14px;
            padding: 20px;
            box-shadow: 0 3px 12px rgba(20,45,75,.04);
            min-width: 0;
        }

        .el-tx-card .el-tx-label {
            display: block;
            color: #61748e;
            font-size: .85rem;
            margin-bottom: 9px;
            line-height: 1.5;
        }

        .el-tx-card strong {
            display: block;
            color: #142b49;
            font-size: 1.5rem;
            overflow-wrap: anywhere;
        }

        .el-tx-card .el-tx-icon {
            font-size: 1.3rem;
            margin-bottom: 10px;
        }

        .el-tx-filter-panel {
            background: #f5f8fc;
            border: 1px solid #dde7f1;
            border-radius: 12px;
            padding: 20px;
            margin: 18px 0 24px;
        }

        .el-tx-filter-grid {
            display: grid;
            grid-template-columns:
                minmax(190px,2fr)
                repeat(3,minmax(135px,1fr))
                auto;
            gap: 12px;
            align-items: end;
        }

        .el-tx-field {
            min-width: 0;
        }

        .el-tx-field label {
            display: block;
            color: #354c69;
            font-size: .86rem;
            font-weight: 650;
            margin-bottom: 7px;
        }

        .el-tx-input {
            display: block;
            width: 100%;
            min-height: 42px;
            border: 1px solid #d4e0ed;
            border-radius: 9px;
            background: #fff;
            color: #172d49;
            padding: 9px 12px;
            font: inherit;
        }

        .el-tx-input:focus {
            outline: 2px solid #9cc5ef;
            outline-offset: 1px;
        }

        .el-tx-button {
            min-height: 42px;
            border: 1px solid #bed0e2;
            background: #fff;
            border-radius: 9px;
            padding: 9px 15px;
            color: #1c4169;
            font-weight: 650;
            cursor: pointer;
        }

        .el-tx-button:hover {
            background: #eaf2fa;
        }

        .el-tx-results {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            color: #61748e;
            font-size: .88rem;
            margin: 18px 0;
            padding: 0 2px;
        }

        .el-tx-status {
            display: inline-block;
            border-radius: 999px;
            padding: 5px 10px;
            font-size: .76rem;
            font-weight: 700;
            white-space: nowrap;
        }

        .el-tx-status-paid {
            background: #e6f6ed;
            color: #177345;
        }

        .el-tx-status-unpaid {
            background: #fff0ed;
            color: #a53e2b;
        }

        .el-tx-status-partial {
            background: #fff5d9;
            color: #8d6100;
        }

        .el-tx-status-unknown {
            background: #eef2f6;
            color: #506176;
        }

        .el-tx-empty {
            padding: 18px;
            text-align: center;
            color: #65758a;
        }

        .el-records-table-scroll {
            width: 100%;
            overflow-x: auto;
            border: 1px solid #e3eaf2;
            border-radius: 11px;
            background: #fff;
        }

        .el-records-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }

        .el-records-table th {
            padding: 16px 18px !important;
            background: #f3f7fb;
            color: #354c69;
            font-size: 12px;
            font-weight: 750;
            text-align: left;
            white-space: nowrap;
            border-bottom: 1px solid #dfe8f2;
        }

        .el-records-table td {
            padding: 17px 18px !important;
            vertical-align: middle;
            border-bottom: 1px solid #edf1f6;
            font-size: 13px;
            line-height: 1.65;
        }

        .el-records-table tr:last-child td {
            border-bottom: none;
        }

        .el-records-book-cell {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .el-tx-pager {
            margin-top: 14px;
        }

        .el-tx-pager td {
            padding: 14px !important;
            text-align: center;
        }

        .el-tx-pager table {
            margin: 0 auto;
        }

        .el-tx-pager a,
        .el-tx-pager span {
            display: inline-block;
            padding: 6px 10px;
            margin: 2px;
            border: 1px solid #d5e0eb;
            border-radius: 7px;
            text-decoration: none;
        }

        .el-records-panel-footer {
            margin-top: 20px;
            padding-top: 16px;
            border-top: 1px solid #e9eef4;
        }

        .el-records-bottom-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin: 24px 0 15px;
        }

        @media (max-width: 1080px) {
            .el-tx-summary {
                grid-template-columns: repeat(2,minmax(0,1fr));
            }

            .el-tx-filter-grid {
                grid-template-columns: repeat(2,minmax(0,1fr));
            }
        }

        @media (max-width: 768px) {
            .el-records-page {
                padding: 16px 14px 32px;
            }

            .el-records-panel {
                padding: 17px;
                margin: 18px 0;
            }

            .el-tx-filter-panel {
                padding: 15px;
            }

            .el-records-table th,
            .el-records-table td {
                padding: 13px 14px !important;
            }
        }

        @media (max-width: 600px) {
            .el-tx-summary {
                grid-template-columns: 1fr 1fr;
                gap: 9px;
            }

            .el-tx-card {
                padding: 13px;
            }

            .el-tx-card strong {
                font-size: 1.12rem;
            }

            .el-tx-filter-grid {
                grid-template-columns: 1fr;
            }

            .el-tx-results {
                align-items: flex-start;
                flex-direction: column;
            }
        }

        @media (max-width: 480px) {
            .el-records-page {
                padding: 12px 10px 25px;
            }

            .el-records-panel {
                padding: 12px;
            }

            .el-records-table th,
            .el-records-table td {
                padding: 12px !important;
            }
        }
    </style>

    <div class="el-records-page">

        <div class="el-records-heading">

            <div>
                <span class="el-section-eyebrow">
                    PAYMENT RECORDS
                </span>

                <h1>My Transactions</h1>

                <p>
                    View your borrowing fees, payments,
                    and transaction history.
                </p>
            </div>

            <a href="<%= ResolveUrl("~/Customer/Books.aspx") %>"
               class="el-records-primary-link">
                Browse Books →
            </a>

        </div>

        <!-- SUMMARY CARDS -->

        <div class="el-tx-summary">

            <div class="el-tx-card">
                <div class="el-tx-icon">💰</div>
                <span class="el-tx-label">
                    Outstanding Balance
                </span>
                <strong>
                    ₱<asp:Label
                        ID="lblOutstandingBalance"
                        runat="server"
                        Text="0.00" />
                </strong>
            </div>

            <div class="el-tx-card">
                <div class="el-tx-icon">💳</div>
                <span class="el-tx-label">
                    Total Payments Recorded
                </span>
                <strong>
                    ₱<asp:Label
                        ID="lblTotalPaid"
                        runat="server"
                        Text="0.00" />
                </strong>
            </div>

            <div class="el-tx-card">
                <div class="el-tx-icon">⏳</div>
                <span class="el-tx-label">
                    Unpaid / Partial Transactions
                </span>
                <strong>
                    <asp:Label
                        ID="lblUnpaidCount"
                        runat="server"
                        Text="0" />
                </strong>
            </div>

            <div class="el-tx-card">
                <div class="el-tx-icon">🧾</div>
                <span class="el-tx-label">
                    Total Transactions
                </span>
                <strong>
                    <asp:Label
                        ID="lblTransactionCount"
                        runat="server"
                        Text="0" />
                </strong>
            </div>

        </div>

        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="el-records-message" />

        <!-- TRANSACTION HISTORY -->

        <section class="el-records-panel">

            <div class="el-records-panel-heading">
                <div>
                    <h2>Transaction History</h2>
                    <p>
                        Search and review your recorded library
                        payments and remaining balances.
                    </p>
                </div>
            </div>

            <!-- FILTERS -->

            <div class="el-tx-filter-panel">

                <asp:Panel
                    ID="pnlFilters"
                    runat="server"
                    DefaultButton="btnSearch">

                    <div class="el-tx-filter-grid">

                        <div class="el-tx-field">

                            <label for="<%= txtSearch.ClientID %>">
                                Search Transactions
                            </label>

                            <asp:TextBox
                                ID="txtSearch"
                                runat="server"
                                CssClass="el-tx-input"
                                placeholder="Receipt number, book, or fee type..." />

                        </div>

                        <div class="el-tx-field">

                            <label for="<%= ddlStatus.ClientID %>">
                                Payment Status
                            </label>

                            <asp:DropDownList
                                ID="ddlStatus"
                                runat="server"
                                CssClass="el-tx-input">

                                <asp:ListItem
                                    Text="All Statuses"
                                    Value="All" />

                                <asp:ListItem
                                    Text="Paid"
                                    Value="Paid" />

                                <asp:ListItem
                                    Text="Unpaid"
                                    Value="Unpaid" />

                                <asp:ListItem
                                    Text="Partially Paid"
                                    Value="Partial" />

                            </asp:DropDownList>

                        </div>

                        <div class="el-tx-field">

                            <label for="<%= ddlMethod.ClientID %>">
                                Payment Method
                            </label>

                            <asp:DropDownList
                                ID="ddlMethod"
                                runat="server"
                                CssClass="el-tx-input">

                                <asp:ListItem
                                    Text="All Methods"
                                    Value="All" />

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

                                <asp:ListItem
                                    Text="Not Set"
                                    Value="Not Set" />

                            </asp:DropDownList>

                        </div>

                        <div class="el-tx-field">

                            <label for="<%= ddlSort.ClientID %>">
                                Sort By
                            </label>

                            <asp:DropDownList
                                ID="ddlSort"
                                runat="server"
                                CssClass="el-tx-input">

                                <asp:ListItem
                                    Text="Newest First"
                                    Value="Newest" />

                                <asp:ListItem
                                    Text="Oldest First"
                                    Value="Oldest" />

                            </asp:DropDownList>

                        </div>

                        <div class="el-tx-field">

                            <asp:Button
                                ID="btnSearch"
                                runat="server"
                                Text="Apply Filters"
                                CssClass="btn btn-primary"
                                OnClick="btnSearch_Click" />

                        </div>

                    </div>

                    <div style="margin-top: 10px;">

                        <asp:Button
                            ID="btnClear"
                            runat="server"
                            Text="Clear Filters"
                            CssClass="el-tx-button"
                            OnClick="btnClear_Click"
                            CausesValidation="false" />

                    </div>

                </asp:Panel>

            </div>

            <!-- RESULTS -->

            <div class="el-tx-results">

                <span>
                    <asp:Label
                        ID="lblResultCount"
                        runat="server"
                        Text="Showing 0 of 0 transactions" />
                </span>

                <span>
                    Payment status is based on the remaining balance.
                </span>

            </div>

            <!-- TABLE -->

            <div class="el-records-table-scroll">

                <asp:GridView
                    ID="gvTransactions"
                    runat="server"
                    AutoGenerateColumns="False"
                    CssClass="el-records-table"
                    GridLines="None"
                    EmptyDataText="No transactions match your search or filters."
                    AllowPaging="true"
                    PageSize="10"
                    OnPageIndexChanging="gvTransactions_PageIndexChanging">

                    <PagerStyle CssClass="el-tx-pager" />

                    <Columns>

                        <asp:TemplateField HeaderText="Receipt">
                            <ItemTemplate>
                                <div class="el-records-book-cell">
                                    <strong>
                                        <%#: Eval("ReceiptNo") %>
                                    </strong>
                                    <small>
                                        ID: <%#: Eval("ReceiptID") %>
                                    </small>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Book">
                            <ItemTemplate>
                                <strong class="el-records-book-title">
                                    <%#: Eval("Title") %>
                                </strong>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Fee Type">
                            <ItemTemplate>
                                <span class="el-records-fee-type">
                                    <%#: Eval("FeeType") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Amount Paid">
                            <ItemTemplate>
                                <span class="el-records-money">
                                    ₱<%# Eval("AmountPaid", "{0:N2}") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Remaining Balance">
                            <ItemTemplate>
                                <span class='<%# GetBalanceClass(Eval("Balance")) %>'>
                                    ₱<%# Eval("Balance", "{0:N2}") %>
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

                        <asp:BoundField
                            DataField="PaymentMethod"
                            HeaderText="Payment Method"
                            NullDisplayText="—" />

                        <asp:BoundField
                            DataField="TransactionDate"
                            HeaderText="Transaction Date"
                            DataFormatString="{0:MMM dd, yyyy hh:mm tt}" />

                    </Columns>

                </asp:GridView>

            </div>

            <div class="el-records-panel-footer">
                <span>
                    These records reflect transactions stored
                    in the library system.
                </span>
            </div>

        </section>

        <!-- BOTTOM ACTIONS -->

        <div class="el-records-bottom-actions">

            <asp:HyperLink
                ID="lnkBooks"
                runat="server"
                NavigateUrl="~/Customer/Books.aspx"
                CssClass="btn btn-primary">
                Browse Books
            </asp:HyperLink>

            <asp:HyperLink
                ID="lnkBorrows"
                runat="server"
                NavigateUrl="~/Customer/MyBorrows.aspx"
                CssClass="btn btn-outline-secondary">
                My Borrowings
            </asp:HyperLink>

        </div>

    </div>

</asp:Content>