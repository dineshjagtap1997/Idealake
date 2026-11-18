namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.SpecialService
{
    public class SpecialServiceRateCommissionDetail : RateCardBase
    {
        public long SpecialServiceRateDetailID { get; set; }
        public long SpecialServiceRateCommissionID { get; set; }
        public int MinimumPax { get; set; }
        public int MaximumPax { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public int CommissionMasterID { get; set; }
    }
}
