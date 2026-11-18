using CommonClass;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel.CancellationPolicy;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel.CancellationPolicy;
using TamarindAstra.WebApi.RateCards.Validations.HotelRateCard;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Logic.RateCards.Hotel
{
    public class CreateHotelRateCardLogic : ICreateRateCardLogic
    {
        private readonly ICreateHotelRateRepository _createHotelRateCardRepository;
        private readonly ICreateHotelRatePolicyRepository _createHotelRatePolicyRepository;

        public CreateHotelRateCardLogic(ICreateHotelRateRepository createHotelRateCardRepository,
            ICreateHotelRatePolicyRepository createHotelRatePolicyRepository) 
        {
            _createHotelRateCardRepository = createHotelRateCardRepository;
            _createHotelRatePolicyRepository = createHotelRatePolicyRepository;
        }
        public async Task<ResponseModel> CreateRateCardAsync(RequestModel request)
        {
            HotelRateRequestDto deserialized = CommonHelper.DecryptAndDeserialize<string, HotelRateRequestDto>(request.RequestText);

            var validator = new HotelRateCardValidator();
            var validationResult = await validator.ValidateAsync(deserialized);
            if (!validationResult.IsValid) return CommonHelper.ValidationOutput(validationResult);

            var response = await _createHotelRateCardRepository.CreateHotelRateCardAsync(deserialized);
            return CommonHelper.CreateApiResponse(true, response);
        }

        public async Task<ResponseModel> CreateCustomRateCardAsync(RequestModel request,RateCardType type)
        {
            CustomHotelRateRequestDto deserialized = CommonHelper.DecryptAndDeserialize<string, CustomHotelRateRequestDto>(request.RequestText);
            var response = await _createHotelRateCardRepository.CreateCustomHotelRateCardAsync(deserialized,type);
            return CommonHelper.CreateApiResponse(true, response);
        }

        public async Task<ResponseModel> CreateRateDetailAsync(RequestModel request)
        {
            HotelRateDetailRequestDto deserializedRequest = CommonHelper.DecryptAndDeserialize<string, HotelRateDetailRequestDto>(request.RequestText);

            //string validationError;
            //if(!Validate(deserializedRequest, out validationError)) return CommonHelper.ValidationOutput(validationError);
            var response = await _createHotelRateCardRepository.CreateHotelRateDetailAsync(deserializedRequest);
            return CommonHelper.CreateApiResponse(true, response);
        }
        //private static bool Validate(HotelRateDetailRequestDto requestDto, out string validationError)
        //{
        //    StringBuilder errorBuilder = new();
        //    var validator = new HotelRateCardDetailValidator();
        //    var validationResult = validator.Validate(requestDto);
        //    errorBuilder.Append(string.Join("; ", validationResult.Errors.Select(e => e.ErrorMessage)));

        //    var validityValidator = new CreateRateValidityCollectionValidator();
        //    var validityValidationResult = validityValidator.Validate(requestDto.Validities);
        //    errorBuilder.Append(string.Join("; ", validityValidationResult.Errors.Select(e => e.ErrorMessage)));

        //    var commissionValidator = new CreateRateCommissionCollectionValidator();
        //    var commissionValidationResult = commissionValidator.Validate(requestDto.Commissions);
        //    errorBuilder.Append(string.Join("; ", validityValidationResult.Errors.Select(e => e.ErrorMessage)));

        //    validationError = errorBuilder.ToString();
        //    return validationResult.IsValid && validityValidationResult.IsValid && commissionValidationResult.IsValid;
        //}


        public async Task<ResponseModel> CreateRateCancellationPolicyAsync(RequestModel request)
        {
            HotelRateCancellationPolicyDto cancellationPolicyDto = CommonHelper.DecryptAndDeserialize<string, HotelRateCancellationPolicyDto>(request.RequestText);
            var result = await _createHotelRatePolicyRepository.CreateHotelRatePolicy(cancellationPolicyDto);
            if (result.RateCardID != 0)
            {
                result.Message = "Cancellation Policy Added Successfully";
                return CommonHelper.CreateApiResponse(true, result);
            }
            else
            {
                result.Message = "Cancellation Policy Already Exists";
                return CommonHelper.CreateApiResponse(false, result, "");
            }
        }
        public async Task<ResponseModel> CreateRateCopyAsync(RequestModel request)
        {
            HotelRateRequestDto req = CommonHelper.DecryptAndDeserialize<string, HotelRateRequestDto>(request.RequestText);
            var result = await _createHotelRateCardRepository.CopyHotelRateAsync(req);
            if(result.RateCardID != 0)
            {
                return CommonHelper.CreateApiResponse(true, result);
            }
            else
            {
                result.Message = "Date range already exists";
                return CommonHelper.CreateApiResponse(false, result, "Date range already exists");
            }
            
        }

        public async Task<ResponseModel> CreateNegotiateRateCardAsync(RequestModel request, RateCardType type)
        {
            CustomHotelRateRequestDto deserialized = CommonHelper.DecryptAndDeserialize<string, CustomHotelRateRequestDto>(request.RequestText);
            var response = await _createHotelRateCardRepository.CreateNegotiateHotelRateCardAsync(deserialized, type);
            return CommonHelper.CreateApiResponse(true, response);
        }
    }
}

