namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.MOT
{
    public class MOTRateCommissionDetail : RateCardBase
    {
        public long MotRateCommissionDetailID { get; set; } // bigint, not null
        public long MOTCommissionDetailID { get; set; } // bigint, not null
        public long? MOTRateDetailID { get; set; } // bigint, nullable
        public int? CategoryID { get; set; } // int, nullable
        public decimal? Tax { get; set; } // decimal(18,2), nullable
        public decimal? TaxAmount { get; set; } // decimal(18,2), nullable
        public decimal? NetAmountIncludingTax { get; set; } // decimal(18,2), nullable
        public decimal? NetAmountExcludingTax { get; set; } // decimal(18,2), nullable
        public bool? IsActive { get; set; } // bit, nullable
        public Guid? CreatedBy { get; set; } // int, nullable
        public Guid? UpdatedBy { get; set; } // int, nullable
        public DateTime? CreatedOn { get; set; } // datetime, nullable
        public DateTime? UpdatedOn { get; set; } // datetime, nullable
        public int? CommissionMasterID { get; set; } // int, nullable
        public string RateType { get; set; } // int, nullable

    }
}
