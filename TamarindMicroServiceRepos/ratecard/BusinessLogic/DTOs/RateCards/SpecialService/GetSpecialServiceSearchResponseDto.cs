using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService
{
    public class GetSpecialServiceSearchResponseDto
    {

        //public long SpecialServiceRateCommissionID { get; set; }
        public long SpecialServiceRateDetailID { get; set; }
        public int SpecialServiceID { get; set; }
        //public RateCardModeType RateCardModeTypeID { get; set; }

        public int TaxID { get; set; }
        public string CityID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }
        public int HotelID { get; set; }
        public string CurrencyID { get; set; }
        public int VendorID { get; set; }
        public int HrsPerDay { get; set; }
        public int KmPerDay { get; set; }
        public string PaxRange { get; set; }
        public string Language { get; set; }
        public string RateType { get; set; }
        public string SpecialService { get; set; }
        public string MonumentService { get; set; }
        public decimal? SellingRate { get; set; }

        public decimal? GrossRate { get; set; }
        public string VendorName { get; set; }
        public List<SpecialServiceRateCommissionDetailSearch> Commissions { get; set; }

        


        ////
        ///
        public string Nationality { get; set; }
        public long? SpecialServiceRateCommissionID { get; set; }
        public int CommissionMasterID { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public string ValidityDate { get; set; }
        public string Ratetype { get; set; }
        public string RatePreference { get; set; }
        public int MinimumPax { get; set; }
        public int MaximumPax { get; set; }

        public long SpecialServiceRateID { get; set; }
        //public TaxPreference TaxID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public int NationalityID { get; set; }
        public RatePreference RatePreferenceID { get; set; }
        public string MISSequence { get; set; }

        public string Action { get; set; }
        public string Heading { get; set; }
        public string CardNumber { get; set; }
        public string ContractDate { get; set; }
        public bool? IsActive { get; set; }
        public string CreatedBy { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedOn { get; set; }
        public string CreatedOn { get; set; }
        public string InfoForOperation { get; set; }
        public string InfoForAgent { get; set; }
        public string InfoForRemark { get; set; }
        public int TotalCount { get; set; }
        public bool HasRules { get; set; } = true;
        public bool HasDocument { get; set; } = true;
        public Guid OperationBy { get; set; }
        //use for filter
        public string City { get; set; }
        public string Vendor { get; set; }
        public string Currency { get; set; }
        public string RateCardMode { get; set; }
        public string RateCardModeType { get; set; }
        public string HotelName { get; set; }
        public string Active { get; set; }
        public string Type { get; set; }
        public int RateCardModeTypeID { get; set; }
        public int XORemark { get; set; }
        public string XORemarkName { get; set; }
        public decimal NetAmountIncludingTax_Con { get; set; }
        public decimal NetAmountExcludingTax_Con { get; set; }

    }

    public class SpecialServiceRateCommissionDetailSearch:GetSpecialServiceRateCommissionDetailResponseDto  
    {
        public decimal NetAmountIncludingTax_Con { get; set; }
        public decimal NetAmountExcludingTax_Con { get; set; }
    }
}