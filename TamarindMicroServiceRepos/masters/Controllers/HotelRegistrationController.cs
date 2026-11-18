using CommonClass;
using Microsoft.AspNetCore.Mvc;
using TamarindAstra.Common;
using TamarindAstraMasters.Interface;
namespace TamarindAstraMasters.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class HotelRegistrationController : Controller
    {
        private readonly IHotelRegistration _cr;

        public HotelRegistrationController(IHotelRegistration cr)
        {
            _cr = cr;
        }

        [HttpPost("SendHotelRegistrationMail")]
        public async Task<ResponseModel> SendHotelRegistrationMail([FromBody] RequestModel request)
        {
            try
            {
                await _cr.SendHotelRegistrationMail(request);
                return CommonFunctions.BlankResponse("200", "Hotel Registration email sent successfully.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Error sending Hotel Registration email.");
            }
        }

        [HttpPost("GetHotelRegistrationMailDetail")]
        public async Task<ResponseModel> GetHotelRegistrationMailDetail(RequestModel request)
        {
            return await _cr.GetHotelRegistrationMailDetail(request);
        }

        [HttpPost("SubmitHotelRegistrationForm")]
        public async Task<ResponseModel> SubmitHotelRegistrationForm([FromBody] RequestModel request)
        {
            try
            {
                await _cr.SubmitHotelRegistrationForm(request);
                return CommonFunctions.BlankResponse("200", "Mail sent successfully.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Error sending Mail.");
            }
        }
    }
}
