using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.SpecialService
{
    public class SpecialServiceRateDetail : RateCardBase
    {
        public long SpecialServiceRateID { get; set; }
        public long SpecialServiceRateDetailID { get; set; }
        public TaxPreference TaxID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public int NationalityID { get; set; }
        public RatePreference RatePreferenceID { get; set; }
        public string MISSequence { get; set; }
    }
}


