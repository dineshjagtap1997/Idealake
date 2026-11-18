namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService
{
    public class SpecialServiceFilter : RateFilter
    {
        public string Vendor { get; set; }
        public string SpecialService { get; set; }
        public string City { get; set; }
    }
}
