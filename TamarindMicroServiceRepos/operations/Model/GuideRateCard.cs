

//using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Guide;
//using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra_Operations.Model
{
    public class GuideRateSearchRequest : RateCardBase
    {
        public int? PaxMaximum { get; set; }
        public int TaxID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public long? GuideRateCommissionID { get; set; }
        public decimal? TaxAmount { get; set; }
        public decimal? TaxPercentage { get; set; }
        public int? PaxMinimum { get; set; }
        public decimal? NetAmountIncludingTax { get; set; }
        public decimal? NetAmountExcludingTax { get; set; }
        public string ValidityDate { get; set; }
        public string OthersRateRefrenceID { get; set; }

        public string IsAmtIncludedInBasic { get; set; }

        public string CommissionRefrenceID { get; set; }

        public string CommissionMasterID { get; set; }

        public long ID { get; set; }
        public string Markup_IsRate { get; set; }

        public decimal? MarkupRate { get; set; }

        public string NetRate { get; set; }
        public decimal? SellingRates { get; set; }

        public decimal? GrossRate { get; set; }
        public string GrossRateAdult { get; set; }
        public string GrossRateChild { get; set; }

        public string RateID { get; set; }
        public long GuideRateDetailID { get; set; }
        public string MISSequence { get; set; }

        public string Notes { get; set; }

        public int QuotationID { get; set; }

        public string Disclaimer { get; set; }
        public string ReasonID { get; set; }

        public long GuideRateID { get; set; }


        public RateCardModeType RateCardModeTypeID { get; set; }
        public string CurrencyID { get; set; }
        public int VendorID { get; set; }
        public string LanguageID { get; set; }
        public string CityID { get; set; }
        public int GuideServiceID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }
        public string ValueAddOn { get; set; }
        public string GuideService { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }

        public long QGID { get; set; }

        public long OthersRateCardCommissionID { get; set; }

        public bool? IsSummary { get; set; }
        public Guid? OperationBy { get; set; }
        //public List<GetGuideRateSearchRequestDto> DataList { get; set; }
       
        public List<GuideRateCommissionDetailRequestDto> Commissions { get; set; }

    }

    public class GuideRateCommissionDetailRequestDto
    {
        public long GuideRateCommissionID { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public int PaxMinimum { get; set; }
        public int PaxMaximum { get; set; }
    }

    public class GuideRateList
    {
        public List<GuideRateSearchRequest> DataList { get; set; }
        public string Action { get; set; }

        public long GuideRateID { get; set; }
        public RateCardModeType RateCardModeTypeID { get; set; }
        public string CurrencyID { get; set; }
        public int VendorID { get; set; }
        public string LanguageID { get; set; }
        public string CityID { get; set; }
        public int GuideServiceID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }
        public string ValueAddOn { get; set; }
        public string GuideService { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }


    }

    public class GetGuideRateSearchResponseDto : GuideRateCommissionDetail
    {
        //Guide Rate properties 

       
        public long GuideRateID { get; set; }
        public long QGID { get; set; }
        public RateCardModeType RateCardModeTypeID { get; set; }
        public string CurrencyID { get; set; }
        public int VendorID { get; set; }
        public string LanguageID { get; set; }

        public string Type { get; set; }
        public string CityID { get; set; }
        public int GuideServiceID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }
        public bool? ShowValueAddOns { get; set; }
        public string ValueAddOn { get; set; }
        public string GuideService { get; set; }

        //GuideRate Details properties

        public long GuideRateDetailID { get; set; }
        public TaxPreference TaxID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public string MISSequence { get; set; }

        public long SpecialServiceRateID { get; set; }
        public long SpecialServiceRateDetailID { get; set; }
        public int NationalityID { get; set; }
        public RatePreference RatePreferenceID { get; set; }

        public string Nationality { get; set; }
        public string PaxRange { get; set; }
        public string Language { get; set; }
        public decimal? SellingRates { get; set; }

        public decimal? GrossRate { get; set; }
        public string Disclaimer { get; set; }

        public string FromToDate { get; set; }

        public bool Markup_IsRate { get; set; }

        public decimal? MarkupRate { get; set; }
        public int? ReasonID { get; set; }
        public int? QuotationID { get; set; }
        public int? CountOfGuide { get; set; }
        public string QuotationNo { get; set; }

        public int OthersRateCardMasterID { get; set; }
        public int BookID { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string QuoCurrency { get; set; }

        public decimal PurchaseRate { get; set; }
        public bool? IsSummary { get; set; }
        //public string? Type { get; set; }
        public int EnquiryID {  get; set; }
        public string EnquiryNo { get; set; }

    }
    public class GuideRateCommissionDetail : RateCardBase
    {

        public long OthersRateCardCommissionID { get; set; }
        public long GuideRateCommissionID { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public int PaxMinimum { get; set; }
        public int PaxMaximum { get; set; }
        //public bool Markup_IsRate { get; set; }
        //public decimal MarkupRate { get; set; }

    }
}
