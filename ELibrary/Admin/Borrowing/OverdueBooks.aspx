<%@ Page Title="Overdue Books"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="OverdueBooks.aspx.cs"
    Inherits="ELibrary.Admin.Borrowing.OverdueBooks" %>

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
            font-weight: 750;
            margin: 7px 0;
        }

        .el-admin-borrowing .br-header p,
        .el-admin-borrowing .br-panel-head p {
            color: #718096;
            margin: 5px 0 0;
        }

        .el-admin-borrowing .br-links {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .el-admin-borrowing .br-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 40px;
            padding: 9px 15px;
            border: 1px solid #dce5ee;
            border-radius: 8px;
            background: #fff;
            color: #172b43;
            text-decoration: none;
            font-size: 13px;
            font-weight: 650;
            cursor: pointer;
        }

        .el-admin-borrowing .br-btn:hover {
            background: #f1f6fb;
            text-decoration: none;
        }

        .el-admin-borrowing .br-btn-primary {
            background: #2f6ba0;
            color: #fff;
            border-color: #2f6ba0;
        }

        .el-admin-borrowing .br-btn-primary:hover {
            background: #235680;
            color: #fff;
        }

        .el-admin-borrowing .br-btn:disabled {
            opacity: .45;
            cursor: default;
        }

        .el-admin-borrowing .br-panel {
            background: #fff;
            border: 1px solid #e4ebf3;
            border-radius: 13px;
            padding: 20px;
            margin-bottom: 18px;
            box-shadow: 0 3px 14px rgba(23,43,67,.04);
        }

        .el-admin-borrowing .br-panel-head {
            margin-bottom: 17px;
        }

        .el-admin-borrowing .br-panel-head h2 {
            font-size: 19px;
            font-weight: 750;
            margin: 0;
        }

        .el-admin-borrowing .br-filters {
            display: grid;
            grid-template-columns:
                minmax(200px,2fr)
                minmax(150px,1fr)
                minmax(150px,1fr)
                auto;
            gap: 12px;
            align-items: end;
            background: #f8fafc;
            border: 1px solid #e4ebf3;
            border-radius: 10px;
            padding: 16px;
        }

        .el-admin-borrowing .br-field {
            min-width: 0;
        }

        .el-admin-borrowing .br-field label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            color: #43566b;
            margin-bottom: 7px;
        }

        .el-admin-borrowing .br-field input,
        .el-admin-borrowing .br-field select {
            display: block;
            width: 100%;
            min-height: 40px;
            padding: 9px 11px;
            border: 1px solid #dce5ee;
            border-radius: 8px;
            background: #fff;
            color: #172b43;
            font-size: 13px;
        }

        .el-admin-borrowing .br-field input:focus,
        .el-admin-borrowing .br-field select:focus {
            outline: none;
            border-color: #2f6ba0;
            box-shadow: 0 0 0 3px rgba(47,107,160,.12);
        }

        .el-admin-borrowing .br-filter-actions {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .el-admin-borrowing .br-filter-actions .br-btn {
            white-space: nowrap;
        }

        .el-admin-borrowing .br-count {
            display: block;
            font-size: 12px;
            color: #718096;
            margin: 12px 0;
        }

        .el-admin-borrowing .br-table-scroll {
            width: 100%;
            overflow-x: auto;
        }

        .el-admin-borrowing .br-table {
            width: 100%;
            min-width: 950px;
            border-collapse: collapse;
            font-size: 13px;
        }

        .el-admin-borrowing .br-table th {
            background: #f4f7fb;
            color: #52647a;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: .04em;
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

        .el-admin-borrowing .br-table tr:hover td {
            background: #f9fbfe;
        }

        .el-admin-borrowing .br-pill {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 750;
            background: #ffe6e6;
            color: #a82e2e;
            white-space: nowrap;
        }

        .el-admin-borrowing .br-message {
            display: block;
            margin-bottom: 15px;
            color: #bd4141;
        }

        .el-admin-borrowing .br-message:empty {
            display: none;
        }

        .el-admin-borrowing .br-note {
            padding: 13px 15px;
            border-radius: 9px;
            background: #f1f6fb;
            color: #43566b;
            font-size: 13px;
        }

        .el-admin-borrowing .br-pager {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 12px;
            padding: 18px 0 4px;
        }

        .el-admin-borrowing .br-page-info {
            color: #61748e;
            font-size: 13px;
        }

        @media(max-width:1050px) {
            .el-admin-borrowing .br-filters {
                grid-template-columns: repeat(2,minmax(0,1fr));
            }
            .el-admin-borrowing .br-search {
                grid-column: 1/-1;
            }
        }

        @media(max-width:600px) {
            .el-admin-borrowing h1 {
                font-size: 24px;
            }
            .el-admin-borrowing .br-panel {
                padding: 14px;
            }
            .el-admin-borrowing .br-filters {
                grid-template-columns: 1fr;
                padding: 12px;
            }
            .el-admin-borrowing .br-search {
                grid-column: auto;
            }
            .el-admin-borrowing .br-links {
                width: 100%;
            }
            .el-admin-borrowing .br-links .br-btn {
                width: 100%;
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

                <h1>Overdue Books</h1>

                <p>
                    Track overdue loans and estimated late fees.
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
                    ID="lnkManage"
                    runat="server"
                    NavigateUrl="~/Admin/Borrowing/ManageBorrows.aspx"
                    CssClass="br-btn"
                    Text="Manage Borrowings" />

                <asp:HyperLink
                    ID="lnkHistory"
                    runat="server"
                    NavigateUrl="~/Admin/Borrowing/BorrowHistory.aspx"
                    CssClass="br-btn"
                    Text="Borrowing History" />

            </div>
        </div>

        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="br-message" />

        <section class="br-panel">

            <div class="br-panel-head">
                <h2>Overdue Records</h2>
                <p>
                    Identify books that have passed their due date.
                </p>
            </div>

            <!-- SEARCH AND FILTER -->
            <asp:Panel
                ID="pnlFilters"
                runat="server"
                DefaultButton="btnApply"
                CssClass="br-filters">

                <div class="br-field br-search">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtSearch"
                        Text="Search Overdue Books" />

                    <asp:TextBox
                        ID="txtSearch"
                        runat="server"
                        MaxLength="255"
                        placeholder="Search ID, customer, email, book..."
                        autocomplete="off" />

                </div>

                <div class="br-field">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlDuration"
                        Text="Days Overdue" />

                    <asp:DropDownList
                        ID="ddlDuration"
                        runat="server">

                        <asp:ListItem
                            Text="All Durations"
                            Value="All" />

                        <asp:ListItem
                            Text="1–7 Days"
                            Value="1-7" />

                        <asp:ListItem
                            Text="8–14 Days"
                            Value="8-14" />

                        <asp:ListItem
                            Text="15–30 Days"
                            Value="15-30" />

                        <asp:ListItem
                            Text="31+ Days"
                            Value="31+" />

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
                            Text="Most Overdue First"
                            Value="DaysDesc" />

                        <asp:ListItem
                            Text="Least Overdue First"
                            Value="DaysAsc" />

                        <asp:ListItem
                            Text="Due Date (Earliest)"
                            Value="DueAsc" />

                        <asp:ListItem
                            Text="Due Date (Latest)"
                            Value="DueDesc" />

                        <asp:ListItem
                            Text="Highest ID First"
                            Value="IDDesc" />

                    </asp:DropDownList>

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

                </div>

            </asp:Panel>

            <p class="br-count">
                Press Enter or click Apply to search and filter.
            </p>

            <asp:Label
                ID="lblResultCount"
                runat="server"
                CssClass="br-count"
                Text="Showing overdue records" />

            <!-- TABLE -->
            <div class="br-table-scroll">

                <asp:GridView
                    ID="gvOverdue"
                    runat="server"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    CssClass="br-table"
                    EmptyDataText="No overdue records match your filters.">

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

                        <asp:BoundField
                            DataField="Author"
                            HeaderText="Author" />

                        <asp:BoundField
                            DataField="DateBorrowed"
                            HeaderText="Date Borrowed"
                            DataFormatString="{0:MM/dd/yyyy}" />

                        <asp:BoundField
                            DataField="DueDate"
                            HeaderText="Due Date"
                            DataFormatString="{0:MM/dd/yyyy}" />

                        <asp:BoundField
                            DataField="DaysOverdue"
                            HeaderText="Days Overdue" />

                        <asp:BoundField
                            DataField="EstimatedLateFee"
                            HeaderText="Estimated Late Fee"
                            DataFormatString="₱{0:N2}" />

                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class="br-pill">
                                    <%#: Eval("Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

            <!-- PAGINATION -->
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
                    CssClass="br-page-info"
                    Text="Page 1 of 1" />

                <asp:Button
                    ID="btnNext"
                    runat="server"
                    Text="Next →"
                    CssClass="br-btn"
                    CausesValidation="false"
                    OnClick="btnNext_Click" />

            </div>

        </section>

        <div class="br-note">
            Estimated late fee:
            <strong>₱10.00 per overdue day.</strong>
            Actual charges are determined by the borrowing system.
        </div>

    </div>

</asp:Content>