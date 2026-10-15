
<%@ Page Title="Borrowing History"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="BorrowHistory.aspx.cs"
    Inherits="ELibrary.Customer.BorrowHistory" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* ==========================================
   COASTAL MINIMAL - BORROWING HISTORY UI-C5A
========================================== */

.el-customer-mode .coast-history {
    --h-ink:#123B4A;
    --h-teal:#168A91;
    --h-muted:#647F89;
    --h-border:#DCE9EB;
    display:flex;
    flex-direction:column;
    gap:23px;
    width:100%;
    min-width:0;
    padding-bottom:35px;
    color:var(--h-ink);
}
.el-customer-mode .coast-history * {
    box-sizing:border-box;
}
.el-customer-mode .coast-history .h-header {
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:20px;
    flex-wrap:wrap;
    padding:32px 36px;
    border:1px solid #D2E8E9;
    border-radius:20px;
    background:linear-gradient(115deg,#DDEFF0,#F5FAF8);
}
.el-customer-mode .coast-history .h-eyebrow {
    display:block;
    margin-bottom:10px;
    color:#13787C;
    font-size:10px;
    font-weight:850;
    letter-spacing:.13em;
}
.el-customer-mode .coast-history h1 {
    margin:0 0 9px;
    color:var(--h-ink);
    font-size:clamp(28px,3.6vw,39px);
    font-weight:850;
}
.el-customer-mode .coast-history .h-header p,
.el-customer-mode .coast-history .h-panel-head p {
    margin:0;
    color:#52737D;
    font-size:12px;
    line-height:1.8;
}
.el-customer-mode .coast-history .h-button {
    display:inline-flex;
    align-items:center;
    justify-content:center;
    padding:10px 16px;
    min-height:41px;
    border:1px solid #CFE3E4;
    border-radius:9px;
    background:white;
    color:var(--h-ink);
    font-size:12px;
    font-weight:800;
    text-decoration:none;
    cursor:pointer;
}
.el-customer-mode .coast-history .h-button:hover {
    background:#EAF6F6;
    color:var(--h-ink);
}
.el-customer-mode .coast-history .h-button.primary {
    background:var(--h-teal);
    border-color:var(--h-teal);
    color:white;
}
.el-customer-mode .coast-history .h-button.primary:hover {
    background:#12757C;
    color:white;
}
.el-customer-mode .coast-history .h-button:disabled {
    opacity:.45;
    cursor:default;
}
.el-customer-mode .coast-history .h-summary {
    display:grid;
    grid-template-columns:repeat(3,minmax(0,1fr));
    gap:14px;
}
.el-customer-mode .coast-history .h-stat {
    display:flex;
    flex-direction:column;
    gap:12px;
    min-width:0;
    padding:20px;
    background:white;
    border:1px solid var(--h-border);
    border-radius:14px;
}
.el-customer-mode .coast-history .h-stat-icon {
    display:flex;
    align-items:center;
    justify-content:center;
    width:40px;
    height:40px;
    border-radius:11px;
    background:#EAF6F6;
    color:#168A91;
    font-size:20px;
}
.el-customer-mode .coast-history .h-stat-icon.green {
    background:#E6F6EE;
    color:#237C62;
}
.el-customer-mode .coast-history .h-stat-icon.grey {
    background:#EDF2F4;
    color:#647F89;
}
.el-customer-mode .coast-history .h-stat span {
    color:var(--h-muted);
    font-size:12px;
    font-weight:700;
}
.el-customer-mode .coast-history .h-stat strong {
    color:var(--h-ink);
    font-size:30px;
    font-weight:850;
}
.el-customer-mode .coast-history .h-panel {
    padding:24px;
    min-width:0;
    background:white;
    border:1px solid var(--h-border);
    border-radius:15px;
}
.el-customer-mode .coast-history .h-panel-head {
    display:flex;
    justify-content:space-between;
    align-items:center;
    flex-wrap:wrap;
    gap:12px;
    margin-bottom:19px;
}
.el-customer-mode .coast-history .h-panel-head h2 {
    margin:0 0 6px;
    color:var(--h-ink);
    font-size:21px;
    font-weight:850;
}
.el-customer-mode .coast-history .h-filters {
    display:grid;
    grid-template-columns:minmax(185px,2fr) repeat(2,minmax(135px,1fr));
    gap:14px;
    padding:17px;
    background:#F5FAFA;
    border:1px solid var(--h-border);
    border-radius:11px;
}
.el-customer-mode .coast-history .h-field {
    min-width:0;
}
.el-customer-mode .coast-history .h-field label {
    display:block;
    margin-bottom:7px;
    color:#375968;
    font-size:12px;
    font-weight:750;
}
.el-customer-mode .coast-history .h-input {
    width:100%;
    display:block;
    min-height:42px;
    padding:10px 12px;
    border:1px solid #CFE1E4;
    border-radius:9px;
    background:white;
    color:var(--h-ink);
    font-size:12px;
}
.el-customer-mode .coast-history .h-input:focus {
    outline:none;
    border-color:var(--h-teal);
    box-shadow:0 0 0 3px rgba(22,138,145,.12);
}
.el-customer-mode .coast-history .h-filter-actions {
    grid-column:1/-1;
    display:flex;
    align-items:center;
    gap:9px;
    flex-wrap:wrap;
}
.el-customer-mode .coast-history .h-helper {
    color:var(--h-muted);
    font-size:11px;
}
.el-customer-mode .coast-history .el-history-message {
    display:block;
    margin:15px 0;
    font-size:12px;
    color:#9E3E39;
    line-height:1.7;
}
.el-customer-mode .coast-history .el-history-message:not(:empty) {
    padding:13px 16px;
    border:1px solid #F2D3CF;
    border-left:4px solid #C34D46;
    border-radius:9px;
    background:#FFF0EF;
}
.el-customer-mode .coast-history .h-result-bar {
    display:flex;
    justify-content:space-between;
    align-items:center;
    flex-wrap:wrap;
    gap:10px;
    margin:17px 0 13px;
    color:var(--h-muted);
    font-size:12px;
}
.el-customer-mode .coast-history .h-table-wrap {
    overflow-x:auto;
    width:100%;
    border:1px solid var(--h-border);
    border-radius:10px;
}
.el-customer-mode .coast-history .h-table {
    width:100%;
    min-width:710px;
    border-collapse:collapse;
    background:white;
    font-size:12px;
}
.el-customer-mode .coast-history .h-table th {
    padding:14px 12px;
    border-bottom:1px solid var(--h-border);
    background:#F5FAFA;
    color:#496B75;
    font-size:11px;
    font-weight:800;
    text-align:left;
    white-space:nowrap;
}
.el-customer-mode .coast-history .h-table td {
    padding:15px 12px;
    border-bottom:1px solid #EDF3F4;
    color:#47616D;
    vertical-align:middle;
}
.el-customer-mode .coast-history .h-table tr:hover td {
    background:#F9FCFC;
}
.el-customer-mode .coast-history .h-record {
    display:flex;
    flex-direction:column;
    gap:6px;
    min-width:160px;
}
.el-customer-mode .coast-history .h-record strong {
    color:var(--h-ink);
    font-size:12px;
    overflow-wrap:anywhere;
}
.el-customer-mode .coast-history .h-record small {
    color:var(--h-muted);
    font-size:11px;
}
.el-customer-mode .coast-history .el-history-pill {
    display:inline-flex;
    padding:7px 11px;
    border-radius:999px;
    background:#EAF6F6;
    color:#126E73;
    font-size:11px;
    font-weight:800;
    white-space:nowrap;
}
.el-customer-mode .coast-history .el-history-pill.returned {
    background:#E6F6EE;
    color:#237C62;
}
.el-customer-mode .coast-history .el-history-pill.cancelled {
    background:#EDF2F4;
    color:#59717C;
}
.el-customer-mode .coast-history .el-history-pill.lost {
    background:#FCE9E7;
    color:#A63D39;
}
.el-customer-mode .coast-history .h-details summary {
    display:inline-flex;
    align-items:center;
    gap:12px;
    padding:8px 12px;
    border:1px solid #CDE7E9;
    border-radius:8px;
    background:#EAF6F6;
    color:#126E73;
    font-size:11px;
    font-weight:800;
    cursor:pointer;
    list-style:none;
}
.el-customer-mode .coast-history .h-details summary::-webkit-details-marker {
    display:none;
}
.el-customer-mode .coast-history .h-details summary::after {
    content:"⌄";
}
.el-customer-mode .coast-history .h-details[open] summary::after {
    content:"⌃";
}
.el-customer-mode .coast-history .h-detail-content {
    display:grid;
    grid-template-columns:repeat(2,minmax(0,1fr));
    gap:12px;
    width:340px;
    max-width:55vw;
    margin-top:10px;
    padding:15px;
    border:1px solid var(--h-border);
    border-radius:9px;
    background:#F7FBFB;
}
.el-customer-mode .coast-history .h-detail-content div {
    display:flex;
    flex-direction:column;
    gap:5px;
    min-width:0;
}
.el-customer-mode .coast-history .h-detail-content small {
    color:var(--h-muted);
    font-size:10px;
}
.el-customer-mode .coast-history .h-detail-content strong {
    color:var(--h-ink);
    font-size:12px;
    overflow-wrap:anywhere;
}
.el-customer-mode .coast-history .h-pager {
    display:flex;
    align-items:center;
    justify-content:center;
    flex-wrap:wrap;
    gap:12px;
    margin-top:20px;
}
.el-customer-mode .coast-history .h-bottom {
    color:#168A91;
    font-size:12px;
    font-weight:800;
    text-decoration:none;
}
@media(max-width:850px) {
    .el-customer-mode .coast-history .h-filters {
        grid-template-columns:repeat(2,minmax(0,1fr));
    }
    .el-customer-mode .coast-history .h-search {
        grid-column:1/-1;
    }
}
@media(max-width:600px) {
    .el-customer-mode .coast-history .h-header {
        padding:25px 20px;
    }
    .el-customer-mode .coast-history .h-summary {
        grid-template-columns:1fr;
        gap:10px;
    }
    .el-customer-mode .coast-history .h-stat {
        padding:15px;
    }
    .el-customer-mode .coast-history .h-panel {
        padding:15px;
    }
    .el-customer-mode .coast-history .h-filters {
        grid-template-columns:1fr;
        padding:12px;
    }
    .el-customer-mode .coast-history .h-search {
        grid-column:auto;
    }
    .el-customer-mode .coast-history .h-filter-actions .h-button {
        flex:1;
    }
    .el-customer-mode .coast-history .h-detail-content {
        max-width:270px;
        grid-template-columns:1fr;
    }
}
</style>
</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="coast-history">

    <!-- INTRO -->
    <header class="h-header">
        <div>
            <span class="h-eyebrow">YOUR READING JOURNEY</span>
            <h1>Borrowing History</h1>
            <p>Review your returned books, lost records,
               and cancelled reservations.</p>
        </div>

        <asp:Button
            ID="btnCurrentBorrows"
            runat="server"
            Text="← Current Borrowings"
            CssClass="h-button"
            CausesValidation="false"
            OnClick="btnCurrentBorrows_Click" />
    </header>

    <!-- COUNTERS -->
    <section class="h-summary"
        aria-label="Borrowing history summary">

        <div class="h-stat">
            <div class="h-stat-icon" aria-hidden="true">▤</div>
            <div>
                <span>History Records</span>
                <strong>
                    <asp:Label ID="lblHistoryCount"
                        runat="server" Text="0" />
                </strong>
            </div>
        </div>

        <div class="h-stat">
            <div class="h-stat-icon green" aria-hidden="true">✓</div>
            <div>
                <span>Returned Records</span>
                <strong>
                    <asp:Label ID="lblReturnedCount"
                        runat="server" Text="0" />
                </strong>
            </div>
        </div>

        <div class="h-stat">
            <div class="h-stat-icon grey" aria-hidden="true">×</div>
            <div>
                <span>Cancelled Reservations</span>
                <strong>
                    <asp:Label ID="lblCancelledCount"
                        runat="server" Text="0" />
                </strong>
            </div>
        </div>

    </section>

    <!-- HISTORY RECORDS -->
    <section class="h-panel">

        <div class="h-panel-head">
            <div>
                <h2>Your Borrowing Records</h2>
                <p>Find a previous borrowing and review its dates.</p>
            </div>
        </div>

        <!-- SERVER-SIDE FILTERS -->
        <asp:Panel ID="pnlFilters"
            runat="server"
            DefaultButton="btnApply"
            CssClass="h-filters">

            <div class="h-field h-search">
                <asp:Label runat="server"
                    AssociatedControlID="txtSearch"
                    Text="Search History" />

                <asp:TextBox ID="txtSearch"
                    runat="server"
                    CssClass="h-input"
                    MaxLength="255"
                    autocomplete="off"
                    placeholder="Book title, author or Borrow ID..." />
            </div>

            <div class="h-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlStatus"
                    Text="Record Status" />

                <asp:DropDownList ID="ddlStatus"
                    runat="server" CssClass="h-input">

                    <asp:ListItem Text="All Statuses" Value="All" />
                    <asp:ListItem Text="Returned" Value="Returned" />
                    <asp:ListItem Text="Lost" Value="Lost" />
                    <asp:ListItem Text="Cancelled" Value="Cancelled" />

                </asp:DropDownList>
            </div>

            <div class="h-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlSort"
                    Text="Sort By" />

                <asp:DropDownList ID="ddlSort"
                    runat="server" CssClass="h-input">

                    <asp:ListItem Text="Newest Reserved" Value="Newest" />
                    <asp:ListItem Text="Oldest Reserved" Value="Oldest" />
                    <asp:ListItem Text="Recently Returned" Value="RecentlyReturned" />
                    <asp:ListItem Text="Book Title (A–Z)" Value="Title" />

                </asp:DropDownList>
            </div>

            <div class="h-filter-actions">

                <asp:Button ID="btnApply"
                    runat="server"
                    Text="Apply Filters"
                    CssClass="h-button primary"
                    CausesValidation="false"
                    OnClick="btnApply_Click" />

                <asp:Button ID="btnClear"
                    runat="server"
                    Text="Clear Filters"
                    CssClass="h-button"
                    CausesValidation="false"
                    OnClick="btnClear_Click" />

                <span class="h-helper">
                    Press Enter or Apply to search.
                </span>
            </div>

        </asp:Panel>

        <!-- LOCAL FILTER ERROR -->
        <asp:Label ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="el-history-message"
            role="alert" />

        <div class="h-result-bar">
            <asp:Label ID="lblResults"
                runat="server"
                Text="Showing borrowing history" />

            <span>Open Details to see every date.</span>
        </div>

        <!-- SIMPLIFIED GRID -->
        <div class="h-table-wrap">

            <asp:GridView ID="gvHistory"
                runat="server"
                AutoGenerateColumns="False"
                GridLines="None"
                CssClass="h-table"
                EmptyDataText="No history matches your filters.">

                <Columns>

                    <asp:TemplateField HeaderText="Borrow ID">
                        <ItemTemplate>
                            <strong>#<%#: Eval("BorrowLogID") %></strong>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Book">
                        <ItemTemplate>
                            <div class="h-record">
                                <strong><%#: Eval("Title") %></strong>
                                <small>by <%#: Eval("Author") %></small>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Reserved">
                        <ItemTemplate>
                            <%#: FormatHistoryDate(Eval("DateBorrowed")) %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='<%# GetStatusClass(
                                Eval("DisplayStatus")) %>'>
                                <%#: Eval("DisplayStatus") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="More">
                        <ItemTemplate>

                            <details class="h-details">
                                <summary>View Details</summary>

                                <div class="h-detail-content">

                                    <div>
                                        <small>Collected</small>
                                        <strong>
                                            <%#: FormatHistoryDate(
                                                Eval("DateCollected")) %>
                                        </strong>
                                    </div>

                                    <div>
                                        <small>Due Date</small>
                                        <strong>
                                            <%#: FormatHistoryDate(
                                                Eval("DueDate")) %>
                                        </strong>
                                    </div>

                                    <div>
                                        <small>Returned</small>
                                        <strong>
                                            <%#: FormatHistoryDate(
                                                Eval("DateReturned")) %>
                                        </strong>
                                    </div>

                                    <div>
                                        <small>Cancelled</small>
                                        <strong>
                                            <%#: FormatHistoryDate(
                                                Eval("DateCancelled")) %>
                                        </strong>
                                    </div>

                                </div>
                            </details>

                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

            </asp:GridView>

        </div>

        <div class="h-pager">

            <asp:Button ID="btnPrevious"
                runat="server"
                Text="← Previous"
                CssClass="h-button"
                CausesValidation="false"
                OnClick="btnPrevious_Click" />

            <asp:Label ID="lblPageInfo"
                runat="server"
                Text="Page 1 of 1"
                CssClass="h-helper" />

            <asp:Button ID="btnNext"
                runat="server"
                Text="Next →"
                CssClass="h-button"
                CausesValidation="false"
                OnClick="btnNext_Click" />

        </div>

    </section>

    <a class="h-bottom"
        href="<%= ResolveUrl("~/Customer/Books.aspx") %>">
        ← Explore More Books
    </a>

</div>

</asp:Content>
