
<%@ Page Title="Collection Trends"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="CollectionTrends.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Finance.CollectionTrends" %>

<%@ Register
    Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<asp:Content ID="HeadContent"
    ContentPlaceHolderID="head"
    runat="server">
<style>
    .ct-page{max-width:1400px;margin:auto;color:#123B4A}
    .ct-page *{box-sizing:border-box}
    .ct-back{display:inline-block;color:#168A91;font-size:12px;font-weight:800;text-decoration:none;margin-bottom:18px}
    .ct-eyebrow{color:#168A91;letter-spacing:1.4px;font-size:11px;font-weight:800}
    .ct-header{margin-bottom:24px}
    .ct-header h1{font-size:30px;font-weight:850;margin:8px 0}
    .ct-header p{color:#647F89;font-size:13px;line-height:1.8;margin:0}
    .ct-panel{background:#fff;border:1px solid #DCE9EB;border-radius:15px;padding:23px;margin-bottom:20px;min-width:0}
    .ct-panel h2{font-size:17px;font-weight:800;margin:0 0 17px}
    .ct-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr)) auto;gap:15px;align-items:end}
    .ct-field label{display:block;font-size:12px;font-weight:750;margin-bottom:8px}
    .ct-input{display:block;width:100%;min-height:43px;border:1px solid #D0E2E5;border-radius:9px;background:#fff;color:#123B4A;padding:10px 12px;font-size:13px}
    .ct-btn{background:#168A91;color:#fff;border:0;border-radius:9px;padding:11px 19px;min-height:43px;font-size:12px;font-weight:800;cursor:pointer;white-space:nowrap}
    .ct-btn:hover{background:#12757C}
    .ct-error{display:block;color:#B94E49;font-size:12px;margin-top:12px}
    .ct-stats{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;margin-bottom:20px}
    .ct-stat{background:#fff;border:1px solid #DCE9EB;border-radius:13px;padding:19px;min-width:0}
    .ct-stat span{display:block;color:#647F89;font-size:12px;margin-bottom:9px}
    .ct-stat strong{display:block;color:#123B4A;font-weight:850;font-size:22px;overflow-wrap:anywhere}
    .ct-stat.highlight strong{color:#168A91}
    .ct-note{color:#647F89;font-size:12px;line-height:1.7;margin-top:14px}
    .ct-viewer{min-height:650px;overflow-x:auto;border:1px solid #DCE9EB;border-radius:10px}
    .ct-empty{border:1px solid #DCE9EB;border-radius:13px;background:#F4F9FA;text-align:center;padding:32px;color:#647F89;font-size:13px}
    @media(max-width:1100px){.ct-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}
    @media(max-width:750px){.ct-stats{grid-template-columns:1fr}}
    @media(max-width:650px){
        .ct-grid{grid-template-columns:1fr}
        .ct-header h1{font-size:25px}
        .ct-btn{width:100%}
        .ct-panel{padding:17px}
    }
</style>
</asp:Content>

<asp:Content ID="MainBlock"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="ct-page">
    <a class="ct-back"
       href="<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>">
        &#8592; Back to Reports &amp; Analytics
    </a>

    <header class="ct-header">
        <span class="ct-eyebrow">
            ADMINISTRATION / FINANCIAL REPORTS
        </span>
        <h1>Collection Trends</h1>
        <p>
            Analyze payments, refunds and net fee collections
            across daily, weekly or monthly reporting periods.
        </p>
    </header>

    <section class="ct-panel">
        <h2>Report Filters</h2>
        <div class="ct-grid">
            <div class="ct-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtFrom"
                    Text="Date From" />
                <asp:TextBox ID="txtFrom"
                    runat="server"
                    TextMode="Date"
                    CssClass="ct-input" />
            </div>

            <div class="ct-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtTo"
                    Text="Date To" />
                <asp:TextBox ID="txtTo"
                    runat="server"
                    TextMode="Date"
                    CssClass="ct-input" />
            </div>

            <div class="ct-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlGrouping"
                    Text="Group By" />
                <asp:DropDownList ID="ddlGrouping"
                    runat="server"
                    CssClass="ct-input">
                    <asp:ListItem Text="Daily" Value="Daily" />
                    <asp:ListItem Text="Weekly" Value="Weekly" />
                    <asp:ListItem Text="Monthly" Value="Monthly" Selected="True" />
                </asp:DropDownList>
            </div>

            <asp:Button ID="btnGenerate"
                runat="server"
                Text="Generate Report"
                CssClass="ct-btn"
                OnClick="btnGenerate_Click" />
        </div>

        <p class="ct-note">
            Weekly periods begin on Monday. Date filters apply
            to actual payment or refund transaction dates.
        </p>

        <asp:Label ID="lblError"
            runat="server"
            CssClass="ct-error"
            EnableViewState="false" />
    </section>

    <asp:Panel ID="pnlResults"
        runat="server"
        Visible="false">

        <div class="ct-stats">
            <div class="ct-stat">
                <span>Gross Payments</span>
                <strong><asp:Label ID="lblPayments" runat="server" /></strong>
            </div>
            <div class="ct-stat">
                <span>Total Refunds</span>
                <strong><asp:Label ID="lblRefunds" runat="server" /></strong>
            </div>
            <div class="ct-stat highlight">
                <span>Net Collections</span>
                <strong><asp:Label ID="lblNet" runat="server" /></strong>
            </div>
        </div>

        <section class="ct-panel">
            <h2>Collection Trend Breakdown</h2>

            <div class="ct-viewer">
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
        CssClass="ct-empty">
        Choose a reporting period and click
        <strong>Generate Report</strong>.
    </asp:Panel>
</div>

</asp:Content>
