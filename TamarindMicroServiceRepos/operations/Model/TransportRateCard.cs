

namespace TamarindAstra_Operations.Model
{

    public class TransportRateRequest : TransportServiceRate
    {
        public int TQTID { get; set; }
        public int TaxID { get; set; }
        public bool? IsSummary { get; set; }
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


        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        //public List<TransportRateCommissionDetailRequestDto> TransportRateCommissionDetails { get; set; }

        public List<TransportServiceCommission> Commissions { get; set; }
        //public List<TransportRateSearchRequestDto> DataList { get; set; }


    }
    public class TransportRateCardSearchRequest
    {
        public string CurrencyID { get; set; }           // Example: "Yes" or "No"
        public string RateCardModeTypeID { get; set; }    // Example: "R1", nullable
        public int? TaxID { get; set; }                   // Nullable int
        public int? TransportServiceID { get; set; }                 // Service ID (nullable)
        public string CityID { get; set; }              // IATA code (e.g., "BOM")
        public int? VendorID { get; set; }                // Vendor ID
        public DateTime? ValidFrom { get; set; }          // Start date of validity
        public DateTime? ValidTo { get; set; }            // End date of validity
        public int? VehicleCategoryID { get; set; }               // Vehicle type(s), comma-separated or single value
    }

    public class TransportServiceCommission
    {
        public long OthersRateCardCommissionID { get; set; }
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
        public object MarkupRate { get; set; }
    }


    public class TransportServiceRate : RateCardBase
    {
        public long TransportRateID { get; set; }
        public RateCardModeType RateCardModeTypeID { get; set; }
        public int TransportServiceID { get; set; }
        //public TransportModeType TransportModeTypeID { get; set; }
        public int HotelID { get; set; }
        public int VendorID { get; set; }
        public int HotelZone { get; set; }
        public string CityID { get; set; }
        public string CityID2 { get; set; }
        public string CurrencyID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }


        public string VendorName { get; set; }
        public string City1 { get; set; }
        public string TransportServiceName { get; set; }
        public string HotelZoneName { get; set; }

        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
    }

    public class TransportServiceList
    {
        public List<TransportRateRequest> DataList { get; set; }
        public string Action { get; set; }

    }

    public class TransportRateSearchResponseDto : TransportServiceRateCommissionDetail
    {
        public long TransportRateID { get; set; }
        public long TQTID { get; set; }
        public int QQID { get; set; }
        //public RateCardModeType RateCardModeTypeID { get; set; }

        public string RateCardModeType { get; set; }
        public string TransportModeType { get; set; }

        public int TaxID { get; set; }
        public int TransportServiceID { get; set; }
        // public TransportModeType TransportModeTypeID { get; set; }
        public int HotelID { get; set; }
        public int VendorID { get; set; }
        public int HotelZone { get; set; }
        public string CityID { get; set; }
        public string CityID2 { get; set; }
        public string CurrencyID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }
        public string VendorName { get; set; }
        public string City { get; set; }
        public string TransportServiceName { get; set; }
        public string HotelZoneName { get; set; }
        //public TaxPreference TaxID { get; set; }
        public int VehicleCategoryID { get; set; }
        public int VehicleBaseID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public string MISSequence { get; set; }
        public string VehicleType { get; set; }
        public string VehicleName { get; set; }
        public string TransportService { get; set; }
        public string VehicleBaseType { get; set; }
        public string SellingRate { get; set; }
        public string Language { get; set; }
        public decimal? GrossRate { get; set; }
        public string Disclaimer { get; set; }

        public string? FromToDate { get; set; }
        public long? QuotationID { get; set; }
        public decimal? MarkupRate { get; set; }
        public bool? Markup_IsRate { get; set; }

        public int? ReasonID { get; set; }

        public string Type { get; set; }

        public string TransportRateCommissionDetails { get; set; } // Raw JSON from DB
        public List<TransportRateCommissionDetailResponseDto> Commissions { get; set; }
        public int RateCardModeTypeID { get; set; }
        public int? CountOfVehicles { get; set; }
        public string QuotationNo { get; set; }



        public string QuoCurrency { get; set; }

        public decimal PurchaseRate { get; set; }
        public bool? IsSummary { get; set; }

        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        public int? BookID { get; set; }
        public int? OthersRateCardMasterID { get; set; }
        public int EnquiryID { get; set; }
        public string EnquiryNo { get; set; }



    }
    public class TransportServiceRateCommissionDetail : RateCardBase
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

        public bool? Markup_IsRate { get; set; }
        public decimal? MarkupRate { get; set; }
        public decimal? GrossRate { get; set; }
        public decimal? SellingRates { get; set; }
        public long OthersRateCardCommissionID { get; set; }
        
    }
    public class TransportRateCommissionDetailResponseDto : TransportServiceRateCommissionDetail
    {
    }

}
