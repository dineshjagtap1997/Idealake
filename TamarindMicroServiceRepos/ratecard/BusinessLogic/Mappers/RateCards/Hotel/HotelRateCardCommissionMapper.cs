using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Mappers.RateCards.Hotel
{
    public interface IHotelRateCardCommissionMapper
    {
        void Map(IList<HotelRateCommissionDetailRequestDto> destination, long id);
    }
    public class HotelRateCardCommissionMapper : IHotelRateCardCommissionMapper
    {
        public void Map(IList<HotelRateCommissionDetailRequestDto> destination, long id)
        {
            if(destination == null || destination.Count == 0) return;
            foreach (var item in destination)
            {
                item.HotelRateDetailID = id;
            }
        }
    }
}
