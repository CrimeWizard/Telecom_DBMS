using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication1
{
    
    public partial class WebForm2 : Page
    {

        private string connectionString = "Data Source=localhost\\SQLEXPRESS;Initial Catalog=Milestone2DB_24;Integrated Security=True;Encrypt=False;\r\n";
        // Event handler for Login button click
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string mobileNumber = txtMobileNumber.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(mobileNumber) || string.IsNullOrEmpty(password))
            {
                lblErrorMessage.Text = "Please enter both Mobile Number and Password.";
                return;
            }

            // Connection to the database
            //string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    // SQL query to validate login
                    string query = "SELECT * FROM customer_account WHERE mobileNo = @MobileNo AND pass = @Password";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MobileNo", mobileNumber);
                    cmd.Parameters.AddWithValue("@Password", password);

                    conn.Open();

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        // Login successful
                        Session["MobileNumber"] = mobileNumber; // Store the mobile number in session
                        Response.Redirect("CustomerDashboard.aspx"); // Redirect to customer dashboard
                    }
                    else
                    {
                        // Invalid credentials
                        lblErrorMessage.Text = "Invalid Mobile Number or Password.";
                    }

                    conn.Close();
                }
                catch (Exception ex)
                {
                    lblErrorMessage.Text = "An error occurred: " + ex.Message;
                }
            }
        }
    }
}
