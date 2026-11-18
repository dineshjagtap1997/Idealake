using CommonClass;

namespace TamarindAstra_Operations.Interface
{
    public interface IQuotation
    {
        Task<ResponseModel> QuotationMaster(RequestModel request);
        Task<ResponseModel> Update_Quotation(RequestModel request);
        Task<ResponseModel> SaveQuotation(RequestModel request);
        Task<ResponseModel> FetchQuotations(RequestModel request);

        Task<ResponseModel> Quotationguide(RequestModel request);

        Task<ResponseModel> QuotationMonumentcreate(RequestModel request);

        Task<ResponseModel> QuotationSpecialServicecreate(RequestModel request);

        Task<ResponseModel> QuotationTransportcreate(RequestModel request);

        Task<ResponseModel> GetQuotationStatus(RequestModel request);

        //Task<ResponseModel> GetQuotationService(RequestModel request);
        Task<ResponseModel> GetQuotationServiceWithCustom(RequestModel request);

        Task<ResponseModel> DeleteRateCard(RequestModel request);

        Task<ResponseModel> QuotationHotelcreate(RequestModel request);
        Task<ResponseModel> CloneQuotation(RequestModel request);
        Task<ResponseModel> DisplayQuotationDisclaimer(RequestModel request);

        Task<ResponseModel> QuotationStatus(RequestModel request);

        Task<ResponseModel> QuotationDraft(RequestModel request);
        Task<ResponseModel> GetCustomRateCardByIdAndType(RequestModel request);


        Task<ResponseModel> GetQuotationVersion(RequestModel request);

    }
}
