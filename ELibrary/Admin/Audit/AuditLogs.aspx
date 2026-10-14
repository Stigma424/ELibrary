
<%@ Page Title="Audit Logs"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="AuditLogs.aspx.cs"
    Inherits="ELibrary.Admin.Audit.AuditLogs" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <style>
        .audit-page {
            max-width: 1450px;
            margin: 30px auto;
            padding: 0 16px;
        }

        .audit-title {
            color: #142d52;
            font-size: 27px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .audit-subtitle {
            color: #64748b;
            margin-bottom: 25px;
        }

        .audit-panel {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 22px;
            margin-bottom: 20px;
        }

        .audit-filters {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
        }

        .audit-field label {
            display: block;
            color: #334155;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 7px;
        }

        .audit-input {
            width: 100%;
            min-height: 39px;
            padding: 8px 11px;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
            background: white;
            color: #1e293b;
        }

        .audit-actions {
            display: flex;
            gap: 10px;
            margin-top: 18px;
            flex-wrap: wrap;
        }

        .audit-button {
            border: 0;
            border-radius: 7px;
            padding: 10px 17px;
            background: #173b6c;
            color: white;
            font-weight: 600;
        }

        .audit-button:hover {
            background: #102a4e;
            color: white;
        }

        .audit-button-secondary {
            background: #e8eef6;
            color: #173b6c;
        }

        .audit-button-secondary:hover {
            background: #dce6f3;
            color: #173b6c;
        }

        .audit-table-wrapper {
            overflow-x: auto;
        }

        .audit-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .audit-table th {
            background: #f1f5f9;
            color: #334155;
            font-weight: 700;
            text-align: left;
            padding: 13px 11px;
            white-space: nowrap;
        }

        .audit-table td {
            border-top: 1px solid #e2e8f0;
            padding: 13px 11px;
            color: #334155;
            vertical-align: top;
        }

        .audit-table tr:hover td {
            background: #f8fafc;
        }

        .audit-category {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 6px;
            background: #e8eef6;
            color: #173b6c;
            font-weight: 600;
            font-size: 12px;
        }

        .audit-empty {
            padding: 30px;
            text-align: center;
            color: #64748b;
        }

        .audit-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 18px;
        }

        .audit-message {
            display: block;
            margin-bottom: 14px;
            color: #b91c1c;
        }

        @media (max-width: 1000px) {
            .audit-filters {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 600px) {
            .audit-filters {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <div class="audit-page">

        <h2 class="audit-title">Audit Logs</h2>

        <p class="audit-subtitle">
            Track reservation, transaction, and archive activity.
        </p>

        <asp:Label
            ID="lblMessage"
            runat="server"
            CssClass="audit-message" />

        <div class="audit-panel">

            <div class="audit-filters">

                <div class="audit-field">
                    <label>Search</label>

                    <asp:TextBox
                        ID="txtSearch"
                        runat="server"
                        CssClass="audit-input"
                        placeholder="Book, user, ID, or action" />
                </div>

                <div class="audit-field">
                    <label>Category</label>

                    <asp:DropDownList
                        ID="ddlCategory"
                        runat="server"
                        CssClass="audit-input">

                        <asp:ListItem Text="All Categories" Value="" />
                        <asp:ListItem Text="Reservation" Value="Reservation" />
                        <asp:ListItem Text="Transaction" Value="Transaction" />
                        <asp:ListItem Text="Archive" Value="Archive" />
                        <asp:ListItem Text="Other" Value="Other" />

                    </asp:DropDownList>
                </div>

                <div class="audit-field">
                    <label>Action</label>

                    <asp:DropDownList
                        ID="ddlAction"
                        runat="server"
                        CssClass="audit-input">

                        <asp:ListItem Text="All Actions" Value="" />
                        <asp:ListItem Text="Reservation Created" Value="Reservation Created%" />
                        <asp:ListItem Text="Collection Confirmed" Value="Collection Confirmed%" />
                        <asp:ListItem Text="Reservation Cancelled" Value="Reservation Cancelled%" />
                        <asp:ListItem Text="Book Returned" Value="Book Returned%" />
                        <asp:ListItem Text="Payment Processed" Value="Payment Processed%" />
                        <asp:ListItem Text="Book Archived" Value="Archived book:%" />
                        <asp:ListItem Text="Book Restored" Value="Restored book:%" />

                    </asp:DropDownList>
                </div>

                <div class="audit-field">
                    <label>Sort By</label>

                    <asp:DropDownList
                        ID="ddlSort"
                        runat="server"
                        CssClass="audit-input">

                        <asp:ListItem Text="Newest First" Value="date-desc" />
                        <asp:ListItem Text="Oldest First" Value="date-asc" />
                        <asp:ListItem Text="Highest Log ID" Value="id-desc" />
                        <asp:ListItem Text="Lowest Log ID" Value="id-asc" />

                    </asp:DropDownList>
                </div>

                <div class="audit-field">
                    <label>Date From</label>

                    <asp:TextBox
                        ID="txtDateFrom"
                        runat="server"
                        TextMode="Date"
                        CssClass="audit-input" />
                </div>

                <div class="audit-field">
                    <label>Date To</label>

                    <asp:TextBox
                        ID="txtDateTo"
                        runat="server"
                        TextMode="Date"
                        CssClass="audit-input" />
                </div>

                <div class="audit-field">
                    <label>Records Per Page</label>

                    <asp:DropDownList
                        ID="ddlPageSize"
                        runat="server"
                        CssClass="audit-input">

                        <asp:ListItem Text="10" Value="10" />
                        <asp:ListItem Text="20" Value="20" />
                        <asp:ListItem Text="50" Value="50" />

                    </asp:DropDownList>
                </div>

            </div>

            <div class="audit-actions">

                <asp:Button
                    ID="btnApply"
                    runat="server"
                    Text="Apply Filters"
                    CssClass="audit-button"
                    OnClick="btnApply_Click" />

                <asp:Button
                    ID="btnClear"
                    runat="server"
                    Text="Clear Filters"
                    CssClass="audit-button audit-button-secondary"
                    OnClick="btnClear_Click" />

            </div>

        </div>

        <div class="audit-panel">

            <div class="audit-table-wrapper">

                <asp:GridView
                    ID="gvAuditLogs"
                    runat="server"
                    AutoGenerateColumns="false"
                    GridLines="None"
                    CssClass="audit-table"
                    ShowHeaderWhenEmpty="true"
                    EmptyDataText="No audit records found.">

                    <Columns>

                        <asp:BoundField
                            DataField="LogID"
                            HeaderText="Log ID" />

                        <asp:BoundField
                            DataField="FullName"
                            HeaderText="Performed By"
                            HtmlEncode="true" />

                        <asp:TemplateField HeaderText="Category">
                            <ItemTemplate>
                                <span class="audit-category">
                                    <%#: Eval("ActionCategory") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField
                            DataField="ActionDesc"
                            HeaderText="Action"
                            HtmlEncode="true" />

                        <asp:BoundField
                            DataField="BookID"
                            HeaderText="Book ID"
                            NullDisplayText="—" />

                        <asp:BoundField
                            DataField="Title"
                            HeaderText="Book"
                            HtmlEncode="true" />

                        <asp:BoundField
                            DataField="BorrowLogID"
                            HeaderText="Borrow Log ID"
                            NullDisplayText="—" />

                        <asp:BoundField
                            DataField="ArchiveID"
                            HeaderText="Archive ID"
                            NullDisplayText="—" />

                        <asp:BoundField
                            DataField="TimeStamp"
                            HeaderText="Date / Time"
                            DataFormatString="{0:MMM dd, yyyy hh:mm tt}"
                            HtmlEncode="true" />

                    </Columns>

                    <EmptyDataRowStyle CssClass="audit-empty" />

                </asp:GridView>

            </div>

            <div class="audit-footer">

                <asp:Label
                    ID="lblRecords"
                    runat="server" />

                <div class="audit-actions">

                    <asp:Button
                        ID="btnPrevious"
                        runat="server"
                        Text="Previous"
                        CssClass="audit-button audit-button-secondary"
                        OnClick="btnPrevious_Click" />

                    <asp:Label
                        ID="lblPage"
                        runat="server" />

                    <asp:Button
                        ID="btnNext"
                        runat="server"
                        Text="Next"
                        CssClass="audit-button audit-button-secondary"
                        OnClick="btnNext_Click" />

                </div>

            </div>

        </div>

    </div>

</asp:Content>
