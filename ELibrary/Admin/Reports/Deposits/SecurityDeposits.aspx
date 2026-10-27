
<%@ Page Title="Security Deposit Transactions"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="SecurityDeposits.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Deposits.SecurityDeposits" %>

<%@ Register
    Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<asp:Content ID="HeadBlock"
    ContentPlaceHolderID="head"
    runat="server">
<style>
    .sd-page{max-width:1400px;margin:auto;color:#123B4A}
    .sd-page *{box-sizing:border-box}
    .sd-back{display:inline-block;color:#168A91;font-size:12px;font-weight:800;text-decoration:none;margin-bottom:18px}
    .sd-header{margin-bottom:24px}
    .sd-eyebrow{color:#168A91;font-size:11px;font-weight:800;letter-spacing:1.4px}
    .sd-header h1{font-size:30px;font-weight:850;margin:8px 0}
    .sd-header p{font-size:13px;line-height:1.8;color:#647F89;margin:0}
    .sd-panel{background:#fff;border:1px solid #DCE9EB;border-radius:15px;padding:23px;margin-bottom:20px;min-width:0}
    .sd-panel h2{font-size:17px;font-weight:800;margin:0 0 18px}
    .sd-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:15px}
    .sd-field label{display:block;font-size:12px;font-weight:750;margin-bottom:8px}
    .sd-input{width:100%;display:block;min-height:43px;padding:10px 12px;border:1px solid #D0E2E5;border-radius:9px;background:#fff;color:#123B4A;font-size:13px}
    .sd-bottom{display:flex;align-items:center;justify-content:space-between;gap:14px;margin-top:18px}
    .sd-note{color:#647F89;font-size:12px;line-height:1.7}
    .sd-btn{min-height:43px;padding:11px 20px;border:0;border-radius:9px;color:white;background:#168A91;font-size:12px;font-weight:800;cursor:pointer}
    .sd-btn:hover{background:#12757C}
    .sd-error{display:block;margin-top:12px;color:#B94E49;font-size:12px}
    .sd-stats{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;margin-bottom:20px}
    .sd-stat{background:#fff;border:1px solid #DCE9EB;border-radius:13px;padding:19px;min-width:0}
    .sd-stat span{display:block;color:#647F89;font-size:12px;margin-bottom:8px}
    .sd-stat strong{font-size:23px;color:#123B4A;font-weight:850;overflow-wrap:anywhere}
    .sd-stat.highlight strong{color:#168A91}
    .sd-viewer{border:1px solid #DCE9EB;border-radius:10px;overflow-x:auto;min-height:650px}
    .sd-empty{background:#F4F9FA;border:1px solid #DCE9EB;border-radius:13px;text-align:center;padding:32px;color:#647F89;font-size:13px}
    @media(max-width:950px){.sd-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}
    @media(max-width:700px){.sd-stats{grid-template-columns:1fr}}
    @media(max-width:650px){.sd-grid{grid-template-columns:1fr}.sd-panel{padding:17px}.sd-header h1{font-size:25px}.sd-bottom{flex-direction:column;align-items:stretch}.sd-btn{width:100%}}
</style>
</asp:Content>

<asp:Content ID="MainBlock"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="sd-page">
    <a class="sd-back"
       href="<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>">
        &#8592; Back to Reports &amp; Analytics
    </a>

    <header class="sd-header">
        <span class="sd-eyebrow">ADMINISTRATION / DEPOSIT REPORTS</span>
        <h1>Security Deposit Transactions</h1>
        <p>
            Track collected and refunded security deposits,
            payment methods, transaction references,
            and the librarian who processed each movement.
        </p>
    </header>

    <section class="sd-panel">
        <h2>Report Filters</h2>

        <div class="sd-grid">
            <div class="sd-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtFrom"
                    Text="Date From" />
                <asp:TextBox ID="txtFrom" runat="server"
                    TextMode="Date" CssClass="sd-input" />
            </div>

            <div class="sd-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtTo"
                    Text="Date To" />
                <asp:TextBox ID="txtTo" runat="server"
                    TextMode="Date" CssClass="sd-input" />
            </div>

            <div class="sd-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlType"
                    Text="Transaction Type" />
                <asp:DropDownList ID="ddlType"
                    runat="server" CssClass="sd-input">
                    <asp:ListItem Text="Collections and Refunds" Value="" />
                    <asp:ListItem Text="Collections Only" Value="Collection" />
                    <asp:ListItem Text="Refunds Only" Value="Refund" />
                </asp:DropDownList>
            </div>

            <div class="sd-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlMethod"
                    Text="Payment Method" />
                <asp:DropDownList ID="ddlMethod"
                    runat="server" CssClass="sd-input">
                    <asp:ListItem Text="All Methods" Value="" />
                    <asp:ListItem Text="Cash" Value="Cash" />
                    <asp:ListItem Text="GCash" Value="GCash" />
                    <asp:ListItem Text="Card" Value="Card" />
                    <asp:ListItem Text="Bank Transfer" Value="Bank Transfer" />
                </asp:DropDownList>
            </div>

            <div class="sd-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtSearch"
                    Text="Search Records" />
                <asp:TextBox ID="txtSearch"
                    runat="server"
                    CssClass="sd-input"
                    MaxLength="150"
                    placeholder="Customer, book, reference or staff" />
            </div>
        </div>

        <div class="sd-bottom">
            <span class="sd-note">
                Date filters apply to deposit transaction timestamps.
                Search and filters apply when you generate the report.
            </span>
            <asp:Button ID="btnGenerate"
                runat="server"
                Text="Generate Report"
                CssClass="sd-btn"
                OnClick="btnGenerate_Click" />
        </div>

        <asp:Label ID="lblError"
            runat="server"
            CssClass="sd-error"
            EnableViewState="false" />
    </section>

    <asp:Panel ID="pnlResults" runat="server" Visible="false">
        <div class="sd-stats">
            <div class="sd-stat">
                <span>Deposits Collected</span>
                <strong><asp:Label ID="lblCollected" runat="server" /></strong>
            </div>
            <div class="sd-stat">
                <span>Deposits Refunded</span>
                <strong><asp:Label ID="lblRefunded" runat="server" /></strong>
            </div>
            <div class="sd-stat highlight">
                <span>Net Movement in Period</span>
                <strong><asp:Label ID="lblNet" runat="server" /></strong>
            </div>
        </div>

        <section class="sd-panel">
            <h2>Deposit Transaction Details</h2>

            <div class="sd-viewer">
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

    <asp:Panel ID="pnlEmpty" runat="server" CssClass="sd-empty">
        Choose a reporting period and click
        <strong>Generate Report</strong>.
    </asp:Panel>
</div>

</asp:Content>
