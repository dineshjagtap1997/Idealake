using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using static NPOI.HSSF.Util.HSSFColor;
using static NPOI.POIFS.Crypt.CryptoFunctions;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument
{
    public class MonumentRateDetailFlatDto : MonumentRateDetail
    {
        // Commission fields
        public long? MonumentCommissionDetailID { get; set; }
        public int CommissionMasterID { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public string ValidityDate { get; set; }
        public string Ratetype { get; set; }
    }
    public class GetAllMonumentRateDetailResponseDto : GetMonumentRateDetailResponseDto
    {
        public string Adult { get; set; }
        public string Child { get; set; }
    }
}
