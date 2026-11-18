using MathNet.Numerics;
using System;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using static NPOI.HSSF.Util.HSSFColor;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.SpecialService;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards
{
    public abstract class RateCardBase : RatePagingFilter
    {
        public string Action { get; set; }
        public string Heading { get; set; }
        public string CardNumber { get; set; }
        public string ContractDate { get; set; }
        public bool? IsActive { get; set; }
        public string CreatedBy { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedOn { get; set; }
        public string CreatedOn { get; set; }
        public string InfoForOperation { get; set; } 
        public string InfoForAgent { get; set; } 
        public string InfoForRemark { get; set; }
        public int TotalCount { get; set; }
        public bool HasRules { get; set; } = true;
        public bool HasDocument { get; set; } = true;
        public Guid OperationBy { get; set; }
        //use for filter
        public string City { get; set; }
        public string Vendor { get; set; }
        public string Currency { get; set; }
        public string RateCardMode { get; set; }
        public string RateCardModeType { get; set; }
        public string HotelName { get; set; }
        public string Active { get; set; }
    }
}

