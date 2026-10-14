
<%@ Page Title="Borrowing History"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="BorrowHistory.aspx.cs"
    Inherits="ELibrary.Admin.Borrowing.BorrowHistory" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

    <style>
        .el-admin-borrowing {
            color: #172b43;
        }

        .el-admin-borrowing .br-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 22px;
        }

        .el-admin-borrowing .br-eyebrow {
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .12em;
            color: #2f6ba0;
        }

        .el-admin-borrowing h1 {
            font-size: 29px;
            margin: 7px 0;
        }

        .el-admin-borrowing .br-muted {
            color: #718096;
            font-size: 13px;
        }

        .el-admin-borrowing .br-links,
        .el-admin-borrowing .br-filter-actions,
        .el-admin-borrowing .br-pager {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 9px;
        }

        .el-admin-borrowing .br-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 40px;
            padding: 9px 15px;
            border: 1px solid #dce5ee;
            border-radius: 8px;
            background: white;
            color: #172b43;
            text-decoration: none;
            font-size: 13px;
            font-weight: 650;
            cursor: pointer;
        }

        .el-admin-borrowing .br-btn-primary {
            background: #2f6ba0;
            border-color: #2f6ba0;
            color: white;
        }

        .el-admin-borrowing .br-btn:disabled {
            opacity: .45;
            cursor: default;
        }

        .el-admin-borrowing .br-panel {
            background: white;
            border: 1px solid #e4ebf3;
            border-radius: 13px;
            padding: 20px;
            margin-bottom: 18px;
            box-shadow: 0 3px 14px rgba(23,43,67,.04);
        }

        .el-admin-borrowing .br-filters {
            display: grid;
            grid-template-columns:
                minmax(190px,2fr)
                repeat(4,minmax(130px,1fr));
            gap: 12px;
            padding: 16px;
            margin: 18px 0;
            background: #f8fafc;
            border: 1px solid #e4ebf3;
            border-radius: 10px;
        }

        .el-admin-borrowing .br-field label {
            display: block;
            margin-bottom: 7px;
            font-size: 12px;
            font-weight: 700;
            color: #43566b;
        }

        .el-admin-borrowing .br-field input,
        .el-admin-borrowing .br-field select {
            width: 100%;
            min-height: 40px;
            padding: 9px 11px;
            border: 1px solid #dce5ee;
            border-radius: 8px;
            background: white;
            color: #172b43;
            font-size: 13px;
            box-sizing: border-box;
        }

        .el-admin-borrowing .br-filter-actions {
            grid-column: 1 / -1;
        }

        .el-admin-borrowing .br-table-scroll {
            width: 100%;
            overflow-x: auto;
        }

        .el-admin-borrowing .br-table {
            width: 100%;
            min-width: 1550px;
            border-collapse: collapse;
            font-size: 13px;
        }

        .el-admin-borrowing .br-table th {
            background: #f4f7fb;
            color: #52647a;
            text-align: left;
            white-space: nowrap;
            padding: 13px 12px;
            border-bottom: 1px solid #e4ebf3;
        }

        .el-admin-borrowing .br-table td {
            padding: 13px 12px;
            border-bottom: 1px solid #edf1f5;
            vertical-align: middle;
        }

        .el-admin-borrowing .br-pill {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 999px;
            background: #e8eef7;
            color: #365678;
            font-size: 11px;
            font-weight: 750;
        }

        .el-admin-borrowing .br-pill.success {
            background: #e6f7ec;
            color: #237c4e;
        }

        .el-admin-borrowing .br-pill.danger {
            background: #ffe6e6;
            color: #a82e2e;
        }

        .el-admin-borrowing .br-pill.cancelled {
            background: #f0f2f5;
            color: #657386;
        }

        .el-admin-borrowing .br-pager {
            justify-content: center;
            margin-top: 20px;
        }

        .el-admin-borrowing .br-message {
            display: block;
            margin: 12px 0;
            color: #bd4141;
        }

        .el-admin-borrowing .br-loss-reason {
            max-width: 260px;
            min-width: 170px;
            white-space: normal;
            overflow-wrap: anywhere;
        }

        .el-admin-borrowing .br-fee {
            font-weight: 700;
            color: #a83b3b;
            white-space: nowrap;
        }

        .el-admin-borrowing .br-loss-note {
            color: #718096;
            font-size: 12px;
            margin: 12px 0 0;
        }

        @media(max-width:1050px) {
            .el-admin-borrowing .br-filters {
                grid-template-columns: repeat(2,minmax(0,1fr));
            }
        }

        @media(max-width:600px) {
            .el-admin-borrowing .br-filters {
                grid-template-columns: 1fr;
            }

            .el-admin-borrowing .br-panel {
                padding: 14px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="el-admin-borrowing">

        <div class="br-header">
            <div>
                <span class="br-eyebrow">
                    ADMINISTRATION / BORROWING
                </span>

                <h1>Borrowing History</h1>

                <p class="br-muted">
                    Review returned books, lost books,
                    and cancelled reservations.
                </p>
            </div>

            <div class="br-links">

                <asp:Button
                    ID="btnRefresh"
                    runat="server"
                    Text="Refresh"
                    CssClass="br-btn br-btn-primary"
                    CausesValidation="false"
                    OnClick="btnRefresh_Click" />

                <asp:HyperLink
                    runat="server"
                    NavigateUrl="~/Admin/Borrowing/ManageBorrows.aspx"
                    CssClass="br-btn"
                    Text="Manage Borrowings" />

                <asp:HyperLink
                    runat="server"
                    NavigateUrl="~/Admin/Borrowing/OverdueBooks.aspx"
                    CssClass="br-btn"
                    Text="Overdue Books" />
            </div>
        </div>

        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="br-message" />

        <section class="br-panel">

            <h2>Borrowing Records</h2>

            <p class="br-muted">
                Search and filter historical borrowing activity,
                including customer-lost books.
            </p>

            <asp:Panel
                ID="pnlFilters"
                runat="server"
                DefaultButton="btnApply"
                CssClass="br-filters">

                <div class="br-field">
                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtSearch"
                        Text="Search History" />

                    <asp:TextBox
                        ID="txtSearch"
                        runat="server"
                        MaxLength="255"
                        placeholder="ID, customer, email, book..."
                        autocomplete="off" />
                </div>

                <div class="br-field">
                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlStatus"
                        Text="Status" />

                    <asp:DropDownList
                        ID="ddlStatus"
                        runat="server">

                        <asp:ListItem
                            Text="All Statuses"
                            Value="All" />

                        <asp:ListItem
                            Text="Returned"
                            Value="Returned" />

                        <asp:ListItem
                            Text="Lost"
                            Value="Lost" />

                        <asp:ListItem
                            Text="Cancelled"
                            Value="Cancelled" />

                    </asp:DropDownList>
                </div>

                <div class="br-field">
                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlSort"
                        Text="Sort By" />

                    <asp:DropDownList
                        ID="ddlSort"
                        runat="server">

                        <asp:ListItem
                            Text="Default Order"
                            Value="Default" />

                        <asp:ListItem
                            Text="Recently Reserved"
                            Value="BorrowDesc" />

                        <asp:ListItem
                            Text="Oldest Reserved"
                            Value="BorrowAsc" />

                        <asp:ListItem
                            Text="Highest ID First"
                            Value="IDDesc" />

                        <asp:ListItem
                            Text="Lowest ID First"
                            Value="IDAsc" />

                    </asp:DropDownList>
                </div>

                <div class="br-field">
                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtDateFrom"
                        Text="Reserved From" />

                    <asp:TextBox
                        ID="txtDateFrom"
                        runat="server"
                        TextMode="Date" />
                </div>

                <div class="br-field">
                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtDateTo"
                        Text="Reserved To" />

                    <asp:TextBox
                        ID="txtDateTo"
                        runat="server"
                        TextMode="Date" />
                </div>

                <div class="br-filter-actions">

                    <asp:Button
                        ID="btnApply"
                        runat="server"
                        Text="Apply"
                        CssClass="br-btn br-btn-primary"
                        CausesValidation="false"
                        OnClick="btnApply_Click" />

                    <asp:Button
                        ID="btnClearFilters"
                        runat="server"
                        Text="Clear Filters"
                        CssClass="br-btn"
                        CausesValidation="false"
                        OnClick="btnClearFilters_Click" />

                    <span class="br-muted">
                        Press Enter or Apply to search.
                    </span>
                </div>

            </asp:Panel>

            <asp:Label
                ID="lblResultCount"
                runat="server"
                CssClass="br-muted"
                Text="Showing borrowing history" />

            <div class="br-table-scroll">

                <asp:GridView
                    ID="gvHistory"
                    runat="server"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    CssClass="br-table"
                    EmptyDataText="No history records match your filters.">

                    <Columns>

                        <asp:BoundField
                            DataField="BorrowLogID"
                            HeaderText="Borrow ID" />

                        <asp:BoundField
                            DataField="FullName"
                            HeaderText="Customer" />

                        <asp:BoundField
                            DataField="Email"
                            HeaderText="Email" />

                        <asp:BoundField
                            DataField="Title"
                            HeaderText="Book" />

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

                        <asp:TemplateField HeaderText="Cancellation Reason">
                            <ItemTemplate>
                                <%# Convert.ToString(Eval("DisplayStatus")) == "Cancelled"
                                    ? Server.HtmlEncode(
                                        Convert.ToString(Eval("CancellationReason")))
                                    : "—" %>
                            </ItemTemplate>
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Lost Date">
                            <ItemTemplate>
                                <%# Convert.ToString(Eval("DisplayStatus")) == "Lost"
                                    ? Server.HtmlEncode(
                                        FormatHistoryDate(Eval("LostDate")))
                                    : "—" %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Loss Reason">
                            <ItemTemplate>
                                <div class="br-loss-reason">
                                    <%# Convert.ToString(Eval("DisplayStatus")) == "Lost"
                                        ? Server.HtmlEncode(
                                            Convert.ToString(Eval("LostReason")))
                                        : "—" %>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Replacement Fee (PHP)">
                            <ItemTemplate>
                                <span class="br-fee">
                                    <%# Convert.ToString(Eval("DisplayStatus")) == "Lost"
                                        && Eval("ReplacementFeeAmount") != DBNull.Value
                                        ? Server.HtmlEncode(
                                            Convert.ToDecimal(
                                                Eval("ReplacementFeeAmount"))
                                                .ToString("N2"))
                                        : "—" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Marked Lost By">
                            <ItemTemplate>
                                <%# Convert.ToString(Eval("DisplayStatus")) == "Lost"
                                    ? Server.HtmlEncode(
                                        string.IsNullOrWhiteSpace(
                                            Convert.ToString(Eval("MarkedLostByName")))
                                            ? "Unknown librarian"
                                            : Convert.ToString(
                                                Eval("MarkedLostByName")))
                                    : "—" %>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

            <p class="br-loss-note">
                Replacement Fee shows the amount charged for
                a lost book. It does not indicate whether the
                customer has paid. Payment tracking will be
                handled in the Transactions module.
            </p>

            <div class="br-pager">

                <asp:Button
                    ID="btnPrevious"
                    runat="server"
                    Text="← Previous"
                    CssClass="br-btn"
                    CausesValidation="false"
                    OnClick="btnPrevious_Click" />

                <asp:Label
                    ID="lblPageInfo"
                    runat="server"
                    Text="Page 1 of 1"
                    CssClass="br-muted" />

                <asp:Button
                    ID="btnNext"
                    runat="server"
                    Text="Next →"
                    CssClass="br-btn"
                    CausesValidation="false"
                    OnClick="btnNext_Click" />

            </div>

        </section>
    </div>

</asp:Content>
