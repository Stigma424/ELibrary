
<%@ Page Title="Book Inventory Report" Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="BookInventory.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Inventory.BookInventory" %>

<%@ Register
    Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>
    .iv-page{max-width:1400px;margin:0 auto;color:#123B4A}
    .iv-page *{box-sizing:border-box}
    .iv-back{display:inline-block;margin-bottom:18px;color:#168A91;font-size:12px;font-weight:800;text-decoration:none}
    .iv-header{margin-bottom:24px}
    .iv-eyebrow{font-size:11px;color:#168A91;font-weight:800;letter-spacing:1.4px}
    .iv-header h1{font-size:30px;font-weight:850;margin:8px 0}
    .iv-header p{margin:0;color:#647F89;font-size:13px;line-height:1.8}
    .iv-panel{background:#fff;border:1px solid #DCE9EB;border-radius:15px;padding:23px;margin-bottom:20px;min-width:0}
    .iv-panel h2{font-size:17px;font-weight:800;margin:0 0 18px}
    .iv-filters{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:15px}
    .iv-field label{display:block;font-size:12px;font-weight:750;margin-bottom:8px}
    .iv-input{display:block;width:100%;min-height:43px;padding:10px 12px;background:#fff;color:#123B4A;border:1px solid #D0E2E5;border-radius:9px;font-size:13px}
    .iv-actions{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;margin-top:18px}
    .iv-btn{padding:11px 20px;min-height:43px;background:#168A91;color:white;border:0;border-radius:9px;font-size:12px;font-weight:800;cursor:pointer}
    .iv-btn:hover{background:#12757C}
    .iv-note{color:#647F89;font-size:12px;line-height:1.8}
    .iv-error{display:block;color:#B94E49;font-size:12px;margin-top:12px}
    .iv-stats{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:13px;margin-bottom:20px}
    .iv-stat{padding:18px;border:1px solid #DCE9EB;border-radius:13px;background:#fff;min-width:0}
    .iv-stat span{display:block;color:#647F89;font-size:11px;margin-bottom:8px}
    .iv-stat strong{font-size:22px;color:#123B4A;font-weight:850}
    .iv-stat.accent strong{color:#168A91}
    .iv-viewer{min-height:650px;overflow-x:auto;border:1px solid #DCE9EB;border-radius:10px}
    .iv-empty{padding:30px;text-align:center;background:#F4F9FA;color:#647F89;border:1px solid #DCE9EB;border-radius:13px;font-size:13px}
    @media(max-width:1050px){.iv-filters{grid-template-columns:repeat(2,minmax(0,1fr))}.iv-stats{grid-template-columns:repeat(2,minmax(0,1fr))}}
    @media(max-width:650px){.iv-filters,.iv-stats{grid-template-columns:1fr}.iv-header h1{font-size:25px}.iv-panel{padding:17px}.iv-btn{width:100%}}
</style>
</asp:Content>

<asp:Content ID="MainContentBlock" ContentPlaceHolderID="MainContent" runat="server">
<div class="iv-page">

    <a class="iv-back" href="<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>">
        &#8592; Back to Reports &amp; Analytics
    </a>

    <header class="iv-header">
        <span class="iv-eyebrow">ADMINISTRATION / INVENTORY REPORTS</span>
        <h1>Expanded Book Inventory</h1>
        <p>
            Review current book stock, genres, archived titles
            and low-stock conditions. This is a current
            inventory snapshot, not historical inventory data.
        </p>
    </header>

    <section class="iv-panel">
        <h2>Inventory Filters</h2>
        <div class="iv-filters">
            <div class="iv-field">
                <asp:Label runat="server" AssociatedControlID="txtSearch"
                    Text="Search Books" />
                <asp:TextBox ID="txtSearch" runat="server"
                    CssClass="iv-input" MaxLength="150"
                    placeholder="Title, ISBN, author or genre" />
            </div>

            <div class="iv-field">
                <asp:Label runat="server" AssociatedControlID="ddlGenre"
                    Text="Genre" />
                <asp:DropDownList ID="ddlGenre" runat="server"
                    CssClass="iv-input" />
            </div>

            <div class="iv-field">
                <asp:Label runat="server" AssociatedControlID="ddlArchive"
                    Text="Archive Status" />
                <asp:DropDownList ID="ddlArchive" runat="server"
                    CssClass="iv-input">
                    <asp:ListItem Text="All Books" Value="All" />
                    <asp:ListItem Text="Active Books" Value="Active" />
                    <asp:ListItem Text="Archived Books" Value="Archived" />
                </asp:DropDownList>
            </div>

            <div class="iv-field">
                <asp:Label runat="server" AssociatedControlID="ddlStock"
                    Text="Stock Status" />
                <asp:DropDownList ID="ddlStock" runat="server"
                    CssClass="iv-input">
                    <asp:ListItem Text="All Stock Levels" Value="All" />
                    <asp:ListItem Text="Available" Value="Available" />
                    <asp:ListItem Text="Low Stock" Value="Low Stock" />
                    <asp:ListItem Text="No Stock" Value="No Stock" />
                    <asp:ListItem Text="Invalid Stock" Value="Invalid Stock" />
                </asp:DropDownList>
            </div>

            <div class="iv-field">
                <asp:Label runat="server" AssociatedControlID="ddlThreshold"
                    Text="Low Stock Threshold" />
                <asp:DropDownList ID="ddlThreshold" runat="server"
                    CssClass="iv-input">
                    <asp:ListItem Text="2 Copies" Value="2" />
                    <asp:ListItem Text="1 Copy" Value="1" />
                    <asp:ListItem Text="3 Copies" Value="3" />
                    <asp:ListItem Text="5 Copies" Value="5" />
                    <asp:ListItem Text="10 Copies" Value="10" />
                </asp:DropDownList>
            </div>
        </div>

        <div class="iv-actions">
            <span class="iv-note">
                Press Enter in Search or click Generate Report to apply filters.
                Counts below reflect matching titles.
            </span>
            <asp:Button ID="btnGenerate" runat="server"
                Text="Generate Report" CssClass="iv-btn"
                OnClick="btnGenerate_Click" />
        </div>

        <asp:Label ID="lblError" runat="server"
            CssClass="iv-error" EnableViewState="false" />
    </section>

    <asp:Panel ID="pnlResults" runat="server" Visible="false">
        <div class="iv-stats">
            <div class="iv-stat">
                <span>Matching Titles</span>
                <strong><asp:Label ID="lblTitles" runat="server" /></strong>
            </div>
            <div class="iv-stat">
                <span>Total Copies</span>
                <strong><asp:Label ID="lblTotalCopies" runat="server" /></strong>
            </div>
            <div class="iv-stat accent">
                <span>Available Copies</span>
                <strong><asp:Label ID="lblAvailable" runat="server" /></strong>
            </div>
            <div class="iv-stat">
                <span>Low / No Stock Titles</span>
                <strong><asp:Label ID="lblLowStock" runat="server" /></strong>
            </div>
        </div>

        <section class="iv-panel">
            <h2>Inventory Report Preview</h2>
            <div class="iv-viewer">
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

    <asp:Panel ID="pnlEmpty" runat="server" CssClass="iv-empty">
        Click <strong>Generate Report</strong> to view current inventory.
    </asp:Panel>
</div>
</asp:Content>
