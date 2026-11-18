using CommonClass;

namespace TamarindAstra_Operations.Interface
{
    public interface IOperations
    {
        Task<ResponseModel> GetUserMail(RequestModel request);
        Task<ResponseModel> Insert_HotelRegistration_Mail(RequestModel request);
        Task<ResponseModel> VendorRegistration_Mail(RequestModel request);
        Task<ResponseModel> FileSummary(RequestModel request);
        Task<ResponseModel> FetchItineraryDetails(RequestModel request);
        Task<ResponseModel> FetchReasonMaster(RequestModel request);

        public Task<ResponseModel> usp_AutoCompleteSearch(RequestModel request);


    }
}


