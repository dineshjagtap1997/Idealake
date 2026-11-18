using CommonClass;
using CommonClass;
namespace TamarindAstra_Operations.Interface
{
    public interface IInvoice
    {

        public Task<ResponseModel> FetchInvoice(RequestModel request);

        //public Task<ResponseModel> InvoiceMaster(RequestModel request);

        

        public Task<ResponseModel> ServiceTaxByInvoice(RequestModel request);

        public Task<ResponseModel> InsertUpdate_Invoice_PrimaryInfo(RequestModel request);

        public Task<ResponseModel> InsertUpdateInvoiceDetails(RequestModel request);

        public Task<ResponseModel> InvInsertUpdateAddendumwithDetails(RequestModel request);

        public Task<ResponseModel> FetchInvoice_PrimaryInfo(RequestModel request);

        public Task<ResponseModel> FetchInvoiceDetails(RequestModel request);

        public Task<ResponseModel> FetchAddendumDetails(RequestModel request);

        public Task<ResponseModel> FetchInvoiceTaxCalculation(RequestModel request);

        public Task<ResponseModel> AddAgentRefrenceNumber(RequestModel request);

        public Task<ResponseModel> GetInvoiceDetailsBTCCommisionTaxCalculation(RequestModel request);

        public Task<ResponseModel> ConvertPerfomaToInvoice(RequestModel request);


        public Task<ResponseModel> InsertbtccommissionInvoice(RequestModel request);

        public Task<ResponseModel> InvInsertUpdateAddendum(RequestModel request);


        public Task<ResponseModel> FetchInvoiceDetailsforEdit(RequestModel request);

        public Task<ResponseModel> FetchInvoice_fromBookingScreenInfo(RequestModel request);

        Task<ResponseModel> PrintInvoiceAddendum(RequestModel request);











    }
}
