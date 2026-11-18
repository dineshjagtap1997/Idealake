using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel
{
    public class HotelRateResponseDto : HotelRate
    {
        public string CurrencyName { get; set; }
        public string PaymentType { get; set; }
        public string RateSheet { get; set; }
        public string MinDate { get; set; }
        public string MaxDate { get; set; }
        public IEnumerable<HotelRatesheetResponseDto> Ratesheet { get; set; }
        public IEnumerable<HotelRateMarketResponseDto> Market { get; set; }
        public IEnumerable<HotelRateVoucherResponseDto> Voucher { get; set; }
    }
}
