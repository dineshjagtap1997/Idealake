using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT
{
    public class GetMOTRateSearchResponseDto : MOTRateDetailFlatDto
    {


        public RateCardModeType RateCardModeTypeID { get; set; }

        public string RateCardModeType { get; set; }

        public int? TaxID { get; set; }
        public string CurrencyID { get; set; }
        public int? VendorID { get; set; }
        public int? MonumentServiceID { get; set; }
        public string CityID { get; set; }
        public int? StateID { get; set; }
        public string GstStatus { get; set; }
        public string CityName { get; set; }



        public string MonumentService { get; set; }
        public string VendorName { get; set; }
        public string PaxRange { get; set; }
        public string Language { get; set; }
        public string Type { get; set; }
        public string MOTType { get; set; }
        public string ClassType { get; set; }

        public List<MOTRateCommissionDetailSearch> Commissions { get; set; }
        public string CommissionJSON { get; set; }
        public string InfoForOperation { get; set; }
        public string InfoForRemark { get; set; }
        public int? XORemark { get; set; }
        public string XORemarkName { get; set; }

        public decimal NetAmountIncludingTax_Con { get; set; }
        public decimal NetAmountExcludingTax_Con { get; set; }

    }

    public class MOTRateCommissionDetailSearch : CreateMOTRateCommissionDetailRequestDto
    {
        public decimal NetAmountIncludingTax_Con { get; set; }
        public decimal NetAmountExcludingTax_Con { get; set; }
    }


}
