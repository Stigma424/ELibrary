
<%@ Page Title="Customer Borrowing History"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="CustomerBorrowing.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Borrowing.CustomerBorrowing" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<asp:Content ID="HeadContent"
    ContentPlaceHolderID="head"
    runat="server">

<style>
    .cr-page{max-width:1400px;margin:0 auto;color:#123B4A}
    .cr-page *{box-sizing:border-box}
    .cr-back{display:inline-block;margin-bottom:18px;color:#168A91;text-decoration:none;font-size:12px;font-weight:800}
    .cr-eyebrow{color:#168A91;font-size:11px;font-weight:800;letter-spacing:1.4px}
    .cr-header{margin-bottom:24px}
    .cr-header h1{margin:8px 0;font-size:30px;font-weight:850}
    .cr-header p{margin:0;color:#647F89;font-size:13px}
    .cr-panel{background:#fff;border:1px solid #DCE9EB;border-radius:15px;padding:23px;margin-bottom:20px;min-width:0}
    .cr-panel h2{font-size:17px;font-weight:800;margin:0 0 17px}
    .cr-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:15px}
    .cr-field label{display:block;margin-bottom:7px;font-size:12px;font-weight:750}
    .cr-control{width:100%;min-height:43px;border:1px solid #D0E2E5;border-radius:9px;background:#fff;color:#123B4A;padding:10px 12px;font-size:13px}
    .cr-actions{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-top:18px}
    .cr-btn{border:0;border-radius:9px;background:#168A91;color:#fff;padding:12px 20px;font-size:12px;font-weight:800;cursor:pointer}
    .cr-btn:hover{background:#12757C}
    .cr-note{color:#647F89;font-size:12px}
    .cr-error{display:block;color:#B94E49;font-size:12px;margin-top:12px}
    .cr-preview{display:flex;justify-content:space-between;align-items:center;gap:10px;margin-bottom:15px}
    .cr-preview h2{margin:0}
    .cr-count{background:#EAF6F6;color:#12757C;padding:8px 12px;border-radius:8px;font-size:12px;font-weight:800}
    .cr-viewer{width:100%;min-height:650px;overflow-x:auto;border:1px solid #DCE9EB;border-radius:10px}
    .cr-empty{text-align:center;background:#F4F9FA;border:1px solid #DCE9EB;border-radius:13px;padding:30px;color:#647F89;font-size:13px}
    @media(max-width:650px){
        .cr-grid{grid-template-columns:1fr}
        .cr-header h1{font-size:25px}
        .cr-actions{align-items:stretch;flex-direction:column}
        .cr-btn{width:100%}
        .cr-panel{padding:17px}
    }
</style>

</asp:Content>

<asp:Content ID="MainContentBlock"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="cr-page">

    <a class="cr-back"
       href="<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>">
        &#8592; Back to Reports &amp; Analytics
    </a>

    <header class="cr-header">
        <span class="cr-eyebrow">
            ADMINISTRATION / BORROWING REPORTS
        </span>
        <h1>Customer Borrowing History</h1>
        <p>
            Review customer borrowing transactions
            within a selected period.
        </p>
    </header>

    <section class="cr-panel">
        <h2>Report Filters</h2>

        <div class="cr-grid">

            <div class="cr-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtDateFrom"
                    Text="Date From" />
                <asp:TextBox ID="txtDateFrom"
                    runat="server"
                    TextMode="Date"
                    CssClass="cr-control" />
            </div>

            <div class="cr-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtDateTo"
                    Text="Date To" />
                <asp:TextBox ID="txtDateTo"
                    runat="server"
                    TextMode="Date"
                    CssClass="cr-control" />
            </div>

            <div class="cr-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtCustomer"
                    Text="Customer Name or Email" />
                <asp:TextBox ID="txtCustomer"
                    runat="server"
                    CssClass="cr-control"
                    MaxLength="150"
                    placeholder="Leave blank for all customers" />
            </div>

            <div class="cr-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlStatus"
                    Text="Borrowing Status" />
                <asp:DropDownList ID="ddlStatus"
                    runat="server"
                    CssClass="cr-control">
                    <asp:ListItem Text="All Statuses" Value="" />
                    <asp:ListItem Text="Borrowed" Value="Borrowed" />
                    <asp:ListItem Text="Overdue" Value="Overdue" />
                    <asp:ListItem Text="Returned" Value="Returned" />
                    <asp:ListItem Text="Lost" Value="Lost" />
                    <asp:ListItem Text="Cancelled" Value="Cancelled" />
                </asp:DropDownList>
            </div>
        </div>

        <div class="cr-actions">
            <span class="cr-note">
                Filters apply only when you generate the report.
            </span>
            <asp:Button ID="btnGenerate"
                runat="server"
                Text="Generate Report"
                CssClass="cr-btn"
                OnClick="btnGenerate_Click" />
        </div>

        <asp:Label ID="lblMessage"
            runat="server"
            CssClass="cr-error"
            EnableViewState="false" />
    </section>

    <asp:Panel ID="pnlReport"
        runat="server"
        CssClass="cr-panel"
        Visible="false">

        <div class="cr-preview">
            <h2>Customer Borrowing Records</h2>
            <asp:Label ID="lblCount"
                runat="server"
                CssClass="cr-count" />
        </div>

        <div class="cr-viewer">
            <asp:ScriptManager ID="smReport"
                runat="server" />

            <rsweb:ReportViewer ID="rvReport"
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

    <asp:Panel ID="pnlEmpty"
        runat="server"
        CssClass="cr-empty">
        Select your filters and click
        <strong>Generate Report</strong>.
    </asp:Panel>

</div>

</asp:Content>
