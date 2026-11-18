using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.SpecialService;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService
{
    public class SpecialServiceRateCommissionDetailRequestDto : SpecialServiceRateCommissionDetail
    {
        public int CommissionMasterID { get; set; }
    }
}
