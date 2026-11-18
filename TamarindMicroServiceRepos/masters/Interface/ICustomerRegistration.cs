using CommonClass;
namespace TamarindAstraMasters.Interface
{
    public interface ICustomerRegistration
    {
        Task SendCustomerRegistrationMail(RequestModel request);
        Task<ResponseModel> GetCustomerRegistrationMailDetail(RequestModel request);
        Task SubmitCustomerRegistrationForm(RequestModel request);
    }
}
