using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using TamarindAstra.Common; // Correct namespace for Cryptography

namespace TamarindAstra.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CryptographyController : Controller
    {
        private readonly string _base64Key;

        public CryptographyController(IOptions<Cryptography> options)
        {
            _base64Key = options.Value.SecretKey;
        }

        [HttpPost("encrypt")]
        public ActionResult<object> Encrypt([FromBody] string input)
        {
            try
            {
                string encryptedData = Cryptography.EncryptStringAES(input, _base64Key);

                return Ok(new
                {
                    Encrypted = encryptedData,
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    Error = ex.Message
                });
            }
        }
        [HttpPost("decrypt")]
        public ActionResult<object> Decrypt([FromBody] string encryptedData)
        {
            try
            {
                string decryptedData = Cryptography.DecryptStringAES(encryptedData, _base64Key);

                return Ok(new
                {
                    Decrypted = decryptedData
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    Error = ex.Message
                });
            }
        }
    }
}
