using System.Runtime.Intrinsics.Arm;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Transport
{
    public class TransportServiceRateCommissionDetail: RateCardBase
    {
        public long TransportCommissionDetailID { get; set; }
        public long TransportRateDetailID { get; set; }
        public int CommissionMasterID { get; set; }
        public bool IsAmtIncludedInBasic { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public string RateType { get; set; }
    }
}