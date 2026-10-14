
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
        .el-admin-books .el-book-filters {
            display: grid;
            grid-template-columns:
                minmax(180px, 2fr)
                repeat(3, minmax(125px, 1fr))
                auto;
            gap: 12px;
            align-items: end;
            padding: 16px;
            margin-bottom: 14px;
            background: #f8fafc;
            border: 1px solid #e4ebf3;
            border-radius: 10px;
        }

        .el-admin-books .el-book-filter-field {
            min-width: 0;
        }

        .el-admin-books .el-book-filter-field label {
            display: block;
            margin-bottom: 7px;
            color: #43566b;
            font-size: 12px;
            font-weight: 700;
        }

        .el-admin-books .el-book-filter-field .form-control {
            display: block;
            width: 100%;
            min-width: 0;
            min-height: 40px;
            padding: 9px 11px;
            border: 1px solid #dce5ee;
            border-radius: 8px;
            background: #fff;
            color: #172b43;
            font-size: 13px;
        }

        .el-admin-books .el-book-filter-field .form-control:focus {
            outline: none;
            border-color: #2f6ba0;
            box-shadow: 0 0 0 3px rgba(47,107,160,.12);
        }

        .el-admin-books .el-book-filter-actions {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .el-admin-books .el-book-filter-actions .el-ac-btn {
            min-height: 40px;
            white-space: nowrap;
        }

        .el-admin-books .el-book-result-count {
            margin: 0 0 13px;
            color: #718096;
            font-size: 12px;
        }

        .el-admin-books .el-book-no-results {
            display: none;
            padding: 18px;
            margin-bottom: 12px;
            border: 1px dashed #dce5ee;
            border-radius: 8px;
            background: #f8fafc;
            color: #718096;
            text-align: center;
            font-size: 13px;
        }

        .el-admin-books .el-book-filter-note {
            margin: -4px 0 14px;
            color: #718096;
            font-size: 11px;
        }

        .el-admin-books .el-ac-table-scroll {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        @media (max-width: 1250px) {
            .el-admin-books .el-book-filters {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .el-admin-books .el-book-search-field {
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 600px) {
            .el-admin-books .el-book-filters {
                grid-template-columns: 1fr;
                padding: 13px;
            }

            .el-admin-books .el-book-search-field {
                grid-column: auto;
            }

            .el-admin-books .el-book-filter-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .el-admin-books .el-book-filter-actions .el-ac-btn {
                width: 100%;
            }
        }
    </style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="el-admin-catalog el-admin-books">

        <!-- PAGE HEADER -->
        <div class="el-ac-header">
            <div>
                <span class="el-ac-eyebrow">
                    ADMINISTRATION / CATALOG
                </span>

                <h1>Manage Books</h1>

                <p>
                    Search your collection, manage inventory,
                    and create new book records.
                </p>
            </div>

            <asp:HyperLink
                runat="server"
                NavigateUrl="~/Admin/Books/ManageGenres.aspx"
                CssClass="el-ac-btn el-ac-btn-light"
                Text="Manage Genres" />
        </div>

        <!-- MESSAGE -->
        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="book-message" />

        <!-- BOOK LIST -->
        <section class="el-ac-panel">

            <div class="el-ac-panel-heading">
                <div>
                    <h2>Book List</h2>

                    <p>
                        Search, filter, edit, or archive books.
                    </p>
                </div>

                <a href="#bookEditor"
                   class="el-ac-btn el-ac-btn-primary">
                    + Create Book
                </a>
            </div>

            <!-- MANUAL SEARCH / FILTER -->
            <asp:Panel ID="pnlBookFilters" runat="server"
                DefaultButton="btnSearch" CssClass="el-book-filters">
                <div class="el-book-filter-field el-book-search-field">
                    <label for="<%= txtSearch.ClientID %>">Search Books</label>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                        MaxLength="255" placeholder="Search title, author, ISBN, or ID"
                        autocomplete="off" />
                </div>
                <div class="el-book-filter-field">
                    <label for="<%= ddlSearchGenre.ClientID %>">Genre</label>
                    <asp:DropDownList ID="ddlSearchGenre" runat="server" CssClass="form-control" />
                </div>
                <div class="el-book-filter-field">
                    <label for="<%= ddlAvailability.ClientID %>">Availability</label>
                    <asp:DropDownList ID="ddlAvailability" runat="server" CssClass="form-control">
                        <asp:ListItem Text="All Books" Value="All" />
                        <asp:ListItem Text="Available" Value="Available" />
                        <asp:ListItem Text="Unavailable" Value="Unavailable" />
                    </asp:DropDownList>
                </div>
                <div class="el-book-filter-field">
                    <label for="<%= ddlSort.ClientID %>">Sort By</label>
                    <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Default Order" Value="Default" />
                        <asp:ListItem Text="Title (A-Z)" Value="TitleAsc" />
                        <asp:ListItem Text="Title (Z-A)" Value="TitleDesc" />
                        <asp:ListItem Text="Highest ID First" Value="IDDesc" />
                        <asp:ListItem Text="Lowest ID First" Value="IDAsc" />
                        <asp:ListItem Text="Most Available Copies" Value="CopiesDesc" />
                    </asp:DropDownList>
                </div>
                <div class="el-book-filter-actions">
                    <asp:Button ID="btnSearch" runat="server" Text="Apply"
                        CssClass="el-ac-btn el-ac-btn-primary" CausesValidation="false"
                        OnClick="btnSearch_Click" />
                    <asp:Button ID="btnResetFilters" runat="server" Text="Clear"
                        CssClass="el-ac-btn el-ac-btn-light" CausesValidation="false"
                        OnClick="btnResetFilters_Click" />
                </div>
            </asp:Panel>
            <p class="el-book-filter-note">Press Enter or click Apply to search and filter.</p>
            <p class="el-book-result-count">
                <asp:Label ID="lblBookResultCount" runat="server" Text="Showing books" />
            </p>

            <!-- BOOK TABLE -->
            <div class="el-ac-table-scroll">

                <asp:GridView
                    ID="gvBooks"
                    runat="server"
                    AutoGenerateColumns="False"
                    CssClass="el-ac-table"
                    GridLines="None"
                    EmptyDataText="No books found."
                    OnRowCommand="gvBooks_RowCommand">

                    <Columns>

                        <asp:TemplateField HeaderText="Book">
                            <ItemTemplate>

                                <div class="el-ac-book-cell">

                                    <asp:Image
                                        ID="imgBookCover"
                                        runat="server"
                                        CssClass="el-ac-book-thumb"
                                        AlternateText="Book cover"
                                        ImageUrl='<%# GetCoverUrl(Eval("CoverImagePath")) %>' />

                                    <div class="el-ac-book-info">
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

                                <div class="el-ac-row-actions">

                                    <asp:LinkButton
                                        ID="btnEdit"
                                        runat="server"
                                        Text="Edit"
                                        CssClass="el-ac-table-action"
                                        CommandName="EditBook"
                                        CommandArgument='<%# Eval("BookID") %>'
                                        CausesValidation="false" />

                                    <asp:LinkButton
                                        ID="btnArchive"
                                        runat="server"
                                        Text="Archive"
                                        CssClass="el-ac-table-action danger"
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
            <div class="el-book-pagination" style="display:flex;align-items:center;justify-content:center;gap:12px;padding:18px;">
                <asp:Button ID="btnPrevious" runat="server" Text="← Previous"
                    CssClass="el-ac-btn el-ac-btn-light" CausesValidation="false"
                    OnClick="btnPrevious_Click" />
                <asp:Label ID="lblPageInfo" runat="server" Text="Page 1 of 1" />
                <asp:Button ID="btnNext" runat="server" Text="Next →"
                    CssClass="el-ac-btn el-ac-btn-light" CausesValidation="false"
                    OnClick="btnNext_Click" />
            </div>
        </section>

        <!-- CREATE / EDIT BOOK -->
        <section class="el-ac-panel el-ac-editor"
                 id="bookEditor">

            <div class="el-ac-panel-heading">
                <div>
                    <h2>Create / Edit Book</h2>

                    <p>
                        Add a new book or update a selected record.
                    </p>
                </div>

                <span class="el-ac-section-chip">
                    Book Information
                </span>
            </div>

            <asp:HiddenField
                ID="hfBookID"
                runat="server"
                Value="0" />

            <div class="el-ac-editor-layout">

                <!-- MAIN FORM -->
                <div class="el-ac-editor-main">

                    <div class="el-ac-form-grid">

                        <div class="el-ac-field el-ac-full">
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

                        <div class="el-ac-field">
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

                        <div class="el-ac-field">
                            <label for="<%= ddlGenre.ClientID %>">
                                Genre *
                            </label>

                            <asp:DropDownList
                                ID="ddlGenre"
                                runat="server"
                                CssClass="form-control" />
                        </div>

                        <div class="el-ac-field el-ac-full">
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

                        <div class="el-ac-field">
                            <label for="<%= txtTotalCopies.ClientID %>">
                                Total Copies *
                            </label>

                            <asp:TextBox
                                ID="txtTotalCopies"
                                runat="server"
                                CssClass="form-control"
                                TextMode="Number"
                                placeholder="0" />
                        </div>

                        <div class="el-ac-field">
                            <label for="<%= txtBorrowingFee.ClientID %>">
                                Borrowing Fee (PHP) *
                            </label>

                            <asp:TextBox
                                ID="txtBorrowingFee"
                                runat="server"
                                CssClass="form-control"
                                placeholder="0.00" />
                        </div>

                        <div class="el-ac-field el-ac-full">
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
                                placeholder="Enter a short book description" />
                        </div>

                    </div>
                </div>

                <!-- COVER PANEL -->
                <aside class="el-ac-cover-panel">

                    <h3>Book Cover</h3>

                    <p>
                        Upload a cover image for the catalog.
                    </p>

                    <div class="el-ac-cover-preview-box">

                        <asp:Image
                            ID="imgCoverPreview"
                            runat="server"
                            CssClass="el-ac-cover-preview"
                            AlternateText="Book cover preview" />

                    </div>

                    <label for="<%= fuBookCover.ClientID %>">
                        Choose Cover Image
                    </label>

                    <asp:FileUpload
                        ID="fuBookCover"
                        runat="server"
                        CssClass="form-control"
                        accept=".jpg,.jpeg,.png,image/jpeg,image/png" />

                    <small>
                        JPG or PNG, maximum 2 MB.
                        Leave blank to keep the existing cover.
                    </small>

                </aside>

            </div>

            <div class="el-ac-editor-actions">

                <span>
                    Fields marked * are required.
                </span>

                <div class="el-ac-button-group">

                    <asp:Button
                        ID="btnClear"
                        runat="server"
                        Text="Clear Form"
                        CssClass="el-ac-btn el-ac-btn-light"
                        CausesValidation="false"
                        OnClick="btnClear_Click" />

                    <asp:Button
                        ID="btnSave"
                        runat="server"
                        Text="Save Book"
                        CssClass="el-ac-btn el-ac-btn-primary"
                        OnClick="btnSave_Click" />

                </div>
            </div>

        </section>

    </div>

    <!-- COVER PREVIEW + EDITOR SCROLL -->
    <script type="text/javascript">
        (function () {

            // BOOK COVER PREVIEW
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

            // SCROLL TO EDITOR WHEN EDITING
            var editor = document.getElementById('bookEditor');

            var bookId = document.getElementById(
                '<%= hfBookID.ClientID %>');

            if (editor && bookId &&
                bookId.value !== '0' &&
                bookId.value !== '') {

                editor.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }

        })();
    </script>

</asp:Content>
