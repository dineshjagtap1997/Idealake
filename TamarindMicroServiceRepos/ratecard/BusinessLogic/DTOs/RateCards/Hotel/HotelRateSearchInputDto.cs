namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel
{
    public class HotelRateSearchInputDto
    {
        public string CityID { get; set; }
        public long? HotelID { get; set; }
        public DateTime CheckIn { get; set; }
        public DateTime CheckOut { get; set; }
        public List<string> Occupancy { get; set; }
        public string CurrencyCode { get; set; }
        public string RateCardModeType { get; set; }
        public int TaxID { get; set; } = 0;
        public int? RatingFrom { get; set; }
        public int? RatingTo { get; set; }
        public string MISSequence { get; set; }
        public string PreferredMarketIDs { get; set; }
        //public string RateSheetIDs { get; set; }
        public List<string> RateSheetIDs { get; set; }
        public bool PreferredHotel { get; set; }
        public long QuotationID { get; set; }
        public long BookingID { get; set; }
        public bool IsFromBooking { get; set; }
        public bool? FIT { get; set; }
        public bool? GIT { get; set; }
        public int? BusinessType { get; set; }
        public long? VendorID { get; set; }
        public long? HotelRateID { get; set; }
        public bool? IsRateCardSearch { get; set; }
    }
}
