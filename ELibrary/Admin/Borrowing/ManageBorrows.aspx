
<%@ Page Title="Manage Borrowings"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ManageBorrows.aspx.cs"
    Inherits="ELibrary.Admin.Borrowing.ManageBorrows" %>

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
                repeat(2,minmax(150px,1fr))
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

        .el-admin-borrowing .br-count {
            font-size: 12px;
            color: #718096;
            margin: 12px 0;
        }

        .el-admin-borrowing .br-table-scroll {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        .el-admin-borrowing .br-table {
            width: 100%;
            min-width: 1120px;
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
            background: #e8eef7;
            color: #365678;
            white-space: nowrap;
        }

        .el-admin-borrowing .br-pill.warning {
            background: #fff1ce;
            color: #8a6100;
        }

        .el-admin-borrowing .br-pill.danger {
            background: #ffe6e6;
            color: #a82e2e;
        }

        .el-admin-borrowing .br-pill.success {
            background: #e6f7ec;
            color: #237c4e;
        }

        .el-admin-borrowing .br-message {
            display: block;
            margin-bottom: 15px;
        }

        .el-admin-borrowing .br-message:empty {
            display: none;
        }

        .el-admin-borrowing .br-message.text-danger {
            color: #bd4141;
        }

        .el-admin-borrowing .br-message.text-success {
            color: #237c4e;
        }

        .el-admin-borrowing .br-action {
            display: inline-block;
            border-radius: 7px;
            padding: 8px 10px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
            border: 1px solid transparent;
            margin: 3px 4px 3px 0;
        }

        .el-admin-borrowing .br-collect {
            background: #e8f1fa;
            color: #245e91;
            border-color: #cbdff0;
        }

        .el-admin-borrowing .br-return {
            background: #e6f7ec;
            color: #237c4e;
            border-color: #ccebd9;
        }

        .el-admin-borrowing .br-cancel {
            background: #fff0f0;
            color: #a83b3b;
            border-color: #f3d2d2;
        }

        .el-admin-borrowing .br-reason {
            display: block;
            width: 190px;
            max-width: 100%;
            padding: 8px 10px;
            margin: 5px 0;
            border: 1px solid #dce5ee;
            border-radius: 7px;
            font-size: 12px;
        }

        .el-admin-borrowing .br-muted {
            color: #8391a3;
            font-size: 12px;
        }

        .el-admin-borrowing .br-filter-actions {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .el-admin-borrowing .br-pager {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            padding: 18px 0 2px;
        }

        .el-admin-borrowing .br-pager .br-btn:disabled {
            opacity: .45;
            cursor: default;
        }

        @media (max-width: 900px) {
            .el-admin-borrowing .br-filters {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 600px) {
            .el-admin-borrowing .br-filters {
                grid-template-columns: 1fr;
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

                <h1>Manage Borrowings</h1>

                <p>
                    Manage pending pickups, active loans,
                    cancellations, and book returns.
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
                    ID="lnkOverdue"
                    runat="server"
                    NavigateUrl="~/Admin/Borrowing/OverdueBooks.aspx"
                    CssClass="br-btn"
                    Text="Overdue Books" />

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
            CssClass="br-message text-danger" />

        <section class="br-panel">

            <div class="br-panel-head">
                <h2>Reservations and Borrowings</h2>
                <p>
                    Confirm book collection, cancel pending
                    reservations, or process physical returns.
                </p>
            </div>

            <asp:Panel
                ID="pnlFilters"
                runat="server"
                DefaultButton="btnApply"
                CssClass="br-filters">

                <div class="br-field">
                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtSearch"
                        Text="Search Borrowings" />

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
                        Text="Borrow Status" />

                    <asp:DropDownList
                        ID="ddlStatus"
                        runat="server">

                        <asp:ListItem
                            Text="All Records"
                            Value="All" />

                        <asp:ListItem
                            Text="Pending Pickup"
                            Value="PendingPickup" />

                        <asp:ListItem
                            Text="Active Loans"
                            Value="Active" />

                        <asp:ListItem
                            Text="Borrowed"
                            Value="Borrowed" />

                        <asp:ListItem
                            Text="Overdue"
                            Value="Overdue" />

                        <asp:ListItem
                            Text="Return Requested"
                            Value="ReturnRequested" />

                        <asp:ListItem
                            Text="No Return Request"
                            Value="NoReturnRequest" />

                        <asp:ListItem
                            Text="Returned"
                            Value="Returned" />

                        <asp:ListItem
                            Text="Cancelled"
                            Value="Cancelled" />

                        <asp:ListItem
                            Text="Closed Records"
                            Value="Closed" />

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
                            Text="Highest ID First"
                            Value="IDDesc" />

                        <asp:ListItem
                            Text="Lowest ID First"
                            Value="IDAsc" />

                        <asp:ListItem
                            Text="Due Date (Earliest)"
                            Value="DueAsc" />

                        <asp:ListItem
                            Text="Due Date (Latest)"
                            Value="DueDesc" />

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
                Pending pickups appear first by default.
            </p>

            <asp:Label
                ID="lblResultCount"
                runat="server"
                CssClass="br-count" />

            <div class="br-table-scroll">

                <asp:GridView
                    ID="gvBorrows"
                    runat="server"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    CssClass="br-table"
                    EmptyDataText="No matching borrowing records found."
                    OnRowCommand="gvBorrows_RowCommand">

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
                            HeaderText="Reserved / Borrowed"
                            DataFormatString="{0:MM/dd/yyyy}" />

                        <asp:TemplateField
                            HeaderText="Due Date">

                            <ItemTemplate>
                                <%# Eval("DueDate") == DBNull.Value
                                    ? "Not assigned"
                                    : Convert.ToDateTime(
                                        Eval("DueDate"))
                                        .ToString("MM/dd/yyyy") %>
                            </ItemTemplate>

                        </asp:TemplateField>

                        <asp:TemplateField
                            HeaderText="Collection">

                            <ItemTemplate>

                                <span class='<%#
                                    Convert.ToString(
                                        Eval("CollectionStatus")) == "Pending"
                                    ? "br-pill warning"
                                    : Convert.ToString(
                                        Eval("CollectionStatus")) == "Cancelled"
                                    ? "br-pill danger"
                                    : "br-pill success" %>'>

                                    <%#: Eval("CollectionStatus") %>

                                </span>

                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField
                            HeaderText="Loan Status">

                            <ItemTemplate>

                                <span class='<%#
                                    Convert.ToString(Eval("Status")) == "Overdue"
                                    ? "br-pill danger"
                                    : "br-pill" %>'>

                                    <%#: Eval("Status") %>

                                </span>

                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField
                            HeaderText="Return Status">

                            <ItemTemplate>

                                <asp:Label
                                    ID="lblReturnStatus"
                                    runat="server"
                                    Text='<%#
                                        Convert.ToString(
                                            Eval("CollectionStatus")) == "Pending"
                                        ? "Awaiting Pickup"
                                        : Convert.ToString(
                                            Eval("CollectionStatus")) == "Cancelled"
                                        ? "Not Applicable"
                                        : Convert.ToString(
                                            Eval("Status")) == "Returned"
                                        ? "Completed"
                                        : Convert.ToBoolean(
                                            Eval("ReturnRequested"))
                                        ? "Return Requested"
                                        : "Not Requested" %>'
                                    CssClass="br-pill" />

                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField
                            HeaderText="Actions">

                            <ItemTemplate>

                                <asp:PlaceHolder
                                    ID="phPending"
                                    runat="server"
                                    Visible='<%#
                                        Convert.ToString(
                                            Eval("CollectionStatus")) == "Pending"
                                        && Convert.ToString(
                                            Eval("Status")) == "Borrowed" %>'>

                                    <asp:Button
                                        ID="btnConfirmCollection"
                                        runat="server"
                                        Text="Confirm Collection"
                                        CssClass="br-action br-collect"
                                        CommandName="ConfirmCollection"
                                        CommandArgument='<%# Eval("BorrowLogID") %>'
                                        CausesValidation="false"
                                        OnClientClick="return confirm('Confirm that the customer physically collected this book? The 7-day borrowing period will begin now.');" />

                                    <asp:TextBox
                                        ID="txtCancellationReason"
                                        runat="server"
                                        CssClass="br-reason"
                                        MaxLength="500"
                                        placeholder="Cancellation reason (required)" />

                                    <asp:Button
                                        ID="btnCancelReservation"
                                        runat="server"
                                        Text="Cancel Reservation"
                                        CssClass="br-action br-cancel"
                                        CommandName="CancelReservation"
                                        CommandArgument='<%# Eval("BorrowLogID") %>'
                                        CausesValidation="false"
                                        OnClientClick="return confirm('Cancel this reservation and restore one available copy?');" />

                                </asp:PlaceHolder>

                                <asp:PlaceHolder
                                    ID="phActive"
                                    runat="server"
                                    Visible='<%#
                                        Convert.ToString(
                                            Eval("CollectionStatus")) == "Collected"
                                        && (
                                            Convert.ToString(
                                                Eval("Status")) == "Borrowed"
                                            || Convert.ToString(
                                                Eval("Status")) == "Overdue"
                                        ) %>'>

                                    <asp:Button
                                        ID="btnConfirmReturn"
                                        runat="server"
                                        Text="Return Book"
                                        CssClass="br-action br-return"
                                        CommandName="ConfirmReturn"
                                        CommandArgument='<%# Eval("BorrowLogID") %>'
                                        CausesValidation="false"
                                        OnClientClick="return confirm('Confirm that the physical book has been returned?');" />

                                </asp:PlaceHolder>

                                <asp:Label
                                    ID="lblClosed"
                                    runat="server"
                                    CssClass="br-muted"
                                    Text="No actions"
                                    Visible='<%#
                                        Convert.ToString(
                                            Eval("CollectionStatus")) == "Cancelled"
                                        || (
                                            Convert.ToString(
                                                Eval("Status")) != "Borrowed"
                                            && Convert.ToString(
                                                Eval("Status")) != "Overdue"
                                        ) %>' />

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

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

    </div>

</asp:Content>
