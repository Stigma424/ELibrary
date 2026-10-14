<%@ Page Title="Archived Books"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="ArchiveBooks.aspx.cs"
    Inherits="ELibrary.Admin.Archive.ArchiveBooks" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <style>
        .el-archive {
            color: #172b43;
        }

        .el-archive * {
            box-sizing: border-box;
        }

        .el-archive-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 24px;
        }

        .el-archive-eyebrow {
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .12em;
            color: #2f6ba0;
        }

        .el-archive h1 {
            font-size: 29px;
            font-weight: 750;
            margin: 7px 0;
        }

        .el-archive-header p,
        .el-archive-panel-head p {
            color: #718096;
            margin: 5px 0 0;
        }

        .el-archive-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 40px;
            padding: 9px 15px;
            border: 1px solid #dce5ee;
            border-radius: 8px;
            background: #fff;
            color: #172b43;
            font-size: 13px;
            font-weight: 650;
            cursor: pointer;
            white-space: nowrap;
        }

        .el-archive-btn:hover {
            background: #f1f6fb;
        }

        .el-archive-btn.primary {
            background: #2f6ba0;
            color: #fff;
            border-color: #2f6ba0;
        }

        .el-archive-btn.primary:hover {
            background: #235680;
        }

        .el-archive-btn:disabled {
            opacity: .45;
            cursor: default;
        }

        .el-archive-panel {
            background: #fff;
            border: 1px solid #e4ebf3;
            border-radius: 13px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 3px 14px rgba(23,43,67,.04);
        }

        .el-archive-panel-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 18px;
        }

        .el-archive-panel-head h2 {
            font-size: 19px;
            font-weight: 750;
            margin: 0;
        }

        .el-archive-tag {
            background: #eaf1f9;
            color: #2f6ba0;
            padding: 6px 11px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 750;
        }

        .el-archive-filters {
            display: grid;
            grid-template-columns:
                minmax(200px,2fr)
                repeat(2,minmax(150px,1fr))
                auto;
            gap: 12px;
            align-items: end;
            padding: 16px;
            background: #f8fafc;
            border: 1px solid #e4ebf3;
            border-radius: 10px;
        }

        .el-archive-field {
            min-width: 0;
        }

        .el-archive-field label {
            display: block;
            margin-bottom: 7px;
            color: #43566b;
            font-size: 12px;
            font-weight: 700;
        }

        .el-archive-field input,
        .el-archive-field select {
            display: block;
            width: 100%;
            min-height: 40px;
            padding: 9px 11px;
            background: #fff;
            color: #172b43;
            border: 1px solid #dce5ee;
            border-radius: 8px;
            font-size: 13px;
        }

        .el-archive-field input:focus,
        .el-archive-field select:focus {
            outline: none;
            border-color: #2f6ba0;
            box-shadow: 0 0 0 3px rgba(47,107,160,.12);
        }

        .el-archive-actions {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .el-archive-count {
            display: block;
            margin: 12px 0;
            font-size: 12px;
            color: #718096;
        }

        .el-archive-table-wrap {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        .el-archive-table {
            width: 100%;
            min-width: 850px;
            border-collapse: collapse;
            font-size: 13px;
        }

        .el-archive-table th {
            background: #f4f7fb;
            color: #52647a;
            text-align: left;
            text-transform: uppercase;
            font-size: 11px;
            letter-spacing: .04em;
            padding: 13px 12px;
            white-space: nowrap;
            border-bottom: 1px solid #e4ebf3;
        }

        .el-archive-table td {
            padding: 13px 12px;
            border-bottom: 1px solid #edf1f5;
            vertical-align: middle;
        }

        .el-archive-table tr:hover td {
            background: #f9fbfe;
        }

        .el-archive-restore {
            background: #e6f7ec;
            color: #237c4e;
            border: 1px solid #ccebd9;
            border-radius: 7px;
            padding: 8px 12px;
            font-size: 12px;
            font-weight: 750;
            cursor: pointer;
            white-space: nowrap;
        }

        .el-archive-restore:hover {
            background: #d5efdf;
        }

        .el-archive .text-danger {
            display: block;
            color: #bd4141;
            margin-bottom: 14px;
        }

        .el-archive .text-success {
            display: block;
            color: #237c4e;
            margin-bottom: 14px;
        }

        .el-archive-pager {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 12px;
            padding: 18px 0 4px;
        }

        .el-archive-page-info {
            font-size: 13px;
            color: #61748e;
        }

        @media(max-width:1050px) {
            .el-archive-filters {
                grid-template-columns:
                    repeat(2,minmax(0,1fr));
            }

            .el-archive-actions {
                grid-column: 1 / -1;
            }
        }

        @media(max-width:600px) {
            .el-archive h1 {
                font-size: 24px;
            }

            .el-archive-panel {
                padding: 14px;
            }

            .el-archive-filters {
                grid-template-columns: 1fr;
                padding: 12px;
            }

            .el-archive-actions {
                grid-column: auto;
                flex-wrap: wrap;
            }

            .el-archive-btn.primary {
                width: 100%;
            }
        }
    </style>

    <div class="el-archive">

        <div class="el-archive-header">
            <div>
                <span class="el-archive-eyebrow">
                    ADMINISTRATION / LIBRARY ARCHIVE
                </span>

                <h1>Archived Books</h1>

                <p>
                    Review archived books and restore them
                    to the library.
                </p>
            </div>

            <asp:Button
                ID="btnRefresh"
                runat="server"
                Text="Refresh"
                CssClass="el-archive-btn primary"
                CausesValidation="false"
                OnClick="btnRefresh_Click" />
        </div>

        <asp:Label
            ID="lblMessage"
            runat="server"
            EnableViewState="false" />

        <section class="el-archive-panel">

            <div class="el-archive-panel-head">
                <div>
                    <h2>Archived Book Records</h2>
                    <p>
                        Search, filter, and manage archived
                        library books.
                    </p>
                </div>

                <span class="el-archive-tag">
                    ARCHIVE MANAGEMENT
                </span>
            </div>

            <!-- SEARCH AND FILTER -->

            <asp:Panel
                ID="pnlArchiveFilters"
                runat="server"
                DefaultButton="btnApply"
                CssClass="el-archive-filters">

                <div class="el-archive-field">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="txtSearch"
                        Text="Search Archived Books" />

                    <asp:TextBox
                        ID="txtSearch"
                        runat="server"
                        MaxLength="255"
                        placeholder="Search ID, title, ISBN, reason..."
                        autocomplete="off" />

                </div>

                <div class="el-archive-field">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlReason"
                        Text="Archive Reason" />

                    <asp:DropDownList
                        ID="ddlReason"
                        runat="server">

                        <asp:ListItem
                            Text="All Reasons"
                            Value="" />

                    </asp:DropDownList>

                </div>

                <div class="el-archive-field">

                    <asp:Label
                        runat="server"
                        AssociatedControlID="ddlSort"
                        Text="Sort By" />

                    <asp:DropDownList
                        ID="ddlSort"
                        runat="server">

                        <asp:ListItem
                            Text="Default Order"
                            Value="Default" />

                        <asp:ListItem
                            Text="Recently Archived"
                            Value="DateDesc" />

                        <asp:ListItem
                            Text="Oldest Archived"
                            Value="DateAsc" />

                        <asp:ListItem
                            Text="Highest Archive ID"
                            Value="IDDesc" />

                        <asp:ListItem
                            Text="Lowest Archive ID"
                            Value="IDAsc" />

                        <asp:ListItem
                            Text="Title (A–Z)"
                            Value="TitleAsc" />

                        <asp:ListItem
                            Text="Title (Z–A)"
                            Value="TitleDesc" />

                    </asp:DropDownList>

                </div>

                <div class="el-archive-actions">

                    <asp:Button
                        ID="btnApply"
                        runat="server"
                        Text="Apply"
                        CssClass="el-archive-btn primary"
                        CausesValidation="false"
                        OnClick="btnApply_Click" />

                    <asp:Button
                        ID="btnClearFilters"
                        runat="server"
                        Text="Clear Filters"
                        CssClass="el-archive-btn"
                        CausesValidation="false"
                        OnClick="btnClearFilters_Click" />

                </div>

            </asp:Panel>

            <p class="el-archive-count">
                Press Enter or click Apply to search and filter.
            </p>

            <asp:Label
                ID="lblResultCount"
                runat="server"
                CssClass="el-archive-count"
                Text="Showing archived books" />

            <!-- ARCHIVED BOOKS TABLE -->

            <div class="el-archive-table-wrap">

                <asp:GridView
                    ID="gvArchivedBooks"
                    runat="server"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    CssClass="el-archive-table"
                    EmptyDataText="No archived books match your filters."
                    OnRowCommand="gvArchivedBooks_RowCommand">

                    <Columns>

                        <asp:BoundField
                            DataField="ArchiveID"
                            HeaderText="Archive ID" />

                        <asp:BoundField
                            DataField="BookID"
                            HeaderText="Book ID" />

                        <asp:BoundField
                            DataField="Title"
                            HeaderText="Title" />

                        <asp:BoundField
                            DataField="ISBN"
                            HeaderText="ISBN" />

                        <asp:BoundField
                            DataField="Reason"
                            HeaderText="Archive Reason" />

                        <asp:BoundField
                            DataField="ArchivedDate"
                            HeaderText="Archived Date"
                            DataFormatString="{0:MMM dd, yyyy hh:mm tt}" />

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>

                                <asp:Button
                                    ID="btnRestore"
                                    runat="server"
                                    Text="Restore Book"
                                    CssClass="el-archive-restore"
                                    CommandName="RestoreBook"
                                    CommandArgument='<%# Eval("ArchiveID") %>'
                                    CausesValidation="false"
                                    OnClientClick="return confirm('Restore this book?');" />

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

            <!-- PAGINATION -->

            <div class="el-archive-pager">

                <asp:Button
                    ID="btnPrevious"
                    runat="server"
                    Text="← Previous"
                    CssClass="el-archive-btn"
                    CausesValidation="false"
                    OnClick="btnPrevious_Click" />

                <asp:Label
                    ID="lblPageInfo"
                    runat="server"
                    CssClass="el-archive-page-info"
                    Text="Page 1 of 1" />

                <asp:Button
                    ID="btnNext"
                    runat="server"
                    Text="Next →"
                    CssClass="el-archive-btn"
                    CausesValidation="false"
                    OnClick="btnNext_Click" />

            </div>

        </section>

    </div>

</asp:Content>