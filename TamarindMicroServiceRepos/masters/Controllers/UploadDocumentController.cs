using CommonClass;
using Microsoft.AspNetCore.Mvc;
using TamarindAstraMasters.Interface;


namespace TamarindAstraMasters.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UploadDocumentController : ControllerBase
    {
       
        private readonly IUploadDocument _upload;

        public UploadDocumentController(IUploadDocument upload)
        {
           
            _upload = upload;
           
        }


        #region UploadDocument starts here
        //[Authorize]
        [HttpPost("UploadDocument")]
        public async Task<ResponseModel> UploadDocument(RequestModel request)
        
        {
            
            return await _upload.UploadDocuments(request);
        }
        [HttpPost("UploadFile")]
        public async Task<ResponseModel> UploadFile([FromForm] UploadDocumentsFormFileEncrypted request)

        {

            return await _upload.UploadFile(request);
        }
        #endregion
        #region DelinkDocuments starts here
        [HttpPost("DelinkDocuments")]
        public async Task<ResponseModel> DelinkDocuments(RequestModel request)
        {
            return await _upload.DelinkDocuments(request);
        }
        #endregion
        #region LinkedDocuments starts here
        [HttpPost("LinkedDocuments")]
        public async Task<ResponseModel> LinkedDocuments(RequestModel request)
        {
            return await _upload.LinkedDocuments(request);
        }
        #endregion

        #region linkAgentdocument starts here
        [HttpPost("LinkOtherDocument")]
        public async Task<ResponseModel> LinkOtherDocument(RequestModel request)
        {
            return await _upload.LinkOtherDocument(request);
        }
        #endregion linkdocument ends here

        #region DocumentTypeMaster starts here
        [HttpPost("DocumentTypeMaster")]
        public async Task<ResponseModel> DocumentTypeMaster(RequestModel request)
        {
            return await _upload.DocumentTypeMaster(request);
        }
        #endregion linkdocument ends here

    }
}
