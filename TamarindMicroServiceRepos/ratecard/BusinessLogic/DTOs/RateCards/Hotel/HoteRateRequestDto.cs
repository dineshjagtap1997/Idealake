using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel
{
    public class HotelRateRequestDto : HotelRate
    {
        public string HotelService { get; set; }
        public List<HotelRatesheetMasterRequestDto> Ratesheet { get; set; }
        public List<HotelRateMarketMasterRequestDto> Market { get; set; }
        public List<HotelRateVoucherTypeRequestDto> Voucher { get; set; }
    }
}
