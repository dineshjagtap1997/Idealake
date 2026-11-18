namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards
{
    public class RateFilter : RatePagingFilter
    {
        public string Action { get; set; }
        public string CardNumber { get; set; }
        public string RateCardModeType { get; set; }
        public string Heading { get; set; }
        public string ContractDate { get; set; }
        public bool? IsActive { get; set; }
    }
}
