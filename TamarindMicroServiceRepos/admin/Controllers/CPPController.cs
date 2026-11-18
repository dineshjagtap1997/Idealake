using BusinessLogic.Interface;
using CommonClass;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace TamarindAstra.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CPPController : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly ICPP _CPP;
        private readonly ILogger<CPPController> _logger;

        public CPPController(IConfiguration config, ICPP CPP, ILogger<CPPController> logger)
        {
            _config = config;
            _CPP = CPP;
            _logger = logger;
        }

        #region PLBMaster starts here
        [Authorize]
        [HttpPost("PLBMaster")]
        public async Task<ResponseModel> PLBMaster(RequestModel request)
        {
            return await _CPP.PLBMaster(request);
        }
        #endregion PLBMaster ends here

        #region AgewiseandHotelwiseRoomNights starts here
        //[Authorize]

        [HttpPost("AgewiseandHotelwiseRoomNights")]
        public async Task<ResponseModel> AgewiseandHotelwiseRoomNights(RequestModel request)
        {
            return await _CPP.AgewiseandHotelwiseRoomNights(request);
        }
        #endregion AgewiseandHotelwiseRoomNights ends here

        #region PackageCodeMaster starts here
        [Authorize]
        [HttpPost("PackageCodeMaster")]
        public async Task<ResponseModel> PackageCodeMaster(RequestModel request)
        {
            return await _CPP.PackageCodeMaster(request);
        }
        #endregion PackageCodeMaster ends here

        #region ExportCPPReports starts here
        //[Authorize]
        [HttpPost("ExportCPPReports")]
        public async Task<ResponseModel> ExportCPPReports(RequestModel request)
        {
            return await _CPP.CPPReports(request);
        }
        #endregion ExportCPPReports ends here
    }
}

