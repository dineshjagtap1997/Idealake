using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Guide;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide
{
    public class GuideRateDetailRequestDto : GuideRateDetail
    {
        public List<GuideRateCommissionDetailRequestDto> Commissions { get; set; }
    }
}
