<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminCustomer.aspx.cs" Inherits="WebApplication1.WebForm1" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin or Customer</title>
    <link href="AdminCustomerStyles.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align: center; margin-top: 50px;">
            <h1>Welcome! Please Choose Your Role</h1>
            <asp:Button ID="btnAdmin" runat="server" Text="Admin" OnClick="btnAdmin_Click" 
                Style="margin: 20px; padding: 10px 20px; font-size: 16px;" />
            <asp:Button ID="btnCustomer" runat="server" Text="Customer" OnClick="btnCustomer_Click" 
                Style="margin: 20px; padding: 10px 20px; font-size: 16px;" />
        </div>
    </form>
</body>
</html>
