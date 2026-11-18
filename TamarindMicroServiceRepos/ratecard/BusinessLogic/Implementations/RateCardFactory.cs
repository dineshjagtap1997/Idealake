using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
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
using TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.HotelOffer;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Transport;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations
{
    public class CreateRateCardFactory : ICreateRateCardFactory
    {
        private readonly ICreateHotelRateRepository _createHotelRateCardRepository;
        private readonly ICreateMonumentRateRepository _createMonumentRateRepository;
        private readonly ICreateSpecialServiceRateRepository _createSpecialServiceRateRepository;
        private readonly ICreateGuideRateRepository _createGuideRateRepository;
        private readonly ICreateTransportRateRepository _createTransportRateRepository;
        private readonly ICreateHotelRatePolicyRepository _createHotelRatePolicyRepository;
        private readonly ICreateHotelOfferRateRepository _createHotelOfferRateRepository;
        private readonly ICreateMOTRateRepository _createMOTRateRepository;

        public CreateRateCardFactory() { }
        public CreateRateCardFactory(
            ICreateHotelRateRepository createHotelRateCardRepository,
            ICreateGuideRateRepository createGuideRateRepository,
            ICreateMonumentRateRepository createMonumentRateRepository,
            ICreateMOTRateRepository createMOTRateRepository,
            ICreateSpecialServiceRateRepository createSpecialServiceRateRepository,
            ICreateTransportRateRepository createTransportRateRepository,
            ICreateHotelRatePolicyRepository createHotelRatePolicyRepository,
            ICreateHotelOfferRateRepository createHotelOfferRateRepository)
        {
            _createGuideRateRepository = createGuideRateRepository;
            _createHotelRateCardRepository = createHotelRateCardRepository;
            _createMonumentRateRepository = createMonumentRateRepository;
            _createMOTRateRepository = createMOTRateRepository;
            _createSpecialServiceRateRepository = createSpecialServiceRateRepository;
            _createTransportRateRepository = createTransportRateRepository;
            _createHotelRatePolicyRepository = createHotelRatePolicyRepository;
            _createHotelOfferRateRepository = createHotelOfferRateRepository;
        }

        public ICreateRateCardLogic Create(RateCardType type)
        {
            return type switch
            {
                RateCardType.Hotel => new CreateHotelRateCardLogic(_createHotelRateCardRepository, _createHotelRatePolicyRepository),
                RateCardType.Guide => new CreateGuideRateCardLogic(_createGuideRateRepository),
                RateCardType.Monument => new CreateMonumentRateLogic(_createMonumentRateRepository),
                RateCardType.SpecialService => new CreateSpecialServiceRateLogic(_createSpecialServiceRateRepository),
                RateCardType.Transport => new CreateTransportRateLogic(_createTransportRateRepository),
                RateCardType.MOT => new CreateMOTRateCardLogic(_createMOTRateRepository),
                RateCardType.HotelOffer => new CreateHotelOfferRateLogic(_createHotelOfferRateRepository),
                _ => throw new ArgumentException($"RateCardType {type} is not supported."),
            };
        }
    }

    public class GetRateCardFactory : IGetRateCardFactory
    {
        private readonly IGetHotelRateCardRepository _getHotelRateCardRepository;
        private readonly IGetGuideRateRepository _getGuideRateRepository;
        private readonly IGetMonumentRateRepository _getMonumentRateRepository;
        private readonly IGetMOTRateRepository _getMOTRateRepository;
        private readonly IGetSpecialServiceRateRepository _getSpecialServiceRateRepository;
        private readonly IGetHotelRatePolicyRepository _getHotelRatePolicyRepository;
        private readonly IGetTransportRateRepository _getTransportRateRepository;
        private readonly IGetHotelOfferRateRepository _getHotelOfferRateRepository;
        public GetRateCardFactory() { }
        public GetRateCardFactory(
            IGetHotelRateCardRepository getHotelRateCardRepository,
            IGetGuideRateRepository getGuideRateRepository,
            IGetMonumentRateRepository getMonumentRateRepository,
            IGetMOTRateRepository getMOTRateRepository,
            IGetSpecialServiceRateRepository getSpecialServiceRateRepository,
            IGetHotelRatePolicyRepository getHotelRatePolicyRepository,
            IGetTransportRateRepository getTransportRateRepository,
            IGetHotelOfferRateRepository getHotelOfferRateRepository)
        {
            _getHotelRateCardRepository = getHotelRateCardRepository;
            _getGuideRateRepository = getGuideRateRepository;
            _getMonumentRateRepository = getMonumentRateRepository;
            _getMOTRateRepository = getMOTRateRepository;
            _getSpecialServiceRateRepository = getSpecialServiceRateRepository;
            _getHotelRatePolicyRepository = getHotelRatePolicyRepository;
            _getTransportRateRepository = getTransportRateRepository;
            _getHotelOfferRateRepository = getHotelOfferRateRepository;
        }
        public IGetRateCardLogic Create(RateCardType type)
        {
            return type switch
            {
                RateCardType.Hotel => new GetHotelRateCardLogic(_getHotelRateCardRepository, _getHotelRatePolicyRepository),
                RateCardType.Guide => new GetGuideRateCardLogic(_getGuideRateRepository),
                RateCardType.Monument => new GetMonumentRateLogic(_getMonumentRateRepository),
                RateCardType.MOT => new GetMOTRateCardLogic(_getMOTRateRepository),
                RateCardType.SpecialService => new GetSpecialServiceRateLogic(_getSpecialServiceRateRepository),
                RateCardType.Transport => new GetTransportRateLogic(_getTransportRateRepository),
                RateCardType.HotelOffer => new GetHotelOfferRateLogic(_getHotelOfferRateRepository),
                _ => throw new ArgumentException($"RateCardType {type} is not supported."),
            };
        }
    }

    public class UpdateRateCardFactory : IUpdateRateCardFactory
    {
        private readonly IUpdateHotelRateRepository _updateHotelRateRepository = new UpdateHotelRateRepository();
        private readonly IUpdateMonumentRateRepository _updateMonumentRateRepository = new UpdateMonumentRateRepository();
        private readonly IUpdateMOTRateRepository _updateMOTRateRepository = new UpdateMOTRateRepository();
        private readonly IUpdateSpecialServiceRateRepository _updateSpecialServiceRateRepository = new UpdateSpecialServiceRateRepository();
        private readonly IUpdateGuideRateRepository _updateGuideRateRepository = new UpdateGuideRateRepository();
        private readonly IUpdateTransportRateRepository _updateTransportRateRepository = new UpdateTransportRateRepository();
        private readonly IUpdateHotelRatePolicyRepository _updateHotelRatePolicyRepository = new UpdateHotelRatePolicyRepository();
        private readonly IUpdateHotelOfferRateRepository _updateHotelOfferRateRepository = new UpdateHotelOfferRateRepository();

        public UpdateRateCardFactory() { }

        public IUpdateRateCardLogic Create(RateCardType type)
        {
            return type switch
            {
                RateCardType.Hotel => new UpdateHotelRateCardLogic(_updateHotelRateRepository, _updateHotelRatePolicyRepository),
                RateCardType.Monument => new UpdateMonumentRateLogic(_updateMonumentRateRepository),
                RateCardType.MOT => new UpdateMOTRateCardLogic(_updateMOTRateRepository),
                RateCardType.SpecialService => new UpdateSpecialServiceRateLogic(_updateSpecialServiceRateRepository),
                RateCardType.Guide => new UpdateGuideRateCardLogic(_updateGuideRateRepository),
                RateCardType.Transport => new UpdateTransportRateLogic(_updateTransportRateRepository),
                RateCardType.HotelOffer => new UpdateHotelOfferRateLogic(_updateHotelOfferRateRepository),
                _ => throw new ArgumentException($"RateCardType {type} is not supported."),
            };
        }
    }
}
