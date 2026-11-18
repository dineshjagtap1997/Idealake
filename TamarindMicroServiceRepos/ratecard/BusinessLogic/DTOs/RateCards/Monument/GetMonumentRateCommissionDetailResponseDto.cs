using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument
{
    public class GetMonumentRateCommissionDetailResponseDto : MonumentRateCommissionDetail
    {
        public long MonumentRateID { get; set; }
        public RateCardModeType RateCardModeTypeID { get; set; }
        public string CurrencyID { get; set; }
        public int VendorID { get; set; }
        public int MonumentServiceID { get; set; }
        public string CityID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }

        public TaxPreference TaxID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public int NationalityID { get; set; }
        public string MISSequence { get; set; }

        public string MonumentService { get; set; }
        public string VendorName { get; set; }
        public decimal? SellingRate { get; set; }

        public decimal? GrossRate { get; set; }
        public string PaxRange { get; set; }
        public string Language { get; set; }
        public string Nationality { get; set; }

        public string RateType { get; set; }
    }
}
