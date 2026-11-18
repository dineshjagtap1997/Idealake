using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService
{




    public class GetSpecialServiceSearchRequestDto
    {
        public string CurrencyID { get; set; }
        public string RateCardModeType { get; set; }
        public int TaxID { get; set; }
        public string CityID { get; set; }
        public int? SpecialServiceRateID { get; set; }
        public int? SpecialServiceID { get; set; }
        public int? VendorID { get; set; }
        public int? NationalityID { get; set; }
        public int? Child { get; set; }
        public int? Adult { get; set; }
        public DateTime? ValidFrom { get; set; }
        public DateTime? ValidTo { get; set; }
        public long QuotationID { get; set; }
        public long BookingID { get; set; }
    }
}
