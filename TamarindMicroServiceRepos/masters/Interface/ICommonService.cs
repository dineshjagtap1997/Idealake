using CommonClass;

namespace BusinessLogic.Interface
{
    public interface ICommonService
    {
       // Task<string> SendAadharOTP(MasterReq _masterReq);
        Task<ResponseModel> GetMasterForExport(RequestModel request);

    }
}
