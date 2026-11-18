namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel
{
    public class HotelRateOfferConfiguration : RateCardBase
    {
        public long OfferID { get; set; }
        public long HotelRateDetailID { get; set; }
        public int Days { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public int TotalNights { get; set; }
        public int PaidNights { get; set; }
        public int FreeNights { get; set; }
        public bool IsExtendible { get; set; }
        public bool IsDeleted { get; set; }
        
        public List<HotelRateOfferConfigurationCommission> OfferCommission { get; set; } = new();
    }

    public class HotelRateOfferConfigurationCommission
    {
        public long OfferCommissionID { get; set; }
        public long OfferConfigurationID { get; set; }
        public int MasterCommissionID { get; set; }
        public decimal Discount { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal PaidNightAmountExcludingTax { get; set; }
        public decimal PaidNightAmountIncludingTax { get; set; }
        public decimal FreeNightAmountExcludingTax { get; set; }
        public decimal FreeNightAmountIncludingTax { get; set; }
        public decimal GrossAmountExcludingTax { get; set; }
        public decimal GrossAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public decimal NetAmountIncludingTax { get; set; }

        public decimal PaidNightAmountExcludingTax_Con { get; set; }
        public decimal PaidNightAmountIncludingTax_Con { get; set; }
        public decimal FreeNightAmountExcludingTax_Con { get; set; }
        public decimal FreeNightAmountIncludingTax_Con { get; set; }
        public decimal GrossAmountExcludingTax_Con { get; set; }
        public decimal GrossAmountIncludingTax_Con { get; set; }
        public decimal NetAmountExcludingTax_Con { get; set; }
        public decimal NetAmountIncludingTax_Con { get; set; }
        public bool IsActive { get; set; }

        public string RateType { get; set; }
    }
}
