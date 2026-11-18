namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Monument
{
    public class MonumentRateCommissionDetail : RateCardBase
    {
        public long MonumentCommissionDetailID { get; set; }
        public long MonumentDetailID { get; set; }
        public int CommissionMasterID { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }

        public decimal GrossRateAdult { get; set; }
        public decimal GrossRateChild { get; set; }

        public string Markup_IsRate { get; set; }

        public decimal MarkupRate { get; set; }
        

    }
}
