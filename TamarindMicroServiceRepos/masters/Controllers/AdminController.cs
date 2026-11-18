using BusinessLogic.Interface;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using DataAccess.Model.DBModel;
using TamarindAstra.Model.DBModel;
using CommonClass;

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

        #region RoleMaster starts here
        //[Authorize]
        [HttpPost("ChangeUserPassword")]
        public async Task<ResponseModel> ChangeUserPassword(RequestModel request)
        {
            return await _Admin.ChangeUserPassword(request);
        }
        #endregion ChangeUserPassword ends here

        #region RoleMaster starts here
        //[Authorize]
        [HttpPost("RoleMaster")]
        public async Task<ResponseModel> RoleMaster(RequestModel request)
        {
            return await _Admin.Roles(request);
        }
        #endregion RoleMaster ends here

        #region RolePermissions starts here
        //[Authorize]
        [HttpPost("RolesPermissions")] // Change route to avoid conflict
        public async Task<ResponseModel> RolesPermissions(RequestModel request)
        {
            return await _Admin.RolesPermissions(request);
        }
        #endregion EmailConfigurations ends here


        #region EmailConfigurations starts here
        //[Authorize]
        [HttpPost("EmailConfigurations")] 
        public async Task<ResponseModel> EmailConfigurations(RequestModel request)
        {
            return await _Admin.EmailConfigurations(request);
        }
        #endregion EmailConfigurations ends here


        #region ConfigSettings starts here
        //[Authorize]
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
    }
}
