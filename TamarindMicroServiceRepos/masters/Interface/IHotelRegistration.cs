using CommonClass;
namespace TamarindAstraMasters.Interface
{
    public interface IHotelRegistration
    {
        Task SendHotelRegistrationMail(RequestModel request);
        Task<ResponseModel> GetHotelRegistrationMailDetail(RequestModel request);
        Task SubmitHotelRegistrationForm(RequestModel request);
    }
}
