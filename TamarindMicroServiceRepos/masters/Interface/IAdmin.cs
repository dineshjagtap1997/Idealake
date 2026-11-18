using DataAccess.Model.DBModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TamarindAstra.Model.DBModel;
using CommonClass;

namespace BusinessLogic.Interface
{
    public interface IAdmin
    {
        Task<ResponseModel> ChangeUserPassword(RequestModel request);

        Task<ResponseModel> Roles(RequestModel request);

     
       Task<ResponseModel>RolesPermissions(RequestModel request);

       Task<ResponseModel> EmailConfigurations(RequestModel request);

       Task<ResponseModel> ConfigSettings(RequestModel request);

        Task<ResponseModel> Unlockuser(RequestModel request);

      //  Task<String>ScheduledJobRun(RequestModel request);

        //Task<string> SAPJobsInsertUpdate(RequestModel request);
    }
}
