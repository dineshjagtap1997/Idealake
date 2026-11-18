using CommonClass;

namespace TamarindAstraEnquiry.Interface
{
    public interface IEnquiry
    {
        Task<ResponseModel> EnquiryModel (RequestModel request);
        Task<ResponseModel> EnquiryClient(RequestModel request);
        Task<ResponseModel> EnquiryStatus(RequestModel request);
        Task<ResponseModel> Enquiryfollowup(RequestModel request);
        Task<ResponseModel> Get_LostReason(RequestModel request);
        Task<ResponseModel> Lost_Enquiry(RequestModel request);
     
    }
}
