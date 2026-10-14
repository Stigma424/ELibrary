
<%@ Page Title="Book Details"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="BookDetails.aspx.cs"
    Inherits="ELibrary.Customer.BookDetails" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="el-book-details-page">

        <!-- BREADCRUMB -->
        <div class="el-book-breadcrumb">
            <a href="<%= ResolveUrl("~/CustomerHome.aspx") %>">
                Home
            </a>
            <span>/</span>
            <a href="<%= ResolveUrl("~/Customer/Books.aspx") %>">
                Browse Books
            </a>
            <span>/</span>
            <strong>Book Details</strong>
        </div>

        <div class="el-book-details-layout">

            <!-- LEFT: BOOK COVER -->
            <div class="el-book-details-visual">

                <div class="el-book-details-cover">

                    <asp:Image
                        ID="imgBookCover"
                        runat="server"
                        AlternateText="Book cover" />

                </div>

                <div class="el-book-details-cover-caption">
                    E-Library Collection
                </div>

            </div>

            <!-- RIGHT: BOOK INFORMATION -->
            <div class="el-book-details-information">

                <span class="el-book-details-eyebrow">
                    BOOK INFORMATION
                </span>

                <div class="el-book-details-genre">
                    <asp:Label
                        ID="lblGenre"
                        runat="server" />
                </div>

                <h1 class="el-book-details-title">
                    <asp:Label
                        ID="lblTitle"
                        runat="server" />
                </h1>

                <p class="el-book-details-author">
                    by
                    <asp:Label
                        ID="lblAuthor"
                        runat="server" />
                </p>

                <div class="el-book-details-divider"></div>

                <!-- BOOK AVAILABILITY -->
                <div class="el-book-details-availability">

                    <asp:Label
                        ID="lblAvailabilityStatus"
                        runat="server"
                        CssClass="el-catalog-status" />

                    <span>
                        <asp:Label
                            ID="lblAvailableCopies"
                            runat="server"
                            Text="0" />
                        copies available
                    </span>

                </div>

                <!-- BORROWING INFORMATION -->
                <div class="el-book-details-fee-box">

                    <span>Borrowing Fee</span>

                    <strong>
                        ₱<asp:Label
                            ID="lblBorrowingFee"
                            runat="server"
                            Text="0.00" />
                    </strong>

                    <small>
                        Borrowing period: 7 days after collection
                    </small>

                </div>

                <!-- RESERVATION INFORMATION -->
                <div style="
                    margin: 16px 0;
                    padding: 15px 17px;
                    background: #f4f8fc;
                    border: 1px solid #dce7f2;
                    border-radius: 10px;">

                    <div style="
                        color: #244c74;
                        font-size: 13px;
                        font-weight: 700;
                        margin-bottom: 7px;">
                        How Book Reservation Works
                    </div>

                    <p style="
                        margin: 0;
                        color: #53677d;
                        font-size: 12px;
                        line-height: 1.8;">

                        Reserve an available book online and
                        collect it at the library.

                        Your reservation will remain pending
                        until a librarian confirms collection.

                        The 7-day borrowing period starts
                        only after collection is confirmed.

                    </p>

                </div>

                <!-- SUCCESS / ERROR MESSAGE -->
                <asp:Label
                    ID="lblMessage"
                    runat="server"
                    EnableViewState="false"
                    CssClass="el-book-details-message" />

                <!-- ACTION BUTTONS -->
                <div class="el-book-details-actions">

                    <asp:Button
                        ID="btnBorrow"
                        runat="server"
                        Text="Reserve Book"
                        CssClass="btn el-book-borrow-btn"
                        CausesValidation="false"
                        OnClick="btnBorrow_Click" />

                    <asp:Button
                        ID="btnBack"
                        runat="server"
                        Text="Back to Books"
                        CssClass="btn el-book-back-btn"
                        CausesValidation="false"
                        OnClick="btnBack_Click" />

                </div>

                <div class="el-book-details-divider"></div>

                <!-- BOOK METADATA -->
                <div class="el-book-details-meta">

                    <div>
                        <span>ISBN</span>
                        <strong>
                            <asp:Label
                                ID="lblISBN"
                                runat="server" />
                        </strong>
                    </div>

                    <div>
                        <span>Total Copies</span>
                        <strong>
                            <asp:Label
                                ID="lblTotalCopies"
                                runat="server" />
                        </strong>
                    </div>

                </div>

            </div>

        </div>

        <!-- BOOK DESCRIPTION -->
        <section class="el-book-description-panel">

            <span class="el-section-eyebrow">
                ABOUT THIS BOOK
            </span>

            <h2>Book Description</h2>

            <p>
                <asp:Label
                    ID="lblDescription"
                    runat="server" />
            </p>

        </section>

        <!-- BOTTOM NAVIGATION -->
        <div class="el-book-details-bottom-link">

            <a href="<%= ResolveUrl("~/Customer/Books.aspx") %>">
                ← Continue Exploring Books
            </a>

        </div>

    </div>

</asp:Content>
