using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel
{
    public class HotelRateCommissionSearch : RateCardBase
    {
        public long RateCommissionID { get; set; }
        public int MasterCommissionID { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal GrossAmountIncludingTax { get; set; }
        public decimal GrossAmountExcludingTax { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public decimal GrossAmountIncludingTax_Con { get; set; }
        public decimal GrossAmountExcludingTax_Con { get; set; }
        public decimal NetAmountIncludingTax_Con { get; set; }
        public decimal NetAmountExcludingTax_Con { get; set; }
        public decimal CommissionPercentage { get; set; }
        public decimal CommissionAmount { get; set; }
        public decimal CommissionAmount_Con { get; set; }
        public long HotelRateDetailID { get; set; }
        public bool IsTax { get; set; }
        public string RateType { get; set; }
    }


    public class HotelRateMealSearchResponse:HotelRateMealResponseDto
        {
        public decimal NetAmountIncludingTax_Con { get; set; }
        public decimal NetAmountExcludingTax_Con { get; set; }
    }



}
