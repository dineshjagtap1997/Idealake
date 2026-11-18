using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Monument;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument
{
    public class GetMonumentRateDetailResponseDto : MonumentRateDetail
    {
        public string ValidityDate { get; set; }
        public List<MonumentRateCommissionDetailRequestDto> Commissions { get; set; }
    }
}
