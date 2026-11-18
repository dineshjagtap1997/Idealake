using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide
{
    public class GetGuideRateSearchRequestDto : GuideRate
    {
        public int? PaxMaximum { get; set; }

        // public TaxPreference TaxID { get; set; }

        public int TaxID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public long? GuideRateCommissionID { get; set; }
        public decimal? TaxAmount { get; set; }
        public decimal? TaxPercentage { get; set; }
        public int? PaxMinimum { get; set; }
        public decimal? NetAmountIncludingTax { get; set; }
        public decimal? NetAmountExcludingTax { get; set; }
        public string ValidityDate { get; set; }
        public string OthersRateRefrenceID { get; set; }

        public string IsAmtIncludedInBasic { get; set; }

        public string CommissionRefrenceID { get; set; }

        public string CommissionMasterID { get; set; }

        public long ID { get; set; }
        public string Markup_IsRate { get; set; }

        public decimal? MarkupRate { get; set; }
        
        public string NetRate { get; set; }
        public decimal? SellingRates { get; set; }

        public decimal? GrossRate { get; set; }
        public string GrossRateAdult { get; set; }
        public string GrossRateChild { get; set; }

        public string RateID { get; set; }
        public long GuideRateDetailID { get; set; }
        public string MISSequence { get; set; }

        public string Notes { get; set; }

        public int QuotationID { get; set; }

        public string Disclaimer { get; set; }
        public string ReasonID { get; set; }

        public List<GetGuideRateSearchRequestDto> DataList { get; set; }

        public List<GuideRateCommissionDetailRequestDto> Commissions { get; set; }
        public string ValueAddOn { get; set; }

        public string InfoForOperation { get; set; }
        public string InfoForRemark { get; set; }
        public long BookingID { get; set; }
        public long? GuidRateID { get; set; }

    }
}
