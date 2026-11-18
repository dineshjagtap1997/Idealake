using CommonClass;
using Microsoft.AspNetCore.Mvc;
using TamarindAstra.Common;
using TamarindAstraMasters.Interface;

namespace TamarindAstraMasters.Controllers
{

    [ApiController]
    [Route("api/[controller]")]
    public class VendorRegistrationController : Controller
    {
        private readonly IVendorRegistration _cr;

        public VendorRegistrationController(IVendorRegistration cr)
        {
            _cr = cr;
        }

        [HttpPost("SendVendorRegistrationMail")]
        public async Task<ResponseModel> SendVendorRegistrationMail([FromBody] RequestModel request)
        {
            try
            {
                await _cr.SendVendorRegistrationMail(request);
                return CommonFunctions.BlankResponse("200", "Vendor Registration email sent successfully.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Error sending Vendor Registration email.");
            }
        }

        [HttpPost("GetVendorRegistrationMailDetail")]
        public async Task<ResponseModel> GetVendorRegistrationMailDetail(RequestModel request)
        {
            return await _cr.GetVendorRegistrationMailDetail(request);
        }

        [HttpPost("SubmitVendorRegistrationForm")]
        public async Task<ResponseModel> SubmitVendorRegistrationForm([FromBody] RequestModel request)
        {
            try
            {
                await _cr.SubmitVendorRegistrationForm(request);
                return CommonFunctions.BlankResponse("200", "Mail sent successfully.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Error sending Mail.");
            }
        }
    }
}
