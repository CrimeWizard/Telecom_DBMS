using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication1
{
    public partial class AdminDashboard : Page
    {
        //database connection string
        private string connectionString = "Data Source=localhost\\SQLEXPRESS;Initial Catalog=Milestone2DB_24;Integrated Security=True;Encrypt=False;\r\n";

        protected void Page_Load(object sender, EventArgs e)
        {
            // If the admin is not logged in, redirect to login page
            if (Session["IsAdminLoggedIn"] == null || !(bool)Session["IsAdminLoggedIn"])
            {
                Response.Redirect("AdminLogin.aspx");
            }
        }



        // Part 1 Admin "Youssef"

        //Requirement 2
        protected void btnLoadCustomerProfiles_Click(object sender, EventArgs e)
        {
            // Define your SQL query to fetch data from the SQL View
            string query = "SELECT * FROM [allCustomerAccounts]";

            // Create a connection to the database
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);  // Fill the DataTable with the result of the query

                // Bind the data to the GridView
                gridCustomerProfiles.DataSource = dt;
                gridCustomerProfiles.DataBind();
            }
        }


        //Requirement 3

        protected void btnLoadPhysicalStores_Click(object sender, EventArgs e)
        {
            string query = "SELECT * FROM [PhysicalStoreVouchers]";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridPhysicalStores.DataSource = dt;
                gridPhysicalStores.DataBind();
            }
        }


        //Requirement 4
        protected void btnLoadResolvedTickets_Click(object sender, EventArgs e)
        {
            string query = "SELECT * FROM [allResolvedTickets]";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridResolvedTickets.DataSource = dt;
                gridResolvedTickets.DataBind();
            }
        }

        //Requirement 5
        protected void btnLoadAccountPlans_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("Account_Plan", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridAccountPlans.DataSource = dt;
                gridAccountPlans.DataBind();
            }
        }

        //Requirement 6
        protected void btnLoadAccountsByPlanAndDate_Click(object sender, EventArgs e)
        {
            string planID = txtPlanID.Text;
            string subscriptionDate = txtSubscriptionDate.Text; // Ensure proper date format

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM [Account_Plan_date](@sub_date, @plan_id)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@sub_date", subscriptionDate);
                cmd.Parameters.AddWithValue("@plan_id", planID);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridAccountsByPlanAndDate.DataSource = dt;
                gridAccountsByPlanAndDate.DataBind();
            }
        }

        //Req 7
        protected void btnShowTotalUsage_Click(object sender, EventArgs e)
        {
            string mobileNumber = txtMobileNumber.Text;
            string startDate = txtStartDate.Text; // Ensure date format is valid

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM [Account_Usage_Plan](@mobile_num, @start_date)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);
                cmd.Parameters.AddWithValue("@start_date", startDate);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridUsage.DataSource = dt;
                gridUsage.DataBind();
            }
        }


        //Req 8
        protected void btnRemoveBenefits_Click(object sender, EventArgs e)
        {
            string mobileNumber = TextBox1.Text;
            string planID = TextBox2.Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("Benefits_Account", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);
                cmd.Parameters.AddWithValue("@plan_id", planID);

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            removebenefits.Text = "Benefits removed successfully!";
        }


        //Req 9
        protected void btnShowSMSOffers_Click(object sender, EventArgs e)
        {
            string mobileNumber = TextBox3.Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM [Account_SMS_Offers](@mobile_num)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridSMSOffers.DataSource = dt;
                gridSMSOffers.DataBind();
            }
        }

        // End of "Youssef" Part

        //---------------------------------

        // Admin Part 2 "Michael"

        // part 2 q1
        protected void btnLoadCustomerWallets_Click(object sender, EventArgs e)
        {
            string query = "SELECT * FROM [CustomerWallet]";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridCustomerWallets.DataSource = dt;
                gridCustomerWallets.DataBind();
            }
        }


        // Q2
        protected void btnLoadEshopVouchers_Click(object sender, EventArgs e)
        {
            string query = "SELECT * FROM [E_shopVouchers]";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridEshopVouchers.DataSource = dt;
                gridEshopVouchers.DataBind();
            }
        }

        //Q3
        protected void btnLoadPaymentDetails_Click(object sender, EventArgs e)
        {
            string query = "SELECT * FROM [AccountPayments]";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridPaymentDetails.DataSource = dt;
                gridPaymentDetails.DataBind();
            }
        }

        //Q4
        protected void btnLoadCashbackTransactions_Click(object sender, EventArgs e)
        {
            string query = "SELECT * FROM [Num_of_cashback]";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridCashbackTransactions.DataSource = dt;
                gridCashbackTransactions.DataBind();
            }
        }

        //Q5
        protected void btnGetPaymentPoints_Click(object sender, EventArgs e)
        {
            string mobileNumber = TextBox4.Text;

            // Validate that the input is not empty
            if (string.IsNullOrEmpty(mobileNumber))
            {
                Label2.Text = "Please enter a mobile number.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Create the SQL command to execute the stored procedure
                SqlCommand cmd = new SqlCommand("Account_Payment_Points", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);

                try
                {
                    con.Open();

                    // Execute the stored procedure and get the result
                    SqlDataReader reader = cmd.ExecuteReader();

                    // Check if there are results
                    if (reader.Read())
                    {
                        int numberOfPayments = reader.GetInt32(0);  // First column: NumberOfPayments
                        int totalPointsEarned = reader.GetInt32(1); // Second column: TotalPointsEarned

                        // Display the results
                        Label2.Text = $"Number of Payments: {numberOfPayments}<br/>Total Points Earned: {totalPointsEarned}";
                    }
                    else
                    {
                        Label2.Text = "No payments found for the given mobile number in the last year.";
                    }

                    con.Close();
                }
                catch (Exception ex)
                {
                    // Display any errors
                    Label2.Text = "Error: " + ex.Message;
                }
            }
        }

        //Q6
        protected void btnGetCashbackAmount_Click(object sender, EventArgs e)
        {
            string walletID = txtWalletID.Text;
            string planID = txtPlanID2.Text;

            // Validate inputs (you can add more validation based on your needs)
            if (string.IsNullOrEmpty(walletID) || string.IsNullOrEmpty(planID))
            {
                lblCashbackResult.Text = "Please fill in all fields.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Create the SQL command to call the function
                string query = "SELECT dbo.Wallet_Cashback_Amount(@walletID, @planID)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@walletID", walletID);
                cmd.Parameters.AddWithValue("@planID", planID);

                try
                {
                    // Open the connection, execute the function, and read the result
                    con.Open();
                    var result = cmd.ExecuteScalar(); // Executes the function and returns the sum of cashback amounts
                    con.Close();

                    // Display the result
                    if (result != DBNull.Value)
                    {
                        lblCashbackResult.Text = "Total Cashback Amount: " + result.ToString();
                    }
                    else
                    {
                        lblCashbackResult.Text = "No cashback found for the given wallet ID and plan ID.";
                    }
                }
                catch (Exception ex)
                {
                    lblCashbackResult.Text = "Error: " + ex.Message;
                }
            }
        }

        //Q7
        protected void btnGetAverageAmount_Click(object sender, EventArgs e)
        {
            string walletID = TextBox6.Text;
            string startDate = TextBox7.Text;
            string endDate = txtEndDate.Text;

            // Validate if the inputs are in the correct format (optional)
            if (string.IsNullOrEmpty(walletID) || string.IsNullOrEmpty(startDate) || string.IsNullOrEmpty(endDate))
            {
                Label1.Text = "Please fill in all fields.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Create the SQL command to call the function
                string query = "SELECT dbo.Wallet_Transfer_Amount(@walletID, @start_date, @end_date)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@walletID", walletID);
                cmd.Parameters.AddWithValue("@start_date", startDate);
                cmd.Parameters.AddWithValue("@end_date", endDate);

                try
                {
                    // Open the connection and execute the function
                    con.Open();
                    var result = cmd.ExecuteScalar(); // Executes the function and returns the average amount
                    con.Close();

                    // Display the result in the label
                    if (result != DBNull.Value)
                    {
                        Label1.Text = "Average Transfer Amount: " + result.ToString();
                    }
                    else
                    {
                        Label1.Text = "No transactions found for the given criteria.";
                    }
                }
                catch (Exception ex)
                {
                    Label1.Text = "Error: " + ex.Message;
                }
            }
        }

        //Q8
        protected void btnCheckWallet_Click(object sender, EventArgs e)
        {
            string mobileNumber = TextBox8.Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Create the SQL command to call the function
                string query = "SELECT dbo.Wallet_MobileNo(@mobile_num)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);

                try
                {
                    // Open the connection, execute the function, and read the result
                    con.Open();
                    var result = cmd.ExecuteScalar(); // Executes the function and returns the result (1 or 0)
                    con.Close();

                    // Check if a wallet is linked to the mobile number
                    if (result != null && (int)result == 1)
                    {
                        lblWalletStatus.Text = "The mobile number is linked to a wallet.";
                    }
                    else
                    {
                        lblWalletStatus.Text = "The mobile number is not linked to a wallet.";
                    }
                }
                catch (Exception ex)
                {
                    lblWalletStatus.Text = "Error: " + ex.Message;
                }
            }
        }

        //Q9
        protected void btnUpdatePoints_Click(object sender, EventArgs e)
        {
            string mobileNumber = TextBox9.Text;
         

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Create the command to execute the stored procedure
                SqlCommand cmd = new SqlCommand("Total_Points_Account", con);
                cmd.CommandType = CommandType.StoredProcedure;

                // Add the parameter for mobile number
                cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);

                try
                {
                    // Open the connection, execute the command and close the connection
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();

                    Label3.Text = "Points updated successfully!";
                }
                catch (Exception ex)
                {
                    Label3.Text = "Error: " + ex.Message;
                }
            }
        }


        // End of Michael part




        // Logout button ----------------------------------------------------------------------------------------------------
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear session and redirect to login page
            Session.Clear();
            Response.Redirect("AdminLogin.aspx");
        }
    }
}
