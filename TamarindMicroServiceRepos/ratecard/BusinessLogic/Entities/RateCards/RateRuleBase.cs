using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards
{
    public class RateRuleBase
    {
        public long ID { get; set; }
        public long RateCardID { get; set; }
        public string Action { get; set; }
        public RateCardType RateCardTypeID { get; set; }
        public bool IsActive { get; set; }
        public string CreatedBy { get; set; }
        public Guid OperationBy { get; set; }
        public string ModifiedBy { get; set; }
        public string CreatedOn { get; set; }
        public string ModifiedOn { get; set; }

    }
}
