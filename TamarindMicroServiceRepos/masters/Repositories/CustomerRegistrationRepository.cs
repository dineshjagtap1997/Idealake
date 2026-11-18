using CommonClass;
using Microsoft.Data.SqlClient;
using NLog;
using System.Data;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using TamarindAstra.Common;
using TamarindAstraMasters.Interface;
using static TamarindAstraMasters.MasterModel.CustomerRegistrationModel;

namespace TamarindAstraMasters.Repositories
{
    public class CustomerRegistrationRepository : ICustomerRegistration
    {
        private static readonly Logger logger = LogManager.GetCurrentClassLogger(); // NLog Logger
        private readonly IConfiguration _configuration;

        public CustomerRegistrationRepository(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        private async Task<DataTable> SqlOperation(object parameters, string storedProcedure)
        {
            DataTable ds = new DataTable();
            using (SqlConnection conn = new SqlConnection(SharedConfiguration.GetConnectionString()))
            {
                await conn.OpenAsync();
                using (SqlCommand cmd = new SqlCommand(storedProcedure, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    var props = parameters.GetType().GetProperties();
                    foreach (var prop in props)
                    {
                        cmd.Parameters.AddWithValue($"{prop.Name}", prop.GetValue(parameters));
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        //select* from CustomerRegistration_Mail
        //select* from CustRegistration_Mail_Details
        //select* from RegistrationDept_Mail_Details
        public async Task SendCustomerRegistrationMail(RequestModel request)
        {
            var _smtpSettings = SharedConfiguration.GetSmtpSettings();
            try
            {
                if (request == null || string.IsNullOrEmpty(request.RequestText))
                    throw new ArgumentNullException("Request is null or empty.");

                //CustomerRegistration_Mail Table

                Console.WriteLine(" Starting Customer Registration process");

                string subject = string.Empty;
                string to = string.Empty;
                //to = "dinesh_jagtapidealake.com";
                string cc = string.Empty;
                var customerRegistration = new CustomerRegistration();

                customerRegistration = CommonFunctions.DecryptAndDeserializeNullRequest<CustomerRegistration>(request.RequestText);

                StringBuilder bodyBuilder = new StringBuilder();
                StringBuilder bodyBuilder_withoutApprovalLink = new StringBuilder();
                bodyBuilder.Append("<html><body style='font-family: Arial, sans-serif;'>");

                var combinedDataTable = await SqlOperation(new
                {
                    EmpID = customerRegistration.TamSalesRepId,
                    Action = "S",
                }, "[dbo].[usp_Employee_Master]");
                string empCCEmail = "";
                if (combinedDataTable.Rows.Count > 0)
                {
                    empCCEmail = combinedDataTable.Rows[0]["OffEmail"].ToString();
                }

                to = customerRegistration.EmailTo;
                cc = customerRegistration.EmailCC;

                if (empCCEmail != "")
                    cc += ";" + empCCEmail;

                if (customerRegistration.EmailFrom != "")
                    cc += ";" + customerRegistration.EmailFrom;

                var custReg = await SqlOperation(new
                {
                    fromEmail = customerRegistration.EmailFrom,
                    toEmail = customerRegistration.EmailTo,
                    ccEmail = cc,
                    agentClassId = customerRegistration.AgentClassId,
                    marketAssignedId = customerRegistration.MarketMasterId,
                    tamSalesRepId = customerRegistration.TamSalesRepId,
                    IsCreditApplicable = customerRegistration.CreditApplicable,
                    creditAllowance = customerRegistration.CreditAllowance,
                    creditCurrencyId = customerRegistration.CreditCurrency,
                    createdby = customerRegistration.OperationBy
                }, "[dbo].[usp_InsertCustomerRegistrationMail]");
                string CustRegID = "";
                if (custReg.Rows.Count > 0)
                {
                    CustRegID = custReg.Rows[0]["CustRegID"].ToString();
                }

                string encryptedData = Convert.ToBase64String(Encoding.UTF8.GetBytes(CustRegID));

                string customerRegistrationUrl = SharedConfiguration.GetCustomerRegistrationUrl();
                string customerRegistrationLink = $"{customerRegistrationUrl}?data={HttpUtility.UrlEncode(encryptedData)}";

                subject = "Customer Registration Link!";

                //string XO_ID = customerRegistration.XO_ID ?? "N/A";
                //string rawEmailData = $"{customerRegistration.EmailFrom}|{customerRegistration.EmailTo}|{customerRegistration.EmailCC}|{customerRegistration.ID}";
                //string encryptedData = Convert.ToBase64String(Encoding.UTF8.GetBytes(rawEmailData));

                //string approveBaseUrl = SharedConfiguration.GetAdvancePayApproveUrl();
                //string rejectBaseUrl = SharedConfiguration.GetAdvancePayRejectUrl();
                //string approveLink = $"{approveBaseUrl}{HttpUtility.UrlEncode(XO_ID)}?data={HttpUtility.UrlEncode(encryptedData)}";
                //string rejectLink = $"{rejectBaseUrl}{HttpUtility.UrlEncode(XO_ID)}?data={HttpUtility.UrlEncode(encryptedData)}";


                // Build email body
                bodyBuilder.Append("Dear Sir/Madam,<br/><br/>");
                bodyBuilder.Append("Greetings!<br/><br/>");
                bodyBuilder.Append("In order to create your company profile in our database, we will need the billing and statutory details of your organization. Kindly click the below link to access the registration form we have provided for this purpose.<br/><br/>");
                bodyBuilder.Append("<a href='" + customerRegistrationLink + "'>Agent_Customer Registration Form</a><br/><br/>");
                bodyBuilder.Append("Thank You,<br/>");
                bodyBuilder.Append("Tamarind Global Team.");



                // ✅ SEND EMAIL WITH BOTH AUTO-EXCEL AND MANUAL ATTACHMENTS
                using (MailMessage mail = new MailMessage())
                {
                    //mail.From = new MailAddress(customerRegistration.EmailFrom, customerRegistration.EmailFrom);
                    //mail.From = new MailAddress(_smtpSettings.SenderEmail, _smtpSettings.SenderName);
                    mail.From = new MailAddress(customerRegistration.EmailFrom, _smtpSettings.SenderName);

                    if (!string.IsNullOrWhiteSpace(to))
                    {
                        foreach (var address in to.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries))
                        {
                            mail.To.Add(address.Trim());
                        }
                    }

                    if (!string.IsNullOrWhiteSpace(cc))
                    {
                        foreach (var address in cc.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries))
                        {
                            mail.CC.Add(address.Trim());
                        }
                    }

                    //if (!string.IsNullOrEmpty(customerRegistration.EmailFrom))
                    //{
                    //    mail.ReplyToList.Add(new MailAddress(customerRegistration.EmailFrom));
                    //}

                    if (!string.IsNullOrEmpty(customerRegistration.EmailFrom))
                    {
                        mail.ReplyToList.Clear();
                        mail.ReplyToList.Add(new MailAddress(customerRegistration.EmailFrom));
                    }

                    //if (!string.IsNullOrEmpty(_smtpSettings.SenderEmail))
                    //{
                    //    mail.ReplyToList.Add(new MailAddress(_smtpSettings.SenderEmail));
                    //}

                    mail.Subject = subject;
                    mail.Body = bodyBuilder.ToString();
                    mail.IsBodyHtml = true;

                    int attachmentCount = 0;

                    // Send the email
                    //using (SmtpClient smtp = new SmtpClient(_smtpSettings.RegHost, _smtpSettings.RegPort))
                    //{
                    //    smtp.Credentials = new NetworkCredential(_smtpSettings.RegUsername, _smtpSettings.RegPassword);
                    //    smtp.EnableSsl = true;
                    //    await smtp.SendMailAsync(mail);
                    //    Console.WriteLine($" Email sent successfully to {to}");
                    //}

                    using (SmtpClient smtp = new SmtpClient(_smtpSettings.Host, _smtpSettings.Port))
                    {
                        smtp.Credentials = new NetworkCredential(_smtpSettings.UserName, _smtpSettings.Password);
                        smtp.EnableSsl = true;
                        await smtp.SendMailAsync(mail);
                        Console.WriteLine($" Email sent successfully to {to}");
                    }

                }

                Console.WriteLine(" Customer Registration process completed successfully");
                //}
            }
            catch (Exception ex)
            {
                Console.WriteLine($" Email sending failed: {ex.Message}");
                Console.WriteLine($"Stack trace: {ex.StackTrace}");
                throw new Exception("Failed to send email.", ex);
            }
        }

        public async Task<ResponseModel> GetCustomerRegistrationMailDetail(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<CustomerRegistration>(request.RequestText);
                logger.Debug("GetCustomerRegistrationMailDetail method called");

                if (req != null)
                {

                    string urlDecoded = HttpUtility.UrlDecode(req.EncryptedCustRegID);
                    byte[] base64Bytes = Convert.FromBase64String(urlDecoded);
                    int decryptedCustRegId = Convert.ToInt32(Encoding.UTF8.GetString(base64Bytes).ToString());

                    var parameters = new
                    {
                        @Action = req.Action,
                        @CustRegID = decryptedCustRegId,
                    };
                    var data = new CommonClass.ResponseViewModel<CustomerRegistration>();

                    int expiryInMinutes = int.Parse(_configuration["Jwt:ExpiryInMinutes"]);
                    var token = JwtHelper.GenerateBarrierJwtToken(_configuration, expiryInMinutes);
                    data.token = token;

                    return CommonFunctions.ProcessDBData(data, req.Action, "[dbo].[usp_Get_CustomerRegistration_Mail]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        public async Task SubmitCustomerRegistrationForm(RequestModel request)
        {
            var _smtpSettings = SharedConfiguration.GetSmtpSettings();
            try
            {
                if (request == null || string.IsNullOrEmpty(request.RequestText))
                    throw new ArgumentNullException("Request is null or empty.");
                var req = CommonFunctions.DecryptAndDeserializeRequest<CustomerRegistration>(request.RequestText);
                logger.Debug("SubmitCustomerRegistrationForm method called");
                if (req != null)
                {

                    var parameters = new
                    {
                        @Action = "S",
                        @RequestID = req.RequestID,
                        @TradeName = req.TradeName,
                        @LegalName = req.LegalName,
                        @BillingAddress = req.BillingAddress,
                        @Country = req.Country,
                        @State = req.State,
                        @CustomState = req.CustomState,
                        @City = req.City,
                        @CustomCity = req.CustomCity,
                        @PostalCode = req.PostalCode,
                        @PAN = req.PAN,
                        @GST = req.GST,
                        @TAN = req.TAN,
                        @SEZ_Unit = req.SEZ_Unit,
                        @AccountName = req.AccountName,
                        @AccountNumber = req.AccountNumber,
                        @BankName = req.BankName,
                        @IFSC = req.IFSC,
                        @ContactNumber = req.ContactNumber,
                        @EmailID = req.EmailID,
                        @GSTFileName = req.AttachmentUrl?
                                        .FirstOrDefault(x => x.ContentType == "GST")
                                        ?.FileName ?? string.Empty,
                        @PANFileName = req.AttachmentUrl?
                                        .FirstOrDefault(x => x.ContentType == "PAN")
                                        ?.FileName ?? string.Empty,
                        @TANFileName = req.AttachmentUrl?
                                        .FirstOrDefault(x => x.ContentType == "TAN")
                                        ?.FileName ?? string.Empty,
                        @VAT = req.VAT,
                        @VATFileName = req.AttachmentUrl?
                                        .FirstOrDefault(x => x.ContentType == "VAT")
                                        ?.FileName ?? string.Empty,
                        @RegistrationDeptDetailJSON = req.RegistrationDeptDetailJSON,
                        @id = 0
                    };

                    var data = new CommonClass.ResponseViewModel<CustomerRegistration>();
                    var result = CommonFunctions.ProcessDBData(data, "S", "[dbo].[usp_Insert_CustRegistration_Mail_Details]", parameters);
                    var wrapper = CommonFunctions.SmartDecryptAndDeserialize<ResponseViewModel<CustomerRegistration>>(result.responseText);

                    var emailmodel = wrapper?.dataList;

                    string subject = string.Empty;
                    string to = string.Empty;
                    string cc = string.Empty;

                    StringBuilder bodyBuilder = new StringBuilder();
                    bodyBuilder.Append("<html><body style='font-family: Arial, sans-serif;'>");

                    to = req.EmailCC;
                    to = "dinesh_jagtap@idealake.com";
                    cc = req.EmailTo;

                    if (req.EmailFrom != "")
                        cc += ";" + req.EmailFrom;

                    subject = "Customer Registration Form";

                    bodyBuilder.Append("<h3>Customer Registration Form</h3>");
                    bodyBuilder.Append("RequestID: " + req.RequestID + "<br/><br/>");

                    void AddRow(string label, string value)
                    {
                        bodyBuilder.AppendFormat("<tr><th align='left' style='background-color:#f0f0f0;'>{0}</th><td>{1}</td></tr>",
                            label,
                            string.IsNullOrWhiteSpace(value) ? "N/A" : value);
                    }

                    bodyBuilder.Append("<table border='1' cellpadding='6' cellspacing='0' style='border-collapse: collapse; width: 50%;'>");

                    if (emailmodel != null && emailmodel.Count > 0)
                    {
                        AddRow("Trade Name", emailmodel[0].TradeName);
                        AddRow("Legal Name", emailmodel[0].LegalName);
                        AddRow("Billing Address", emailmodel[0].BillingAddress);
                        AddRow("Country", emailmodel[0].Country);
                        AddRow("State", emailmodel[0].State);
                        AddRow("Custom State", emailmodel[0].CustomState?.ToString() == "" ? "Not Defined" : emailmodel[0].CustomState);
                        AddRow("City", emailmodel[0].City);
                        AddRow("Custom City", emailmodel[0].CustomCity?.ToString() == "" ? "Not Defined" : emailmodel[0].CustomCity);
                        AddRow("Postal Code", emailmodel[0].PostalCode);
                        AddRow("PAN Number", emailmodel[0].PAN.ToString() == "" ? "No" : emailmodel[0].PAN);
                        AddRow("GST Number", emailmodel[0].GST.ToString() == "" ? "No" : emailmodel[0].GST);
                        AddRow("TAN Number", emailmodel[0].TAN.ToString() == "" ? "No" : emailmodel[0].TAN);
                        AddRow("SEZ Unit", emailmodel[0].SEZ_Unit.HasValue && emailmodel[0].SEZ_Unit.Value ? "Yes" : "No");
                        AddRow("VAT Number", emailmodel[0].VAT.ToString() == "" ? "No" : emailmodel[0].VAT);
                        AddRow("EmailID", emailmodel[0].EmailID.ToString() == "" ? "No" : emailmodel[0].EmailID);
                        AddRow("Contact Number", emailmodel[0].ContactNumber.ToString() == "" ? "No" : emailmodel[0].ContactNumber);
                    }

                    bodyBuilder.Append("</table><br/>");

                    void AddDeptCommonHearder()
                    {
                        bodyBuilder.AppendFormat("<tr>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Name</th>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Designation</th>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Mobile Number</th>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Email ID</th>");
                        bodyBuilder.AppendFormat("</tr>");
                    }

                    void AddDeptRow(string Name, string Designation, string ISD, string Mobile, string EmailId)
                    {

                        bodyBuilder.AppendFormat(
                            "<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td></tr>",
                            string.IsNullOrWhiteSpace(Name) ? "N/A" : System.Net.WebUtility.HtmlEncode(Name),
                            string.IsNullOrWhiteSpace(Designation) ? "N/A" : System.Net.WebUtility.HtmlEncode(Designation),
                            string.IsNullOrWhiteSpace(ISD) ? "N/A" : System.Net.WebUtility.HtmlEncode(ISD),
                            string.IsNullOrWhiteSpace(Mobile) ? "N/A" : System.Net.WebUtility.HtmlEncode(Mobile),
                            string.IsNullOrWhiteSpace(EmailId) ? "N/A" : System.Net.WebUtility.HtmlEncode(EmailId)
                        );
                    }

                    void AddBankRow(string AccName, string AccountNumber, string BankName, string IFSC)
                    {

                        bodyBuilder.AppendFormat(
                            "<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td></tr>",
                            string.IsNullOrWhiteSpace(AccName) ? "N/A" : System.Net.WebUtility.HtmlEncode(AccName),
                            string.IsNullOrWhiteSpace(AccountNumber) ? "N/A" : System.Net.WebUtility.HtmlEncode(AccountNumber),
                            string.IsNullOrWhiteSpace(BankName) ? "N/A" : System.Net.WebUtility.HtmlEncode(BankName),
                            string.IsNullOrWhiteSpace(IFSC) ? "N/A" : System.Net.WebUtility.HtmlEncode(IFSC)
                        );
                    }

                    bodyBuilder.Append("<h3>Bank details of your organization.</h3>");
                    bodyBuilder.Append("<table border='1' cellpadding='6' cellspacing='0' style='border-collapse: collapse; width: 100%;'>");
                    if (emailmodel != null && emailmodel.Count > 0)
                    {
                        bodyBuilder.AppendFormat("<tr>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Account Name</th>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Account Number</th>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Bank Name</th>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>IFSC</th>");
                        bodyBuilder.AppendFormat("</tr>");

                        AddBankRow(emailmodel[0].AccountName, emailmodel[0].AccountNumber, emailmodel[0].BankName, emailmodel[0].IFSC);
                    }
                    bodyBuilder.Append("</table><br/>");

                    bodyBuilder.Append("<h3>Details of your Key Management/Managerial level personnel.</h3>");
                    bodyBuilder.Append("<table border='1' cellpadding='6' cellspacing='0' style='border-collapse: collapse; width: 100%;'>");
                    if (emailmodel[0].ManagementDeptDetails != null && emailmodel[0].ManagementDeptDetails.Any())
                    {
                        AddDeptCommonHearder();
                        foreach (var attachment in emailmodel[0].ManagementDeptDetails)
                        {
                            if (!string.IsNullOrWhiteSpace(attachment.Name))
                            {
                                try
                                {
                                    AddDeptRow(attachment.Name, attachment.Designation, attachment.MCountryCode, attachment.MobileNumber, attachment.EmailID);
                                }
                                catch (Exception Ex)
                                {
                                    Console.WriteLine($"Failed to process {attachment.Name}: {Ex.Message}");
                                }
                            }
                        }
                    }
                    bodyBuilder.Append("</table><br/>");

                    bodyBuilder.Append("<h3>Details of your Key Finance/Accounts personnel.</h3>");
                    bodyBuilder.Append("<table border='1' cellpadding='6' cellspacing='0' style='border-collapse: collapse; width: 100%;'>");
                    if (emailmodel[0].FinanceDeptDetails != null && emailmodel[0].FinanceDeptDetails.Any())
                    {
                        AddDeptCommonHearder();
                        foreach (var attachment in emailmodel[0].FinanceDeptDetails)
                        {
                            if (!string.IsNullOrWhiteSpace(attachment.Name))
                            {
                                try
                                {
                                    AddDeptRow(attachment.Name, attachment.Designation, attachment.MCountryCode, attachment.MobileNumber, attachment.EmailID);
                                }
                                catch (Exception Ex)
                                {
                                    Console.WriteLine($"Failed to process {attachment.Name}: {Ex.Message}");
                                }
                            }
                        }
                    }
                    bodyBuilder.Append("</table><br/>");

                    bodyBuilder.Append("<h3>Other Information</h3>");

                    bodyBuilder.Append("<table border='1' cellpadding='6' cellspacing='0' style='border-collapse: collapse; width: 50%;'>");

                    if (emailmodel != null && emailmodel.Count > 0)
                    {
                        AddRow("Agent Classification", emailmodel[0].agentClassification);
                        AddRow("Market", emailmodel[0].marketAssigned);
                        AddRow("Tam Sales Rep", emailmodel[0].tamSalesRep);
                        AddRow("Credit Applicable", emailmodel[0].CreditApplicable.HasValue && emailmodel[0].CreditApplicable.Value ? "Yes" : "No");
                        AddRow("Credit Allowance", emailmodel[0].CreditAllowance == 0 ? "Not Defined" : emailmodel[0].CreditAllowance.ToString());
                        AddRow("Currency", emailmodel[0].creditCurrency == "" ? "Not Selected" : emailmodel[0].creditCurrency);
                    }

                    bodyBuilder.Append("</table><br/>");

                    bodyBuilder.Append("Thanks & Regards<br/>");
                    bodyBuilder.Append("Please do not revert on this email. This is system genereated email.<br/>");

                    bodyBuilder.Append("</body></html>");

                    using (MailMessage mail = new MailMessage())
                    {
                        mail.From = new MailAddress(_smtpSettings.RegFromMail, _smtpSettings.SenderName);

                        if (!string.IsNullOrWhiteSpace(to))
                        {
                            foreach (var address in to.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries))
                            {
                                mail.To.Add(address.Trim());
                            }
                        }


                        if (!string.IsNullOrWhiteSpace(cc))
                        {
                            foreach (var address in cc.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries))
                            {
                                mail.CC.Add(address.Trim());
                            }
                        }

                        mail.ReplyToList.Add(_smtpSettings.RegFromMail);

                        mail.Subject = subject;
                        mail.Body = bodyBuilder.ToString();
                        mail.IsBodyHtml = true;

                        int attachmentCount = 0;



                        // ATTACH MANUAL FILES (UP TO 4 FILES MAX)
                        if (req.AttachmentUrl != null && req.AttachmentUrl.Any())
                        {
                            int remainingSlots = 4 - attachmentCount; // Reserve slots for manual files
                            int manualFilesAttached = 0;

                            Console.WriteLine($" Processing manual attachments. Remaining slots: {remainingSlots}");

                            foreach (var attachment in req.AttachmentUrl.Take(remainingSlots))
                            {
                                try
                                {
                                    bool attached = false;

                                    // Try Base64 content first (mapping to your JSON structure)
                                    if (!string.IsNullOrWhiteSpace(attachment.Base64 ?? attachment.Base64Content) &&
                                        !string.IsNullOrWhiteSpace(attachment.Filename ?? attachment.FileName))
                                    {
                                        try
                                        {
                                            string base64Data = attachment.Base64 ?? attachment.Base64Content;
                                            string fileName = attachment.Filename ?? attachment.FileName;
                                            string fileExt = attachment.Fileext ?? attachment.FileExt ?? "application/octet-stream";

                                            byte[] fileBytes = Convert.FromBase64String(base64Data);
                                            var stream = new MemoryStream(fileBytes);
                                            stream.Position = 0;
                                            var mailAttachment = new Attachment(stream, fileName, fileExt);
                                            mail.Attachments.Add(mailAttachment);
                                            attached = true;
                                            manualFilesAttached++;
                                            Console.WriteLine($" Manual attachment added (Base64): {fileName}");
                                        }
                                        catch (Exception base64Ex)
                                        {
                                            Console.WriteLine($"Failed to process Base64 attachment {attachment.Filename ?? attachment.FileName}: {base64Ex.Message}");
                                        }
                                    }


                                }
                                catch (Exception attachEx)
                                {
                                    Console.WriteLine($"Failed to attach manual file {attachment.Filename ?? attachment.FileName}: {attachEx.Message}");
                                }
                            }

                            Console.WriteLine($" Total manual files attached: {manualFilesAttached}");
                            Console.WriteLine($" Total attachments: {attachmentCount + manualFilesAttached}");
                        }
                        using (SmtpClient smtp = new SmtpClient(_smtpSettings.Host, _smtpSettings.Port))
                        {
                            smtp.Credentials = new NetworkCredential(_smtpSettings.UserName, _smtpSettings.Password);
                            smtp.EnableSsl = true;
                            await smtp.SendMailAsync(mail);
                            Console.WriteLine($" Email sent successfully to {to}");
                        }
                    }

                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($" Email sending failed: {ex.Message}");
                Console.WriteLine($"Stack trace: {ex.StackTrace}");
                throw new Exception("Failed to send email.", ex);
            }

        }

    }


}
