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
using static TamarindAstraMasters.MasterModel.HotelRegistrationModel;
using static TamarindAstraMasters.MasterModel.VendorRegistrationModel;


namespace TamarindAstraMasters.Repositories
{
    public class HotelRegistrationRepository : IHotelRegistration
    {
        private static readonly Logger logger = LogManager.GetCurrentClassLogger();
        private readonly IConfiguration _configuration;

        public HotelRegistrationRepository(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        //select* from HotelRegistration_Mail
        //select* from HotelRegistration_Mail_Details

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
        public async Task SendHotelRegistrationMail(RequestModel request)
        {
            var _smtpSettings = SharedConfiguration.GetSmtpSettings();
            try
            {
                if (request == null || string.IsNullOrEmpty(request.RequestText))
                    throw new ArgumentNullException("Request is null or empty.");

                //HotelRegistration_Mail Table

                Console.WriteLine(" Starting Hotel Registration process");

                string subject = string.Empty;
                string to = string.Empty;
                //to = "dinesh_jagtapidealake.com";
                string cc = string.Empty;
                var HotelRegistration = new HotelRegistration();

                HotelRegistration = CommonFunctions.DecryptAndDeserializeNullRequest<HotelRegistration>(request.RequestText);

                StringBuilder bodyBuilder = new StringBuilder();
                StringBuilder bodyBuilder_withoutApprovalLink = new StringBuilder();
                bodyBuilder.Append("<html><body style='font-family: Arial, sans-serif;'>");

                to = HotelRegistration.EmailTo;
                cc = HotelRegistration.EmailCC;

                if (HotelRegistration.EmailFrom != "")
                    cc += ";" + HotelRegistration.EmailFrom;

                var HotelReg = await SqlOperation(new
                {
                    fromEmail = HotelRegistration.EmailFrom,
                    toEmail = HotelRegistration.EmailTo,
                    ccEmail = cc,
                    subject = HotelRegistration.Subject,
                    createdby = HotelRegistration.OperationBy
                }, "[dbo].[usp_InsertHotelRegistrationMail]");
                string HotelRegID = "", empCCEmail = "";
                if (HotelReg.Rows.Count > 0)
                {
                    HotelRegID = HotelReg.Rows[0]["HotelRegID"].ToString();
                    empCCEmail = HotelReg.Rows[0]["createdByEmail"].ToString();
                    if (empCCEmail != "")
                        cc += ";" + empCCEmail;
                }

                string encryptedData = Convert.ToBase64String(Encoding.UTF8.GetBytes(HotelRegID));

                string hotelRegistrationUrl = SharedConfiguration.GetHotelRegistrationUrl();
                string hotelRegistrationLink = $"{hotelRegistrationUrl}?data={HttpUtility.UrlEncode(encryptedData)}";

                subject = "Hotel Registration Link - " + HotelRegistration.Subject;

                //string XO_ID = HotelRegistration.XO_ID ?? "N/A";
                //string rawEmailData = $"{HotelRegistration.EmailFrom}|{HotelRegistration.EmailTo}|{HotelRegistration.EmailCC}|{HotelRegistration.ID}";
                //string encryptedData = Convert.ToBase64String(Encoding.UTF8.GetBytes(rawEmailData));

                //string approveBaseUrl = SharedConfiguration.GetAdvancePayApproveUrl();
                //string rejectBaseUrl = SharedConfiguration.GetAdvancePayRejectUrl();
                //string approveLink = $"{approveBaseUrl}{HttpUtility.UrlEncode(XO_ID)}?data={HttpUtility.UrlEncode(encryptedData)}";
                //string rejectLink = $"{rejectBaseUrl}{HttpUtility.UrlEncode(XO_ID)}?data={HttpUtility.UrlEncode(encryptedData)}";

                // Build email body
                bodyBuilder.Append("Dear Sir/Madam,<br/><br/>");
                bodyBuilder.Append("Greetings!<br/><br/>");
                bodyBuilder.Append("In order to create your hotel profile in our database, we will need the billing and statutory details of your organization. Kindly click the below link to access the registration form we have provided for this purpose.<br/><br/>");
                bodyBuilder.Append("<a href='" + hotelRegistrationLink + "'>Hotel Registration Form</a><br/><br/>");
                bodyBuilder.Append("Thank You,<br/>");
                bodyBuilder.Append("Tamarind Global Team.");



                // ✅ SEND EMAIL WITH BOTH AUTO-EXCEL AND MANUAL ATTACHMENTS
                using (MailMessage mail = new MailMessage())
                {
                    mail.From = new MailAddress(HotelRegistration.EmailFrom, _smtpSettings.SenderName);

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

                    //if (!string.IsNullOrEmpty(HotelRegistration.EmailFrom))
                    //{
                    //    mail.ReplyToList.Add(new MailAddress(HotelRegistration.EmailFrom));
                    //}

                    if (!string.IsNullOrEmpty(HotelRegistration.EmailFrom))
                    {
                        mail.ReplyToList.Clear();
                        mail.ReplyToList.Add(new MailAddress(HotelRegistration.EmailFrom));
                    }

                    mail.Subject = subject;
                    mail.Body = bodyBuilder.ToString();
                    mail.IsBodyHtml = true;

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

                Console.WriteLine(" Hotel Registration process completed successfully");
                //}
            }
            catch (Exception ex)
            {
                Console.WriteLine($" Email sending failed: {ex.Message}");
                Console.WriteLine($"Stack trace: {ex.StackTrace}");
                throw new Exception("Failed to send email.", ex);
            }
        }
        public async Task<ResponseModel> GetHotelRegistrationMailDetail(RequestModel request)
        {
            ResponseModel _resModel = new ResponseModel();
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<HotelRegistration>(request.RequestText);
                logger.Debug("GetHotelRegistrationMailDetail method called");

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
                    var data = new CommonClass.ResponseViewModel<HotelRegistration>();

                    int expiryInMinutes = int.Parse(_configuration["Jwt:ExpiryInMinutes"]);
                    var token = JwtHelper.GenerateBarrierJwtToken(_configuration, expiryInMinutes);
                    data.token = token;

                    return CommonFunctions.ProcessDBData(data, req.Action, "[dbo].[usp_Get_HotelRegistration_Mail]", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        public async Task SubmitHotelRegistrationForm(RequestModel request)
        {
            var _smtpSettings = SharedConfiguration.GetSmtpSettings();
            try
            {
                if (request == null || string.IsNullOrEmpty(request.RequestText))
                    throw new ArgumentNullException("Request is null or empty.");
                var req = CommonFunctions.DecryptAndDeserializeRequest<HotelRegistration>(request.RequestText);
                logger.Debug("SubmitHotelRegistrationForm method called");
                if (req != null)
                {

                    var parameters = new
                    {
                        @Action = "S",
                        @RequestID = req.RequestID,
                        @HotelName = req.HotelName,
                        @LegalName = req.LegalName,
                        @HotelRatingID = req.HotelRatingID,
                        @HotelTypeID = req.HotelTypeID,
                        @HotelGroupIATACode = req.HotelGroupIATACode,
                        @CustomHotelGroup = req.CustomHotelGroup,
                        @HotelPostalAddress = req.HotelPostalAddress,
                        @Country = req.Country,
                        @State = req.State,
                        @CustomState = req.CustomState,
                        @City = req.City,
                        @CustomCity = req.CustomCity,
                        @PostalCode = req.PostalCode,

                        @ISDCode = req.ISDCode,
                        @STDCode = req.STDCode,
                        @ContactNumber = req.ContactNumber,
                        @Website = req.Website,
                        @EmailID = req.EmailID,

                        @NoOfHotelRooms = req.NoOfHotelRooms,
                        @RoomCategoryNames = req.RoomCategoryNames,

                        @PAN = req.PAN,
                        @GST = req.GST,
                        @TAN = req.TAN,
                        @MSMEType = req.MSMEType,
                        @MSME_No = req.MSME_No,
                        @UDYAMNo = req.UDYAMNo,
                        @AccountName = req.AccountName,
                        @AccountNumber = req.AccountNumber,
                        @BankName = req.BankName,
                        @IFSC = req.IFSC,
                        @BankBranch = req.BankBranch,

                        @CancelBankChequeFileName = req.AttachmentUrl?
                    .FirstOrDefault(x => x.ContentType == "CancelBankCheque")
                    ?.FileName ?? string.Empty,

                        @GSTFileName = req.AttachmentUrl?
                    .FirstOrDefault(x => x.ContentType == "GST")
                    ?.FileName ?? string.Empty,

                        @PANFileName = req.AttachmentUrl?
                    .FirstOrDefault(x => x.ContentType == "PAN")
                    ?.FileName ?? string.Empty,

                        @TANFileName = req.AttachmentUrl?
                    .FirstOrDefault(x => x.ContentType == "TAN")
                    ?.FileName ?? string.Empty,

                        @MSMEFileName = req.AttachmentUrl?
                    .FirstOrDefault(x => x.ContentType == "MSME")
                    ?.FileName ?? string.Empty,

                        @VATFileName = req.AttachmentUrl?
                    .FirstOrDefault(x => x.ContentType == "VAT")
                    ?.FileName ?? string.Empty,

                        @VAT = req.VAT,
                        @SEZ_Unit = req.SEZ_Unit,

                        @createdby = req.CreatedBy,
                        @RegistrationDeptDetailJSON = req.RegistrationDeptDetailJSON,
                        @id = 0
                    };

                    var data = new CommonClass.ResponseViewModel<HotelRegistration>();
                    var result = CommonFunctions.ProcessDBData(data, "S", "[dbo].[usp_Insert_HotelRegistration_Mail_Details]", parameters);
                    var wrapper = CommonFunctions.SmartDecryptAndDeserialize<ResponseViewModel<HotelRegistration>>(result.responseText);

                    var emailmodel = wrapper?.dataList;

                    string subject = string.Empty;
                    string to = string.Empty;
                    string cc = string.Empty;

                    StringBuilder bodyBuilder = new StringBuilder();
                    bodyBuilder.Append("<html><body style='font-family: Arial, sans-serif;'>");

                    to = req.EmailCC;
                    cc = req.EmailTo;

                    //if (req.EmailFrom != "")
                    //    cc += ";" + req.EmailFrom;

                    subject = "Hotel Registration Form - " + req.Subject;

                    bodyBuilder.Append("<h3>Hotel Registration Form.</h3>");
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
                        AddRow("Hotel Name", emailmodel[0].HotelName);
                        AddRow("Legal Name", emailmodel[0].LegalName);
                        AddRow("Hotel Rating", emailmodel[0].HotelRating);
                        AddRow("Type of Property", emailmodel[0].HotelType);
                        AddRow("Hotel Chain/Group", emailmodel[0].HotelGroup);
                        AddRow("Custom Hotel Chain/Group", emailmodel[0].CustomHotelGroup?.ToString() == "" ? "Not Defined" : emailmodel[0].CustomState);
                        AddRow("Hotel Postal Address", emailmodel[0].HotelPostalAddress);
                        AddRow("Country", emailmodel[0].Country);
                        AddRow("State", emailmodel[0].State);
                        AddRow("Custom State", emailmodel[0].CustomState?.ToString() == "" ? "Not Defined" : emailmodel[0].CustomState);
                        AddRow("City", emailmodel[0].City);
                        AddRow("Custom City", emailmodel[0].CustomCity?.ToString() == "" ? "Not Defined" : emailmodel[0].CustomCity);
                        AddRow("Postal Code", emailmodel[0].PostalCode);
                        AddRow("Contact Number", emailmodel[0].ContactNumber);
                        AddRow("Website", emailmodel[0].Website);
                        AddRow("EmailID", emailmodel[0].EmailID);
                        AddRow("No. Of Rooms in Hotel", emailmodel[0].NoOfHotelRooms.ToString());
                        AddRow("Room Category Names", emailmodel[0].RoomCategoryNames);
                        AddRow("PAN Number", emailmodel[0].PAN.ToString() == "" ? "No" : emailmodel[0].PAN);
                        AddRow("GSTIN Number", emailmodel[0].GST.ToString() == "" ? "No" : emailmodel[0].GST);
                        AddRow("TAN Number", emailmodel[0].TAN.ToString() == "" ? "No" : emailmodel[0].TAN);
                        AddRow("MSME Type", emailmodel[0].MSMEType.ToString() == "" ? "No" : emailmodel[0].MSMEType);
                        AddRow("SEZ Unit", emailmodel[0].SEZ_Unit.HasValue && emailmodel[0].SEZ_Unit.Value ? "Yes" : "No");
                        AddRow("VAT Number", emailmodel[0].VAT.ToString() == "" ? "No" : emailmodel[0].VAT);
                    }

                    bodyBuilder.Append("</table><br/>");

                    void AddDeptCommonHearder()
                    {
                        bodyBuilder.AppendFormat("<tr>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Name</th>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Designation</th>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>ISD Number</th>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Mobile Number</th>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Email ID</th>");
                        bodyBuilder.AppendFormat("</tr>");
                    }

                    void AddDeptRow(string Name, string Designation, string ISD, string Mobile, string EmailId)
                    {

                        bodyBuilder.AppendFormat(
                            "<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td></tr>",
                            string.IsNullOrWhiteSpace(Name) ? "N/A" : System.Net.WebUtility.HtmlEncode(Name),
                            string.IsNullOrWhiteSpace(Designation) ? "N/A" : System.Net.WebUtility.HtmlEncode(Designation),
                            string.IsNullOrWhiteSpace(ISD) ? "N/A" : System.Net.WebUtility.HtmlEncode(ISD),
                            string.IsNullOrWhiteSpace(Mobile) ? "N/A" : System.Net.WebUtility.HtmlEncode(Mobile),
                            string.IsNullOrWhiteSpace(EmailId) ? "N/A" : System.Net.WebUtility.HtmlEncode(EmailId)
                        );
                    }

                    void AddBankRow(string Name, string AccNo, string BankName, string IFSC, string BankBranch)
                    {

                        bodyBuilder.AppendFormat(
                            "<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td></tr>",
                            string.IsNullOrWhiteSpace(Name) ? "N/A" : System.Net.WebUtility.HtmlEncode(Name),
                            string.IsNullOrWhiteSpace(AccNo) ? "N/A" : System.Net.WebUtility.HtmlEncode(AccNo),
                            string.IsNullOrWhiteSpace(BankName) ? "N/A" : System.Net.WebUtility.HtmlEncode(BankName),
                            string.IsNullOrWhiteSpace(IFSC) ? "N/A" : System.Net.WebUtility.HtmlEncode(IFSC),
                            string.IsNullOrWhiteSpace(BankBranch) ? "N/A" : System.Net.WebUtility.HtmlEncode(BankBranch)
                        );
                    }

                    bodyBuilder.Append("<h3>Bank details of your organization.</h3>");
                    bodyBuilder.Append("<table border='1' cellpadding='6' cellspacing='0' style='border-collapse: collapse; width: 100%;'>");
                    if (emailmodel != null && emailmodel.Count > 0)
                    {
                        bodyBuilder.AppendFormat("<tr>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Account Beneficiary Name</th>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Account Number</th>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Bank Name</th>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>IFSC Code</th>");
                        bodyBuilder.AppendFormat("<th align='left' style='background-color:#f0f0f0;'>Bank Branch</th>");
                        bodyBuilder.AppendFormat("</tr>");

                        AddBankRow(emailmodel[0].AccountName, emailmodel[0].AccountNumber, emailmodel[0].BankName, emailmodel[0].IFSC,
                            emailmodel[0].BankBranch);
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
                            int remainingSlots = 6 - attachmentCount; // Reserve slots for manual files
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
