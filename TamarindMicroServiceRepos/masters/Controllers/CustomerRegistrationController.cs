using CommonClass;
using Microsoft.AspNetCore.Mvc;
using TamarindAstra.Common;
using TamarindAstraMasters.Interface;

namespace TamarindAstraMasters.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CustomerRegistrationController : Controller
    {
        private readonly ICustomerRegistration _cr;

        public CustomerRegistrationController(ICustomerRegistration cr)
        {
            _cr = cr;
        }

        [HttpPost("SendCustomerRegistrationMail")]
        public async Task<ResponseModel> SendCustomerRegistrationMail([FromBody] RequestModel request)
        {
            try
            {
                await _cr.SendCustomerRegistrationMail(request);
                return CommonFunctions.BlankResponse("200", "Customer Registration email sent successfully.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Error sending Customer Registration email.");
            }
        }

        [HttpPost("GetCustomerRegistrationMailDetail")]
        public async Task<ResponseModel> GetCustomerRegistrationMailDetail(RequestModel request)
        {
            return await _cr.GetCustomerRegistrationMailDetail(request);
        }

        [HttpPost("SubmitCustomerRegistrationForm")]
        public async Task<ResponseModel> SubmitCustomerRegistrationForm([FromBody] RequestModel request)
        {
            try
            {
                await _cr.SubmitCustomerRegistrationForm(request);
                return CommonFunctions.BlankResponse("200", "Mail sent successfully.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Error sending Mail.");
            }
        }

    }
}
