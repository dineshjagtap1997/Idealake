using BusinessLogic.Interface;
using CommonClass;
using Dapper;
using DataAccess.Model.DBModel;
using System.Data;

using TamarindAstra.Common;

namespace BusinessLogic.Repositories
{
    public class AdminRepository : IAdmin
    {
       
        
      
      
        #region changeuserpassword starts here
        public async Task<ResponseModel> ChangeUserPassword(RequestModel request)
        {

            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<ChangeUserPassword>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @UserName = req.UserName,
                       
                        //@OldPassword = req.OldPassword,
                        @NewPassword = req.NewPassword,
                    };

                    var data = new CommonClass.ResponseViewModel<ChangeUserPassword>();
                    return CommonFunctions.ProcessDBData(data,"U", "usp_ChangeUser_Password", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");


            }
            catch (Exception ex)
            {


                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }
            
          
        }
        #endregion changeuserpassword ends here

        #region Roles Mater Starts Here
        public async Task<ResponseModel> RolesMaster(RequestModel request)
        {
            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<Roles>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @RoleId = req.RoleId,
                        @RoleName = req.RoleName,
                        @Description = req.Description,
                        @IsActive = req.IsActive,
                        @CreatedBy = req.CreatedBy,
                        @UpdatedBy = req.UpdatedBy,
                        @Action = req.Action,
                        @OperationBy = req.OperationBy

                    };

                    var data = new CommonClass.ResponseViewModel<Roles>()
                    {
                        data = req
                    };
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Roles_Master", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");


            }
            catch (Exception ex)
            {


                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }
        }

        #endregion
        #region Get Roles Starts Here
        public async Task<ResponseModel> GetRoles(RequestModel request)
        {
            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<Roles>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        req.RoleId,

                        Action = "S"
                    };

                    var data = new CommonClass.ResponseViewModel<Roles>();
                    return CommonFunctions.ProcessDBData(data, "S", "usp_Roles_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");


            }
            catch (Exception ex)
            {


                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }
        }

        #endregion
        #region Get Modules Starts Here
        public async Task<ResponseModel> GetModules(RequestModel request)
        {
            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<Modules>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        req.ModuleID,

                        Action = "S"
                    };
                    // var (statusresponse, modules) = SqlHelper.LoadDataWithTable<StatusModel, Modules, dynamic>("[usp_Modules_Master]", parameters);

                    //var modules = SqlHelper.LoadData< Modules, dynamic>("[usp_Modules_Master]", parameters);

                    var data = new CommonClass.ResponseViewModel<Modules>();
                    var modules = SqlHelper.LoadData<Modules, dynamic>("usp_Modules_Master", parameters);

                    if (modules != null && modules.Any())
                    {
                        // Initialize a list to hold all modules (you can use this as a final result)
                        var processedModules = new List<Modules>();

                        // Get top-level modules (Level 1 modules with ParentMenuID = null)
                        var topLevelModules = modules.Where(m => m.ParentMenuID == null).ToList();

                        foreach (var module in topLevelModules)
                        {
                            // Initialize SubModules to prevent null reference issues
                            module.SubModules = new List<Modules>();

                            // Find sub-modules under the current module (Level 2 modules)
                            module.SubModules = modules
                                .Where(m => m.ParentMenuID == module.ModuleID && m.Level == 2)
                                .ToList();

                            foreach (var subModule in module.SubModules)
                            {
                                // Initialize Tabs to prevent null reference issues
                                subModule.Tabs = new List<Modules>();

                                // Find tabs under the current sub-module (Level 3 modules)
                                subModule.Tabs = modules
                                    .Where(m => m.ParentMenuID == subModule.ModuleID && m.Level == 3)
                                    .ToList();

                                foreach (var tab in subModule.Tabs)
                                {
                                    // Initialize SubTabs to prevent null reference issues
                                    tab.SubTabs = new List<Modules>();

                                    // Find sub-tabs under the current tab (Level 4 modules)
                                    tab.SubTabs = modules
                                        .Where(m => m.ParentMenuID == tab.ModuleID && m.Level == 4)
                                        .ToList();
                                }
                            }

                            // Add the processed module to the final list
                            processedModules.Add(module);
                        }

                        // Now assign the final processed data to DataList
                        data.dataList = processedModules;
                        data.returnCode = "200";
                        data.returnMessage = "Data Found";

                        // Return the processed result
                        return CommonFunctions.ProcessResult(data);
                    }
                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");

                // Return the processed result

            }
            catch (Exception ex)
            {
                // Log and return a standardized error response

                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }
        }

        #endregion
        #region Module Mater Starts Here
        public async Task<ResponseModel> ModuleMaster(RequestModel request)
        {
            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<Modules>(request.RequestText);

                if (req != null)
                {

                    // Prepare parameters for the stored procedure
                    var parameters = new
                    {
                        req.Action,
                        req.ModuleID,
                        req.ModuleName,
                        req.DisplayOrder,
                        req.ParentMenuID,
                        req.Level,
                        req.Type,
                        req.CreatedBy,
                        req.UpdatedBy,
                        req.IsActive,
                        req.Link,
                        req.visibleSection
                    };


                    var data = new CommonClass.ResponseViewModel<Modules>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_Modules_Master", parameters);


                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");



            }
            catch (Exception ex)
            {
                // Log and return a standardized error response

                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }
        }

        #endregion
        #region Get Modules Starts Here
        public async Task<ResponseModel> GetRightsByRole(RequestModel request)
        {
            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<RolePermission>(request.RequestText);

                if (req != null)
                {



                    var parameters = new
                    {
                        req.RoleId,

                        Action = "S"
                    };
                    //var (statusresponse, rights) = SqlHelper.LoadDataWithTable<StatusModel, dynamic, dynamic>("[usp_RolePermissions_Master]", parameters);
                    var data = new CommonClass.ResponseViewModel<dynamic>();
                    return CommonFunctions.ProcessDBData(data, "S", "usp_RolePermissions_Master", parameters);


                }

                return CommonFunctions.BlankResponse("201", "Something went wrong.");

                // Return the processed result

            }
            catch (Exception ex)
            {
                // Log and return a standardized error response

                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }
        }

        #endregion
        #region Roles Mater Starts Here
        public async Task<ResponseModel> RoleRightsMaster(RequestModel request)
        {
            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<RequestBatchModel>(request.RequestText);

                if (req != null)
                {
                    // Prepare parameters for the stored procedure
                    var dataTable = new DataTable();

                    // Add columns to the DataTable
                    dataTable.Columns.Add("RolePermissionID", typeof(int));
                    dataTable.Columns.Add("RoleId", typeof(int));
                    dataTable.Columns.Add("ModuleId", typeof(int));
                    dataTable.Columns.Add("CanView", typeof(bool));
                    dataTable.Columns.Add("CanEdit", typeof(bool));
                    dataTable.Columns.Add("CanAdd", typeof(bool));
                    dataTable.Columns.Add("CanExport", typeof(bool));
                    dataTable.Columns.Add("CanDelete", typeof(bool));
                    dataTable.Columns.Add("CanPrint", typeof(bool));
                    dataTable.Columns.Add("CanUndoXO", typeof(bool));
                    dataTable.Columns.Add("CanReassignTo", typeof(bool));
                    dataTable.Columns.Add("CanViewAllFiles", typeof(bool));
                    dataTable.Columns.Add("CanViewAllFilesReadOnly", typeof(bool));
                    dataTable.Columns.Add("IsActive", typeof(bool));

                    // Add rows to the DataTable
                    req.RolePermissions.ForEach(rp =>
                    {
                        dataTable.Rows.Add(
                            rp.RolePermissionID,rp.RoleId, rp.ModuleID, rp.CanView, rp.CanEdit, rp.CanAdd, rp.CanExport,
                            rp.CanDelete, rp.CanPrint, rp.CanUndoXO, rp.CanReassignTo, rp.CanViewAllFiles,
                            rp.CanViewAllFilesReadOnly,rp.IsActive
                        );
                    });


                        var parameters = new
                    {
                        RoleId = dataTable.Rows[0]["RoleId"]


                        //Action = req.Action,
                    };

                    var dynamicParams = new Dapper.DynamicParameters();

                    

                    // var result = SqlHelper.LoadData<StatusModel, dynamic>("[usp_RolePermissions_Master]", parameters).FirstOrDefault();


                    var data = new CommonClass.ResponseViewModel<RolePermission>();
                    if (req.Action.ToLower() == "s")
                    {
                        return CommonFunctions.ProcessDBData(data, req.Action, "usp_RolePermissions_Select", parameters);
                    }
                    else
                    {
                        // Map your parameters to DynamicParameters
                        dynamicParams.Add("RolePermissions", dataTable.AsTableValuedParameter("dbo.RolePermissionsType"));
                        dynamicParams.Add("IsActive", req.IsActive);
                        dynamicParams.Add("CreatedBy", req.CreatedBy);
                        dynamicParams.Add("Action", req.Action);

                        var result = await CommonFunctions.BulkInsertUsingDataTableAsync(data, "usp_RolePermissions_InsertUpdate", dynamicParams);
                        return CommonFunctions.ProcessResult(data);
                    }

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");



            }
            catch (Exception ex)
            {


                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }
        }
        #endregion

        #region emailconfiguration starts here
        public async Task<ResponseModel> EmailConfigurations(RequestModel request)
        {
            string baseUrl = SharedConfiguration.GetUploadsBaseUrl();
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<EmailConfigurations>(request.RequestText);

                if (req != null)
                {
                    string fileUrl = null;
                    if (!string.IsNullOrEmpty(req.Documents) && !string.IsNullOrEmpty(req.DocumentName))
                    {
                        string rootFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads", "Documents");
                        string masterTypeName = CommonFunctions.GetMasterTypeName(req.ParentTypeID);
                        string masterFolder = Path.Combine(rootFolder, masterTypeName);

                        if (!Directory.Exists(masterFolder))
                        {
                            Directory.CreateDirectory(masterFolder);
                        }

                        var uniqueFileName = $"{Guid.NewGuid()}_{req.DocumentName}";
                        string filePath = Path.Combine(masterFolder, uniqueFileName);

                        byte[] fileBytes = Convert.FromBase64String(req.Documents);
                        await File.WriteAllBytesAsync(filePath, fileBytes);

                        fileUrl = $"{baseUrl}/Documents/{masterTypeName}/{uniqueFileName}";
                    }

                    var parameters = new
                    {
                        @EmailTemplateId = req.EmailTemplateId,
                        @EmailCategory = req.EmailCategory,
                        @FromEmailAddress = req.FromEmailAddress,
                        @ToEmailAddress = req.ToEmailAddress,
                        @CCEmailAddress = req.CCEmailAddress,
                        @Subject = req.Subject,
                        @EmailBody = req.EmailBody,
                        @OperationBy = req.OperationBy,
                        @Action = req.Action,
                        @DocumentID = req.DocumentID,
                        @Documents = fileUrl, // Pass the file path URL
                        @DocumentName = req.DocumentName,
                        @DocMimeType = req.DocMimeType,
                        @UploadedBy = req.OperationBy,
                        @ParentTypeID = req.ParentTypeID,
                        @DocumentTypeId = req.DocumentTypeId
                    };

                    var data = new CommonClass.ResponseViewModel<EmailConfigurations>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "USP_UpdateEmailConfiguration", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }
        }
        #endregion emailconfiguration ends here


        //#region emailconfiguration starts here
        //public async Task<ResponseModel> EmailConfigurations(RequestModel request)
        //{

        //    try
        //    {

        //        var req = CommonFunctions.DecryptAndDeserializeRequest<EmailConfigurations>(request.RequestText);

        //        if (req != null)
        //        {


        //            var parameters = new
        //            {
        //                @EmailTemplateId = req.EmailTemplateId,
        //                @EmailCategory = req.EmailCategory,
        //                @FromEmailAddress = req.FromEmailAddress,
        //                @ToEmailAddress = req.ToEmailAddress,
        //                @Subject = req.Subject,
        //                @EmailBody = req.EmailBody,
        //                @OperationBy = req.OperationBy,
        //                @Action = req.Action,
        //                @DocumentID = req.DocumentID

        //            };

        //            var data = new CommonClass.ResponseViewModel<EmailConfigurations>();
        //            return CommonFunctions.ProcessDBData(data, req.Action, "USP_UpdateEmailConfiguration" 
        //                , parameters);

        //        }
        //        return CommonFunctions.BlankResponse("201", "Something went wrong.");


        //    }
        //    catch (Exception ex)
        //    {


        //        return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
        //    }


        //}

        //#endregion emailconfiguration ends here

        #region ConfigSettings starts here
        public async Task<ResponseModel> ConfigSettings(RequestModel request)
        {

            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<ConfigSettings>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @Action = req.Action,
                        @ConfigSettingID = req.ConfigSettingID,
                        @ConfigKey = req.ConfigKey,
                        @ConfigValue = req.ConfigValue,
                        @OperationBy = req.OperationBy
                    };

                    var data = new CommonClass.ResponseViewModel<ConfigSettings>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_ConfigSettingsMaster", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");


            }
            catch (Exception ex)
            {


                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }
           

        }
        #endregion ConfigSettings ends here

        #region unlockuser starts here
        public async Task<ResponseModel> Unlockuser(RequestModel request)
        {

            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<Unlockuser>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @EmpID = req.EmpID,
                        @UserName = req.UserName,
                        @OperatedBy =req.OperatedBy,
                        @Action = req.Action
                    };

                    var data = new CommonClass.ResponseViewModel<Unlockuser>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "USP_UnlockUser", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");


            }
            catch (Exception ex)
            {


                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }


          

        }
        #endregion unlockusre ends here

        #region IRN Upload Excel
       
     

        public async Task<ResponseModel> IRNUpload(IFormFile file, RequestModel request)
        {
            string uniqueFileName = string.Empty;

            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<InvoiceData>(request.RequestText);

                if (file != null && file.Length > 0 && req != null)
                {
                    // Convert Excel to DataTable
                    var dataTable = CommonFunctions.ConvertExcelToDataTable(file);

                    // Add metadata (common for all APIs)
                    CommonFunctions.AddMetadataColumns(dataTable, req.CreatedBy);

                    var parameters = new DynamicParameters();
                    parameters.Add("@InvoiceData", dataTable.AsTableValuedParameter("IRNDataType"));

                    var data = new CommonClass.ResponseViewModel<StatusModel>();

                    // Call bulk insert and save file after successful operation
                    var result = await CommonFunctions.BulkInsertUsingDataTableAsync(data, "InsertInvoiceDataBatch", parameters);

                    if (data.returnCode == "200") // Assuming success is indicated by code 200
                    {
                        // Generate a unique file name
                        uniqueFileName = $"{Path.GetFileNameWithoutExtension(file.FileName)}_{DateTime.Now:yyyyMMdd_HHmmss}{Path.GetExtension(file.FileName)}";

                        // Create the full file path
                        var filePath = Path.Combine(CommonFunctions.CreateSubFolder("Invoice"), uniqueFileName);

                        // Save the file to disk
                        using (var fileStream = new FileStream(filePath, FileMode.Create))
                        {
                            await file.CopyToAsync(fileStream);
                        }

                        // Return success response
                        return CommonFunctions.ProcessResult(data);
                    }
                    else
                    {
                        return CommonFunctions.BlankResponse(data.returnCode, data.returnMessage);
                    }
                }
                return CommonFunctions.BlankResponse("400", "Invalid file or request.");
            }
            catch (Exception ex)
            {
                // Log error and return error response
                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }
        }
        #endregion


        #region SAPJobsInsertUpdate starts here
        public async Task<ResponseModel>SAPJobsInsertUpdate(RequestModel request)
        {

            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<SAPJobsInsertUpdate>(request.RequestText);

                if (req != null)
                {


                    var parameters = new
                    {
                        @JobName = req.JobName,
                        @Taskflag = req.Taskflag,
                        @DataToSplit = req.DataToSplit,
                        @CreatedBy = req.CreatedBy
                    };

                    var data = new CommonClass.ResponseViewModel<SAPJobsInsertUpdate>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData(data, req.Taskflag, "usp_InsertUpdateSAPJobsTime", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");


            }
            catch (Exception ex)
            {

                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }


        }
        #endregion ConfigSettings ends here

        #region Get SAP_ViewLogs Starts Here
        public async Task<ResponseModel> GetSAPInsertUpdateLogs(RequestModel request)
        {
            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<SAPJobsInsertUpdate>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @JobName = req.JobName,
                        @Taskflag = req.Taskflag,
                        @DataNumber = req.DataNumber
                    };

                    var data = new CommonClass.ResponseViewModel<SAPJobsInsertUpdate>
                    {
                        data = req
                    };

                    return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_GetLogDetailsSAPJobApplication", parameters);


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
