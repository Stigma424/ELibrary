
<%@ Page Title="Lost Book Settlements"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="LostBookSettlements.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Finance.LostBookSettlements" %>

<%@ Register
    Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<asp:Content ID="HeadContent"
    ContentPlaceHolderID="head"
    runat="server">
<style>
    .ls-page{max-width:1400px;margin:auto;color:#123B4A}
    .ls-page *{box-sizing:border-box}
    .ls-back{display:inline-block;color:#168A91;font-size:12px;font-weight:800;text-decoration:none;margin-bottom:18px}
    .ls-header{margin-bottom:24px}
    .ls-eyebrow{color:#168A91;letter-spacing:1.4px;font-size:11px;font-weight:800}
    .ls-header h1{font-size:30px;font-weight:850;margin:8px 0}
    .ls-header p{color:#647F89;font-size:13px;line-height:1.8;margin:0}
    .ls-panel{background:#fff;border:1px solid #DCE9EB;border-radius:15px;padding:23px;margin-bottom:20px;min-width:0}
    .ls-panel h2{font-size:17px;font-weight:800;margin:0 0 17px}
    .ls-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:15px}
    .ls-field label{display:block;font-size:12px;font-weight:750;margin-bottom:8px}
    .ls-input{display:block;width:100%;min-height:43px;border:1px solid #D0E2E5;border-radius:9px;background:#fff;color:#123B4A;padding:10px 12px;font-size:13px}
    .ls-actions{display:flex;justify-content:space-between;align-items:center;gap:12px;margin-top:18px}
    .ls-btn{background:#168A91;border:0;color:#fff;border-radius:9px;min-height:43px;padding:11px 20px;font-size:12px;font-weight:800;cursor:pointer}
    .ls-btn:hover{background:#12757C}
    .ls-note{color:#647F89;font-size:12px;line-height:1.7}
    .ls-error{display:block;color:#B94E49;font-size:12px;margin-top:12px}
    .ls-stats{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:13px;margin-bottom:20px}
    .ls-stat{border:1px solid #DCE9EB;border-radius:13px;background:#fff;padding:19px;min-width:0}
    .ls-stat span{display:block;color:#647F89;font-size:12px;margin-bottom:9px}
    .ls-stat strong{display:block;color:#123B4A;font-size:23px;font-weight:850;overflow-wrap:anywhere}
    .ls-stat.highlight strong{color:#168A91}
    .ls-viewer{min-height:650px;overflow-x:auto;border:1px solid #DCE9EB;border-radius:10px}
    .ls-empty{border:1px solid #DCE9EB;border-radius:13px;background:#F4F9FA;padding:32px;text-align:center;color:#647F89;font-size:13px}
    @media(max-width:850px){.ls-stats{grid-template-columns:1fr}}
    @media(max-width:650px){
        .ls-grid{grid-template-columns:1fr}
        .ls-header h1{font-size:25px}
        .ls-actions{flex-direction:column;align-items:stretch}
        .ls-btn{width:100%}
        .ls-panel{padding:17px}
    }
</style>
</asp:Content>

<asp:Content ID="MainBlock"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="ls-page">
    <a class="ls-back"
       href="<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>">
        &#8592; Back to Reports &amp; Analytics
    </a>

    <header class="ls-header">
        <span class="ls-eyebrow">
            ADMINISTRATION / FINANCIAL REPORTS
        </span>
        <h1>Lost Book Settlements</h1>
        <p>
            Track lost books, associated replacement and late fees,
            current outstanding balances and settlement status.
        </p>
    </header>

    <section class="ls-panel">
        <h2>Report Filters</h2>

        <div class="ls-grid">
            <div class="ls-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtFrom"
                    Text="Lost Date From" />
                <asp:TextBox ID="txtFrom"
                    runat="server"
                    TextMode="Date"
                    CssClass="ls-input" />
            </div>

            <div class="ls-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtTo"
                    Text="Lost Date To" />
                <asp:TextBox ID="txtTo"
                    runat="server"
                    TextMode="Date"
                    CssClass="ls-input" />
            </div>

            <div class="ls-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtSearch"
                    Text="Search Customer or Book" />
                <asp:TextBox ID="txtSearch"
                    runat="server"
                    CssClass="ls-input"
                    MaxLength="150"
                    placeholder="Name, email or book title" />
            </div>

            <div class="ls-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlStatus"
                    Text="Settlement Status" />
                <asp:DropDownList ID="ddlStatus"
                    runat="server"
                    CssClass="ls-input">
                    <asp:ListItem Text="All Settlements" Value="" />
                    <asp:ListItem Text="Fully Paid" Value="Fully Paid" />
                    <asp:ListItem Text="Partially Paid" Value="Partially Paid" />
                    <asp:ListItem Text="Unpaid" Value="Unpaid" />
                    <asp:ListItem Text="No Recorded Charges" Value="No Recorded Charges" />
                </asp:DropDownList>
            </div>
        </div>

        <div class="ls-actions">
            <span class="ls-note">
                Date filters apply to when the book was recorded lost.
                Balances reflect current receipt records.
            </span>
            <asp:Button ID="btnGenerate"
                runat="server"
                Text="Generate Report"
                CssClass="ls-btn"
                OnClick="btnGenerate_Click" />
        </div>

        <asp:Label ID="lblError"
            runat="server"
            CssClass="ls-error"
            EnableViewState="false" />
    </section>

    <asp:Panel ID="pnlResults"
        runat="server"
        Visible="false">

        <div class="ls-stats">
            <div class="ls-stat">
                <span>Lost Book Cases</span>
                <strong><asp:Label ID="lblCases" runat="server" /></strong>
            </div>
            <div class="ls-stat">
                <span>Fully Settled Cases</span>
                <strong><asp:Label ID="lblSettled" runat="server" /></strong>
            </div>
            <div class="ls-stat highlight">
                <span>Total Outstanding</span>
                <strong><asp:Label ID="lblOutstanding" runat="server" /></strong>
            </div>
        </div>

        <section class="ls-panel">
            <h2>Lost Book Settlement Details</h2>

            <div class="ls-viewer">
                <asp:ScriptManager ID="smReport" runat="server" />
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
        </section>
    </asp:Panel>

    <asp:Panel ID="pnlEmpty"
        runat="server"
        CssClass="ls-empty">
        Select your filters and click
        <strong>Generate Report</strong>.
    </asp:Panel>
</div>

</asp:Content>
