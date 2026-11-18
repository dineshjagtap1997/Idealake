using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.SpecialService;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.SpecialService;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.SpecialService
{
    public class CreateSpecialServiceRateRepository : ICreateSpecialServiceRateRepository
    {
        public async Task<ApiResponseWrapper> CreateSpecialServiceRateAsync(SpecialServiceRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetSpecialServiceRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_SpecialServiceRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@SpecialServiceRateID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            request.CardNumber = respone.CardNumber;
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_SpecialServiceRateCard");
            respone.Message = "New rate configuration added successfully";
            return respone;
        }

        public async Task<ApiResponseWrapper> CreateNegotiateSpecialServiceRateAsync(CustomHotelRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "INSERT");
            parameters.Add("@ContractDate", CommonFunctions.ParseDate(request.ContractDate));
            parameters.Add("@CurrencyID", request.CurrencyID);
            parameters.Add("@Heading", request.Heading);
            parameters.Add("@RateCardModeTypeID", 3);
            parameters.Add("@VendorID", request.VendorID);
            parameters.Add("@CityID", request.CityID);
            parameters.Add("@SpecialServiceID", request.ServiceID);
            parameters.Add("@InfoForOperation", request.InfoForOperation);
            parameters.Add("@InfoForRemark", request.InfoForRemark);
            parameters.Add("@InfoForAgent", request.InfoForAgent);
            parameters.Add("@GSTStatus", 0);
            parameters.Add("@StateID", 0);
            parameters.Add("@HrsPerDay", 0);
            parameters.Add("@KmPerDay", 0);
            parameters.Add("@IsActive", request.IsActive);
            parameters.Add("@SpecialServiceRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameters.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameters.Add("@CreatedBy", request.OperationBy);
            parameters.Add("@HotelId", request.HotelID);
            parameters.Add("@BookingID", request.BookingID);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_SpecialServiceRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@SpecialServiceRateID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            request.CardNumber = respone.CardNumber;
            if (respone.RateCardID > 0)
            {
                TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_SpecialServiceRateCard");
                respone.Message = "New rate configuration added successfully";
                var parameter = new DynamicParameters();
                parameter.Add("@Operation", "INSERT");
                parameter.Add("@TaxID", (int)request.TaxID);
                parameter.Add("@ValidFrom", CommonFunctions.ParseDate(request.Validfrom));
                parameter.Add("@ValidTo", CommonFunctions.ParseDate(request.ValidTo));
                parameter.Add("@MISSequence", request.MISSequence);
                parameter.Add("@NationalityID", request.NationalityID);
                parameter.Add("@RatePreferenceID", (int)request.RatePreferenceID);
                parameter.Add("@IsActive", request.IsActive);
                parameter.Add("@SpecialServiceRateID", respone.RateCardID);
                parameter.Add("@CreatedBy", request.OperationBy);
                parameter.Add("@SpecialServiceRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_SpecialServiceRateDetail", parameter);
                var Ratecarddetailsid = Convert.ToInt64(parameter.Get<string>("@SpecialServiceRateDetailID"));
                if (Ratecarddetailsid > 0)
                {
                    TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(Ratecarddetailsid), "CreateOrUpdate_SpecialServiceRateDetail");
                    List<SpecialServiceRateCommissionDetailRequestDto> ComissionList = new List<SpecialServiceRateCommissionDetailRequestDto>();
                    if (request.Commissions != null || request.Commissions.Count > 0)
                        foreach (var item in request.Commissions)
                        {
                            SpecialServiceRateCommissionDetailRequestDto CommissionsObj = new SpecialServiceRateCommissionDetailRequestDto();

                            CommissionsObj.MinimumPax = item.MinimumPax;
                            CommissionsObj.MaximumPax = item.MaximumPax;
                            CommissionsObj.TaxPercentage = item.TaxPercentage;
                            CommissionsObj.TaxAmount = item.TaxAmount;
                            CommissionsObj.NetAmountIncludingTax = item.NetAmountIncludingTax;
                            CommissionsObj.NetAmountExcludingTax = item.NetAmountExcludingTax;
                            CommissionsObj.SpecialServiceRateDetailID = Ratecarddetailsid;
                            CommissionsObj.IsActive = item.IsActive;
                            CommissionsObj.CommissionMasterID = item.MasterCommissionID;
                            CommissionsObj.CreatedBy = request.OperationBy.ToString();
                            ComissionList.Add(CommissionsObj);
                        }
                    await CreateSpecialServiceRateCommissionDetailAsync(ComissionList, Ratecarddetailsid);
                }
                else
                {
                    respone.Message = "Rate configuration with the same details already exists.";
                }
            }
            else
            {
                respone.Message = "Rate configuration with the same details already exists.";
            }

            return respone;
        }

        public async Task<ApiResponseWrapper> CreateSpecialServiceRateDetailAsync(SpecialServiceDetailRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetSpecialServiceRateDetailParameters(request);
            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_SpecialServiceRateDetail", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@SpecialServiceRateDetailID"));
            if (respone.RateCardID > 0)
            {
                TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_SpecialServiceRateDetail");
                respone.Message = "New rate configuration added successfully";
                await CreateSpecialServiceRateCommissionDetailAsync(request.Commissions, respone.RateCardID);
            }
            else
            {
                respone.Message = "Rate configuration with the same details already exists.";
            }

            return respone;
        }
        private static async Task CreateSpecialServiceRateCommissionDetailAsync(List<SpecialServiceRateCommissionDetailRequestDto> request, long specialServiceRateDetailID)
        {
            foreach (var commission in request)
            {
                commission.SpecialServiceRateDetailID = specialServiceRateDetailID;
                var parameters = GetSpecialServiceRateCommissionDetailParameters(commission);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_SpecialServiceRateCommissionDetail", parameters);
            }
        }
        public async Task<ApiResponseWrapper> CopySpecialServiceRateAsync(SpecialServiceRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = CopySpecialServiceRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].Copy_SpecialServiceRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<Int64>("@SpecialServiceRateID"));
            //respone.CardNumber = parameters.Get<string>("@CardNumber");
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_SpecialServiceRateCard");
            respone.Message = "New rate configuration added successfully";
            return respone;
        }
        private static DynamicParameters CopySpecialServiceRateParameters(SpecialServiceRateRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@RateCardID", request.SpecialServiceRateID, DbType.Int64);
            parameter.Add("@CreatedBy", request.OperationBy, DbType.Guid);
            parameter.Add("@SpecialServiceRateID", dbType: DbType.Int64, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetSpecialServiceRateParameters(SpecialServiceRateRequestDto request)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "INSERT");
            parameters.Add("@ContractDate", CommonFunctions.ParseDate(request.ContractDate));
            parameters.Add("@CurrencyID", request.CurrencyID);
            parameters.Add("@Heading", request.Heading);
            parameters.Add("@RateCardModeTypeID", (int)request.RateCardModeTypeID);
            parameters.Add("@VendorID", request.VendorID);
            parameters.Add("@CityID", request.CityID);
            parameters.Add("@SpecialServiceID", request.SpecialServiceID);
            parameters.Add("@InfoForOperation", request.InfoForOperation);
            parameters.Add("@InfoForRemark", request.InfoForRemark);
            parameters.Add("@InfoForAgent", request.InfoForAgent);
            parameters.Add("@GSTStatus", request.GstStatus);
            parameters.Add("@StateID", request.StateID);
            parameters.Add("@HrsPerDay", request.HrsPerDay);
            parameters.Add("@KmPerDay", request.KmPerDay);
            parameters.Add("@IsActive", request.IsActive);
            parameters.Add("@SpecialServiceRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameters.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameters.Add("@CreatedBy", request.OperationBy);
            parameters.Add("@HotelId", request.HotelID);
            return parameters;
        }
        private static DynamicParameters GetSpecialServiceRateCommissionDetailParameters(SpecialServiceRateCommissionDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@MinimumPax", request.MinimumPax);
            parameter.Add("@MaximumPax", request.MaximumPax);
            parameter.Add("@TaxPercentage", request.TaxPercentage);
            parameter.Add("@TaxAmount", request.TaxAmount);
            parameter.Add("@NetAmountIncludingTax", request.NetAmountIncludingTax);
            parameter.Add("@NetAmountExcludingTax", request.NetAmountExcludingTax);
            parameter.Add("@SpecialServiceRateDetailID", request.SpecialServiceRateDetailID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@CommissionMasterID", request.CommissionMasterID);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@SpecialServiceRateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);

            return parameter;
        }
        private static DynamicParameters GetSpecialServiceRateDetailParameters(SpecialServiceDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@TaxID",(int) request.TaxID);
            parameter.Add("@ValidFrom", CommonFunctions.ParseDate(request.ValidFrom));
            parameter.Add("@ValidTo", CommonFunctions.ParseDate(request.ValidTo));
            parameter.Add("@MISSequence", request.MISSequence);
            parameter.Add("@NationalityID", request.NationalityID);
            parameter.Add("@RatePreferenceID",(int) request.RatePreferenceID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@SpecialServiceRateID", request.SpecialServiceRateID);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@SpecialServiceRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
    }
}
