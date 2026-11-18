using CommonClass;
using Microsoft.AspNetCore.Mvc;
using TamarindAstra_Operations.Interface;

namespace TamarindAstra_Operations.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OperationsController : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly IOperations _Operation;
        private readonly ILogger<OperationsController> _logger;


        public OperationsController(IConfiguration config, IOperations level1, ILogger<OperationsController> logger)
        {
            _config = config;
            _Operation = level1;
            _logger = logger;
        }

        #region GetUserMail starts here
        //[Authorize]
        [HttpPost("GetUserMail")]
        public async Task<ResponseModel> GetUserMail(RequestModel request)
        {
            return await _Operation.GetUserMail(request);
        }
        #endregion GetUserMail ends here

        #region GetUserMail starts here
        //[Authorize]
        [HttpPost("Insert_HotelRegistration_Mail")]
        public async Task<ResponseModel> Insert_HotelRegistration_Mail(RequestModel request)
        {
            return await _Operation.Insert_HotelRegistration_Mail(request);
        }
        #endregion Insert_HotelRegistration_Mail ends here

        #region VendorRegistration_Mail starts here
        //[Authorize]
        [HttpPost("VendorRegistration_Mail")]
        public async Task<ResponseModel> VendorRegistration_Mail(RequestModel request)
        {
            return await _Operation.VendorRegistration_Mail(request);
        }
        #endregion VendorRegistration_Mail ends here

        #region FileSummary starts here
        //[Authorize]
        [HttpPost("FileSummary")]
        public async Task<ResponseModel> FileSummary(RequestModel request)
        {
            return await _Operation.FileSummary(request);
        }
        #endregion FileSummary ends here

        #region FetchItineraryDetails starts here
        //[Authorize]
        [HttpPost("FetchItineraryDetails")]
        public async Task<ResponseModel> FetchItineraryDetails(RequestModel request)
        {
            return await _Operation.FetchItineraryDetails(request);
        }
        #endregion FetchItineraryDetails ends here

        [HttpPost("FetchReasonMaster")]
        public async Task<ResponseModel> FetchReasonMaster(RequestModel request)
        {
            return await _Operation.FetchReasonMaster(request);
        }


        [HttpPost("usp_AutoCompleteSearch")]
        public async Task<ResponseModel> usp_AutoCompleteSearch(RequestModel request)
        {
            return await _Operation.usp_AutoCompleteSearch(request);
        }

    }
}