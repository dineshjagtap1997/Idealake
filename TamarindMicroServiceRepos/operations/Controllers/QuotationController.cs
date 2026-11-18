using CommonClass;
using Microsoft.AspNetCore.Mvc;
using TamarindAstra_Operations.Interface;

namespace TamarindAstra_Operations.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class QuotationController : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly IQuotation _quotation;
        private readonly ILogger<QuotationController> _logger;


        public QuotationController(IConfiguration config, IQuotation quotation, ILogger<QuotationController> logger)
        {
            _config = config;
            _quotation = quotation;
            _logger = logger;
        }


        //[Authorize]
        [HttpPost("QuotationMaster")]
        public async Task<ResponseModel> QuotationMaster(RequestModel request)
        {
            return await _quotation.QuotationMaster(request);
        }

        [HttpPost("Update_Quotation")]
        public async Task<ResponseModel> Update_Quotation(RequestModel request)
        {
            return await _quotation.Update_Quotation(request);
        }
        [HttpPost("SaveQuotation")]
        public async Task<ResponseModel> SaveQuotation(RequestModel request)
        {
            return await _quotation.SaveQuotation(request);
        }

        [HttpPost("FetchQuotations")]
        public async Task<ResponseModel> FetchQuotations(RequestModel request)
        {
            return await _quotation.FetchQuotations(request);
        }

        //[HttpPost]
        //[Route("/{type}/Quotationguide")]
        //public async Task<IActionResult> RateCardSearchCreateAsync(RateCardType type, [FromBody] RequestModel request)
        //{
        //    var result = await RateSearchCreateReportFactoryAsync(type, request);
        //    return Ok(result);
        //}

        [HttpPost("Quotationguidecreate")]
        public async Task<ResponseModel> Quotationguidecreate(RequestModel request)
        {
            return await _quotation.Quotationguide(request);
        }

        [HttpPost("QuotationMonumentcreate")]
        public async Task<ResponseModel> QuotationMonumentcreate(RequestModel request)
        {
            return await _quotation.QuotationMonumentcreate(request);
        }

        [HttpPost("QuotationSpecialServicecreate")]
        public async Task<ResponseModel> QuotationSpecialServicecreate(RequestModel request)
        {
            return await _quotation.QuotationSpecialServicecreate(request);
        }

        [HttpPost("QuotationTransportcreate")]
        public async Task<ResponseModel> QuotationTransportcreate(RequestModel request)
        {
            return await _quotation.QuotationTransportcreate(request);
        }

        [HttpPost("GetQuotationStatus")]
        public async Task<ResponseModel> GetQuotationStatus(RequestModel request)
        {
            return await _quotation.GetQuotationStatus(request);
        }

        [HttpPost("GetQuotationService")]
        public async Task<ResponseModel> GetQuotationService(RequestModel request)
        {
            //return await _quotation.GetQuotationService(request);
            return await _quotation.GetQuotationServiceWithCustom(request);
        }


        //[HttpPost("GetQuotationServiceWithCustom")]
        //public async Task<ResponseModel> GetQuotationServiceWithCustom(RequestModel request)
        //{
        //    return await _quotation.GetQuotationServiceWithCustom(request);
        //}

        [HttpPost("DeleteRateCard")]
        public async Task<ResponseModel> DeleteRateCard(RequestModel request)
        {
            return await _quotation.DeleteRateCard(request);
        }

        [HttpPost("QuotationHotelcreate")]
        public async Task<ResponseModel> QuotationHotelcreate(RequestModel request)
        {
            return await _quotation.QuotationHotelcreate(request);
        }

        [HttpPost("CloneQuotation")]
        public async Task<ResponseModel> CloneQuotation(RequestModel request)
        {
            return await _quotation.CloneQuotation(request);
        }

        [HttpPost("QuotationStatus")]
        public async Task<ResponseModel> QuotationStatus(RequestModel request)
        {
            return await _quotation.QuotationStatus(request);
        }

        [HttpPost("DisplayQuotationDisclaimer")]
        public async Task<ResponseModel> DisplayQuotationDisclaimer(RequestModel request)
        {
            return await _quotation.DisplayQuotationDisclaimer(request);
        }

        [HttpPost("QuotationDraft")]
        public async Task<ResponseModel> QuotationDraft(RequestModel request)
        {
            return await _quotation.QuotationDraft(request);
        }

        [HttpPost("GetCustomRateCardByIdAndType")]
        public async Task<ResponseModel> GetCustomRateCardByIdAndType(RequestModel request)
        {
            return await _quotation.GetCustomRateCardByIdAndType(request);
        }

        [HttpPost("GetQuotationVersion")]
        public async Task<ResponseModel> GetQuotationVersion(RequestModel request)
        {
            return await _quotation.GetQuotationVersion(request);
        }

    }
}