using CommonClass;

namespace BusinessLogic.Interface
{
    public interface IAuditLogService
    {
        Task<ResponseModel> FetchAuditLogs(RequestModel request);
    }
}
