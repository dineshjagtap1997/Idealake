using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TamarindAstraLoginDashboardReport.Models
{
    public class Employee
    {
        public string EmpCode { get; set; }
        public Guid UserID { get; set; }
        public int SalutationID { get; set; }
        public string Gender { get; set; }
        public string EmpName { get; set; }
        public string Address { get; set; }
        public string CityIATACode { get; set; }
        public string ResPhoneNo { get; set; }
        public string MobileNo { get; set; }
        public string PersonalEmail { get; set; }
        public int CompanyID { get; set; }
        public DateTime DateOfBirth { get; set; }
        public DateTime DateOfJoining { get; set; }
        public DateTime? DateOfRetirement { get; set; }  // Nullable if retirement is not yet applicable
        public int DesignationID { get; set; }
        public int DepartmentID { get; set; }
        public int ReportHeadID { get; set; }
        public string OffEmail { get; set; }
        public string OffPhone { get; set; }
        public string Pan { get; set; }
        public bool IsActive { get; set; }
        public string Operation { get; set; }
        public Guid OperationBy { get; set; }
        public DateTime OperationOn { get; set; }
        public int OldID { get; set; }
        public int LevelID { get; set; }
        public bool IsSales { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public bool IsLockedOut { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime? LastLoginDate { get; set; }  // Nullable if user hasn't logged in
        public int FailedPasswordAttemptCount { get; set; }
        public string returnCode{ get; set; }
        public string returnMessage{ get; set; }
    }
}