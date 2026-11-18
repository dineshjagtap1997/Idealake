using CommonClass;
using TamarindAstra.Common;
using TamarindAstraMasters.Interface;

namespace TamarindAstraMasters.Repositories
{
    public class UploadDocumentRepository : IUploadDocument
    {
       
        #region UploadDocument starts here
        public async Task<ResponseModel> UploadDocuments(RequestModel request)
        {
            string baseUrl = SharedConfiguration.GetUploadsBaseUrl();

            try
            {

                var req = CommonFunctions.DecryptAndDeserializeRequest<UploadDocuments>(request.RequestText);

                if (req != null)
                {

                   
                    string rootFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads", "Documents");

                   

                    // Determine master type name based on ParentTypeID
                    string masterTypeName = CommonFunctions.GetMasterTypeName(req.ParentTypeID);

                    // Create subfolder inside root folder
                    string masterFolder = Path.Combine(rootFolder, masterTypeName);
                   // string parentFolder = Path.Combine(masterFolder, req.ParentID.ToString());

                    // Ensure directory exists
                    if (!Directory.Exists(masterFolder))
                    {
                        Directory.CreateDirectory(masterFolder);
                    }

                    // Generate unique file name
                    
                    var uniqueFileName = $"{Guid.NewGuid()}_{req.DocumentName}";
                   
                    string filePath = Path.Combine(masterFolder, uniqueFileName);

                    // Convert Base64 string to byte array and save file
                    byte[] fileBytes = Convert.FromBase64String(req.Documents);
                    await File.WriteAllBytesAsync(filePath, fileBytes);

                    // Generate URL for the stored file
                    
                    string fileUrl = $"{baseUrl}/Documents/{masterTypeName}/{uniqueFileName}";


                    var parameters = new
                    {
                        @Action = req.Action,
                        @ParentID = req.ParentID,
                        @ParentTypeID = req.ParentTypeID,
                        @DocumentID = req.DocumentID,
                        @DocumentName = req.DocumentName,
                        @DocMimeType = req.DocMimeType,
                        @Documents = fileUrl,
                        @UploadedBy = req.UploadedBy,
                        @DocumentTypeId = req.DocumentTypeId,
                        @OperationBy = req.OperationBy
                    };

                    var data = new CommonClass.ResponseViewModel<UploadDocuments>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_UploadDocument", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");


            }
            catch (Exception ex)
            {


                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }


        }
        public async Task<ResponseModel> UploadFile(UploadDocumentsFormFileEncrypted request)
        {
            string baseUrl = SharedConfiguration.GetUploadsBaseUrl();

            try
            {
                if (request?.Documents == null || string.IsNullOrEmpty(request.EncryptedData))
                    return CommonFunctions.BlankResponse("400", "File or EncryptedData is missing.");

                var req = CommonFunctions.DecryptAndDeserializeRequest<UploadDocuments>(request.EncryptedData);
                //var req = JsonConvert.DeserializeObject<UploadDocumentFields>(decryptedJson);

                if (req == null)
                    return CommonFunctions.BlankResponse("400", "Invalid encrypted data.");

             
                string rootFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads", "Documents");
                string masterTypeName = CommonFunctions.GetMasterTypeName(req.ParentTypeID);
                string masterFolder = Path.Combine(rootFolder, masterTypeName);
                if (!Directory.Exists(masterFolder))
                    Directory.CreateDirectory(masterFolder);

                
                string uniqueFileName = $"{Guid.NewGuid()}_{req.DocumentName}";
                string filePath = Path.Combine(masterFolder, uniqueFileName);

                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await request.Documents.CopyToAsync(stream);
                }

                string fileUrl = $"{baseUrl}/Documents/{masterTypeName}/{uniqueFileName}";

                
                var parameters = new
                {
                    req.Action,
                    req.ParentID,
                    req.ParentTypeID,
                    req.DocumentID,
                    req.DocumentName,
                    req.DocMimeType,
                    Documents = fileUrl,
                    req.UploadedBy,
                    req.DocumentTypeId,
                    req.OperationBy
                };

                var data = new CommonClass.ResponseViewModel<UploadDocuments>();
                return CommonFunctions.ProcessDBData(data, req.Action, "usp_UploadDocument", parameters);
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }
        }

        #endregion

        #region linkdocument 
        public async Task<ResponseModel> LinkOtherDocument(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<UploadDocuments>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @ParentID = req.ParentID,
                        @ParentTypeID = req.ParentTypeID,
                        @DocumentIDs = req.DocumentIDs,
                    };

                    var data = new CommonClass.ResponseViewModel<UploadDocuments>();
                    return CommonFunctions.ProcessDBData(data, "", "usp_InsertUpdateLinkedDocuments", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion linkdocument ends here
        #region DelinkDocuments 
        public async Task<ResponseModel> DelinkDocuments(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<UploadDocuments>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @DocumentLinkID = req.DocumentLinkID
                        
                    };

                    var data = new CommonClass.ResponseViewModel<UploadDocuments>();
                    return CommonFunctions.ProcessDBData(data,"", "usp_DeleteLinkedDocuments", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Something went wrong!");
            }
        }
        #endregion

        #region LinkedDocuments 
        public async Task<ResponseModel> LinkedDocuments(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<UploadDocuments>(request.RequestText);

                if (req != null)
                {

                    var parameters = new
                    {
                        @ParentID = req.ParentID,
                        @ParentTypeID = req.ParentTypeID,
                        @Action = req.Action,
                        @DocumentLinkID = req.DocumentLinkID
                    };

                    var data = new CommonClass.ResponseViewModel<UploadDocuments>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_UploadDocument", parameters);

                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
        #endregion

        #region DocumentType
        public async Task<ResponseModel> DocumentTypeMaster(RequestModel request)
        {
            try
            {
                // Decrypt and deserialize the request
                var req = CommonFunctions.DecryptAndDeserializeRequest<DocumentTypeMaster>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        @DocumentTypeId = req.DocumentTypeId,
                        @DocumentType = req.DocumentType,
                        @IsActive = req.IsActive,
                        @OperationBy = req.OperationBy,
                       
                        @Action = req.Action
                    };

                    return req.Action.ToLower() == "ex"
? CommonFunctions.ProcessDBData(new CommonClass.ResponseViewModel<DocumentTypeMasterExport>(), req.Action, "usp_DocumentType", parameters)
: CommonFunctions.ProcessDBData(new CommonClass.ResponseViewModel<DocumentTypeMaster> { data = req }, req.Action, "usp_DocumentType", parameters);



                    //var data = new CommonClass.ResponseViewModel<DocumentTypeMaster>()

                   
                    //{
                    //    data = req
                    //};
                    //return CommonFunctions.ProcessDBData(data, req.Action, "usp_DocumentType", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Operation Failed");
            }
        }
        #endregion

    }
}
