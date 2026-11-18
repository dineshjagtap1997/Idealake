using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Transport;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Transport;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Transport
{
    public class CreateTransportRateRepository : ICreateTransportRateRepository
    {
        public async Task<ApiResponseWrapper> CreateTransportServiceRateAsync(TransportRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetTransportServiceRateParameters(request);
            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_TransportRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@TransportRateID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            request.CardNumber = respone.CardNumber;
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_TransportRateCard");
            respone.Message = "New rate configuration added successfully";
            return respone;
        }

        public async Task<ApiResponseWrapper> CreateNegotiateTransportServiceRateAsync(CustomHotelRateRequestDto request)
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
            parameters.Add("@CityID2", "");
            parameters.Add("@HotelZone", 0);
            parameters.Add("@HotelID", request.HotelID);
            parameters.Add("@InfoForOperation", request.InfoForOperation);
            parameters.Add("@InfoForRemark", request.InfoForRemark);
            parameters.Add("@InfoForAgent", request.InfoForAgent);
            parameters.Add("@GSTStatus", 0);
            parameters.Add("@StateID", 0);
            parameters.Add("@IsActive", request.IsActive);
            parameters.Add("@TransportServiceID", request.ServiceID);
            parameters.Add("@TransportModeTypeID", 0);
            parameters.Add("@TransportRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameters.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameters.Add("@CreatedBy", request.OperationBy);
            parameters.Add("@BookingID", request.BookingID);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_TransportRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@TransportRateID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            request.CardNumber = respone.CardNumber;
            if (respone.RateCardID > 0)
            {
                TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_TransportRateCard");
                var parameter = new DynamicParameters();
                parameter.Add("@Operation", "INSERT");
                parameter.Add("@TaxID", (int)request.TaxID);
                parameter.Add("@ValidFrom", CommonFunctions.ParseDate(request.Validfrom));
                parameter.Add("@ValidTo", CommonFunctions.ParseDate(request.ValidTo));
                parameter.Add("@MISSequence", request.MISSequence);
                parameter.Add("@VehicleCategoryID", request.VehicleCategoryID);
                parameter.Add("@VehicleBaseID", 0);
                parameter.Add("@IsActive", request.IsActive);
                parameter.Add("@TransportRateID", respone.RateCardID);
                parameter.Add("@CreatedBy", request.OperationBy);
                parameter.Add("@TransportRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_TransportRateDetail", parameter);
                var RateCardDetailId = Convert.ToInt64(parameter.Get<string>("@TransportRateDetailID"));
                if (RateCardDetailId > 0)
                {
                    TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_TransportRateDetail");
                    List<TransportRateCommissionDetailRequestDto> ComissionList = new List<TransportRateCommissionDetailRequestDto>();
                    if (request.Commissions != null || request.Commissions.Count > 0)
                        foreach (var item in request.Commissions)
                        {
                            TransportRateCommissionDetailRequestDto CommissionsObj = new TransportRateCommissionDetailRequestDto();

                            CommissionsObj.CommissionMasterID = item.MasterCommissionID;
                            CommissionsObj.IsAmtIncludedInBasic = item.IsAmtIncludedInBasic;
                            CommissionsObj.TaxPercentage = item.TaxPercentage;
                            CommissionsObj.TaxAmount = item.TaxAmount;
                            CommissionsObj.NetAmountIncludingTax = item.NetAmountIncludingTax;
                            CommissionsObj.NetAmountExcludingTax = item.NetAmountExcludingTax;
                            CommissionsObj.TransportRateDetailID = RateCardDetailId;
                            CommissionsObj.IsActive = item.IsActive;
                            CommissionsObj.CreatedBy = request.OperationBy.ToString();
                            ComissionList.Add(CommissionsObj);
                        }
                    await CreateTransportServiceRateCommissionDetailAsync(ComissionList, RateCardDetailId);
                }
            }
            respone.Message = "New rate configuration added successfully";
            return respone;
        }

        public async Task<ApiResponseWrapper> CreateTransportServiceRateDetailAsync(TransportRateDetailRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetTransportServiceRateDetailParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_TransportRateDetail", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@TransportRateDetailID"));
            if (respone.RateCardID > 0)
            {
                TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_TransportRateDetail");
                respone.Message = "New rate configuration added successfully";
                await CreateTransportServiceRateCommissionDetailAsync(request.Commissions, respone.RateCardID);
            }
            else
            {
                respone.Message = "Rate configuration with the same details already exists.";
            }
            return respone;
        }

        public async Task<ApiResponseWrapper> CopyTransportRateAsync(TransportRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = CopyTransportRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].Copy_TransportRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<Int64>("@TransportRateID"));
            //respone.CardNumber = parameters.Get<string>("@CardNumber");
            //TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_GuideRateCard");
            respone.Message = "New rate configuration added successfully";
            return respone;
        }

        private static DynamicParameters CopyTransportRateParameters(TransportRateRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@RateCardID", request.TransportRateID, DbType.Int64);
            parameter.Add("@CreatedBy", request.OperationBy, DbType.Guid);
            parameter.Add("@TransportRateID", dbType: DbType.Int64, direction: ParameterDirection.Output);
            return parameter;
        }

        private static async Task CreateTransportServiceRateCommissionDetailAsync(List<TransportRateCommissionDetailRequestDto> request, long specialServiceRateDetailID)
        {
            foreach (var commission in request)
            {
                commission.TransportRateDetailID = specialServiceRateDetailID;
                var parameters = GetTransportServiceRateCommissionDetailParameters(commission);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_TransportRateCommissionDetail", parameters);
            }
        }
        private static DynamicParameters GetTransportServiceRateParameters(TransportRateRequestDto request)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "INSERT");
            parameters.Add("@ContractDate", CommonFunctions.ParseDate(request.ContractDate));
            parameters.Add("@CurrencyID", request.CurrencyID);
            parameters.Add("@Heading", request.Heading);
            parameters.Add("@RateCardModeTypeID", (int)request.RateCardModeTypeID);
            parameters.Add("@VendorID", request.VendorID);
            parameters.Add("@CityID", request.CityID);
            parameters.Add("@CityID2", request.CityID2);
            parameters.Add("@HotelZone", request.HotelZone);
            parameters.Add("@HotelID", request.HotelID);
            parameters.Add("@InfoForOperation", request.InfoForOperation);
            parameters.Add("@InfoForRemark", request.InfoForRemark);
            parameters.Add("@InfoForAgent", request.InfoForAgent);
            parameters.Add("@GSTStatus", request.GstStatus);
            parameters.Add("@StateID", request.StateID);
            parameters.Add("@IsActive", request.IsActive);
            parameters.Add("@TransportServiceID", request.TransportServiceID);
            parameters.Add("@TransportModeTypeID", (int) request.TransportModeTypeID);
            parameters.Add("@TransportRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameters.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameters.Add("@CreatedBy", request.OperationBy);
            return parameters;
        }
        private static DynamicParameters GetTransportServiceRateCommissionDetailParameters(TransportRateCommissionDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@MasterCommissionID", request.CommissionMasterID);
            parameter.Add("@IsAmtIncludedInTax", request.IsAmtIncludedInBasic);
            parameter.Add("@TaxPercentage", request.TaxPercentage);
            parameter.Add("@TaxAmount", request.TaxAmount);
            parameter.Add("@NetAmountIncludingTax", request.NetAmountIncludingTax);
            parameter.Add("@NetAmountExcludingTax", request.NetAmountExcludingTax);
            parameter.Add("@TransportRateDetailID", request.TransportRateDetailID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@TransportRateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);

            return parameter;
        }

        private static DynamicParameters GetTransportServiceRateDetailParameters(TransportRateDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@TaxID", (int)request.TaxID);
            parameter.Add("@ValidFrom", CommonFunctions.ParseDate(request.ValidFrom));
            parameter.Add("@ValidTo", CommonFunctions.ParseDate(request.ValidTo));
            parameter.Add("@MISSequence", request.MISSequence);
            parameter.Add("@VehicleCategoryID", request.VehicleCategoryID);
            parameter.Add("@VehicleBaseID", (int)request.VehicleBaseID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@TransportRateID", request.TransportRateID);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@TransportRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
    }
}
