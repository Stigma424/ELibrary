
<%@ Page Title="Most Borrowed Books"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="MostBorrowedBooks.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Inventory.MostBorrowedBooks" %>

<%@ Register
    Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>
    .mb-page{max-width:1400px;margin:0 auto;color:#123B4A}
    .mb-page *{box-sizing:border-box}
    .mb-back{display:inline-block;color:#168A91;font-size:12px;font-weight:800;text-decoration:none;margin-bottom:18px}
    .mb-header{margin-bottom:24px}
    .mb-header h1{font-size:30px;font-weight:850;margin:8px 0}
    .mb-header p{color:#647F89;font-size:13px;line-height:1.8;margin:0}
    .mb-eyebrow{font-size:11px;color:#168A91;font-weight:800;letter-spacing:1.4px}
    .mb-panel{background:#fff;border:1px solid #DCE9EB;border-radius:15px;padding:23px;margin-bottom:20px;min-width:0}
    .mb-panel h2{font-size:17px;font-weight:800;margin:0 0 18px}
    .mb-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:15px}
    .mb-field label{display:block;font-size:12px;font-weight:750;margin-bottom:8px}
    .mb-input{display:block;width:100%;min-height:43px;padding:10px 12px;background:white;border:1px solid #D0E2E5;border-radius:9px;color:#123B4A;font-size:13px}
    .mb-actions{display:flex;justify-content:space-between;align-items:center;gap:15px;margin-top:18px;flex-wrap:wrap}
    .mb-btn{min-height:43px;padding:11px 20px;color:white;background:#168A91;border:none;border-radius:9px;font-size:12px;font-weight:800;cursor:pointer}
    .mb-btn:hover{background:#12757C}
    .mb-note{color:#647F89;font-size:12px;line-height:1.7}
    .mb-error{display:block;color:#B94E49;font-size:12px;margin-top:12px}
    .mb-stats{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:13px;margin-bottom:20px}
    .mb-stat{padding:19px;background:white;border:1px solid #DCE9EB;border-radius:13px;min-width:0}
    .mb-stat span{display:block;font-size:12px;color:#647F89;margin-bottom:8px}
    .mb-stat strong{display:block;font-size:23px;font-weight:850;color:#123B4A}
    .mb-stat.accent strong{color:#168A91}
    .mb-viewer{min-height:650px;overflow-x:auto;border:1px solid #DCE9EB;border-radius:10px}
    .mb-empty{text-align:center;padding:32px;background:#F4F9FA;border:1px solid #DCE9EB;border-radius:13px;color:#647F89;font-size:13px}
    @media(max-width:1000px){.mb-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}
    @media(max-width:650px){.mb-grid,.mb-stats{grid-template-columns:1fr}.mb-panel{padding:17px}.mb-header h1{font-size:25px}.mb-btn{width:100%}}
</style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
<div class="mb-page">
    <a class="mb-back"
       href="<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>">
        &#8592; Back to Reports &amp; Analytics
    </a>

    <header class="mb-header">
        <span class="mb-eyebrow">ADMINISTRATION / INVENTORY REPORTS</span>
        <h1>Most Borrowed Books</h1>
        <p>
            Rank books by collected borrowing transactions
            created in the selected period. Uncollected and
            cancelled reservations are excluded.
        </p>
    </header>

    <section class="mb-panel">
        <h2>Popularity Filters</h2>

        <div class="mb-grid">
            <div class="mb-field">
                <asp:Label runat="server" AssociatedControlID="txtFrom"
                    Text="Date From" />
                <asp:TextBox ID="txtFrom" runat="server"
                    TextMode="Date" CssClass="mb-input" />
            </div>

            <div class="mb-field">
                <asp:Label runat="server" AssociatedControlID="txtTo"
                    Text="Date To" />
                <asp:TextBox ID="txtTo" runat="server"
                    TextMode="Date" CssClass="mb-input" />
            </div>

            <div class="mb-field">
                <asp:Label runat="server" AssociatedControlID="ddlGenre"
                    Text="Genre" />
                <asp:DropDownList ID="ddlGenre"
                    runat="server" CssClass="mb-input" />
            </div>

            <div class="mb-field">
                <asp:Label runat="server" AssociatedControlID="txtSearch"
                    Text="Search Title, Author or ISBN" />
                <asp:TextBox ID="txtSearch" runat="server"
                    CssClass="mb-input" MaxLength="150"
                    placeholder="Leave blank for all titles" />
            </div>

            <div class="mb-field">
                <asp:Label runat="server" AssociatedControlID="ddlTop"
                    Text="Show Top" />
                <asp:DropDownList ID="ddlTop"
                    runat="server" CssClass="mb-input">
                    <asp:ListItem Text="Top 10" Value="10" />
                    <asp:ListItem Text="Top 20" Value="20" Selected="True" />
                    <asp:ListItem Text="Top 50" Value="50" />
                    <asp:ListItem Text="Top 100" Value="100" />
                </asp:DropDownList>
            </div>

            <div class="mb-field">
                <asp:Label runat="server" AssociatedControlID="ddlArchived"
                    Text="Archived Books" />
                <asp:DropDownList ID="ddlArchived"
                    runat="server" CssClass="mb-input">
                    <asp:ListItem Text="Active Books Only" Value="0" />
                    <asp:ListItem Text="Include Archived" Value="1" />
                </asp:DropDownList>
            </div>
        </div>

        <div class="mb-actions">
            <span class="mb-note">
                Books with zero qualifying loans can appear
                at the bottom of the ranking.
            </span>
            <asp:Button ID="btnGenerate" runat="server"
                Text="Generate Report" CssClass="mb-btn"
                OnClick="btnGenerate_Click" />
        </div>

        <asp:Label ID="lblError"
            runat="server" CssClass="mb-error"
            EnableViewState="false" />
    </section>

    <asp:Panel ID="pnlResults" runat="server" Visible="false">
        <div class="mb-stats">
            <div class="mb-stat">
                <span>Ranked Titles</span>
                <strong><asp:Label ID="lblTitles" runat="server" /></strong>
            </div>
            <div class="mb-stat accent">
                <span>Qualifying Borrowings</span>
                <strong><asp:Label ID="lblBorrowings" runat="server" /></strong>
            </div>
            <div class="mb-stat">
                <span>Top Ranked Book</span>
                <strong style="font-size:15px">
                    <asp:Label ID="lblTopBook" runat="server" />
                </strong>
            </div>
        </div>

        <section class="mb-panel">
            <h2>Popularity Ranking Preview</h2>
            <div class="mb-viewer">
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

    <asp:Panel ID="pnlEmpty" runat="server"
        CssClass="mb-empty">
        Select filters and click
        <strong>Generate Report</strong>
        to rank the library's books.
    </asp:Panel>
</div>
</asp:Content>
