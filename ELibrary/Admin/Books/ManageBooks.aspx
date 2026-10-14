
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

        .el-admin-books .el-book-filter-note {
            margin: -4px 0 14px;
            color: #718096;
            font-size: 11px;
        }

        .el-admin-books .el-ac-table-scroll {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        .el-admin-books .el-loss-panel {
            border: 1px solid #e4ebf3;
            border-radius: 10px;
            background: #fff;
            padding: 18px;
            margin-bottom: 16px;
        }

        .el-admin-books .el-loss-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .el-admin-books .el-loss-field {
            min-width: 0;
        }

        .el-admin-books .el-loss-field label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            color: #43566b;
            margin-bottom: 7px;
        }

        .el-admin-books .el-loss-field .form-control {
            width: 100%;
            min-height: 40px;
            padding: 9px 11px;
            border: 1px solid #dce5ee;
            border-radius: 8px;
            background: #fff;
            box-sizing: border-box;
        }

        .el-admin-books .el-loss-summary {
            padding: 14px;
            margin: 12px 0;
            background: #f8fafc;
            border: 1px solid #e4ebf3;
            border-radius: 8px;
            line-height: 1.8;
            color: #334155;
        }

        .el-admin-books .el-loss-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 16px;
        }

        .el-admin-books .el-loss-note {
            color: #64748b;
            font-size: 12px;
            margin: 10px 0;
        }

        .el-admin-books .el-loss-danger {
            color: #b42318;
        }

        .el-admin-books .el-history-filters {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
            margin-bottom: 15px;
        }

        .el-admin-books .el-history-filters .form-control {
            flex: 1;
            min-width: 200px;
            padding: 10px;
            border: 1px solid #dce5ee;
            border-radius: 8px;
        }

        .el-admin-books .el-book-pagination {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            padding: 18px;
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
            .el-admin-books .el-book-filters,
            .el-admin-books .el-loss-grid {
                grid-template-columns: 1fr;
            }

            .el-admin-books .el-book-filters {
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
                        Search, filter, edit, archive,
                        or record inventory losses.
                    </p>
                </div>

                <a href="#bookEditor"
                    class="el-ac-btn el-ac-btn-primary">
                    + Create Book
                </a>
            </div>

            <asp:Panel
                ID="pnlBookFilters"
                runat="server"
                DefaultButton="btnSearch"
                CssClass="el-book-filters">

                <div class="el-book-filter-field el-book-search-field">
                    <label for="<%= txtSearch.ClientID %>">
                        Search Books
                    </label>
                    <asp:TextBox
                        ID="txtSearch"
                        runat="server"
                        CssClass="form-control"
                        MaxLength="255"
                        placeholder="Search title, author, ISBN, or ID"
                        autocomplete="off" />
                </div>

                <div class="el-book-filter-field">
                    <label for="<%= ddlSearchGenre.ClientID %>">
                        Genre
                    </label>
                    <asp:DropDownList
                        ID="ddlSearchGenre"
                        runat="server"
                        CssClass="form-control" />
                </div>

                <div class="el-book-filter-field">
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

                <div class="el-book-filter-field">
                    <label for="<%= ddlSort.ClientID %>">
                        Sort By
                    </label>
                    <asp:DropDownList
                        ID="ddlSort"
                        runat="server"
                        CssClass="form-control">
                        <asp:ListItem Text="Default Order" Value="Default" />
                        <asp:ListItem Text="Title (A-Z)" Value="TitleAsc" />
                        <asp:ListItem Text="Title (Z-A)" Value="TitleDesc" />
                        <asp:ListItem Text="Highest ID First" Value="IDDesc" />
                        <asp:ListItem Text="Lowest ID First" Value="IDAsc" />
                        <asp:ListItem Text="Most Available Copies" Value="CopiesDesc" />
                    </asp:DropDownList>
                </div>

                <div class="el-book-filter-actions">
                    <asp:Button
                        ID="btnSearch"
                        runat="server"
                        Text="Apply"
                        CssClass="el-ac-btn el-ac-btn-primary"
                        CausesValidation="false"
                        OnClick="btnSearch_Click" />

                    <asp:Button
                        ID="btnResetFilters"
                        runat="server"
                        Text="Clear"
                        CssClass="el-ac-btn el-ac-btn-light"
                        CausesValidation="false"
                        OnClick="btnResetFilters_Click" />
                </div>
            </asp:Panel>

            <p class="el-book-filter-note">
                Press Enter or click Apply to search and filter.
            </p>

            <p class="el-book-result-count">
                <asp:Label
                    ID="lblBookResultCount"
                    runat="server"
                    Text="Showing books" />
            </p>

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
                                        <strong><%#: Eval("Title") %></strong>
                                        <small><%#: Eval("Author") %></small>
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
                                        ID="btnInventoryLost"
                                        runat="server"
                                        Text="Mark Lost"
                                        CssClass="el-ac-table-action"
                                        CommandName="InventoryLost"
                                        CommandArgument='<%# Eval("BookID") %>'
                                        CausesValidation="false"
                                        Visible='<%# Convert.ToInt32(Eval("AvailableCopies")) > 0 %>' />

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

            <div class="el-book-pagination">
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

        <!-- INVENTORY LOSS FORM -->
        <asp:Panel
            ID="pnlInventoryLoss"
            runat="server"
            Visible="false"
            CssClass="el-ac-panel"
            ClientIDMode="Static">

            <div class="el-ac-panel-heading">
                <div>
                    <h2>Mark Inventory Lost</h2>
                    <p>
                        Record missing or damaged copies
                        from available library stock.
                    </p>
                </div>
                <span class="el-ac-section-chip">
                    Inventory Adjustment
                </span>
            </div>

            <div class="el-loss-panel">

                <asp:HiddenField
                    ID="hfInventoryLossBookID"
                    runat="server"
                    Value="0" />

                <h3>
                    <asp:Label
                        ID="lblLossBookTitle"
                        runat="server" />
                </h3>

                <div class="el-loss-summary">
                    <strong>Current Inventory</strong>
                    <div>
                        Total Copies:
                        <asp:Label
                            ID="lblLossTotal"
                            runat="server"
                            Text="0" />
                    </div>
                    <div>
                        Available Copies:
                        <asp:Label
                            ID="lblLossAvailable"
                            runat="server"
                            Text="0" />
                    </div>
                    <div>
                        Maximum Inventory Loss:
                        <asp:Label
                            ID="lblLossMaximum"
                            runat="server"
                            Text="0" />
                    </div>
                </div>

                <div class="el-loss-grid">

                    <div class="el-loss-field">
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

                    <div class="el-loss-field">
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

                <p class="el-loss-note">
                    Only available copies may be recorded as
                    inventory lost. Borrowed books must be handled
                    through Manage Borrowings.
                </p>

                <p class="el-loss-note el-loss-danger">
                    This operation permanently reduces total and
                    available copies. It does not automatically
                    archive the book.
                </p>

                <div class="el-loss-actions">
                    <asp:Button
                        ID="btnConfirmInventoryLoss"
                        runat="server"
                        Text="Confirm Inventory Loss"
                        CssClass="el-ac-btn el-ac-btn-primary"
                        CausesValidation="false"
                        OnClick="btnConfirmInventoryLoss_Click"
                        OnClientClick="return confirm('Confirm this inventory loss? The stock deduction will be recorded in the audit history.');" />

                    <asp:Button
                        ID="btnCancelInventoryLoss"
                        runat="server"
                        Text="Cancel"
                        CssClass="el-ac-btn el-ac-btn-light"
                        CausesValidation="false"
                        OnClick="btnCancelInventoryLoss_Click" />
                </div>

            </div>
        </asp:Panel>

        <!-- INVENTORY LOSS HISTORY -->
        <section class="el-ac-panel" id="inventoryLossHistory">

            <div class="el-ac-panel-heading">
                <div>
                    <h2>Inventory Loss History</h2>
                    <p>
                        Review recorded stock losses and
                        the librarians responsible.
                    </p>
                </div>
            </div>

            <asp:Panel
                ID="pnlLossHistorySearch"
                runat="server"
                DefaultButton="btnLossHistorySearch"
                CssClass="el-history-filters">

                <asp:TextBox
                    ID="txtLossHistorySearch"
                    runat="server"
                    CssClass="form-control"
                    MaxLength="255"
                    placeholder="Search book, ISBN, librarian, or reason" />

                <asp:Button
                    ID="btnLossHistorySearch"
                    runat="server"
                    Text="Search"
                    CssClass="el-ac-btn el-ac-btn-primary"
                    CausesValidation="false"
                    OnClick="btnLossHistorySearch_Click" />

                <asp:Button
                    ID="btnLossHistoryClear"
                    runat="server"
                    Text="Clear"
                    CssClass="el-ac-btn el-ac-btn-light"
                    CausesValidation="false"
                    OnClick="btnLossHistoryClear_Click" />
            </asp:Panel>

            <p class="el-book-filter-note">
                History searches run only when you press Enter
                or click Search.
            </p>

            <div class="el-ac-table-scroll">
                <asp:GridView
                    ID="gvInventoryLossHistory"
                    runat="server"
                    AutoGenerateColumns="False"
                    CssClass="el-ac-table"
                    GridLines="None"
                    EmptyDataText="No inventory losses found.">

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

            <div class="el-book-pagination">
                <asp:Button
                    ID="btnLossHistoryPrevious"
                    runat="server"
                    Text="← Previous"
                    CssClass="el-ac-btn el-ac-btn-light"
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
                    CssClass="el-ac-btn el-ac-btn-light"
                    CausesValidation="false"
                    OnClick="btnLossHistoryNext_Click" />
            </div>
        </section>

        <!-- CREATE / EDIT BOOK -->
        <section
            class="el-ac-panel el-ac-editor"
            id="bookEditor">

            <div class="el-ac-panel-heading">
                <div>
                    <h2>Create / Edit Book</h2>
                    <p>
                        Add a new book, edit its information,
                        or increase its inventory.
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
                            <small>
                                Existing books: you may add copies,
                                but reductions require Mark Inventory Lost.
                            </small>
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

            var lossPanel = document.getElementById('pnlInventoryLoss');
            var lossBookId = document.getElementById(
                '<%= hfInventoryLossBookID.ClientID %>');

            if (lossPanel && lossBookId &&
                lossBookId.value !== '0' &&
                lossBookId.value !== '') {
                lossPanel.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        })();
    </script>

</asp:Content>
