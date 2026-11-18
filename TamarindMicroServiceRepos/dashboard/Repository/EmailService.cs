using MailKit.Net.Smtp;
using MimeKit;
using Microsoft.Extensions.Options;
using TamarindAstra.Common;
using CommonClass;
using TamarindAstraLoginDashboardReport.Interface;
using TamarindAstraLoginDashboardReport.Models;

namespace TamarindAstraLoginDashboardReport.Repository
{
    public class EmailService: IEmailService
    {
        //private readonly SmtpSettings _smtpSettings;

        //public EmailService(IOptions<SmtpSettings> smtpSettings)
        //{
        //    _smtpSettings = smtpSettings.Value;
        //}

        public async Task<ResponseModel> SendEmail(RequestModel request)
        {

            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<SendEmail>(request.RequestText);

                if (req != null)
                {
                    string body = CommonFunctions.createHtml(req.Content, req.HotelName);
                   
                    SendEmailHotelInfo(body, "Hotel Information");
                    var data = new ResponseViewModel<object>
                    {
                        returnCode = "200",
                        returnMessage = "Email sent successfully."
                    };
                     return CommonFunctions.ProcessResult(data);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }
        }
        public void SendEmailHotelInfo(string body,string subject)
        {
            var _smtpSettings = SharedConfiguration.GetSmtpSettings();

            var message = new MimeMessage();
            message.From.Add(new MailboxAddress(_smtpSettings.SenderName, _smtpSettings.SenderEmail));
            message.To.Add(new MailboxAddress("", _smtpSettings.RecipientEmail));
            message.Subject = subject;


            
            message.Body = new TextPart("html") { Text = body };

            try
            {
                using (var client = new SmtpClient())
                {
                    client.Connect(_smtpSettings.Host, _smtpSettings.Port, false);
                    client.Authenticate(_smtpSettings.UserName, _smtpSettings.Password);
                    client.Send(message);
                    client.Disconnect(true);
                }
            }
            catch (Exception ex)
            {
               
            }
        }
    }
}
