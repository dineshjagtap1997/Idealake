using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Monument;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument
{
    public class MonumentRateDetailRequestDto : MonumentRateDetail
    {
        public List<MonumentRateCommissionDetailRequestDto> Commissions { get; set; }
    }
}
