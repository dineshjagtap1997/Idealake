

using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument
{
    public class GetMonumentRateSearchRequestDto : MonumentRate
    {


        public string CurrencyID { get; set; } // @DisplayRate
        //public RateCardModeType RateCardModeTypeID { get; set; } // @RateCardModeTypeID
        //public TaxPreference TaxID { get; set; } // @TaxID

        public int TaxID { get; set; } // @TaxID
        public string CityID { get; set; } // @CityIata
        public int? MonumentServiceID { get; set; } // @Service
        public int? VendorID { get; set; } // @Vendor
        public int? NationalityID { get; set; } // @NationalityID
        public int? Adult { get; set; } // @Adult
        public int? Child { get; set; } // @Child
        public string ValidFrom { get; set; } // @ValidFrom
        public string ValidTo { get; set; } // @ValidTo


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
        public string MISSequence { get; set; }

        public string Notes { get; set; }

        public long QuotationID { get; set; }

        public string Disclaimer { get; set; }
        public string ReasonID { get; set; }

        public long MonumentDetailID { get; set; }
        public string Nationality { get; set; }

        public List<GetMonumentRateSearchRequestDto> DataList { get; set; }

        public List<GetMonumentRateCommissionDetailResponseDto> Commissions { get; set; }

        public long BookingID { get; set; }
        public long? MonumentRateID { get; set; }


    }
}
