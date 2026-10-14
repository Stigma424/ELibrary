
<%@ Page Title="Walk-in Borrowing"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="WalkInBorrow.aspx.cs"
    Inherits="ELibrary.Admin.Borrowing.WalkInBorrow" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <style>
        .walkin-page {
            max-width: 1050px;
            margin: 0 auto;
            padding: 24px 16px 48px;
            color: #19334f;
        }

        .walkin-heading {
            margin-bottom: 24px;
        }

        .walkin-heading h1 {
            font-size: 28px;
            font-weight: 750;
            margin: 0 0 8px;
            color: #183b60;
        }

        .walkin-heading p {
            color: #61748e;
            margin: 0;
            line-height: 1.6;
        }

        .walkin-card {
            background: #fff;
            border: 1px solid #dce5f0;
            border-radius: 14px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 4px 18px rgba(23, 51, 80, .04);
        }

        .walkin-card h2 {
            font-size: 19px;
            color: #1c4169;
            margin: 0 0 8px;
        }

        .walkin-description {
            color: #61748e;
            font-size: 13px;
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .walkin-field label {
            display: block;
            font-size: 13px;
            font-weight: 700;
            color: #354c69;
            margin-bottom: 8px;
        }

        .walkin-input {
            display: block;
            width: 100%;
            box-sizing: border-box;
            padding: 12px 14px;
            border: 1px solid #cfdaea;
            border-radius: 9px;
            background: #fff;
            color: #19334f;
            font: inherit;
        }

        .walkin-input:focus {
            outline: none;
            border-color: #397cbd;
            box-shadow: 0 0 0 3px rgba(57, 124, 189, .12);
        }

        .walkin-search-row {
            display: flex;
            align-items: end;
            gap: 12px;
            flex-wrap: wrap;
        }

        .walkin-search-field {
            flex: 1;
            min-width: 220px;
        }

        .walkin-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 22px;
        }

        .walkin-button {
            border: 1px solid #1c4169;
            border-radius: 9px;
            padding: 11px 18px;
            background: #1c4169;
            color: white;
            font-weight: 700;
            cursor: pointer;
        }

        .walkin-button:hover {
            background: #14324f;
        }

        .walkin-secondary {
            background: white;
            color: #1c4169;
            border-color: #bfd0e1;
        }

        .walkin-secondary:hover {
            background: #edf4fa;
        }

        .walkin-message {
            display: block;
            padding: 12px 15px;
            border-radius: 9px;
            margin-bottom: 18px;
            line-height: 1.5;
        }

        .walkin-success {
            color: #17643e;
            background: #e7f5ed;
            border: 1px solid #b9e0c8;
        }

        .walkin-error {
            color: #973b3b;
            background: #fff0f0;
            border: 1px solid #f0caca;
        }

        .walkin-selected {
            margin-top: 16px;
            padding: 14px 16px;
            background: #edf5fc;
            border: 1px solid #cbdff0;
            border-radius: 10px;
            color: #1c4169;
        }

        .walkin-selected strong {
            display: block;
            margin-bottom: 5px;
        }

        .walkin-results {
            margin-top: 16px;
            width: 100%;
            border-collapse: collapse;
        }

        .walkin-results th,
        .walkin-results td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e3eaf3;
            font-size: 13px;
            vertical-align: middle;
        }

        .walkin-results th {
            background: #f2f6fb;
            color: #345675;
        }

        .walkin-results td {
            overflow-wrap: anywhere;
        }

        .walkin-result-button {
            padding: 8px 13px;
            border-radius: 8px;
            border: 1px solid #1c4169;
            background: #1c4169;
            color: #fff;
            cursor: pointer;
            font-weight: 700;
        }

        .walkin-table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        .walkin-preview {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-top: 20px;
        }

        .walkin-preview-item {
            background: #f5f8fc;
            border: 1px solid #e0e9f2;
            border-radius: 10px;
            padding: 17px;
            min-width: 0;
        }

        .walkin-preview-item span {
            display: block;
            color: #647991;
            font-size: 12px;
            margin-bottom: 8px;
        }

        .walkin-preview-item strong {
            display: block;
            color: #1c4169;
            font-size: 15px;
            overflow-wrap: anywhere;
        }

        .walkin-note {
            background: #f1f6fc;
            border: 1px solid #d8e6f4;
            border-radius: 10px;
            padding: 15px 18px;
            color: #4c6580;
            font-size: 13px;
            line-height: 1.7;
            margin-top: 20px;
        }

        .walkin-empty {
            color: #647991;
            font-size: 13px;
            padding: 14px 0;
        }

        @media (max-width: 650px) {
            .walkin-preview {
                grid-template-columns: 1fr;
            }

            .walkin-card {
                padding: 18px;
            }

            .walkin-search-row {
                align-items: stretch;
                flex-direction: column;
            }

            .walkin-search-field {
                width: 100%;
                min-width: 0;
            }
        }
    </style>

    <div class="walkin-page">

        <div class="walkin-heading">
            <h1>Walk-in Borrowing</h1>
            <p>
                Record books borrowed directly at the library.
                The borrowing period begins immediately.
            </p>
        </div>

        <asp:Label
            ID="lblMessage"
            runat="server"
            Visible="false"
            CssClass="walkin-message" />

        <div class="walkin-card">

            <h2>1. Find Customer</h2>

            <p class="walkin-description">
                Search for a registered customer by name or email.
                Select the correct customer from the results.
            </p>

            <asp:Panel
                ID="pnlCustomerSearch"
                runat="server"
                DefaultButton="btnSearchCustomer">

                <div class="walkin-search-row">

                    <div class="walkin-field walkin-search-field">
                        <asp:Label
                            runat="server"
                            AssociatedControlID="txtCustomerSearch"
                            Text="Customer Name or Email" />

                        <asp:TextBox
                            ID="txtCustomerSearch"
                            runat="server"
                            CssClass="walkin-input"
                            MaxLength="100"
                            placeholder="Search customer..." />
                    </div>

                    <asp:Button
                        ID="btnSearchCustomer"
                        runat="server"
                        Text="Search Customer"
                        CssClass="walkin-button"
                        CausesValidation="false"
                        OnClick="btnSearchCustomer_Click" />

                </div>

            </asp:Panel>

            <asp:Panel
                ID="pnlCustomerResults"
                runat="server"
                Visible="false">

                <div class="walkin-table-wrap">

                    <asp:GridView
                        ID="gvCustomers"
                        runat="server"
                        AutoGenerateColumns="false"
                        DataKeyNames="UserID"
                        CssClass="walkin-results"
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
                                        ? "Allowed"
                                        : "Restricted" %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:Button
                                        runat="server"
                                        Text="Select"
                                        CommandName="SelectCustomer"
                                        CommandArgument='<%# Eval("UserID") %>'
                                        CssClass="walkin-result-button"
                                        CausesValidation="false" />
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>

                    </asp:GridView>

                </div>

                <asp:Label
                    ID="lblCustomerEmpty"
                    runat="server"
                    Visible="false"
                    CssClass="walkin-empty"
                    Text="No matching customers found." />

            </asp:Panel>

            <asp:Panel
                ID="pnlSelectedCustomer"
                runat="server"
                Visible="false"
                CssClass="walkin-selected">

                <strong>Selected Customer</strong>

                <asp:Label
                    ID="lblSelectedCustomer"
                    runat="server" />

            </asp:Panel>

        </div>

        <div class="walkin-card">

            <h2>2. Find Book</h2>

            <p class="walkin-description">
                Search by book title, author, or ISBN.
                Only non-archived books are shown.
            </p>

            <asp:Panel
                ID="pnlBookSearch"
                runat="server"
                DefaultButton="btnSearchBook">

                <div class="walkin-search-row">

                    <div class="walkin-field walkin-search-field">

                        <asp:Label
                            runat="server"
                            AssociatedControlID="txtBookSearch"
                            Text="Book Title, Author, or ISBN" />

                        <asp:TextBox
                            ID="txtBookSearch"
                            runat="server"
                            CssClass="walkin-input"
                            MaxLength="255"
                            placeholder="Search book..." />

                    </div>

                    <asp:Button
                        ID="btnSearchBook"
                        runat="server"
                        Text="Search Book"
                        CssClass="walkin-button"
                        CausesValidation="false"
                        OnClick="btnSearchBook_Click" />

                </div>

            </asp:Panel>

            <asp:Panel
                ID="pnlBookResults"
                runat="server"
                Visible="false">

                <div class="walkin-table-wrap">

                    <asp:GridView
                        ID="gvBooks"
                        runat="server"
                        AutoGenerateColumns="false"
                        DataKeyNames="BookID"
                        CssClass="walkin-results"
                        GridLines="None"
                        OnRowCommand="gvBooks_RowCommand">

                        <Columns>

                            <asp:BoundField
                                DataField="Title"
                                HeaderText="Book Title" />

                            <asp:BoundField
                                DataField="Author"
                                HeaderText="Author" />

                            <asp:BoundField
                                DataField="AvailableCopies"
                                HeaderText="Available" />

                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:Button
                                        runat="server"
                                        Text="Select"
                                        CommandName="SelectBook"
                                        CommandArgument='<%# Eval("BookID") %>'
                                        CssClass="walkin-result-button"
                                        CausesValidation="false" />
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>

                    </asp:GridView>

                </div>

                <asp:Label
                    ID="lblBookEmpty"
                    runat="server"
                    Visible="false"
                    CssClass="walkin-empty"
                    Text="No matching books found." />

            </asp:Panel>

            <asp:Panel
                ID="pnlSelectedBook"
                runat="server"
                Visible="false"
                CssClass="walkin-selected">

                <strong>Selected Book</strong>

                <asp:Label
                    ID="lblSelectedBook"
                    runat="server" />

            </asp:Panel>

        </div>

        <div class="walkin-card">

            <h2>3. Verify Borrowing</h2>

            <p class="walkin-description">
                Verify the selected customer and book
                before completing the borrowing transaction.
            </p>

            <div class="walkin-actions">

                <asp:Button
                    ID="btnVerify"
                    runat="server"
                    Text="Verify Customer &amp; Book"
                    CssClass="walkin-button"
                    CausesValidation="false"
                    OnClick="btnVerify_Click" />

                <asp:Button
                    ID="btnClear"
                    runat="server"
                    Text="Clear"
                    CssClass="walkin-button walkin-secondary"
                    CausesValidation="false"
                    OnClick="btnClear_Click" />

            </div>

        </div>

        <asp:Panel
            ID="pnlPreview"
            runat="server"
            Visible="false"
            CssClass="walkin-card">

            <h2>Confirm Borrowing</h2>

            <p class="walkin-description">
                Review the details before handing
                the book to the customer.
            </p>

            <div class="walkin-preview">

                <div class="walkin-preview-item">
                    <span>Customer</span>
                    <strong>
                        <asp:Label
                            ID="lblCustomer"
                            runat="server" />
                    </strong>
                </div>

                <div class="walkin-preview-item">
                    <span>Book</span>
                    <strong>
                        <asp:Label
                            ID="lblBook"
                            runat="server" />
                    </strong>
                </div>

                <div class="walkin-preview-item">
                    <span>Available Copies</span>
                    <strong>
                        <asp:Label
                            ID="lblAvailable"
                            runat="server" />
                    </strong>
                </div>

                <div class="walkin-preview-item">
                    <span>Borrowing Period</span>
                    <strong>7 Days</strong>
                </div>

            </div>

            <div class="walkin-note">
                Confirming will immediately deduct one
                available copy, mark the book as collected,
                and create a 7-day loan.
            </div>

            <div class="walkin-actions">

                <asp:Button
                    ID="btnConfirm"
                    runat="server"
                    Text="Confirm Walk-in Borrowing"
                    CssClass="walkin-button"
                    CausesValidation="false"
                    OnClick="btnConfirm_Click"
                    OnClientClick="return confirm('Confirm this walk-in borrowing and hand over the book?');" />

            </div>

        </asp:Panel>

    </div>

</asp:Content>
