using CommonClass;
using Microsoft.AspNetCore.Mvc;
using TamarindAstraLoginDashboardReport.Interface;
using TamarindAstraLoginDashboardReport.Models;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuth _auth;

    public AuthController(IAuth auth)
    {
        _auth = auth;
    }

    [HttpPost("refresh")]
    public async Task<ResponseModel> RefreshToken([FromBody] RequestModel request)
    {
        return await _auth.RefreshToken(request);

    }

}

