using CommonClass;
using Microsoft.AspNetCore.Mvc;
using TamarindAstra_Operations.Interface;

namespace TamarindAstra_Operations.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class InvoiceController : Controller
    {
        private readonly IConfiguration _config;
        private readonly IInvoice _Invoice;
        private readonly ILogger<QuotationController> _logger;


        public InvoiceController(IConfiguration config, IInvoice invoice, ILogger<QuotationController> logger)
        {
            _config = config;
            _Invoice = invoice;
            _logger = logger;
        }

        //[HttpPost("InvoiceMaster")]
        //public async Task<ResponseModel> InvoiceMaster(RequestModel request)
        //{
        //    return await _Invoice.InvoiceMaster(request);
        //}

        [HttpPost("FetchInvoice")]
        public async Task<ResponseModel> FetchInvoice(RequestModel request)
        {
            return await _Invoice.FetchInvoice(request);
        }

        [HttpPost("ServiceTaxByInvoice")]
        public async Task<ResponseModel> ServiceTaxByInvoice(RequestModel request)
        {
            return await _Invoice.ServiceTaxByInvoice(request);
        }

        [HttpPost("FetchInvoice_PrimaryInfo")]
        public async Task<ResponseModel> FetchInvoice_PrimaryInfo(RequestModel request)
        {
            return await _Invoice.FetchInvoice_PrimaryInfo(request);
        }

        [HttpPost("FetchInvoiceDetails")]
        public async Task<ResponseModel> FetchInvoiceDetails(RequestModel request)
        {
            return await _Invoice.FetchInvoiceDetails(request);
        }

        [HttpPost("FetchAddendumDetails")]
        public async Task<ResponseModel> FetchAddendumDetails(RequestModel request)
        {
            return await _Invoice.FetchAddendumDetails(request);
        }

        [HttpPost("InsertUpdate_Invoice_PrimaryInfo")]
        public async Task<ResponseModel> InsertUpdate_Invoice_PrimaryInfo(RequestModel request)
        {
            return await _Invoice.InsertUpdate_Invoice_PrimaryInfo(request);
        }
        [HttpPost("InsertUpdateInvoiceDetails")]
        public async Task<ResponseModel> InsertUpdateInvoiceDetails(RequestModel request)
        {
            return await _Invoice.InsertUpdateInvoiceDetails(request);
        }

        [HttpPost("InvInsertUpdateAddendumwithDetails")]
        public async Task<ResponseModel> InvInsertUpdateAddendumwithDetails(RequestModel request)
        {
            return await _Invoice.InvInsertUpdateAddendumwithDetails(request);
        }

        [HttpPost("FetchInvoiceTaxCalculation")]
        public async Task<ResponseModel> FetchInvoiceTaxCalculation(RequestModel request)
        {
            return await _Invoice.FetchInvoiceTaxCalculation(request);
        }

        [HttpPost("AddAgentRefrenceNumber")]
        public async Task<ResponseModel> AddAgentRefrenceNumber(RequestModel request)
        {
            return await _Invoice.AddAgentRefrenceNumber(request);
        }

        [HttpPost("ConvertPerfomaToInvoice")]
        public async Task<ResponseModel> ConvertPerfomaToInvoice(RequestModel request)
        {
            return await _Invoice.ConvertPerfomaToInvoice(request);
        }

        [HttpPost("InsertbtccommissionInvoice")]
        public async Task<ResponseModel> InsertbtccommissionInvoice(RequestModel request)
        {
            return await _Invoice.InsertbtccommissionInvoice(request);
        }

        [HttpPost("InvInsertUpdateAddendum")]
        public async Task<ResponseModel> InvInsertUpdateAddendum(RequestModel request)
        {
            return await _Invoice.InvInsertUpdateAddendum(request);
        }

        [HttpPost("FetchInvoiceDetailsforEdit")]
        public async Task<ResponseModel> FetchInvoiceDetailsforEdit(RequestModel request)
        {
            return await _Invoice.FetchInvoiceDetailsforEdit(request);
        }

        [HttpPost("FetchInvoice_fromBookingScreenInfo")]
        public async Task<ResponseModel> FetchInvoice_fromBookingScreenInfo(RequestModel request)
        {
            return await _Invoice.FetchInvoice_fromBookingScreenInfo(request);
        }

        [HttpPost("PrintInvoiceAddendum")]
        public async Task<ResponseModel> PrintInvoiceAddendum([FromBody] RequestModel request)
        {
            return await _Invoice.PrintInvoiceAddendum(request);
        }


    }
}

