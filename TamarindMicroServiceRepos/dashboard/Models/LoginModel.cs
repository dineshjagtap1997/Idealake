using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TamarindAstraLoginDashboardReport.Models
{
    public class LoginModel
    {
        public string Username { get; set; }
        public string Password { get; set; }
    }

    public class Login : RolePermission
    {
        // Basic User Information
        public int EmpID { get; set; }
        public string EmpCode { get; set; }
        public string EmpName { get; set; }
        public string UserName { get; set; }

        // Role Information
        public int RoleId { get; set; }
        public string RoleName { get; set; }

        // Module Permissions (List of RolePermissions)
        public List<RolePermission> ModulePermissions { get; set; }

        // Response Metadata
        public string returnCode { get; set; }
        public string returnMessage { get; set; }

        // Additional Fields for Login
        public Guid UserId { get; set; }
        public string Password { get; set; }
        public string LoginCount { get; set; }
        public string LoginAttempts { get; set; }
        public bool RememberMe { get; set; } // "Remember Me" feature

        public Guid NewUserId { get; set; }

        public int? BizVertical { get; set; }
        public string TamSales { get; set; }
        public int? Department { get; set; }

        public string? CompanyID { get; set; }

        public string? DepartmentID { get; set; }

        // public int? BusinessTypeIDs { get; set; }
        public string? BusinessTypeIDs { get; set; }

        public string? BusinessTypeName { get; set; }

        public string? DepartmentName { get; set; }

        public string CurrencyName { get; set; }
        public int? CurrencyId { get; set; }

        public string MarketIDs { get; set; }
        public string MarketNames { get; set; }

        public string empOffEmail { get; set; }

        public string ApproverEmail { get; set; }
    }

    public class RolePermission
    {
        // Module Information
        public int? ModuleId { get; set; }            // Foreign Key to Modules table (nullable)
        public string ModuleName { get; set; }         // Name of the module
        public int? ParentMenuID { get; set; }         // Parent module ID (nullable for root modules)
        public int Level { get; set; }                 // Hierarchical level of the module
        public string Type { get; set; }               // Type of the module (e.g., "Module", "SubModule")

        // Permission Flags
        public bool CanView { get; set; }             // Permission flag for View
        public bool CanEdit { get; set; }             // Permission flag for Edit
        public bool CanAdd { get; set; }              // Permission flag for Add
        public bool CanExport { get; set; }           // Permission flag for Export
        public bool CanDelete { get; set; }           // Permission flag for Delete
        public bool CanPrint { get; set; }            // Permission flag for Print
        public bool CanUndoXO { get; set; }           // Permission flag for Undo/Redo
        public bool CanReassignTo { get; set; }       // Permission flag for Reassign
        public bool CanViewAllFiles { get; set; }     // Permission flag for viewing all files
        public bool CanViewAllFilesReadOnly { get; set; } // Permission flag for read-only file view
        public string Link { get; set; }

    }

    public class TokenRequest
    {
        public string RefreshToken { get; set; }
    }


    public class RefreshTokenData
    {
        public string UserId { get; set; }
        public string RefreshToken { get; set; }
        public string AccessToken { get; set; }
        public string Action { get; set; }
        public DateTime ExpirationDate { get; set; }
        public bool IsRemembered { get; set; }
    }

}
