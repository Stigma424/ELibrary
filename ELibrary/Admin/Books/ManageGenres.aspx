
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
        .el-admin-genres .el-ac-live-filters {
            display: grid;
            grid-template-columns:
                minmax(200px, 2fr)
                minmax(160px, 1fr)
                auto;
            gap: 12px;
            align-items: end;
            padding: 16px;
            margin-bottom: 12px;
            border: 1px solid #e4ebf3;
            border-radius: 10px;
            background: #f8fafc;
        }

        .el-admin-genres .el-ac-live-field {
            min-width: 0;
        }

        .el-admin-genres .el-ac-live-field label {
            display: block;
            margin-bottom: 7px;
            color: #43566b;
            font-size: 12px;
            font-weight: 700;
        }

        .el-admin-genres .el-ac-live-field .form-control {
            width: 100%;
            min-height: 40px;
            padding: 9px 11px;
            border: 1px solid #dce5ee;
            border-radius: 8px;
            background: #fff;
            color: #172b43;
            font-size: 13px;
        }

        .el-admin-genres .el-ac-live-field .form-control:focus {
            outline: none;
            border-color: #2f6ba0;
            box-shadow: 0 0 0 3px rgba(47,107,160,.12);
        }

        .el-admin-genres .el-ac-live-reset {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .el-admin-genres .el-ac-live-reset .el-ac-btn {
            min-height: 40px;
            white-space: nowrap;
        }

        .el-admin-genres .el-ac-live-count {
            display: block;
            margin: 0 0 13px;
            color: #718096;
            font-size: 12px;
        }

        .el-admin-genres .el-genre-filter-note {
            margin: 0 0 12px;
            color: #718096;
            font-size: 12px;
        }

        .el-admin-genres .el-genre-pager {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 12px;
            padding: 18px 0 4px;
        }

        .el-admin-genres .el-genre-page-info {
            color: #61748e;
            font-size: 13px;
        }

        .el-admin-genres .el-genre-pager .el-ac-btn:disabled {
            opacity: .45;
            cursor: default;
        }
    </style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="el-admin-catalog el-admin-genres">

        <!-- PAGE HEADER -->
        <div class="el-ac-header">
            <div>
                <span class="el-ac-eyebrow">
                    ADMINISTRATION / CATALOG
                </span>

                <h1>Manage Genres</h1>

                <p>
                    Organize the categories used throughout
                    your library collection.
                </p>
            </div>

            <asp:HyperLink
                runat="server"
                NavigateUrl="~/Admin/Books/ManageBooks.aspx"
                CssClass="el-ac-btn el-ac-btn-light"
                Text="← Manage Books" />
        </div>

        <!-- MESSAGE -->
        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="el-ac-message" />

        <!-- GENRE LIST -->
        <section class="el-ac-panel">

            <div class="el-ac-panel-heading">
                <div>
                    <h2>Genre List</h2>

                    <p>
                        Search, sort, edit, or delete
                        catalog genres.
                    </p>
                </div>

                <a href="#genreEditor"
                   class="el-ac-btn el-ac-btn-primary">
                    + Create Genre
                </a>
            </div>

            <!-- SEARCH AND FILTER -->
            <asp:Panel
                ID="pnlGenreFilters"
                runat="server"
                DefaultButton="btnApply"
                CssClass="el-ac-live-filters">

                <div class="el-ac-live-field">
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

                <div class="el-ac-live-field">
                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlSort"
                        Text="Sort By" />

                    <asp:DropDownList
                        ID="ddlSort"
                        runat="server"
                        CssClass="form-control">

                        <asp:ListItem
                            Text="Default Order"
                            Value="Default" />

                        <asp:ListItem
                            Text="Genre Name (A–Z)"
                            Value="NameAsc" />

                        <asp:ListItem
                            Text="Genre Name (Z–A)"
                            Value="NameDesc" />

                        <asp:ListItem
                            Text="ID (Lowest First)"
                            Value="IDAsc" />

                        <asp:ListItem
                            Text="ID (Highest First)"
                            Value="IDDesc" />

                    </asp:DropDownList>
                </div>

                <div class="el-ac-live-field el-ac-live-reset">

                    <asp:Button
                        ID="btnApply"
                        runat="server"
                        Text="Apply"
                        CssClass="el-ac-btn el-ac-btn-primary"
                        CausesValidation="false"
                        OnClick="btnApply_Click" />

                    <asp:Button
                        ID="btnClearFilters"
                        runat="server"
                        Text="Clear"
                        CssClass="el-ac-btn el-ac-btn-light"
                        CausesValidation="false"
                        OnClick="btnClearFilters_Click" />

                </div>

            </asp:Panel>

            <p class="el-genre-filter-note">
                Press Enter or click Apply to search and sort.
            </p>

            <asp:Label
                ID="lblResultCount"
                runat="server"
                CssClass="el-ac-live-count"
                Text="Showing genres" />

            <!-- GENRE TABLE -->
            <div class="el-ac-table-scroll">

                <asp:GridView
                    ID="gvGenres"
                    runat="server"
                    AutoGenerateColumns="False"
                    CssClass="el-ac-table"
                    GridLines="None"
                    EmptyDataText="No genres match your search."
                    OnRowCommand="gvGenres_RowCommand">

                    <Columns>

                        <asp:BoundField
                            DataField="GenreID"
                            HeaderText="ID" />

                        <asp:BoundField
                            DataField="GenreName"
                            HeaderText="Genre Name" />

                        <asp:BoundField
                            DataField="GenreDesc"
                            HeaderText="Description" />

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>

                                <div class="el-ac-row-actions">

                                    <asp:LinkButton
                                        ID="btnEdit"
                                        runat="server"
                                        Text="Edit"
                                        CssClass="el-ac-table-action"
                                        CommandName="EditGenre"
                                        CommandArgument='<%# Eval("GenreID") %>'
                                        CausesValidation="false" />

                                    <asp:LinkButton
                                        ID="btnDelete"
                                        runat="server"
                                        Text="Delete"
                                        CssClass="el-ac-table-action danger"
                                        CommandName="DeleteGenre"
                                        CommandArgument='<%# Eval("GenreID") %>'
                                        CausesValidation="false"
                                        OnClientClick="return confirm('Delete this genre?');" />

                                </div>

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>

            </div>

            <!-- PAGINATION -->
            <div class="el-genre-pager">

                <asp:Button
                    ID="btnPrevious"
                    runat="server"
                    Text="← Previous"
                    CssClass="el-ac-btn el-ac-btn-light"
                    CausesValidation="false"
                    OnClick="btnPrevious_Click" />

                <asp:Label
                    ID="lblPageInfo"
                    runat="server"
                    CssClass="el-genre-page-info"
                    Text="Page 1 of 1" />

                <asp:Button
                    ID="btnNext"
                    runat="server"
                    Text="Next →"
                    CssClass="el-ac-btn el-ac-btn-light"
                    CausesValidation="false"
                    OnClick="btnNext_Click" />

            </div>

        </section>

        <!-- CREATE / EDIT GENRE -->
        <section class="el-ac-panel el-ac-editor"
                 id="genreEditor">

            <div class="el-ac-panel-heading">
                <div>
                    <h2>Create / Edit Genre</h2>

                    <p>
                        Add a category or edit an existing one.
                    </p>
                </div>
            </div>

            <asp:HiddenField
                ID="hfGenreID"
                runat="server"
                Value="0" />

            <div class="el-ac-form-grid">

                <div class="el-ac-field">
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

                <div class="el-ac-field el-ac-full">
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

            <div class="el-ac-editor-actions">
                <span>
                    Fields marked * are required.
                </span>

                <div class="el-ac-button-group">

                    <asp:Button
                        ID="btnCancel"
                        runat="server"
                        Text="Clear Form"
                        CssClass="el-ac-btn el-ac-btn-light"
                        CausesValidation="false"
                        OnClick="btnCancel_Click" />

                    <asp:Button
                        ID="btnSave"
                        runat="server"
                        Text="Save Genre"
                        CssClass="el-ac-btn el-ac-btn-primary"
                        OnClick="btnSave_Click" />

                </div>
            </div>

        </section>

    </div>

    <!-- SCROLL TO EDITOR WHEN EDITING -->
    <script type="text/javascript">
        (function () {
            var editor = document.getElementById('genreEditor');

            var genreId = document.getElementById(
                '<%= hfGenreID.ClientID %>');

            if (editor && genreId &&
                genreId.value !== '0' &&
                genreId.value !== '') {

                editor.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        })();
    </script>

</asp:Content>
