namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.MOT
{
    public class MOTRateDetail : RateCardBase
    {
        public long MOTRateDetailID { get; set; } // bigint, not null
        public int? ClassTypeID { get; set; } // int, nullable
        public bool TaxType { get; set; } // int, nullable
        public DateTime? ValidFrom { get; set; } // datetime, nullable
        public DateTime? ValidTo { get; set; } // datetime, nullable
        public string MISSequence { get; set; } // varchar(100), nullable
        public bool? IsActive { get; set; } // bit, nullable
        public DateTime? CreatedOn { get; set; } // datetime, nullable
        public DateTime? UpdatedOn { get; set; } // datetime, nullable
        public long MOTRateID { get; set; } // bigint, nullable
        public string ApplicableTo { get; set; } // varchar(500), nullable
        public string Description { get; set; } // varchar(500), nullable
        public Guid? CreatedBy { get; set; } // uniqueidentifier, nullable
        public Guid? UpdatedBy { get; set; } // uniqueidentifier, nullable
        public virtual IList<MOTRateCommissionDetail> Commissions { get; set; }
        public string CommissionJSON { get; set; }
    }
}
