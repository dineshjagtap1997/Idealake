using BusinessLogic.Interface;
using CommonClass;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace TamarindAstra.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class Admincontroller : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly IAdmin _Admin;
        private readonly ILogger<Admincontroller> _logger;


        public Admincontroller(IConfiguration config, IAdmin Admin, ILogger<Admincontroller> logger)
        {
            _config = config;
            _Admin = Admin;
            _logger = logger;
        }

        #region ChangeUserPassword starts here
        [Authorize]
        [HttpPost("ChangeUserPassword")]
        public async Task<ResponseModel> ChangeUserPassword(RequestModel request)
        {
            return await _Admin.ChangeUserPassword(request);
        }
        #endregion ChangeUserPassword ends here

        #region RoleMaster starts here
        [Authorize]
        [HttpPost("RoleMaster")]
        public async Task<ResponseModel> RoleMaster(RequestModel request)
        {
            return await _Admin.RolesMaster(request);
        }
        #endregion

        //#region GetRoles starts here
        //[Authorize]
        //[HttpPost("GetRoles")]
        //public async Task<ResponseModel> GetRoles(RequestModel request)
        //{
        //    return await _Admin.GetRoles(request);
        //}
        //#endregion

        #region Get Module starts here
        [Authorize]
        [HttpPost("GetModules")]
        public async Task<ResponseModel> GetModules(RequestModel request)
        {
            return await _Admin.GetModules(request);
        }
        #endregion

        #region Module Master starts here
        [Authorize]
        [HttpPost("ModuleMaster")]
        public async Task<ResponseModel> ModuleMaster(RequestModel request)
        {
            return await _Admin.ModuleMaster(request);
        }
        #endregion

        #region Master starts here
        [Authorize]
        [HttpPost("RoleRightsMaster")] // Change route to avoid conflict
        public async Task<ResponseModel> RoleRightsMaster(RequestModel request)
        {
            return await _Admin.RoleRightsMaster(request);
        }
        #endregion EmailConfigurations ends here

        #region RoleRightsMaster starts here
        [Authorize]
        [HttpPost("GetRightsByRole")] // Change route to avoid conflict
        public async Task<ResponseModel> GetRightsByRole(RequestModel request)
        {
            return await _Admin.GetRightsByRole(request);
        }
        #endregion EmailConfigurations ends here

      


        #region EmailConfigurations starts here
        [Authorize]
        [HttpPost("EmailConfigurations")] 
        public async Task<ResponseModel> EmailConfigurations(RequestModel request)
        {
            return await _Admin.EmailConfigurations(request);
        }
        #endregion EmailConfigurations ends here
        

        #region ConfigSettings starts here
        [Authorize]
        [HttpPost("ConfigSettings")]
        public async Task<ResponseModel> ConfigSettings(RequestModel request)
        {
            return await _Admin.ConfigSettings(request);
        }
        #endregion ConfigSettings ends here

        #region unlockuser starts here
        [HttpPost("UnlockUser")]
        public async Task<ResponseModel> UnlockUser(RequestModel request)
        {
            return await _Admin.Unlockuser(request);
        }
        #endregion unlockuser ends here

        #region IRN Upload starts here
        [Authorize]
        [HttpPost("UploadIRNExcel")] // Change route to avoid conflict
        public async Task<ResponseModel> IRNUpload(IFormFile file, [FromForm] string request)
        {
            var requestModel = JsonConvert.DeserializeObject<RequestModel>(request);
            return await _Admin.IRNUpload(file, requestModel);
        }
        #endregion

        #region SAPJobsInsertUpdate starts here
        [Authorize]
        [HttpPost("SAPJobsInsertUpdate")]
        public async Task<ResponseModel> SAPJobsInsertUpdate(RequestModel request)
        {
            return await _Admin.SAPJobsInsertUpdate(request);
        }
        #endregion

        #region GetSAPInsertUpdateLogs starts here
        [Authorize]
        [HttpPost("GetSAPInsertUpdateLogs")]
        public async Task<ResponseModel> GetSAPInsertUpdateLogs(RequestModel request)
        {
            return await _Admin.GetSAPInsertUpdateLogs(request);
        }
        #endregion


    }

}
