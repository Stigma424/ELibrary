
<%@ Page Title="Fee Collections Report" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="FeeCollections.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Finance.FeeCollections" %>
<%@ Register
    Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>
    .fin-page{max-width:1400px;margin:auto;color:#123B4A}
    .fin-page *{box-sizing:border-box}
    .fin-back{display:inline-block;margin-bottom:18px;text-decoration:none;color:#168A91;font-size:12px;font-weight:800}
    .fin-header{margin-bottom:24px}
    .fin-eyebrow{color:#168A91;font-size:11px;letter-spacing:1.4px;font-weight:800}
    .fin-header h1{font-size:30px;font-weight:850;margin:8px 0}
    .fin-header p{color:#647F89;font-size:13px;margin:0;line-height:1.8}
    .fin-panel{padding:23px;border:1px solid #DCE9EB;border-radius:15px;background:#fff;margin-bottom:20px;min-width:0}
    .fin-panel h2{font-size:17px;font-weight:800;margin:0 0 18px}
    .fin-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:15px}
    .fin-field label{display:block;font-weight:750;font-size:12px;margin-bottom:8px}
    .fin-input{width:100%;min-height:43px;border-radius:9px;border:1px solid #D0E2E5;padding:10px 12px;font-size:13px;background:white;color:#123B4A}
    .fin-bottom{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-top:18px}
    .fin-btn{background:#168A91;color:#fff;border:0;border-radius:9px;min-height:43px;padding:11px 20px;font-weight:800;font-size:12px;cursor:pointer}
    .fin-btn:hover{background:#12757C}
    .fin-note{font-size:12px;color:#647F89;line-height:1.7}
    .fin-error{display:block;color:#B94E49;font-size:12px;margin-top:12px}
    .fin-stats{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;margin-bottom:20px}
    .fin-stat{border:1px solid #DCE9EB;border-radius:13px;background:#fff;padding:19px;min-width:0}
    .fin-stat span{display:block;color:#647F89;font-size:12px;margin-bottom:8px}
    .fin-stat strong{font-size:23px;font-weight:850;color:#123B4A;overflow-wrap:anywhere}
    .fin-stat.highlight strong{color:#168A91}
    .fin-viewer{border:1px solid #DCE9EB;border-radius:10px;overflow-x:auto;min-height:650px}
    .fin-empty{padding:32px;background:#F4F9FA;border:1px solid #DCE9EB;border-radius:13px;text-align:center;color:#647F89;font-size:13px}
    @media(max-width:750px){.fin-stats{grid-template-columns:1fr}.fin-grid{grid-template-columns:1fr}.fin-header h1{font-size:25px}.fin-bottom{flex-direction:column;align-items:stretch}.fin-btn{width:100%}.fin-panel{padding:17px}}
</style>
</asp:Content>

<asp:Content ID="MainContentBlock" ContentPlaceHolderID="MainContent" runat="server">
<div class="fin-page">
    <a class="fin-back" href="<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>">
        &#8592; Back to Reports &amp; Analytics
    </a>

    <header class="fin-header">
        <span class="fin-eyebrow">ADMINISTRATION / FINANCIAL REPORTS</span>
        <h1>Fee Collections Report</h1>
        <p>
            Analyze borrowing, late and replacement fee payments
            and refunds. Security deposits are excluded.
        </p>
    </header>

    <section class="fin-panel">
        <h2>Report Filters</h2>
        <div class="fin-grid">
            <div class="fin-field">
                <asp:Label runat="server" AssociatedControlID="txtFrom" Text="Date From" />
                <asp:TextBox ID="txtFrom" runat="server" TextMode="Date" CssClass="fin-input" />
            </div>
            <div class="fin-field">
                <asp:Label runat="server" AssociatedControlID="txtTo" Text="Date To" />
                <asp:TextBox ID="txtTo" runat="server" TextMode="Date" CssClass="fin-input" />
            </div>
            <div class="fin-field">
                <asp:Label runat="server" AssociatedControlID="ddlFeeType" Text="Fee Type" />
                <asp:DropDownList ID="ddlFeeType" runat="server" CssClass="fin-input">
                    <asp:ListItem Text="All Fee Types" Value="" />
                    <asp:ListItem Text="Borrowing Fee" Value="Borrowing Fee" />
                    <asp:ListItem Text="Late Fee" Value="Late Fee" />
                    <asp:ListItem Text="Replacement Fee" Value="Replacement Fee" />
                </asp:DropDownList>
            </div>
            <div class="fin-field">
                <asp:Label runat="server" AssociatedControlID="ddlTransaction" Text="Transaction Type" />
                <asp:DropDownList ID="ddlTransaction" runat="server" CssClass="fin-input">
                    <asp:ListItem Text="Payments and Refunds" Value="" />
                    <asp:ListItem Text="Payments Only" Value="Payment" />
                    <asp:ListItem Text="Refunds Only" Value="Refund" />
                </asp:DropDownList>
            </div>
        </div>
        <div class="fin-bottom">
            <span class="fin-note">Filters apply when you click Generate Report.</span>
            <asp:Button ID="btnGenerate" runat="server" Text="Generate Report"
                CssClass="fin-btn" OnClick="btnGenerate_Click" />
        </div>
        <asp:Label ID="lblError" runat="server" CssClass="fin-error" EnableViewState="false" />
    </section>

    <asp:Panel ID="pnlResults" runat="server" Visible="false">
        <div class="fin-stats">
            <div class="fin-stat">
                <span>Gross Payments</span>
                <strong><asp:Label ID="lblPayments" runat="server" /></strong>
            </div>
            <div class="fin-stat">
                <span>Refunds Issued</span>
                <strong><asp:Label ID="lblRefunds" runat="server" /></strong>
            </div>
            <div class="fin-stat highlight">
                <span>Net Fee Collections</span>
                <strong><asp:Label ID="lblNet" runat="server" /></strong>
            </div>
        </div>

        <section class="fin-panel">
            <h2>Transaction Report</h2>
            <div class="fin-viewer">
                <asp:ScriptManager ID="smReport" runat="server" />
                <rsweb:ReportViewer ID="rvReport" runat="server"
                    ProcessingMode="Local"
                    Width="100%" Height="650px"
                    AsyncRendering="false"
                    SizeToReportContent="false"
                    ShowExportControls="true"
                    ShowRefreshButton="false"
                    ShowParameterPrompts="false" />
            </div>
        </section>
    </asp:Panel>

    <asp:Panel ID="pnlEmpty" runat="server" CssClass="fin-empty">
        Select a reporting period and click <strong>Generate Report</strong>.
    </asp:Panel>
</div>
</asp:Content>
