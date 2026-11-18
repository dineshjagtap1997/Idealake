using CommonClass;
using Microsoft.AspNetCore.Mvc;
using TamarindAstraEnquiry.Interface;

namespace TamarindAstraEnquiry.Controllers
{

    [ApiController]
    [Route("api/[controller]")]
    public class Enquirycontroller : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly IEnquiry _Enquiry;
        private readonly ILogger<Enquirycontroller> _logger;


        public Enquirycontroller(IConfiguration config, IEnquiry Enquiry, ILogger<Enquirycontroller> logger)
        {
            _config = config;
            _Enquiry = Enquiry;
            _logger = logger;
        }

        #region EnquiryModel starts here
        //[Authorize]
        [HttpPost("EnquiryModel")]
        public async Task<ResponseModel> EnquiryModel(RequestModel request)
        {
            return await _Enquiry.EnquiryModel(request);
        }
        #endregion EnquiryModel starts here

        #region EnquiryClientModel starts here
        //[Authorize]
        [HttpPost("EnquiryClient")]
        public async Task<ResponseModel> EnquiryClient(RequestModel request)
        {
            return await _Enquiry.EnquiryClient(request);
        }
        #endregion EnquiryClientModel starts here


        #region EnquiryStatus starts here
        //[Authorize]
        [HttpPost("EnquiryStatus")]
        public async Task<ResponseModel> EnquiryStatus(RequestModel request)
        {
            return await _Enquiry.EnquiryStatus(request);
        }
        #endregion EnquiryStatus starts here

        #region Enquiryfollowup starts here
        //[Authorize]
        [HttpPost("Enquiryfollowup")]
        public async Task<ResponseModel> Enquiryfollowup(RequestModel request)
        {
            return await _Enquiry.Enquiryfollowup(request);
        }
        #endregion Enquiryfollowup starts here


        #region Get_LostReason starts here
        //[Authorize]
        [HttpPost("Get_LostReason")]
        public async Task<ResponseModel> Get_LostReason(RequestModel request)
        {
            return await _Enquiry.Get_LostReason(request);
        }
        #endregion Get_LostReason starts here

        #region Lost_Enquiry starts here
        //[Authorize]
        [HttpPost("Lost_Enquiry")]
        public async Task<ResponseModel> Lost_Enquiry(RequestModel request)
        {
            return await _Enquiry.Lost_Enquiry(request);
        }
        #endregion Lost_Enquiry starts here
    }
}
