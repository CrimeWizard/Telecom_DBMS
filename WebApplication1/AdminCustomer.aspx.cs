using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace WebApplication1
{
    public partial class WebForm1 : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // No specific logic required for Page_Load in this case
        }

        protected void btnAdmin_Click(object sender, EventArgs e)
        {
            // Redirect to the Admin Login page
            Response.Redirect("AdminLogin.aspx");
        }

        protected void btnCustomer_Click(object sender, EventArgs e)
        {
            // Redirect to the Customer Login page
            Response.Redirect("CustomerLogin.aspx");
        }
    }
}
