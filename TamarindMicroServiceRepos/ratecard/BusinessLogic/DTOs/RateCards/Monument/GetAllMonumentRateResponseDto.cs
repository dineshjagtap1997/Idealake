using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Monument;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument
{
    public class GetAllMonumentRateResponseDto : MonumentRate
    {
        public string MonumentService { get; set; }
        public string VendorName { get; set; }

        public string RateCardMode { get; set; }

        public string City { get; set; }
        public string NetAmountIncludingTax { get; set; }
        public string TaxPercentage { get; set; }
        public string TaxAmount { get; set; }
        public string NetAmountExcludingTax { get; set; }
        public string SellingRate { get; set; }
        public string PaxRange { get; set; }
        public string Language { get; set; }

        public string RateType { get; set; }
    }
}
