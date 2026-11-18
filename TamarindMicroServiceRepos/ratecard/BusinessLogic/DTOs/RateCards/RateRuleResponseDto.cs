using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards
{
    public class RateRuleResponseDto : RateRuleBase
    {
        public int RuleID { get; set; }
        public string Rule { get; set; }
        public int ApplicableID { get; set; }
        public string Applicable { get; set; }
        public string MISSequence { get; set; }
        public string Description { get; set; }
    }
}
