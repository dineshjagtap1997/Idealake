namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport
{
    public class TransportRateFilter : RateFilter
    {
        public string Vendor { get; set; }
        public string Service { get; set; }
        public string TransportService { get; set; }
    }
}
