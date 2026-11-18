using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Model.DBModel
{
    public class ChangeUserPassword
    {
        public string UserName { get; set; }
        public bool IsActive { get; set; }
        public string OldPassword { get; set; }
        public string NewPassword { get; set; }

    }
    
    public class Roles
    {
        public Guid RoleId { get; set; }
        public string ApplicationName { get; set; }
        public string RoleName { get; set; }

        public string Action { get; set; }
      
    }

    public class  RolesPermissions
    {
        public Guid RoleID { get; set; }      
        public int ModuleID { get; set; }     
        public int Permissions { get; set; }  
        public string Action { get; set; }   
    }


    public class EmailConfigurations
    {
        public int EmailCategory { get; set; }
        public string FromEmailAddress { get; set; }
        public string ToEmailAddress { get; set; }
        public string Subject { get; set; }
        public string EmailBody { get; set; }
        public Guid OperationBy { get; set; }
        public string Action { get; set; }


    }


    public class ConfigSettings
    {
        public string Action { get; set; } 
        public int? ConfigSettingID { get; set; } 
        public string ConfigKey { get; set; } 
        public string ConfigValue { get; set; } 
        public Guid? OperationBy { get; set; } 
    }

    //public class ScheduledJobRun
    //{

    //}

    public class SAPJobsInsertUpdate
    {

    }

    #region unlockuser starts here
    public class Unlockuser
    {
        public int UserId { get; set; }
        public string UserName { get; set; }
    }

    #endregion unlockuser ends here

    #region Request Model starts here 
    //public class RequestModel
    //{
    //    public string RequestText { get; set; }
    //    public string MasterFlag { get; set; }
    //}

    #endregion Request Model ENDs here

    #region Response Model starts here
    //public class ResponseModel
    //{
    //    public string responseText { get; set; }
    //}
    #endregion Response Model ENDs here
}