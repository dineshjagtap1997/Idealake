using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Mappers.RateCards.Hotel
{
    public interface IHotelMealOverviewMapper
    {
        void Map(IList<HotelRateMealRequestDto> destination, int id);
    }
    public class HotelMealOverviewMapper : IHotelMealOverviewMapper
    {
        public void Map(IList<HotelRateMealRequestDto> destination, int id)
        {
           if(destination == null || destination.Count == 0) return;
            foreach (var item in destination)
            {
                item.HotelRateDetailID = id;
            }
        }
    }
}
