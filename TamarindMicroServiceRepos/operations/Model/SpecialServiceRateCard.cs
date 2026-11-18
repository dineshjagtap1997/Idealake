



using AutoMapper;

namespace TamarindAstra_Operations.Model
{


    public class SpecialServiceRequest : SpecialServiceRate
    {
        public long SpecialServiceRateDetailID { get; set; }
        public bool? IsSummary { get; set; }
        public long QSSMID { get; set; }
        public int TaxID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public int NationalityID { get; set; }
        public int? Adult { get; set; }
        public int? Child { get; set; }
        public decimal? GrossRate { get; set; }

        public int? PaxMinimum { get; set; }

        public string OthersRateRefrenceID { get; set; }

        public string IsAmtIncludedInBasic { get; set; }


        public long ID { get; set; }
        public string Markup_IsRate { get; set; }
        public decimal? MarkupRate { get; set; }
        public string NetRate { get; set; }
        public decimal? SellingRates { get; set; }
        public string GrossRateAdult { get; set; }
        public string GrossRateChild { get; set; }

        public string RateID { get; set; }
        public long GuideRateDetailID { get; set; }
        public string MISSequence { get; set; }

        public string Notes { get; set; }

        public long QuotationID { get; set; }

        public string Disclaimer { get; set; }
        public string ReasonID { get; set; }

        public decimal? SellingRate { get; set; }


        public List<SpecialServiceRateCommissionDetail> Commissions { get; set; }


        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
    }
    public class SpecialServiceRateCommissionDetail
    {
        public long OthersRateCardCommissionID { get; set; }
        public long SpecialServiceRateDetailID { get; set; }
        public long SpecialServiceRateCommissionID { get; set; }
        public int MinimumPax { get; set; }
        public int MaximumPax { get; set; }
        public decimal TaxPercentage { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal NetAmountIncludingTax { get; set; }
        public decimal NetAmountExcludingTax { get; set; }
        public int CommissionMasterID { get; set; }

        public decimal GrossRate { get; set; }

        public decimal SellingRates { get; set; }

        public bool? Markup_IsRate { get; set; }
        public decimal? MarkupRate { get; set; }
        public bool IsActive { get; set; }

        public string RateType { get; set; }
        public string PaxRange { get; set; }
        public int AdultReasonId { get; set; }
        public int ChildReasonId { get; set; }
    }

    public class SpecialServiceList
    {
        public List<SpecialServiceRequest> DataList { get; set; }
        public string Action { get; set; }

    }
    public class SpecialServiceRate : RateCardBase
    {
        public long SpecialServiceRateID { get; set; }
        public int SpecialServiceID { get; set; }
        public RateCardModeType RateCardModeTypeID { get; set; }
        public string CityID { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }
        public int HotelID { get; set; }
        public string CurrencyID { get; set; }
        public int VendorID { get; set; }
        public int HrsPerDay { get; set; }
        public int KmPerDay { get; set; }
        public string SpecialService { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }


    }
    public class GetSpecialServiceSearchResponseDto
    {

        //public long SpecialServiceRateCommissionID { get; set; }
        public long SpecialServiceRateDetailID { get; set; }
        public long QSSMID { get; set; }
        public int SpecialServiceID { get; set; }
        //public RateCardModeType RateCardModeTypeID { get; set; }

        public int TaxID { get; set; }
        public string CityID { get; set; }
        public string City { get; set; }
        public string Nationality { get; set; }
        public string TransportService { get; set; }
        public int StateID { get; set; }
        public string GstStatus { get; set; }
        public int HotelID { get; set; }
        public string CurrencyID { get; set; }
        public int VendorID { get; set; }
        public int HrsPerDay { get; set; }
        public int KmPerDay { get; set; }
        public string PaxRange { get; set; }
        public string Language { get; set; }
        public string RateType { get; set; }
        public string SpecialService { get; set; }
        public string MonumentService { get; set; }
        public decimal? SellingRate { get; set; }

        public decimal? GrossRate { get; set; }
        public decimal? MarkupRate { get; set; }

        public string VendorName { get; set; }
        public string SpecialServiceRateCommissionDetails { get; set; }
        public List<GetSpecialServiceRateCommissionDetailResponseDto> Commissions { get; set; }


        ////
        ///
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



        public long SpecialServiceRateID { get; set; }
        //public TaxPreference TaxID { get; set; }
        public string ValidFrom { get; set; }
        public string ValidTo { get; set; }
        public int NationalityID { get; set; }
        public RatePreference RatePreferenceID { get; set; }
        public string MISSequence { get; set; }

        public string Action { get; set; }
        public string Heading { get; set; }
        public string CardNumber { get; set; }
        public string ContractDate { get; set; }
        public bool? IsActive { get; set; }
        public string CreatedBy { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedOn { get; set; }
        public string CreatedOn { get; set; }
        public string InfoForOperation { get; set; }
        public string InfoForAgent { get; set; }
        public string InfoForRemark { get; set; }
        public int TotalCount { get; set; }
        public bool HasRules { get; set; } = true;
        public bool HasDocument { get; set; } = true;
        public Guid OperationBy { get; set; }
        //use for filter

        public string Vendor { get; set; }
        public string Currency { get; set; }
        public string RateCardMode { get; set; }
        public string RateCardModeType { get; set; }
        public string HotelName { get; set; }
        public string Active { get; set; }
        public string Disclaimer { get; set; }

        public string? FromToDate { get; set; }
        public long? QuotationID { get; set; }
        public int? ReasonID { get; set; }
        public int RateCardModeTypeID { get; set; }

        public string RateCardType { get; set; }
        public string Type { get; set; }
        public int? Adult { get; set; }
        public decimal? AdultGrossRate { get; set; }
        public int? PerPersonChild { get; set; }
        public decimal? ChildGrossRate { get; set; }
        public int? Consolidated { get; set; }
        public decimal? ConsolidateGrossRate { get; set; }
        public string QuotationNo { get; set; }
        public string QuoCurrency { get; set; }

        public decimal PurchaseRate { get; set; }
        public bool? IsSummary { get; set; }

        public int OthersRateCardMasterID { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        public int EnquiryID { get; set; }

        public string EnquiryNo { get; set; }


    }

    public class GetSpecialServiceRateCommissionDetailResponseDto : SpecialServiceRateCommissionDetail
    {
        public string Ratetype { get; set; }
        public long OthersRateCardCommissionID { get; set; }
    }
    public class SpecialServiceRateProfile : Profile
    {
        public SpecialServiceRateProfile()
        {
            // Flat -> Commission DTO
            CreateMap<GetSpecialServiceSearchResponseDto, GetSpecialServiceRateCommissionDetailResponseDto>()
                .ForMember(dest => dest.SpecialServiceRateCommissionID, opt => opt.MapFrom(src => src.SpecialServiceRateCommissionID ?? 0))
                .ForMember(dest => dest.TaxAmount, opt => opt.MapFrom(src => src.TaxAmount))
                .ForMember(dest => dest.TaxPercentage, opt => opt.MapFrom(src => src.TaxPercentage))
                .ForMember(dest => dest.NetAmountIncludingTax, opt => opt.MapFrom(src => src.NetAmountIncludingTax))
                .ForMember(dest => dest.NetAmountExcludingTax, opt => opt.MapFrom(src => src.NetAmountExcludingTax))
                .ForMember(dest => dest.MinimumPax, opt => opt.MapFrom(src => src.MinimumPax))
                .ForMember(dest => dest.MaximumPax, opt => opt.MapFrom(src => src.MaximumPax))
                .ForMember(dest => dest.CommissionMasterID, opt => opt.MapFrom(src => src.CommissionMasterID))
                .ForMember(dest => dest.Ratetype, opt => opt.MapFrom(src => src.Ratetype));

            // Flat -> Grouped Response DTO (commissions handled manually)
            CreateMap<GetSpecialServiceSearchResponseDto, GetSpecialServiceSearchResponseDto>()
                .ForMember(dest => dest.Commissions, opt => opt.Ignore()) // handled with grouping logic manually
                .ForMember(dest => dest.SpecialServiceRateCommissionID, opt => opt.Ignore()) // to avoid copying unintended values
                .ForMember(dest => dest.TaxAmount, opt => opt.Ignore()) // avoid copying extra commission fields
                .ForMember(dest => dest.TaxPercentage, opt => opt.Ignore())
                .ForMember(dest => dest.NetAmountIncludingTax, opt => opt.Ignore())
                .ForMember(dest => dest.NetAmountExcludingTax, opt => opt.Ignore())
                .ForMember(dest => dest.MinimumPax, opt => opt.Ignore())
                .ForMember(dest => dest.MaximumPax, opt => opt.Ignore())
                .ForMember(dest => dest.CommissionMasterID, opt => opt.Ignore())
                .ForMember(dest => dest.Ratetype, opt => opt.Ignore());
        }
    }

}

