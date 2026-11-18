using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel
{
    public class HotelRateDetail : RateCardBase
    {
        public long HotelRateDetailID { get; set; }
        public long HotelRateID { get; set; }
        public int RoomCategoryID { get; set; }//Room Category
        public TaxPreference TaxID { get; set; }
        public string Days { get; set; } //Days Applicable*
        public bool FIT { get; set; } //FIt 
        public bool GIT { get; set; } //GIT
        public int MealPlanID { get; set; }
        public int TransferID { get; set; }
        public int MinNights { get; set; }
        public int MaxNights { get; set; }
        public int RateTypeID { get; set; }
        public OfferType OfferTypeID { get; set; }
        public string MISSequence { get; set; }
        public int BusinessType { get; set; }
        public int? ClassTypeID { get; set; } // int, nullable
        public bool TaxType { get; set; } // int, nullable
    }
}
