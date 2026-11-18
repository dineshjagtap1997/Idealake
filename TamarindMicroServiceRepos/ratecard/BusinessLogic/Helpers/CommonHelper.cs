using System.Collections;
using CommonClass;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Helpers
{
    public static class CommonHelper
    {
        public static TDestination DecryptAndDeserialize<TSource, TDestination>(TSource source) where TDestination : class
        {
            if (source is string sourceString)
            {
                return CommonFunctions.DecryptAndDeserializeRequest<TDestination>(sourceString);
            }
            throw new ArgumentException($"Invalid type: Expected string but got {typeof(TSource)}", nameof(source));
        }
        public static ResponseModel CreateApiResponse(string message = "")
        {
            return CommonFunctions.ProcessResult(new ResponseViewModel<bool>
            {
                returnMessage = message,
                returnCode = "200"
            });
        }
        // ✅ Process Success/Failure Response
        public static ResponseModel CreateApiResponse(bool isSuccess, ApiResponseWrapper response = null, string validationError = null)
        {
            if (isSuccess == false)
            {
                return CommonFunctions.ProcessResult(new ResponseViewModel<AcknowledgedResponse<ApiResponseWrapper>>
                {
                    ID = (int)response?.RateCardID,
                    returnMessage = response.Message,
                    returnCode = "409"
                });
            }
            else
            {
                return CommonFunctions.ProcessResult(new ResponseViewModel<AcknowledgedResponse<ApiResponseWrapper>>
                {
                    ID = (int)response?.RateCardID,
                    returnMessage = response.Message,
                    returnCode = "200"
                });
            }
        }
        public static List<T> ToCollection<T>(T item)
        {
            return [item];
        }
        public static ResponseModel CreateApiResponse<T>(T data)
        {
            return CommonFunctions.ProcessResult(new ResponseViewModel<T> { dataList = ToCollection(data) });
        }
        //public static ResponseModel CreateApiResponse<T>(T data)
        //{
        //    return CommonFunctions.ProcessResult(new ResponseViewModel<T> { data = data });
        //}
        public static ResponseModel CreateApiResponse<T>(IEnumerable<T> data)
        {
            if (data != null)
            {
                return CommonFunctions.ProcessResult(new ResponseViewModel<T> { dataList = data.ToList() });
            }
            else
            {
                return ValidationOutput("Data not found");
            }

        }

        // ✅ Process Validation Failure Response
        public static ResponseModel ValidationOutput(FluentValidation.Results.ValidationResult validationResult) =>
            CommonFunctions.ProcessResult(new ResponseViewModel<AcknowledgedResponse<ApiResponseWrapper>>
            {
                data = new AcknowledgedResponse<ApiResponseWrapper>
                {
                    IsSuccess = false,
                    ValidationError = string.Join("; ", validationResult.Errors.Select(e => e.ErrorMessage))
                }
            });

        public static ResponseModel ValidationOutput(string validationResult) =>
        CommonFunctions.ProcessResult(new ResponseViewModel<AcknowledgedResponse<ApiResponseWrapper>>
        {
            data = new AcknowledgedResponse<ApiResponseWrapper>
            {
                IsSuccess = false,
                ValidationError = validationResult
            }
        });
    }
}
