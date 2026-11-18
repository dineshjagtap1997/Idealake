using Microsoft.Extensions.Configuration;
using System.Threading.Tasks;
using TamarindAstra.Common;
using CommonClass;
using TamarindAstraLoginDashboardReport.Models;
using TamarindAstraLoginDashboardReport.Interface;
using System.Text;
using System.Security.Cryptography;

namespace BusinessLogic.Repositories
{
    public class LoginRepository : ILogin
    {
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public LoginRepository(IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _configuration = configuration;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<ResponseModel> Login(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Login>(request.RequestText);
                //  req.Password = PasswordHasher.HashPassword(req.Password);
                if (req != null)
                {
                    var parameters = new
                    {
                        UserName = req.UserName,
                        Password = req.Password,
                        LoginCount = req.LoginCount,
                        LoginAttempts = req.LoginAttempts,
                        IsRemembered = req.RememberMe,
                        UserID = req.UserId,
                        CompanyID = req.CompanyID,
                        DepartmentID = req.DepartmentID,
                        BusinessTypeIDs = req.BusinessTypeIDs,
                        BusinessTypeName = req.BusinessTypeName,
                        DepartmentName = req.DepartmentName,
                    };
                    var data = new CommonClass.ResponseViewModel<Login>();

                    // Load data from SQL procedure
                    var response = SqlHelper.LoadData<Login, dynamic>("usp_Login_Authentication", parameters);

                    // Check if the response is not null
                    if (response != null && response.Any())
                    {
                        var check = response.FirstOrDefault();
                        data.returnCode = check.returnCode;
                        data.returnMessage = check.returnMessage;



                        if (check.returnCode == "200")
                        {
                            _httpContextAccessor.HttpContext.Session.SetString("IsRembered", response.FirstOrDefault().RememberMe.ToString());
                            var remembermer = _httpContextAccessor.HttpContext.Session.GetString("IsRembered");
                            var empId = response.FirstOrDefault()?.EmpID.ToString();
                            var groupedResult = response.GroupBy(emp => new { emp.EmpID, emp.EmpCode, emp.EmpName, emp.UserName, emp.RoleId, emp.RoleName, emp.UserId, emp.BizVertical, emp.TamSales, emp.Department, emp.CompanyID, emp.DepartmentID, emp.BusinessTypeIDs, emp.DepartmentName, emp.BusinessTypeName, emp.CurrencyName, emp.CurrencyId, emp.MarketIDs, emp.MarketNames,emp.empOffEmail,emp.ApproverEmail })
                             .Select(group => new
                             {
                                 group.Key.EmpID,
                                 group.Key.EmpCode,
                                 group.Key.EmpName,
                                 group.Key.RoleId,
                                 group.Key.RoleName,
                                 group.Key.UserName,
                                 UserId = group.Key.UserId,
                                 group.Key.Department,
                                 group.Key.TamSales,
                                 group.Key.BizVertical,
                                 group.Key.CompanyID,
                                 group.Key.CurrencyName,
                                 group.Key.CurrencyId,
                                 group.Key.DepartmentID,
                                 group.Key.BusinessTypeIDs,
                                 group.Key.DepartmentName,
                                 group.Key.BusinessTypeName,
                                 group.Key.MarketIDs,
                                 group.Key.MarketNames,
                                 group.Key.empOffEmail,
                                 group.Key.ApproverEmail,
                                 ModulePermissions = group.Select(g => new RolePermission
                                 {
                                     ParentMenuID = g.ParentMenuID,
                                     ModuleId = g.ModuleId,
                                     Level = g.Level,
                                     Type = g.Type,
                                     ModuleName = g.ModuleName,
                                     CanView = g.CanView,
                                     CanEdit = g.CanEdit,
                                     CanAdd = g.CanAdd,
                                     CanExport = g.CanExport,
                                     CanDelete = g.CanDelete,
                                     CanPrint = g.CanPrint,
                                     CanReassignTo = g.CanReassignTo,
                                     CanUndoXO = g.CanUndoXO,
                                     CanViewAllFiles = g.CanViewAllFiles,
                                     CanViewAllFilesReadOnly = g.CanViewAllFilesReadOnly,
                                     Link = g.Link


                                 }).ToList(),
                                 HasMultiplePermissions = group.Count() > 1
                             }).ToList();



                            if (groupedResult.Any(item => item.HasMultiplePermissions))
                            {
                                data.dataList = groupedResult.Select(group => new Login
                                {
                                    EmpID = group.EmpID,
                                    EmpCode = group.EmpCode,
                                    EmpName = group.EmpName,
                                    RoleId = group.RoleId,
                                    RoleName = group.RoleName,
                                    UserName = group.UserName,
                                    UserId = group.UserId,
                                    NewUserId = group.UserId,
                                    ModulePermissions = group.ModulePermissions,
                                    Department = group.Department,
                                    TamSales = group.TamSales,
                                    BizVertical = group.BizVertical,
                                    CompanyID = group.CompanyID,
                                    CurrencyName = group.CurrencyName,
                                    CurrencyId = group.CurrencyId,
                                    MarketIDs = group.MarketIDs,
                                    MarketNames = group.MarketNames,
                                    empOffEmail = group.empOffEmail,
                                    ApproverEmail = group.ApproverEmail,
                                    DepartmentID = group.DepartmentID,
                                    BusinessTypeIDs = group.BusinessTypeIDs,
                                    DepartmentName = group.DepartmentName,
                                    BusinessTypeName = group.BusinessTypeName
                                }).ToList();
                            }
                            else
                            {
                                data.dataList = response.ToList();
                            }

                            #region JWT Token

                            int expiryInMinutes = req.RememberMe
     ? int.Parse(_configuration["Jwt:RememberMeExpiryInDays"]) * 24 * 60  // 24 hours × 60 minutes
     : int.Parse(_configuration["Jwt:ExpiryInMinutes"]);


                            // Generate tokens
                            var token = JwtHelper.GenerateJwtToken(req.UserName, _configuration, expiryInMinutes);


                            data.token = token;


                            var param = new
                            {
                                @UserId = req.UserName,
                                @RefreshToken = token,
                                @ExpirationDate = DateTime.UtcNow.AddMinutes(expiryInMinutes),
                                @Action = "I",
                                @AccessToken = token,
                                @IsRemembered = req.RememberMe

                            };

                            //// Generate JWT Token
                            //var token = JwtHelper.GenerateJwtToken(req.UserName, _configuration, _httpContextAccessor);

                            //// Add the token to the response
                            //data.token = token;


                            //var param = new
                            //{
                            //    @UserId = req.UserName,
                            //    @RefreshToken = token,
                            //    @ExpirationDate = DateTime.UtcNow.AddMinutes(30),
                            //    @Action = "I",
                            //    @AccessToken = token

                            //};

                            #endregion
                            var statusresponse = SqlHelper.LoadData<StatusModel, dynamic>("usp_ManageRefreshToken", param);
                        }


                        return CommonFunctions.ProcessResult(data);
                    }
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }

        //public static class PasswordHasher
        //{
        //    public static string HashPassword(string password)
        //    {
        //        using var sha256 = SHA256.Create();
        //        var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
        //        return Convert.ToBase64String(bytes);
        //    }
        //}
        public async Task<ResponseModel> Logout(RequestModel request)
        {
            try
            {
                var req = CommonFunctions.DecryptAndDeserializeRequest<Login>(request.RequestText);

                if (req != null)
                {
                    var parameters = new
                    {
                        UserName = req.UserName,
                        Password = req.Password,
                        LoginCount = req.LoginCount,
                        LoginAttempts = req.LoginAttempts,
                        IsRemembered = req.RememberMe,
                        UserID = req.UserId,
                        CompanyID = req.CompanyID,
                        DepartmentID = req.DepartmentID,
                        BusinessTypeIDs = req.BusinessTypeIDs,



                    };
                    var data = new CommonClass.ResponseViewModel<Login>();

                    // Load data from SQL procedure
                    var response = SqlHelper.LoadData<Login, dynamic>("usp_Login_Authentication", parameters);

                    // Check if the response is not null
                    if (response != null && response.Any())
                    {
                        var check = response.FirstOrDefault();
                        data.returnCode = check.returnCode;
                        data.returnMessage = check.returnMessage;

                        // Proceed if the response code is 200 (success)
                        if (check.returnCode == "200")
                        {
                            _httpContextAccessor.HttpContext.Session.Remove("IsRembered");

                        }

                        return CommonFunctions.ProcessResult(data);
                    }
                }
                return CommonFunctions.BlankResponse("201", "Something went wrong.");
            }
            catch (Exception ex)
            {
                return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
            }
        }
    }
}