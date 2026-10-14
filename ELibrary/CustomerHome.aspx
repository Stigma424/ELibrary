
<%@ Page Title="Customer Dashboard"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="CustomerHome.aspx.cs"
    Inherits="ELibrary.CustomerHome" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="el-customer-dashboard">

        <section class="el-customer-hero">
            <div class="el-customer-hero-content">

                <span class="el-customer-eyebrow">
                    YOUR PERSONAL LIBRARY
                </span>

                <h1>
                    Welcome back,
                    <asp:Label ID="lblFullName"
                        runat="server" />!
                </h1>

                <p>
                    Discover your next favorite book,
                    manage your reservations, and keep
                    your reading journey on track.
                </p>

                <div class="el-customer-hero-actions">

                    <a href="<%= ResolveUrl("~/Customer/Books.aspx") %>"
                       class="el-customer-btn el-customer-btn-light">
                        Explore Books →
                    </a>

                    <a href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>"
                       class="el-customer-btn el-customer-btn-outline-light">
                        My Borrowings
                    </a>

                </div>
            </div>

            <div class="el-customer-hero-art"
                 aria-hidden="true">
                <div class="el-hero-circle"></div>
                <div class="el-hero-book el-hero-book-one"></div>
                <div class="el-hero-book el-hero-book-two"></div>
                <div class="el-hero-book el-hero-book-three"></div>
                <div class="el-hero-book el-hero-book-four"></div>
            </div>
        </section>

        <asp:Label ID="lblMessage"
            runat="server"
            EnableViewState="false"
            CssClass="el-customer-message" />

        <section class="el-customer-section">

            <div class="el-customer-section-heading">
                <div>
                    <span class="el-section-eyebrow">
                        YOUR ACTIVITY
                    </span>

                    <h2>Library Overview</h2>

                    <p>
                        Your reservations, collected books,
                        and borrowing history.
                    </p>
                </div>
            </div>

            <div class="el-customer-stats">

                <a class="el-customer-stat"
                   href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>">
                    <div class="el-stat-icon el-stat-icon-orange">
                        <span aria-hidden="true">◷</span>
                    </div>
                    <div class="el-stat-info">
                        <span>Pending Pickups</span>
                        <strong>
                            <asp:Label ID="lblPendingPickups"
                                runat="server" Text="0" />
                        </strong>
                        <small>Reserved, awaiting collection</small>
                    </div>
                </a>

                <a class="el-customer-stat"
                   href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>">
                    <div class="el-stat-icon el-stat-icon-blue">
                        <span aria-hidden="true">📖</span>
                    </div>
                    <div class="el-stat-info">
                        <span>Active Borrowings</span>
                        <strong>
                            <asp:Label ID="lblActiveBorrowings"
                                runat="server" Text="0" />
                        </strong>
                        <small>Books you have collected</small>
                    </div>
                </a>

                <a class="el-customer-stat"
                   href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>">
                    <div class="el-stat-icon el-stat-icon-red">
                        <span aria-hidden="true">⏰</span>
                    </div>
                    <div class="el-stat-info">
                        <span>Overdue Books</span>
                        <strong>
                            <asp:Label ID="lblOverdueBooks"
                                runat="server" Text="0" />
                        </strong>
                        <small>Need your attention</small>
                    </div>
                </a>

                <a class="el-customer-stat"
                   href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>">
                    <div class="el-stat-icon el-stat-icon-orange">
                        <span aria-hidden="true">↩</span>
                    </div>
                    <div class="el-stat-info">
                        <span>Pending Returns</span>
                        <strong>
                            <asp:Label ID="lblPendingReturns"
                                runat="server" Text="0" />
                        </strong>
                        <small>Awaiting librarian confirmation</small>
                    </div>
                </a>

                <a class="el-customer-stat"
                   href="<%= ResolveUrl("~/Customer/BorrowHistory.aspx") %>">
                    <div class="el-stat-icon el-stat-icon-green">
                        <span aria-hidden="true">✓</span>
                    </div>
                    <div class="el-stat-info">
                        <span>Returned Books</span>
                        <strong>
                            <asp:Label ID="lblReturnedBooks"
                                runat="server" Text="0" />
                        </strong>
                        <small>Completed borrowings</small>
                    </div>
                </a>

                <a class="el-customer-stat"
                   href="<%= ResolveUrl("~/Customer/BorrowHistory.aspx") %>">
                    <div class="el-stat-icon el-stat-icon-red">
                        <span aria-hidden="true">×</span>
                    </div>
                    <div class="el-stat-info">
                        <span>Cancelled Reservations</span>
                        <strong>
                            <asp:Label ID="lblCancelledReservations"
                                runat="server" Text="0" />
                        </strong>
                        <small>Reservations cancelled before pickup</small>
                    </div>
                </a>

                <a class="el-customer-stat"
                   href="<%= ResolveUrl("~/Customer/MyTransactions.aspx") %>">
                    <div class="el-stat-icon el-stat-icon-purple">
                        <span aria-hidden="true">₱</span>
                    </div>
                    <div class="el-stat-info">
                        <span>Unpaid Balance</span>
                        <strong class="el-stat-balance">
                            ₱<asp:Label ID="lblUnpaidBalance"
                                runat="server" Text="0.00" />
                        </strong>
                        <small>View transactions</small>
                    </div>
                </a>

            </div>
        </section>

        <section class="el-customer-section">

            <div class="el-customer-section-heading">
                <div>
                    <span class="el-section-eyebrow">
                        DISCOVER SOMETHING NEW
                    </span>

                    <h2>Explore Our Collection</h2>

                    <p>
                        Browse books available in our library.
                    </p>
                </div>

                <a href="<%= ResolveUrl("~/Customer/Books.aspx") %>"
                   class="el-section-view-all">
                    View All Books →
                </a>
            </div>

            <asp:Panel ID="pnlFeaturedBooks"
                runat="server">

                <div class="el-customer-book-grid">

                    <asp:Repeater ID="rptFeaturedBooks"
                        runat="server">

                        <ItemTemplate>

                            <article class="el-customer-book-card">

                                <a href='<%# GetBookDetailsUrl(Eval("BookID")) %>'
                                   class="el-customer-book-cover">

                                    <asp:Image
                                        runat="server"
                                        ImageUrl='<%# GetCoverUrl(Eval("CoverImagePath")) %>'
                                        AlternateText='<%# Eval("Title") %>' />

                                </a>

                                <div class="el-customer-book-info">

                                    <span class="el-book-genre">
                                        <%#: Eval("GenreName") %>
                                    </span>

                                    <h3>
                                        <a href='<%# GetBookDetailsUrl(Eval("BookID")) %>'>
                                            <%#: Eval("Title") %>
                                        </a>
                                    </h3>

                                    <p class="el-book-author">
                                        <%#: Eval("Author") %>
                                    </p>

                                    <div class="el-book-bottom">

                                        <span class='<%# GetAvailabilityClass(Eval("AvailableCopies")) %>'>
                                            <%# GetAvailabilityText(Eval("AvailableCopies")) %>
                                        </span>

                                        <a href='<%# GetBookDetailsUrl(Eval("BookID")) %>'
                                           class="el-book-details-link">
                                            Details →
                                        </a>

                                    </div>
                                </div>

                            </article>

                        </ItemTemplate>

                    </asp:Repeater>

                </div>

            </asp:Panel>

            <asp:Panel ID="pnlNoFeaturedBooks"
                runat="server"
                Visible="false"
                CssClass="el-customer-empty">

                <span class="el-empty-icon">📚</span>

                <h3>No books available yet</h3>

                <p>
                    New books will appear here once
                    they are added to the catalog.
                </p>

            </asp:Panel>

        </section>

        <section class="el-customer-section">

            <div class="el-customer-section-heading">
                <div>
                    <span class="el-section-eyebrow">
                        SHORTCUTS
                    </span>

                    <h2>Quick Actions</h2>

                    <p>
                        Jump straight to the things you need.
                    </p>
                </div>
            </div>

            <div class="el-customer-actions-grid">

                <a href="<%= ResolveUrl("~/Customer/Books.aspx") %>"
                   class="el-customer-action-card">
                    <div class="el-action-icon">📚</div>
                    <strong>Browse Books</strong>
                    <span>Explore the catalog</span>
                    <small>Explore →</small>
                </a>

                <a href="<%= ResolveUrl("~/Customer/MyBorrows.aspx") %>"
                   class="el-customer-action-card">
                    <div class="el-action-icon">📖</div>
                    <strong>My Borrowings</strong>
                    <span>Reservations and active loans</span>
                    <small>View →</small>
                </a>

                <a href="<%= ResolveUrl("~/Customer/BorrowHistory.aspx") %>"
                   class="el-customer-action-card">
                    <div class="el-action-icon">🕘</div>
                    <strong>Borrowing History</strong>
                    <span>Returned and cancelled records</span>
                    <small>View →</small>
                </a>

                <a href="<%= ResolveUrl("~/Customer/MyTransactions.aspx") %>"
                   class="el-customer-action-card">
                    <div class="el-action-icon">💳</div>
                    <strong>My Transactions</strong>
                    <span>View fees and payments</span>
                    <small>View →</small>
                </a>

                <a href="<%= ResolveUrl("~/Customer/Profile.aspx") %>"
                   class="el-customer-action-card">
                    <div class="el-action-icon">👤</div>
                    <strong>My Profile</strong>
                    <span>Manage your account</span>
                    <small>Edit →</small>
                </a>

            </div>
        </section>

    </div>
</asp:Content>
