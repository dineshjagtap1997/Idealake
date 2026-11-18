

using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Mappers.RateCards.Hotel
{

    public interface IHotelRateCardValidityMapper
    {
        void Map(IList<HotelRateValidityRequestDto> destination, long id);
    }
    public class HotelRateCardValidityMapper : IHotelRateCardValidityMapper
    {
        public void Map(IList<HotelRateValidityRequestDto> destination, long id)
        {
            if(destination == null || destination.Count == 0) return;
            foreach (var item in destination)
            {
                item.HotelRateDetailID = id;
            }
        }
    }
}
