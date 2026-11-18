using CommonClass;
using Microsoft.AspNetCore.Mvc;
using TamarindAstraReports.Interface;

namespace TamarindAstra.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReportController : ControllerBase
    {
        private readonly IReport _report;


        public ReportController(IReport report)
        {
            _report = report;
        }

        #region HotelRateDetails starts here
        ////[Authorize]
        [HttpPost("HotelRateCard")]
        public async Task<ResponseModel> HotelRateCard(RequestModel request)
        {
            return await _report.HotelRateCard(request);
        }
        #endregion HotelRateDetails ends here

        #region ReportDownloads starts here
        ////[Authorize]
        [HttpPost("ReportDownloads")]
        public async Task<ResponseModel> ReportDownloads(RequestModel request)
        {
            return await _report.ReportDownloads(request);
        }
        [HttpPost("ReportDownloadsEXPORT")]
        public async Task<ResponseModel> EXPReportDownloads(RequestModel request)
        {
            return await _report.GetMasterForExport(request);
        }
        #endregion ReportDownloads ends here

        #region GREXOViewModel starts here
        ////[Authorize]
        [HttpPost("GREXOViewModel")]
        public async Task<ResponseModel> GREXOViewModel(RequestModel request)
        {
            return await _report.GREXOViewModel(request);
        }
        #endregion GREXOViewModel ends here

        #region SearchFileCodeXoNoQuotation starts here
        ////[Authorize]
        [HttpPost("SearchFileCodeXoNoQuotation")]
        public async Task<ResponseModel> SearchFileCodeXoNoQuotation(RequestModel request)
        {
            return await _report.SearchFileCodeXoNoQuotation(request);
        }
        #endregion SearchFileCodeXoNoQuotation ends here

        #region UpdateLockUnlockQuotationModel starts here
        ////[Authorize]
        [HttpPost("UpdateLockUnlockQuotationModel")]
        public async Task<ResponseModel> UpdateLockUnlockQuotationModel(RequestModel request)
        {
            return await _report.UpdateLockUnlockQuotationModel(request);
        }
        #endregion UpdateLockUnlockQuotationModel ends here

        #region File2FileMapping starts here
        ////[Authorize]
        [HttpPost("File2FileMapping")]
        public async Task<ResponseModel> File2FileMapping(RequestModel request)
        {
            return await _report.File2FileMapping(request);
        }
        #endregion File2FileMapping ends here

        #region GetReportTypes starts here
        ////[Authorize]
        [HttpPost("GetReportTypes")]
        public async Task<ResponseModel> GetReportTypes(RequestModel request)
        {
            return await _report.GetReportTypes(request);
        }
        #endregion GetReportTypes ends here

        #region XoData starts here
        ////[Authorize]
        [HttpPost("XoData")]
        public async Task<ResponseModel> XODataModel(RequestModel request)
        {
            return await _report.XODataModel(request);
        }
        #endregion XoData ends here

        #region filecode starts here
        [HttpPost("FileCode")]
        public async Task<ResponseModel> FileCode(RequestModel request)
        {
            return await _report.FileCode(request);
        }
        #endregion filecode ends here
    }
}