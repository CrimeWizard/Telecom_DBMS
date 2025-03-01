<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerDashboard.aspx.cs" Inherits="WebApplication1.WebForm3" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Dashboard</title>
    <link href="CustomerDashboardStyles.css" rel="stylesheet" />
</head>
<body>
    <h1>Welcome to Customer Dashboard</h1>
    <form id="form1" runat="server">
        <div>

            <!--Omar Issa Part-->

                <!--part 1 customer req 1-->
                <asp:Button ID="btnLoadServicePlans" runat="server" Text="View Service Plans" OnClick="btnLoadServicePlans_Click" />
                <asp:GridView ID="gridServicePlans" runat="server" AutoGenerateColumns="True"></asp:GridView>
                <br /> <br />

               <!--part 1 customer req 3-->
                <asp:TextBox ID="txtPlanName" runat="server" Placeholder="Plan Name"></asp:TextBox>
                <asp:TextBox ID="txtStartDate" runat="server" Placeholder="Start Date (YYYY-MM-DD)"></asp:TextBox>
                <asp:TextBox ID="txtEndDate" runat="server" Placeholder="End Date (YYYY-MM-DD)"></asp:TextBox>
                <asp:Button ID="btnViewConsumption" runat="server" Text="View Consumption" OnClick="btnViewConsumption_Click" />
                <asp:GridView ID="gridConsumption" runat="server" AutoGenerateColumns="True"></asp:GridView>
                <br /> <br />

                <!--part 1 customer req 4--> 
                <asp:Button ID="btnLoadUnsubscribedPlans" runat="server" Text="View Unsubscribed Plans" OnClick="btnLoadUnsubscribedPlans_Click" />
                <asp:GridView ID="gridUnsubscribedPlans" runat="server" AutoGenerateColumns="True"></asp:GridView>
                <br /> <br />

                <!--part 1 customer req 5-->
            
                <asp:Button ID="btnLoadUsageCurrentMonth" runat="server" Text="View Current Month Usage" OnClick="btnLoadUsageCurrentMonth_Click" />
                <asp:GridView ID="gridUsageCurrentMonth" runat="server" AutoGenerateColumns="True"></asp:GridView>
                <br /> <br />

                <!--part 1 customer req 6-->
                <asp:TextBox ID="txtNationalID" runat="server" Placeholder="National ID"></asp:TextBox>
                <asp:Button ID="btnLoadCashbackTransactions" runat="server" Text="View Cashback Transactions" OnClick="btnLoadCashbackTransactions_Click" />
                <asp:GridView ID="gridCashbackTransactions" runat="server" AutoGenerateColumns="True"></asp:GridView>
                <br /> <br />

                <!--End of Omar Issa Part-->

                <!--Ismail Part-->

                <!--part2 req1-->
                <asp:Button ID="btnLoadActiveBenefits" runat="server" Text="View Active Benefits" OnClick="btnLoadActiveBenefits_Click" />
                <asp:GridView ID="gridActiveBenefits" runat="server" AutoGenerateColumns="True"></asp:GridView>
                <br />
                <br />
                <!--part2 req2-->
                <asp:TextBox ID="TextBox1" runat="server" Placeholder="National ID"></asp:TextBox>
                <asp:Button ID="btnLoadUnresolvedTickets" runat="server" Text="View Unresolved Tickets" OnClick="btnLoadUnresolvedTickets_Click" />
                <asp:Label ID="lblUnresolvedTickets" runat="server" Text=""></asp:Label>
                <br />
                <br />
                <!--part2 req3-->
                <asp:TextBox ID="txtMobileNumber" runat="server" Placeholder="Mobile Number"></asp:TextBox>
                <asp:Button ID="btnLoadHighestVoucher" runat="server" Text="View Highest Voucher" OnClick="btnLoadHighestVoucher_Click" />
                <asp:Label ID="lblHighestVoucher" runat="server" Text=""></asp:Label>
                <br />
                <br />
                <!-- part2 req4-->
                <asp:TextBox ID="TextBox2" runat="server" Placeholder="Mobile Number"></asp:TextBox>
                <asp:TextBox ID="TextBox3" runat="server" Placeholder="Plan Name"></asp:TextBox>
                <asp:Button ID="btnLoadRemainingAmount" runat="server" Text="View Remaining Amount" OnClick="btnLoadRemainingAmount_Click" />
                <asp:Label ID="lblRemainingAmount" runat="server" Text=""></asp:Label>
                <br />
                <br />
                <!-- part2 req5-->
                <asp:TextBox ID="TextBox4" runat="server" Placeholder="Mobile Number"></asp:TextBox>
                <asp:TextBox ID="TextBox5" runat="server" Placeholder="Plan Name"></asp:TextBox>
                <asp:Button ID="btnLoadExtraAmount" runat="server" Text="View Extra Amount" OnClick="btnLoadExtraAmount_Click" />
                <asp:Label ID="lblExtraAmount" runat="server" Text=""></asp:Label>
                <br />
                <br />

                <!-- part2 req6-->
                <asp:TextBox ID="TextBox6" runat="server" Placeholder="Mobile Number"></asp:TextBox>
                <asp:Button ID="btnLoadTopPayments" runat="server" Text="View Top Payments" OnClick="btnLoadTopPayments_Click" />
                <asp:GridView ID="gridTopPayments" runat="server" AutoGenerateColumns="True"></asp:GridView>
                <br /> <br />

                <!--End of Ismail Part-->

               <!--Omar Ibrahim Part-->
            <asp:Button ID="btnLoadAllShops" runat="server" Text="View All Shops" OnClick="btnLoadAllShops_Click" />
            <asp:GridView ID="gridAllShops" runat="server" AutoGenerateColumns="True"></asp:GridView>
            <br />
            <br />

            <asp:TextBox ID="TextBox7" runat="server" Placeholder="Enter Mobile Number"></asp:TextBox>
            <asp:Button ID="btnLoadSubscribedPlans" runat="server" Text="View Subscribed Plans" OnClick="btnLoadSubscribedPlans_Click" />
            <asp:GridView ID="gridSubscribedPlans" runat="server" AutoGenerateColumns="True"></asp:GridView>
            <asp:Label ID="lblMessage" runat="server" Text="" ForeColor="Red"></asp:Label>
            <br />
            <br />

            <asp:TextBox ID="TextBox8" runat="server" Placeholder="Mobile Number"></asp:TextBox>
            <asp:TextBox ID="txtPlanID" runat="server" Placeholder="Plan ID"></asp:TextBox>
            <asp:TextBox ID="txtAmount" runat="server" Placeholder="Payment Amount"></asp:TextBox>
            <asp:DropDownList ID="ddlPaymentMethod" runat="server">
            <asp:ListItem Text="Credit Card" Value="Credit Card"></asp:ListItem>
            <asp:ListItem Text="Debit Card" Value="Debit Card"></asp:ListItem>
            <asp:ListItem Text="PayPal" Value="PayPal"></asp:ListItem>
            </asp:DropDownList>
            <asp:Button ID="btnRenewSubscription" runat="server" Text="Renew Subscription" OnClick="btnRenewSubscription_Click" />
            <asp:Label ID="Label1" runat="server" Text="" />

             <br />
             <br />

            <asp:TextBox ID="txtWalletID" runat="server" Placeholder="Wallet ID"></asp:TextBox>
            <asp:TextBox ID="TextBox9" runat="server" Placeholder="Plan ID"></asp:TextBox>
            <asp:Button ID="btnGetCashbackAmount" runat="server" Text="Get Cashback Amount" OnClick="btnGetCashbackAmount_Click" />
            <asp:Label ID="lblCashbackAmount" runat="server" Text="" />

            <br />
            <br />

            <asp:TextBox ID="TextBox10" runat="server" Placeholder="Enter Mobile Number"></asp:TextBox>
            <asp:TextBox ID="TextBox11" runat="server" Placeholder="Enter Amount"></asp:TextBox>
            <asp:DropDownList ID="DropDownList1" runat="server">
            <asp:ListItem Text="Credit Card" Value="Credit Card"></asp:ListItem>
            <asp:ListItem Text="Debit Card" Value="Debit Card"></asp:ListItem>
            <asp:ListItem Text="PayPal" Value="PayPal"></asp:ListItem>
            </asp:DropDownList>
            <asp:Button ID="btnRechargeBalance" runat="server" Text="Recharge Balance" OnClick="btnRechargeBalance_Click" />
            <asp:Label ID="Label2" runat="server" Text="" />

            <br />
            <br />

            <asp:TextBox ID="TextBox12" runat="server" Placeholder="Enter Mobile Number"></asp:TextBox>
            <asp:TextBox ID="txtVoucherID" runat="server" Placeholder="Enter Voucher ID"></asp:TextBox>
            <asp:Button ID="btnRedeemVoucher" runat="server" Text="Redeem Voucher" OnClick="btnRedeemVoucher_Click" />
            <asp:Label ID="lblResult" runat="server" Text="" />


            <!--End of Omar Ibrahim Part-->




            <!--Logout button-->
            <br /><br />
            <asp:Button ID="btnLogout" runat="server" Text="Logout" OnClick="btnLogout_Click" />
        </div>
    </form>
</body>
</html>
