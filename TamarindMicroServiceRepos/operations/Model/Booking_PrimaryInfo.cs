using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TamarindAstra_Operations.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class Booking_PrimaryInfo
    {
        [Key]
        public int ID { get; set; }

        [Required]
        [StringLength(200)]
        public string PaxName { get; set; }

        [Required]
        [StringLength(30)]
        public string MobileNO { get; set; }

        [StringLength(200)]
        public string? PaxEmailID { get; set; }

        [Required]
        public int Numberofpax { get; set; }

        [Required]
        public DateTime StartDate { get; set; }

        [Required]
        public DateTime EndDate { get; set; }

        [StringLength(500)]
        public string? BizVirticale { get; set; }

        public int? DepartmentID { get; set; }

        [Required]
        public DateTime BookingCreationDate { get; set; }

        [StringLength(500)]
        public string? GusetNationality { get; set; }

        public bool? PrePone { get; set; }

        public DateTime? PrePoneDate { get; set; }

        public bool? AgentInvoiceReq { get; set; }

        public string? Reason { get; set; } // varchar(max)

        [StringLength(50)]
        public string? PacageCode { get; set; }

        [StringLength(500)]
        public string? PrmSrvcLoc { get; set; }

        [StringLength(50)]
        public string? Origin { get; set; }

        [StringLength(500)]
        public string? OnlineBookingID { get; set; }

        public bool? FIT { get; set; }

        public bool? SupplierTax_B2b { get; set; }

        public bool? SupplierTax_InCluding { get; set; }

        public bool? MarkupType_Gross { get; set; }

        public int? AgentID { get; set; }

        public int? MarketID { get; set; }

        [StringLength(3)]
        public string? CityIATACode { get; set; }

        public string? BillingAddress { get; set; } // varchar(max)

        [StringLength(20)]
        public string? PANNo { get; set; }

        [StringLength(20)]
        public string? GSTNo { get; set; }

        [StringLength(20)]
        public string? TANNo { get; set; }

        [StringLength(20)]
        public string? SEZ { get; set; }

        public bool? FreeZone { get; set; }

        public bool? AgentOnCredit { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal? CreditAmount { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal? OutStandingAmount { get; set; }

        public int? DBL { get; set; }

        public int? EBA { get; set; }

        public int? EBC { get; set; }

        public int? CNB { get; set; }

        public int? SGL { get; set; }
        public int? taxID { get; set; }

        public string? UserNote1 { get; set; }

        public string? UserNote2 { get; set; }

        public Guid? CreatedBy { get; set; }

        [Required]
        public DateTime CreatedOn { get; set; }

        public Guid? ModifiedBy { get; set; }

        public DateTime? ModifiedOn { get; set; }
    }
}
