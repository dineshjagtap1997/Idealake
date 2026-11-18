using CommonClass;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNetCore.Mvc;
using TamarindAstra.Common;
using TamarindAstra_Operations.Interface;

namespace TamarindAstra_Operations.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class XoModelController : Controller
    {
        private readonly IConfiguration _config;
        private readonly Ixo _xo;
        private readonly ILogger<XoModelController> _logger;

        public XoModelController(IConfiguration config, Ixo xo, ILogger<XoModelController> logger)
        {
            _config = config;
            _xo = xo;
            _logger = logger;
        }

        #region insertxo starts here
        [Authorize]
        [HttpPost("InsertXOModel")]
        public async Task<ResponseModel> InsertXOModel([FromBody] RequestModel request)
        {
            return await _xo.InsertXOModel(request);
        }
        #endregion insertxo ends here

        #region getxo starts here
        [Authorize]
        [HttpPost("GetXo")]
        public async Task<ResponseModel> GetXo([FromBody] RequestModel request)
        {
            return await _xo.GetXo(request);
        }
        #endregion getxo ends here

        #region xo starts here
        [Authorize]
        [HttpPost("XOInstruction")]
        public async Task<ResponseModel> XOInstruction([FromBody] RequestModel request)
        {
            return await _xo.XOInstruction(request);
        }
        #endregion xo ends here

        #region xo insertupdateinstruction starts here
        [Authorize]
        [HttpPost("XOInstructionModel")]
        public async Task<ResponseModel> XOInstructionModel([FromBody] RequestModel request)
        {
            return await _xo.XOInstructionModel(request);
        }
        #endregion xoinsertupdateinstruction ends here

        #region updatexo starts here
        [Authorize]
        [HttpPost("UpdateUndoXOModel")]
        public async Task<ResponseModel> UpdateUndoXOModel([FromBody] RequestModel request)
        {
            return await _xo.UpdateUndoXOModel(request);
        }
        #endregion updatexo ends here

        #region updateadvancepay starts here
        [Authorize]
        [HttpPost("UpdateAdvancePaySendRequestModel")]
        public async Task<ResponseModel> UpdateAdvancePaySendRequestModel([FromBody] RequestModel request)
        {
            return await _xo.UpdateAdvancePaySendRequestModel(request);
        }
        #endregion updateadvancepay ends here

        #region ADVANCEPAY starts here
        [Authorize]
        [HttpPost("AdvancePaySendRequestModel")]
        public async Task<ResponseModel> AdvancePaySendRequestModel([FromBody] RequestModel request)
        {
            return await _xo.AdvancePaySendRequestModel(request);
        }
        #endregion ADVANCEPAY ends here

        #region QuotationXOAdvPyModel starts here
        [Authorize]
        [HttpPost("QuotationXOAdvPyModel")]
        public async Task<ResponseModel> QuotationXOAdvPyModel([FromBody] RequestModel request)
        {
            return await _xo.QuotationXOAdvPyModel(request);
        }
        #endregion QuotationXOAdvPyModel ends here

        #region printxo starts if
        [HttpPost("XOReportModel")]
        public async Task<ResponseModel> XOReportModel([FromBody] RequestModel request)
        {
            return await _xo.XOReportModel(request);
        }
        #endregion printxo ends here

        #region xounlock starts here
        [Authorize]
        [HttpPost("SendAdvancePayMail")]
        public async Task<ResponseModel> SendAdvancePayMail([FromBody] RequestModel request)
        {
            try
            {
                await _xo.SendAdvancePayEmail(request, includeUnlockSection: false, includeAdvancePaySection: true);
                return CommonFunctions.BlankResponse("200", "Advance Pay email sent successfully.");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending Advance Pay email");
                return CommonFunctions.CreateErrorResponse(ex, "500", "Error sending Advance Pay email.");
            }
        }
        #endregion xounlock ends here

        [Authorize]
        [HttpPost("SendUnlockRequestMail")]
        public async Task<ResponseModel> SendUnlockRequestMail([FromBody] RequestModel request)
        {
            try
            {
                await _xo.SendAdvancePayEmail(request, includeUnlockSection: true, includeAdvancePaySection: false);
                return CommonFunctions.BlankResponse("200", "Unlock request email sent successfully.");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending Unlock request email");
                return CommonFunctions.CreateErrorResponse(ex, "500", "Error sending Unlock request email.");
            }
        }

        [Authorize]
        [HttpPost("GetAdvancePayDataByFileCode")]
        public async Task<ResponseModel> GetAdvancePayDataByFileCode([FromBody] RequestModel request)
        {
            return await _xo.GetAdvancePayDataByFileCode(request);
        }

        [HttpPost("ExportMasterToCsv")]
        public async Task<ResponseModel> ExportMasterToCsv(RequestModel request)
        {
            return await _xo.GetMasterForExport(request);
        }

        [HttpPost("ExportAdvancePayReqToCsv")]
        public async Task<ResponseModel> ExportAdvancePayReqToCsv(RequestModel request)
        {
            return await _xo.GetAdvancePayReqForExport(request);
        }
    }
}