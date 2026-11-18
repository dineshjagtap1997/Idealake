using CommonClass;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Polly;
using Polly.Retry;
using System.Text;
using System.Text.RegularExpressions;
using TamarindAstra.Common;
using Zoop.Model;

[Route("api/[controller]")]
[ApiController]
public class VerificationController : ControllerBase
{
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly IConfiguration _config;
    private readonly ILogger<VerificationController> _logger;
    private readonly AsyncRetryPolicy<HttpResponseMessage> _retryPolicy;

    public VerificationController(
        IHttpClientFactory httpClientFactory,
        IConfiguration config,
        ILogger<VerificationController> logger)
    {
        _httpClientFactory = httpClientFactory;
        _config = config;
        _logger = logger;

        _retryPolicy = Policy
            .Handle<HttpRequestException>()
            .OrResult<HttpResponseMessage>(r => !r.IsSuccessStatusCode)
            .WaitAndRetryAsync(3, retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)));
    }
    [HttpPost("verifypan")]
    public async Task<ResponseModel> VerifyPan(RequestModel request) //AAACI7536A
    {
        var req = CommonFunctions.DecryptAndDeserializeRequest<PanVerificationRequest>(request.RequestText);

        try
        {
            if (req != null)
            {
                // Log request input
                _logger.LogInformation("PAN Request Object: {@PanRequest}", req);

                if (ValidatePan(req.PanNumber))
                {
                    var client = new HttpClient();
                    var reqMsg = new HttpRequestMessage(HttpMethod.Post,
                        _config.GetSection("Zoop:BaseUrl").Value + _config.GetSection("Zoop:Endpoints:pan").Value);

                    reqMsg.Headers.Add("app-id", _config.GetSection("Zoop:AppId").Value);
                    reqMsg.Headers.Add("api-key", _config.GetSection("Zoop:ApiKey").Value);

                    var staticJson = new JObject
                {
                    { "mode", "sync" },
                    {
                        "data", new JObject
                        {
                            { "customer_pan_number", req.PanNumber },
                            { "consent", "Y" },
                            { "consent_text", "I hereby declare my consent agreement for fetching my information via ZOOP API" }
                        }
                    },
                    { "task_id", _config.GetSection("Zoop:pan_task_id").Value }
                };

                    var jsonContent = new StringContent(staticJson.ToString(), System.Text.Encoding.UTF8, "application/json");

                    // Log outgoing request payload
                    _logger.LogInformation("Sending request to Zoop API (PAN): {JsonPayload}", staticJson.ToString());

                    reqMsg.Content = jsonContent;

                    var response = await client.SendAsync(reqMsg);
                    response.EnsureSuccessStatusCode();

                    var responseString = await response.Content.ReadAsStringAsync();

                    // Log full response string
                    _logger.LogInformation("Zoop API Response (PAN): {Response}", responseString);

                    var result = JsonConvert.DeserializeObject<PanVerificationResult>(responseString);

                    if (result != null && result.success == true)
                    {
                        var data = new CommonClass.ResponseViewModel<PanVerificationResult>
                        {
                            returnMessage = "PAN verified",
                            returnCode = "200",
                            data = result
                        };
                        return CommonFunctions.ProcessResult(data);
                    }
                    else
                    {
                        var data = new CommonClass.ResponseViewModel<PanVerificationResult>
                        {
                            returnMessage = "PAN verification failed",
                            returnCode = "201",
                            data = result
                        };
                        return CommonFunctions.ProcessResult(data);
                    }
                }
                else
                {
                    var data = new CommonClass.ResponseViewModel<PanVerificationResult>
                    {
                        returnMessage = "Invalid PAN format",
                        returnCode = "201"
                    };
                    return CommonFunctions.ProcessResult(data);
                }
            }

            return CommonFunctions.BlankResponse("201", "Something went wrong.");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "PAN Verification Error");
            return CommonFunctions.CreateErrorResponse(ex, "Error", "Verification service unavailable");
        }
    }


    [HttpPost("verifygst")]
    public async Task<ResponseModel> VerifyGst(RequestModel request) //27AAACI7536A1ZV
    {
        var req = CommonFunctions.DecryptAndDeserializeRequest<GstVerificationRequest>(request.RequestText);

        try
        {
            if (req != null)
            {
                // Log request input
                _logger.LogInformation("GST Request Object: {@GstRequest}", req);

                if (ValidateGst(req.GstNumber))
                {
                    var client = new HttpClient();
                    var reqMsg = new HttpRequestMessage(HttpMethod.Post,
                        _config.GetSection("Zoop:BaseUrl").Value + _config.GetSection("Zoop:Endpoints:gst").Value);

                    reqMsg.Headers.Add("app-id", _config.GetSection("Zoop:AppId").Value);
                    reqMsg.Headers.Add("api-key", _config.GetSection("Zoop:ApiKey").Value);

                    var staticJson = new JObject
                {
                    { "mode", "sync" },
                    {
                        "data", new JObject
                        {
                            { "business_gstin_number", req.GstNumber },
                            { "consent", "Y" },
                            { "consent_text", "I hereby declare my consent agreement for fetching my information via ZOOP API" }
                        }
                    },
                    { "task_id", _config.GetSection("Zoop:gst_task_id").Value }
                };

                    var jsonContent = new StringContent(staticJson.ToString(), System.Text.Encoding.UTF8, "application/json");

                    // Log outgoing request payload
                    _logger.LogInformation("Sending request to Zoop API: {JsonPayload}", staticJson.ToString());

                    reqMsg.Content = jsonContent;

                    var response = await client.SendAsync(reqMsg);
                    response.EnsureSuccessStatusCode();

                    var responseString = await response.Content.ReadAsStringAsync();

                    // Log full response string
                    _logger.LogInformation("Zoop API Response: {Response}", responseString);

                    var result = JsonConvert.DeserializeObject<GstVerificationResult>(responseString);

                    if (result != null && result.success == true)
                    {
                        var data = new CommonClass.ResponseViewModel<GstVerificationResult>
                        {
                            returnMessage = "GST verified",
                            returnCode = "200",
                            data = result
                        };
                        return CommonFunctions.ProcessResult(data);
                    }
                    else
                    {
                        var data = new CommonClass.ResponseViewModel<GstVerificationResult>
                        {
                            returnMessage = "GST verification failed",
                            returnCode = "201",
                            data = result
                        };
                        return CommonFunctions.ProcessResult(data);
                    }
                }
                else
                {
                    var data = new CommonClass.ResponseViewModel<GstVerificationResult>
                    {
                        returnMessage = "Invalid GST number",
                        returnCode = "201"
                    };
                    return CommonFunctions.ProcessResult(data);
                }
            }

            return CommonFunctions.BlankResponse("201", "Something went wrong.");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "GST Verification Error");
            return CommonFunctions.CreateErrorResponse(ex, "Error", "Verification service unavailable");
        }
    }


    [HttpPost("verifytan")]
    public async Task<ResponseModel> VerifyTan(RequestModel request) //TANID1234F
    {
        var req = CommonFunctions.DecryptAndDeserializeRequest<TanVerificationRequest>(request.RequestText);
        try
        {
            if (req != null)
            {
                if (ValidateTan(req.TanNumber))
                {
                    var client = new HttpClient();
                    var reqMsg = new HttpRequestMessage(HttpMethod.Post, _config.GetSection("Zoop:BaseUrl").Value + _config.GetSection("Zoop:Endpoints:tan").Value);
                    reqMsg.Headers.Add("app-id", _config.GetSection("Zoop:AppId").Value);
                    reqMsg.Headers.Add("api-key", _config.GetSection("Zoop:ApiKey").Value);

                    var staticJson = new JObject {
                        { "mode", "sync" },
                        { "data", new JObject
                        {
                            { "customer_tan_number", req.TanNumber},
                            { "consent", "Y" },
                            { "consent_text", "I hereby declare my consent agreement for fetching my information via ZOOP API" }
                        }
                        },
                        { "task_id", _config.GetSection("Zoop:tan_task_id").Value }
                    };
                    var jsonContent = new StringContent(staticJson.ToString(), System.Text.Encoding.UTF8, "application/json");
                    reqMsg.Content = jsonContent;
                    var response = await client.SendAsync(reqMsg);
                    response.EnsureSuccessStatusCode();
                    var result = await ParseResponse<TanVerificationResult>(response);

                    if (result != null && result.success == true)
                    {
                        var data = new CommonClass.ResponseViewModel<TanVerificationResult>
                        {
                            returnMessage = "TAN verified",
                            returnCode = "200",
                            data = result
                        };
                        return CommonFunctions.ProcessResult(data);
                    }
                    else
                    {
                        var data = new CommonClass.ResponseViewModel<TanVerificationResult>
                        {
                            returnMessage = "Tan Verification failed",
                            returnCode = "201",
                            data = result
                        };
                        return CommonFunctions.ProcessResult(data);
                    }
                }
                else
                {
                    var data = new CommonClass.ResponseViewModel<TanVerificationResult>
                    {
                        returnMessage = "Invalid TanVerification number",
                        returnCode = "201"
                    };
                    return CommonFunctions.ProcessResult(data);
                }
            }

            return CommonFunctions.BlankResponse("201", "Something went wrong.");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "TanVerification Error");
            return CommonFunctions.CreateErrorResponse(ex, "Error", "Verification service unavailable");
        }
    }
    [HttpPost("verifypassport")]
    public async Task<ResponseModel> VerifyPassport(RequestModel request)
    {
        var req = CommonFunctions.DecryptAndDeserializeRequest<PassportVerificationResult>(request.RequestText);
        try
        {
            if (req != null)
            {
                if (ValidatePassport(req.Number))
                {
                    var client = new HttpClient();
                    var reqMsg = new HttpRequestMessage(HttpMethod.Post, _config.GetSection("Zoop:BaseUrl").Value + _config.GetSection("Zoop:Endpoints:passport").Value);
                    reqMsg.Headers.Add("app-id", _config.GetSection("Zoop:AppId").Value);
                    reqMsg.Headers.Add("api-key", _config.GetSection("Zoop:ApiKey").Value);

                    var staticJson = new JObject {
                        { "mode", "sync" },
                        { "data", new JObject
                        {
                            { "customer_passport_number", req.Number},
                            { "consent", "Y" },
                            { "consent_text", "I hereby declare my consent agreement for fetching my information via ZOOP API" }
                        }
                        },
                        { "task_id", _config.GetSection("Zoop:task_id").Value }
                    };
                    var jsonContent = new StringContent(staticJson.ToString(), System.Text.Encoding.UTF8, "application/json");
                    reqMsg.Content = jsonContent;
                    var response = await client.SendAsync(reqMsg);
                    response.EnsureSuccessStatusCode();
                    var result = await ParseResponse<PassportVerificationResult>(response);

                    if (result != null && result.success == true)
                    {
                        var data = new CommonClass.ResponseViewModel<PassportVerificationResult>
                        {
                            returnMessage = "Passport verified",
                            returnCode = "200",
                            data = result
                        };
                        return CommonFunctions.ProcessResult(data);
                    }
                    else
                    {
                        var data = new CommonClass.ResponseViewModel<PassportVerificationResult>
                        {
                            returnMessage = "Passport verification failed",
                            returnCode = "201",
                            data = result
                        };
                        return CommonFunctions.ProcessResult(data);
                    }
                }
                else
                {
                    var data = new CommonClass.ResponseViewModel<PassportVerificationResult>
                    {
                        returnMessage = "Invalid Passport number",
                        returnCode = "201"
                    };
                    return CommonFunctions.ProcessResult(data);
                }
            }

            return CommonFunctions.BlankResponse("201", "Something went wrong.");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "TanVerification Error");
            return CommonFunctions.CreateErrorResponse(ex, "Error", "Verification service unavailable");
        }
    }

    private async Task<HttpResponseMessage> CallZoopApi(string endpoint, object request)
    {
        var client = _httpClientFactory.CreateClient("ZoopAPI");
        var endpoints = _config.GetSection("Zoop:Endpoints").Get<Dictionary<string, string>>();

        var json = JsonConvert.SerializeObject(request);
        return await _retryPolicy.ExecuteAsync(async () =>
        {
            return await client.PostAsync(endpoints[endpoint],
                new StringContent(json, Encoding.UTF8, "application/json"));
        });
    }

    private bool ValidatePan(string pan) =>
        Regex.IsMatch(pan, @"^[A-Z]{5}[0-9]{4}[A-Z]$");

    private bool ValidateGst(string gst) =>
        Regex.IsMatch(gst, @"^\d{2}[A-Z]{5}\d{4}[A-Z]{1}\d[Z][A-Z\d]{1}$");

    private bool ValidateTan(string tan) =>
        Regex.IsMatch(tan, @"^[A-Z]{4}\d{5}[A-Z]$");

    private bool ValidatePassport(string passport) =>
        Regex.IsMatch(passport, @"^[A-Z0-9]{8}$");

    private async Task<IActionResult> HandleApiError(HttpResponseMessage response)
    {
        var errorContent = await response.Content.ReadAsStringAsync();
        _logger.LogError("API Error: {StatusCode} - {Content}", response.StatusCode, errorContent);
        return StatusCode((int)response.StatusCode, new VerificationResponse<object>(false, "Error", errorContent, null));
    }

    private async Task<T> ParseResponse<T>(HttpResponseMessage response)
    {
        var content = await response.Content.ReadAsStringAsync();
        return JsonConvert.DeserializeObject<T>(content);
    }
}