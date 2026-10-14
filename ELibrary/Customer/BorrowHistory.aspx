
<%@ Page Title="Borrowing History"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="BorrowHistory.aspx.cs"
    Inherits="ELibrary.Customer.BorrowHistory" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <style>
        .el-history-page {
            max-width: 1450px;
            margin: 0 auto;
            padding: 24px 28px 45px;
            color: #172d49;
        }

        .el-history-page * {
            box-sizing: border-box;
        }

        .el-history-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            margin-bottom: 24px;
        }

        .el-history-header h1 {
            margin: 7px 0;
            font-size: 28px;
        }

        .el-history-muted {
            color: #61748e;
            font-size: 13px;
        }

        .el-history-summary {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 15px;
            margin: 24px 0;
        }

        .el-history-stat,
        .el-history-panel {
            background: #fff;
            border: 1px solid #e0e8f1;
            border-radius: 14px;
            padding: 22px;
            box-shadow: 0 4px 18px rgba(20,45,75,.04);
        }

        .el-history-stat span {
            display: block;
            font-size: 13px;
            color: #61748e;
            margin-bottom: 8px;
        }

        .el-history-stat strong {
            font-size: 27px;
            color: #1c4169;
        }

        .el-history-panel h2 {
            margin: 0 0 6px;
            font-size: 20px;
        }

        .el-history-filters {
            display: grid;
            grid-template-columns: minmax(200px,2fr) repeat(2,minmax(150px,1fr));
            gap: 12px;
            padding: 18px;
            margin: 20px 0;
            background: #f5f8fc;
            border: 1px solid #dce5f0;
            border-radius: 11px;
        }

        .el-history-field label {
            display: block;
            margin-bottom: 7px;
            font-size: 12px;
            font-weight: 700;
            color: #354c69;
        }

        .el-history-input {
            width: 100%;
            min-height: 42px;
            padding: 9px 12px;
            border: 1px solid #d4e0ed;
            border-radius: 8px;
            background: white;
            color: #172d49;
            font: inherit;
        }

        .el-history-actions {
            grid-column: 1 / -1;
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .el-history-btn {
            min-height: 40px;
            padding: 9px 16px;
            border-radius: 8px;
            border: 1px solid #1c4169;
            background: #1c4169;
            color: #fff;
            font-weight: 650;
            cursor: pointer;
        }

        .el-history-btn.secondary {
            background: #fff;
            color: #1c4169;
            border-color: #bed0e2;
        }

        .el-history-btn:disabled {
            opacity: .45;
            cursor: default;
        }

        .el-history-table-wrap {
            width: 100%;
            overflow-x: auto;
            border: 1px solid #e3eaf2;
            border-radius: 10px;
        }

        .el-history-table {
            width: 100%;
            min-width: 1050px;
            border-collapse: collapse;
            font-size: 13px;
        }

        .el-history-table th {
            background: #f3f7fb;
            color: #354c69;
            text-align: left;
            padding: 14px 12px;
            white-space: nowrap;
            border-bottom: 1px solid #dfe8f2;
        }

        .el-history-table td {
            padding: 15px 12px;
            vertical-align: middle;
            border-bottom: 1px solid #edf1f6;
        }

        .el-history-book {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .el-history-book small {
            color: #61748e;
        }

        .el-history-pill {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            background: #e8eef7;
            color: #365678;
        }

        .el-history-pill.returned {
            background: #e6f7ec;
            color: #237c4e;
        }

        .el-history-pill.cancelled {
            background: #f0f2f5;
            color: #657386;
        }

        .el-history-pill.lost {
            background: #ffe6e6;
            color: #a82e2e;
        }

        .el-history-pager {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 12px;
            margin-top: 20px;
        }

        .el-history-message {
            display: block;
            color: #b42318;
            margin: 12px 0;
        }

        @media(max-width: 750px) {
            .el-history-page {
                padding: 15px 12px 30px;
            }

            .el-history-summary {
                grid-template-columns: 1fr;
            }

            .el-history-filters {
                grid-template-columns: 1fr;
            }

            .el-history-panel {
                padding: 15px;
            }
        }
    </style>

    <div class="el-history-page">

        <div class="el-history-header">
            <div>
                <span class="el-section-eyebrow">
                    MY LIBRARY
                </span>
                <h1>Borrowing History</h1>
                <p class="el-history-muted">
                    Review completed borrowings and cancelled reservations.
                </p>
            </div>

            <asp:Button
                ID="btnCurrentBorrows"
                runat="server"
                Text="← Current Borrowings"
                CssClass="el-history-btn secondary"
                CausesValidation="false"
                OnClick="btnCurrentBorrows_Click" />
        </div>

        <div class="el-history-summary">

            <div class="el-history-stat">
                <span>History Records</span>
                <strong>
                    <asp:Label ID="lblHistoryCount"
                        runat="server" Text="0" />
                </strong>
            </div>

            <div class="el-history-stat">
                <span>Returned Records</span>
                <strong>
                    <asp:Label ID="lblReturnedCount"
                        runat="server" Text="0" />
                </strong>
            </div>

            <div class="el-history-stat">
                <span>Cancelled Reservations</span>
                <strong>
                    <asp:Label ID="lblCancelledCount"
                        runat="server" Text="0" />
                </strong>
            </div>

        </div>

        <asp:Label ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="el-history-message" />

        <section class="el-history-panel">

            <h2>Your Borrowing Records</h2>
            <p class="el-history-muted">
                Search by book, author, or borrowing ID.
            </p>

            <asp:Panel ID="pnlFilters"
                runat="server"
                DefaultButton="btnApply"
                CssClass="el-history-filters">

                <div class="el-history-field">
                    <asp:Label runat="server"
                        AssociatedControlID="txtSearch"
                        Text="Search History" />

                    <asp:TextBox ID="txtSearch"
                        runat="server"
                        CssClass="el-history-input"
                        MaxLength="255"
                        placeholder="Title, author, or Borrow ID" />
                </div>

                <div class="el-history-field">
                    <asp:Label runat="server"
                        AssociatedControlID="ddlStatus"
                        Text="Status" />

                    <asp:DropDownList ID="ddlStatus"
                        runat="server"
                        CssClass="el-history-input">
                        <asp:ListItem Text="All Statuses" Value="All" />
                        <asp:ListItem Text="Returned" Value="Returned" />
                        <asp:ListItem Text="Lost" Value="Lost" />
                        <asp:ListItem Text="Cancelled" Value="Cancelled" />
                    </asp:DropDownList>
                </div>

                <div class="el-history-field">
                    <asp:Label runat="server"
                        AssociatedControlID="ddlSort"
                        Text="Sort By" />

                    <asp:DropDownList ID="ddlSort"
                        runat="server"
                        CssClass="el-history-input">
                        <asp:ListItem Text="Newest Reserved" Value="Newest" />
                        <asp:ListItem Text="Oldest Reserved" Value="Oldest" />
                        <asp:ListItem Text="Recently Returned" Value="RecentlyReturned" />
                        <asp:ListItem Text="Book Title (A-Z)" Value="Title" />
                    </asp:DropDownList>
                </div>

                <div class="el-history-actions">
                    <asp:Button ID="btnApply"
                        runat="server"
                        Text="Apply Filters"
                        CssClass="el-history-btn"
                        CausesValidation="false"
                        OnClick="btnApply_Click" />

                    <asp:Button ID="btnClear"
                        runat="server"
                        Text="Clear Filters"
                        CssClass="el-history-btn secondary"
                        CausesValidation="false"
                        OnClick="btnClear_Click" />

                    <span class="el-history-muted">
                        Press Enter or Apply to search.
                    </span>
                </div>

            </asp:Panel>

            <p class="el-history-muted">
                <asp:Label ID="lblResults"
                    runat="server"
                    Text="Showing borrowing history" />
            </p>

            <div class="el-history-table-wrap">

                <asp:GridView ID="gvHistory"
                    runat="server"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    CssClass="el-history-table"
                    EmptyDataText="No history matches your filters.">

                    <Columns>

                        <asp:TemplateField HeaderText="Borrow ID">
                            <ItemTemplate>
                                #<%#: Eval("BorrowLogID") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Book">
                            <ItemTemplate>
                                <div class="el-history-book">
                                    <strong><%#: Eval("Title") %></strong>
                                    <small><%#: Eval("Author") %></small>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Reserved">
                            <ItemTemplate>
                                <%#: FormatHistoryDate(Eval("DateBorrowed")) %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Collected">
                            <ItemTemplate>
                                <%#: FormatHistoryDate(Eval("DateCollected")) %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Due Date">
                            <ItemTemplate>
                                <%#: FormatHistoryDate(Eval("DueDate")) %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Returned">
                            <ItemTemplate>
                                <%#: FormatHistoryDate(Eval("DateReturned")) %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Cancelled">
                            <ItemTemplate>
                                <%#: FormatHistoryDate(Eval("DateCancelled")) %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# GetStatusClass(Eval("DisplayStatus")) %>'>
                                    <%#: Eval("DisplayStatus") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>

            </div>

            <div class="el-history-pager">

                <asp:Button ID="btnPrevious"
                    runat="server"
                    Text="← Previous"
                    CssClass="el-history-btn secondary"
                    CausesValidation="false"
                    OnClick="btnPrevious_Click" />

                <asp:Label ID="lblPageInfo"
                    runat="server"
                    Text="Page 1 of 1"
                    CssClass="el-history-muted" />

                <asp:Button ID="btnNext"
                    runat="server"
                    Text="Next →"
                    CssClass="el-history-btn secondary"
                    CausesValidation="false"
                    OnClick="btnNext_Click" />

            </div>

        </section>

        <p>
            <a href="<%= ResolveUrl("~/Customer/Books.aspx") %>">
                ← Explore More Books
            </a>
        </p>

    </div>
</asp:Content>
