using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.MOT
{
    public class MOTRate : RateCardBase
    {


        public long ID { get; set; } // bigint, not null
        public string RateCardNo { get; set; } // varchar(50), not null
        public DateTime? ContractDate { get; set; } // datetime, nullable
        public DateTime? ValidFrom { get; set; } // datetime, nullable
        public DateTime? ValidTo { get; set; } // datetime, nullable
        public DateTime? FromDate { get; set; } // datetime, nullable
        public DateTime? ToDate { get; set; } // datetime, nullable
        public string ContractHeading { get; set; } // nvarchar(400), nullable
        public int? TravelModeTypeID { get; set; } // int, nullable
        public string MOTNameORNumber { get; set; } // nvarchar(200), nullable
        public string Sector { get; set; } // nvarchar(400), nullable
        public RateCardModeType RateCardModeTypeID { get; set; }
        public string RateCardMode { get; set; }
        public string InformationToOperations { get; set; } // nvarchar(max), nullable
        public string XORemarks { get; set; } // nvarchar(max), nullable
        public int? VendorID { get; set; } // int, nullable
        public string CurrencyCode { get; set; } // nvarchar(20), nullable
        public bool IsActive { get; set; } // bit, not null
        public int? CompanyID { get; set; } // int, nullable
        public int? YearID { get; set; } // int, nullable
        public int? ClassTypeID { get; set; } // int, nullable
        public Guid? CreatedBy { get; set; } // nvarchar(200), nullable
        public DateTime CreatedOn { get; set; } // datetime, not null
        public Guid? ModifiedBy { get; set; } // nvarchar(200), nullable
        public DateTime? ModifiedOn { get; set; } // datetime, nullable
    }
}
