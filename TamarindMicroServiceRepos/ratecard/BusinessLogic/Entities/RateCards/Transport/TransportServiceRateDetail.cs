using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Transport
{
    public class TransportServiceRateDetail : RateCardBase
    {
        public long TransportRateDetailID { get; set; }
        public long TransportRateID { get; set; }
        public TaxPreference TaxID { get; set; }
        public int VehicleCategoryID { get; set; }
        public int VehicleBaseID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public string MISSequence { get; set; }
        public string VehicleType { get; set; }
        public string VehicleName { get; set; }
    }
}

            