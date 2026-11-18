// Updated Interface - Remove loggedInUserEmail parameter
using CommonClass;
using TamarindAstra_Operations.Model;
using static TamarindAstra_Operations.Model.Xomodel;

namespace TamarindAstra_Operations.Interface
{
    public interface Ixo
    {
        Task<ResponseModel> InsertXOModel(RequestModel request);
        Task<ResponseModel> GetXo(RequestModel request);
        Task<ResponseModel> XOInstruction(RequestModel request);
        Task<ResponseModel> XOInstructionModel(RequestModel request);
        Task<ResponseModel> UpdateUndoXOModel(RequestModel request);
        Task<ResponseModel> AdvancePaySendRequestModel(RequestModel request);
        Task<ResponseModel> UpdateAdvancePaySendRequestModel(RequestModel request);
        Task<ResponseModel> QuotationXOAdvPyModel(RequestModel request);
        Task<ResponseModel> XOReportModel(RequestModel request);
        Task<ResponseModel> GetAdvancePayDataByFileCode(RequestModel request);
        Task<ResponseModel> GetMasterForExport(RequestModel request);
        Task<ResponseModel> GetAdvancePayReqForExport(RequestModel request);
        // Simplified method signature - no need for extra parameter since EmailFrom is in request data
        Task SendAdvancePayEmail(RequestModel request, bool includeUnlockSection, bool includeAdvancePaySection, bool advancepayapprovereject = false);
    }
}