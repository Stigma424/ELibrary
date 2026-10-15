
<%@ Page Title="Audit Logs"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="AuditLogs.aspx.cs"
    Inherits="ELibrary.Admin.Audit.AuditLogs" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

<style>
/* ============================================
   INTERNSHIPELIB - OCEAN TEAL
   UI-4B AUDIT LOGS
============================================ */

.el-audit-page {
    --al-primary:#123B4A;
    --al-accent:#168A91;
    --al-hover:#12757C;
    --al-muted:#647F89;
    --al-border:#DCE9EB;
    --al-soft:#F5FAFA;

    display:flex;
    flex-direction:column;
    gap:21px;
    min-width:0;
    padding-bottom:30px;
    color:var(--al-primary);
}

.el-audit-page *,
.el-audit-page *::before,
.el-audit-page *::after {
    box-sizing:border-box;
}

.el-audit-page .al-header {
    display:flex;
    justify-content:space-between;
    align-items:center;
    flex-wrap:wrap;
    gap:14px;
}

.el-audit-page .al-eyebrow {
    display:block;
    margin-bottom:8px;
    color:var(--al-accent);
    font-size:10px;
    font-weight:800;
    letter-spacing:.12em;
}

.el-audit-page .al-header h1 {
    margin:0 0 7px;
    color:var(--al-primary);
    font-size:29px;
    font-weight:800;
}

.el-audit-page .al-header p,
.el-audit-page .al-panel-head p {
    margin:0;
    color:var(--al-muted);
    font-size:12px;
    line-height:1.7;
}

.el-audit-page .al-tag {
    display:inline-flex;
    align-items:center;
    padding:7px 11px;
    border-radius:8px;
    background:#E9F6F6;
    color:#126E73;
    font-size:11px;
    font-weight:750;
}

.el-audit-page .al-panel {
    min-width:0;
    padding:23px;
    background:#FFFFFF;
    border:1px solid var(--al-border);
    border-radius:14px;
    box-shadow:0 3px 14px rgba(18,59,74,.035);
}

.el-audit-page .al-panel-head {
    display:flex;
    align-items:flex-start;
    justify-content:space-between;
    flex-wrap:wrap;
    gap:12px;
    margin-bottom:20px;
}

.el-audit-page .al-panel-head h2 {
    margin:0 0 6px;
    color:var(--al-primary);
    font-size:18px;
    font-weight:800;
}

.el-audit-page .al-filters {
    display:grid;
    grid-template-columns:repeat(4,minmax(0,1fr));
    gap:14px;
    padding:16px;
    background:var(--al-soft);
    border:1px solid var(--al-border);
    border-radius:11px;
}

.el-audit-page .al-field {
    min-width:0;
}

.el-audit-page .al-search {
    grid-column:span 2;
}

.el-audit-page .al-field label {
    display:block;
    margin-bottom:7px;
    color:#375968;
    font-size:12px;
    font-weight:700;
}

.el-audit-page .al-input {
    display:block;
    width:100%;
    min-height:41px;
    padding:9px 12px;
    background:#FFFFFF;
    color:var(--al-primary);
    border:1px solid #CFE1E4;
    border-radius:8px;
    font-size:12px;
}

.el-audit-page .al-input:focus {
    outline:none;
    border-color:var(--al-accent);
    box-shadow:0 0 0 3px rgba(22,138,145,.12);
}

.el-audit-page .al-actions {
    display:flex;
    align-items:center;
    gap:9px;
    flex-wrap:wrap;
    margin-top:16px;
}

.el-audit-page .al-btn {
    display:inline-flex;
    align-items:center;
    justify-content:center;
    min-height:40px;
    padding:9px 16px;
    color:var(--al-primary);
    background:#FFFFFF;
    border:1px solid var(--al-border);
    border-radius:9px;
    font-size:12px;
    font-weight:750;
    cursor:pointer;
    text-decoration:none;
}

.el-audit-page .al-btn:hover {
    color:var(--al-primary);
    background:#EAF5F6;
    border-color:#B4DADD;
}

.el-audit-page .al-btn-primary {
    color:#FFFFFF;
    background:var(--al-accent);
    border-color:var(--al-accent);
}

.el-audit-page .al-btn-primary:hover {
    color:#FFFFFF;
    background:var(--al-hover);
    border-color:var(--al-hover);
}

.el-audit-page .al-btn:disabled {
    opacity:.45;
    cursor:default;
}

.el-audit-page .al-message {
    display:block;
    margin-top:16px;
    padding:13px 16px;
    background:#FFF0EF;
    border:1px solid #F2D3CF;
    border-left:4px solid #C34D46;
    border-radius:9px;
    color:#9E3E39;
    font-size:12px;
    line-height:1.7;
}

.el-audit-page .al-message:empty {
    display:none;
}

.el-audit-page .al-table-wrap {
    width:100%;
    overflow-x:auto;
    border:1px solid var(--al-border);
    border-radius:10px;
    -webkit-overflow-scrolling:touch;
}

.el-audit-page .al-table {
    min-width:1020px;
    width:100%;
    border-collapse:collapse;
    background:#FFFFFF;
    font-size:12px;
}

.el-audit-page .al-table th {
    padding:14px 12px;
    background:var(--al-soft);
    color:#496B75;
    border-bottom:1px solid var(--al-border);
    font-size:11px;
    font-weight:800;
    text-align:left;
    white-space:nowrap;
}

.el-audit-page .al-table td {
    padding:14px 12px;
    border-bottom:1px solid #EDF3F4;
    color:#47616D;
    vertical-align:middle;
}

.el-audit-page .al-table tr:hover td {
    background:#F9FCFC;
}

.el-audit-page .al-actor {
    display:flex;
    flex-direction:column;
    gap:5px;
    min-width:120px;
}

.el-audit-page .al-actor strong {
    color:var(--al-primary);
    font-size:12px;
    font-weight:800;
    overflow-wrap:anywhere;
}

.el-audit-page .al-actor small {
    color:var(--al-muted);
    font-size:11px;
}

.el-audit-page .al-category {
    display:inline-block;
    padding:6px 10px;
    color:#126E73;
    background:#E9F6F6;
    border-radius:999px;
    font-size:11px;
    font-weight:750;
    white-space:nowrap;
}

.el-audit-page .al-action-text {
    display:block;
    min-width:160px;
    max-width:380px;
    line-height:1.7;
    overflow-wrap:anywhere;
    white-space:normal;
}

.el-audit-page .al-reference {
    color:var(--al-primary);
    font-weight:700;
}

.el-audit-page .al-empty {
    padding:25px;
    text-align:center;
    color:var(--al-muted);
}

.el-audit-page .al-footer {
    display:flex;
    justify-content:space-between;
    align-items:center;
    flex-wrap:wrap;
    gap:16px;
    margin-top:18px;
    font-size:12px;
    color:var(--al-muted);
}

.el-audit-page .al-pager {
    display:flex;
    justify-content:center;
    align-items:center;
    flex-wrap:wrap;
    gap:12px;
}

.el-audit-page .al-note {
    padding:16px 18px;
    border:1px solid #D2E7E8;
    border-radius:10px;
    background:#EAF6F6;
    color:#315D67;
    font-size:12px;
    line-height:1.8;
}

.el-audit-page .al-note strong {
    color:var(--al-primary);
}

@media(max-width:1100px) {
    .el-audit-page .al-filters {
        grid-template-columns:repeat(2,minmax(0,1fr));
    }
    .el-audit-page .al-search {
        grid-column:1/-1;
    }
}

@media(max-width:650px) {
    .el-audit-page .al-header h1 {font-size:24px;}
    .el-audit-page .al-panel {padding:15px;}
    .el-audit-page .al-filters {
        grid-template-columns:1fr;
        padding:12px;
    }
    .el-audit-page .al-search {grid-column:auto;}
    .el-audit-page .al-actions .al-btn {flex:1;}
    .el-audit-page .al-footer {flex-direction:column;align-items:stretch;}
    .el-audit-page .al-pager {justify-content:space-between;}
}
</style>

<div class="el-audit-page">

    <!-- HEADER -->

    <header class="al-header">
        <div>
            <span class="al-eyebrow">
                ADMINISTRATION / SYSTEM MONITORING
            </span>

            <h1>Audit Logs</h1>

            <p>
                Review recorded system activity, including
                borrowing, payments, and archive actions.
            </p>
        </div>

        <span class="al-tag">Read-only Activity Records</span>
    </header>

    <!-- FILTER PANEL -->

    <section id="auditFilterSection" class="al-panel">

        <div class="al-panel-head">
            <div>
                <h2>Search Activity</h2>
                <p>
                    Narrow audit records by action, category,
                    date, or person.
                </p>
            </div>
        </div>

        <asp:Panel ID="pnlAuditFilters"
            runat="server"
            DefaultButton="btnApply">

            <div class="al-filters">

                <div class="al-field al-search">
                    <asp:Label runat="server"
                        AssociatedControlID="txtSearch"
                        Text="Search Logs" />

                    <asp:TextBox ID="txtSearch"
                        runat="server"
                        CssClass="al-input"
                        MaxLength="255"
                        autocomplete="off"
                        placeholder="User, book, ID, action..." />
                </div>

                <div class="al-field">
                    <asp:Label runat="server"
                        AssociatedControlID="ddlCategory"
                        Text="Category" />

                    <asp:DropDownList ID="ddlCategory"
                        runat="server" CssClass="al-input">
                        <asp:ListItem Text="All Categories" Value="" />
                        <asp:ListItem Text="Reservation" Value="Reservation" />
                        <asp:ListItem Text="Transaction" Value="Transaction" />
                        <asp:ListItem Text="Archive" Value="Archive" />
                        <asp:ListItem Text="Other" Value="Other" />
                    </asp:DropDownList>
                </div>

                <div class="al-field">
                    <asp:Label runat="server"
                        AssociatedControlID="ddlAction"
                        Text="Action" />

                    <asp:DropDownList ID="ddlAction"
                        runat="server" CssClass="al-input">
                        <asp:ListItem Text="All Actions" Value="" />
                        <asp:ListItem Text="Reservation Created" Value="Reservation Created%" />
                        <asp:ListItem Text="Collection Confirmed" Value="Collection Confirmed%" />
                        <asp:ListItem Text="Reservation Cancelled" Value="Reservation Cancelled%" />
                        <asp:ListItem Text="Book Returned" Value="Book Returned%" />
                        <asp:ListItem Text="Payment Processed" Value="Payment Processed%" />
                        <asp:ListItem Text="Book Archived" Value="Archived book:%" />
                        <asp:ListItem Text="Book Restored" Value="Restored book:%" />
                    </asp:DropDownList>
                </div>

                <div class="al-field">
                    <asp:Label runat="server"
                        AssociatedControlID="ddlSort"
                        Text="Sort By" />

                    <asp:DropDownList ID="ddlSort"
                        runat="server" CssClass="al-input">
                        <asp:ListItem Text="Newest First" Value="date-desc" />
                        <asp:ListItem Text="Oldest First" Value="date-asc" />
                        <asp:ListItem Text="Highest Log ID" Value="id-desc" />
                        <asp:ListItem Text="Lowest Log ID" Value="id-asc" />
                    </asp:DropDownList>
                </div>

                <div class="al-field">
                    <asp:Label runat="server"
                        AssociatedControlID="txtDateFrom"
                        Text="Date From" />

                    <asp:TextBox ID="txtDateFrom"
                        runat="server"
                        TextMode="Date"
                        CssClass="al-input" />
                </div>

                <div class="al-field">
                    <asp:Label runat="server"
                        AssociatedControlID="txtDateTo"
                        Text="Date To" />

                    <asp:TextBox ID="txtDateTo"
                        runat="server"
                        TextMode="Date"
                        CssClass="al-input" />
                </div>

                <div class="al-field">
                    <asp:Label runat="server"
                        AssociatedControlID="ddlPageSize"
                        Text="Records Per Page" />

                    <asp:DropDownList ID="ddlPageSize"
                        runat="server"
                        CssClass="al-input">
                        <asp:ListItem Text="10" Value="10" />
                        <asp:ListItem Text="20" Value="20" />
                        <asp:ListItem Text="50" Value="50" />
                    </asp:DropDownList>
                </div>

            </div>

            <div class="al-actions">
                <asp:Button ID="btnApply"
                    runat="server"
                    Text="Apply Filters"
                    CssClass="al-btn al-btn-primary"
                    CausesValidation="false"
                    OnClick="btnApply_Click" />

                <asp:Button ID="btnClear"
                    runat="server"
                    Text="Clear Filters"
                    CssClass="al-btn"
                    CausesValidation="false"
                    OnClick="btnClear_Click" />
            </div>

        </asp:Panel>

        <!-- VALIDATION AND SEARCH ERRORS APPEAR HERE -->

        <asp:Label ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="al-message"
            role="alert" />

    </section>

    <!-- AUDIT RECORDS -->

    <section class="al-panel">

        <div class="al-panel-head">
            <div>
                <h2>Activity History</h2>
                <p>
                    View who performed an action and which
                    library record it affected.
                </p>
            </div>

            <span class="al-tag">Audit Trail</span>
        </div>

        <div class="al-table-wrap">

            <asp:GridView ID="gvAuditLogs"
                runat="server"
                AutoGenerateColumns="False"
                GridLines="None"
                CssClass="al-table"
                ShowHeaderWhenEmpty="true"
                EmptyDataText="No audit records found.">

                <Columns>

                    <asp:BoundField
                        DataField="LogID"
                        HeaderText="Log ID" />

                    <asp:TemplateField HeaderText="Performed By">
                        <ItemTemplate>
                            <div class="al-actor">
                                <strong>
                                    <%#: Eval("FullName") %>
                                </strong>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Category">
                        <ItemTemplate>
                            <span class="al-category">
                                <%#: Eval("ActionCategory") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <span class="al-action-text">
                                <%#: Eval("ActionDesc") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField
                        DataField="BookID"
                        HeaderText="Book ID"
                        NullDisplayText="—" />

                    <asp:BoundField
                        DataField="Title"
                        HeaderText="Book"
                        NullDisplayText="—"
                        HtmlEncode="true" />

                    <asp:BoundField
                        DataField="BorrowLogID"
                        HeaderText="Borrow Log ID"
                        NullDisplayText="—" />

                    <asp:BoundField
                        DataField="ArchiveID"
                        HeaderText="Archive ID"
                        NullDisplayText="—" />

                    <asp:BoundField
                        DataField="TimeStamp"
                        HeaderText="Date / Time"
                        DataFormatString="{0:MMM dd, yyyy hh:mm tt}"
                        HtmlEncode="true" />

                </Columns>

                <EmptyDataRowStyle CssClass="al-empty" />

            </asp:GridView>

        </div>

        <!-- RECORD COUNT AND DATABASE PAGINATION -->

        <div class="al-footer">

            <asp:Label ID="lblRecords"
                runat="server"
                Text="0 record(s) found" />

            <div class="al-pager">

                <asp:Button ID="btnPrevious"
                    runat="server"
                    Text="← Previous"
                    CssClass="al-btn"
                    CausesValidation="false"
                    OnClick="btnPrevious_Click" />

                <asp:Label ID="lblPage"
                    runat="server"
                    Text="Page 1 of 1" />

                <asp:Button ID="btnNext"
                    runat="server"
                    Text="Next →"
                    CssClass="al-btn"
                    CausesValidation="false"
                    OnClick="btnNext_Click" />

            </div>

        </div>

    </section>

    <aside class="al-note">
        <strong>Audit records:</strong>
        These entries document recorded system activity.
        This page is intended for reviewing and filtering
        records, not changing or deleting them.
    </aside>

</div>

</asp:Content>
