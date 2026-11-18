using Newtonsoft.Json.Linq;
using TamarindAstra.Model.DBModel;

namespace BusinessLogic.Interface
{
    public interface ICryptoService
    {
        string EncryptString(MasterReq _masterReq);
        Task<JObject> DecryptString(MasterReq _masterReq);
    }
}
