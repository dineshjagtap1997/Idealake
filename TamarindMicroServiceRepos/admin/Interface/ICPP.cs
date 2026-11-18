using CommonClass;

namespace BusinessLogic.Interface
{
    public interface ICPP
    {
        Task<ResponseModel> AgewiseandHotelwiseRoomNights(RequestModel request);
        Task<ResponseModel> PLBMaster(RequestModel request);
        Task<ResponseModel> PackageCodeMaster(RequestModel request);
        Task<ResponseModel> CPPReports(RequestModel request);
        Task<ResponseModel> ExportCPPReports(ResponseModel request);
       // Task<byte[]> ExportCPPReports(RequestModel request);
    }
}
