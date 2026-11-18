using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Monument;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Monument;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Monument
{
    public class CreateMonumentRateRepository : ICreateMonumentRateRepository
    {
        public async Task<ApiResponseWrapper> CreateMonumentRateAsync(MonumentRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetMonumentRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MonumentRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@MonumentRateID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            request.CardNumber = respone.CardNumber;
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_MonumentRateCard");
            respone.Message = "New rate configuration added successfully";
            return respone;
        }

        public async Task<ApiResponseWrapper> CreateNegotiateMonumentRateAsync(CustomHotelRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@ContractDate", CommonFunctions.ParseDate(request.ContractDate));
            parameter.Add("@CurrencyID", request.CurrencyID);
            parameter.Add("@Heading", request.Heading);
            parameter.Add("@RateCardModeTypeID", 3);
            parameter.Add("@VendorID", request.VendorID);
            parameter.Add("@CityID", request.CityID);
            parameter.Add("@MonumentServiceID", request.ServiceID);
            parameter.Add("@InfoForOperation", request.InfoForOperation);
            parameter.Add("@InfoForRemark", request.InfoForRemark);
            parameter.Add("@InfoForAgent", request.InfoForAgent);
            parameter.Add("@GSTStatus", 0);
            parameter.Add("@StateID", 0);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@MonumentRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@BookingID", request.BookingID);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MonumentRateCard", parameter);
            respone.RateCardID = Convert.ToInt64(parameter.Get<string>("@MonumentRateID"));
            respone.CardNumber = parameter.Get<string>("@CardNumber");
            request.CardNumber = respone.CardNumber;
            if (respone.RateCardID != null && respone.RateCardID != 0)
            {
                TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_MonumentRateCard");
                parameter = new DynamicParameters();
                parameter.Add("@Operation", "INSERT");
                parameter.Add("@TaxID", request.TaxID);
                parameter.Add("@NationalityID", request.NationalityID);
                parameter.Add("@ValidFrom", CommonFunctions.ParseDate(request.Validfrom));
                parameter.Add("@ValidTo", CommonFunctions.ParseDate(request.ValidTo));
                parameter.Add("@MISSequence", request.MISSequence);
                parameter.Add("@IsActive", request.IsActive);
                parameter.Add("@MonumentRateID", respone.RateCardID);
                parameter.Add("@CreatedBy", request.OperationBy);
                parameter.Add("@MonumentRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);

                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MonumentRateDetail", parameter);
                var RateCardDetailID = Convert.ToInt64(parameter.Get<string>("@MonumentRateDetailID"));
                if (RateCardDetailID > 0)
                {
                    TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_MonumentRateDetail");
                    List<MonumentRateCommissionDetailRequestDto> ComissionList = new List<MonumentRateCommissionDetailRequestDto>();
                    if (request.Commissions != null || request.Commissions.Count > 0)
                        foreach (var item in request.Commissions)
                        {
                            MonumentRateCommissionDetailRequestDto CommissionsObj = new MonumentRateCommissionDetailRequestDto();
                            CommissionsObj.CommissionMasterID = item.MasterCommissionID;
                            CommissionsObj.TaxPercentage = item.TaxPercentage;
                            CommissionsObj.TaxAmount = item.TaxAmount;
                            //CommissionsObj. = item.GrossAmountIncludingTax;
                            //CommissionsObj.GrossAmountExcludingTax = item.GrossAmountExcludingTax;
                            CommissionsObj.NetAmountIncludingTax = item.NetAmountIncludingTax;
                            CommissionsObj.NetAmountExcludingTax = item.NetAmountExcludingTax;
                            CommissionsObj.TaxPercentage = item.TaxPercentage;
                            CommissionsObj.TaxAmount = item.TaxAmount;
                            CommissionsObj.MonumentDetailID = RateCardDetailID;
                            CommissionsObj.CreatedBy = request.OperationBy.ToString();
                            parameter.Add("@RateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
                            ComissionList.Add(CommissionsObj);
                        }
                    await CreateMonumentRateCommissionDetailAsync(ComissionList, RateCardDetailID);
                }
            }
            //respone.Message = "New rate configuration added successfully";
            return respone;
        }

        public async Task<ApiResponseWrapper> CreateMonumentRateDetailAsync(MonumentRateDetailRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetMonumentRateDetailParameters(request);
            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MonumentRateDetail", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@MonumentRateDetailID"));
            if (respone.RateCardID > 0)
            {
                TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_MonumentRateDetail");
                respone.Message = "New rate configuration added successfully";
                await CreateMonumentRateCommissionDetailAsync(request.Commissions, respone.RateCardID);

            }
            else
            {
                respone.Message = "Rate configuration with the same details already exists.";
            }
            return respone;
        }

        private static async Task CreateMonumentRateCommissionDetailAsync(List<MonumentRateCommissionDetailRequestDto> request, long monumentRateDetailID)
        {
            foreach (var commission in request)
            {
                commission.MonumentDetailID = monumentRateDetailID;
                var parameters = GetMonumentRateCommissionDetailParameters(commission);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MonumentRateCommissionDetails", parameters);
            }
        }

        public async Task<ApiResponseWrapper> CopyMonumentRateAsync(MonumentRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = CopyMonumentRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].Copy_MonumentRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<Int64>("@MonumentRateID"));
            //respone.CardNumber = parameters.Get<string>("@CardNumber");
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_MonumentRateDetail");
            respone.Message = "New rate configuration added successfully";
            return respone;
        }

        private static DynamicParameters CopyMonumentRateParameters(MonumentRateRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@RateCardID", request.MonumentRateID, DbType.Int64);
            parameter.Add("@CreatedBy", request.OperationBy, DbType.Guid);
            parameter.Add("@MonumentRateID", dbType: DbType.Int64, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetMonumentRateCommissionDetailParameters(MonumentRateCommissionDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@MasterCommissionID", request.CommissionMasterID);
            parameter.Add("@TaxPercentage", request.TaxPercentage);
            parameter.Add("@TaxAmount", request.TaxAmount);
            parameter.Add("@NetAmountIncludingTax", request.NetAmountIncludingTax);
            parameter.Add("@NetAmountExcludingTax", request.NetAmountExcludingTax);
            parameter.Add("@MonumentDetailID", request.MonumentDetailID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@MonumentRateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetMonumentRateDetailParameters(MonumentRateDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@TaxID", request.TaxID);
            parameter.Add("@NationalityID", request.NationalityID);
            parameter.Add("@ValidFrom", CommonFunctions.ParseDate(request.ValidFrom));
            parameter.Add("@ValidTo", CommonFunctions.ParseDate(request.ValidTo));
            parameter.Add("@MISSequence", request.MISSequence);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@MonumentRateID", request.MonumentRateID);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@MonumentRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetMonumentRateParameters(MonumentRateRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@ContractDate", CommonFunctions.ParseDate(request.ContractDate));
            parameter.Add("@CurrencyID", request.CurrencyID);
            parameter.Add("@Heading", request.Heading);
            parameter.Add("@RateCardModeTypeID", (int)request.RateCardModeTypeID);
            parameter.Add("@VendorID", request.VendorID);
            parameter.Add("@CityID", request.CityID);
            parameter.Add("@MonumentServiceID", request.MonumentServiceID);
            parameter.Add("@InfoForOperation", request.InfoForOperation);
            parameter.Add("@InfoForRemark", request.InfoForRemark);
            parameter.Add("@InfoForAgent", request.InfoForAgent);
            parameter.Add("@GSTStatus", request.GstStatus);
            parameter.Add("@StateID", request.StateID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@MonumentRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CreatedBy", request.OperationBy);

            return parameter;
        }
    }
}