
<%@ Page Title="Archived Books"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ArchiveBooks.aspx.cs"
    Inherits="ELibrary.Admin.Archive.ArchiveBooks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent"
    runat="server">

<style>
/* ============================================
   INTERNSHIPELIB - OCEAN TEAL
   UI-4A ARCHIVED BOOKS
============================================ */

.el-archive {
    --ar-primary:#123B4A;
    --ar-accent:#168A91;
    --ar-hover:#12757C;
    --ar-muted:#647F89;
    --ar-border:#DCE9EB;
    --ar-soft:#F5FAFA;

    display:flex;
    flex-direction:column;
    gap:21px;
    min-width:0;
    padding-bottom:30px;
    color:var(--ar-primary);
}

.el-archive *,
.el-archive *::before,
.el-archive *::after {
    box-sizing:border-box;
}

.el-archive .ar-header {
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:16px;
    flex-wrap:wrap;
}

.el-archive .ar-eyebrow {
    display:block;
    margin-bottom:8px;
    font-size:10px;
    font-weight:800;
    letter-spacing:.12em;
    color:var(--ar-accent);
}

.el-archive .ar-header h1 {
    margin:0 0 7px;
    color:var(--ar-primary);
    font-size:29px;
    font-weight:800;
}

.el-archive .ar-header p,
.el-archive .ar-panel-head p {
    margin:0;
    color:var(--ar-muted);
    font-size:12px;
    line-height:1.7;
}

.el-archive .ar-header-actions {
    display:flex;
    align-items:center;
    gap:9px;
    flex-wrap:wrap;
}

.el-archive .ar-btn {
    display:inline-flex;
    align-items:center;
    justify-content:center;
    min-height:40px;
    padding:9px 15px;
    background:#FFFFFF;
    border:1px solid var(--ar-border);
    border-radius:9px;
    color:var(--ar-primary);
    font-size:12px;
    font-weight:750;
    text-decoration:none;
    cursor:pointer;
    white-space:nowrap;
}

.el-archive .ar-btn:hover {
    color:var(--ar-primary);
    background:#EAF5F6;
    border-color:#B4DADD;
    text-decoration:none;
}

.el-archive .ar-btn.primary {
    color:#FFFFFF;
    background:var(--ar-accent);
    border-color:var(--ar-accent);
}

.el-archive .ar-btn.primary:hover {
    color:#FFFFFF;
    background:var(--ar-hover);
    border-color:var(--ar-hover);
}

.el-archive .ar-btn:disabled {
    opacity:.45;
    cursor:default;
}

.el-archive .ar-panel {
    min-width:0;
    padding:23px;
    background:#FFFFFF;
    border:1px solid var(--ar-border);
    border-radius:14px;
    box-shadow:0 3px 14px rgba(18,59,74,.035);
    scroll-margin-top:95px;
}

.el-archive .ar-panel-head {
    display:flex;
    align-items:flex-start;
    justify-content:space-between;
    flex-wrap:wrap;
    gap:14px;
    margin-bottom:20px;
}

.el-archive .ar-panel-head h2 {
    margin:0 0 6px;
    color:var(--ar-primary);
    font-size:18px;
    font-weight:800;
}

.el-archive .ar-tag {
    display:inline-flex;
    align-items:center;
    padding:7px 11px;
    background:#E9F6F6;
    border-radius:8px;
    color:#126E73;
    font-size:11px;
    font-weight:750;
}

.el-archive .ar-filters {
    display:grid;
    grid-template-columns:
        minmax(200px,2fr)
        repeat(2,minmax(145px,1fr))
        auto;
    gap:12px;
    align-items:end;
    padding:16px;
    background:var(--ar-soft);
    border:1px solid var(--ar-border);
    border-radius:11px;
}

.el-archive .ar-field {
    min-width:0;
}

.el-archive .ar-field label {
    display:block;
    margin-bottom:7px;
    color:#375968;
    font-size:12px;
    font-weight:700;
}

.el-archive .ar-field input,
.el-archive .ar-field select {
    display:block;
    width:100%;
    min-height:41px;
    padding:9px 12px;
    color:var(--ar-primary);
    font-size:12px;
    background:#FFFFFF;
    border:1px solid #CFE1E4;
    border-radius:8px;
}

.el-archive .ar-field input:focus,
.el-archive .ar-field select:focus {
    outline:none;
    border-color:var(--ar-accent);
    box-shadow:0 0 0 3px rgba(22,138,145,.12);
}

.el-archive .ar-filter-actions {
    display:flex;
    align-items:center;
    flex-wrap:wrap;
    gap:8px;
}

.el-archive .ar-result-bar {
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:12px;
    flex-wrap:wrap;
    margin:16px 0 13px;
    color:var(--ar-muted);
    font-size:12px;
}

.el-archive .ar-message {
    display:block;
    margin:16px 0;
    font-size:12px;
    line-height:1.7;
}

.el-archive .ar-message:empty {
    display:none;
}

/* The existing code-behind sets text-success or text-danger. */

.el-archive .ar-message.text-success {
    padding:13px 16px;
    background:#E9F7F1;
    border:1px solid #C8E8D7;
    border-left:4px solid #28845B;
    border-radius:9px;
    color:#236747 !important;
}

.el-archive .ar-message.text-danger {
    padding:13px 16px;
    background:#FFF0EF;
    border:1px solid #F2D3CF;
    border-left:4px solid #C34D46;
    border-radius:9px;
    color:#9E3E39 !important;
}

.el-archive .ar-table-wrap {
    width:100%;
    overflow-x:auto;
    border:1px solid var(--ar-border);
    border-radius:10px;
    -webkit-overflow-scrolling:touch;
}

.el-archive .ar-table {
    width:100%;
    min-width:830px;
    border-collapse:collapse;
    background:#FFFFFF;
    font-size:12px;
}

.el-archive .ar-table th {
    padding:14px 12px;
    background:var(--ar-soft);
    color:#496B75;
    border-bottom:1px solid var(--ar-border);
    font-size:11px;
    font-weight:800;
    text-align:left;
    white-space:nowrap;
}

.el-archive .ar-table td {
    padding:14px 12px;
    color:#47616D;
    border-bottom:1px solid #EDF3F4;
    vertical-align:middle;
}

.el-archive .ar-table tr:hover td {
    background:#F9FCFC;
}

.el-archive .ar-record {
    display:flex;
    flex-direction:column;
    gap:5px;
    min-width:130px;
}

.el-archive .ar-record strong {
    color:var(--ar-primary);
    font-size:12px;
    font-weight:800;
    overflow-wrap:anywhere;
}

.el-archive .ar-record small {
    color:var(--ar-muted);
    font-size:11px;
    overflow-wrap:anywhere;
}

.el-archive .ar-reason {
    display:block;
    max-width:310px;
    line-height:1.6;
    overflow-wrap:anywhere;
}

.el-archive .ar-restore {
    display:inline-flex;
    align-items:center;
    justify-content:center;
    min-height:34px;
    padding:7px 12px;
    background:#E6F6EE;
    color:#237C62;
    border:1px solid #C8E8D7;
    border-radius:8px;
    font-size:11px;
    font-weight:750;
    white-space:nowrap;
    cursor:pointer;
}

.el-archive .ar-restore:hover {
    color:#185840;
    background:#D7F0E4;
}

.el-archive .ar-pager {
    display:flex;
    justify-content:center;
    align-items:center;
    gap:12px;
    flex-wrap:wrap;
    padding-top:19px;
    color:var(--ar-muted);
    font-size:12px;
}

.el-archive .ar-info {
    padding:16px 18px;
    background:#EAF6F6;
    border:1px solid #D2E7E8;
    border-radius:10px;
    color:#315D67;
    font-size:12px;
    line-height:1.8;
}

.el-archive .ar-info strong {
    color:var(--ar-primary);
}

@media(max-width:1100px) {
    .el-archive .ar-filters {
        grid-template-columns:repeat(2,minmax(0,1fr));
    }
    .el-archive .ar-search,
    .el-archive .ar-filter-actions {
        grid-column:1/-1;
    }
}

@media(max-width:650px) {
    .el-archive .ar-header h1 {font-size:24px;}
    .el-archive .ar-panel {padding:15px;}
    .el-archive .ar-filters {
        grid-template-columns:1fr;
        padding:12px;
    }
    .el-archive .ar-search,
    .el-archive .ar-filter-actions {
        grid-column:auto;
    }
    .el-archive .ar-header-actions,
    .el-archive .ar-filter-actions {width:100%;}
    .el-archive .ar-header-actions .ar-btn,
    .el-archive .ar-filter-actions .ar-btn {flex:1;}
}
</style>

<div class="el-archive">

    <!-- PAGE HEADER -->

    <header class="ar-header">
        <div>
            <span class="ar-eyebrow">
                ADMINISTRATION / LIBRARY ARCHIVE
            </span>

            <h1>Archived Books</h1>

            <p>
                Find archived books and restore eligible
                titles to the active collection.
            </p>
        </div>

        <div class="ar-header-actions">
            <asp:HyperLink runat="server"
                NavigateUrl="~/Admin/Books/ManageBooks.aspx"
                CssClass="ar-btn"
                Text="← Manage Books" />

            <asp:Button ID="btnRefresh" runat="server"
                Text="↻ Refresh"
                CssClass="ar-btn primary"
                CausesValidation="false"
                OnClick="btnRefresh_Click" />
        </div>
    </header>

    <!-- ARCHIVE CATALOG -->

    <section id="archiveRecords" class="ar-panel">

        <div class="ar-panel-head">
            <div>
                <h2>Archived Book Records</h2>
                <p>
                    Search by book, ISBN, or archive reason.
                    Restore a book using its row action.
                </p>
            </div>

            <span class="ar-tag">Archived Collection</span>
        </div>

        <!-- SEARCH / FILTER PANEL -->

        <asp:Panel ID="pnlArchiveFilters"
            runat="server"
            DefaultButton="btnApply"
            CssClass="ar-filters">

            <div class="ar-field ar-search">
                <asp:Label runat="server"
                    AssociatedControlID="txtSearch"
                    Text="Search Archived Books" />

                <asp:TextBox ID="txtSearch"
                    runat="server"
                    MaxLength="255"
                    autocomplete="off"
                    placeholder="Book ID, title, ISBN, reason..." />
            </div>

            <div class="ar-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlReason"
                    Text="Archive Reason" />

                <asp:DropDownList ID="ddlReason"
                    runat="server">
                    <asp:ListItem Text="All Reasons" Value="" />
                </asp:DropDownList>
            </div>

            <div class="ar-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlSort"
                    Text="Sort By" />

                <asp:DropDownList ID="ddlSort" runat="server">
                    <asp:ListItem Text="Default Order" Value="Default" />
                    <asp:ListItem Text="Recently Archived" Value="DateDesc" />
                    <asp:ListItem Text="Oldest Archived" Value="DateAsc" />
                    <asp:ListItem Text="Highest Archive ID" Value="IDDesc" />
                    <asp:ListItem Text="Lowest Archive ID" Value="IDAsc" />
                    <asp:ListItem Text="Title (A–Z)" Value="TitleAsc" />
                    <asp:ListItem Text="Title (Z–A)" Value="TitleDesc" />
                </asp:DropDownList>
            </div>

            <div class="ar-filter-actions">
                <asp:Button ID="btnApply"
                    runat="server"
                    Text="Apply"
                    CssClass="ar-btn primary"
                    CausesValidation="false"
                    OnClick="btnApply_Click" />

                <asp:Button ID="btnClearFilters"
                    runat="server"
                    Text="Clear"
                    CssClass="ar-btn"
                    CausesValidation="false"
                    OnClick="btnClearFilters_Click" />
            </div>

        </asp:Panel>

        <!-- FEEDBACK NEAR SEARCH AND RESTORE ACTIONS -->

        <asp:Label ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="ar-message"
            role="status"
            aria-live="polite" />

        <div class="ar-result-bar">
            <asp:Label ID="lblResultCount"
                runat="server"
                Text="Showing archived books" />

            <span>Press Enter or Apply to search.</span>
        </div>

        <!-- ARCHIVED BOOK LIST -->

        <div class="ar-table-wrap">

            <asp:GridView ID="gvArchivedBooks"
                runat="server"
                AutoGenerateColumns="False"
                GridLines="None"
                CssClass="ar-table"
                EmptyDataText="No archived books match your filters."
                OnRowCommand="gvArchivedBooks_RowCommand">

                <Columns>

                    <asp:BoundField
                        DataField="ArchiveID"
                        HeaderText="Archive ID" />

                    <asp:BoundField
                        DataField="BookID"
                        HeaderText="Book ID" />

                    <asp:TemplateField HeaderText="Book">
                        <ItemTemplate>
                            <div class="ar-record">
                                <strong><%#: Eval("Title") %></strong>
                                <small>ISBN: <%#: Eval("ISBN") %></small>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Archive Reason">
                        <ItemTemplate>
                            <span class="ar-reason">
                                <%#: Eval("Reason") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField
                        DataField="ArchivedDate"
                        HeaderText="Archived Date"
                        DataFormatString="{0:MMM dd, yyyy hh:mm tt}" />

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:Button ID="btnRestore"
                                runat="server"
                                Text="Restore Book"
                                CssClass="ar-restore"
                                CommandName="RestoreBook"
                                CommandArgument='<%# Eval("ArchiveID") %>'
                                CausesValidation="false"
                                OnClientClick="return confirm('Restore this book to the library catalog?');" />
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

            </asp:GridView>

        </div>

        <div class="ar-pager">
            <asp:Button ID="btnPrevious"
                runat="server"
                Text="← Previous"
                CssClass="ar-btn"
                CausesValidation="false"
                OnClick="btnPrevious_Click" />

            <asp:Label ID="lblPageInfo"
                runat="server"
                Text="Page 1 of 1" />

            <asp:Button ID="btnNext"
                runat="server"
                Text="Next →"
                CssClass="ar-btn"
                CausesValidation="false"
                OnClick="btnNext_Click" />
        </div>

    </section>

    <aside class="ar-info">
        <strong>Restoring books:</strong>
        Restoration is handled by your existing database
        procedure. Once restored, the book is removed from
        the archived results and becomes available through
        the active book catalog, subject to its inventory status.
    </aside>

</div>

</asp:Content>
