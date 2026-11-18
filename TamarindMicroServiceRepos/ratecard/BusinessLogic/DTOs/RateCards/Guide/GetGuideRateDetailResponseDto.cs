using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Guide;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide
{
    public class GetGuideRateDetailResponseDto : GuideRateDetail
    {
        public string ValidityDate { get; set; }
        public List<GuideRateCommissionDetailRequestDto> Commissions { get; set; }
    }
}
