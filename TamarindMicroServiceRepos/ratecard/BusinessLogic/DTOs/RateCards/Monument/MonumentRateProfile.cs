namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument
{
    using AutoMapper;

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

            CreateMap<GetMonumentRateSearchResponseDto, MonumentRateCommissionDetailSearch>()
                .ForMember(dest => dest.Ratetype, opt => opt.MapFrom(src => src.Ratetype))
                .ForMember(dest => dest.MonumentCommissionDetailID, opt => opt.MapFrom(src => src.MonumentCommissionDetailID ?? 0))
                .ForMember(dest => dest.TaxAmount, opt => opt.MapFrom(src => src.TaxAmount))
                .ForMember(dest => dest.CommissionMasterID, opt => opt.MapFrom(src => src.CommissionMasterID))
                .ForMember(dest => dest.TaxPercentage, opt => opt.MapFrom(src => src.TaxPercentage))
                .ForMember(dest => dest.NetAmountIncludingTax, opt => opt.MapFrom(src => src.NetAmountIncludingTax))
                .ForMember(dest => dest.NetAmountExcludingTax, opt => opt.MapFrom(src => src.NetAmountExcludingTax))
                .ForMember(dest => dest.NetAmountIncludingTax_Con, opt => opt.MapFrom(src => src.NetAmountIncludingTax_Con))
                .ForMember(dest => dest.NetAmountExcludingTax_Con, opt => opt.MapFrom(src => src.NetAmountExcludingTax_Con));
        }
    }

}
