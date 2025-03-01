using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class AdminLogin : Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string adminID = txtAdminID.Text;
            string password = txtPassword.Text;

            // Hardcoded admin credentials
            const string hardcodedAdminID = "admin";
            const string hardcodedPassword = "pass123";

            if (adminID == hardcodedAdminID && password == hardcodedPassword)
            {
                // Successful login
                Session["IsAdminLoggedIn"] = true; // Use a session variable for login status
                Response.Redirect("AdminDashboard.aspx"); // Redirect to dashboard
            }
            else
            {
                // Unsuccessful login
                lblMessage.Text = "Invalid Admin ID or Password. Please try again.";
            }
        }
    }
}
