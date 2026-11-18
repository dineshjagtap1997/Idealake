using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.HotelOffer
{
    public class HotelOfferRate : RateCardBase
    {
        public long HotelOfferID { get; set; }
        public HospitalityPartner HospitalityPartnerID { get; set; }
        public string CityID { get; set; }
        public int HotelID { get; set; }
        public int HotelGroupID { get; set; }
        public int VendorID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public bool IsMarketOrAgent { get; set; }
        public string Rule { get; set; }

        public string VendorName { get; set; }
        public List<HotelOfferRateSheetMasterLookup> RateSheet { get; set; }
        public List<HotelOfferMarketMasterLookup> Market { get; set; }
        public List<HotelOfferMapping> Hotels { get; set; }
    }
}
