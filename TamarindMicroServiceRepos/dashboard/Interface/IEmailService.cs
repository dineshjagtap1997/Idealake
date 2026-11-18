using CommonClass;

namespace TamarindAstraLoginDashboardReport.Interface
{
    public interface IEmailService
    {
        Task<ResponseModel> SendEmail(RequestModel request);
    }
}
