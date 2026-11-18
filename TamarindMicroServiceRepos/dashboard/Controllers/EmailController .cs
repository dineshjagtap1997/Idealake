using Microsoft.AspNetCore.Mvc;
using TamarindAstraLoginDashboardReport.Interface;
using CommonClass;

namespace TamarindAstraLoginDashboardReport.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmailController : ControllerBase
    {
        private readonly IEmailService _emailService;

        public EmailController(IEmailService emailService)
        {
            _emailService = emailService;
        }

        [HttpPost("SendEmailHotelInfo")]
        public async Task<ResponseModel> SendEmailHotelInfo(RequestModel request)
        {
            return await _emailService.SendEmail(request);
           
        }
    }
}
