<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="WebApplication1.AdminDashboard" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Admin Dashboard</title>
    <link href="AdminDashboardStyles.css" rel="stylesheet" />
</head>
<body>

  
    <form id="form1" runat="server">
        <div>
            <h2>Welcome to Admin Dashboard</h2>
            

            <br /><br />
            <!-- Youssef-->
            <!-- 2 -->

            <asp:Button ID="btnLoadCustomerProfiles" runat="server" Text="View All Customer Profiles" OnClick="btnLoadCustomerProfiles_Click" />
            <asp:GridView ID="gridCustomerProfiles" runat="server" AutoGenerateColumns="True" ></asp:GridView>

            <br /><br />

            <!-- 3 -->
            <asp:Button ID="btnLoadResolvedTickets" runat="server" Text="View Resolved Tickets" OnClick="btnLoadResolvedTickets_Click" />
            <asp:GridView ID="gridResolvedTickets" runat="server" AutoGenerateColumns="True"></asp:GridView>

            <br /> <br />
            <!-- 4 -->
            <asp:Button ID="btnLoadPhysicalStores" runat="server" Text="View Physical Stores & Vouchers" OnClick="btnLoadPhysicalStores_Click" />
            <asp:GridView ID="gridPhysicalStores" runat="server" AutoGenerateColumns="True"></asp:GridView>

            <br /> <br />
            <!-- 5 -->
            <asp:Button ID="btnLoadAccountPlans" runat="server" Text="View Account Plans" OnClick="btnLoadAccountPlans_Click" />
            <asp:GridView ID="gridAccountPlans" runat="server" AutoGenerateColumns="True"></asp:GridView>

            <br /> <br />
            <!-- 6 -->
            <label for ="planId">PlanID: </label>
            <asp:TextBox ID="txtPlanID" runat="server" Placeholder="Plan ID"></asp:TextBox>
            <br />
            <br />

            <label for ="subDate">Subscription Date:  </label>
            <asp:TextBox ID="txtSubscriptionDate" runat="server" Placeholder="xxxx-xx-xx"></asp:TextBox>
            <br />
            <br />

            <asp:Button ID="btnLoadAccountsByPlanAndDate" runat="server" Text="Search Accounts" OnClick="btnLoadAccountsByPlanAndDate_Click" />
            <asp:GridView ID="gridAccountsByPlanAndDate" runat="server" AutoGenerateColumns="True"></asp:GridView>
            <br /> <br />

            <!-- 7 -->
            <asp:TextBox ID="txtMobileNumber" runat="server" Placeholder="Mobile Number"></asp:TextBox>
            <asp:TextBox ID="txtStartDate" runat="server" Placeholder="Start Date (YYYY-MM-DD)"></asp:TextBox>
            <asp:Button ID="btnShowTotalUsage" runat="server" Text="Show Usage" OnClick="btnShowTotalUsage_Click" />
            <asp:GridView ID="gridUsage" runat="server" AutoGenerateColumns="True"></asp:GridView>
            <br /> <br />

            <!-- 8 -->
            <asp:TextBox ID="TextBox1" runat="server" Placeholder="Mobile Number"></asp:TextBox>
            <asp:TextBox ID="TextBox2" runat="server" Placeholder="Plan ID"></asp:TextBox>
            <asp:Button ID="btnRemoveBenefits" runat="server" Text="Remove Benefits" OnClick="btnRemoveBenefits_Click" />
            <asp:Label ID="removebenefits" runat="server" Text=""></asp:Label>

            <br /> <br />
            <!-- 9 -->
            <asp:TextBox ID="TextBox3" runat="server" Placeholder="Mobile Number"></asp:TextBox>
            <asp:Button ID="btnShowSMSOffers" runat="server" Text="Show SMS Offers" OnClick="btnShowSMSOffers_Click" />
            <asp:GridView ID="gridSMSOffers" runat="server" AutoGenerateColumns="True"></asp:GridView>


            <br /> <br />
            <!-- End of Youssef part-->

            <!--Michael-->

            <!--part 2 q1-->
            <asp:Button ID="btnLoadCustomerWallets" runat="server" Text="View Customer Wallets" OnClick="btnLoadCustomerWallets_Click" />
            <asp:GridView ID="gridCustomerWallets" runat="server" AutoGenerateColumns="True"></asp:GridView>


              <br /> <br />
              <!-- part 2 q2 -->
              <asp:Button ID="btnLoadEshopVouchers" runat="server" Text="View E-shop Vouchers" OnClick="btnLoadEshopVouchers_Click" />
              <asp:GridView ID="gridEshopVouchers" runat="server" AutoGenerateColumns="True"></asp:GridView>

              <br /> <br />
              <!-- part 2 q3 -->
              <asp:Button ID="btnLoadPaymentDetails" runat="server" Text="View Payment Transactions" OnClick="btnLoadPaymentDetails_Click" />
              <asp:GridView ID="gridPaymentDetails" runat="server" AutoGenerateColumns="True"></asp:GridView>

              <br /> <br />
              <!-- part 2 q4 -->
              <asp:Button ID="btnLoadCashbackTransactions" runat="server" Text="Load Cashback Transactions" OnClick="btnLoadCashbackTransactions_Click" />
              <asp:GridView ID="gridCashbackTransactions" runat="server" AutoGenerateColumns="True"></asp:GridView>

              <br /> <br />
              <!-- part 2 q5 -->
              <asp:TextBox ID="TextBox4" runat="server" Placeholder="Enter Mobile Number" />
              <asp:Button ID="btnGetPaymentPoints" runat="server" Text="Get Payment and Points Info" OnClick="btnGetPaymentPoints_Click" />
              <asp:Label ID="Label2" runat="server" Text=""></asp:Label>

              <br /> <br />
              <!-- part 2 q6 -->
              <asp:TextBox ID="txtWalletID" runat="server" Placeholder="Enter Wallet ID" />
              <asp:TextBox ID="txtPlanID2" runat="server" Placeholder="Enter Plan ID" />
              <asp:Button ID="btnGetCashbackAmount" runat="server" Text="Get Cashback Amount" OnClick="btnGetCashbackAmount_Click" />
              <asp:Label ID="lblCashbackResult" runat="server" Text=""></asp:Label>

              <br /> <br />
              <!-- part 2 q7 -->
              <asp:TextBox ID="TextBox6" runat="server" Placeholder="Enter Wallet ID" />
              <asp:TextBox ID="TextBox7" runat="server" Placeholder="Start Date (YYYY-MM-DD)" />
              <asp:TextBox ID="txtEndDate" runat="server" Placeholder="End Date (YYYY-MM-DD)" />
              <asp:Button ID="btnGetAverageAmount" runat="server" Text="Get Average Amount" OnClick="btnGetAverageAmount_Click" />
              <asp:Label ID="Label1" runat="server" Text=""></asp:Label>

              <br /> <br />
              <!-- part 2 q8 -->
              <asp:TextBox ID="TextBox8" runat="server" Placeholder="Enter Mobile Number" />
              <asp:Button ID="btnCheckWallet" runat="server" Text="Check Wallet" OnClick="btnCheckWallet_Click" />
              <asp:Label ID="lblWalletStatus" runat="server" Text=""></asp:Label>

              <br /> <br />
              <!-- part 2 q9 -->
              <asp:TextBox ID="TextBox9" runat="server" Placeholder="Enter Mobile Number" />
              <asp:Button ID="btnUpdatePoints" runat="server" Text="Update Points" OnClick="btnUpdatePoints_Click" />
              <asp:Label ID="Label3" runat="server" Text=""></asp:Label>
              <br /> <br />

            <!-- End of Michael part-->

            <!-- Logout button -->
            <asp:Button ID="Button1" runat="server" Text="Logout" OnClick="btnLogout_Click" />
            <br /> <br />


        </div>
    </form>
</body>
</html>
