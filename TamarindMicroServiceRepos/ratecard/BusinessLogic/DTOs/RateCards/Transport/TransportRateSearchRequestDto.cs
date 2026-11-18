using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Transport;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport
{
    public class TransportRateSearchRequestDto : TransportServiceRate
    {
        //public TaxPreference TaxID { get; set; }

        public int TaxID { get; set; }
        public int VehicleCategoryID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public string ID { get; set; }

        public string TransportRateDetailID { get; set; }
        public string ValidityDate { get; set; }
        public string OthersRateRefrenceID { get; set; }
        public decimal? GrossRate { get; set; }

        public decimal? SellingRate { get; set; }
        public string RateType { get; set; }

        public string MarkupToggle { get; set; }

        public string Markup_IsRate { get; set; }

        public string SellingRates { get; set; }

        public string NetRate { get; set; }


        public decimal? MarkupRate { get; set; }
        public string Extrakms { get; set; }

        public string ExtraHrs { get; set; }
        public string MarkupPercent { get; set; }

        public string QuotationID { get; set; }

        public string Disclaimer { get; set; }
        public string ReasonID { get; set; }

        public List<TransportRateCommissionDetailRequestDto> TransportRateCommissionDetails { get; set; }

        public List<TransportServiceCommission> Commissions { get; set; }
        public List<TransportRateSearchRequestDto> DataList { get; set; }

        //public List<TransportRateCommissionDetailRequestDto> Commissions { get; set; }
    }
    public class TransportRateCardSearchRequest
    {
        public string CurrencyID { get; set; }           // Example: "Yes" or "No"
        public string RateCardModeType { get; set; }    // Example: "R1", nullable
        public int? TaxID { get; set; }                   // Nullable int
        public int? TransportServiceID { get; set; }                 // Service ID (nullable)
        public string CityID { get; set; }              // IATA code (e.g., "BOM")
        public int? VendorID { get; set; }                // Vendor ID
        public DateTime? ValidFrom { get; set; }          // Start date of validity
        public DateTime? ValidTo { get; set; }            // End date of validity
        public int? VehicleCategoryID { get; set; }               // Vehicle type(s), comma-separated or single value
        public long QuotationID { get; set; }
        public long BookingID { get; set; }
        public long? TransportRateID { get; set; }
    }

    public class TransportServiceCommission
    {
        public long TransportCommissionDetailID { get; set; }
        public long TransportRateDetailID { get; set; }
        public int CommissionMasterID { get; set; }
        public bool IsAmtIncludedInBasic { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public string RateType { get; set; }

        public decimal SellingRates { get; set; }

        public decimal GrossRate { get; set; }

        public bool Markup_IsRate { get; set; }

    }

}
