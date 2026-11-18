namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel
{
    public class HotelRateCommission : RateCardBase
    {
        public long RateCommissionID { get; set; }
        public int MasterCommissionID { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal GrossAmountIncludingTax { get; set; }
        public decimal GrossAmountExcludingTax { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public decimal CommissionPercentage { get; set; }
        public decimal CommissionAmount { get; set; }
        public long HotelRateDetailID { get; set; }
        public bool IsTax { get; set; }
        public string RateType { get; set; }
    }

    public class CustomRateCommission : HotelRateCommission
    {
        public bool IsAmtIncludedInBasic { get; set; }
        public int MinimumPax { get; set; }
        public int MaximumPax { get; set; }
    }
}