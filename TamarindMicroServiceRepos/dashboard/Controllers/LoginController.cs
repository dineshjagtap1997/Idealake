using CommonClass;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TamarindAstraLoginDashboardReport.Interface;

[ApiController]
[Route("api/[controller]")]
public class LoginController : ControllerBase
{
    private readonly ILogin _login;
    private readonly IAuth _auth;

    public LoginController(ILogin login, IAuth auth)
    {
        _login = login;
        _auth = auth;
    }
    // [Authorize]
    [HttpPost("Login")]
    public async Task<ResponseModel> Login([FromBody]RequestModel request)
    {
        return await _login.Login(request);
    }

    [HttpPost("Logout")]
    public async Task<ResponseModel> logout([FromBody] RequestModel request)
    {
        return await _auth.ExpiredToken(request);

    }

    [HttpPost("Test")]
    public async Task<IActionResult> Test()
    {
        return Ok("test");
    }

}
