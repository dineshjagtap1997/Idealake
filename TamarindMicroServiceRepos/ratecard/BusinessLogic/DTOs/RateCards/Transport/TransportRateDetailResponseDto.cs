using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Transport;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport
{
    public class TransportRateDetailFlatDto: TransportServiceRateDetail
    {
        public long? TransportCommissionDetailID { get; set; }
        public int CommissionMasterID { get; set; }
        public bool IsAmtIncludedInBasic { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public string RateType { get; set; }
        public string ValidityDate { get; set; }
    }

    public class TransportRateDetailResponseDto : TransportServiceRateDetail
    {
        public string ValidityDate { get; set; }
        public List<TransportRateCommissionDetailResponseDto> Commissions { get; set; }
    }
    public class TransportRateCommissionDetailResponseDto : TransportServiceRateCommissionDetail
    {
    }
}


