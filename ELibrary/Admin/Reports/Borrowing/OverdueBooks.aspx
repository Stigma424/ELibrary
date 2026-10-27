
<%@ Page Title="Overdue Books Report"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="OverdueBooks.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Borrowing.OverdueBooks" %>

<%@ Register
    Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="head"
    runat="server">

<style>
    .ov-page {
        max-width: 1400px;
        margin: 0 auto;
        color: #123B4A;
    }

    .ov-page * {
        box-sizing: border-box;
    }

    .ov-back {
        display: inline-block;
        margin-bottom: 20px;
        color: #168A91;
        font-size: 12px;
        font-weight: 800;
        text-decoration: none;
    }

    .ov-back:hover {
        color: #12757C;
        text-decoration: underline;
    }

    .ov-header {
        margin-bottom: 26px;
    }

    .ov-eyebrow {
        display: block;
        margin-bottom: 10px;
        color: #168A91;
        font-size: 11px;
        font-weight: 800;
        letter-spacing: 1.5px;
    }

    .ov-header h1 {
        margin: 0 0 10px;
        font-size: 30px;
        font-weight: 850;
    }

    .ov-header p {
        max-width: 760px;
        margin: 0;
        color: #647F89;
        font-size: 13px;
        line-height: 1.8;
    }

    .ov-panel {
        min-width: 0;
        margin-bottom: 22px;
        padding: 24px;
        border: 1px solid #DCE9EB;
        border-radius: 15px;
        background: #FFFFFF;
    }

    .ov-panel h2 {
        margin: 0 0 17px;
        font-size: 17px;
        font-weight: 800;
    }

    .ov-filters {
        display: grid;
        grid-template-columns:
            minmax(0, 2fr)
            minmax(0, 1fr)
            auto;
        gap: 15px;
        align-items: end;
    }

    .ov-field label {
        display: block;
        margin-bottom: 8px;
        font-size: 12px;
        font-weight: 750;
    }

    .ov-control {
        display: block;
        width: 100%;
        min-height: 44px;
        padding: 10px 12px;
        border: 1px solid #D0E2E5;
        border-radius: 9px;
        background: #FFFFFF;
        color: #123B4A;
        font-size: 13px;
    }

    .ov-control:focus {
        outline: 2px solid #168A91;
        outline-offset: 1px;
    }

    .ov-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-height: 44px;
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

    .ov-btn:hover {
        background: #12757C;
    }

    .ov-note {
        margin-top: 14px;
        color: #647F89;
        font-size: 12px;
        line-height: 1.7;
    }

    .ov-error {
        display: block;
        margin-top: 12px;
        color: #B94E49;
        font-size: 12px;
    }

    .ov-error:empty {
        display: none;
    }

    .ov-preview-heading {
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 14px;
        margin-bottom: 17px;
    }

    .ov-preview-heading h2 {
        margin: 0 0 6px;
    }

    .ov-meta {
        color: #647F89;
        font-size: 12px;
    }

    .ov-count {
        display: inline-block;
        padding: 9px 13px;
        border-radius: 9px;
        background: #EAF6F6;
        color: #12757C;
        font-size: 12px;
        font-weight: 800;
    }

    .ov-viewer {
        width: 100%;
        min-height: 650px;
        overflow-x: auto;
        border: 1px solid #DCE9EB;
        border-radius: 10px;
        background: #FFFFFF;
    }

    .ov-empty {
        padding: 34px 22px;
        background: #F4F9FA;
        border: 1px solid #DCE9EB;
        border-radius: 13px;
        text-align: center;
        color: #647F89;
        font-size: 13px;
    }

    @media (max-width: 900px) {
        .ov-filters {
            grid-template-columns:
                repeat(2, minmax(0, 1fr));
        }

        .ov-search {
            grid-column: 1 / -1;
        }
    }

    @media (max-width: 600px) {
        .ov-filters {
            grid-template-columns: 1fr;
        }

        .ov-search {
            grid-column: auto;
        }

        .ov-header h1 {
            font-size: 25px;
        }

        .ov-panel {
            padding: 17px;
        }

        .ov-btn {
            width: 100%;
        }
    }
</style>

</asp:Content>

<asp:Content ID="Content2"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="ov-page">

    <a class="ov-back"
       href="<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>">
        &#8592; Back to Reports &amp; Analytics
    </a>

    <header class="ov-header">

        <span class="ov-eyebrow">
            ADMINISTRATION / BORROWING REPORTS
        </span>

        <h1>Overdue Books Report</h1>

        <p>
            Identify books that have not been returned
            after their due date. View responsible
            borrowers, due dates, overdue days and
            borrowing channels.
        </p>

    </header>

    <section class="ov-panel">

        <h2>Report Filters</h2>

        <div class="ov-filters">

            <div class="ov-field ov-search">

                <asp:Label
                    runat="server"
                    AssociatedControlID="txtSearch"
                    Text="Search Book or Customer" />

                <asp:TextBox
                    ID="txtSearch"
                    runat="server"
                    CssClass="ov-control"
                    MaxLength="150"
                    placeholder="Book title, author, customer or email" />

            </div>

            <div class="ov-field">

                <asp:Label
                    runat="server"
                    AssociatedControlID="ddlMinimumDays"
                    Text="Minimum Days Overdue" />

                <asp:DropDownList
                    ID="ddlMinimumDays"
                    runat="server"
                    CssClass="ov-control">

                    <asp:ListItem
                        Text="1 day or more"
                        Value="1" />

                    <asp:ListItem
                        Text="3 days or more"
                        Value="3" />

                    <asp:ListItem
                        Text="7 days or more"
                        Value="7" />

                    <asp:ListItem
                        Text="14 days or more"
                        Value="14" />

                    <asp:ListItem
                        Text="30 days or more"
                        Value="30" />

                </asp:DropDownList>

            </div>

            <asp:Button
                ID="btnGenerate"
                runat="server"
                Text="Generate Report"
                CssClass="ov-btn"
                OnClick="btnGenerate_Click" />

        </div>

        <p class="ov-note">
            The report uses the current date.
            Searching or changing a filter only
            applies when you press Enter or click
            Generate Report.
        </p>

        <asp:Label
            ID="lblMessage"
            runat="server"
            CssClass="ov-error"
            EnableViewState="false" />

    </section>

    <asp:Panel
        ID="pnlReport"
        runat="server"
        CssClass="ov-panel"
        Visible="false">

        <div class="ov-preview-heading">

            <div>
                <h2>Overdue Records</h2>

                <span class="ov-meta">
                    Printable current overdue snapshot
                </span>
            </div>

            <asp:Label
                ID="lblRecordCount"
                runat="server"
                CssClass="ov-count" />

        </div>

        <div class="ov-viewer">

            <asp:ScriptManager
                ID="smOverdue"
                runat="server" />

            <rsweb:ReportViewer
                ID="rvOverdue"
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
        CssClass="ov-empty">

        Click <strong>Generate Report</strong>
        to view the library's currently overdue books.

    </asp:Panel>

</div>

</asp:Content>
