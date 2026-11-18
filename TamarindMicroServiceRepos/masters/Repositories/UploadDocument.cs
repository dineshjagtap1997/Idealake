using BusinessLogic.Interface;
using CommonClass;
using Dapper;
using DataAccess.Model.DBModel;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using NLog;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;
using TamarindAstra.Common;

using Azure;
using NPOI.POIFS.Properties;
using NPOI.POIFS.FileSystem;
using TamarindAstraMasters.Interface;

namespace TamarindAstraMasters.Repositories
{
    public class UploadDocument : IUploadDocument
    {
        private readonly string _base64Key;
        private readonly IConfiguration _config;
        private static readonly Logger logger = LogManager.GetCurrentClassLogger(); // NLog Logger
        private readonly string isEncrypted;



        public UploadDocument(IConfiguration config, IOptions<Cryptography> options)
        {
            _base64Key = options.Value.SecretKey;
            _config = config;
            isEncrypted = config["AppConfigs:isEncrypted"];

        }
        #region UploadDocument starts here
        public async Task<ResponseModel> UploadDocuments(RequestModel request)
        {

            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<UploadDocuments>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @Action = req.Action,
                        @ParentID = req.ParentID,
                        @ParentTypeID = req.ParentTypeID,
                        @DocumentID = req.DocumentID,
                        @DocumentName = req.DocumentName,
                        @DocMimeType = req.DocMimeType,
                        @Documents = req.Documents,
                        @UploadedBy = req.UploadedBy
                    };

                    var data = new CommonClass.ResponseViewModel<UploadDocument>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_UploadDocument", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");


            }
            catch (Exception ex)
            {


                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }


        }
        #endregion
    }
}
