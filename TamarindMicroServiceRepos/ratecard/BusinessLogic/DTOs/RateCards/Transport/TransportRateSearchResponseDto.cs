using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Transport;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport
{
    public class TransportRateSearchResponseDto : TransportServiceRateCommissionDetail
    {
        public long TransportRateID { get; set; }
        //public RateCardModeType RateCardModeTypeID { get; set; }

        public string RateCardModeType { get; set; }
        public int? RateCardModeTypeID { get; set; }
        public string TransportModeType { get; set; }
        public string CardNumber { get; set; }

        public int TaxID { get; set; }
        public string InfoForOperation { get; set; }
        public string InfoForRemark { get; set; }
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
        public string City1 { get; set; }
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
        public string TransportRateCommissionDetails { get; set; } // Raw JSON from DB
        public List<TransportServiceRateCommissionDetailSearch> Commissions { get; set; }
        public string Type { get; set; }
        public long QuotationID { get; set; }
        public int XORemark { get; set; }
        public string XORemarkName { get; set; }

    }
    public class TransportServiceRateCommissionDetailSearch:TransportRateCommissionDetailResponseDto 
    {
        public decimal NetAmountIncludingTax_Con { get; set; }
        public decimal NetAmountExcludingTax_Con { get; set; }
    }
}
