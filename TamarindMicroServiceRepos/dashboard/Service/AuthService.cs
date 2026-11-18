using CommonClass;
using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.Data.SqlClient;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using TamarindAstra.Common;
using TamarindAstraLoginDashboardReport.Interface;
using TamarindAstraLoginDashboardReport.Models;

public class AuthService : IAuth
{
   private readonly IConfiguration _config;
    private readonly IHttpContextAccessor _httpContextAccessor;
    //private readonly ILogin _auth;
    private readonly string _connectionString;
    //private readonly IConfiguration _configuration;

    public AuthService(IConfiguration config, IHttpContextAccessor httpContextAccessor)
    {
        _config = config;
        _httpContextAccessor = httpContextAccessor;
    }

    //public async Task<ResponseModel> RefreshToken(RequestModel request)
    //{
    //    ResponseModel _resModel = new ResponseModel();
    //    try
    //    {
    //        var req = CommonFunctions.DecryptAndDeserializeRequest<RefreshTokenData>(request.RequestText);

    //        if (req != null)
    //        {
    //            var storedRefreshToken = GetStoredRefreshToken(req);





    //            if (storedRefreshToken != null && storedRefreshToken.ExpirationDate > DateTime.UtcNow)

    //            {

    //                int expiryInMinutes = storedRefreshToken.IsRemembered
    // ? int.Parse(_config["Jwt:RememberMeExpiryInDays"]) * 24 * 60  // 24 hours × 60 minutes
    // : int.Parse(_config["Jwt:ExpiryInMinutes"]);
    //                //var newAccessToken = GenerateAccessToken(req.UserId);

    //                var newRefreshToken = JwtHelper.GenerateJwtToken(req.UserId, _config, expiryInMinutes);


    //                var parameters = new
    //                {
    //                    @UserId = req.UserId,
    //                    @RefreshToken = newRefreshToken,
    //                    @ExpirationDate = DateTime.UtcNow.AddMinutes(expiryInMinutes),
    //                    @Action = req.Action,
    //                    @AccessToken=req.RefreshToken,
    //                    @IsRemembered = storedRefreshToken.IsRemembered

    //                };

    //                var data = new CommonClass.ResponseViewModel<RefreshTokenData>
    //                {
    //                    data = new RefreshTokenData
    //                    {
    //                        RefreshToken = newRefreshToken,
    //                        //AccessToken = newAccessToken
    //                    }
    //                };
    //                return CommonFunctions.ProcessDBData(data, req.Action, "usp_ManageRefreshToken", parameters);

    //            }
    //            return CommonFunctions.BlankResponse("401", "Invalid Token.");
    //        }
    //        return CommonFunctions.BlankResponse("201", "Please Send the Appropreate Data.");
    //    }
    //    catch (Exception ex)
    //    {
    //        return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
    //    }
    //}

    public async Task<ResponseModel> RefreshToken(RequestModel request)
    {
        try
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<RefreshTokenData>(request.RequestText);
            if (req == null) return CommonFunctions.BlankResponse("201", "Invalid request");
           
        req.RefreshToken = req.RefreshToken.Trim();
                req.AccessToken = req.AccessToken.Trim();
                var storedToken = GetStoredRefreshToken(req);

            if (storedToken == null)
                return CommonFunctions.BlankResponse("401", "Invalid token");

            // Handle "Remember Me" tokens
            if (storedToken.IsRemembered)
            {
                // Never expire - just refresh token
                return RefreshRememberedToken(req, storedToken);
            }

            // Handle normal tokens
            if (storedToken.ExpirationDate > DateTime.UtcNow)
            {
                return RefreshNormalToken(req, storedToken);
            }

            return CommonFunctions.BlankResponse("401", "Token expired. Do you want to continue?");
        }
        catch (Exception ex)
        {
            return CommonFunctions.CreateErrorResponse(ex, "500", "Token refresh failed");
        }
    }

    private ResponseModel RefreshRememberedToken(RefreshTokenData req, RefreshTokenData storedToken)
    {
        int longExpiry = 365 * 24 * 60; // 1 year
        var newToken = JwtHelper.GenerateJwtToken(req.UserId, _config, longExpiry);

        var parameters = new
        {
            @UserId = req.UserId,
            @RefreshToken = newToken,
            @ExpirationDate = DateTime.UtcNow.AddMinutes(longExpiry),
            @Action = "U",
            @AccessToken = req.RefreshToken,
            @IsRemembered = true
        };

        return CommonFunctions.ProcessDBData(
            new ResponseViewModel<RefreshTokenData>
            {
                data = new RefreshTokenData { RefreshToken = newToken }
            },
            req.Action,
            "usp_ManageRefreshToken",
            parameters
        );
    }

    private ResponseModel RefreshNormalToken(RefreshTokenData req, RefreshTokenData storedToken)
    {
        int expiry = int.Parse(_config["Jwt:ExpiryInMinutes"]);
        var newToken = JwtHelper.GenerateJwtToken(req.UserId, _config, expiry);

        var parameters = new
        {
            @UserId = req.UserId,
            @RefreshToken = newToken,
            @ExpirationDate = DateTime.UtcNow.AddMinutes(expiry),
            @Action = "U",
            @AccessToken = req.RefreshToken,
            @IsRemembered = false
        };

        return CommonFunctions.ProcessDBData(
            new ResponseViewModel<RefreshTokenData>
            {
                data = new RefreshTokenData { RefreshToken = newToken }
            },
            req.Action,
            "usp_ManageRefreshToken",
            parameters
        );
    }
    public async Task<ResponseModel> ExpiredToken(RequestModel request)
    {
        ResponseModel _resModel = new ResponseModel();
        try
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<RefreshTokenData>(request.RequestText);

            if (req != null)
            {

                var parameters = new
                {
                    @UserId = req.UserId,
                    @RefreshToken = req.RefreshToken,
                    @ExpirationDate = DateTime.UtcNow,
                    @Action = req.Action
                };

                var data = new CommonClass.ResponseViewModel<RefreshTokenData> { };
                return CommonFunctions.ProcessDBData_WitoutAction(data, "usp_ManageRefreshToken", parameters);
            }
            return CommonFunctions.BlankResponse("401", "Token Expired.");
        }
        catch (Exception ex)
        {
            return CommonFunctions.CreateErrorResponse(ex, "500", "Login Failed");
        }
    }

    //public RefreshTokenData GetStoredRefreshToken(RefreshTokenData refreshToken)
    //{
    //    var data = GetData<RefreshTokenData>("usp_ManageRefreshToken",
    //        new
    //        {
    //            @UserId = refreshToken.UserId,
    //            @RefreshToken = refreshToken.RefreshToken,
    //            @ExpirationDate = refreshToken.ExpirationDate,
    //            @Action = "S"

    //        }, _config.GetConnectionString("DefaultConnection"));
    //    return data;
    //}
    public RefreshTokenData GetStoredRefreshToken(RefreshTokenData refreshToken)
    {
        var result = SqlHelper.LoadData<RefreshTokenData, dynamic>(
            "usp_ManageRefreshToken",
            new
            {
                UserId = refreshToken.UserId,
                RefreshToken = refreshToken.RefreshToken,
                ExpirationDate = refreshToken.ExpirationDate,
                Action = "S"
            }
        );

        return result.FirstOrDefault();
    }


public string GenerateAccessToken(string username, string empId)
    {

        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.ASCII.GetBytes("8FA7E22F924A8F3B5E419D9FA23D9C37CEFC456A78B9DC45F3A87E9AB64C327F"); // Replace with your secret key
        var claims = new[]
    {
        new Claim(ClaimTypes.Name, username),
        new Claim("EmpId", empId)  // Add EmpId claim
    };
        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(new[] { new Claim(ClaimTypes.Name, username) }),
            Expires = DateTime.UtcNow.AddMinutes(30),
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };
        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }

    public string GenerateRefreshToken()
    {
        var randomNumber = new byte[32];
        using (var rng = RandomNumberGenerator.Create())
        {
            rng.GetBytes(randomNumber);
            return Convert.ToBase64String(randomNumber);
        }
    }

    //public void SaveRefreshToken(RefreshTokenData refreshToken)
    //{
    //    using (var connection = new SqlConnection(_config.GetConnectionString("DefaultConnection")))
    //    {

    //        var data = GetData<RefreshTokenData>("usp_ManageRefreshToken",
    //        new
    //        {
    //            @UserId = refreshToken.UserId,
    //            @RefreshToken = refreshToken.RefreshToken,
    //             @ExpirationDate = refreshToken.ExpirationDate,
    //            @Action = "U"

    //        }, _config.GetConnectionString("DefaultConnection"));
    //    }
    //}

    public void SaveRefreshToken(RefreshTokenData refreshToken)
    {
        using (var connection = new SqlConnection(_config.GetConnectionString("DefaultConnection")))
        {
            var expiryInMinutes = int.Parse(_config.GetSection("Jwt:ExpiryInMinutes").Value);

            var data = GetData<RefreshTokenData>("usp_ManageRefreshToken",
            new
            {
                @UserId = refreshToken.UserId,
                @RefreshToken = refreshToken.RefreshToken,
                @ExpirationDate = DateTime.UtcNow.AddMinutes(expiryInMinutes),
                @Action = "U"
            }, _config.GetConnectionString("DefaultConnection"));
        }
    }

    //public ResponseModel ExpiredToken(RefreshTokenData refreshToken)
    //{
    //    using (var connection = new SqlConnection(_config.GetConnectionString("DefaultConnection")))
    //    {
    //        var expiryInMinutes = int.Parse(_config.GetSection("Jwt:ExpiryInMinutes").Value);

    //        var data = GetData<ResponseModel>("usp_ManageRefreshToken",
    //        new
    //        {
    //            @UserId = refreshToken.UserId,
    //            @RefreshToken = refreshToken.RefreshToken,
    //            @ExpirationDate = DateTime.UtcNow,
    //            @Action = "U"
    //        }, _config.GetConnectionString("DefaultConnection"));

    //        return data;
    //    }
    //}

    private T GetData<T>(string query, object parameters = null, string connectionString = null)
    {
        using (var connection = new SqlConnection(connectionString))
        {
            return connection.QueryFirstOrDefault<T>(query, parameters);
        }
    }
    public async Task<ResponseModel> CheckTokenExpiration(RequestModel request)
    {
        try
        {
            var req = CommonFunctions.DecryptAndDeserializeRequest<RefreshTokenData>(request.RequestText);

            if (req == null)
                return CommonFunctions.BlankResponse("201", "Invalid request");

            var storedToken = GetStoredRefreshToken(req);

            if (storedToken == null)
                return CommonFunctions.BlankResponse("401", "Invalid token");

            if (storedToken.IsRemembered)
            {
                return CommonFunctions.BlankResponse("200", "Token valid");
            }
            else
            {
                if (storedToken.ExpirationDate < DateTime.UtcNow)
                {
                    return CommonFunctions.BlankResponse("401", "Token expired. Do you want to continue?");
                }
                return CommonFunctions.BlankResponse("200", "Token valid");
            }
        }
        catch (Exception ex)
        {
            return CommonFunctions.CreateErrorResponse(ex, "500", "Token check failed");
        }
    }
}

