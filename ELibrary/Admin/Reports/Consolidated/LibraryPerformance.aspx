
<%@ Page Title="Library Performance Report"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="LibraryPerformance.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Consolidated.LibraryPerformance" %>

<%@ Register
    Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<asp:Content ID="HeadContent"
    ContentPlaceHolderID="head"
    runat="server">
<style>
    .lp-page{max-width:1400px;margin:0 auto;color:#123B4A}
    .lp-page *{box-sizing:border-box}
    .lp-back{display:inline-block;margin-bottom:18px;color:#168A91;font-size:12px;font-weight:800;text-decoration:none}
    .lp-eyebrow{display:block;color:#168A91;font-size:11px;font-weight:800;letter-spacing:1.4px}
    .lp-header{margin-bottom:25px}
    .lp-header h1{font-size:30px;font-weight:850;margin:9px 0}
    .lp-header p{font-size:13px;line-height:1.8;color:#647F89;margin:0}
    .lp-panel{background:#fff;border:1px solid #DCE9EB;border-radius:15px;padding:24px;margin-bottom:20px}
    .lp-panel h2{font-size:17px;font-weight:800;margin:0 0 18px}
    .lp-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:15px;align-items:end}
    .lp-field label{display:block;font-size:12px;font-weight:750;margin-bottom:8px}
    .lp-input{display:block;width:100%;min-height:43px;padding:10px 12px;border:1px solid #D0E2E5;border-radius:9px;color:#123B4A;background:#fff;font-size:13px}
    .lp-btn{background:#168A91;color:#fff;border:0;border-radius:9px;min-height:43px;padding:11px 20px;cursor:pointer;font-size:12px;font-weight:800}
    .lp-btn:hover{background:#12757C}
    .lp-actions{display:flex;align-items:end;gap:12px;margin-top:17px;flex-wrap:wrap}
    .lp-note{font-size:12px;line-height:1.8;color:#647F89;margin:15px 0 0}
    .lp-error{color:#B94E49;font-size:12px;display:block;margin-top:12px}
    .lp-stats{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:14px;margin-bottom:20px}
    .lp-stat{background:#fff;border:1px solid #DCE9EB;border-radius:13px;padding:18px;min-width:0}
    .lp-stat span{display:block;font-size:11px;color:#647F89;margin-bottom:9px;font-weight:650}
    .lp-stat strong{display:block;font-size:21px;color:#123B4A;overflow-wrap:anywhere}
    .lp-stat.highlight strong{color:#168A91}
    .lp-snapshot{font-size:12px;color:#647F89;margin:0 0 18px;line-height:1.7}
    .lp-viewer{border:1px solid #DCE9EB;border-radius:11px;overflow-x:auto;min-height:650px}
    .lp-empty{background:#F4F9FA;border:1px solid #DCE9EB;border-radius:13px;text-align:center;color:#647F89;padding:34px;font-size:13px;line-height:1.8}
    .lp-badge{display:inline-block;background:#EAF6F6;border-radius:8px;color:#168A91;padding:7px 10px;font-weight:800;font-size:11px}
    @media(max-width:1050px){
        .lp-grid{grid-template-columns:repeat(2,minmax(0,1fr))}
        .lp-stats{grid-template-columns:repeat(2,minmax(0,1fr))}
    }
    @media(max-width:650px){
        .lp-grid,.lp-stats{grid-template-columns:1fr}
        .lp-header h1{font-size:24px}
        .lp-panel{padding:17px}
        .lp-btn{width:100%}
    }
</style>
</asp:Content>

<asp:Content ID="MainBlock"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="lp-page">

    <a class="lp-back"
       href='<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>'>
        &#8592; Back to Reports &amp; Analytics
    </a>

    <header class="lp-header">
        <span class="lp-eyebrow">ADMINISTRATION / CONSOLIDATED REPORTS</span>
        <h1>Library Performance Report</h1>
        <p>
            Generate one consolidated management report covering
            borrowing, fee collections, inventory, deposits,
            book popularity and audit activity.
        </p>
    </header>

    <section class="lp-panel">
        <h2>Report Configuration</h2>

        <div class="lp-grid">

            <div class="lp-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlPeriod"
                    Text="Period Type" />
                <asp:DropDownList ID="ddlPeriod"
                    runat="server"
                    CssClass="lp-input">
                    <asp:ListItem Text="Monthly" Value="Monthly" />
                    <asp:ListItem Text="Quarterly" Value="Quarterly" />
                    <asp:ListItem Text="Yearly" Value="Yearly" />
                    <asp:ListItem Text="Custom Range" Value="Custom" />
                </asp:DropDownList>
            </div>

            <div class="lp-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlYear"
                    Text="Year" />
                <asp:DropDownList ID="ddlYear"
                    runat="server"
                    CssClass="lp-input" />
            </div>

            <div class="lp-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlMonth"
                    Text="Month (Monthly Reports)" />
                <asp:DropDownList ID="ddlMonth"
                    runat="server"
                    CssClass="lp-input">
                    <asp:ListItem Text="January" Value="1" />
                    <asp:ListItem Text="February" Value="2" />
                    <asp:ListItem Text="March" Value="3" />
                    <asp:ListItem Text="April" Value="4" />
                    <asp:ListItem Text="May" Value="5" />
                    <asp:ListItem Text="June" Value="6" />
                    <asp:ListItem Text="July" Value="7" />
                    <asp:ListItem Text="August" Value="8" />
                    <asp:ListItem Text="September" Value="9" />
                    <asp:ListItem Text="October" Value="10" />
                    <asp:ListItem Text="November" Value="11" />
                    <asp:ListItem Text="December" Value="12" />
                </asp:DropDownList>
            </div>

            <div class="lp-field">
                <asp:Label runat="server"
                    AssociatedControlID="ddlQuarter"
                    Text="Quarter (Quarterly Reports)" />
                <asp:DropDownList ID="ddlQuarter"
                    runat="server"
                    CssClass="lp-input">
                    <asp:ListItem Text="Q1 - Jan to Mar" Value="1" />
                    <asp:ListItem Text="Q2 - Apr to Jun" Value="2" />
                    <asp:ListItem Text="Q3 - Jul to Sep" Value="3" />
                    <asp:ListItem Text="Q4 - Oct to Dec" Value="4" />
                </asp:DropDownList>
            </div>

            <div class="lp-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtFrom"
                    Text="Custom Date From" />
                <asp:TextBox ID="txtFrom"
                    runat="server"
                    TextMode="Date"
                    CssClass="lp-input" />
            </div>

            <div class="lp-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtTo"
                    Text="Custom Date To" />
                <asp:TextBox ID="txtTo"
                    runat="server"
                    TextMode="Date"
                    CssClass="lp-input" />
            </div>

        </div>

        <div class="lp-actions">
            <asp:Button ID="btnGenerate"
                runat="server"
                Text="Generate Consolidated Report"
                CssClass="lp-btn"
                OnClick="btnGenerate_Click" />
            <span class="lp-badge">PDF / Excel Export</span>
        </div>

        <p class="lp-note">
            Select a period type, then click Generate.
            Monthly uses Month and Year; Quarterly uses Quarter and Year;
            Yearly uses Year; Custom uses Date From and Date To.
            No database query runs when changing a filter.
        </p>

        <asp:Label ID="lblError"
            runat="server"
            CssClass="lp-error"
            EnableViewState="false" />

    </section>

    <asp:Panel ID="pnlResults"
        runat="server"
        Visible="false">

        <div class="lp-stats">
            <div class="lp-stat">
                <span>Collected Borrowings</span>
                <strong>
                    <asp:Label ID="lblBorrowings" runat="server" />
                </strong>
            </div>

            <div class="lp-stat">
                <span>Online Conversion Rate</span>
                <strong>
                    <asp:Label ID="lblConversion" runat="server" />
                </strong>
            </div>

            <div class="lp-stat">
                <span>Gross Fee Payments</span>
                <strong>
                    <asp:Label ID="lblGross" runat="server" />
                </strong>
            </div>

            <div class="lp-stat highlight">
                <span>Net Fee Collections</span>
                <strong>
                    <asp:Label ID="lblNet" runat="server" />
                </strong>
            </div>
        </div>

        <p class="lp-snapshot">
            <asp:Label ID="lblSnapshot"
                runat="server" />
        </p>

        <section class="lp-panel">
            <h2>Consolidated Report Preview</h2>

            <div class="lp-viewer">
                <asp:ScriptManager ID="smReport"
                    runat="server" />

                <rsweb:ReportViewer ID="rvReport"
                    runat="server"
                    ProcessingMode="Local"
                    Width="100%"
                    Height="700px"
                    AsyncRendering="false"
                    SizeToReportContent="false"
                    ShowExportControls="true"
                    ShowRefreshButton="false"
                    ShowParameterPrompts="false" />
            </div>

            <p class="lp-note">
                Use the ReportViewer export menu to save a PDF
                or Excel workbook. Snapshot metrics use the
                database state when the report was generated.
            </p>
        </section>

    </asp:Panel>

    <asp:Panel ID="pnlEmpty"
        runat="server"
        CssClass="lp-empty">
        Select your reporting period and click
        <strong>Generate Consolidated Report</strong>.
    </asp:Panel>

</div>
</asp:Content>
