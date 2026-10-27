
<%@ Page Title="Audit Trail Summary" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="AuditTrailSummary.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Audit.AuditTrailSummary" %>
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
    .rpt-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:15px}
    .rpt-field label{display:block;font-size:12px;font-weight:750;margin-bottom:8px}
    .rpt-input{width:100%;min-height:43px;padding:10px 12px;border:1px solid #D0E2E5;border-radius:9px;background:#fff;color:#123B4A;font-size:13px}
    .rpt-actions{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-top:18px}
    .rpt-btn{background:#168A91;border:none;border-radius:9px;min-height:43px;padding:11px 20px;color:white;font-size:12px;font-weight:800;cursor:pointer}
    .rpt-btn:hover{background:#12757C}
    .rpt-note{font-size:12px;color:#647F89;line-height:1.7}
    .rpt-error{display:block;color:#B94E49;font-size:12px;margin-top:12px}
    .rpt-stats{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;margin-bottom:20px}
    .rpt-stat{padding:19px;background:#fff;border:1px solid #DCE9EB;border-radius:13px}
    .rpt-stat span{display:block;color:#647F89;font-size:12px;margin-bottom:8px}
    .rpt-stat strong{font-size:23px;font-weight:850;color:#168A91;overflow-wrap:anywhere}
    .rpt-viewer{border:1px solid #DCE9EB;border-radius:10px;min-height:650px;overflow-x:auto}
    .rpt-empty{padding:32px;text-align:center;color:#647F89;background:#F4F9FA;border:1px solid #DCE9EB;border-radius:13px}
    @media(max-width:650px){.rpt-grid,.rpt-stats{grid-template-columns:1fr}.rpt-actions{flex-direction:column;align-items:stretch}.rpt-btn{width:100%}.rpt-panel{padding:17px}}
</style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
<div class="rpt">
    <a class="rpt-back" href="<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>">
        &#8592; Back to Reports &amp; Analytics
    </a>

    <span class="rpt-eyebrow">ADMINISTRATION / AUDIT REPORTS</span>
    <h1>Audit Trail Summary</h1>
    <p class="rpt-desc">
        Review the system's recorded audit events, with
        actor, category, action and date filtering.
    </p>

    <section class="rpt-panel">
        <h2>Report Filters</h2>
        <div class="rpt-grid">

            <div class="rpt-field">
                <asp:Label runat="server" AssociatedControlID="txtFrom"
                    Text="Date From" />
                <asp:TextBox ID="txtFrom" runat="server"
                    TextMode="Date" CssClass="rpt-input" />
            </div>
            <div class="rpt-field">
                <asp:Label runat="server" AssociatedControlID="txtTo"
                    Text="Date To" />
                <asp:TextBox ID="txtTo" runat="server"
                    TextMode="Date" CssClass="rpt-input" />
            </div>
            <div class="rpt-field">
                <asp:Label runat="server" AssociatedControlID="txtSearch"
                    Text="Search Actor, Action or Log ID" />
                <asp:TextBox ID="txtSearch" runat="server"
                    CssClass="rpt-input" MaxLength="150"
                    placeholder="Name, description or exact log number" />
            </div>
            <div class="rpt-field">
                <asp:Label runat="server" AssociatedControlID="ddlCategory"
                    Text="Action Category" />
                <asp:DropDownList ID="ddlCategory"
                    runat="server" CssClass="rpt-input" />
            </div>
            <div class="rpt-field">
                <asp:Label runat="server" AssociatedControlID="ddlRole"
                    Text="Actor Role" />
                <asp:DropDownList ID="ddlRole"
                    runat="server" CssClass="rpt-input">
                    <asp:ListItem Text="All Actors" Value="" />
                    <asp:ListItem Text="Customers" Value="1" />
                    <asp:ListItem Text="Librarians" Value="2" />
                </asp:DropDownList>
            </div>
        </div>

        <div class="rpt-actions">
            <span class="rpt-note">
                Reports recorded events, not unlogged system actions.
                Filters apply on Generate Report.
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
                <span>Audit Events</span>
                <strong><asp:Label ID="lblEvents" runat="server" /></strong>
            </div>
            <div class="rpt-stat">
                <span>Distinct Actors</span>
                <strong><asp:Label ID="lblActors" runat="server" /></strong>
            </div>
            <div class="rpt-stat">
                <span>Action Categories</span>
                <strong><asp:Label ID="lblCategories" runat="server" /></strong>
            </div>
        </div>

        <section class="rpt-panel">
            <h2>Audit Trail Records</h2>
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
        Select filters and click
        <strong>Generate Report</strong>.
    </asp:Panel>
</div>
</asp:Content>
