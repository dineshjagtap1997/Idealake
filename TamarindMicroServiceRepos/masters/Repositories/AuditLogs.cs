using BusinessLogic.Interface;
using Microsoft.Extensions.Options;
using MongoDB.Repositories;
using TamarindAstra.Common;

namespace CommonClass.Repositories
{
    public class AuditLogs : IAuditLogService
    {
        private readonly string _base64Key;
        private readonly IConfiguration _config;
        private readonly string isEncrypted;
        public string CollectionName = "";
        private static MongoHelper _mongoHelper;

        public AuditLogs(IOptions<Cryptography> options, IConfiguration config)
        {
            _base64Key = options.Value.SecretKey;
            _config = config;
            isEncrypted = config["AppConfigs:isEncrypted"];
        }

        public async Task<ResponseModel> FetchAuditLogs(RequestModel request)
        {
            CommonClass.ResponseViewModel<dynamic> data = new CommonClass.ResponseViewModel<dynamic>();
            CollectionName = request.MasterFlag;
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<dynamic>(request.RequestText);
                if (req != null)
                {
                    data = new CommonClass.ResponseViewModel<dynamic>();
                    data.collectionName = CollectionName;
                    return CommonFunctions.ViewLogs(data, req);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
               
                // CommonFunctions.ApiExceptionLogs(CollectionName, request.RequestText, Cryptography.EncryptStringAES(Newtonsoft.Json.JsonConvert.SerializeObject(data), _base64Key), ex.ToString(), ExceptionLogsApiName);
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
    }
}
