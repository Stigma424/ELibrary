
<%@ Page Title="Manage Genres"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ManageGenres.aspx.cs"
    Inherits="ELibrary.Admin.Books.ManageGenres" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">
<style>
.el-admin-genres {
    --gn-primary:#123B4A;
    --gn-teal:#168A91;
    --gn-teal-hover:#12757C;
    --gn-muted:#647F89;
    --gn-border:#DCE9EB;
    --gn-soft:#F5FAFA;
    display:flex;
    flex-direction:column;
    gap:22px;
    color:var(--gn-primary);
}
.el-admin-genres * {box-sizing:border-box;}
.el-admin-genres .gn-header,
.el-admin-genres .gn-panel-head {
    display:flex;
    align-items:center;
    justify-content:space-between;
    flex-wrap:wrap;
    gap:14px;
}
.el-admin-genres .gn-eyebrow {
    color:var(--gn-teal);
    font-size:10px;
    letter-spacing:.12em;
    font-weight:800;
}
.el-admin-genres .gn-header h1 {
    color:var(--gn-primary);
    font-size:29px;
    font-weight:800;
    margin:7px 0;
}
.el-admin-genres .gn-header p,
.el-admin-genres .gn-panel-head p {
    font-size:12px;
    color:var(--gn-muted);
    margin:5px 0 0;
    line-height:1.6;
}
.el-admin-genres .gn-header-actions {
    display:flex;
    flex-wrap:wrap;
    gap:9px;
}
.el-admin-genres .gn-btn {
    display:inline-flex;
    align-items:center;
    justify-content:center;
    min-height:40px;
    padding:9px 15px;
    border:1px solid var(--gn-border);
    border-radius:9px;
    background:#FFFFFF;
    color:var(--gn-primary);
    font-size:12px;
    font-weight:750;
    cursor:pointer;
    text-decoration:none;
}
.el-admin-genres .gn-btn:hover {
    background:#EAF5F6;
    color:var(--gn-primary);
    border-color:#B4DADD;
}
.el-admin-genres .gn-btn-primary {
    color:#FFFFFF;
    background:var(--gn-teal);
    border-color:var(--gn-teal);
}
.el-admin-genres .gn-btn-primary:hover {
    color:#FFFFFF;
    background:var(--gn-teal-hover);
    border-color:var(--gn-teal-hover);
}
.el-admin-genres .gn-btn:disabled {
    opacity:.45;
    cursor:default;
}
.el-admin-genres .gn-panel {
    min-width:0;
    border:1px solid var(--gn-border);
    border-radius:14px;
    padding:23px;
    background:#FFFFFF;
    box-shadow:0 3px 14px rgba(18,59,74,.035);
    scroll-margin-top:95px;
}
.el-admin-genres .gn-panel-head {
    margin-bottom:19px;
}
.el-admin-genres .gn-panel-head h2 {
    font-size:18px;
    font-weight:800;
    margin:0;
    color:var(--gn-primary);
}
.el-admin-genres .gn-tag {
    padding:7px 11px;
    border-radius:8px;
    color:#126E73;
    background:#E9F6F6;
    font-size:11px;
    font-weight:750;
}
.el-admin-genres .gn-filters {
    display:grid;
    grid-template-columns:minmax(190px,2fr) minmax(160px,1fr) auto;
    align-items:end;
    gap:12px;
    padding:16px;
    border:1px solid var(--gn-border);
    border-radius:11px;
    background:var(--gn-soft);
}
.el-admin-genres .gn-field {min-width:0;}
.el-admin-genres .gn-field label {
    display:block;
    margin-bottom:7px;
    color:#375968;
    font-size:12px;
    font-weight:700;
}
.el-admin-genres .gn-field .form-control {
    display:block;
    width:100%;
    min-height:41px;
    padding:9px 12px;
    background:#FFFFFF;
    border:1px solid #CFE1E4;
    border-radius:8px;
    color:var(--gn-primary);
    font-size:12px;
}
.el-admin-genres .gn-field .form-control:focus {
    border-color:var(--gn-teal);
    outline:0;
    box-shadow:0 0 0 3px rgba(22,138,145,.12);
}
.el-admin-genres .gn-filter-actions {
    display:flex;
    gap:8px;
    align-items:center;
}
.el-admin-genres .gn-result-bar {
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:10px;
    flex-wrap:wrap;
    color:var(--gn-muted);
    font-size:12px;
    margin:15px 0 12px;
}
.el-admin-genres .gn-table-wrap {
    overflow-x:auto;
    border:1px solid var(--gn-border);
    border-radius:10px;
}
.el-admin-genres .gn-table {
    width:100%;
    min-width:620px;
    border-collapse:collapse;
    background:#FFFFFF;
    font-size:12px;
}
.el-admin-genres .gn-table th {
    padding:14px;
    background:var(--gn-soft);
    color:#496B75;
    border-bottom:1px solid var(--gn-border);
    font-size:11px;
    font-weight:800;
    text-align:left;
}
.el-admin-genres .gn-table td {
    padding:15px 14px;
    vertical-align:middle;
    color:#47616D;
    border-bottom:1px solid #EDF3F4;
    overflow-wrap:anywhere;
}
.el-admin-genres .gn-table tr:hover td {
    background:#F9FCFC;
}
.el-admin-genres .gn-row-actions {
    display:flex;
    flex-wrap:wrap;
    gap:7px;
}
.el-admin-genres .gn-row-action {
    display:inline-flex;
    padding:7px 11px;
    border:1px solid #CCE7E8;
    border-radius:7px;
    background:#E9F6F6;
    color:#126E73;
    font-size:11px;
    font-weight:750;
    text-decoration:none;
    white-space:nowrap;
}
.el-admin-genres .gn-row-action:hover {
    background:#DDF0F1;
    color:#0F6065;
}
.el-admin-genres .gn-row-action.danger {
    color:#B94E49;
    background:#FFF4F3;
    border-color:#F2D8D5;
}
.el-admin-genres .gn-row-action.danger:hover {
    background:#FBE7E5;
    color:#913D39;
}
.el-admin-genres .gn-pager {
    display:flex;
    justify-content:center;
    align-items:center;
    gap:12px;
    padding-top:19px;
    color:var(--gn-muted);
    font-size:12px;
}
.el-admin-genres .gn-form-grid {
    display:grid;
    grid-template-columns:repeat(2,minmax(0,1fr));
    gap:16px;
}
.el-admin-genres .gn-full {grid-column:1/-1;}
.el-admin-genres .gn-form-grid textarea {
    min-height:105px;
    resize:vertical;
}
.el-admin-genres .gn-form-actions {
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:15px;
    flex-wrap:wrap;
    margin-top:20px;
    padding-top:20px;
    border-top:1px solid #EDF3F4;
}
.el-admin-genres .gn-form-buttons {
    display:flex;
    gap:9px;
    flex-wrap:wrap;
}
.el-admin-genres .gn-note {
    font-size:11px;
    color:var(--gn-muted);
    line-height:1.6;
}
.el-admin-genres .gn-message {
    display:block;
    margin-bottom:16px;
    font-size:12px;
    line-height:1.7;
    scroll-margin-top:100px;
}
.el-admin-genres .gn-message:empty {display:none;}
.el-admin-genres .gn-message.success {
    padding:13px 16px;
    background:#E9F7F1;
    border:1px solid #C8E8D7;
    border-left:4px solid #28845B;
    border-radius:8px;
    color:#236747;
}
.el-admin-genres .gn-message.error {
    padding:13px 16px;
    background:#FFF0EF;
    border:1px solid #F2D3CF;
    border-left:4px solid #C34D46;
    border-radius:8px;
    color:#9E3E39;
}
@media(max-width:850px) {
    .el-admin-genres .gn-filters {
        grid-template-columns:repeat(2,minmax(0,1fr));
    }
    .el-admin-genres .gn-filter-actions {
        grid-column:1/-1;
    }
}
@media(max-width:600px) {
    .el-admin-genres .gn-header h1 {font-size:24px;}
    .el-admin-genres .gn-panel {padding:15px;}
    .el-admin-genres .gn-filters,
    .el-admin-genres .gn-form-grid {
        grid-template-columns:1fr;
    }
    .el-admin-genres .gn-filter-actions,
    .el-admin-genres .gn-full {grid-column:auto;}
    .el-admin-genres .gn-header-actions,
    .el-admin-genres .gn-form-buttons {width:100%;}
    .el-admin-genres .gn-header-actions .gn-btn,
    .el-admin-genres .gn-form-buttons .gn-btn {flex:1;}
}
</style>
</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="el-admin-genres">

    <header class="gn-header">
        <div>
            <span class="gn-eyebrow">
                ADMINISTRATION / LIBRARY MANAGEMENT
            </span>
            <h1>Manage Genres</h1>
            <p>
                Maintain the categories used to organize
                the library collection.
            </p>
        </div>

        <div class="gn-header-actions">
            <asp:HyperLink
                runat="server"
                NavigateUrl="~/Admin/Books/ManageBooks.aspx"
                CssClass="gn-btn"
                Text="← Manage Books" />

            <asp:Button
                ID="btnCreateGenre"
                runat="server"
                Text="+ Add Genre"
                CssClass="gn-btn gn-btn-primary"
                CausesValidation="false"
                OnClick="btnCreateGenre_Click" />
        </div>
    </header>

    <!-- GENRE CATALOG -->
    <section id="genreCatalog" class="gn-panel">
        <div class="gn-panel-head">
            <div>
                <h2>Genre Catalog</h2>
                <p>Search, organize, edit, or delete existing genres.</p>
            </div>
            <span class="gn-tag">Catalog Categories</span>
        </div>

        <!-- LOCAL CATALOG MESSAGE -->
        <asp:Label
            ID="lblListMessage"
            runat="server"
            EnableViewState="false"
            CssClass="gn-message"
            role="status"
            aria-live="polite" />

        <asp:Panel
            ID="pnlGenreFilters"
            runat="server"
            DefaultButton="btnApply"
            CssClass="gn-filters">

            <div class="gn-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="txtSearch"
                    Text="Search Genres" />
                <asp:TextBox
                    ID="txtSearch"
                    runat="server"
                    CssClass="form-control"
                    MaxLength="255"
                    placeholder="Search ID, name, or description..."
                    autocomplete="off" />
            </div>

            <div class="gn-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="ddlSort"
                    Text="Sort By" />
                <asp:DropDownList
                    ID="ddlSort"
                    runat="server"
                    CssClass="form-control">
                    <asp:ListItem Text="Default Order" Value="Default" />
                    <asp:ListItem Text="Genre Name (A–Z)" Value="NameAsc" />
                    <asp:ListItem Text="Genre Name (Z–A)" Value="NameDesc" />
                    <asp:ListItem Text="ID (Lowest First)" Value="IDAsc" />
                    <asp:ListItem Text="ID (Highest First)" Value="IDDesc" />
                </asp:DropDownList>
            </div>

            <div class="gn-filter-actions">
                <asp:Button
                    ID="btnApply"
                    runat="server"
                    Text="Apply"
                    CssClass="gn-btn gn-btn-primary"
                    CausesValidation="false"
                    OnClick="btnApply_Click" />
                <asp:Button
                    ID="btnClearFilters"
                    runat="server"
                    Text="Clear"
                    CssClass="gn-btn"
                    CausesValidation="false"
                    OnClick="btnClearFilters_Click" />
            </div>
        </asp:Panel>

        <div class="gn-result-bar">
            <asp:Label
                ID="lblResultCount"
                runat="server"
                Text="Showing genres" />
            <span>Press Enter or Apply to search.</span>
        </div>

        <div class="gn-table-wrap">
            <asp:GridView
                ID="gvGenres"
                runat="server"
                AutoGenerateColumns="False"
                CssClass="gn-table"
                GridLines="None"
                EmptyDataText="No genres match your search."
                OnRowCommand="gvGenres_RowCommand">
                <Columns>
                    <asp:BoundField
                        DataField="GenreID"
                        HeaderText="ID" />
                    <asp:TemplateField HeaderText="Genre Name">
                        <ItemTemplate>
                            <strong><%#: Eval("GenreName") %></strong>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField
                        DataField="GenreDesc"
                        HeaderText="Description" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="gn-row-actions">
                                <asp:LinkButton
                                    ID="btnEdit"
                                    runat="server"
                                    Text="Edit"
                                    CssClass="gn-row-action"
                                    CommandName="EditGenre"
                                    CommandArgument='<%# Eval("GenreID") %>'
                                    CausesValidation="false" />

                                <asp:LinkButton
                                    ID="btnDelete"
                                    runat="server"
                                    Text="Delete"
                                    CssClass="gn-row-action danger"
                                    CommandName="DeleteGenre"
                                    CommandArgument='<%# Eval("GenreID") %>'
                                    CausesValidation="false"
                                    OnClientClick="return confirm('Delete this genre? Genres currently in use may not be removable.');" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <div class="gn-pager">
            <asp:Button
                ID="btnPrevious"
                runat="server"
                Text="← Previous"
                CssClass="gn-btn"
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
                CssClass="gn-btn"
                CausesValidation="false"
                OnClick="btnNext_Click" />
        </div>
    </section>

    <!-- EDITOR: ONLY RENDERED WHEN OPENED -->
    <asp:Panel
        ID="pnlGenreEditor"
        runat="server"
        Visible="false"
        ClientIDMode="Static"
        CssClass="gn-panel">

        <div class="gn-panel-head">
            <div>
                <h2>
                    <asp:Label
                        ID="lblEditorTitle"
                        runat="server"
                        Text="Add New Genre" />
                </h2>
                <p>Add a category or update an existing one.</p>
            </div>
            <span class="gn-tag">Genre Information</span>
        </div>

        <!-- LOCAL FORM MESSAGE -->
        <asp:Label
            ID="lblEditorMessage"
            runat="server"
            EnableViewState="false"
            CssClass="gn-message"
            role="status"
            aria-live="polite" />

        <asp:HiddenField
            ID="hfGenreID"
            runat="server"
            Value="0" />

        <div class="gn-form-grid">
            <div class="gn-field">
                <label for="<%= txtGenreName.ClientID %>">
                    Genre Name *
                </label>
                <asp:TextBox
                    ID="txtGenreName"
                    runat="server"
                    CssClass="form-control"
                    MaxLength="100"
                    placeholder="e.g. Science Fiction" />
            </div>

            <div class="gn-field gn-full">
                <label for="<%= txtGenreDesc.ClientID %>">
                    Genre Description *
                </label>
                <asp:TextBox
                    ID="txtGenreDesc"
                    runat="server"
                    CssClass="form-control"
                    TextMode="MultiLine"
                    Rows="3"
                    MaxLength="255"
                    placeholder="Briefly describe this genre" />
            </div>
        </div>

        <div class="gn-form-actions">
            <span class="gn-note">
                Fields marked * are required.
            </span>
            <div class="gn-form-buttons">
                <asp:Button
                    ID="btnCancel"
                    runat="server"
                    Text="Clear Form"
                    CssClass="gn-btn"
                    CausesValidation="false"
                    OnClick="btnCancel_Click" />
                <asp:Button
                    ID="btnCloseEditor"
                    runat="server"
                    Text="Close"
                    CssClass="gn-btn"
                    CausesValidation="false"
                    OnClick="btnCloseEditor_Click" />
                <asp:Button
                    ID="btnSave"
                    runat="server"
                    Text="Save Genre"
                    CssClass="gn-btn gn-btn-primary"
                    CausesValidation="false"
                    OnClick="btnSave_Click" />
            </div>
        </div>
    </asp:Panel>
</div>

<asp:HiddenField
    ID="hfFocusTarget"
    runat="server"
    ClientIDMode="Static" />

<script type="text/javascript">
    (function () {
        var focus = document.getElementById('hfFocusTarget');
        if (!focus || !focus.value) return;

        var target = document.getElementById(focus.value);
        if (!target) return;

        requestAnimationFrame(function () {
            target.scrollIntoView({
                behavior: window.matchMedia(
                    '(prefers-reduced-motion: reduce)').matches
                    ? 'auto' : 'smooth',
                block: 'start'
            });
        });
    })();
</script>
</asp:Content>
