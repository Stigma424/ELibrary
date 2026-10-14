
<%@ Page Title="Browse Books"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Books.aspx.cs"
    Inherits="ELibrary.Customer.Books"
    MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <style>
        .el-catalog-v2-filters {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .el-catalog-v2-filters .el-catalog-v2-search {
            flex: 1 1 320px;
            min-width: 0;
        }

        .el-catalog-v2-search .form-control {
            width: 100%;
            min-height: 44px;
            box-sizing: border-box;
        }

        .el-catalog-v2-filters .el-catalog-v2-genre {
            flex: 0 1 220px;
            min-height: 44px;
        }

        .el-catalog-v2-filters .btn {
            min-height: 44px;
        }

        .el-catalog-v2-pager {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 12px;
            margin-top: 28px;
            padding: 15px;
        }

        .el-catalog-v2-pager .btn:disabled {
            opacity: .45;
            cursor: default;
        }

        .el-catalog-v2-page-info {
            color: #61748e;
            font-size: .9rem;
        }
    </style>

    <div class="el-catalog-page el-catalog-v2">

        <!-- PAGE HEADING -->
        <div class="el-catalog-v2-heading">
            <div>
                <span class="el-section-eyebrow">
                    E-LIBRARY COLLECTION
                </span>

                <h1>Discover Books</h1>

                <p>
                    Explore our collection and find
                    your next great read.
                </p>
            </div>

            <div class="el-catalog-v2-heading-icon">
                &#128218;
            </div>
        </div>

        <!-- SEARCH AND FILTER -->
        <asp:Panel ID="pnlFilters"
            runat="server"
            DefaultButton="btnSearch"
            CssClass="el-catalog-v2-filters">

            <div class="el-catalog-v2-search">
                <span class="el-catalog-v2-search-icon">
                    &#9906;
                </span>

                <asp:TextBox
                    ID="txtSearch"
                    runat="server"
                    CssClass="form-control"
                    MaxLength="255"
                    placeholder="Search by title, author, or ISBN..." />
            </div>

            <asp:DropDownList
                ID="ddlGenre"
                runat="server"
                CssClass="form-select el-catalog-v2-genre" />

            <asp:Button
                ID="btnSearch"
                runat="server"
                Text="Apply"
                CssClass="btn btn-primary"
                CausesValidation="false"
                OnClick="btnSearch_Click" />

            <asp:Button
                ID="btnClear"
                runat="server"
                Text="Clear"
                CssClass="btn btn-outline-secondary"
                CausesValidation="false"
                OnClick="btnClear_Click" />

        </asp:Panel>

        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="el-catalog-message" />

        <!-- CATALOG -->
        <div class="el-catalog-v2-results">

            <div class="el-catalog-v2-results-heading">
                <h2>All Books</h2>

                <asp:Label
                    ID="lblResultCount"
                    runat="server"
                    CssClass="el-catalog-v2-count"
                    Text="0 books found" />
            </div>

            <asp:Panel
                ID="pnlBookResults"
                runat="server">

                <div class="el-catalog-v2-grid">

                    <asp:Repeater
                        ID="rptBooks"
                        runat="server">

                        <ItemTemplate>

                            <article class="el-catalog-v2-card">

                                <a class="el-catalog-v2-cover"
                                   href='<%# GetBookDetailsUrl(Eval("BookID")) %>'>

                                    <asp:Image
                                        runat="server"
                                        ImageUrl='<%# GetCoverUrl(Eval("CoverImagePath")) %>'
                                        AlternateText='<%# Eval("Title") %>' />

                                </a>

                                <div class="el-catalog-v2-card-body">

                                    <span class="el-catalog-v2-category">
                                        <%#: Eval("GenreName") %>
                                    </span>

                                    <h3>
                                        <a href='<%# GetBookDetailsUrl(Eval("BookID")) %>'>
                                            <%#: Eval("Title") %>
                                        </a>
                                    </h3>

                                    <p class="el-catalog-v2-author">
                                        <%#: Eval("Author") %>
                                    </p>

                                    <div class="el-catalog-v2-availability">

                                        <span class='<%# GetAvailabilityClass(Eval("AvailableCopies")) %>'>
                                            <%# GetAvailabilityText(Eval("AvailableCopies")) %>
                                        </span>

                                        <small>
                                            <%#: Eval("AvailableCopies") %>
                                            copies
                                        </small>

                                    </div>

                                    <div class="el-catalog-v2-bottom">

                                        <div class="el-catalog-v2-price">
                                            <small>Borrowing Fee</small>

                                            <strong>
                                                ₱<%# Eval("BorrowingFee", "{0:N2}") %>
                                            </strong>
                                        </div>

                                        <a class="el-catalog-v2-details"
                                           href='<%# GetBookDetailsUrl(Eval("BookID")) %>'>
                                            View Details
                                        </a>

                                    </div>

                                </div>

                            </article>

                        </ItemTemplate>

                    </asp:Repeater>

                </div>

            </asp:Panel>

            <asp:Panel
                ID="pnlEmptyResults"
                runat="server"
                Visible="false"
                CssClass="el-catalog-empty">

                <div class="el-catalog-empty-icon">
                    &#128214;
                </div>

                <h3>No books found</h3>

                <p>
                    Try a different search term
                    or select another genre.
                </p>

            </asp:Panel>

            <!-- PAGINATION -->
            <div class="el-catalog-v2-pager">

                <asp:Button
                    ID="btnPrevious"
                    runat="server"
                    Text="← Previous"
                    CssClass="btn btn-outline-primary"
                    CausesValidation="false"
                    OnClick="btnPrevious_Click" />

                <asp:Label
                    ID="lblPageInfo"
                    runat="server"
                    CssClass="el-catalog-v2-page-info"
                    Text="Page 1 of 1" />

                <asp:Button
                    ID="btnNext"
                    runat="server"
                    Text="Next →"
                    CssClass="btn btn-outline-primary"
                    CausesValidation="false"
                    OnClick="btnNext_Click" />

            </div>

        </div>
    </div>
</asp:Content>
