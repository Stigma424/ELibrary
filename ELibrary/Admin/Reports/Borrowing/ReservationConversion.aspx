
<%@ Page Title="Reservation Conversion Report"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ReservationConversion.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Borrowing.ReservationConversion" %>

<%@ Register
    Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<asp:Content ID="HeadBlock"
    ContentPlaceHolderID="head"
    runat="server">

<style>
    .rc-page{max-width:1400px;margin:0 auto;color:#123B4A}
    .rc-page *{box-sizing:border-box}
    .rc-back{display:inline-block;color:#168A91;font-size:12px;font-weight:800;text-decoration:none;margin-bottom:18px}
    .rc-header{margin-bottom:24px}
    .rc-eyebrow{display:block;color:#168A91;font-size:11px;font-weight:800;letter-spacing:1.4px}
    .rc-header h1{font-size:30px;font-weight:850;margin:8px 0}
    .rc-header p{color:#647F89;font-size:13px;margin:0;line-height:1.8}
    .rc-panel{background:#fff;border:1px solid #DCE9EB;border-radius:15px;padding:23px;margin-bottom:20px}
    .rc-panel h2{font-size:17px;font-weight:800;margin:0 0 17px}
    .rc-filter{display:grid;grid-template-columns:1fr 1fr auto;gap:15px;align-items:end}
    .rc-field label{display:block;font-size:12px;font-weight:750;margin-bottom:8px}
    .rc-control{display:block;width:100%;min-height:43px;border:1px solid #D0E2E5;border-radius:9px;padding:10px 12px;color:#123B4A;background:#fff;font-size:13px}
    .rc-btn{min-height:43px;border:0;background:#168A91;color:#fff;padding:11px 19px;border-radius:9px;font-size:12px;font-weight:800;cursor:pointer}
    .rc-btn:hover{background:#12757C}
    .rc-error{display:block;margin-top:12px;color:#B94E49;font-size:12px}
    .rc-cards{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:13px;margin-bottom:20px}
    .rc-card{background:#fff;border:1px solid #DCE9EB;border-radius:13px;padding:18px;min-width:0}
    .rc-card span{display:block;font-size:11px;color:#647F89;margin-bottom:9px}
    .rc-card strong{display:block;font-size:23px;font-weight:850;color:#123B4A}
    .rc-card.highlight strong{color:#168A91}
    .rc-preview{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-bottom:16px}
    .rc-preview h2{margin:0}
    .rc-viewer{width:100%;min-height:650px;overflow-x:auto;border:1px solid #DCE9EB;border-radius:10px}
    .rc-empty{border:1px solid #DCE9EB;border-radius:13px;background:#F4F9FA;color:#647F89;text-align:center;padding:32px;font-size:13px}
    .rc-footnote{font-size:12px;color:#647F89;line-height:1.7;margin-top:13px}
    @media(max-width:950px){.rc-cards{grid-template-columns:repeat(2,1fr)}}
    @media(max-width:650px){
        .rc-filter{grid-template-columns:1fr}
        .rc-cards{grid-template-columns:1fr}
        .rc-header h1{font-size:25px}
        .rc-panel{padding:17px}
        .rc-btn{width:100%}
    }
</style>

</asp:Content>

<asp:Content ID="MainBlock"
    ContentPlaceHolderID="MainContent"
    runat="server">

<div class="rc-page">

    <a class="rc-back"
       href="<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>">
        &#8592; Back to Reports &amp; Analytics
    </a>

    <header class="rc-header">
        <span class="rc-eyebrow">
            ADMINISTRATION / BORROWING REPORTS
        </span>
        <h1>Reservation Conversion Report</h1>
        <p>
            See how online reservation requests progress
            to collection, cancellation or expiration.
            Results reflect current recorded outcomes.
        </p>
    </header>

    <section class="rc-panel">
        <h2>Reporting Period</h2>

        <div class="rc-filter">

            <div class="rc-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtDateFrom"
                    Text="Date From" />
                <asp:TextBox ID="txtDateFrom"
                    runat="server"
                    TextMode="Date"
                    CssClass="rc-control" />
            </div>

            <div class="rc-field">
                <asp:Label runat="server"
                    AssociatedControlID="txtDateTo"
                    Text="Date To" />
                <asp:TextBox ID="txtDateTo"
                    runat="server"
                    TextMode="Date"
                    CssClass="rc-control" />
            </div>

            <asp:Button ID="btnGenerate"
                runat="server"
                Text="Generate Report"
                CssClass="rc-btn"
                OnClick="btnGenerate_Click" />

        </div>

        <asp:Label ID="lblMessage"
            runat="server"
            CssClass="rc-error"
            EnableViewState="false" />
    </section>

    <asp:Panel ID="pnlResults"
        runat="server"
        Visible="false">

        <div class="rc-cards">

            <div class="rc-card">
                <span>Total Online Reservations</span>
                <strong>
                    <asp:Label ID="lblTotal"
                        runat="server" />
                </strong>
            </div>

            <div class="rc-card">
                <span>Collected</span>
                <strong>
                    <asp:Label ID="lblCollected"
                        runat="server" />
                </strong>
            </div>

            <div class="rc-card">
                <span>Not Collected</span>
                <strong>
                    <asp:Label ID="lblNotCollected"
                        runat="server" />
                </strong>
            </div>

            <div class="rc-card highlight">
                <span>Pickup Conversion Rate</span>
                <strong>
                    <asp:Label ID="lblRate"
                        runat="server" />
                </strong>
            </div>

        </div>

        <section class="rc-panel">
            <div class="rc-preview">
                <h2>Reservation Records</h2>
            </div>

            <div class="rc-viewer">
                <asp:ScriptManager ID="smReport"
                    runat="server" />

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

            <p class="rc-footnote">
                The conversion rate is calculated from
                online reservations created in the
                selected period. Pending reservations
                are included in the denominator.
                Expired labels depend on recorded
                cancellation reasons.
            </p>
        </section>

    </asp:Panel>

    <asp:Panel ID="pnlEmpty"
        runat="server"
        CssClass="rc-empty">
        Select a date range and click
        <strong>Generate Report</strong>
        to analyze online reservations.
    </asp:Panel>

</div>

</asp:Content>
