
using CommonClass;

namespace BusinessLogic.Interface
{
    public interface IAdmin
    {
        Task<ResponseModel> ChangeUserPassword(RequestModel request);

        Task<ResponseModel> RolesMaster(RequestModel request);
        Task<ResponseModel> GetRoles(RequestModel request); 

        Task<ResponseModel> GetModules(RequestModel request);
        Task<ResponseModel> ModuleMaster(RequestModel request);
        Task<ResponseModel> RoleRightsMaster(RequestModel request);
        Task<ResponseModel> GetRightsByRole(RequestModel request);

       Task<ResponseModel> EmailConfigurations(RequestModel request);

       Task<ResponseModel> ConfigSettings(RequestModel request);

        Task<ResponseModel> Unlockuser(RequestModel request);
        Task<ResponseModel> IRNUpload(IFormFile file, RequestModel request);

        //  Task<String>ScheduledJobRun(RequestModel request);

        Task<ResponseModel> SAPJobsInsertUpdate(RequestModel request);
        Task<ResponseModel> GetSAPInsertUpdateLogs(RequestModel request);
        
    }
}
