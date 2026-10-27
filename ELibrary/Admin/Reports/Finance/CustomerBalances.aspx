
<%@ Page Title="Customer Outstanding Balances"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="CustomerBalances.aspx.cs"
    Inherits="ELibrary.Admin.Reports.Finance.CustomerBalances" %>
<%@ Register
    Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms"
    TagPrefix="rsweb" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>
    .bal-page{max-width:1400px;margin:auto;color:#123B4A}
    .bal-page *{box-sizing:border-box}
    .bal-back{display:inline-block;color:#168A91;font-size:12px;font-weight:800;text-decoration:none;margin-bottom:18px}
    .bal-header{margin-bottom:24px}
    .bal-eyebrow{display:block;color:#168A91;letter-spacing:1.4px;font-size:11px;font-weight:800}
    .bal-header h1{font-size:30px;font-weight:850;margin:8px 0}
    .bal-header p{color:#647F89;font-size:13px;line-height:1.8;margin:0}
    .bal-panel{background:white;border:1px solid #DCE9EB;border-radius:15px;padding:23px;margin-bottom:20px;min-width:0}
    .bal-panel h2{margin:0 0 17px;font-size:17px;font-weight:800}
    .bal-grid{display:grid;grid-template-columns:2fr 1fr 1fr;gap:15px;align-items:end}
    .bal-field label{display:block;font-size:12px;font-weight:750;margin-bottom:8px}
    .bal-input{min-height:43px;width:100%;border:1px solid #D0E2E5;border-radius:9px;background:white;color:#123B4A;padding:10px 12px;font-size:13px}
    .bal-bottom{display:flex;justify-content:space-between;align-items:center;gap:14px;margin-top:18px}
    .bal-btn{min-height:43px;background:#168A91;color:white;border:0;border-radius:9px;padding:11px 20px;font-weight:800;font-size:12px;cursor:pointer}
    .bal-btn:hover{background:#12757C}
    .bal-note{color:#647F89;font-size:12px;line-height:1.7}
    .bal-error{display:block;color:#B94E49;font-size:12px;margin-top:12px}
    .bal-summary{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px;margin-bottom:20px}
    .bal-stat{background:white;border:1px solid #DCE9EB;border-radius:13px;padding:20px}
    .bal-stat span{display:block;color:#647F89;font-size:12px;margin-bottom:8px}
    .bal-stat strong{font-size:23px;font-weight:850;color:#168A91}
    .bal-viewer{border:1px solid #DCE9EB;border-radius:10px;min-height:650px;overflow-x:auto}
    .bal-empty{border:1px solid #DCE9EB;border-radius:13px;background:#F4F9FA;color:#647F89;text-align:center;padding:32px;font-size:13px}
    @media(max-width:850px){.bal-grid{grid-template-columns:1fr 1fr}.bal-search{grid-column:1/-1}}
    @media(max-width:600px){.bal-grid,.bal-summary{grid-template-columns:1fr}.bal-search{grid-column:auto}.bal-header h1{font-size:25px}.bal-bottom{flex-direction:column;align-items:stretch}.bal-btn{width:100%}.bal-panel{padding:17px}}
</style>
</asp:Content>

<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
<div class="bal-page">
    <a class="bal-back" href="<%= ResolveUrl("~/Admin/Reports/Reports.aspx") %>">
        &#8592; Back to Reports &amp; Analytics
    </a>

    <header class="bal-header">
        <span class="bal-eyebrow">ADMINISTRATION / FINANCIAL REPORTS</span>
        <h1>Customer Outstanding Balances</h1>
        <p>
            Review customers with unpaid borrowing, late, or
            replacement fees. Results reflect current receipt balances.
        </p>
    </header>

    <section class="bal-panel">
        <h2>Report Filters</h2>
        <div class="bal-grid">
            <div class="bal-field bal-search">
                <asp:Label runat="server" AssociatedControlID="txtSearch"
                    Text="Search Customer, Book or Receipt" />
                <asp:TextBox ID="txtSearch" runat="server"
                    CssClass="bal-input" MaxLength="150"
                    placeholder="Name, email, book title, receipt number" />
            </div>
            <div class="bal-field">
                <asp:Label runat="server" AssociatedControlID="ddlFeeType"
                    Text="Fee Type" />
                <asp:DropDownList ID="ddlFeeType" runat="server" CssClass="bal-input">
                    <asp:ListItem Text="All Fee Types" Value="" />
                    <asp:ListItem Text="Borrowing Fee" Value="Borrowing Fee" />
                    <asp:ListItem Text="Late Fee" Value="Late Fee" />
                    <asp:ListItem Text="Replacement Fee" Value="Replacement Fee" />
                </asp:DropDownList>
            </div>
            <div class="bal-field">
                <asp:Label runat="server" AssociatedControlID="ddlMinimum"
                    Text="Minimum Outstanding" />
                <asp:DropDownList ID="ddlMinimum" runat="server" CssClass="bal-input">
                    <asp:ListItem Text="Any Amount" Value="0.01" />
                    <asp:ListItem Text="₱50 or More" Value="50.00" />
                    <asp:ListItem Text="₱100 or More" Value="100.00" />
                    <asp:ListItem Text="₱250 or More" Value="250.00" />
                    <asp:ListItem Text="₱500 or More" Value="500.00" />
                </asp:DropDownList>
            </div>
        </div>

        <div class="bal-bottom">
            <span class="bal-note">
                This is a current balance snapshot, not a past-period report.
                Filters apply when you generate the report.
            </span>
            <asp:Button ID="btnGenerate" runat="server" Text="Generate Report"
                CssClass="bal-btn" OnClick="btnGenerate_Click" />
        </div>

        <asp:Label ID="lblError" runat="server"
            CssClass="bal-error" EnableViewState="false" />
    </section>

    <asp:Panel ID="pnlResults" runat="server" Visible="false">
        <div class="bal-summary">
            <div class="bal-stat">
                <span>Unpaid Receipts</span>
                <strong><asp:Label ID="lblReceipts" runat="server" /></strong>
            </div>
            <div class="bal-stat">
                <span>Total Outstanding Balance</span>
                <strong><asp:Label ID="lblOutstanding" runat="server" /></strong>
            </div>
        </div>

        <section class="bal-panel">
            <h2>Outstanding Receipt Details</h2>
            <div class="bal-viewer">
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

    <asp:Panel ID="pnlEmpty" runat="server" CssClass="bal-empty">
        Click <strong>Generate Report</strong> to view outstanding receipts.
    </asp:Panel>
</div>
</asp:Content>
