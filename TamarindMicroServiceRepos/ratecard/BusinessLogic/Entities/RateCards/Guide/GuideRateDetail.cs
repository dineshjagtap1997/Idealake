using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Guide
{
    public class GuideRateDetail : RateCardBase
    {
        public long GuideRateID { get; set; }
        public long GuideRateDetailID { get; set; }
        public TaxPreference TaxID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public string MISSequence { get; set; }
    }
}
