using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class WebForm3 : System.Web.UI.Page
    {
        //database connection string
        private string connectionString = "Data Source=localhost\\SQLEXPRESS;Initial Catalog=Milestone2DB_24;Integrated Security=True;Encrypt=False;\r\n";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["MobileNumber"] == null)
            {
                // Redirect to the login page if the session is not set
                Response.Redirect("CustomerLogin.aspx");
            }
        }

        //Omar Issa Part /////////////////////////////////////////////////////////
        //   Customer Dashboard  
        // 1 
        protected void btnLoadServicePlans_Click(object sender, EventArgs e)
        {
            string query = "SELECT * FROM [allServicePlans]";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridServicePlans.DataSource = dt;
                gridServicePlans.DataBind();
            }
        }


        //3 

        protected void btnViewConsumption_Click(object sender, EventArgs e)
        {
            string planName = txtPlanName.Text;
            string startDate = txtStartDate.Text;
            string endDate = txtEndDate.Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM [Consumption](@Plan_name, @start_date, @end_date)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Plan_name", planName);
                cmd.Parameters.AddWithValue("@start_date", startDate);
                cmd.Parameters.AddWithValue("@end_date", endDate);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridConsumption.DataSource = dt;
                gridConsumption.DataBind();
            }
        }

        //4 
        protected void btnLoadUnsubscribedPlans_Click(object sender, EventArgs e)
        {
            string mobileNumber = Session["MobileNumber"].ToString(); // Use logged-in user's mobile number

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("Unsubscribed_Plans", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridUnsubscribedPlans.DataSource = dt;
                gridUnsubscribedPlans.DataBind();
            }
        }


        //5 
        protected void btnLoadUsageCurrentMonth_Click(object sender, EventArgs e)
        {
            string mobileNumber = Session["MobileNumber"].ToString(); // Use logged-in user's mobile number

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Define the SQL query to call the function
                string query = "SELECT * FROM [Usage_Plan_CurrentMonth](@mobile_num)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridUsageCurrentMonth.DataSource = dt;
                gridUsageCurrentMonth.DataBind();
            }
        }

        //6

        protected void btnLoadCashbackTransactions_Click(object sender, EventArgs e)
        {
            string nationalID = txtNationalID.Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Define the SQL query to call the function
                string query = "SELECT * FROM [Cashback_Wallet_Customer](@NID)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@NID", nationalID);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridCashbackTransactions.DataSource = dt;
                gridCashbackTransactions.DataBind();
            }
        }

        // End of Omar Issa Part ///////////////////////////////////////////////////








        //Ismail Part ////////////////////////////////////////////////////////////////////////////////
        // part2 req1 
        protected void btnLoadActiveBenefits_Click(object sender, EventArgs e)
        {
            string query = "SELECT * FROM [allBenefits]";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridActiveBenefits.DataSource = dt;
                gridActiveBenefits.DataBind();
            }
        }
        // part2 req2
        protected void btnLoadUnresolvedTickets_Click(object sender, EventArgs e)
        {
            string nationalID = TextBox1.Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("Ticket_Account_Customer", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@NID", nationalID);

                con.Open();
                object result = cmd.ExecuteScalar();
                con.Close();

                lblUnresolvedTickets.Text = result != null ? $"Unresolved Tickets: {result}" : "No tickets found.";
            }
        }

        //part2 req3
        protected void btnLoadHighestVoucher_Click(object sender, EventArgs e)
        {
            string mobileNumber = txtMobileNumber.Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("Account_Highest_Voucher", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);

                con.Open();
                object result = cmd.ExecuteScalar(); // ExecuteScalar retrieves a single value
                con.Close();

                lblHighestVoucher.Text = result != null
                    ? $"Voucher with the highest value: {result}"
                    : "No voucher found for this account.";
            }
        }

        //part2 req4

        protected void btnLoadRemainingAmount_Click(object sender, EventArgs e)
        {
            string mobileNumber = TextBox2.Text;
            string planName = TextBox3.Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Define the query for calling the SQL function
                string query = "SELECT dbo.Remaining_plan_amount(@mobile_num, @plan_name)";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);
                cmd.Parameters.AddWithValue("@plan_name", planName);

                con.Open();
                object result = cmd.ExecuteScalar(); // Get the output of the function
                con.Close();

                lblRemainingAmount.Text = result != null
                    ? $"Remaining Amount: {result}"
                    : "No remaining amount found for this account and plan.";
            }
        }

        //part2 req5
        protected void btnLoadExtraAmount_Click(object sender, EventArgs e)
        {
            string mobileNumber = TextBox4.Text;
            string planName = TextBox5.Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Define the query for calling the SQL function
                string query = "SELECT dbo.Extra_plan_amount(@mobile_num, @plan_name)";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);
                cmd.Parameters.AddWithValue("@plan_name", planName);

                con.Open();
                object result = cmd.ExecuteScalar(); // Get the output of the function
                con.Close();

                lblExtraAmount.Text = result != null
                    ? $"Extra Amount: {result}"
                    : "No extra amount found for this account and plan.";
            }
        }

        //part2 req6

        protected void btnLoadTopPayments_Click(object sender, EventArgs e)
        {
            string mobileNumber = TextBox6.Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("Top_Successful_Payments", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridTopPayments.DataSource = dt;
                gridTopPayments.DataBind();
            }
        }



        // End of Ismail part ////////////////////////////////////////////////////////////////////////////



        // Omar Ibrahim Part //////////////////////////////////////////////////////////////////////////////
        //p3 q1

        protected void btnLoadAllShops_Click(object sender, EventArgs e)
        {
            string query = "SELECT * FROM [allShops]";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gridAllShops.DataSource = dt;
                gridAllShops.DataBind();
            }
        }

        protected void btnLoadSubscribedPlans_Click(object sender, EventArgs e)
        {
            string mobileNumber = TextBox7.Text;

            if (!string.IsNullOrWhiteSpace(mobileNumber))
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM [Subscribed_plans_5_Months](@MobileNo)";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@MobileNo", mobileNumber);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gridSubscribedPlans.DataSource = dt;
                    gridSubscribedPlans.DataBind();
                }
            }
            else
            {
                lblMessage.Text = "Please enter a valid mobile number.";
            }
        }

        protected void btnRenewSubscription_Click(object sender, EventArgs e)
        {
            string mobileNumber = TextBox8.Text;
            string planId = txtPlanID.Text;
            string paymentMethod = ddlPaymentMethod.SelectedValue;
            decimal amount;

            if (decimal.TryParse(txtAmount.Text, out amount) && !string.IsNullOrWhiteSpace(mobileNumber) && !string.IsNullOrWhiteSpace(planId))
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        SqlCommand cmd = new SqlCommand("Initiate_plan_payment", con);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);
                        cmd.Parameters.AddWithValue("@amount", amount);
                        cmd.Parameters.AddWithValue("@payment_method", paymentMethod);
                        cmd.Parameters.AddWithValue("@plan_id", int.Parse(planId));

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();

                        Label1.Text = "Subscription renewed successfully!";
                        Label1.ForeColor = System.Drawing.Color.Green;
                    }
                }
                catch (Exception ex)
                {
                    Label1.Text = "Error: " + ex.Message;
                    Label1.ForeColor = System.Drawing.Color.Red;
                }
            }
            else
            {
                Label1.Text = "Please enter valid input values.";
                Label1.ForeColor = System.Drawing.Color.Red;
            }
        }


        protected void btnGetCashbackAmount_Click(object sender, EventArgs e)
        {
            string walletId = txtWalletID.Text;
            string planId = TextBox9.Text;

            if (int.TryParse(walletId, out int walletID) && int.TryParse(planId, out int planID))
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        string query = "SELECT dbo.Wallet_Cashback_Amount(@walletID, @planID) AS CashbackAmount";
                        SqlCommand cmd = new SqlCommand(query, con);
                        cmd.Parameters.AddWithValue("@walletID", walletID);
                        cmd.Parameters.AddWithValue("@planID", planID);

                        con.Open();
                        object result = cmd.ExecuteScalar();
                        con.Close();

                        if (result != null)
                        {
                            lblCashbackAmount.Text = "Cashback Amount: " + result.ToString();
                            lblCashbackAmount.ForeColor = System.Drawing.Color.Green;
                        }
                        else
                        {
                            lblCashbackAmount.Text = "No cashback found for the specified details.";
                            lblCashbackAmount.ForeColor = System.Drawing.Color.Red;
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblCashbackAmount.Text = "Error: " + ex.Message;
                    lblCashbackAmount.ForeColor = System.Drawing.Color.Red;
                }
            }
            else
            {
                lblCashbackAmount.Text = "Please enter valid numeric values for Wallet ID and Plan ID.";
                lblCashbackAmount.ForeColor = System.Drawing.Color.Red;
            }
        }


        protected void btnRechargeBalance_Click(object sender, EventArgs e)
        {
            string mobileNumber = TextBox10.Text;
            string paymentMethod = DropDownList1.SelectedValue;
            decimal amount;

            if (decimal.TryParse(TextBox11.Text, out amount) && !string.IsNullOrWhiteSpace(mobileNumber))
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        SqlCommand cmd = new SqlCommand("Initiate_balance_payment", con);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);
                        cmd.Parameters.AddWithValue("@amount", amount);
                        cmd.Parameters.AddWithValue("@payment_method", paymentMethod);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();

                        Label2.Text = "Balance recharged successfully!";
                        Label2.ForeColor = System.Drawing.Color.Green;
                    }
                }
                catch (Exception ex)
                {
                    Label2.Text = "Error: " + ex.Message;
                    Label2.ForeColor = System.Drawing.Color.Red;
                }
            }
            else
            {
                Label2.Text = "Please enter a valid mobile number and payment amount.";
                Label2.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnRedeemVoucher_Click(object sender, EventArgs e)
        {
            string mobileNumber = TextBox12.Text;
            string voucherId = txtVoucherID.Text;

            if (!string.IsNullOrWhiteSpace(mobileNumber) && int.TryParse(voucherId, out int voucherID))
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        SqlCommand cmd = new SqlCommand("Redeem_voucher_points", con);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.AddWithValue("@mobile_num", mobileNumber);
                        cmd.Parameters.AddWithValue("@voucher_id", voucherID);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();

                        lblResult.Text = "Voucher redeemed successfully!";
                        lblResult.ForeColor = System.Drawing.Color.Green;
                    }
                }
                catch (SqlException ex)
                {
                    lblResult.Text = ex.Message.Contains("no enough points to redeem voucher")
                        ? "Insufficient points to redeem this voucher."
                        : "Error: " + ex.Message;
                    lblResult.ForeColor = System.Drawing.Color.Red;
                }
                catch (Exception ex)
                {
                    lblResult.Text = "Error: " + ex.Message;
                    lblResult.ForeColor = System.Drawing.Color.Red;
                }
            }
            else
            {
                lblResult.Text = "Please enter a valid mobile number and voucher ID.";
                lblResult.ForeColor = System.Drawing.Color.Red;
            }
        }





        // end of omar ibrahim part


        //Logout button
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear the session and abandon it
            Session.Clear();
            Session.Abandon();

            // Redirect to the login page
            Response.Redirect("CustomerLogin.aspx");
        }
    }
}