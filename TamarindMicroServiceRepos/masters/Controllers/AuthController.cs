//using DataAccess.Model.DBModel;
//using Microsoft.AspNetCore.Mvc;

//[ApiController]
//[Route("api/[controller]")]
//public class AuthController : ControllerBase
//{
//    private readonly IConfiguration _configuration;

//    public AuthController(IConfiguration configuration)
//    {
//        _configuration = configuration;
//    }

//    [HttpPost("refresh")]
//    public IActionResult RefreshToken([FromBody]
//
//
//    Data request)
//    {
//        AuthService authService = new AuthService(_configuration);
//        var storedRefreshToken = authService.GetStoredRefreshToken(request); // Call the AuthService
//        if (storedRefreshToken == null || storedRefreshToken.ExpirationDate < DateTime.UtcNow)
//            return Unauthorized("Invalid or expired refresh token.");

//        // Generate new tokens
//        var newAccessToken = authService.GenerateAccessToken(storedRefreshToken.UserId); // Call the AuthService
//        var newRefreshToken = authService.GenerateRefreshToken(); // Call the AuthService

//        request.RefreshToken = newRefreshToken;
//        // Save new refresh token
//        authService.SaveRefreshToken(request); // Call the AuthService

//        return Ok(new { AccessToken = newAccessToken, RefreshToken = newRefreshToken });
//        }

//}
