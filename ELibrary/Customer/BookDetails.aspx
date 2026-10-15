
<%@ Page Title="Book Details"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="BookDetails.aspx.cs"
    Inherits="ELibrary.Customer.BookDetails" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* ============================================
   COASTAL MINIMAL - CUSTOMER BOOK DETAILS
   UI-C3B
============================================ */

.el-customer-mode .coast-details {
    --cd-ink: #123B4A;
    --cd-teal: #168A91;
    --cd-hover: #12757C;
    --cd-muted: #647F89;
    --cd-border: #DCE9EB;

    display: flex;
    flex-direction: column;
    gap: 25px;
    width: 100%;
    min-width: 0;
    padding-bottom: 32px;
    color: var(--cd-ink);
}

.el-customer-mode .coast-details *,
.el-customer-mode .coast-details *::before,
.el-customer-mode .coast-details *::after {
    box-sizing: border-box;
}

.el-customer-mode .coast-details .cd-breadcrumb {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
    font-size: 12px;
    color: #647F89;
}

.el-customer-mode .coast-details .cd-breadcrumb a {
    color: #168A91;
    text-decoration: none;
    font-weight: 700;
}

.el-customer-mode .coast-details .cd-breadcrumb a:hover {
    text-decoration: underline;
}

.el-customer-mode .coast-details .cd-breadcrumb strong {
    color: #123B4A;
}

.el-customer-mode .coast-details .cd-layout {
    display: grid;
    grid-template-columns: minmax(280px,.8fr) minmax(0,1.2fr);
    gap: 25px;
    align-items: start;
}

.el-customer-mode .coast-details .cd-cover-panel {
    display: flex;
    flex-direction: column;
    gap: 17px;
    padding: 35px 25px 21px;
    border: 1px solid #DCE9EB;
    border-radius: 17px;
    background: linear-gradient(145deg, #E3F0EF, #F6FAF9);
}

.el-customer-mode .coast-details .cd-cover-display {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 390px;
}

.el-customer-mode .coast-details .cd-cover-display img {
    display: block;
    max-width: 100%;
    width: auto;
    max-height: 385px;
    object-fit: contain;
    border-radius: 4px 10px 10px 4px;
    box-shadow: 14px 18px 27px rgba(18,59,74,.19);
}

.el-customer-mode .coast-details .cd-cover-caption {
    display: block;
    text-align: center;
    font-size: 10px;
    letter-spacing: .13em;
    font-weight: 800;
    color: #64848A;
}

.el-customer-mode .coast-details .cd-information {
    min-width: 0;
    padding: 31px;
    border: 1px solid #DCE9EB;
    border-radius: 17px;
    background: #FFFFFF;
    box-shadow: 0 3px 15px rgba(18,59,74,.035);
}

.el-customer-mode .coast-details .cd-eyebrow {
    display: block;
    margin-bottom: 12px;
    color: #168A91;
    font-size: 10px;
    letter-spacing: .14em;
    font-weight: 850;
}

.el-customer-mode .coast-details .cd-genre {
    display: inline-flex;
    margin-bottom: 12px;
    padding: 7px 11px;
    background: #EAF6F6;
    border-radius: 999px;
    color: #126E73;
    font-size: 11px;
    font-weight: 750;
}

.el-customer-mode .coast-details .cd-title {
    margin: 0 0 13px;
    color: #123B4A;
    font-size: clamp(27px, 3.4vw, 40px);
    line-height: 1.2;
    letter-spacing: -.8px;
    font-weight: 850;
    overflow-wrap: anywhere;
}

.el-customer-mode .coast-details .cd-author {
    margin: 0 0 22px;
    color: #647F89;
    font-size: 14px;
    line-height: 1.6;
}

.el-customer-mode .coast-details .cd-author strong {
    color: #416370;
}

.el-customer-mode .coast-details .cd-divider {
    margin: 22px 0;
    height: 1px;
    background: #E6EFF0;
}

.el-customer-mode .coast-details .cd-availability {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
    margin-bottom: 21px;
    font-size: 12px;
    color: #647F89;
}

.el-customer-mode .coast-details
.cd-availability .el-catalog-status {
    display: inline-flex;
    padding: 8px 12px;
    border-radius: 8px;
    font-size: 11px;
    font-weight: 800;
}

.el-customer-mode .coast-details
.cd-availability .el-catalog-status.available {
    color: #237C62;
    background: #E5F6EC;
}

.el-customer-mode .coast-details
.cd-availability .el-catalog-status.unavailable {
    color: #A63D39;
    background: #FCE9E7;
}

.el-customer-mode .coast-details .cd-fee-panel {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 12px;
    margin-bottom: 21px;
    padding: 18px 20px;
    border: 1px solid #CDE7E9;
    border-radius: 12px;
    background: #EAF6F6;
}

.el-customer-mode .coast-details .cd-fee-label {
    display: block;
    margin-bottom: 6px;
    color: #54747C;
    font-size: 11px;
    font-weight: 750;
}

.el-customer-mode .coast-details .cd-fee-value {
    display: block;
    color: #123B4A;
    font-size: 30px;
    font-weight: 850;
}

.el-customer-mode .coast-details .cd-fee-note {
    max-width: 190px;
    color: #577980;
    font-size: 11px;
    line-height: 1.7;
}

.el-customer-mode .coast-details .cd-explainer {
    padding: 18px;
    margin-bottom: 21px;
    border: 1px solid #E3E9DF;
    border-radius: 11px;
    background: #F8FAF5;
}

.el-customer-mode .coast-details .cd-explainer strong {
    display: block;
    margin-bottom: 9px;
    color: #375C54;
    font-size: 12px;
    font-weight: 850;
}

.el-customer-mode .coast-details .cd-explainer p {
    margin: 0;
    color: #64766E;
    font-size: 12px;
    line-height: 1.85;
}

.el-customer-mode .coast-details .cd-message {
    display: block;
    margin: 0 0 17px;
    font-size: 12px;
    line-height: 1.75;
}

.el-customer-mode .coast-details .cd-message:empty {
    display: none;
}

.el-customer-mode .coast-details .cd-message.success {
    padding: 14px 16px;
    background: #E9F7F1;
    border: 1px solid #C8E8D7;
    border-left: 4px solid #28845B;
    border-radius: 9px;
    color: #236747 !important;
}

.el-customer-mode .coast-details .cd-message.error {
    padding: 14px 16px;
    background: #FFF0EF;
    border: 1px solid #F2D3CF;
    border-left: 4px solid #C34D46;
    border-radius: 9px;
    color: #9E3E39 !important;
}

.el-customer-mode .coast-details .cd-actions {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;
}

.el-customer-mode .coast-details .cd-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 46px;
    padding: 11px 22px;
    border: 1px solid #CFE3E4;
    border-radius: 10px;
    background: #FFFFFF;
    color: #123B4A;
    font-size: 12px;
    font-weight: 850;
    text-decoration: none;
    cursor: pointer;
}

.el-customer-mode .coast-details .cd-btn:hover {
    color: #123B4A;
    background: #F0F8F9;
}

.el-customer-mode .coast-details .cd-btn-primary {
    background: #168A91;
    border-color: #168A91;
    color: #FFFFFF;
}

.el-customer-mode .coast-details .cd-btn-primary:hover {
    background: #12757C;
    border-color: #12757C;
    color: #FFFFFF;
}

.el-customer-mode .coast-details .cd-btn-primary:disabled {
    opacity: .48;
    cursor: not-allowed;
}

.el-customer-mode .coast-details .cd-metadata {
    display: grid;
    grid-template-columns: repeat(2, minmax(0,1fr));
    gap: 13px;
}

.el-customer-mode .coast-details .cd-meta-item {
    min-width: 0;
    padding: 15px;
    border: 1px solid #E2ECEE;
    border-radius: 10px;
    background: #F7FBFB;
}

.el-customer-mode .coast-details .cd-meta-item span {
    display: block;
    margin-bottom: 7px;
    color: #647F89;
    font-size: 11px;
}

.el-customer-mode .coast-details .cd-meta-item strong {
    display: block;
    color: #123B4A;
    font-size: 13px;
    font-weight: 800;
    overflow-wrap: anywhere;
}

.el-customer-mode .coast-details .cd-description {
    padding: 27px 30px;
    border: 1px solid #DCE9EB;
    border-radius: 15px;
    background: #FFFFFF;
}

.el-customer-mode .coast-details .cd-description h2 {
    margin: 0 0 13px;
    color: #123B4A;
    font-size: 21px;
    font-weight: 850;
}

.el-customer-mode .coast-details .cd-description p {
    margin: 0;
    color: #526F79;
    font-size: 13px;
    line-height: 1.95;
    overflow-wrap: anywhere;
    white-space: pre-line;
}

.el-customer-mode .coast-details .cd-bottom-link {
    color: #168A91;
    font-size: 12px;
    font-weight: 800;
    text-decoration: none;
}

.el-customer-mode .coast-details .cd-bottom-link:hover {
    text-decoration: underline;
}

@media (max-width: 960px) {
    .el-customer-mode .coast-details .cd-layout {
        grid-template-columns: minmax(220px,.75fr) minmax(0,1.25fr);
        gap: 16px;
    }

    .el-customer-mode .coast-details .cd-information {
        padding: 23px;
    }
}

@media (max-width: 760px) {
    .el-customer-mode .coast-details .cd-layout {
        grid-template-columns: 1fr;
    }

    .el-customer-mode .coast-details .cd-cover-display {
        min-height: 275px;
    }

    .el-customer-mode .coast-details .cd-cover-display img {
        max-height: 270px;
    }
}

@media (max-width: 520px) {
    .el-customer-mode .coast-details .cd-cover-panel {
        padding: 20px;
    }

    .el-customer-mode .coast-details .cd-information,
    .el-customer-mode .coast-details .cd-description {
        padding: 19px;
    }

    .el-customer-mode .coast-details .cd-title {
        font-size: 28px;
    }

    .el-customer-mode .coast-details .cd-actions {
        flex-direction: column;
        align-items: stretch;
    }

    .el-customer-mode .coast-details .cd-actions .cd-btn {
        width: 100%;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="coast-details">

    <!-- BREADCRUMB -->
    <nav class="cd-breadcrumb"
        aria-label="Breadcrumb">

        <a href="<%= ResolveUrl("~/CustomerHome.aspx") %>">
            Home
        </a>

        <span>/</span>

        <a href="<%= ResolveUrl("~/Customer/Books.aspx") %>">
            Browse Books
        </a>

        <span>/</span>

        <strong>Book Details</strong>

    </nav>

    <!-- BOOK INFORMATION LAYOUT -->
    <div class="cd-layout">

        <!-- BOOK COVER -->
        <section class="cd-cover-panel">

            <div class="cd-cover-display">

                <asp:Image
                    ID="imgBookCover"
                    runat="server"
                    AlternateText="Book cover" />

            </div>

            <span class="cd-cover-caption">
                ELIBRARY COLLECTION
            </span>

        </section>

        <!-- DETAILS & RESERVATION -->
        <section class="cd-information">

            <span class="cd-eyebrow">
                DISCOVER THE BOOK
            </span>

            <div class="cd-genre">
                <asp:Label
                    ID="lblGenre"
                    runat="server" />
            </div>

            <h1 class="cd-title">
                <asp:Label
                    ID="lblTitle"
                    runat="server" />
            </h1>

            <p class="cd-author">
                by
                <strong>
                    <asp:Label
                        ID="lblAuthor"
                        runat="server" />
                </strong>
            </p>

            <div class="cd-divider"></div>

            <!-- STOCK AVAILABILITY -->
            <div class="cd-availability">

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

            <!-- BORROWING FEE -->
            <div class="cd-fee-panel">

                <div>
                    <span class="cd-fee-label">
                        Borrowing Fee
                    </span>

                    <strong class="cd-fee-value">
                        ₱<asp:Label
                            ID="lblBorrowingFee"
                            runat="server"
                            Text="0.00" />
                    </strong>
                </div>

                <span class="cd-fee-note">
                    The seven-day borrowing period starts
                    when a librarian confirms collection.
                </span>

            </div>

            <!-- HOW RESERVATION WORKS -->
            <div class="cd-explainer">

                <strong>
                    How Book Reservation Works
                </strong>

                <p>
                    Reserve an available book online,
                    then collect it at the library.
                    A librarian confirms the collection,
                    which starts your seven-day borrowing period.
                </p>

            </div>

            <!-- SUCCESS / ERROR -->
            <asp:Label
                ID="lblMessage"
                runat="server"
                EnableViewState="false"
                CssClass="cd-message"
                role="status"
                aria-live="polite" />

            <!-- ACTION BUTTONS -->
            <div class="cd-actions">

                <asp:Button
                    ID="btnBorrow"
                    runat="server"
                    Text="Reserve Book"
                    CssClass="cd-btn cd-btn-primary"
                    CausesValidation="false"
                    OnClick="btnBorrow_Click"
                    OnClientClick="return confirm('Reserve this book for library pickup?');" />

                <asp:Button
                    ID="btnBack"
                    runat="server"
                    Text="Back to Books"
                    CssClass="cd-btn"
                    CausesValidation="false"
                    OnClick="btnBack_Click" />

            </div>

            <div class="cd-divider"></div>

            <!-- METADATA -->
            <div class="cd-metadata">

                <div class="cd-meta-item">
                    <span>ISBN</span>

                    <strong>
                        <asp:Label
                            ID="lblISBN"
                            runat="server" />
                    </strong>
                </div>

                <div class="cd-meta-item">
                    <span>Total Copies</span>

                    <strong>
                        <asp:Label
                            ID="lblTotalCopies"
                            runat="server" />
                    </strong>
                </div>

            </div>

        </section>
    </div>

    <!-- DESCRIPTION -->
    <section class="cd-description">

        <span class="cd-eyebrow">
            ABOUT THIS TITLE
        </span>

        <h2>Book Description</h2>

        <p>
            <asp:Label
                ID="lblDescription"
                runat="server" />
        </p>

    </section>

    <!-- RETURN TO CATALOG -->
    <a class="cd-bottom-link"
        href="<%= ResolveUrl("~/Customer/Books.aspx") %>">
        &larr; Continue Exploring Books
    </a>

</div>

</asp:Content>
