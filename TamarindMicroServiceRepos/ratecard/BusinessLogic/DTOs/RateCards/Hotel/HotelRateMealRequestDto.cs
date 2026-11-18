using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel
{
    public class HotelRateMealRequestDto : HotelMeal
    {
        public int MasterCommissionID { get; set; }
        public int HotelRateMealID { get; set; }
        public long HotelRateDetailID { get; set; }
        public int MealTypeID { get; set; }
    }
}
