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
        public int RoleId { get; set; }               // Unique identifier for the role
        public string RoleName { get; set; }          // Name of the role
        public string Description { get; set; }       // Optional description of the role
        public bool IsActive { get; set; }            // Indicates if the role is active
        public int CreatedBy { get; set; }            // ID of the user who created the role
        public DateTime CreatedDateTime { get; set; } // Timestamp when the role was created
        public int? UpdatedBy { get; set; }           // ID of the user who last updated the role
        public Guid OperationBy { get; set; }           // ID of the user who last updated the role
        public DateTime? UpdatedDateTime { get; set; } // Timestamp when the role was last updated
        public string Action { get; set; }
    }
    public class Modules
    {
        public int ModuleID { get; set; }
        public string ModuleName { get; set; }
        public int DisplayOrder { get; set; }
        public int Level { get; set; }
        public string Type { get; set; }
        public int? ParentMenuID { get; set; }

        // New properties to match the database changes
        public int CreatedBy { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int? UpdatedBy { get; set; }  // Nullable since it might be null on creation
        public DateTime? UpdatedDateTime { get; set; }  // Nullable since it might be null on creation
        public bool IsActive { get; set; }

        // Navigation properties for hierarchy
        public List<Modules> SubModules { get; set; } // SubModules under this module (level 2)
        public List<Modules> Tabs { get; set; }       // Tabs under this submodule (level 3)
        public List<Modules> SubTabs { get; set; }    // SubTabs under this tab (level 4)
        public string Action { get; set; }

        public string Link { get; set; }
        public bool visibleSection { get; set; }
    }


    public class SubModule
    {
        public int ModuleID { get; set; }
        public string ModuleName { get; set; }
        public int DisplayOrder { get; set; }
        public int Level { get; set; }
        public string Type { get; set; }
        public List<Tab> Tabs { get; set; } = new List<Tab>();
    }

    public class Tab
    {
        public int ModuleID { get; set; }
        public string ModuleName { get; set; }
        public int DisplayOrder { get; set; }
        public int Level { get; set; }
        public string Type { get; set; }
        public List<SubTab> SubTabs { get; set; } = new List<SubTab>();
    }

    public class SubTab
    {
        public int ModuleID { get; set; }
        public string ModuleName { get; set; }
        public int DisplayOrder { get; set; }
        public int Level { get; set; }
        public string Type { get; set; }
    }

    public class RolePermission
    {
        public int RolePermissionID { get; set; }    // Primary Key
        public int? RoleId { get; set; }               // Foreign Key to Roles table
        public int? ModuleID { get; set; }            // Foreign Key to Modules table (nullable)
        public string ModuleName { get; set; }         // Name of the module
        public int? ParentMenuID { get; set; }         // Parent module ID (nullable for root modules)
        public int Level { get; set; }                 // Hierarchical level of the module
        public string Type { get; set; }               // Type of the module (e.g., "Module", "SubModule")

        public bool CanView { get; set; }             // Permission flag
        public bool CanEdit { get; set; }             // Permission flag
        public bool CanAdd { get; set; }              // Permission flag
        public bool CanExport{ get; set; }           // Permission flag
        public bool CanDelete { get; set; }           // Permission flag
        public bool CanPrint { get; set; }            // Permission flag
        public bool CanUndoXO { get; set; }           // Permission flag
        public bool CanReassignTo { get; set; }       // Permission flag
        public bool CanViewAllFiles { get; set; }     // Permission flag
        public bool CanViewAllFilesReadOnly { get; set; } // Permission flag
        public int CreatedBy { get; set; }            // UserID of who created the record
       // public DateTime CreatedDateTime { get; set; }  // Timestamp when record was created
        //public int? UpdatedBy { get; set; }           // UserID of who updated the record (nullable)
        //public DateTime? UpdatedDateTime { get; set; } // Timestamp when record was updated (nullable)
        public bool IsActive { get; set; }            // Flag indicating if the record is active
        public string Action { get; set; }


        // Return codes for operation result
        // Return message (e.g., "Success", "Error")
    }

    public class RequestBatchModel
    {
        public string Action { get; set; }  // Action type (e.g., "B" for batch insert)
        public int CreatedBy { get; set; }  // Common CreatedBy field
        public bool IsActive { get; set; }  // Common IsActive field
        public List<RolePermission> RolePermissions { get; set; }  // List of role permission objects
    }


 



    public class ConfigSettings
    {
        public string Action { get; set; } 
        public int? ConfigSettingID { get; set; } 
        public string ConfigKey { get; set; } 
        public string ConfigValue { get; set; } 
        public Guid? OperationBy { get; set; } 
        public Guid? CreatedBy { get; set; } 
        public Guid? UpdatedBy { get; set; } 
    }

    //public class ScheduledJobRun
    //{

    //}

    public class SAPJobsInsertUpdate
    {
        public string JobName { get; set; }  // Agent , Hotel,Vendor , XO , Invoice,
                                             // ,XORepost, XOArriDept
        public string Taskflag { get; set; } // Insert or Update
        public string DataNumber { get; set; } // Data Passed to Ins or Updt
        public string DataToSplit { get; set; } // Data Passed to Ins or Updt
        public int CreatedBy { get; set; }

    }

    #region unlockuser starts here
    public class Unlockuser
    {
        public int EmpID { get; set; }
        public string UserName { get; set; }
        public Guid OperatedBy { get; set; }
        public string Action { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime LastLoginDate { get; set; }
        public bool IsLockedOut { get; set; }


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

    public class InvoiceData
    {
        public string INVOICENO { get; set; }
        public DateTime INVOICEDATE { get; set; }
        public long Ackno { get; set; }
        public DateTime Ackdate { get; set; }
        public string IRN { get; set; }
        public string SignedQR { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int UpdatedBy { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public bool IsActive { get; set; }
    }
}