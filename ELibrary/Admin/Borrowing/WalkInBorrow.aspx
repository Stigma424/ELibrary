
<%@ Page Title="Walk-in Borrowing"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="WalkInBorrow.aspx.cs"
    Inherits="ELibrary.Admin.Borrowing.WalkInBorrow" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
/* INTERNSHIPELIB - OCEAN TEAL WALK-IN BORROWING */

.el-walkin {
    --wi-primary: #123B4A;
    --wi-teal: #168A91;
    --wi-hover: #12757C;
    --wi-muted: #647F89;
    --wi-border: #DCE9EB;
    --wi-soft: #F5FAFA;
    display: flex;
    flex-direction: column;
    gap: 20px;
    max-width: 1180px;
    margin: 0 auto;
    padding-bottom: 35px;
    color: var(--wi-primary);
}

.el-walkin *,
.el-walkin *::before,
.el-walkin *::after {
    box-sizing: border-box;
}

.el-walkin .wi-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 14px;
    flex-wrap: wrap;
    padding: 4px 0;
}

.el-walkin .wi-eyebrow {
    display: block;
    color: var(--wi-teal);
    font-size: 10px;
    font-weight: 800;
    letter-spacing: .12em;
    margin-bottom: 8px;
}

.el-walkin .wi-header h1 {
    margin: 0 0 7px;
    color: var(--wi-primary);
    font-size: 29px;
    font-weight: 800;
}

.el-walkin .wi-header p,
.el-walkin .wi-description {
    margin: 0;
    color: var(--wi-muted);
    font-size: 12px;
    line-height: 1.7;
}

.el-walkin .wi-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 41px;
    padding: 9px 16px;
    border: 1px solid var(--wi-border);
    border-radius: 9px;
    background: #FFFFFF;
    color: var(--wi-primary);
    font-size: 12px;
    font-weight: 750;
    line-height: 1.5;
    text-decoration: none;
    cursor: pointer;
}

.el-walkin .wi-btn:hover {
    background: #EAF5F6;
    color: var(--wi-primary);
    border-color: #B4DADD;
}

.el-walkin .wi-btn-primary {
    background: var(--wi-teal);
    color: #FFFFFF;
    border-color: var(--wi-teal);
}

.el-walkin .wi-btn-primary:hover {
    background: var(--wi-hover);
    border-color: var(--wi-hover);
    color: #FFFFFF;
}

.el-walkin .wi-btn:disabled {
    opacity: .5;
    cursor: default;
}

.el-walkin .wi-card {
    min-width: 0;
    padding: 23px;
    background: #FFFFFF;
    border: 1px solid var(--wi-border);
    border-radius: 14px;
    box-shadow: 0 3px 14px rgba(18,59,74,.035);
    scroll-margin-top: 100px;
}

.el-walkin .wi-card-head {
    display: flex;
    align-items: flex-start;
    gap: 14px;
    margin-bottom: 20px;
}

.el-walkin .wi-step {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    width: 43px;
    height: 43px;
    border-radius: 12px;
    background: #E4F5F5;
    color: #126E73;
    font-size: 13px;
    font-weight: 850;
}

.el-walkin .wi-card-head h2 {
    margin: 0 0 5px;
    color: var(--wi-primary);
    font-size: 18px;
    font-weight: 800;
}

.el-walkin .wi-search-row {
    display: flex;
    align-items: flex-end;
    flex-wrap: wrap;
    gap: 12px;
}

.el-walkin .wi-field {
    flex: 1;
    min-width: 200px;
}

.el-walkin .wi-field label {
    display: block;
    color: #375968;
    font-size: 12px;
    font-weight: 700;
    margin-bottom: 7px;
}

.el-walkin .wi-input {
    display: block;
    width: 100%;
    min-height: 42px;
    padding: 10px 12px;
    border: 1px solid #CFE1E4;
    border-radius: 9px;
    background: #FFFFFF;
    color: var(--wi-primary);
    font-size: 12px;
}

.el-walkin .wi-input:focus {
    outline: none;
    border-color: var(--wi-teal);
    box-shadow: 0 0 0 3px rgba(22,138,145,.12);
}

.el-walkin .wi-search-note {
    display: block;
    margin: 10px 0 0;
    color: var(--wi-muted);
    font-size: 11px;
}

.el-walkin .wi-message {
    display: block;
    margin: 15px 0;
    padding: 13px 16px;
    border-radius: 9px;
    font-size: 12px;
    line-height: 1.7;
}

.el-walkin .wi-message.success {
    color: #236747;
    background: #E9F7F1;
    border: 1px solid #C8E8D7;
    border-left: 4px solid #28845B;
}

.el-walkin .wi-message.error {
    color: #9E3E39;
    background: #FFF0EF;
    border: 1px solid #F2D3CF;
    border-left: 4px solid #C34D46;
}

.el-walkin .wi-table-wrap {
    overflow-x: auto;
    width: 100%;
    margin-top: 16px;
    border: 1px solid var(--wi-border);
    border-radius: 10px;
}

.el-walkin .wi-table {
    width: 100%;
    min-width: 580px;
    border-collapse: collapse;
    font-size: 12px;
}

.el-walkin .wi-table th {
    padding: 13px;
    background: var(--wi-soft);
    color: #496B75;
    font-size: 11px;
    font-weight: 800;
    text-align: left;
    border-bottom: 1px solid var(--wi-border);
}

.el-walkin .wi-table td {
    padding: 13px;
    color: #47616D;
    vertical-align: middle;
    border-bottom: 1px solid #EDF3F4;
}

.el-walkin .wi-table tr:hover td {
    background: #F9FCFC;
}

.el-walkin .wi-select-btn {
    min-height: 34px;
    padding: 7px 12px;
    color: #126E73;
    background: #E9F6F6;
    border: 1px solid #CCE7E8;
    border-radius: 8px;
    font-size: 11px;
    font-weight: 750;
    cursor: pointer;
}

.el-walkin .wi-select-btn:hover {
    background: #DDF0F1;
}

.el-walkin .wi-empty {
    display: block;
    margin-top: 15px;
    color: var(--wi-muted);
    font-size: 12px;
}

.el-walkin .wi-selected {
    display: flex;
    flex-direction: column;
    gap: 5px;
    margin-top: 17px;
    padding: 15px 17px;
    background: #EAF6F6;
    border: 1px solid #CDE7E9;
    border-radius: 10px;
    color: #315D67;
    overflow-wrap: anywhere;
}

.el-walkin .wi-selected strong {
    color: #106B70;
    font-size: 12px;
}

.el-walkin .wi-selected span {
    font-size: 13px;
    line-height: 1.6;
}

.el-walkin .wi-actions {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;
    margin-top: 19px;
}

.el-walkin .wi-review-grid {
    display: grid;
    grid-template-columns: repeat(2,minmax(0,1fr));
    gap: 12px;
    margin: 18px 0;
}

.el-walkin .wi-review-item {
    min-width: 0;
    padding: 18px;
    border: 1px solid var(--wi-border);
    border-radius: 10px;
    background: var(--wi-soft);
}

.el-walkin .wi-review-item span {
    display: block;
    margin-bottom: 9px;
    color: var(--wi-muted);
    font-size: 11px;
    font-weight: 700;
}

.el-walkin .wi-review-item strong {
    color: var(--wi-primary);
    font-size: 15px;
    font-weight: 800;
    overflow-wrap: anywhere;
}

.el-walkin .wi-warning {
    padding: 15px 17px;
    background: #FFF8EF;
    border: 1px solid #F2D9C0;
    border-radius: 10px;
    color: #875C29;
    font-size: 12px;
    line-height: 1.8;
}

.el-walkin .wi-finish {
    border-color: #BFDADB;
    background: linear-gradient(
        125deg,
        #FFFFFF 0%,
        #F0FAFA 100%
    );
}

.el-walkin .wi-progress {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 12px;
}

.el-walkin .wi-progress-item {
    display: inline-flex;
    align-items: center;
    padding: 7px 11px;
    border-radius: 999px;
    background: #EAF6F6;
    color: #126E73;
    font-size: 11px;
    font-weight: 750;
}

.el-walkin .wi-progress-arrow {
    color: #82A7AA;
    font-size: 12px;
}

@media(max-width:650px) {
    .el-walkin .wi-header h1 {
        font-size: 24px;
    }

    .el-walkin .wi-card {
        padding: 16px;
    }

    .el-walkin .wi-search-row {
        align-items: stretch;
        flex-direction: column;
    }

    .el-walkin .wi-field {
        width: 100%;
        min-width: 0;
    }

    .el-walkin .wi-search-row .wi-btn {
        width: 100%;
    }

    .el-walkin .wi-review-grid {
        grid-template-columns: 1fr;
    }

    .el-walkin .wi-actions .wi-btn {
        flex: 1;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="el-walkin">

    <!-- PAGE HEADER -->

    <header class="wi-header">
        <div>
            <span class="wi-eyebrow">
                ADMINISTRATION / BORROWING MANAGEMENT
            </span>

            <h1>Walk-in Borrowing</h1>

            <p>
                Issue a book directly to a registered customer
                at the library counter.
            </p>

            <div class="wi-progress">
                <span class="wi-progress-item">01 Customer</span>
                <span class="wi-progress-arrow">→</span>
                <span class="wi-progress-item">02 Book</span>
                <span class="wi-progress-arrow">→</span>
                <span class="wi-progress-item">03 Verify</span>
            </div>
        </div>

        <asp:HyperLink
            runat="server"
            NavigateUrl="~/Admin/Borrowing/ManageBorrows.aspx"
            CssClass="wi-btn"
            Text="← Manage Borrowings" />
    </header>

    <!-- STEP ONE: FIND CUSTOMER -->

    <section id="walkinCustomer" class="wi-card">

        <div class="wi-card-head">
            <span class="wi-step">01</span>
            <div>
                <h2>Find Customer</h2>
                <p class="wi-description">
                    Search for a registered customer and confirm
                    their borrowing eligibility.
                </p>
            </div>
        </div>

        <asp:Panel
            ID="pnlCustomerSearch"
            runat="server"
            DefaultButton="btnSearchCustomer">

            <div class="wi-search-row">
                <div class="wi-field">
                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtCustomerSearch"
                        Text="Customer Name or Email" />

                    <asp:TextBox
                        ID="txtCustomerSearch"
                        runat="server"
                        CssClass="wi-input"
                        MaxLength="100"
                        autocomplete="off"
                        placeholder="Enter customer name or email" />
                </div>

                <asp:Button
                    ID="btnSearchCustomer"
                    runat="server"
                    Text="Search Customer"
                    CssClass="wi-btn wi-btn-primary"
                    CausesValidation="false"
                    OnClick="btnSearchCustomer_Click" />
            </div>

            <span class="wi-search-note">
                Search only runs when you press Enter
                or select Search Customer.
            </span>

        </asp:Panel>

        <asp:Label
            ID="lblCustomerMessage"
            runat="server"
            EnableViewState="false"
            Visible="false"
            CssClass="wi-message"
            role="status"
            aria-live="polite" />

        <asp:Panel
            ID="pnlCustomerResults"
            runat="server"
            Visible="false">

            <div class="wi-table-wrap">
                <asp:GridView
                    ID="gvCustomers"
                    runat="server"
                    AutoGenerateColumns="false"
                    DataKeyNames="UserID"
                    CssClass="wi-table"
                    GridLines="None"
                    OnRowCommand="gvCustomers_RowCommand">

                    <Columns>

                        <asp:BoundField
                            DataField="FullName"
                            HeaderText="Customer" />

                        <asp:BoundField
                            DataField="Email"
                            HeaderText="Email" />

                        <asp:TemplateField HeaderText="Eligibility">
                            <ItemTemplate>
                                <%# Convert.ToBoolean(
                                    Eval("IsAllowedToBorrow"))
                                    ? "Allowed"
                                    : "Restricted" %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button
                                    runat="server"
                                    Text="Select"
                                    CommandName="SelectCustomer"
                                    CommandArgument='<%# Eval("UserID") %>'
                                    CssClass="wi-select-btn"
                                    CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>

            <asp:Label
                ID="lblCustomerEmpty"
                runat="server"
                Visible="false"
                CssClass="wi-empty"
                Text="No matching customers found." />

        </asp:Panel>

        <asp:Panel
            ID="pnlSelectedCustomer"
            runat="server"
            Visible="false"
            CssClass="wi-selected">

            <strong>Selected Customer</strong>

            <span>
                <asp:Label
                    ID="lblSelectedCustomer"
                    runat="server" />
            </span>

        </asp:Panel>

    </section>

    <!-- STEP TWO: FIND BOOK -->

    <section id="walkinBook" class="wi-card">

        <div class="wi-card-head">
            <span class="wi-step">02</span>
            <div>
                <h2>Find Book</h2>
                <p class="wi-description">
                    Select a non-archived book with
                    at least one available copy.
                </p>
            </div>
        </div>

        <asp:Panel
            ID="pnlBookSearch"
            runat="server"
            DefaultButton="btnSearchBook">

            <div class="wi-search-row">
                <div class="wi-field">
                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtBookSearch"
                        Text="Book Title, Author, or ISBN" />

                    <asp:TextBox
                        ID="txtBookSearch"
                        runat="server"
                        CssClass="wi-input"
                        MaxLength="255"
                        autocomplete="off"
                        placeholder="Enter book title, author, or ISBN" />
                </div>

                <asp:Button
                    ID="btnSearchBook"
                    runat="server"
                    Text="Search Book"
                    CssClass="wi-btn wi-btn-primary"
                    CausesValidation="false"
                    OnClick="btnSearchBook_Click" />
            </div>

            <span class="wi-search-note">
                Press Enter or select Search Book
                to run the search.
            </span>

        </asp:Panel>

        <asp:Label
            ID="lblBookMessage"
            runat="server"
            EnableViewState="false"
            Visible="false"
            CssClass="wi-message"
            role="status"
            aria-live="polite" />

        <asp:Panel
            ID="pnlBookResults"
            runat="server"
            Visible="false">

            <div class="wi-table-wrap">
                <asp:GridView
                    ID="gvBooks"
                    runat="server"
                    AutoGenerateColumns="false"
                    DataKeyNames="BookID"
                    CssClass="wi-table"
                    GridLines="None"
                    OnRowCommand="gvBooks_RowCommand">

                    <Columns>

                        <asp:BoundField
                            DataField="Title"
                            HeaderText="Book Title" />

                        <asp:BoundField
                            DataField="Author"
                            HeaderText="Author" />

                        <asp:BoundField
                            DataField="AvailableCopies"
                            HeaderText="Available" />

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button
                                    runat="server"
                                    Text="Select"
                                    CommandName="SelectBook"
                                    CommandArgument='<%# Eval("BookID") %>'
                                    CssClass="wi-select-btn"
                                    CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>

            <asp:Label
                ID="lblBookEmpty"
                runat="server"
                Visible="false"
                CssClass="wi-empty"
                Text="No matching books found." />

        </asp:Panel>

        <asp:Panel
            ID="pnlSelectedBook"
            runat="server"
            Visible="false"
            CssClass="wi-selected">

            <strong>Selected Book</strong>

            <span>
                <asp:Label
                    ID="lblSelectedBook"
                    runat="server" />
            </span>

        </asp:Panel>

    </section>

    <!-- STEP THREE: VERIFICATION -->

    <section id="walkinVerify" class="wi-card">

        <div class="wi-card-head">
            <span class="wi-step">03</span>
            <div>
                <h2>Verify Borrowing</h2>
                <p class="wi-description">
                    Check the selected customer and book
                    before creating the loan.
                </p>
            </div>
        </div>

        <asp:Label
            ID="lblVerifyMessage"
            runat="server"
            EnableViewState="false"
            Visible="false"
            CssClass="wi-message"
            role="status"
            aria-live="polite" />

        <div class="wi-actions">
            <asp:Button
                ID="btnVerify"
                runat="server"
                Text="Verify Customer &amp; Book"
                CssClass="wi-btn wi-btn-primary"
                CausesValidation="false"
                OnClick="btnVerify_Click" />

            <asp:Button
                ID="btnClear"
                runat="server"
                Text="Clear Selection"
                CssClass="wi-btn"
                CausesValidation="false"
                OnClick="btnClear_Click" />
        </div>

    </section>

    <!-- CONFIRMATION PANEL -->

    <asp:Panel
        ID="pnlPreview"
        runat="server"
        Visible="false"
        CssClass="wi-card wi-finish"
        ClientIDMode="Static">

        <div class="wi-card-head">
            <span class="wi-step">✓</span>

            <div>
                <h2>Confirm Walk-in Borrowing</h2>
                <p class="wi-description">
                    Review the verified details before
                    handing over the book.
                </p>
            </div>
        </div>

        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false"
            Visible="false"
            CssClass="wi-message"
            role="status"
            aria-live="polite" />

        <div class="wi-review-grid">

            <div class="wi-review-item">
                <span>Customer</span>
                <strong>
                    <asp:Label
                        ID="lblCustomer"
                        runat="server" />
                </strong>
            </div>

            <div class="wi-review-item">
                <span>Book</span>
                <strong>
                    <asp:Label
                        ID="lblBook"
                        runat="server" />
                </strong>
            </div>

            <div class="wi-review-item">
                <span>Available Copies</span>
                <strong>
                    <asp:Label
                        ID="lblAvailable"
                        runat="server" />
                </strong>
            </div>

            <div class="wi-review-item">
                <span>Borrowing Period</span>
                <strong>7 Days</strong>
            </div>

        </div>

        <div class="wi-warning">
            <strong>Before confirming:</strong>
            The system will deduct one available copy,
            mark the book as collected, and create a
            seven-day loan. Hand the book to the customer
            only after the transaction succeeds.
        </div>

        <div class="wi-actions">
            <asp:Button
                ID="btnConfirm"
                runat="server"
                Text="Confirm Walk-in Borrowing"
                CssClass="wi-btn wi-btn-primary"
                CausesValidation="false"
                OnClick="btnConfirm_Click"
                OnClientClick="return confirm('Confirm this walk-in borrowing and hand over the book?');" />
        </div>

    </asp:Panel>

    <!-- COMPLETED TRANSACTION FEEDBACK -->

    <asp:Panel
        ID="pnlCompleted"
        runat="server"
        Visible="false"
        CssClass="wi-card wi-finish"
        ClientIDMode="Static">

        <div class="wi-card-head">
            <span class="wi-step">✓</span>
            <div>
                <h2>Borrowing Result</h2>
                <p class="wi-description">
                    Transaction feedback appears here.
                </p>
            </div>
        </div>

        <asp:Label
            ID="lblCompletedMessage"
            runat="server"
            EnableViewState="false"
            Visible="false"
            CssClass="wi-message"
            role="status"
            aria-live="polite" />

        <asp:HyperLink
            runat="server"
            NavigateUrl="~/Admin/Borrowing/ManageBorrows.aspx"
            CssClass="wi-btn"
            Text="View Borrowing Records" />

    </asp:Panel>

</div>

<asp:HiddenField
    ID="hfFocusTarget"
    runat="server"
    ClientIDMode="Static" />

<script type="text/javascript">
(function () {
    var focus = document.getElementById('hfFocusTarget');

    if (!focus || !focus.value) {
        return;
    }

    var target = document.getElementById(focus.value);

    if (!target) {
        return;
    }

    window.requestAnimationFrame(function () {
        var reduced = window.matchMedia(
            '(prefers-reduced-motion: reduce)').matches;

        target.scrollIntoView({
            behavior: reduced ? 'auto' : 'smooth',
            block: 'start'
        });
    });
})();
</script>

</asp:Content>
