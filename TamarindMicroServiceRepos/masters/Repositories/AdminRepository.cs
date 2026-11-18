using DataAccess.Model.DBModel;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using NLog;
using System.Data.SqlClient;
using Dapper;
using BusinessLogic.Interface;
using Microsoft.Extensions.Logging;
using Azure;
using TamarindAstra.Model.DBModel;
using TamarindAstra.Common;
using CommonClass;

namespace BusinessLogic.Repositories
{
    public class AdminRepository:IAdmin
    {
        private readonly string _base64Key;
        private readonly IConfiguration _config;
        private static readonly Logger logger = LogManager.GetCurrentClassLogger(); // NLog Logger
        private readonly string isEncrypted;

        public AdminRepository(IConfiguration config, IOptions<Cryptography> options)
        {
            _base64Key = options.Value.SecretKey;
            _config = config;
            isEncrypted = config["AppConfigs:isEncrypted"];
        }
        #region changeuserpassword starts here
        public async Task<ResponseModel> ChangeUserPassword(RequestModel request)
        {
            ResponseModel responseModel = new ResponseModel();
            string jsonString = string.Empty;
            var data = new CommonClass.ResponseViewModel<ChangeUserPassword>();
            ChangeUserPassword req = null;
            try
            {
                JObject obj = Cryptography.DecryptionData(request.RequestText, _base64Key, isEncrypted);

                if (obj != null && obj.Count > 0)
                {
                    req = JsonConvert.DeserializeObject<ChangeUserPassword>(obj.ToString());
                }
                if (req != null)
                {
                    // Database operation
                    string connectionString = _config.GetConnectionString("DefaultConnection");
                    if (string.IsNullOrEmpty(connectionString))
                        throw new Exception("Connection string not found.");

                    string con = _config.GetConnectionString("DefaultConnection");
                    if (con == null) throw new Exception("Connection string not found.");

                    using (var connection = new SqlConnection(con))
                    {
                        await connection.OpenAsync();

                        var result = connection.QueryMultiple(
                            "usp_ChangeUser_Password",
                            new
                            {
                                @UserName = req.UserName,
                                @IsActive = req.IsActive,
                                @OldPassword = req.OldPassword,
                                @NewPassword = req.NewPassword,
                                
                            },
                            commandType: CommandType.StoredProcedure
                        );

                        if (result != null)
                        {
                            var token = JwtHelper.GenerateJwtToken(req.UserName, _config);
                            if (req.UserName.ToLower() == "s")
                            {
                                var dataList = result.Read<ChangeUserPassword>().ToList();
                                data.dataList = dataList;
                                data.data = data.data;
                                data.token = token;
                            }
                            else
                            {
                                data.dataList = null;
                                data.token = token;
                            }
                            var returnInfo = result.Read().FirstOrDefault();
                            if (returnInfo != null)
                            {
                                data.returnCode = returnInfo.returnCode?.ToString();
                                data.returnMessage = returnInfo.returnMessage;
                            }
                        }
                        else
                        {
                            data.returnMessage = "No data found.";
                            data.returnCode = "201";
                        }
                    }
                }

                jsonString = JsonConvert.SerializeObject(data);

                // Encrypt the response if needed
                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(jsonString, _base64Key);
                    return responseModel;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Error in ChangeUserPasswordMaster");

                // Return a generic error response
                var errorResponse = new
                {
                    returnCode = "500",
                    returnMsg = $"Something went wrong! Error: {ex.Message}",
                    token = (string)null,
                    Data = new List<string>()
                };

                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(JsonConvert.SerializeObject(errorResponse), _base64Key);
                    return responseModel;
                }

                responseModel.responseText = JsonConvert.SerializeObject(errorResponse);
                return responseModel;
            }
            return responseModel;

        }
        #endregion changeuserpassword ends here

        public async Task<ResponseModel> Roles(RequestModel request)
        {
            ResponseModel responseModel = new ResponseModel();
            string jsonString = string.Empty;
            var data = new CommonClass.ResponseViewModel<Roles>();
            Roles req = null;
            try
            {
                JObject obj = Cryptography.DecryptionData(request.RequestText, _base64Key, isEncrypted);

                if (obj != null && obj.Count > 0)
                {
                    req = JsonConvert.DeserializeObject<Roles>(obj.ToString());
                }
                if (req != null)
                {
                    // Database operation
                    string connectionString = _config.GetConnectionString("DefaultConnection");
                    if (string.IsNullOrEmpty(connectionString))
                        throw new Exception("Connection string not found.");

                    string con = _config.GetConnectionString("DefaultConnection");
                    if (con == null) throw new Exception("Connection string not found.");

                    using (var connection = new SqlConnection(con))
                    {
                        await connection.OpenAsync();

                        var result = connection.QueryMultiple(
                            "usp_MergeAspnet_Roles",
                            new
                            {
                                @RoleId = req.RoleId,
                                @ApplicationName = req.ApplicationName,
                                @RoleName = req.RoleName,
                                @Action = req.Action,
                            },
                            commandType: CommandType.StoredProcedure
                        );

                        if (result != null)
                        {
                            var token = JwtHelper.GenerateJwtToken(req.Action, _config);
                            if (req.Action.ToLower() == "s")
                            {
                                var dataList = result.Read<Roles>().ToList();
                                data.dataList = dataList;
                                data.data = data.data;
                                data.token = token;
                            }
                            else
                            {
                                data.dataList = null;
                                data.token = token;
                            }
                            var returnInfo = result.Read().FirstOrDefault();
                            if (returnInfo != null)
                            {
                                data.returnCode = returnInfo.returnCode?.ToString();
                                data.returnMessage = returnInfo.returnMessage;
                            }
                        }
                        else
                        {
                            data.returnMessage = "No data found.";
                            data.returnCode = "201";
                        }
                    }
                }

                jsonString = JsonConvert.SerializeObject(data);

                // Encrypt the response if needed
                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(jsonString, _base64Key);
                    return responseModel;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Error in RoleMaster");

                // Return a generic error response
                var errorResponse = new
                {
                    returnCode = "500",
                    returnMsg = $"Something went wrong! Error: {ex.Message}",
                    token = (string)null,
                    Data = new List<string>()
                };

                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(JsonConvert.SerializeObject(errorResponse), _base64Key);
                    return responseModel;
                }

                responseModel.responseText = JsonConvert.SerializeObject(errorResponse);
                return responseModel;
            }
            return responseModel;

        }

        #region RolesPermissions STARTS HERE

        public async Task<ResponseModel> RolesPermissions(RequestModel request)
        {
            ResponseModel responseModel = new ResponseModel();
            string jsonString = string.Empty;
            var data = new CommonClass.ResponseViewModel<RolesPermissions>();
            RolesPermissions req = null;
            try
            {
                JObject obj = Cryptography.DecryptionData(request.RequestText, _base64Key, isEncrypted);

                if (obj != null && obj.Count > 0)
                {
                    req = JsonConvert.DeserializeObject<RolesPermissions>(obj.ToString());
                }
                if (req != null)
                {
                    // Database operation
                    string connectionString = _config.GetConnectionString("DefaultConnection");
                    if (string.IsNullOrEmpty(connectionString))
                        throw new Exception("Connection string not found.");

                    string con = _config.GetConnectionString("DefaultConnection");
                    if (con == null) throw new Exception("Connection string not found.");

                    using (var connection = new SqlConnection(con))
                    {
                        await connection.OpenAsync();

                        var result = connection.QueryMultiple(
                        "usp_InsertRoles_Permissions",
                        new
                        {
                            @RoleId = req.RoleID,
                            @ModuleID = req.ModuleID,
                            @Permissions = req.Permissions,
                            @Action = req.Action,
                        },
                        commandType: CommandType.StoredProcedure
                    );

                        if (result != null)
                        {
                            var token = JwtHelper.GenerateJwtToken(req.Action, _config);
                            if (req.Action.ToLower() == "s")
                            {
                                var dataList = result.Read<RolesPermissions>().ToList();
                                data.dataList = dataList;
                                data.data = data.data;
                                data.token = token;
                            }
                            else
                            {
                                data.dataList = null;
                                data.token = token;
                            }
                            var returnInfo = result.Read().FirstOrDefault();
                            if (returnInfo != null)
                            {
                                data.returnCode = returnInfo.returnCode?.ToString();
                                data.returnMessage = returnInfo.returnMessage;
                            }
                        }
                        else
                        {
                            data.returnMessage = "No data found.";
                            data.returnCode = "201";
                        }
                    }
                }

                jsonString = JsonConvert.SerializeObject(data);

                // Encrypt the response if needed
                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(jsonString, _base64Key);
                    return responseModel;
                }
            }
            catch (Exception ex)
            {

                // Return a generic error response
                var errorResponse = new
                {
                    returnCode = "500",
                    returnMsg = $"Something went wrong! Error: {ex.Message}",
                    token = (string)null,
                    Data = new List<string>()
                };

                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(JsonConvert.SerializeObject(errorResponse), _base64Key);
                    return responseModel;
                }

                responseModel.responseText = JsonConvert.SerializeObject(errorResponse);
                return responseModel;
            }
            return responseModel;

        }

        #endregion ROLEPERMISSION ENDS HERE

        #region emailconfiguration starts here
        public async Task<ResponseModel> EmailConfigurations(RequestModel request)
        {
            ResponseModel responseModel = new ResponseModel();
            string jsonString = string.Empty;
            var data = new CommonClass.ResponseViewModel<EmailConfigurations>();
            EmailConfigurations req = null;
            try
            {
                JObject obj = Cryptography.DecryptionData(request.RequestText, _base64Key, isEncrypted);

                if (obj != null && obj.Count > 0)
                {
                    req = JsonConvert.DeserializeObject<EmailConfigurations>(obj.ToString());
                }
                if (req != null)
                {
                    // Database operation
                    string connectionString = _config.GetConnectionString("DefaultConnection");
                    if (string.IsNullOrEmpty(connectionString))
                        throw new Exception("Connection string not found.");

                    string con = _config.GetConnectionString("DefaultConnection");
                    if (con == null) throw new Exception("Connection string not found.");

                    using (var connection = new SqlConnection(con))
                    {
                        await connection.OpenAsync();


                        var result = connection.QueryMultiple(
                            "USP_InsertEmailConfiguration",
                            new
                            {
                                @EmailCategory = req.EmailCategory,
                                @FromEmailAddress = req.FromEmailAddress,
                                @ToEmailAddress = req.ToEmailAddress,
                                @Subject = req.Subject,
                                @EmailBody = req.EmailBody,
                                @OperationBy = req.OperationBy,
                                @Action = req.Action

                            },
                            commandType: CommandType.StoredProcedure
                        );

                        if (result != null)
                        {
                            var token = JwtHelper.GenerateJwtToken(req.Action, _config);
                            if (req.Action.ToLower() == "s")
                            {
                                var dataList = result.Read<EmailConfigurations>().ToList();
                                data.dataList = dataList;
                                data.data = data.data;
                                data.token = token;
                            }
                            else
                            {
                                data.dataList = null;
                                data.token = token;
                            }
                            var returnInfo = result.Read().FirstOrDefault();
                            if (returnInfo != null)
                            {
                                data.returnCode = returnInfo.returnCode?.ToString();
                                data.returnMessage = returnInfo.returnMessage;
                            }
                        }
                        else
                        {
                            data.returnMessage = "No data found.";
                            data.returnCode = "201";
                        }
                    }
                }
                jsonString = JsonConvert.SerializeObject(data);

                // Encrypt the response if needed
                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(jsonString, _base64Key);
                    return responseModel;
                }
            }
            catch (Exception ex)
            {

                // Return a generic error response
                var errorResponse = new
                {
                    returnCode = "500",
                    returnMsg = $"Something went wrong! Error: {ex.Message}",
                    token = (string)null,
                    Data = new List<string>()
                };

                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(JsonConvert.SerializeObject(errorResponse), _base64Key);
                    return responseModel;
                }

                responseModel.responseText = JsonConvert.SerializeObject(errorResponse);
                return responseModel;
            }
            return responseModel;

        }
        #endregion emailconfiguration ends here


        #region ConfigSettings starts here
        public async Task<ResponseModel> ConfigSettings(RequestModel request)
        {
            ResponseModel responseModel = new ResponseModel();
            string jsonString = string.Empty;
            var data = new CommonClass.ResponseViewModel<ConfigSettings>();
            ConfigSettings req = null;
            try
            {
                JObject obj = Cryptography.DecryptionData(request.RequestText, _base64Key, isEncrypted);

                if (obj != null && obj.Count > 0)
                {
                    req = JsonConvert.DeserializeObject<ConfigSettings>(obj.ToString());
                }
                if (req != null)
                {
                    // Database operation
                    string connectionString = _config.GetConnectionString("DefaultConnection");
                    if (string.IsNullOrEmpty(connectionString))
                        throw new Exception("Connection string not found.");

                    string con = _config.GetConnectionString("DefaultConnection");
                    if (con == null) throw new Exception("Connection string not found.");

                    using (var connection = new SqlConnection(con))
                    {
                        await connection.OpenAsync();

                        var result = connection.QueryMultiple(
                            "usp_ConfigSettingsMaster",
                            new
                            {
                                @Action = req.Action,
                                @ConfigSettingID = req.ConfigSettingID,
                                @ConfigKey = req.ConfigKey,
                               @ConfigValue = req.ConfigValue,
                                @OperationBy = req.OperationBy
                            },
                            commandType: CommandType.StoredProcedure
                        );

                        if (result != null)
                        {
                            var token = JwtHelper.GenerateJwtToken(req.Action, _config);
                            if (req.Action.ToLower() == "s")
                            {
                                var dataList = result.Read<ConfigSettings>().ToList();
                                data.dataList = dataList;
                                data.data = data.data;
                                data.token = token;
                            }
                            else
                            {
                                data.dataList = null;
                                data.token = token;
                            }
                            var returnInfo = result.Read().FirstOrDefault();
                            if (returnInfo != null)
                            {
                                data.returnCode = returnInfo.returnCode?.ToString();
                                data.returnMessage = returnInfo.returnMessage;
                            }
                        }
                        else
                        {
                            data.returnMessage = "No data found.";
                            data.returnCode = "201";
                        }
                    }
                }

                jsonString = JsonConvert.SerializeObject(data);

                // Encrypt the response if needed
                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(jsonString, _base64Key);
                    return responseModel;
                }
            }
            catch (Exception ex)
            {

                // Return a generic error response
                var errorResponse = new
                {
                    returnCode = "500",
                    returnMsg = $"Something went wrong! Error: {ex.Message}",
                    token = (string)null,
                    Data = new List<string>()
                };

                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(JsonConvert.SerializeObject(errorResponse), _base64Key);
                    return responseModel;
                }

                responseModel.responseText = JsonConvert.SerializeObject(errorResponse);
                return responseModel;
            }
            return responseModel;

        }
        #endregion ConfigSettings ends here

        #region unlockuser starts here
        public async Task<ResponseModel> Unlockuser(RequestModel request)
        {
            ResponseModel responseModel = new ResponseModel();
            string jsonString = string.Empty;
            var data = new CommonClass.ResponseViewModel<Unlockuser>();
            Unlockuser req = null;
            try
            {
                JObject obj = Cryptography.DecryptionData(request.RequestText, _base64Key, isEncrypted);

                if (obj != null && obj.Count > 0)
                {
                    req = JsonConvert.DeserializeObject<Unlockuser>(obj.ToString());
                }
                if (req != null)
                {
                    string connectionString = _config.GetConnectionString("DefaultConnection");
                    if (string.IsNullOrEmpty(connectionString))
                        throw new Exception("Connection string not found.");

                    string con = _config.GetConnectionString("DefaultConnection");
                    if (con == null) throw new Exception("Connection string not found.");

                    var result = await SqlHelper.LoadData<CommonClass.ResponseViewModel<Unlockuser>, dynamic>("USP_UnlockUser", new
                    {
                        @UserId = req.UserId,
                        @UserName = req.UserName,
                    });

                    if (result != null)
                    {
                        //if (req.UserName.ToLower() == "s")
                        if (req.UserId != null || req.UserName != "")
                        {
                            var dataList = result.ToList();
                            data.returnCode = dataList[0].returnCode?.ToString();
                            data.returnMessage = dataList[0].returnMessage?.ToString();
                        }
                        else
                        {
                            data.dataList = null;
                        }
                    }
                    else
                    {
                        data.returnMessage = "No data found.";
                        data.returnCode = "201";
                    }
                }
                jsonString = JsonConvert.SerializeObject(data);

                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(jsonString, _base64Key);
                    return responseModel;
                }
            }
            catch (Exception ex)
            {

                var errorResponse = new
                {
                    returnCode = "500",
                    returnMsg = $"Something went wrong! Error: {ex.Message}",
                    token = (string)null,
                    Data = new List<string>()
                };

                if (isEncrypted == "Y")
                {
                    responseModel.responseText = Cryptography.EncryptStringAES(JsonConvert.SerializeObject(errorResponse), _base64Key);
                    return responseModel;
                }

                responseModel.responseText = JsonConvert.SerializeObject(errorResponse);
                return responseModel;
            }
            return responseModel;
        }
        #endregion unlockusre ends here
    }
}
