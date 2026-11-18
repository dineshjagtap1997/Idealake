namespace TamarindAstra_Operations.Model
{

    public class DayWiseResponseModel
    {
        public BookingWithCommissionModel MonumentResponse { get; set; }
        public BookingWithCommissionModel TransportResponse { get; set; }
        public BookingWithCommissionModel GuideResponse { get; set; }
        public BookingWithCommissionModel SpecialServiceResponse { get; set; }
        public List<HotelDayWiseModel> HotelResponse { get; set; }

    }
    public class DayWiseModel
    {
        public List<BookingInfo> BookingInfo { get; set; }
    }
    public class BookingInfo
    {
        public int ID { get; set; }
        public DateTime DayWiseDate { get; set; }
        public string City { get; set; }
        public string ServiceName { get; set; }
        public string VendorInfo { get; set; }
        public int Adult { get; set; }
        public decimal Adult_Rate { get; set; }
        public int Child { get; set; }
        public decimal Child_Rate { get; set; }
        public int Consolidated { get; set; }
        public List<Commission> CommissionJSON { get; set; }

    }

    public class Commission
    {
        public int OthersRateCardMasterID { get; set; }
        public int CommissionMasterID { get; set; }
        public int MasterCommissionID { get; set; }
        public string RateType { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal GrossAmountIncludingTax { get; set; }
        public decimal GrossAmountExcludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal GrossRate { get; set; }
        public bool IsActive { get; set; }
    }

    public class GuideModelDayWiseModel
    {
        public int ID { get; set; }
        public DateTime DayWiseDate { get; set; }
        public string? City { get; set; }
        public string? ServiceName { get; set; }
        public int? Guide { get; set; }
        public string? LanguageInfo { get; set; }
        public int VendorInfo { get; set; }
        public int? Count { get; set; }
        public decimal? GrossRate { get; set; }
        public int BookingID { get; set; }
    }

    public class RootObject
    {
        public string BookingWithCommission { get; set; }
    }

    // This is the structure of BookingWithCommission, after parsing its string value
    public class BookingWithCommissionModel
    {
        public List<BookingInfo> BookingInfo { get; set; }
    }

    public class HotelDayWiseModel
    {
        public int ID { get; set; }
        public DateTime DayWiseDate { get; set; }
        public string City { get; set; }
        public string HotelName { get; set; }
        public string RoomCategory { get; set; }
        public int SGL { get; set; }
        public int Twin { get; set; }
        public int DBL { get; set; }
        public int EBA { get; set; }
        public int EBC { get; set; }
        public int CNB { get; set; }
        public double? SGL_Rate { get; set; }
        public double? Twin_Rate { get; set; }
        public double? DBL_Rate { get; set; }
        public double? EBA_Rate { get; set; }
        public double? EBC_Rate { get; set; }
        public double? CNB_Rate { get; set; }
        public double? GrossRate { get; set; }
        public string MealPlan { get; set; }
        public bool Breakfast { get; set; }
        public bool Lunch { get; set; }
        public bool Dinner { get; set; }
        public int BookingID { get; set; }
        public double RateCommissionID { get; set; }
        public double CommissionMasterID { get; set; }
        public double GrossAmountIncludingTax { get; set; }
        public decimal? NetAmountIncludingTax { get; set; }
        public decimal? NetAmountExcludingTax { get; set; }
        public double GrossAmountExcludingTax { get; set; }
    }

}
