namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT
{
    public class MOTRateFilter : RateFilter
    {
        public string MOT { get; set; }
        public string DisplayRate { get; set; }           // VARCHAR(5)
        public string RateCardModeTypeID { get; set; }    // VARCHAR(50)
        public int? TaxID { get; set; }                    // INT
        public string? CityIata { get; set; }              // CHAR(3)
        public int? Service { get; set; }                  // INT
        public int? Vendor { get; set; }                   // INT
        public int? NationalityID { get; set; }            // INT
        public int? Adult { get; set; }                    // INT
        public int? Child { get; set; }                    // INT
        public DateTime? ValidFrom { get; set; }           // DATETIME
        public DateTime? ValidTo { get; set; }             // DATETIME
        public int? QuotationID { get; set; }              // INT
        public long? BookingID { get; set; }               // BIGINT
        public long? MOTRateID { get; set; }               // BIGINT
    }
}
