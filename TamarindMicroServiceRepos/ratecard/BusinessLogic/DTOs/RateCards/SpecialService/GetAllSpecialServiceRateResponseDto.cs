using MathNet.Numerics.LinearAlgebra.Factorization;
using NPOI.SS.Formula.Functions;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService
{
    public class SpecialServiceRateDetailFlatDto : SpecialServiceRateDetail
    {
        // Commission fields
        public string Nationality { get; set; }
        public long? SpecialServiceRateCommissionID { get; set; }
        public int CommissionMasterID { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public string ValidityDate { get; set; }
        public string Ratetype { get; set; }
        public string RatePreference { get; set; }
        public int MinimumPax { get; set; }
        public int MaximumPax { get; set; }
    }
    public class GetAllSpecialServiceRateResponseDto : GetSpecialServiceRateDetailResponseDto
    {
        public string SpecialService { get; set; }
        public string VendorName { get; set; }

        public string RateCardMode { get; set; }
        public string MonumentService { get; set; }
        public string City { get; set; }

        public string NetAmountIncludingTax { get; set; }
        public string TaxPercentage { get; set; }
        public string TaxAmount { get; set; }
        public string NetAmountExcludingTax { get; set; }
        public string SellingRate { get; set; }
        public string PaxRange { get; set; }
        public string Language { get; set; }

        public string RateType { get; set; }
    }
}





