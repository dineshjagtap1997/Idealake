using CommonClass;
namespace TamarindAstraMasters.Interface
{
    public interface IVendorRegistration
    {
        Task SendVendorRegistrationMail(RequestModel request);
        Task<ResponseModel> GetVendorRegistrationMailDetail(RequestModel request);
        Task SubmitVendorRegistrationForm(RequestModel request);
    }
}
