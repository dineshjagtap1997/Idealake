using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.SpecialService;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService
{
    public class SpecialServiceDetailRequestDto : SpecialServiceRateDetail
    {
        public List<SpecialServiceRateCommissionDetailRequestDto> Commissions { get; set; }
    }
}
