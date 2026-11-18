using CommonClass;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace TamarindAstraLoginDashboardReport.Interface
{
    public interface IDashboard
    {
        Task<ResponseModel> GetTourStartingEnding(RequestModel request);
        Task<ResponseModel> GetAdvancePaymentRequest(RequestModel request);
        Task<ResponseModel> GetDashboardCount(RequestModel request);
        Task<ResponseModel> GetDashboardStayTransport(RequestModel request);
        Task<ResponseModel> GetDashAgentInvoice(RequestModel request);

        Task<ResponseModel> GetDashCommInvoice(RequestModel request);
        Task<ResponseModel> GetDashPerformaNotConverted(RequestModel request);
        Task<ResponseModel> GetMasterForExport(RequestModel request);
        

    }
}
