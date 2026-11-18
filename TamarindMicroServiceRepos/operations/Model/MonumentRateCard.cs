using AutoMapper;
//using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;

namespace TamarindAstra_Operations.Model
{
    public class MonumentRateSearchRequest : RateCardBase
    {
        public long? QMID { get; set; }
        public bool? IsSummary { get; set; }

        public string CurrencyID { get; set; } // @DisplayRate
        //public RateCardModeType RateCardModeTypeID { get; set; } // @RateCardModeTypeID
        //public TaxPreference TaxID { get; set; } // @TaxID

        public int TaxID { get; set; } // @TaxID
        public string CityID { get; set; } // @CityIata
        public int MonumentServiceID { get; set; } // @Service
        public int VendorID { get; set; } // @Vendor
        public int? NationalityID { get; set; } // @NationalityID
        public int Adult { get; set; } // @Adult
        public int Child { get; set; } // @Child
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
        public bool Markup_IsRate { get; set; }
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

        public string? Disclaimer { get; set; }
        public string ReasonID { get; set; }

        public long MonumentDetailID { get; set; }
        public string Nationality { get; set; }

        public long MonumentRateID { get; set; }


        public List<MonumentRateCommissionDetail> Commissions { get; set; }
        

        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
    }

    public class MonumentRateCommissionDetail
    {

        public long OthersRateCardCommissionID { get; set; }
        public long MonumentCommissionDetailID { get; set; }
        public long MonumentDetailID { get; set; }
        public int CommissionMasterID { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }

        public decimal GrossRateAdult { get; set; }
        public decimal GrossRateChild { get; set; }

        public bool? Markup_IsRate { get; set; }

        public decimal? MarkupRate { get; set; }


        public string NetRate { get; set; }


        public decimal? SellingRates { get; set; }

        public decimal? GrossRate { get; set; }

        public string Ratetype { get; set; }
        public int AdultReasonId { get; set; }
        public int ChildReasonId { get; set; }

    }

    public class MonumentRateList
    {
        public List<MonumentRateSearchRequest> DataList { get; set; }

        public string Action { get; set; }
        public long MonumentRateID { get; set; }
        public RateCardModeType RateCardModeTypeID { get; set; }
        public string CurrencyID { get; set; }
        public int VendorID { get; set; }
        public int MonumentServiceID { get; set; }
        public string CityID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }
        public string MonumentService { get; set; }

        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public Guid? OperationBy { get; set; }




    }
    public class MonumentRateProfile : Profile
    {
        public MonumentRateProfile()
        {
            //CreateMap<GetMonumentRateSearchResponseDto, GetMonumentRateSearchResponseDto>()
            //    .ForMember(dest => dest.Commissions, opt => opt.Ignore());  // We'll map commissions separately

            CreateMap<GetMonumentRateSearchResponseDto, GetMonumentRateSearchResponseDto>()
            .ForMember(dest => dest.MonumentCommissionDetailID, opt => opt.Ignore())
            .ForMember(dest => dest.CommissionMasterID, opt => opt.Ignore())
            .ForMember(dest => dest.TaxPercentage, opt => opt.Ignore())
            .ForMember(dest => dest.TaxAmount, opt => opt.Ignore())
            .ForMember(dest => dest.NetAmountIncludingTax, opt => opt.Ignore())
            .ForMember(dest => dest.NetAmountExcludingTax, opt => opt.Ignore())
            .ForMember(dest => dest.ValidityDate, opt => opt.Ignore())
            .ForMember(dest => dest.Ratetype, opt => opt.Ignore())
            .ForMember(dest => dest.Commissions, opt => opt.Ignore());

            CreateMap<GetMonumentRateSearchResponseDto, MonumentRateCommissionDetailRequestDto>()
                .ForMember(dest => dest.Ratetype, opt => opt.MapFrom(src => src.Ratetype))
                .ForMember(dest => dest.MonumentCommissionDetailID, opt => opt.MapFrom(src => src.MonumentCommissionDetailID ?? 0))
                .ForMember(dest => dest.TaxAmount, opt => opt.MapFrom(src => src.TaxAmount))
                .ForMember(dest => dest.CommissionMasterID, opt => opt.MapFrom(src => src.CommissionMasterID))
                .ForMember(dest => dest.TaxPercentage, opt => opt.MapFrom(src => src.TaxPercentage))
                .ForMember(dest => dest.NetAmountIncludingTax, opt => opt.MapFrom(src => src.NetAmountIncludingTax))
                .ForMember(dest => dest.NetAmountExcludingTax, opt => opt.MapFrom(src => src.NetAmountExcludingTax));
        }
    }
    public class MonumentRateCommissionDetailRequestDto : MonumentRateCommissionDetail
    {
        public string Ratetype { get; set; }
        public long OthersRateCardCommissionID { get; set; }

    }
    public class GetMonumentRateSearchResponseDto : MonumentRateDetailFlatDto
    {


        public RateCardModeType RateCardModeTypeID { get; set; }

        public string RateCardModeType { get; set; }

        public int TaxID { get; set; }
        public string CurrencyID { get; set; }
        public int VendorID { get; set; }
        public int MonumentServiceID { get; set; }
        public string CityID { get; set; }
        public int StateID { get; set; }
        public long QMID { get; set; }
        public decimal MarkupRate { get; set; }
        public string GstStatus { get; set; }
        public string CityName { get; set; }

        public string Type { get; set; }

        public string CommissionDetailsJson { get; set; }
        

        public string MonumentService { get; set; }
        public string VendorName { get; set; }
        public string PaxRange { get; set; }
        public string Language { get; set; }
        public string Disclaimer { get; set; }
        public string FromToDate { get; set; }


        public int? ReasonID { get; set; }
        public int? QuotationID { get; set; }
        public List<MonumentRateCommissionDetailRequestDto> Commissions { get; set; }

        public decimal? AdultGrossRate { get; set; }
        public int? CountOfAdult { get; set; }
        public decimal? ChildGrossRate { get; set; }
        public int? CountOfChild { get; set; }
        public string QuotationNo { get; set; }

        public int OthersRateCardMasterID { get; set; }
        public int BookID { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        public string QuoCurrency { get; set; }

        public decimal PurchaseRate { get; set; }
        public bool? IsSummary { get; set; }


        public int EnquiryID { get; set; }
        public string EnquiryNo { get; set; }


    }
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

        public decimal? SellingRates { get; set; }

        public decimal? GrossRate { get; set; }
    }
    public class GetAllMonumentRateDetailResponseDto : GetMonumentRateDetailResponseDto
    {
        public string Adult { get; set; }
        public string Child { get; set; }
    }
    public class MonumentRateDetail : RateCardBase
    {
        public long MonumentDetailID { get; set; }
        public long MonumentRateID { get; set; }
        public TaxPreference TaxID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public int NationalityID { get; set; }
        public string MISSequence { get; set; }
        public string Nationality { get; set; }
    }
    public class GetMonumentRateDetailResponseDto : MonumentRateDetail
    {
        public string ValidityDate { get; set; }
        public List<MonumentRateCommissionDetailRequestDto> Commissions { get; set; }
    }
}

