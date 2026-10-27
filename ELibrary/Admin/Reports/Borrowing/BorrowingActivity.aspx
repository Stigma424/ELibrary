
<%@ Page Title="Borrowing Activity Report"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="BorrowingActivity.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Borrowing.BorrowingActivity" %>

<%@ Register
    Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
    .bra-page {
        max-width: 1400px;
        margin: 0 auto;
        color: #123B4A;
    }

    .bra-page * {
        box-sizing: border-box;
    }

    .bra-back {
        display: inline-block;
        margin-bottom: 20px;
        color: #168A91;
        text-decoration: none;
        font-size: 12px;
        font-weight: 800;
    }

    .bra-back:hover {
        color: #126E75;
        text-decoration: underline;
    }

    .bra-header {
        margin-bottom: 26px;
    }

    .bra-eyebrow {
        display: block;
        margin-bottom: 9px;
        color: #168A91;
        font-size: 11px;
        font-weight: 800;
        letter-spacing: 1.5px;
    }

    .bra-header h1 {
        margin: 0 0 10px;
        color: #123B4A;
        font-size: 30px;
        font-weight: 850;
    }

    .bra-header p {
        max-width: 750px;
        margin: 0;
        color: #647F89;
        font-size: 13px;
        line-height: 1.8;
    }

    .bra-panel {
        background: #FFFFFF;
        border: 1px solid #DCE9EB;
        border-radius: 15px;
        padding: 24px;
        margin-bottom: 22px;
        min-width: 0;
    }

    .bra-panel h2 {
        margin: 0 0 18px;
        font-size: 17px;
        font-weight: 800;
    }

    .bra-filters {
        display: grid;
        grid-template-columns:
            repeat(3, minmax(0, 1fr)) auto;
        gap: 15px;
        align-items: end;
    }

    .bra-field label {
        display: block;
        margin-bottom: 8px;
        font-size: 12px;
        font-weight: 750;
    }

    .bra-control {
        display: block;
        width: 100%;
        min-height: 43px;
        padding: 10px 12px;
        border: 1px solid #D0E2E5;
        border-radius: 9px;
        color: #123B4A;
        background: #FFFFFF;
        font-size: 13px;
    }

    .bra-control:focus {
        outline: 2px solid #168A91;
        outline-offset: 1px;
    }

    .bra-button {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-height: 43px;
        padding: 11px 19px;
        border: none;
        border-radius: 9px;
        background: #168A91;
        color: #FFFFFF;
        font-size: 12px;
        font-weight: 800;
        cursor: pointer;
        white-space: nowrap;
    }

    .bra-button:hover {
        background: #12757C;
    }

    .bra-message {
        display: block;
        margin-top: 15px;
        color: #B94E49;
        font-size: 12px;
    }

    .bra-message:empty {
        display: none;
    }

    .bra-preview-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 15px;
        flex-wrap: wrap;
        margin-bottom: 18px;
    }

    .bra-preview-header h2 {
        margin: 0 0 5px;
    }

    .bra-preview-note {
        color: #647F89;
        font-size: 11px;
    }

    .bra-record-count {
        display: inline-flex;
        padding: 8px 12px;
        border-radius: 8px;
        background: #EAF6F6;
        color: #12757C;
        font-size: 12px;
        font-weight: 800;
    }

    .bra-viewer {
        width: 100%;
        min-height: 650px;
        overflow-x: auto;
        border: 1px solid #E0EAEC;
        border-radius: 10px;
        background: #FFFFFF;
    }

    .bra-empty {
        padding: 34px 24px;
        border: 1px solid #DCE9EB;
        border-radius: 13px;
        background: #F4F9FA;
        text-align: center;
        color: #647F89;
        font-size: 13px;
    }

    @media (max-width: 1100px) {
        .bra-filters {
            grid-template-columns:
                repeat(2, minmax(0, 1fr));
        }
    }

    @media (max-width: 650px) {
        .bra-filters {
            grid-template-columns: 1fr;
        }

        .bra-header h1 {
            font-size: 25px;
        }

        .bra-panel {
            padding: 17px;
        }

        .bra-button {
            width: 100%;
        }
    }
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="bra-page">

    <a class="bra-back"
       href="<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>">
        &#8592; Back to Reports &amp; Analytics
    </a>

    <header class="bra-header">

        <span class="bra-eyebrow">
            ADMINISTRATION / BORROWING REPORTS
        </span>

        <h1>Borrowing Activity Report</h1>

        <p>
            Generate a detailed report of borrowing
            transactions, including reservations,
            collected loans, returns, cancellations,
            overdue records and lost books.
        </p>

    </header>

    <section class="bra-panel">

        <h2>Report Filters</h2>

        <div class="bra-filters">

            <div class="bra-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="txtDateFrom"
                    Text="Date From" />

                <asp:TextBox
                    ID="txtDateFrom"
                    runat="server"
                    TextMode="Date"
                    CssClass="bra-control" />
            </div>

            <div class="bra-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="txtDateTo"
                    Text="Date To" />

                <asp:TextBox
                    ID="txtDateTo"
                    runat="server"
                    TextMode="Date"
                    CssClass="bra-control" />
            </div>

            <div class="bra-field">
                <asp:Label
                    runat="server"
                    AssociatedControlID="ddlStatus"
                    Text="Borrowing Status" />

                <asp:DropDownList
                    ID="ddlStatus"
                    runat="server"
                    CssClass="bra-control">

                    <asp:ListItem
                        Text="All Statuses"
                        Value="" />

                    <asp:ListItem
                        Text="Borrowed"
                        Value="Borrowed" />

                    <asp:ListItem
                        Text="Overdue"
                        Value="Overdue" />

                    <asp:ListItem
                        Text="Returned"
                        Value="Returned" />

                    <asp:ListItem
                        Text="Lost"
                        Value="Lost" />

                    <asp:ListItem
                        Text="Cancelled"
                        Value="Cancelled" />

                </asp:DropDownList>
            </div>

            <asp:Button
                ID="btnGenerate"
                runat="server"
                Text="Generate Report"
                CssClass="bra-button"
                OnClick="btnGenerate_Click" />

        </div>

        <asp:Label
            ID="lblMessage"
            runat="server"
            CssClass="bra-message"
            EnableViewState="false" />

    </section>

    <asp:Panel
        ID="pnlReport"
        runat="server"
        CssClass="bra-panel"
        Visible="false">

        <div class="bra-preview-header">

            <div>
                <h2>Report Preview</h2>

                <span class="bra-preview-note">
                    Use the toolbar to print or export.
                </span>
            </div>

            <asp:Label
                ID="lblRecordCount"
                runat="server"
                CssClass="bra-record-count" />

        </div>

        <div class="bra-viewer">

            <asp:ScriptManager
                ID="smBorrowingReport"
                runat="server" />

            <rsweb:ReportViewer
                ID="rvBorrowing"
                runat="server"
                ProcessingMode="Local"
                Width="100%"
                Height="650px"
                AsyncRendering="false"
                SizeToReportContent="false"
                ShowExportControls="true"
                ShowRefreshButton="false"
                ShowParameterPrompts="false" />

        </div>

    </asp:Panel>

    <asp:Panel
        ID="pnlEmpty"
        runat="server"
        CssClass="bra-empty">

        Choose your reporting period and click
        <strong>Generate Report</strong>
        to display borrowing records.

    </asp:Panel>

</div>

</asp:Content>
