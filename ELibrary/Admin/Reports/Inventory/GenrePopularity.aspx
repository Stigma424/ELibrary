
<%@ Page Title="Genre Popularity Report"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="GenrePopularity.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Inventory.GenrePopularity" %>

<%@ Register
    Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<asp:Content ID="HeadBlock"
    ContentPlaceHolderID="head"
    runat="server">
<style>
    .gp-page{max-width:1400px;margin:auto;color:#123B4A}
    .gp-page *{box-sizing:border-box}
    .gp-back{display:inline-block;margin-bottom:18px;color:#168A91;font-size:12px;font-weight:800;text-decoration:none}
    .gp-header{margin-bottom:24px}
    .gp-eyebrow{color:#168A91;font-size:11px;font-weight:800;letter-spacing:1.4px}
    .gp-header h1{font-size:30px;font-weight:850;margin:8px 0}
    .gp-header p{font-size:13px;line-height:1.8;color:#647F89;margin:0}
    .gp-panel{background:#fff;border:1px solid #DCE9EB;border-radius:15px;padding:23px;margin-bottom:20px;min-width:0}
    .gp-panel h2{font-size:17px;font-weight:800;margin:0 0 18px}
    .gp-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:15px}
    .gp-field label{display:block;font-size:12px;font-weight:750;margin-bottom:8px}
    .gp-input{display:block;width:100%;min-height:43px;padding:10px 12px;background:#fff;color:#123B4A;border:1px solid #D0E2E5;border-radius:9px;font-size:13px}
    .gp-bottom{display:flex;align-items:center;justify-content:space-between;gap:14px;margin-top:18px}
    .gp-note{color:#647F89;font-size:12px;line-height:1.7}
    .gp-btn{background:#168A91;color:#fff;padding:11px 20px;border:0;border-radius:9px;font-weight:800;font-size:12px;min-height:43px;cursor:pointer}
    .gp-btn:hover{background:#12757C}
    .gp-error{display:block;margin-top:12px;color:#B94E49;font-size:12px}
    .gp-stats{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;margin-bottom:20px}
    .gp-stat{background:#fff;border:1px solid #DCE9EB;border-radius:13px;padding:19px}
    .gp-stat span{display:block;color:#647F89;font-size:12px;margin-bottom:8px}
    .gp-stat strong{font-size:23px;font-weight:850;color:#123B4A;overflow-wrap:anywhere}
    .gp-stat.highlight strong{color:#168A91}
    .gp-viewer{border:1px solid #DCE9EB;border-radius:10px;overflow-x:auto;min-height:650px}
    .gp-empty{background:#F4F9FA;border:1px solid #DCE9EB;border-radius:13px;color:#647F89;text-align:center;padding:32px;font-size:13px}
    @media(max-width:750px){.gp-stats{grid-template-columns:1fr}}
    @media(max-width:650px){.gp-grid{grid-template-columns:1fr}.gp-panel{padding:17px}.gp-header h1{font-size:25px}.gp-bottom{flex-direction:column;align-items:stretch}.gp-btn{width:100%}}
</style>
</asp:Content>

<asp:Content ID="MainBlock"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="gp-page">
    <a class="gp-back"
       href="<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>">
        &#8592; Back to Reports &amp; Analytics
    </a>

    <header class="gp-header">
        <span class="gp-eyebrow">ADMINISTRATION / INVENTORY REPORTS</span>
        <h1>Genre Popularity Report</h1>
        <p>
            Compare book genres by collected borrowing transactions.
            Both online and walk-in borrowings are counted,
            and genres with zero activity are included.
        </p>
    </header>

    <section class="gp-panel">
        <h2>Report Filters</h2>

        <div class="gp-grid">
            <div class="gp-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtFrom"
                    Text="Date From" />
                <asp:TextBox ID="txtFrom"
                    runat="server"
                    TextMode="Date"
                    CssClass="gp-input" />
            </div>

            <div class="gp-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtTo"
                    Text="Date To" />
                <asp:TextBox ID="txtTo"
                    runat="server"
                    TextMode="Date"
                    CssClass="gp-input" />
            </div>

            <div class="gp-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtSearch"
                    Text="Search Genre" />
                <asp:TextBox ID="txtSearch"
                    runat="server"
                    CssClass="gp-input"
                    MaxLength="100"
                    placeholder="Leave blank for all genres" />
            </div>

            <div class="gp-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlArchived"
                    Text="Archived Books" />
                <asp:DropDownList ID="ddlArchived"
                    runat="server"
                    CssClass="gp-input">
                    <asp:ListItem Text="Active Books Only" Value="0" />
                    <asp:ListItem Text="Include Archived Books" Value="1" />
                </asp:DropDownList>
            </div>
        </div>

        <div class="gp-bottom">
            <span class="gp-note">
                Filters apply when you press Enter or click Generate Report.
                Rankings use confirmed collections.
            </span>
            <asp:Button ID="btnGenerate"
                runat="server"
                Text="Generate Report"
                CssClass="gp-btn"
                OnClick="btnGenerate_Click" />
        </div>

        <asp:Label ID="lblError"
            runat="server"
            CssClass="gp-error"
            EnableViewState="false" />
    </section>

    <asp:Panel ID="pnlResults"
        runat="server"
        Visible="false">

        <div class="gp-stats">
            <div class="gp-stat">
                <span>Genres in Report</span>
                <strong><asp:Label ID="lblGenres" runat="server" /></strong>
            </div>

            <div class="gp-stat highlight">
                <span>Qualifying Borrowings</span>
                <strong><asp:Label ID="lblBorrowings" runat="server" /></strong>
            </div>

            <div class="gp-stat">
                <span>Most Popular Genre</span>
                <strong style="font-size:17px">
                    <asp:Label ID="lblTopGenre" runat="server" />
                </strong>
            </div>
        </div>

        <section class="gp-panel">
            <h2>Genre Rankings</h2>

            <div class="gp-viewer">
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
        CssClass="gp-empty">
        Choose a reporting period and click
        <strong>Generate Report</strong>.
    </asp:Panel>
</div>

</asp:Content>
