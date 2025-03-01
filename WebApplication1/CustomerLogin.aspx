<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerLogin.aspx.cs" Inherits="WebApplication1.WebForm2" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Login</title>
    <link href="CustomerLoginStyles.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align: center; margin-top: 100px;">
            <h2>Customer Login</h2>
            <table style="margin: auto;">
                <tr>
                    <td>
                        <label for="txtMobileNumber">Mobile Number:</label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtMobileNumber" runat="server" MaxLength="11" Width="200px" Placeholder="Enter Mobile Number"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="txtPassword">Password:</label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="200px" Placeholder="Enter Password"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center;">
                        <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center; color: red;">
                        <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
