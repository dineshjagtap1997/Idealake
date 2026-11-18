using Microsoft.AspNetCore.Mvc;
using CommonClass;
using Microsoft.AspNetCore.Authorization;
using TamarindAstraLoginDashboardReport.Interface;
using TamarindAstraLoginDashboardReport.Models;

namespace TamarindAstraLoginDashboardReport.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DashboardController : Controller
    {
        private readonly IDashboard _dashboard;
        public DashboardController(IDashboard dashboard)
        {
            _dashboard = dashboard;
        }

        [HttpPost("GetTourStartingEnding")]
        public async Task<ResponseModel> GetTourStartingEnding(RequestModel request)
        {
            return await _dashboard.GetTourStartingEnding(request);
        }

        [HttpPost("GetAdvancePaymentRequest")]
        public async Task<ResponseModel> GetAdvancePaymentRequest(RequestModel request)
        {
            return await _dashboard.GetAdvancePaymentRequest(request);
        }

        [HttpPost("GetDashboardCount")]
        public async Task<ResponseModel> GetDashboardCount(RequestModel request)
        {
            return await _dashboard.GetDashboardCount(request);
        }
        [HttpPost("GetDashboardStayTransport")]
        public async Task<ResponseModel> GetDashboardStayTransport(RequestModel request)
        {
            return await _dashboard.GetDashboardStayTransport(request);
        }
        [HttpPost("GetDashAgentInvoice")]
        public async Task<ResponseModel> GetDashAgentInvoice(RequestModel request)
        {
            return await _dashboard.GetDashAgentInvoice(request);
        }
        [HttpPost("GetDashCommInvoice")]
        public async Task<ResponseModel> GetDashCommInvoice(RequestModel request)
        {
            return await _dashboard.GetDashCommInvoice(request);
        }
        [HttpPost("GetDashPerformaNotConverted")]
        public async Task<ResponseModel> GetDashPerformaNotConverted(RequestModel request)
        {
            return await _dashboard.GetDashPerformaNotConverted(request);
        }

        [HttpPost("DashboardDownloadsEXPORT")]
        public async Task<ResponseModel> EXPReportDownloads(RequestModel request)
        {
            return await _dashboard.GetMasterForExport(request);
        }
    }
}
