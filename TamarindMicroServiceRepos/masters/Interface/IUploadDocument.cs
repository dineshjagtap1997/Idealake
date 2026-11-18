using CommonClass;

namespace TamarindAstraMasters.Interface
{
    public interface IUploadDocument
    {
        Task<ResponseModel> UploadDocuments(RequestModel request);
        Task<ResponseModel> UploadFile(UploadDocumentsFormFileEncrypted request);
        Task<ResponseModel> DelinkDocuments(RequestModel request);
        Task<ResponseModel> LinkedDocuments(RequestModel request);
        Task<ResponseModel> LinkOtherDocument(RequestModel request);

        Task<ResponseModel> DocumentTypeMaster(RequestModel request);
    }
}
