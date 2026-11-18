using CommonClass;

namespace TamarindAstraReports.Interface
{
    public interface IReport
    {
        Task<ResponseModel> HotelRateCard(RequestModel request);
        Task<ResponseModel> ReportDownloads(RequestModel request);

        Task<ResponseModel> GetMasterForExport(RequestModel request);

        Task<ResponseModel> GREXOViewModel(RequestModel request);
        Task<ResponseModel> SearchFileCodeXoNoQuotation(RequestModel request);

        Task<ResponseModel> UpdateLockUnlockQuotationModel(RequestModel request);

        Task<ResponseModel> File2FileMapping(RequestModel request);

        Task<ResponseModel> GetReportTypes(RequestModel request);

        Task<ResponseModel> XODataModel(RequestModel request);

        Task<ResponseModel> FileCode(RequestModel request);
    }
}
