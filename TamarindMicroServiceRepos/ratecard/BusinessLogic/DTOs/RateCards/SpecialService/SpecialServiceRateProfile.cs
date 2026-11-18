namespace TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService
{
    using AutoMapper;
    using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService;
    using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.SpecialService;
    using static System.Runtime.InteropServices.JavaScript.JSType;

    public class SpecialServiceRateProfile : Profile
    {
        public SpecialServiceRateProfile()
        {
            // Flat -> Commission DTO
            CreateMap<GetSpecialServiceSearchResponseDto, SpecialServiceRateCommissionDetailSearch>()
                .ForMember(dest => dest.SpecialServiceRateCommissionID, opt => opt.MapFrom(src => src.SpecialServiceRateCommissionID ?? 0))
                .ForMember(dest => dest.TaxAmount, opt => opt.MapFrom(src => src.TaxAmount))
                .ForMember(dest => dest.TaxPercentage, opt => opt.MapFrom(src => src.TaxPercentage))
                .ForMember(dest => dest.NetAmountIncludingTax, opt => opt.MapFrom(src => src.NetAmountIncludingTax))
                .ForMember(dest => dest.NetAmountExcludingTax, opt => opt.MapFrom(src => src.NetAmountExcludingTax))
                .ForMember(dest => dest.MinimumPax, opt => opt.MapFrom(src => src.MinimumPax))
                .ForMember(dest => dest.MaximumPax, opt => opt.MapFrom(src => src.MaximumPax))
                .ForMember(dest => dest.CommissionMasterID, opt => opt.MapFrom(src => src.CommissionMasterID))
                .ForMember(dest => dest.Ratetype, opt => opt.MapFrom(src => src.Ratetype))
                 .ForMember(dest => dest.NetAmountIncludingTax_Con, opt => opt.MapFrom(src => src.NetAmountIncludingTax_Con))
                .ForMember(dest => dest.NetAmountExcludingTax_Con, opt => opt.MapFrom(src => src.NetAmountExcludingTax_Con));

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
