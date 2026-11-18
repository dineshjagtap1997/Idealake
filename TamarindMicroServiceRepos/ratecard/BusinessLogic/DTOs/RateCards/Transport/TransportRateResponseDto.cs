
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Transport;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport
{
    public class TransportRateResponseDto : TransportServiceRate
    {
        public string TransportService { get; set; }

        public string VehicleBaseType { get; set; }

        public string VehicleType { get; set; }
        public string RateType { get; set; }

        public string VendorName { get; set; }
        public string City { get; set; }
        public string NetAmountIncludingTax { get; set; }
        public string TaxPercentage { get; set; }
        public string TaxAmount { get; set; }
        public string NetAmountExcludingTax { get; set; }
        public string SellingRate { get; set; }
        public string Language { get; set; }
    }
}
