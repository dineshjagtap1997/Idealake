namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Guide
{
    public class GuideRateCommissionDetail : RateCardBase
    {
        public long GuideRateCommissionID { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public int PaxMinimum { get; set; }
        public int PaxMaximum { get; set; }
    }
}

