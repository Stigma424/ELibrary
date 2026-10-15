
<%@ Page Title="Browse Books"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Books.aspx.cs"
    Inherits="ELibrary.Customer.Books"
    MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* ============================================
   COASTAL MINIMAL - CUSTOMER BOOK CATALOG
   UI-C3A
============================================ */

.el-customer-mode .coast-catalog {
    --cc-ink: #123B4A;
    --cc-teal: #168A91;
    --cc-hover: #12757C;
    --cc-muted: #647F89;
    --cc-border: #DCE9EB;
    --cc-soft: #F5FAFA;

    display: flex;
    flex-direction: column;
    gap: 26px;
    width: 100%;
    min-width: 0;
    padding-bottom: 32px;
    color: var(--cc-ink);
}

.el-customer-mode .coast-catalog *,
.el-customer-mode .coast-catalog *::before,
.el-customer-mode .coast-catalog *::after {
    box-sizing: border-box;
}

.el-customer-mode .coast-catalog .cc-hero {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 24px;
    min-height: 205px;
    padding: clamp(25px, 4vw, 48px);
    border: 1px solid #D0E8E9;
    border-radius: 20px;
    background: linear-gradient(115deg, #DDEFF0, #F4FAF8);
    overflow: hidden;
}

.el-customer-mode .coast-catalog .cc-eyebrow {
    display: block;
    margin-bottom: 12px;
    color: #13787C;
    font-size: 10px;
    font-weight: 850;
    letter-spacing: .13em;
}

.el-customer-mode .coast-catalog h1 {
    margin: 0 0 11px;
    color: var(--cc-ink);
    font-size: clamp(29px, 3.6vw, 43px);
    letter-spacing: -1px;
    font-weight: 850;
}

.el-customer-mode .coast-catalog .cc-hero p {
    max-width: 550px;
    margin: 0;
    color: #52737D;
    font-size: 13px;
    line-height: 1.8;
}

.el-customer-mode .coast-catalog .cc-hero-art {
    flex-shrink: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 145px;
    height: 145px;
    border-radius: 50%;
    background: rgba(255,255,255,.45);
    font-size: 73px;
    color: #168A91;
}

.el-customer-mode .coast-catalog .cc-panel {
    min-width: 0;
    padding: 25px;
    border: 1px solid var(--cc-border);
    border-radius: 15px;
    background: #FFFFFF;
    box-shadow: 0 3px 14px rgba(18,59,74,.03);
}

.el-customer-mode .coast-catalog .cc-panel-title {
    margin: 0 0 18px;
    color: var(--cc-ink);
    font-size: 17px;
    font-weight: 800;
}

.el-customer-mode .coast-catalog .cc-filters {
    display: grid;
    grid-template-columns: minmax(180px, 1fr) 220px auto;
    align-items: end;
    gap: 12px;
}

.el-customer-mode .coast-catalog .cc-field {
    min-width: 0;
}

.el-customer-mode .coast-catalog .cc-field label {
    display: block;
    margin-bottom: 8px;
    color: #375968;
    font-size: 12px;
    font-weight: 750;
}

.el-customer-mode .coast-catalog .cc-input {
    display: block;
    width: 100%;
    min-height: 45px;
    padding: 11px 13px;
    border: 1px solid #CFE1E4;
    border-radius: 10px;
    background: #FFFFFF;
    color: #123B4A;
    font-size: 12px;
}

.el-customer-mode .coast-catalog .cc-input:focus {
    outline: none;
    border-color: var(--cc-teal);
    box-shadow: 0 0 0 3px rgba(22,138,145,.12);
}

.el-customer-mode .coast-catalog .cc-filter-actions {
    display: flex;
    align-items: center;
    gap: 9px;
}

.el-customer-mode .coast-catalog .cc-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 45px;
    padding: 11px 17px;
    border: 1px solid #D3E4E5;
    border-radius: 10px;
    background: #FFFFFF;
    color: #123B4A;
    font-size: 12px;
    font-weight: 800;
    text-decoration: none;
    cursor: pointer;
}

.el-customer-mode .coast-catalog .cc-btn:hover {
    color: #123B4A;
    background: #F0F8F9;
    border-color: #B5D6D9;
}

.el-customer-mode .coast-catalog .cc-btn-primary {
    background: var(--cc-teal);
    border-color: var(--cc-teal);
    color: #FFFFFF;
}

.el-customer-mode .coast-catalog .cc-btn-primary:hover {
    background: var(--cc-hover);
    border-color: var(--cc-hover);
    color: #FFFFFF;
}

.el-customer-mode .coast-catalog .cc-btn:disabled {
    opacity: .45;
    cursor: default;
}

.el-customer-mode .coast-catalog .cc-hint {
    display: block;
    margin-top: 12px;
    color: var(--cc-muted);
    font-size: 11px;
}

.el-customer-mode .coast-catalog .cc-message {
    display: block;
    margin-top: 16px;
    color: #9E3E39;
    font-size: 12px;
    line-height: 1.7;
}

.el-customer-mode .coast-catalog .cc-message:empty {
    display: none;
}

.el-customer-mode .coast-catalog .cc-message.text-danger {
    padding: 13px 16px;
    background: #FFF0EF;
    border: 1px solid #F2D3CF;
    border-left: 4px solid #C34D46;
    border-radius: 9px;
    color: #9E3E39 !important;
}

.el-customer-mode .coast-catalog .cc-results-heading {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 12px;
    margin-bottom: 22px;
}

.el-customer-mode .coast-catalog .cc-results-heading h2 {
    margin: 0;
    color: var(--cc-ink);
    font-size: 22px;
    font-weight: 850;
}

.el-customer-mode .coast-catalog .cc-count {
    display: inline-flex;
    padding: 8px 12px;
    border-radius: 999px;
    background: #EAF6F6;
    color: #126E73;
    font-size: 11px;
    font-weight: 800;
}

.el-customer-mode .coast-catalog .cc-grid {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 17px;
}

.el-customer-mode .coast-catalog .cc-card {
    display: flex;
    flex-direction: column;
    min-width: 0;
    overflow: hidden;
    background: #FFFFFF;
    border: 1px solid #DCE9EB;
    border-radius: 14px;
    transition: transform .18s, box-shadow .18s;
}

.el-customer-mode .coast-catalog .cc-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 12px 26px rgba(18,59,74,.075);
}

.el-customer-mode .coast-catalog .cc-cover {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 245px;
    padding: 20px;
    background: linear-gradient(145deg, #EFF6F4, #DFEBED);
}

.el-customer-mode .coast-catalog .cc-cover img {
    display: block;
    width: auto;
    max-width: 100%;
    height: 100%;
    object-fit: contain;
    border-radius: 3px 7px 7px 3px;
    box-shadow: 5px 7px 12px rgba(18,59,74,.13);
}

.el-customer-mode .coast-catalog .cc-card-body {
    display: flex;
    flex-direction: column;
    flex: 1;
    gap: 10px;
    padding: 16px;
}

.el-customer-mode .coast-catalog .cc-genre {
    color: #168A91;
    font-size: 10px;
    font-weight: 850;
    text-transform: uppercase;
    letter-spacing: .06em;
}

.el-customer-mode .coast-catalog .cc-card h3 {
    margin: 0;
    color: #123B4A;
    font-size: 14px;
    font-weight: 800;
    line-height: 1.5;
    overflow-wrap: anywhere;
}

.el-customer-mode .coast-catalog .cc-card h3 a {
    color: inherit;
    text-decoration: none;
}

.el-customer-mode .coast-catalog .cc-card h3 a:hover {
    color: #168A91;
}

.el-customer-mode .coast-catalog .cc-author {
    margin: 0;
    color: #647F89;
    font-size: 11px;
}

.el-customer-mode .coast-catalog .cc-availability {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 8px;
}

.el-customer-mode .coast-catalog .cc-availability
.el-catalog-status {
    display: inline-block;
    padding: 6px 9px;
    border-radius: 7px;
    font-size: 10px;
    font-weight: 800;
}

.el-customer-mode .coast-catalog .cc-availability
.el-catalog-status.available {
    color: #237C62;
    background: #E5F6EC;
}

.el-customer-mode .coast-catalog .cc-availability
.el-catalog-status.unavailable {
    color: #A63D39;
    background: #FCE9E7;
}

.el-customer-mode .coast-catalog .cc-copies {
    color: #647F89;
    font-size: 10px;
}

.el-customer-mode .coast-catalog .cc-card-bottom {
    display: flex;
    flex-direction: column;
    gap: 13px;
    margin-top: auto;
    padding-top: 13px;
    border-top: 1px solid #EDF3F4;
}

.el-customer-mode .coast-catalog .cc-fee {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.el-customer-mode .coast-catalog .cc-fee span {
    color: #647F89;
    font-size: 10px;
}

.el-customer-mode .coast-catalog .cc-fee strong {
    color: #123B4A;
    font-size: 18px;
    font-weight: 850;
}

.el-customer-mode .coast-catalog .cc-details-link {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 38px;
    padding: 9px 12px;
    background: #EAF6F6;
    border: 1px solid #CDE7E9;
    border-radius: 8px;
    color: #126E73;
    font-size: 11px;
    font-weight: 800;
    text-decoration: none;
}

.el-customer-mode .coast-catalog .cc-details-link:hover {
    background: #DDF0F1;
    color: #0F6065;
}

.el-customer-mode .coast-catalog .cc-empty {
    padding: 45px 22px;
    border: 1px dashed #C8E0E2;
    border-radius: 14px;
    text-align: center;
    background: #F9FCFC;
}

.el-customer-mode .coast-catalog .cc-empty h3 {
    margin: 0 0 8px;
    font-size: 17px;
    color: #123B4A;
}

.el-customer-mode .coast-catalog .cc-empty p {
    margin: 0;
    color: #647F89;
    font-size: 12px;
}

.el-customer-mode .coast-catalog .cc-pager {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
    margin-top: 25px;
}

.el-customer-mode .coast-catalog .cc-page-info {
    color: #647F89;
    font-size: 12px;
    font-weight: 700;
}

@media (max-width: 1100px) {
    .el-customer-mode .coast-catalog .cc-grid {
        grid-template-columns: repeat(3, minmax(0,1fr));
    }
}

@media (max-width: 800px) {
    .el-customer-mode .coast-catalog .cc-filters {
        grid-template-columns: repeat(2, minmax(0,1fr));
    }

    .el-customer-mode .coast-catalog .cc-search-field {
        grid-column: 1 / -1;
    }

    .el-customer-mode .coast-catalog .cc-grid {
        grid-template-columns: repeat(2, minmax(0,1fr));
    }
}

@media (max-width: 520px) {
    .el-customer-mode .coast-catalog .cc-hero {
        padding: 27px 22px;
        min-height: 0;
    }

    .el-customer-mode .coast-catalog .cc-hero-art {
        display: none;
    }

    .el-customer-mode .coast-catalog .cc-panel {
        padding: 16px;
    }

    .el-customer-mode .coast-catalog .cc-filters {
        grid-template-columns: 1fr;
    }

    .el-customer-mode .coast-catalog .cc-search-field {
        grid-column: auto;
    }

    .el-customer-mode .coast-catalog .cc-filter-actions {
        width: 100%;
    }

    .el-customer-mode .coast-catalog .cc-filter-actions .cc-btn {
        flex: 1;
    }

    .el-customer-mode .coast-catalog .cc-grid {
        gap: 10px;
    }

    .el-customer-mode .coast-catalog .cc-cover {
        height: 170px;
        padding: 12px;
    }

    .el-customer-mode .coast-catalog .cc-card-body {
        padding: 12px;
        gap: 8px;
    }

    .el-customer-mode .coast-catalog .cc-card h3 {
        font-size: 12px;
    }
}

@media (prefers-reduced-motion: reduce) {
    .el-customer-mode .coast-catalog .cc-card {
        transition: none;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="coast-catalog">

    <!-- INTRODUCTION -->
    <header class="cc-hero">
        <div>
            <span class="cc-eyebrow">
                EXPLORE OUR LIBRARY
            </span>

            <h1>Discover your next great read.</h1>

            <p>
                Explore our collection of stories and knowledge.
                Find books that interest you, check their
                availability, and reserve your favorites.
            </p>
        </div>

        <div class="cc-hero-art" aria-hidden="true">
            &#128218;
        </div>
    </header>

    <!-- SEARCH SECTION -->
    <section class="cc-panel">

        <h2 class="cc-panel-title">
            Find a Book
        </h2>

        <asp:Panel
            ID="pnlFilters"
            runat="server"
            DefaultButton="btnSearch"
            CssClass="cc-filters">

            <div class="cc-field cc-search-field">

                <asp:Label
                    runat="server"
                    AssociatedControlID="txtSearch"
                    Text="Search the collection" />

                <asp:TextBox
                    ID="txtSearch"
                    runat="server"
                    CssClass="cc-input"
                    MaxLength="255"
                    autocomplete="off"
                    placeholder="Title, author or ISBN..." />

            </div>

            <div class="cc-field">

                <asp:Label
                    runat="server"
                    AssociatedControlID="ddlGenre"
                    Text="Genre" />

                <asp:DropDownList
                    ID="ddlGenre"
                    runat="server"
                    CssClass="cc-input" />

            </div>

            <div class="cc-filter-actions">

                <asp:Button
                    ID="btnSearch"
                    runat="server"
                    Text="Search"
                    CssClass="cc-btn cc-btn-primary"
                    CausesValidation="false"
                    OnClick="btnSearch_Click" />

                <asp:Button
                    ID="btnClear"
                    runat="server"
                    Text="Clear"
                    CssClass="cc-btn"
                    CausesValidation="false"
                    OnClick="btnClear_Click" />

            </div>

        </asp:Panel>

        <span class="cc-hint">
            Press Enter or Search to apply your filters.
            Changing the genre alone won't reload the results.
        </span>

        <!-- ERRORS REMAIN BESIDE FILTERS -->
        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="cc-message"
            role="status"
            aria-live="polite" />

    </section>

    <!-- BOOK RESULTS -->
    <section class="cc-panel">

        <div class="cc-results-heading">
            <h2>Library Collection</h2>

            <asp:Label
                ID="lblResultCount"
                runat="server"
                CssClass="cc-count"
                Text="0 books found" />
        </div>

        <asp:Panel
            ID="pnlBookResults"
            runat="server">

            <div class="cc-grid">

                <asp:Repeater
                    ID="rptBooks"
                    runat="server">

                    <ItemTemplate>

                        <article class="cc-card">

                            <a class="cc-cover"
                               href='<%# GetBookDetailsUrl(Eval("BookID")) %>'>

                                <asp:Image
                                    runat="server"
                                    ImageUrl='<%# GetCoverUrl(Eval("CoverImagePath")) %>'
                                    AlternateText='<%# Eval("Title") %>' />

                            </a>

                            <div class="cc-card-body">

                                <span class="cc-genre">
                                    <%#: Eval("GenreName") %>
                                </span>

                                <h3>
                                    <a href='<%# GetBookDetailsUrl(Eval("BookID")) %>'>
                                        <%#: Eval("Title") %>
                                    </a>
                                </h3>

                                <p class="cc-author">
                                    by <%#: Eval("Author") %>
                                </p>

                                <div class="cc-availability">

                                    <span class='<%#
                                        GetAvailabilityClass(
                                            Eval("AvailableCopies")) %>'>

                                        <%# GetAvailabilityText(
                                            Eval("AvailableCopies")) %>
                                    </span>

                                    <span class="cc-copies">
                                        <%#: Eval("AvailableCopies") %>
                                        available copies
                                    </span>

                                </div>

                                <div class="cc-card-bottom">

                                    <div class="cc-fee">
                                        <span>Borrowing Fee</span>

                                        <strong>
                                            ₱<%# Eval("BorrowingFee", "{0:N2}") %>
                                        </strong>
                                    </div>

                                    <a class="cc-details-link"
                                       href='<%# GetBookDetailsUrl(
                                           Eval("BookID")) %>'>
                                        View Book Details &rarr;
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
            CssClass="cc-empty">

            <div style="font-size:38px;margin-bottom:12px;"
                aria-hidden="true">
                &#128214;
            </div>

            <h3>No books found</h3>

            <p>
                Try another search term or
                choose a different genre.
            </p>

        </asp:Panel>

        <!-- SERVER-SIDE PAGINATION -->
        <div class="cc-pager">

            <asp:Button
                ID="btnPrevious"
                runat="server"
                Text="← Previous"
                CssClass="cc-btn"
                CausesValidation="false"
                OnClick="btnPrevious_Click" />

            <asp:Label
                ID="lblPageInfo"
                runat="server"
                CssClass="cc-page-info"
                Text="Page 1 of 1" />

            <asp:Button
                ID="btnNext"
                runat="server"
                Text="Next →"
                CssClass="cc-btn"
                CausesValidation="false"
                OnClick="btnNext_Click" />

        </div>

    </section>

</div>

</asp:Content>
