
<%@ Page Title="Manage Books"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ManageBooks.aspx.cs"
    Inherits="ELibrary.Admin.Books.ManageBooks" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* ==========================================
   OCEAN TEAL - ADMIN MANAGE BOOKS
========================================== */

.el-admin-books {
    --bk-primary: #123B4A;
    --bk-accent: #168A91;
    --bk-hover: #12757C;
    --bk-border: #DCE9EB;
    --bk-muted: #647F89;
    --bk-soft: #F5FAFA;
    --bk-danger: #B94E49;

    display: flex;
    flex-direction: column;
    gap: 22px;
    color: var(--bk-primary);
}

.el-admin-books * {
    box-sizing: border-box;
}

.el-admin-books .bk-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
    padding: 4px 0;
}

.el-admin-books .bk-eyebrow {
    display: block;
    color: var(--bk-accent);
    font-size: 10px;
    font-weight: 800;
    letter-spacing: .12em;
    margin-bottom: 8px;
}

.el-admin-books .bk-header h1 {
    margin: 0 0 7px;
    color: var(--bk-primary);
    font-size: 29px;
    font-weight: 800;
}

.el-admin-books .bk-header p,
.el-admin-books .bk-panel-head p {
    margin: 0;
    color: var(--bk-muted);
    font-size: 12px;
    line-height: 1.7;
}

.el-admin-books .bk-header-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 9px;
}

.el-admin-books .bk-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 40px;
    padding: 9px 16px;
    background: #FFFFFF;
    color: var(--bk-primary);
    border: 1px solid var(--bk-border);
    border-radius: 9px;
    text-decoration: none;
    font-size: 12px;
    font-weight: 750;
    cursor: pointer;
    transition: background .2s, border-color .2s;
}

.el-admin-books .bk-btn:hover {
    background: #EAF5F6;
    color: var(--bk-primary);
    border-color: #B4DADD;
}

.el-admin-books .bk-btn-primary {
    background: var(--bk-accent);
    color: #FFFFFF;
    border-color: var(--bk-accent);
}

.el-admin-books .bk-btn-primary:hover {
    background: var(--bk-hover);
    border-color: var(--bk-hover);
    color: #FFFFFF;
}

.el-admin-books .bk-btn-danger {
    color: var(--bk-danger);
    background: #FFF6F5;
    border-color: #F1D8D5;
}

.el-admin-books .bk-btn-danger:hover {
    color: #913D39;
    background: #FCEAE8;
}

.el-admin-books .bk-panel {
    min-width: 0;
    background: #FFFFFF;
    border: 1px solid var(--bk-border);
    border-radius: 14px;
    padding: 23px;
    box-shadow: 0 3px 14px rgba(18,59,74,.035);
    scroll-margin-top: 95px;
}

.el-admin-books .bk-panel-head {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
    margin-bottom: 20px;
}

.el-admin-books .bk-panel-head h2 {
    margin: 0 0 5px;
    font-size: 18px;
    font-weight: 800;
    color: var(--bk-primary);
}

.el-admin-books .bk-tag {
    display: inline-block;
    padding: 7px 11px;
    color: #126E73;
    background: #E9F6F6;
    border-radius: 7px;
    font-size: 11px;
    font-weight: 700;
}

.el-admin-books .bk-filters {
    display: grid;
    grid-template-columns:
        minmax(190px, 2fr)
        repeat(3, minmax(115px, 1fr))
        auto;
    align-items: end;
    gap: 12px;
    padding: 16px;
    border: 1px solid var(--bk-border);
    border-radius: 11px;
    background: var(--bk-soft);
}

.el-admin-books .bk-field {
    min-width: 0;
}

.el-admin-books .bk-field label {
    display: block;
    margin-bottom: 7px;
    color: #375968;
    font-size: 12px;
    font-weight: 700;
}

.el-admin-books .bk-field .form-control {
    display: block;
    width: 100%;
    min-height: 41px;
    padding: 9px 12px;
    color: var(--bk-primary);
    background: #FFFFFF;
    border: 1px solid #CFE1E4;
    border-radius: 8px;
    font-size: 12px;
}

.el-admin-books .bk-field .form-control:focus {
    outline: none;
    border-color: var(--bk-accent);
    box-shadow: 0 0 0 3px rgba(22,138,145,.12);
}

.el-admin-books .bk-filter-actions {
    display: flex;
    align-items: center;
    gap: 7px;
}

.el-admin-books .bk-result-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;
    margin: 16px 0 13px;
    color: var(--bk-muted);
    font-size: 12px;
}

.el-admin-books .bk-table-wrap {
    width: 100%;
    overflow-x: auto;
    border: 1px solid var(--bk-border);
    border-radius: 10px;
}

.el-admin-books .bk-table {
    width: 100%;
    min-width: 820px;
    border-collapse: collapse;
    background: #FFFFFF;
    font-size: 12px;
}

.el-admin-books .bk-table th {
    padding: 14px 13px;
    color: #496B75;
    background: var(--bk-soft);
    border-bottom: 1px solid var(--bk-border);
    font-size: 11px;
    font-weight: 800;
    text-align: left;
    white-space: nowrap;
}

.el-admin-books .bk-table td {
    padding: 14px 13px;
    color: #47616D;
    vertical-align: middle;
    border-bottom: 1px solid #EDF3F4;
}

.el-admin-books .bk-table tr:hover td {
    background: #F9FCFC;
}

.el-admin-books .bk-book-cell {
    display: flex;
    align-items: center;
    gap: 12px;
    min-width: 180px;
}

.el-admin-books .bk-book-thumb {
    width: 43px;
    height: 59px;
    flex-shrink: 0;
    border: 1px solid var(--bk-border);
    border-radius: 5px;
    object-fit: cover;
    background: #EAF3F3;
}

.el-admin-books .bk-book-info {
    display: flex;
    flex-direction: column;
    gap: 4px;
    min-width: 0;
}

.el-admin-books .bk-book-info strong {
    color: var(--bk-primary);
    font-size: 12px;
    font-weight: 800;
    overflow-wrap: anywhere;
}

.el-admin-books .bk-book-info small {
    color: var(--bk-muted);
    font-size: 11px;
}

.el-admin-books .bk-row-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 7px;
}

.el-admin-books .bk-row-action {
    display: inline-flex;
    padding: 7px 10px;
    color: #126E73;
    background: #E9F6F6;
    border: 1px solid #CCE7E8;
    border-radius: 7px;
    font-size: 11px;
    font-weight: 750;
    text-decoration: none;
    white-space: nowrap;
}

.el-admin-books .bk-row-action:hover {
    color: #0F6065;
    background: #DDF0F1;
}

.el-admin-books .bk-row-action.danger {
    color: var(--bk-danger);
    background: #FFF4F3;
    border-color: #F2D8D5;
}

.el-admin-books .bk-pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 14px;
    padding: 20px 0 0;
    color: var(--bk-muted);
    font-size: 12px;
}

/* LOCAL SUCCESS / ERROR MESSAGES */

.el-admin-books .bk-message {
    display: block;
    margin-bottom: 16px;
    font-size: 12px;
    line-height: 1.7;
    scroll-margin-top: 110px;
}

.el-admin-books .bk-message:empty {
    display: none;
}

.el-admin-books .bk-message.success {
    padding: 13px 16px;
    background: #E9F7F1;
    border: 1px solid #C8E8D7;
    border-left: 4px solid #28845B;
    border-radius: 8px;
    color: #236747;
}

.el-admin-books .bk-message.error {
    padding: 13px 16px;
    background: #FFF0EF;
    border: 1px solid #F2D3CF;
    border-left: 4px solid #C34D46;
    border-radius: 8px;
    color: #9E3E39;
}

/* EDITOR */

.el-admin-books .bk-editor-layout {
    display: grid;
    grid-template-columns: minmax(0, 1fr) 245px;
    gap: 24px;
    align-items: start;
}

.el-admin-books .bk-form-grid,
.el-admin-books .bk-loss-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 17px;
}

.el-admin-books .bk-full {
    grid-column: 1 / -1;
}

.el-admin-books .bk-field textarea.form-control {
    min-height: 95px;
    resize: vertical;
}

.el-admin-books .bk-help {
    display: block;
    margin-top: 7px;
    font-size: 11px;
    line-height: 1.6;
    color: var(--bk-muted);
}

.el-admin-books .bk-cover-panel {
    padding: 18px;
    border: 1px solid var(--bk-border);
    border-radius: 11px;
    background: var(--bk-soft);
}

.el-admin-books .bk-cover-panel h3 {
    font-size: 14px;
    font-weight: 800;
    color: var(--bk-primary);
}

.el-admin-books .bk-cover-box {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 195px;
    margin: 16px 0;
    padding: 15px;
    border: 1px dashed #BCD6D9;
    border-radius: 9px;
    background: #FFFFFF;
}

.el-admin-books .bk-cover-preview {
    max-width: 100%;
    height: 165px;
    object-fit: contain;
}

.el-admin-books .bk-form-footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 15px;
    padding-top: 20px;
    margin-top: 22px;
    border-top: 1px solid #EDF3F4;
}

.el-admin-books .bk-button-group {
    display: flex;
    flex-wrap: wrap;
    gap: 9px;
}

.el-admin-books .bk-loss-summary {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 10px;
    margin: 12px 0 20px;
}

.el-admin-books .bk-loss-stat {
    padding: 15px;
    background: var(--bk-soft);
    border: 1px solid var(--bk-border);
    border-radius: 9px;
}

.el-admin-books .bk-loss-stat small {
    display: block;
    margin-bottom: 8px;
    color: var(--bk-muted);
    font-size: 11px;
}

.el-admin-books .bk-loss-stat strong {
    font-size: 21px;
    color: var(--bk-primary);
}

.el-admin-books .bk-warning {
    padding: 13px 15px;
    margin: 16px 0;
    border: 1px solid #F2D9C0;
    border-radius: 9px;
    background: #FFF8EF;
    color: #875C29;
    font-size: 12px;
    line-height: 1.7;
}

.el-admin-books .bk-history-filters {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
    margin-bottom: 15px;
}

.el-admin-books .bk-history-filters .form-control {
    flex: 1;
    min-width: 200px;
    min-height: 40px;
}

/* RESPONSIVE */

@media (max-width: 1250px) {
    .el-admin-books .bk-filters {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .el-admin-books .bk-search-field {
        grid-column: 1 / -1;
    }
}

@media (max-width: 900px) {
    .el-admin-books .bk-editor-layout {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 650px) {
    .el-admin-books .bk-header h1 {
        font-size: 24px;
    }

    .el-admin-books .bk-panel {
        padding: 15px;
    }

    .el-admin-books .bk-filters,
    .el-admin-books .bk-form-grid,
    .el-admin-books .bk-loss-grid,
    .el-admin-books .bk-loss-summary {
        grid-template-columns: 1fr;
    }

    .el-admin-books .bk-search-field {
        grid-column: auto;
    }

    .el-admin-books .bk-full {
        grid-column: auto;
    }

    .el-admin-books .bk-filter-actions,
    .el-admin-books .bk-form-footer {
        align-items: stretch;
        flex-direction: column;
    }

    .el-admin-books .bk-filter-actions .bk-btn {
        flex: 1;
    }

    .el-admin-books .bk-header-actions {
        width: 100%;
    }

    .el-admin-books .bk-header-actions .bk-btn {
        flex: 1;
    }

    .el-admin-books .bk-button-group,
    .el-admin-books .bk-button-group .bk-btn {
        width: 100%;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="el-admin-books">

    <!-- HEADER -->

    <header class="bk-header">
        <div>
            <span class="bk-eyebrow">
                ADMINISTRATION / LIBRARY MANAGEMENT
            </span>

            <h1>Manage Books</h1>

            <p>
                Organize your catalog, manage stock,
                and maintain accurate book records.
            </p>
        </div>

        <div class="bk-header-actions">

            <asp:HyperLink
                runat="server"
                NavigateUrl="~/Admin/Books/ManageGenres.aspx"
                CssClass="bk-btn"
                Text="Manage Genres" />

            <asp:Button
                ID="btnCreateBook"
                runat="server"
                Text="+ Add Book"
                CssClass="bk-btn bk-btn-primary"
                CausesValidation="false"
                OnClick="btnCreateBook_Click" />

        </div>
    </header>

    <!-- BOOK CATALOG -->

    <section id="bookCatalog"
        class="bk-panel">

        <div class="bk-panel-head">
            <div>
                <h2>Book Catalog</h2>

                <p>
                    Search, edit, archive, or adjust available stock.
                </p>
            </div>

            <span class="bk-tag">
                Active Collection
            </span>
        </div>

        <!-- CATALOG NOTIFICATIONS -->

        <asp:Label
            ID="lblListMessage"
            runat="server"
            EnableViewState="false"
            CssClass="bk-message"
            role="status"
            aria-live="polite" />

        <asp:Panel
            ID="pnlBookFilters"
            runat="server"
            DefaultButton="btnSearch"
            CssClass="bk-filters">

            <div class="bk-field bk-search-field">
                <label for="<%= txtSearch.ClientID %>">
                    Search Books
                </label>

                <asp:TextBox
                    ID="txtSearch"
                    runat="server"
                    CssClass="form-control"
                    MaxLength="255"
                    autocomplete="off"
                    placeholder="Search title, author, ISBN or ID" />
            </div>

            <div class="bk-field">
                <label for="<%= ddlSearchGenre.ClientID %>">
                    Genre
                </label>

                <asp:DropDownList
                    ID="ddlSearchGenre"
                    runat="server"
                    CssClass="form-control" />
            </div>

            <div class="bk-field">
                <label for="<%= ddlAvailability.ClientID %>">
                    Availability
                </label>

                <asp:DropDownList
                    ID="ddlAvailability"
                    runat="server"
                    CssClass="form-control">

                    <asp:ListItem Text="All Books" Value="All" />
                    <asp:ListItem Text="Available" Value="Available" />
                    <asp:ListItem Text="Unavailable" Value="Unavailable" />

                </asp:DropDownList>
            </div>

            <div class="bk-field">
                <label for="<%= ddlSort.ClientID %>">
                    Sort
                </label>

                <asp:DropDownList
                    ID="ddlSort"
                    runat="server"
                    CssClass="form-control">

                    <asp:ListItem Text="Default Order" Value="Default" />
                    <asp:ListItem Text="Title A–Z" Value="TitleAsc" />
                    <asp:ListItem Text="Title Z–A" Value="TitleDesc" />
                    <asp:ListItem Text="Newest ID" Value="IDDesc" />
                    <asp:ListItem Text="Oldest ID" Value="IDAsc" />
                    <asp:ListItem Text="Most Available" Value="CopiesDesc" />

                </asp:DropDownList>
            </div>

            <div class="bk-filter-actions">

                <asp:Button
                    ID="btnSearch"
                    runat="server"
                    Text="Apply"
                    CssClass="bk-btn bk-btn-primary"
                    CausesValidation="false"
                    OnClick="btnSearch_Click" />

                <asp:Button
                    ID="btnResetFilters"
                    runat="server"
                    Text="Clear"
                    CssClass="bk-btn"
                    CausesValidation="false"
                    OnClick="btnResetFilters_Click" />

            </div>
        </asp:Panel>

        <div class="bk-result-bar">
            <asp:Label
                ID="lblBookResultCount"
                runat="server"
                Text="Showing books" />

            <span>
                Press Enter or Apply to search.
            </span>
        </div>

        <div class="bk-table-wrap">

            <asp:GridView
                ID="gvBooks"
                runat="server"
                AutoGenerateColumns="False"
                CssClass="bk-table"
                GridLines="None"
                EmptyDataText="No matching books found."
                OnRowCommand="gvBooks_RowCommand">

                <Columns>

                    <asp:TemplateField HeaderText="Book">
                        <ItemTemplate>
                            <div class="bk-book-cell">

                                <asp:Image
                                    ID="imgBookCover"
                                    runat="server"
                                    CssClass="bk-book-thumb"
                                    AlternateText="Book cover"
                                    ImageUrl='<%# GetCoverUrl(Eval("CoverImagePath")) %>' />

                                <div class="bk-book-info">
                                    <strong>
                                        <%#: Eval("Title") %>
                                    </strong>

                                    <small>
                                        <%#: Eval("Author") %>
                                    </small>
                                </div>

                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField
                        DataField="BookID"
                        HeaderText="ID" />

                    <asp:BoundField
                        DataField="ISBN"
                        HeaderText="ISBN" />

                    <asp:BoundField
                        DataField="GenreName"
                        HeaderText="Genre" />

                    <asp:BoundField
                        DataField="TotalCopies"
                        HeaderText="Total" />

                    <asp:BoundField
                        DataField="AvailableCopies"
                        HeaderText="Available" />

                    <asp:BoundField
                        DataField="BorrowingFee"
                        HeaderText="Fee (PHP)"
                        DataFormatString="{0:N2}" />

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>

                            <div class="bk-row-actions">

                                <asp:LinkButton
                                    ID="btnEdit"
                                    runat="server"
                                    Text="Edit"
                                    CssClass="bk-row-action"
                                    CommandName="EditBook"
                                    CommandArgument='<%# Eval("BookID") %>'
                                    CausesValidation="false" />

                                <asp:LinkButton
                                    ID="btnInventoryLost"
                                    runat="server"
                                    Text="Mark Lost"
                                    CssClass="bk-row-action"
                                    CommandName="InventoryLost"
                                    CommandArgument='<%# Eval("BookID") %>'
                                    CausesValidation="false"
                                    Visible='<%# Convert.ToInt32(Eval("AvailableCopies")) > 0 %>' />

                                <asp:LinkButton
                                    ID="btnArchive"
                                    runat="server"
                                    Text="Archive"
                                    CssClass="bk-row-action danger"
                                    CommandName="ArchiveBook"
                                    CommandArgument='<%# Eval("BookID") %>'
                                    CausesValidation="false"
                                    OnClientClick="return confirm('Archive this book?');" />

                            </div>

                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

            </asp:GridView>

        </div>

        <div class="bk-pagination">

            <asp:Button
                ID="btnPrevious"
                runat="server"
                Text="← Previous"
                CssClass="bk-btn"
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
                CssClass="bk-btn"
                CausesValidation="false"
                OnClick="btnNext_Click" />

        </div>

    </section>

    <!-- CREATE / EDIT BOOK - HIDDEN UNTIL NEEDED -->

    <asp:Panel
        ID="pnlBookEditor"
        runat="server"
        Visible="false"
        ClientIDMode="Static"
        CssClass="bk-panel">

        <div class="bk-panel-head">
            <div>

                <h2>
                    <asp:Label
                        ID="lblEditorTitle"
                        runat="server"
                        Text="Add New Book" />
                </h2>

                <p>
                    Enter book details and manage its cover image.
                </p>

            </div>

            <span class="bk-tag">
                Book Information
            </span>
        </div>

        <!-- EDITOR NOTIFICATIONS -->

        <asp:Label
            ID="lblEditorMessage"
            runat="server"
            EnableViewState="false"
            CssClass="bk-message"
            role="status"
            aria-live="polite" />

        <asp:HiddenField
            ID="hfBookID"
            runat="server"
            Value="0" />

        <div class="bk-editor-layout">

            <div class="bk-form-grid">

                <div class="bk-field bk-full">
                    <label for="<%= txtTitle.ClientID %>">
                        Book Title *
                    </label>

                    <asp:TextBox
                        ID="txtTitle"
                        runat="server"
                        CssClass="form-control"
                        MaxLength="255"
                        placeholder="Enter book title" />
                </div>

                <div class="bk-field">
                    <label for="<%= txtISBN.ClientID %>">
                        ISBN *
                    </label>

                    <asp:TextBox
                        ID="txtISBN"
                        runat="server"
                        CssClass="form-control"
                        MaxLength="20"
                        placeholder="Enter ISBN" />
                </div>

                <div class="bk-field">
                    <label for="<%= ddlGenre.ClientID %>">
                        Genre *
                    </label>

                    <asp:DropDownList
                        ID="ddlGenre"
                        runat="server"
                        CssClass="form-control" />
                </div>

                <div class="bk-field bk-full">
                    <label for="<%= txtAuthor.ClientID %>">
                        Author *
                    </label>

                    <asp:TextBox
                        ID="txtAuthor"
                        runat="server"
                        CssClass="form-control"
                        MaxLength="150"
                        placeholder="Enter author name" />
                </div>

                <div class="bk-field">
                    <label for="<%= txtTotalCopies.ClientID %>">
                        Total Copies *
                    </label>

                    <asp:TextBox
                        ID="txtTotalCopies"
                        runat="server"
                        CssClass="form-control"
                        TextMode="Number"
                        placeholder="0" />

                    <small class="bk-help">
                        Existing stock may be increased here.
                        Use Mark Lost for stock deductions.
                    </small>
                </div>

                <div class="bk-field">
                    <label for="<%= txtBorrowingFee.ClientID %>">
                        Borrowing Fee (PHP) *
                    </label>

                    <asp:TextBox
                        ID="txtBorrowingFee"
                        runat="server"
                        CssClass="form-control"
                        placeholder="0.00" />
                </div>

                <div class="bk-field bk-full">
                    <label for="<%= txtBookDesc.ClientID %>">
                        Description *
                    </label>

                    <asp:TextBox
                        ID="txtBookDesc"
                        runat="server"
                        CssClass="form-control"
                        TextMode="MultiLine"
                        Rows="4"
                        MaxLength="255"
                        placeholder="Enter a short description" />
                </div>

            </div>

            <!-- BOOK COVER -->

            <aside class="bk-cover-panel">

                <h3>Book Cover</h3>

                <p class="bk-help">
                    Upload a cover image for your catalog.
                </p>

                <div class="bk-cover-box">
                    <asp:Image
                        ID="imgCoverPreview"
                        runat="server"
                        CssClass="bk-cover-preview"
                        AlternateText="Book cover preview" />
                </div>

                <div class="bk-field">
                    <label for="<%= fuBookCover.ClientID %>">
                        Choose Cover
                    </label>

                    <asp:FileUpload
                        ID="fuBookCover"
                        runat="server"
                        CssClass="form-control"
                        accept=".jpg,.jpeg,.png,image/jpeg,image/png" />
                </div>

                <small class="bk-help">
                    JPG or PNG, maximum 2 MB.
                    Leave blank to keep the existing image.
                </small>

            </aside>

        </div>

        <div class="bk-form-footer">

            <small class="bk-help">
                Fields marked * are required.
            </small>

            <div class="bk-button-group">

                <asp:Button
                    ID="btnClear"
                    runat="server"
                    Text="Clear Form"
                    CssClass="bk-btn"
                    CausesValidation="false"
                    OnClick="btnClear_Click" />

                <asp:Button
                    ID="btnCancelEditor"
                    runat="server"
                    Text="Close"
                    CssClass="bk-btn"
                    CausesValidation="false"
                    OnClick="btnCancelEditor_Click" />

                <asp:Button
                    ID="btnSave"
                    runat="server"
                    Text="Save Book"
                    CssClass="bk-btn bk-btn-primary"
                    CausesValidation="false"
                    OnClick="btnSave_Click" />

            </div>
        </div>

    </asp:Panel>

    <!-- INVENTORY LOSS FORM - HIDDEN UNTIL NEEDED -->

    <asp:Panel
        ID="pnlInventoryLoss"
        runat="server"
        Visible="false"
        CssClass="bk-panel"
        ClientIDMode="Static">

        <div class="bk-panel-head">
            <div>
                <h2>Mark Inventory Lost</h2>
                <p>
                    Record missing or damaged copies
                    from available stock.
                </p>
            </div>

            <span class="bk-tag">
                Inventory Adjustment
            </span>
        </div>

        <!-- LOSS FORM NOTIFICATIONS -->

        <asp:Label
            ID="lblLossMessage"
            runat="server"
            EnableViewState="false"
            CssClass="bk-message"
            role="status"
            aria-live="polite" />

        <asp:HiddenField
            ID="hfInventoryLossBookID"
            runat="server"
            Value="0" />

        <h3 style="font-size:17px;font-weight:800;">
            <asp:Label
                ID="lblLossBookTitle"
                runat="server" />
        </h3>

        <div class="bk-loss-summary">

            <div class="bk-loss-stat">
                <small>Total Copies</small>
                <strong>
                    <asp:Label
                        ID="lblLossTotal"
                        runat="server"
                        Text="0" />
                </strong>
            </div>

            <div class="bk-loss-stat">
                <small>Available Copies</small>
                <strong>
                    <asp:Label
                        ID="lblLossAvailable"
                        runat="server"
                        Text="0" />
                </strong>
            </div>

            <div class="bk-loss-stat">
                <small>Maximum Loss</small>
                <strong>
                    <asp:Label
                        ID="lblLossMaximum"
                        runat="server"
                        Text="0" />
                </strong>
            </div>

        </div>

        <div class="bk-loss-grid">

            <div class="bk-field">
                <label for="<%= txtQuantityLost.ClientID %>">
                    Quantity Lost *
                </label>

                <asp:TextBox
                    ID="txtQuantityLost"
                    runat="server"
                    CssClass="form-control"
                    TextMode="Number"
                    placeholder="Enter quantity" />
            </div>

            <div class="bk-field">
                <label for="<%= txtLossReason.ClientID %>">
                    Reason *
                </label>

                <asp:TextBox
                    ID="txtLossReason"
                    runat="server"
                    CssClass="form-control"
                    TextMode="MultiLine"
                    Rows="3"
                    MaxLength="500"
                    placeholder="Explain why these copies are missing or damaged" />
            </div>

        </div>

        <div class="bk-warning">
            Only available copies can be marked lost.
            This operation permanently reduces total and
            available stock. Borrowed books must be handled
            through Manage Borrowings.
        </div>

        <div class="bk-button-group">

            <asp:Button
                ID="btnConfirmInventoryLoss"
                runat="server"
                Text="Confirm Inventory Loss"
                CssClass="bk-btn bk-btn-primary"
                CausesValidation="false"
                OnClick="btnConfirmInventoryLoss_Click"
                OnClientClick="return confirm('Confirm this inventory loss? The stock deduction will be recorded in the audit history.');" />

            <asp:Button
                ID="btnCancelInventoryLoss"
                runat="server"
                Text="Cancel"
                CssClass="bk-btn"
                CausesValidation="false"
                OnClick="btnCancelInventoryLoss_Click" />

        </div>

    </asp:Panel>

    <!-- INVENTORY LOSS HISTORY -->

    <section id="inventoryLossHistory"
        class="bk-panel">

        <div class="bk-panel-head">
            <div>
                <h2>Inventory Loss History</h2>
                <p>
                    Review stock adjustments and responsible librarians.
                </p>
            </div>

            <span class="bk-tag">
                Audit Records
            </span>
        </div>

        <!-- HISTORY NOTIFICATIONS -->

        <asp:Label
            ID="lblHistoryMessage"
            runat="server"
            EnableViewState="false"
            CssClass="bk-message"
            role="status"
            aria-live="polite" />

        <asp:Panel
            ID="pnlLossHistorySearch"
            runat="server"
            DefaultButton="btnLossHistorySearch"
            CssClass="bk-history-filters">

            <asp:TextBox
                ID="txtLossHistorySearch"
                runat="server"
                CssClass="form-control"
                MaxLength="255"
                placeholder="Search book, ISBN, librarian or reason" />

            <asp:Button
                ID="btnLossHistorySearch"
                runat="server"
                Text="Search"
                CssClass="bk-btn bk-btn-primary"
                CausesValidation="false"
                OnClick="btnLossHistorySearch_Click" />

            <asp:Button
                ID="btnLossHistoryClear"
                runat="server"
                Text="Clear"
                CssClass="bk-btn"
                CausesValidation="false"
                OnClick="btnLossHistoryClear_Click" />

        </asp:Panel>

        <p class="bk-help" style="margin-bottom:15px;">
            Search runs only when you press Enter or click Search.
        </p>

        <div class="bk-table-wrap">

            <asp:GridView
                ID="gvInventoryLossHistory"
                runat="server"
                AutoGenerateColumns="False"
                CssClass="bk-table"
                GridLines="None"
                EmptyDataText="No inventory loss records found.">

                <Columns>

                    <asp:BoundField
                        DataField="InventoryLossID"
                        HeaderText="Loss ID" />

                    <asp:BoundField
                        DataField="BookTitle"
                        HeaderText="Book" />

                    <asp:BoundField
                        DataField="QuantityLost"
                        HeaderText="Lost Qty" />

                    <asp:BoundField
                        DataField="Reason"
                        HeaderText="Reason" />

                    <asp:BoundField
                        DataField="RecordedBy"
                        HeaderText="Recorded By" />

                    <asp:BoundField
                        DataField="DateRecorded"
                        HeaderText="Date"
                        DataFormatString="{0:MMM dd, yyyy hh:mm tt}" />

                    <asp:BoundField
                        DataField="TotalCopiesBefore"
                        HeaderText="Total Before" />

                    <asp:BoundField
                        DataField="TotalCopiesAfter"
                        HeaderText="Total After" />

                    <asp:BoundField
                        DataField="AvailableCopiesBefore"
                        HeaderText="Available Before" />

                    <asp:BoundField
                        DataField="AvailableCopiesAfter"
                        HeaderText="Available After" />

                </Columns>
            </asp:GridView>

        </div>

        <div class="bk-pagination">

            <asp:Button
                ID="btnLossHistoryPrevious"
                runat="server"
                Text="← Previous"
                CssClass="bk-btn"
                CausesValidation="false"
                OnClick="btnLossHistoryPrevious_Click" />

            <asp:Label
                ID="lblLossHistoryPageInfo"
                runat="server"
                Text="Page 1 of 1" />

            <asp:Button
                ID="btnLossHistoryNext"
                runat="server"
                Text="Next →"
                CssClass="bk-btn"
                CausesValidation="false"
                OnClick="btnLossHistoryNext_Click" />

        </div>

    </section>

</div>

<!-- SCROLL TO THE RELEVANT FORM OR RESULT -->

<asp:HiddenField
    ID="hfFocusTarget"
    runat="server"
    Value=""
    ClientIDMode="Static" />

<script type="text/javascript">
    (function () {

        var upload = document.getElementById(
        '<%= fuBookCover.ClientID %>');

    var preview = document.getElementById(
        '<%= imgCoverPreview.ClientID %>');

        if (upload && preview) {
            upload.addEventListener('change', function () {
                var file = upload.files && upload.files[0];
                if (!file) return;

                if (file.type !== 'image/jpeg' &&
                    file.type !== 'image/png') {
                    alert('Choose a JPG or PNG image.');
                    upload.value = '';
                    return;
                }

                if (file.size > 2 * 1024 * 1024) {
                    alert('Image must not exceed 2 MB.');
                    upload.value = '';
                    return;
                }

                var reader = new FileReader();

                reader.onload = function (event) {
                    preview.src = event.target.result;
                };

                reader.readAsDataURL(file);
            });
        }

        var focusInput =
            document.getElementById('hfFocusTarget');

        if (focusInput && focusInput.value) {
            var target = document.getElementById(
                focusInput.value);

            if (target) {
                window.requestAnimationFrame(function () {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                });
            }
        }

    })();
</script>

</asp:Content>
