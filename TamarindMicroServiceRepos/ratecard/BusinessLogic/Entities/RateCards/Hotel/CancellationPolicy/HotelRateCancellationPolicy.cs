using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel.CancellationPolicy
{
    public class HotelRateCancellationPolicy
    {
        public long PolicyID { get; set; }
        public RateCardType RateCardTypeID { get; set; }
        public long RateCardID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public string TsStart { get; set; }
        public string TsEnd { get; set; }
        public string AgentStart { get; set; }
        public string AgentEnd { get; set; }
        public string ChangePercent { get; set; }
        public string ChargeNight { get; set; }
        public bool IsActive { get; set; }
        public string CreatedBy { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime UpdatedOn { get; set; }

        public Guid? OperationBy { get; set; }

    }
}
