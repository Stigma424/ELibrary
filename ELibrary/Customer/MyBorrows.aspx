
<%@ Page Title="My Borrowings"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="MyBorrows.aspx.cs"
    Inherits="ELibrary.Customer.MyBorrows"
    MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <style>
        /* ==========================================
           MY BORROWS - FILTERS
           ========================================== */

        .el-borrow-filters {
            background: #f5f8fc;
            border: 1px solid #dce5f0;
            border-radius: 12px;
            padding: 20px;
            margin: 0 0 20px;
            box-sizing: border-box;
        }

        .el-borrow-filter-grid {
            display: grid;
            grid-template-columns:
                minmax(200px, 2fr)
                repeat(3, minmax(130px, 1fr));
            gap: 16px;
            align-items: end;
        }

        .el-borrow-field {
            min-width: 0;
        }

        .el-borrow-field label {
            display: block;
            margin-bottom: 8px;
            color: #354c69;
            font-size: .85rem;
            font-weight: 650;
        }

        .el-borrow-input {
            width: 100%;
            min-height: 43px;
            box-sizing: border-box;
            padding: 9px 12px;
            border: 1px solid #d4e0ed;
            border-radius: 9px;
            background: white;
            color: #172d49;
            font: inherit;
        }

        .el-borrow-input:focus {
            outline: none;
            border-color: #397cbd;
            box-shadow: 0 0 0 3px rgba(57,124,189,.14);
        }

        .el-borrow-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
            margin-top: 18px;
        }

        .el-borrow-btn {
            border: 1px solid #1c4169;
            border-radius: 9px;
            background: #1c4169;
            color: white;
            padding: 10px 20px;
            min-height: 43px;
            font-weight: 650;
            cursor: pointer;
        }

        .el-borrow-btn:hover {
            background: #14324f;
            color: white;
        }

        .el-borrow-btn-clear {
            background: white;
            color: #1c4169;
            border-color: #bed0e2;
        }

        .el-borrow-btn-clear:hover {
            background: #eaf2fa;
            color: #1c4169;
        }

        .el-borrow-results {
            color: #61748e;
            font-size: .87rem;
            margin: 0 0 14px;
            padding: 0 2px;
        }

        /* ==========================================
           MAIN BORROWING PANEL
           ========================================== */

        .el-records-page .el-records-panel {
            padding: 24px;
            box-sizing: border-box;
            min-width: 0;
        }

        .el-records-page .el-records-panel-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 20px;
            padding-bottom: 18px;
        }

        .el-records-page .el-records-panel-heading h2 {
            margin: 0 0 6px;
        }

        .el-records-page .el-records-panel-heading p {
            margin: 0;
            line-height: 1.6;
        }

        /* ==========================================
           BORROWING TABLE SPACING
           ========================================== */

        .el-records-page .el-records-table-scroll {
            width: 100%;
            max-width: 100%;
            overflow-x: auto;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            box-sizing: border-box;
        }

        .el-records-page .el-records-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin: 0;
        }

        .el-records-page .el-records-table th {
            padding: 15px 18px;
            text-align: left;
            vertical-align: middle;
            white-space: nowrap;
            line-height: 1.5;
        }

        .el-records-page .el-records-table td {
            padding: 18px;
            vertical-align: middle;
            line-height: 1.6;
            border-bottom: 1px solid #e7edf5;
        }

        .el-records-page .el-records-table tr:last-child td {
            border-bottom: none;
        }

        .el-records-page .el-records-book-cell {
            display: flex;
            flex-direction: column;
            gap: 5px;
            min-width: 160px;
        }

        .el-records-page .el-records-book-cell strong {
            display: block;
            line-height: 1.5;
            overflow-wrap: anywhere;
        }

        .el-records-page .el-records-book-cell small {
            display: block;
            line-height: 1.5;
        }

        /* ==========================================
           COLLECTION STATUS BADGES
           ========================================== */

        .el-borrow-lifecycle {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            line-height: 1.5;
            white-space: nowrap;
        }

        .el-borrow-lifecycle.pending {
            background: #fff1ce;
            color: #886000;
        }

        .el-borrow-lifecycle.collected {
            background: #e8f2fc;
            color: #245e91;
        }

        .el-borrow-lifecycle.cancelled {
            background: #ffe8e8;
            color: #a33a3a;
        }

        .el-borrow-lifecycle.returned {
            background: #e5f5eb;
            color: #237c4e;
        }

        /* ==========================================
           ROW ACTIONS
           ========================================== */

        .el-borrow-row-action {
            display: inline-block;
            border: 1px solid transparent;
            border-radius: 8px;
            padding: 9px 13px;
            font-size: 12px;
            font-weight: 700;
            line-height: 1.5;
            cursor: pointer;
            white-space: normal;
            text-align: center;
            max-width: 100%;
        }

        .el-borrow-cancel {
            background: #fff0f0;
            color: #a33a3a;
            border-color: #f2caca;
        }

        .el-borrow-cancel:hover {
            background: #ffe1e1;
        }

        .el-borrow-return {
            background: #e9f3fc;
            color: #245e91;
            border-color: #cbdff0;
        }

        .el-borrow-return:hover {
            background: #d9eafa;
        }

        .el-borrow-row-action:disabled {
            opacity: .55;
            cursor: not-allowed;
        }

        .el-borrow-muted {
            font-size: 12px;
            color: #7b8a9b;
        }

        .el-borrow-reason {
            display: block;
            width: 190px;
            max-width: 100%;
            padding: 10px 12px;
            margin: 0 0 10px;
            border: 1px solid #d4e0ed;
            border-radius: 7px;
            font-size: 12px;
            line-height: 1.5;
            box-sizing: border-box;
        }

        .el-borrow-date {
            display: block;
            font-size: 12px;
            white-space: nowrap;
        }

        /* ==========================================
           RESERVATION REMINDER
           ========================================== */

        .el-borrow-note {
            background: #f4f8fc;
            border: 1px solid #dce7f2;
            border-radius: 10px;
            padding: 16px 20px;
            margin: 16px 0 22px;
            color: #52677e;
            font-size: 13px;
            line-height: 1.7;
        }

        /* ==========================================
           PAGINATION
           ========================================== */

        .el-borrow-pager {
            display: flex;
            align-items: center;
            justify-content: center;
            flex-wrap: wrap;
            gap: 12px;
            padding: 22px 0 10px;
            margin: 0;
        }

        .el-borrow-page-info {
            color: #61748e;
            font-size: .85rem;
        }

        .el-borrow-page-btn {
            border: 1px solid #d4e0ed;
            border-radius: 8px;
            background: white;
            color: #1c4169;
            padding: 9px 14px;
            cursor: pointer;
        }

        .el-borrow-page-btn:hover {
            background: #eaf2fa;
        }

        .el-borrow-page-btn:disabled {
            opacity: .45;
            cursor: default;
        }

        .el-records-page .el-records-panel-footer {
            margin-top: 18px;
            padding-top: 18px;
            line-height: 1.7;
        }

        /* ==========================================
           RESPONSIVE LAYOUT
           ========================================== */

        @media (max-width: 950px) {
            .el-borrow-filter-grid {
                grid-template-columns:
                    repeat(2, minmax(0, 1fr));
            }

            .el-records-page .el-records-panel {
                padding: 18px;
            }

            .el-records-page .el-records-table th {
                padding: 13px 15px;
            }

            .el-records-page .el-records-table td {
                padding: 15px;
            }
        }

        @media (max-width: 560px) {
            .el-borrow-filter-grid {
                grid-template-columns: 1fr;
            }

            .el-records-page .el-records-panel {
                padding: 14px;
            }

            .el-records-page .el-records-panel-heading {
                flex-direction: column;
                align-items: flex-start;
            }

            .el-borrow-filters {
                padding: 14px;
            }

            .el-records-page .el-records-table th {
                padding: 12px;
            }

            .el-records-page .el-records-table td {
                padding: 12px;
            }

            .el-borrow-pager {
                gap: 8px;
                padding: 18px 0 8px;
            }
        }
    </style>

    <div class="el-records-page">

        <!-- PAGE HEADING -->
        <div class="el-records-heading">
            <div>
                <span class="el-section-eyebrow">
                    MY LIBRARY
                </span>

                <h1>My Borrowings</h1>

                <p>
                    Manage reservations, track collected books,
                    and request returns.
                </p>
            </div>

            <a href="<%= ResolveUrl("~/Customer/Books.aspx") %>"
               class="el-records-primary-link">
                + Browse Books
            </a>
        </div>

        <!-- SUMMARY -->
        <div class="el-records-summary">

            <div class="el-records-summary-item">
                <div class="el-records-summary-icon">📚</div>

                <div>
                    <span>Current Reservations &amp; Loans</span>

                    <strong>
                        <asp:Label
                            ID="lblTotalBorrows"
                            runat="server"
                            Text="0" />
                    </strong>
                </div>
            </div>

            <div class="el-records-summary-item">
                <div class="el-records-summary-icon">⏰</div>

                <div>
                    <span>Overdue Books</span>

                    <strong>
                        <asp:Label
                            ID="lblOverdueCount"
                            runat="server"
                            Text="0" />
                    </strong>
                </div>
            </div>

            <div class="el-records-summary-item">
                <div class="el-records-summary-icon">📖</div>

                <div>
                    <span>Pending Pickups</span>

                    <strong>
                        <asp:Label
                            ID="lblPendingCount"
                            runat="server"
                            Text="0" />
                    </strong>
                </div>
            </div>

            <div class="el-records-summary-item">
                <div class="el-records-summary-icon">↩</div>

                <div>
                    <span>Pending Return Requests</span>

                    <strong>
                        <asp:Label
                            ID="lblReturnPendingCount"
                            runat="server"
                            Text="0" />
                    </strong>
                </div>
            </div>

        </div>

        <!-- MESSAGE -->
        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="el-records-message" />

        <!-- RESERVATION REMINDER -->
        <div class="el-borrow-note">
            <strong>Reservation reminder:</strong>
            Reserving a book holds one available copy.
            Your 7-day borrowing period starts only after
            a librarian confirms physical collection.
            You may cancel a reservation before collection.
        </div>

        <!-- BORROWING LIST PANEL -->
        <section class="el-records-panel">

            <div class="el-records-panel-heading">
                <div>
                    <h2>Reservations &amp; Borrowings</h2>

                    <p>
                        View pending pickups and active loans.
                        Returned and cancelled records are available
                        in Borrow History.
                    </p>
                </div>

                <asp:Button
                    ID="btnHistory"
                    runat="server"
                    Text="View History →"
                    CssClass="btn btn-outline-primary btn-sm"
                    CausesValidation="false"
                    OnClick="btnHistory_Click" />
            </div>

            <!-- SEARCH AND FILTER -->
            <div class="el-borrow-filters">

                <asp:Panel
                    ID="pnlFilters"
                    runat="server"
                    DefaultButton="btnApply">

                    <div class="el-borrow-filter-grid">

                        <div class="el-borrow-field">
                            <asp:Label
                                runat="server"
                                AssociatedControlID="txtSearch"
                                Text="Search Borrowings" />

                            <asp:TextBox
                                ID="txtSearch"
                                runat="server"
                                CssClass="el-borrow-input"
                                MaxLength="255"
                                placeholder="Title, author, or Borrow ID" />
                        </div>

                        <div class="el-borrow-field">
                            <asp:Label
                                runat="server"
                                AssociatedControlID="ddlStatus"
                                Text="Borrow Status" />

                            <asp:DropDownList
                                ID="ddlStatus"
                                runat="server"
                                CssClass="el-borrow-input">

                                <asp:ListItem
                                    Text="All Active Records"
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

                            </asp:DropDownList>
                        </div>

                        <div class="el-borrow-field">
                            <asp:Label
                                runat="server"
                                AssociatedControlID="ddlReturn"
                                Text="Return Request" />

                            <asp:DropDownList
                                ID="ddlReturn"
                                runat="server"
                                CssClass="el-borrow-input">

                                <asp:ListItem
                                    Text="All Requests"
                                    Value="All" />

                                <asp:ListItem
                                    Text="Return Requested"
                                    Value="Pending" />

                                <asp:ListItem
                                    Text="Not Requested"
                                    Value="NotRequested" />

                            </asp:DropDownList>
                        </div>

                        <div class="el-borrow-field">
                            <asp:Label
                                runat="server"
                                AssociatedControlID="ddlSort"
                                Text="Sort By" />

                            <asp:DropDownList
                                ID="ddlSort"
                                runat="server"
                                CssClass="el-borrow-input">

                                <asp:ListItem
                                    Text="Due Soonest / Pending First"
                                    Value="DueSoonest" />

                                <asp:ListItem
                                    Text="Due Latest"
                                    Value="DueLatest" />

                                <asp:ListItem
                                    Text="Newest"
                                    Value="Newest" />

                                <asp:ListItem
                                    Text="Oldest"
                                    Value="Oldest" />

                                <asp:ListItem
                                    Text="Book Title (A-Z)"
                                    Value="Title" />

                            </asp:DropDownList>
                        </div>

                    </div>

                    <div class="el-borrow-actions">

                        <asp:Button
                            ID="btnApply"
                            runat="server"
                            Text="Apply Filters"
                            CssClass="el-borrow-btn"
                            CausesValidation="false"
                            OnClick="btnApply_Click" />

                        <asp:Button
                            ID="btnClear"
                            runat="server"
                            Text="Clear Filters"
                            CssClass="el-borrow-btn el-borrow-btn-clear"
                            CausesValidation="false"
                            OnClick="btnClear_Click" />

                        <span class="el-borrow-page-info">
                            Press Enter or click Apply to search.
                        </span>

                    </div>

                </asp:Panel>

            </div>

            <!-- RESULT COUNT -->
            <div class="el-borrow-results">

                <asp:Label
                    ID="lblResults"
                    runat="server"
                    Text="Showing borrowings" />

            </div>

            <!-- BORROWING TABLE -->
            <div class="el-records-table-scroll">

                <asp:GridView
                    ID="gvBorrows"
                    runat="server"
                    AutoGenerateColumns="False"
                    CssClass="el-records-table"
                    GridLines="None"
                    EmptyDataText="No active borrowing records match your search."
                    OnRowCommand="gvBorrows_RowCommand">

                    <Columns>

                        
                        <asp:TemplateField HeaderText="Borrow ID">
                            <ItemTemplate>
                                <span class="el-records-id">
                                    #<%#: Eval("BorrowLogID") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

  
                        <asp:TemplateField HeaderText="Book">
                            <ItemTemplate>
                                <div class="el-records-book-cell">

                                    <strong>
                                        <%#: Eval("Title") %>
                                    </strong>

                                    <small>
                                        <%#: Eval("Author") %>
                                    </small>

                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Borrowing Fee">
                            <ItemTemplate>
                                <span class="el-records-money">
                                    ₱<%# Eval("BorrowingFee", "{0:N2}") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField
                            DataField="DateBorrowed"
                            HeaderText="Reserved On"
                            DataFormatString="{0:MMM dd, yyyy}" />

                        <asp:TemplateField HeaderText="Collected On">
                            <ItemTemplate>
                                <span class="el-borrow-date">
                                    <%# FormatDate(Eval("DateCollected")) %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Due Date">
                            <ItemTemplate>
                                <span class='<%# GetDueDateClass(
                                    Eval("DueDate"),
                                    Eval("Status")) %>'>

                                    <%# FormatDate(Eval("DueDate")) %>

                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Collection Status">
                            <ItemTemplate>
                                <span class='<%# GetCollectionClass(
                                    Eval("CollectionStatus"),
                                    Eval("Status")) %>'>

                                    <%#: GetCollectionDisplay(
                                        Eval("CollectionStatus"),
                                        Eval("Status")) %>

                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                      
                        <asp:TemplateField HeaderText="Loan Status">
                            <ItemTemplate>
                                <span class='<%# GetStatusClass(
                                    Eval("Status")) %>'>

                                    <%#: Eval("Status") %>

                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>

                                <asp:PlaceHolder
                                    ID="phPending"
                                    runat="server"
                                    Visible='<%#
                                        Convert.ToString(
                                            Eval("CollectionStatus")) == "Pending"
                                        && Convert.ToString(
                                            Eval("Status")) == "Borrowed" %>'>

                                    <asp:TextBox
                                        ID="txtCancellationReason"
                                        runat="server"
                                        CssClass="el-borrow-reason"
                                        MaxLength="500"
                                        placeholder="Reason (optional)" />

                                    <asp:Button
                                        ID="btnCancelReservation"
                                        runat="server"
                                        Text="Cancel Reservation"
                                        CssClass="el-borrow-row-action el-borrow-cancel"
                                        CausesValidation="false"
                                        CommandName="CancelReservation"
                                        CommandArgument='<%# Eval("BorrowLogID") %>'
                                        OnClientClick="return confirm('Cancel this reservation? One book copy will become available again.');" />

                                </asp:PlaceHolder>

                                <!-- COLLECTED ACTIVE LOAN -->
                                <asp:PlaceHolder
                                    ID="phCollected"
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
                                        ID="btnRequestReturn"
                                        runat="server"
                                        Text='<%#
                                            Convert.ToBoolean(
                                                Eval("ReturnRequested"))
                                            ? "Pending Confirmation"
                                            : "Request Return" %>'
                                        Enabled='<%#
                                            !Convert.ToBoolean(
                                                Eval("ReturnRequested")) %>'
                                        CssClass="el-borrow-row-action el-borrow-return"
                                        CausesValidation="false"
                                        CommandName="RequestReturn"
                                        CommandArgument='<%# Eval("BorrowLogID") %>'
                                        OnClientClick="return confirm('Request to return this book?');" />

                                </asp:PlaceHolder>

                                <!-- CLOSED RECORD -->
                                <asp:PlaceHolder
                                    ID="phClosed"
                                    runat="server"
                                    Visible='<%#
                                        Convert.ToString(
                                            Eval("CollectionStatus")) == "Cancelled"
                                        || Convert.ToString(
                                            Eval("Status")) == "Returned"
                                        || Convert.ToString(
                                            Eval("Status")) == "Lost" %>'>

                                    <span class="el-borrow-muted">
                                        No actions available
                                    </span>

                                </asp:PlaceHolder>

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

            <!-- PAGINATION -->
            <div class="el-borrow-pager">

                <asp:Button
                    ID="btnPrevious"
                    runat="server"
                    Text="← Previous"
                    CssClass="el-borrow-page-btn"
                    CausesValidation="false"
                    OnClick="btnPrevious_Click" />

                <asp:Label
                    ID="lblPageInfo"
                    runat="server"
                    CssClass="el-borrow-page-info"
                    Text="Page 1 of 1" />

                <asp:Button
                    ID="btnNext"
                    runat="server"
                    Text="Next →"
                    CssClass="el-borrow-page-btn"
                    CausesValidation="false"
                    OnClick="btnNext_Click" />

            </div>

            <!-- FOOTER -->
            <div class="el-records-panel-footer">
                <span>
                    Pending reservations may be cancelled before
                    collection. Collected books must be physically
                    returned and confirmed by the librarian.
                </span>
            </div>

        </section>

    </div>

</asp:Content>
