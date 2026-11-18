using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Monument
{
    public class MonumentRateDetail : RateCardBase
    {
        public long MonumentDetailID { get; set; }
        public long MonumentRateID { get; set; }
        public TaxPreference TaxID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public int NationalityID { get; set; }
        public string MISSequence { get; set; }
        public string Nationality { get; set; }
    }
}
