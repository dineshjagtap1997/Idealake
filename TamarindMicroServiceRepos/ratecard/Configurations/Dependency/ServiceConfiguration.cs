using TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Hotel.CancellationPolicy;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.HotelOffer;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Transport;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.Factory;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel.CancellationPolicy;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.HotelOffer;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Transport;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Rule;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Mappers.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.Configurations.Dependency
{
    public static class ServiceConfiguration
    {
        public static IServiceCollection AddServices(this IServiceCollection services)
        {
            //----------------Mapper---------------
            services.AddScoped<IHotelRateCardValidityMapper, HotelRateCardValidityMapper>();
            services.AddScoped<IHotelRateCardCommissionMapper, HotelRateCardCommissionMapper>();
            //----------------Ratecard logic---------------------
            services.AddScoped<IGetRateCardFactory, GetRateCardFactory>();
            services.AddTransient<ICreateRateCardFactory, CreateRateCardFactory>();
            services.AddScoped<IUpdateRateCardFactory, UpdateRateCardFactory>();
            //------------Hotel-------------------
            services.AddTransient<ICreateHotelRateRepository, CreateHotelRateRepository>();
            services.AddScoped<IGetHotelRateCardRepository, GetHotelRateCardRepository>();
            services.AddScoped<IUpdateHotelRateRepository, UpdateHotelRateRepository>();
            //------------Guide------------------
            services.AddScoped<ICreateGuideRateRepository, CreateGuideRateRepository>();
            services.AddScoped<IGetGuideRateRepository, GetGuideRateRepository>();
            //------------MOT-----------------------
            services.AddScoped<ICreateMOTRateRepository, CreateMOTRateRepository>();
            services.AddScoped<IGetMOTRateRepository, GetMOTRateRepository>();
            services.AddScoped<IUpdateMOTRateRepository, UpdateMOTRateRepository>();
            //--------------Monument------------------------
            services.AddScoped<ICreateMonumentRateRepository, CreateMonumentRateRepository>();
            services.AddScoped<IUpdateMonumentRateRepository, UpdateMonumentRateRepository>();
            services.AddScoped<IGetMonumentRateRepository, GetMonumentRateRepository>();
            //--------------Special Service------------------------
            services.AddScoped<ICreateSpecialServiceRateRepository, CreateSpecialServiceRateRepository>();
            services.AddScoped<IUpdateSpecialServiceRateRepository, UpdateSpecialServiceRateRepository>();
            services.AddScoped<IGetSpecialServiceRateRepository, GetSpecialServiceRateRepository>();

            services.AddScoped<IRateRulesRepository, RateRulesRepository>();
            services.AddScoped<IRateRuleLogic, RateRuleLogic>();

            //-------------------Transport-----------------------
            services.AddScoped<IGetTransportRateRepository, GetTransportRateRepository>();
            services.AddScoped<ICreateTransportRateRepository, CreateTransportRateRepository>();
            services.AddScoped<IUpdateTransportRateRepository, UpdateTransportRateRepository>();
            services.AddScoped<ICreateHotelRatePolicyRepository, CreateHotelRatePolicyRepository>();
            services.AddScoped<IGetHotelRatePolicyRepository, GetHotelRatePolicyRepository>();
            services.AddScoped<IUpdateHotelRatePolicyRepository, UpdateHotelRatePolicyRepository>();
            //---------------------------Hotel Offer---------------------
            services.AddScoped<ICreateHotelOfferRateRepository, CreateHotelOfferRateRepository>();
            services.AddScoped<IUpdateHotelOfferRateRepository, UpdateHotelOfferRateRepository>();
            services.AddScoped<IGetHotelOfferRateRepository, GetHotelOfferRateRepository>();
            return services;
        }
    }
}
