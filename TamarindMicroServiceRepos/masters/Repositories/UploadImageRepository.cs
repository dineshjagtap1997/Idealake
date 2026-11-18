using CommonClass;
using TamarindAstra.Common;
using TamarindAstraMasters.Interface;

namespace TamarindAstraMasters.Repositories
{
    public class UploadImageRepository : IImage
    {
        
       
        #region UploadImage starts here
        public async Task<ResponseModel> UploadImage(RequestModel request)
        {
            string baseUrl = SharedConfiguration.GetUploadsBaseUrl();
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<UploadImage>(request.RequestText);

                if (req != null)
                {
                    string rootFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads", "Images");
                    // Determine master type name based on ParentPageType (not ParentID)
                    string masterTypeName = CommonFunctions.GetMasterTypeImageName(req.ParentPageType);

                    // Create subfolder inside root folder
                    string masterFolder = Path.Combine(rootFolder, masterTypeName);

                    // Ensure directory exists
                    if (!Directory.Exists(masterFolder))
                    {
                        Directory.CreateDirectory(masterFolder);
                    }

                    // Generate unique file name
                    var uniqueFileName = $"{Guid.NewGuid()}_{req.ImageName}";
                    string filePath = Path.Combine(masterFolder, uniqueFileName);

                    // Convert Base64 string to byte array and save file
                    byte[] fileBytes = Convert.FromBase64String(req.Image);
                    //await File.WriteAllBytesAsync(filePath, fileBytes);
                    await File.WriteAllBytesAsync(filePath, fileBytes);
                    // Generate URL for the stored file

                    string fileUrl = $"{baseUrl}/Images/{masterTypeName}/{uniqueFileName}";

                    // Parameters aligned with UploadImage model
                    var parameters = new
                    {
                        @Image = fileUrl,
                        @ImageName = req.ImageName,
                        @ParentPageType = req.ParentPageType,
                        @ParentID = req.ParentID,
                        @Action = req.Action,
                    };

                    // Use UploadImage as the response model
                    var data = new CommonClass.ResponseViewModel<UploadImage>();
                    return CommonFunctions.ProcessDBData(data, req.Action, "usp_GetImages", parameters);
                }
                return CommonFunctions.BlankResponse("201", "Invalid request data.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Failed to upload image.");
            }
        }
        #endregion
    }
}