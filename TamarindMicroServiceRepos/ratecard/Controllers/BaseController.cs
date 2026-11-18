using CommonClass;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel.CancellationPolicy;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.HotelOffer;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.Factory;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Rule;

namespace TamarindAstra.WebApi.RateCards.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BaseController : ControllerBase
    {
        private readonly IGetRateCardFactory _getRateCardFactory;
        private readonly ICreateRateCardFactory _createRateCardFactory;
        private readonly IUpdateRateCardFactory _updateRateCardFactory;
        private readonly IRateRuleLogic _rateRuleLogic;

        public BaseController() { }
        public BaseController(IGetRateCardFactory getRateCardFactory,
        ICreateRateCardFactory createRateCardFactory,
        IUpdateRateCardFactory updateRateCardFactory,
        IRateRuleLogic rateRuleLogic)
        {
            _getRateCardFactory = getRateCardFactory;
            _createRateCardFactory = createRateCardFactory;
            _updateRateCardFactory = updateRateCardFactory;
            _rateRuleLogic = rateRuleLogic;
        }

        #region Rate Cancellation Policy
        protected async Task<ResponseModel> RateCancellationPolicyFactoryAsync(RateCardType type, RequestModel request)
        {
            var getFactory = _getRateCardFactory.Create(type);
            if (type == RateCardType.Hotel)
            {
                HotelRateCancellationPolicyDto cancellationPolicyDto = CommonHelper.DecryptAndDeserialize<string, HotelRateCancellationPolicyDto>(request.RequestText);
                if (cancellationPolicyDto.Action.Equals("S") && cancellationPolicyDto.RateCardID > 0 && cancellationPolicyDto.PolicyID == 0)
                {
                    return await getFactory.GetAllRateCancellationPolicyAsync(request);
                }
                else if (cancellationPolicyDto.Action.Equals("S") && cancellationPolicyDto.PolicyID > 0)
                {
                    return await getFactory.GetRateCancellationPolicyByIDAsync(request);
                }
                else if (cancellationPolicyDto.Action.Equals("U"))
                {
                    var updateFactory = _updateRateCardFactory.Create(type);
                    return await updateFactory.UpdateRateCancellationPolicyAsync(request);
                }
                var createFactory = _createRateCardFactory.Create(type);
                return await createFactory.CreateRateCancellationPolicyAsync(request);
            }
            return null;
        }
        #endregion

        #region Rate Rule
        protected async Task<ResponseModel> RateRuleFactoryAsync(RateCardType rateCardType, RequestModel request)

        {
            RateRuleRequestDto rateRuleRequest = CommonHelper.DecryptAndDeserialize<string, RateRuleRequestDto>(request.RequestText);
            rateRuleRequest.RateCardTypeID = rateCardType;
            if (rateRuleRequest.Action.Equals("I"))
            {
                return await _rateRuleLogic.CreateRateRuleAsync(request, (int)rateCardType);
            }
            else if (rateRuleRequest.Action.Equals("U"))
            {
                return await _rateRuleLogic.UpdateRateRuleAsync(request, (int)rateCardType);
            }
            else if (rateRuleRequest.Action.Equals("S") && rateRuleRequest.ID > 0)
            {
                return await _rateRuleLogic.GetRateRuleByIDAsync(rateRuleRequest.ID, (int)rateCardType);
            }
            else
            {
                return await _rateRuleLogic.GetRateRuleAsync(rateRuleRequest.RateCardID, (int)rateCardType);
            }
        }
        #endregion

        #region Rate Card Detail
        protected async Task<ResponseModel> RateCardDetailFactoryAsync(RateCardType type, RequestModel request)
        {
            if (type == RateCardType.Hotel)
            {
                HotelRateDetailRequestDto hotelRateCardDetail = CommonHelper.DecryptAndDeserialize<string, HotelRateDetailRequestDto>(request.RequestText);
                return await RateCardDetailAsync(
                    hotelRateCardDetail.Action, hotelRateCardDetail.HotelRateID, hotelRateCardDetail.HotelRateDetailID,
                    hotelRateCardDetail.PageNumber, hotelRateCardDetail.PageSize, type, request);
            }
            else if (type == RateCardType.Guide)
            {
                GuideRateDetailRequestDto guideRateCardDetail = CommonHelper.DecryptAndDeserialize<string, GuideRateDetailRequestDto>(request.RequestText);
                return await RateCardDetailAsync(
                    guideRateCardDetail.Action, guideRateCardDetail.GuideRateID, guideRateCardDetail.GuideRateDetailID,
                    guideRateCardDetail.PageNumber, guideRateCardDetail.PageSize, type, request);
            }
            else if (type == RateCardType.SpecialService)
            {
                SpecialServiceDetailRequestDto specialServiceRateCardDetail = CommonHelper.DecryptAndDeserialize<string, SpecialServiceDetailRequestDto>(request.RequestText);
                return await RateCardDetailAsync(
                    specialServiceRateCardDetail.Action, specialServiceRateCardDetail.SpecialServiceRateID, specialServiceRateCardDetail.SpecialServiceRateDetailID,
                    specialServiceRateCardDetail.PageNumber, specialServiceRateCardDetail.PageSize, type, request);
            }
            else if (type == RateCardType.Monument)
            {
                MonumentRateDetailRequestDto monumentRateCardDetail = CommonHelper.DecryptAndDeserialize<string, MonumentRateDetailRequestDto>(request.RequestText);
                return await RateCardDetailAsync(
                    monumentRateCardDetail.Action, monumentRateCardDetail.MonumentRateID, monumentRateCardDetail.MonumentDetailID,
                    monumentRateCardDetail.PageNumber, monumentRateCardDetail.PageSize, type, request);
            }
            else if (type == RateCardType.MOT)
            {
                CreateMOTRateDetailRequestDto MOTRateCardDetail = CommonHelper.DecryptAndDeserialize<string, CreateMOTRateDetailRequestDto>(request.RequestText);
                return await RateCardDetailAsync(
                    MOTRateCardDetail.Action, MOTRateCardDetail.MOTRateID, MOTRateCardDetail.MOTRateDetailID,
                    MOTRateCardDetail.PageNumber, MOTRateCardDetail.PageSize, type, request);
            }
            else if (type == RateCardType.Transport)
            {
                TransportRateDetailRequestDto transportRateCardDetail = CommonHelper.DecryptAndDeserialize<string, TransportRateDetailRequestDto>(request.RequestText);
                return await RateCardDetailAsync(
                    transportRateCardDetail.Action, transportRateCardDetail.TransportRateID, transportRateCardDetail.TransportRateDetailID,
                    transportRateCardDetail.PageNumber, transportRateCardDetail.PageSize, type, request);
            }
            return null;
        }
        private async Task<ResponseModel> RateCardDetailAsync(string action, long id, long detailID, int pageNumber, int pageSize, RateCardType type, RequestModel request)
        {
            if (action.Equals("S", StringComparison.OrdinalIgnoreCase) && id > 0)
            {
                return await GetAllRateDetailAsync(type, id, pageNumber, pageSize);
            }
            else if (action.Equals("S", StringComparison.OrdinalIgnoreCase) && id > detailID)
            {
                return await GetRateDetailByIDAsync(type, detailID);
            }
            else if (action.Equals("U", StringComparison.OrdinalIgnoreCase))
            {
                return await UpdateRateDetailAsync(type, request);
            }
            return await CreateRateDetailAsync(type, request);
        }
        private async Task<ResponseModel> CreateRateDetailAsync(RateCardType type, RequestModel request)
        {
            var createFactory = _createRateCardFactory.Create(type);
            return await createFactory.CreateRateDetailAsync(request);
        }

        protected async Task<ResponseModel> CreateRateCardCopyFactoryAsync(RateCardType type, RequestModel request)
        {
            var createFactory = _createRateCardFactory.Create(type);
            return await createFactory.CreateRateCopyAsync(request);
        }

        private async Task<ResponseModel> UpdateRateDetailAsync(RateCardType type, RequestModel request)
        {
            var updateFactory = _updateRateCardFactory.Create(type);
            return await updateFactory.UpdateRateDetailAsync(request);
        }
        private async Task<ResponseModel> GetAllRateDetailAsync(RateCardType type, long id, int pageNumber, int pageSize)
        {
            var getFactory = _getRateCardFactory.Create(type);
            return await getFactory.GetAllRateDetailsByIDAsync(id, pageNumber, pageSize);
        }
        private async Task<ResponseModel> GetRateDetailByIDAsync(RateCardType type, long id)
        {
            var getFactory = _getRateCardFactory.Create(type);
            return await getFactory.GetRateDetailByIDAsync(id);
        }
        #endregion

        #region Rate Card
        protected async Task<ResponseModel> RateCardFactoryAsync(RateCardType type, RequestModel request)
        {

            if (type == RateCardType.Hotel)
            {
                HotelRateRequestDto hotelRateCard = CommonHelper.DecryptAndDeserialize<string, HotelRateRequestDto>(request.RequestText);
                return await RateCardAsync(hotelRateCard.Action, hotelRateCard.HotelRateID, type, request);
            }
            else if (type == RateCardType.Guide)
            {
                GuideRateRequestDto guideRateCard = CommonHelper.DecryptAndDeserialize<string, GuideRateRequestDto>(request.RequestText);
                return await RateCardAsync(guideRateCard.Action, guideRateCard.GuideRateID, type, request);
            }
            else if (type == RateCardType.SpecialService)
            {
                SpecialServiceRateRequestDto specialServiceRateCard = CommonHelper.DecryptAndDeserialize<string, SpecialServiceRateRequestDto>(request.RequestText);
                return await RateCardAsync(specialServiceRateCard.Action, specialServiceRateCard.SpecialServiceRateID, type, request);
            }
            else if (type == RateCardType.Monument)
            {
                MonumentRateRequestDto monumentRateCard = CommonHelper.DecryptAndDeserialize<string, MonumentRateRequestDto>(request.RequestText);
                return await RateCardAsync(monumentRateCard.Action, monumentRateCard.MonumentRateID, type, request);
            }
            else if (type == RateCardType.MOT)
            {
                CreateMOTRateRequestDto MOTRateCard = CommonHelper.DecryptAndDeserialize<string, CreateMOTRateRequestDto>(request.RequestText);
                return await RateCardAsync(MOTRateCard.Action, MOTRateCard.ID, type, request);
            }
            else if (type == RateCardType.HotelOffer)
            {
                HotelOfferRequestDto hotelOffer = CommonHelper.DecryptAndDeserialize<string, HotelOfferRequestDto>(request.RequestText);
                return await RateCardAsync(hotelOffer.Action, hotelOffer.HotelOfferID, type, request);
            }
            else
            {
                TransportRateRequestDto transportRateCard = CommonHelper.DecryptAndDeserialize<string, TransportRateRequestDto>(request.RequestText);
                return await RateCardAsync(transportRateCard.Action, transportRateCard.TransportRateID, type, request);
            }
        }
        private async Task<ResponseModel> RateCardAsync(string action, long ID, RateCardType type, RequestModel request)
        {
            if (action.Equals("S", StringComparison.OrdinalIgnoreCase) && ID == 0)
            {
                return await GetAllRateCardsAsync(type, request);
            }
            else if (action.Equals("S", StringComparison.OrdinalIgnoreCase) && ID > 0)
            {
                return await GetRateCardByIDAsync(type, ID);
            }
            else if (action.Equals("U", StringComparison.OrdinalIgnoreCase))
            {
                return await UpdateRateCardAsync(type, request);
            }
            return await CreateRateCardAsync(type, request);
        }
        private async Task<ResponseModel> GetAllRateCardsAsync(RateCardType type, RequestModel request)
        {
            var getFactory = _getRateCardFactory.Create(type);
            return await getFactory.GetAllRateCardsAsync(request);
        }
        private async Task<ResponseModel> GetRateCardByIDAsync(RateCardType type, long id)
        {
            var getFactory = _getRateCardFactory.Create(type);
            return await getFactory.GetRateCardByIDAsync(id);
        }
        private async Task<ResponseModel> CreateRateCardAsync(RateCardType type, RequestModel request)
        {
            var createFactory = _createRateCardFactory.Create(type);
            return await createFactory.CreateRateCardAsync(request);
        }
        private async Task<ResponseModel> UpdateRateCardAsync(RateCardType type, RequestModel request)
        {
            var updateFactory = _updateRateCardFactory.Create(type);
            return await updateFactory.UpdateRateCardAsync(request);
        }
        #endregion

        #region Rate Card Documents
        protected async Task<ResponseModel> RateCardDocumentFactoryAsync(RateCardType type, RequestModel request)
        {
            var getFactory = _getRateCardFactory.Create(type);
            return await getFactory.GetRateCardDocumentsAsync(request);
        }
        #endregion

        #region Rate Card Filter
        protected async Task<ResponseModel> GetRateCardNumberFactoryAsync(RateCardType type, RequestModel request)
        {
            var getFactory = _getRateCardFactory.Create(type);
            return await getFactory.GetRateCardNumbersAsync(request);
        }
        protected async Task<ResponseModel> GetRateCardHeadingFactoryAsync(RateCardType type, RequestModel request)
        {
            var getFactory = _getRateCardFactory.Create(type);
            return await getFactory.GetRateCardHeadingsAsync(request);
        }
        protected async Task<ResponseModel> GetRateCardServicesFactoryAsync(RateCardType type, RequestModel request)
        {
            var getFactory = _getRateCardFactory.Create(type);
            return await getFactory.GetRateCardServicesAsync(request);
        }
        #endregion


        #region Rate SearchReport
        protected async Task<ResponseModel> RateSearchReportFactoryAsync(RateCardType type, RequestModel request)
        {

            if (type == RateCardType.Guide)
            {
                GuideRateRequestDto guideRateCard = CommonHelper.DecryptAndDeserialize<string, GuideRateRequestDto>(request.RequestText);
                return await RateSearchReportCardAsync(guideRateCard.Action, guideRateCard.GuideRateID, type, request);
            }
            else if (type == RateCardType.SpecialService)
            {
                SpecialServiceRateRequestDto specialServiceRateCard = CommonHelper.DecryptAndDeserialize<string, SpecialServiceRateRequestDto>(request.RequestText);
                return await RateSearchReportCardAsync(specialServiceRateCard.Action, specialServiceRateCard.SpecialServiceRateID, type, request);
            }
            else if (type == RateCardType.Monument)
            {
                MonumentRateRequestDto monumentRateCard = CommonHelper.DecryptAndDeserialize<string, MonumentRateRequestDto>(request.RequestText);
                return await RateSearchReportCardAsync(monumentRateCard.Action, monumentRateCard.MonumentRateID, type, request);
            }
            else if (type == RateCardType.MOT)
            {
                CreateMOTRateRequestDto MOTRateCard = CommonHelper.DecryptAndDeserialize<string, CreateMOTRateRequestDto>(request.RequestText);
                return await RateSearchReportCardAsync(MOTRateCard.Action, MOTRateCard.ID, type, request);
            }
             else if (type == RateCardType.HotelOffer)
            {
                HotelOfferSearchRequestDto hotelOfferRateCard = CommonHelper.DecryptAndDeserialize<string, HotelOfferSearchRequestDto>(request.RequestText);
                return await RateSearchReportCardAsync(hotelOfferRateCard.Action, 0, type, request);
            }
            else
            {
                TransportRateRequestDto transportRateCard = CommonHelper.DecryptAndDeserialize<string, TransportRateRequestDto>(request.RequestText);
                return await RateSearchReportCardAsync(transportRateCard.Action, transportRateCard.TransportRateID, type, request);
            }
        }



        private async Task<ResponseModel> RateSearchReportCardAsync(string action, long ID, RateCardType type, RequestModel request)
        {
            if (action.Equals("S", StringComparison.OrdinalIgnoreCase))
            {
                return await GetAllRateSearchReportCardsAsync(type, request);
            }
            return await GetAllRateCardsAsync(type, request);
        }

        private async Task<ResponseModel> GetAllRateSearchReportCardsAsync(RateCardType type, RequestModel request)
        {
            var getFactory = _getRateCardFactory.Create(type);
            return await getFactory.GetAllRateSearchReportCardsAsync(request);
        }

        #endregion

        #region Negotiate Rate Card
        protected async Task<ResponseModel> NegotiateRateCardFactoryAsync(RateCardType type, RequestModel request)
        {

            if (type == RateCardType.Hotel)
            {
                CustomHotelRateRequestDto hotelRateCard = CommonHelper.DecryptAndDeserialize<string, CustomHotelRateRequestDto>(request.RequestText);
                return await NegotiateRateCardAsync(hotelRateCard.Action, hotelRateCard.HotelRateID, type, request);
            }
            else if (type == RateCardType.Guide)
            {
                CustomHotelRateRequestDto guideRateCard = CommonHelper.DecryptAndDeserialize<string, CustomHotelRateRequestDto>(request.RequestText);
                return await NegotiateRateCardAsync(guideRateCard.Action, guideRateCard.HotelRateID, type, request);
            }
            else if (type == RateCardType.SpecialService)
            {
                SpecialServiceRateRequestDto specialServiceRateCard = CommonHelper.DecryptAndDeserialize<string, SpecialServiceRateRequestDto>(request.RequestText);
                return await NegotiateRateCardAsync(specialServiceRateCard.Action, specialServiceRateCard.SpecialServiceRateID, type, request);
            }
            else if (type == RateCardType.Monument)
            {
                MonumentRateRequestDto monumentRateCard = CommonHelper.DecryptAndDeserialize<string, MonumentRateRequestDto>(request.RequestText);
                return await NegotiateRateCardAsync(monumentRateCard.Action, monumentRateCard.MonumentRateID, type, request);
            }
            else if (type == RateCardType.MOT)
            {
                CreateMOTRateRequestDto MOTRateCard = CommonHelper.DecryptAndDeserialize<string, CreateMOTRateRequestDto>(request.RequestText);
                return await NegotiateRateCardAsync(MOTRateCard.Action, MOTRateCard.ID, type, request);
            }
            else if (type == RateCardType.HotelOffer)
            {
                HotelOfferRequestDto hotelOffer = CommonHelper.DecryptAndDeserialize<string, HotelOfferRequestDto>(request.RequestText);
                return await NegotiateRateCardAsync(hotelOffer.Action, hotelOffer.HotelOfferID, type, request);
            }
            else
            {
                TransportRateRequestDto transportRateCard = CommonHelper.DecryptAndDeserialize<string, TransportRateRequestDto>(request.RequestText);
                return await NegotiateRateCardAsync(transportRateCard.Action, transportRateCard.TransportRateID, type, request);
            }
        }

        private async Task<ResponseModel> NegotiateRateCardAsync(string action, long ID, RateCardType type, RequestModel request)
        {
            //if (action.Equals("S", StringComparison.OrdinalIgnoreCase) && ID == 0)
            //{
            //    return await GetAllCustomRateCardsAsync(type, request);
            //}
            //else if (action.Equals("S", StringComparison.OrdinalIgnoreCase) && ID > 0)
            //{
            //    return await GetCustomRateCardByIDAsync(type, ID);
            //}
            //else if (action.Equals("U", StringComparison.OrdinalIgnoreCase))
            //{
            //    return await UpdateCustomRateCardAsync(type, request);
            //}
            return await CreateNegotiateRateCardAsync(type, request);
        }

        private async Task<ResponseModel> CreateNegotiateRateCardAsync(RateCardType type, RequestModel request)
        {
            //RateCardType rateCardType = RateCardType.Hotel;
            RateCardType rateCardType = type;
            var createFactory = _createRateCardFactory.Create(rateCardType);
            return await createFactory.CreateNegotiateRateCardAsync(request, type);
        }
        #endregion

        #region Custom Rate Card
        protected async Task<ResponseModel> CustomRateCardFactoryAsync(RateCardType type, RequestModel request)
        {

            //if (type == RateCardType.Hotel)
            //{
            CustomHotelRateRequestDto hotelRateCard = CommonHelper.DecryptAndDeserialize<string, CustomHotelRateRequestDto>(request.RequestText);
            return await CustomRateCardAsync(hotelRateCard.Action, hotelRateCard.HotelRateID, type, request);
            //}
            //else if (type == RateCardType.Guide)
            //{
            //    GuideRateRequestDto guideRateCard = CommonHelper.DecryptAndDeserialize<string, GuideRateRequestDto>(request.RequestText);
            //    return await RateCardAsync(guideRateCard.Action, guideRateCard.GuideRateID, type, request);
            //}
            //else if (type == RateCardType.SpecialService)
            //{
            //    SpecialServiceRateRequestDto specialServiceRateCard = CommonHelper.DecryptAndDeserialize<string, SpecialServiceRateRequestDto>(request.RequestText);
            //    return await RateCardAsync(specialServiceRateCard.Action, specialServiceRateCard.SpecialServiceRateID, type, request);
            //}
            //else if (type == RateCardType.Monument)
            //{
            //    MonumentRateRequestDto monumentRateCard = CommonHelper.DecryptAndDeserialize<string, MonumentRateRequestDto>(request.RequestText);
            //    return await RateCardAsync(monumentRateCard.Action, monumentRateCard.MonumentRateID, type, request);
            //}
            //else if (type == RateCardType.HotelOffer)
            //{
            //    HotelOfferRequestDto hotelOffer = CommonHelper.DecryptAndDeserialize<string, HotelOfferRequestDto>(request.RequestText);
            //    return await RateCardAsync(hotelOffer.Action, hotelOffer.HotelOfferID, type, request);
            //}
            //else
            //{
            //    TransportRateRequestDto transportRateCard = CommonHelper.DecryptAndDeserialize<string, TransportRateRequestDto>(request.RequestText);
            //    return await RateCardAsync(transportRateCard.Action, transportRateCard.TransportRateID, type, request);
            //}
        }
        private async Task<ResponseModel> CustomRateCardAsync(string action, long ID, RateCardType type, RequestModel request)
        {
            if (action.Equals("S", StringComparison.OrdinalIgnoreCase) && ID == 0)
            {
                return await GetAllCustomRateCardsAsync(type, request);
            }
            else if (action.Equals("S", StringComparison.OrdinalIgnoreCase) && ID > 0)
            {
                return await GetCustomRateCardByIDAsync(type, ID);
            }
            else if (action.Equals("U", StringComparison.OrdinalIgnoreCase))
            {
                return await UpdateCustomRateCardAsync(type, request);
            }
            return await CreateCustomRateCardAsync(type, request);
        }

        private async Task<ResponseModel> CreateCustomRateCardAsync(RateCardType type, RequestModel request)
        {
            RateCardType rateCardType = RateCardType.Hotel;
            var createFactory = _createRateCardFactory.Create(rateCardType);
            return await createFactory.CreateCustomRateCardAsync(request, type);
        }

        private async Task<ResponseModel> UpdateCustomRateCardAsync(RateCardType type, RequestModel request)
        {
            RateCardType rateCardType = RateCardType.Hotel;
            var updateFactory = _updateRateCardFactory.Create(rateCardType);
            return await updateFactory.UpdateCustomRateCardAsync(request, type);
        }

        private async Task<ResponseModel> GetAllCustomRateCardsAsync(RateCardType type, RequestModel request)
        {
            RateCardType rateCardType = RateCardType.Hotel;
            var getFactory = _getRateCardFactory.Create(rateCardType);
            return await getFactory.GetAllCustomRateCardsAsync(request);
        }
        private async Task<ResponseModel> GetCustomRateCardByIDAsync(RateCardType type, long id)
        {
            RateCardType rateCardType = RateCardType.Hotel;
            var getFactory = _getRateCardFactory.Create(rateCardType);
            return await getFactory.GetCustomRateCardByIDAsync(id, type);
        }
        #endregion
    }
}
