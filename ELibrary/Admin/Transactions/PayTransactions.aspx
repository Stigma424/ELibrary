
<%@ Page Title="Record Payment"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="PayTransactions.aspx.cs"
    Inherits="ELibrary.Admin.Transactions.PayTransaction" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="container mt-4">

        <h2>Record Payment</h2>

        <asp:Label
            ID="lblMessage"
            runat="server"
            CssClass="text-danger">
        </asp:Label>

        <div class="card p-4 mt-3">

            <div class="mb-3">
                <label>Customer</label>

                <asp:Label
                    ID="lblCustomer"
                    runat="server"
                    CssClass="form-control">
                </asp:Label>
            </div>

            <div class="mb-3">
                <label>Book</label>

                <asp:Label
                    ID="lblBook"
                    runat="server"
                    CssClass="form-control">
                </asp:Label>
            </div>

            <div class="mb-3">
                <label>Fee Type</label>

                <asp:Label
                    ID="lblFeeType"
                    runat="server"
                    CssClass="form-control">
                </asp:Label>
            </div>

            <div class="mb-3">
                <label>Outstanding Balance</label>

                <asp:Label
                    ID="lblBalance"
                    runat="server"
                    CssClass="form-control">
                </asp:Label>
            </div>

            <div class="mb-3">
                <label>Amount Paid</label>

                <asp:TextBox
                    ID="txtAmountPaid"
                    runat="server"
                    CssClass="form-control"
                    TextMode="Number"
                    step="0.01"
                    min="0.01">
                </asp:TextBox>

                <asp:RequiredFieldValidator
                    ID="rfvAmountPaid"
                    runat="server"
                    ControlToValidate="txtAmountPaid"
                    ErrorMessage="Payment amount is required."
                    CssClass="text-danger"
                    Display="Dynamic"
                    ValidationGroup="Payment">
                </asp:RequiredFieldValidator>
            </div>

            <div class="mb-3">
                <label>Payment Method</label>

                <asp:DropDownList
                    ID="ddlPaymentMethod"
                    runat="server"
                    CssClass="form-control">

                    <asp:ListItem
                        Text="Cash"
                        Value="Cash" />

                    <asp:ListItem
                        Text="GCash"
                        Value="GCash" />

                    <asp:ListItem
                        Text="Card"
                        Value="Card" />

                    <asp:ListItem
                        Text="Bank Transfer"
                        Value="Bank Transfer" />

                </asp:DropDownList>
            </div>

            <div>
                <asp:Button
                    ID="btnRecordPayment"
                    runat="server"
                    Text="Record Payment"
                    CssClass="btn btn-success"
                    ValidationGroup="Payment"
                    OnClick="btnRecordPayment_Click"
                    UseSubmitBehavior="true" />

                <asp:Button
                    ID="btnCancel"
                    runat="server"
                    Text="Cancel"
                    CssClass="btn btn-secondary"
                    CausesValidation="false"
                    OnClick="btnCancel_Click" />
            </div>

        </div>

    </div>

</asp:Content>
