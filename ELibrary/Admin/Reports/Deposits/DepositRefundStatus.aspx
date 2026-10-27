
<%@ Page Title="Deposit Refund Status" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="DepositRefundStatus.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Deposits.DepositRefundStatus" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>
    .rpt{max-width:1400px;margin:auto;color:#123B4A}
    .rpt *{box-sizing:border-box}
    .rpt-back{display:inline-block;color:#168A91;font-size:12px;font-weight:800;text-decoration:none;margin-bottom:18px}
    .rpt-eyebrow{font-size:11px;font-weight:800;letter-spacing:1.4px;color:#168A91}
    .rpt h1{font-size:30px;font-weight:850;margin:8px 0}
    .rpt-desc{font-size:13px;color:#647F89;line-height:1.8;margin:0 0 24px}
    .rpt-panel{background:#fff;border:1px solid #DCE9EB;border-radius:15px;padding:23px;margin-bottom:20px;min-width:0}
    .rpt-panel h2{font-size:17px;font-weight:800;margin:0 0 18px}
    .rpt-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:15px;align-items:end}
    .rpt-field label{display:block;font-size:12px;font-weight:750;margin-bottom:8px}
    .rpt-input{width:100%;min-height:43px;padding:10px 12px;border:1px solid #D0E2E5;border-radius:9px;background:#fff;color:#123B4A;font-size:13px}
    .rpt-actions{display:flex;justify-content:space-between;align-items:center;gap:12px;margin-top:18px}
    .rpt-btn{background:#168A91;border:0;border-radius:9px;color:#fff;padding:11px 20px;min-height:43px;font-size:12px;font-weight:800;cursor:pointer}
    .rpt-btn:hover{background:#12757C}
    .rpt-note{font-size:12px;color:#647F89;line-height:1.7}
    .rpt-error{display:block;color:#B94E49;font-size:12px;margin-top:12px}
    .rpt-stats{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;margin-bottom:20px}
    .rpt-stat{padding:19px;background:#fff;border:1px solid #DCE9EB;border-radius:13px}
    .rpt-stat span{display:block;color:#647F89;font-size:12px;margin-bottom:8px}
    .rpt-stat strong{font-size:23px;font-weight:850;color:#168A91;overflow-wrap:anywhere}
    .rpt-viewer{border:1px solid #DCE9EB;border-radius:10px;min-height:650px;overflow-x:auto}
    .rpt-empty{padding:32px;text-align:center;color:#647F89;background:#F4F9FA;border:1px solid #DCE9EB;border-radius:13px}
    @media(max-width:900px){.rpt-grid{grid-template-columns:repeat(2,1fr)}}
    @media(max-width:650px){.rpt-grid,.rpt-stats{grid-template-columns:1fr}.rpt-actions{flex-direction:column;align-items:stretch}.rpt-btn{width:100%}.rpt-panel{padding:17px}}
</style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
<div class="rpt">

    <a class="rpt-back" href="<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>">
        &#8592; Back to Reports &amp; Analytics
    </a>

    <span class="rpt-eyebrow">ADMINISTRATION / DEPOSIT REPORTS</span>
    <h1>Deposit Refund Status</h1>
    <p class="rpt-desc">
        Review current deposit balances, received amounts,
        refunds issued, and recorded deposit statuses.
    </p>

    <section class="rpt-panel">
        <h2>Report Filters</h2>

        <div class="rpt-grid">
            <div class="rpt-field">
                <asp:Label runat="server" AssociatedControlID="txtSearch"
                    Text="Customer or Book" />
                <asp:TextBox ID="txtSearch" runat="server"
                    CssClass="rpt-input" MaxLength="150"
                    placeholder="Search customer, email or book" />
            </div>

            <div class="rpt-field">
                <asp:Label runat="server" AssociatedControlID="ddlStatus"
                    Text="Deposit Status" />
                <asp:DropDownList ID="ddlStatus" runat="server"
                    CssClass="rpt-input" />
            </div>

            <div class="rpt-field">
                <asp:Label runat="server" AssociatedControlID="ddlHeld"
                    Text="Balance Filter" />
                <asp:DropDownList ID="ddlHeld" runat="server"
                    CssClass="rpt-input">
                    <asp:ListItem Text="All Deposits" Value="0" />
                    <asp:ListItem Text="Only Funds Still Held" Value="1" />
                </asp:DropDownList>
            </div>
        </div>

        <div class="rpt-actions">
            <span class="rpt-note">
                Live balance snapshot. Apply filters by pressing
                Enter or clicking Generate Report.
            </span>
            <asp:Button ID="btnGenerate" runat="server"
                CssClass="rpt-btn" Text="Generate Report"
                OnClick="btnGenerate_Click" />
        </div>

        <asp:Label ID="lblError" runat="server"
            CssClass="rpt-error" EnableViewState="false" />
    </section>

    <asp:Panel ID="pnlResults" runat="server" Visible="false">
        <div class="rpt-stats">
            <div class="rpt-stat">
                <span>Deposit Records</span>
                <strong><asp:Label ID="lblCount" runat="server" /></strong>
            </div>
            <div class="rpt-stat">
                <span>Total Refunded</span>
                <strong><asp:Label ID="lblRefunded" runat="server" /></strong>
            </div>
            <div class="rpt-stat">
                <span>Funds Still Held</span>
                <strong><asp:Label ID="lblHeld" runat="server" /></strong>
            </div>
        </div>

        <section class="rpt-panel">
            <h2>Deposit Balance Details</h2>
            <div class="rpt-viewer">
                <asp:ScriptManager ID="smReport" runat="server" />
                <rsweb:ReportViewer ID="rvReport" runat="server"
                    ProcessingMode="Local" Width="100%" Height="650px"
                    AsyncRendering="false" SizeToReportContent="false"
                    ShowExportControls="true" ShowRefreshButton="false"
                    ShowParameterPrompts="false" />
            </div>
        </section>
    </asp:Panel>

    <asp:Panel ID="pnlEmpty" runat="server" CssClass="rpt-empty">
        Click <strong>Generate Report</strong>
        to view deposit refund statuses.
    </asp:Panel>
</div>
</asp:Content>
