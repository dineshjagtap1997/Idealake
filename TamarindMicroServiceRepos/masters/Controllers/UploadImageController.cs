using CommonClass;
using Microsoft.AspNetCore.Mvc;
using TamarindAstraMasters.Interface;


namespace TamarindAstraMasters.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UploadImageController : ControllerBase
    {

        private readonly IImage _upload;

        public UploadImageController(IImage upload)
        {

            _upload = upload;

        }


        #region UploadImage starts here
        //[Authorize]
        [HttpPost("UploadImage")]
        public async Task<ResponseModel> UploadImage(RequestModel request)

        {

            return await _upload.UploadImage(request);
        }
        #endregion
    }
}
