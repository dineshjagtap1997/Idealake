using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Guide;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Guide;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Guide
{
    public class CreateGuideRateRepository : ICreateGuideRateRepository
    {
        public async Task<ApiResponseWrapper> CreateGuideRateAsync(GuideRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetGuideRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_GuideRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@GuideRateID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            request.CardNumber = respone.CardNumber;
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_GuideRateCard");
            respone.Message = "New rate configuration added successfully";
            return respone;
        }

        public async Task<ApiResponseWrapper> CreateNegotiateGuideRateAsync(CustomHotelRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@ContractDate", CommonFunctions.ParseDate(request.ContractDate));
            parameter.Add("@CurrencyID", request.CurrencyID);
            parameter.Add("@Heading", request.Heading);
            parameter.Add("@RateCardModeTypeID", 3);
            parameter.Add("@LanguageID", request.LanguageID);
            parameter.Add("@VendorID", request.VendorID);
            parameter.Add("@CityID", request.CityID);
            parameter.Add("@GuideServiceID", request.ServiceID);
            parameter.Add("@InfoForOperation", request.InfoForOperation);
            parameter.Add("@InfoForRemark", request.InfoForRemark);
            parameter.Add("@InfoForAgent", request.InfoForAgent);
            parameter.Add("@StateID", 0);
            parameter.Add("@GstStatus", 0);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@Notes", request.ValueAddOn);
            parameter.Add("@GuideRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@BookingID", request.BookingID);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_GuideRateCard", parameter);
            respone.RateCardID = Convert.ToInt64(parameter.Get<string>("@GuideRateID"));
            respone.CardNumber = parameter.Get<string>("@CardNumber");
            request.CardNumber = respone.CardNumber;
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_GuideRateCard");
            if(respone.RateCardID != null && respone.RateCardID != 0)
            {
                parameter = new DynamicParameters();
                parameter.Add("@Operation", "INSERT");
                parameter.Add("@TaxID", (int)request.TaxID);
                parameter.Add("@GuideRateID", respone.RateCardID);
                parameter.Add("@ValidFrom", CommonFunctions.ParseDate(request.Validfrom));
                parameter.Add("@ValidTo", CommonFunctions.ParseDate(request.ValidTo));
                parameter.Add("@MISSequence", request.MISSequence);
                parameter.Add("@PaxMinimum", request.Commissions[0].MinimumPax);
                parameter.Add("@PaxMaximum", request.Commissions[0].MaximumPax);
                parameter.Add("@IsActive", request.IsActive);
                parameter.Add("@CreatedBy", request.OperationBy);
                parameter.Add("@GuideRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);

                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_GuideRateDetail", parameter);
                var ratedetailsId = Convert.ToInt64(parameter.Get<string>("@GuideRateDetailID"));
                if (ratedetailsId != 0)
                {
                    TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_GuideRateDetail");
                    List<GuideRateCommissionDetailRequestDto> ComissionList = new List<GuideRateCommissionDetailRequestDto>();
                    if (request.Commissions != null || request.Commissions.Count > 0)
                        foreach (var item in request.Commissions)
                        {
                            GuideRateCommissionDetailRequestDto CommissionsObj = new GuideRateCommissionDetailRequestDto();

                            CommissionsObj.TaxPercentage = item.TaxPercentage;
                            CommissionsObj.TaxAmount = item.TaxAmount;
                            CommissionsObj.NetAmountIncludingTax = item.NetAmountIncludingTax;
                            CommissionsObj.NetAmountExcludingTax = item.NetAmountExcludingTax;
                            CommissionsObj.TaxPercentage = item.CommissionPercentage;
                            CommissionsObj.TaxAmount = item.CommissionAmount;
                            CommissionsObj.GuideRateDetailID = ratedetailsId;
                            CommissionsObj.CreatedBy = request.OperationBy.ToString();
                            CommissionsObj.PaxMinimum = item.MinimumPax;
                            CommissionsObj.PaxMaximum = item.MaximumPax;
                            CommissionsObj.IsActive = item.IsActive;
                            item.HotelRateDetailID = ratedetailsId;
                            ComissionList.Add(CommissionsObj);
                        }
                    await CreateGuideRateCommissionDetailAsync(ComissionList, ratedetailsId);
                }
                
            }
            else
            {
                respone.RateCardID = 0;
            }
            respone.Message = "New rate configuration added successfully";
            return respone;
        }

        public async Task<ApiResponseWrapper> CopyGuideRateAsync(GuideRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = CopyGuideRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].Copy_GuideRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<Int64>("@GuideRateID"));
            //respone.CardNumber = parameters.Get<string>("@CardNumber");
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_GuideRateCard");
            respone.Message = "New rate configuration added successfully";
            return respone;
        }

        public async Task<ApiResponseWrapper> CreateGuideRateDetailAsync(GuideRateDetailRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetGuideRateDetailParameters(request);
            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_GuideRateDetail", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@GuideRateDetailID"));
            if(respone.RateCardID == 0)
            {
                respone.Message = "Rate configuration with the same details already exists";
                return respone;
            }
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_GuideRateDetail");
            respone.Message = "New rate configuration added successfully";
            await CreateGuideRateCommissionDetailAsync(request.Commissions,respone.RateCardID);
            return respone;
        }

        private static async Task CreateGuideRateCommissionDetailAsync(List<GuideRateCommissionDetailRequestDto> request,long guideRateDetailID)
        {
            foreach (var commission in request)
            {
                commission.GuideRateDetailID = guideRateDetailID;
                var parameters = GetGuideRateCommissionDetailParameters(commission);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_GuideRateCommissionDetail", parameters);
            }
        }

        private static DynamicParameters CopyGuideRateParameters(GuideRateRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@RateCardID", request.GuideRateID, DbType.Int64);
            parameter.Add("@CreatedBy", request.OperationBy, DbType.Guid);
            parameter.Add("@GuideRateID", dbType: DbType.Int64, direction: ParameterDirection.Output);
            return parameter;
        }

        private static DynamicParameters GetGuideRateParameters(GuideRateRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@ContractDate", CommonFunctions.ParseDate(request.ContractDate));
            parameter.Add("@CurrencyID", request.CurrencyID);
            parameter.Add("@Heading", request.Heading);
            parameter.Add("@RateCardModeTypeID", (int)request.RateCardModeTypeID);
            parameter.Add("@LanguageID", request.LanguageID);
            parameter.Add("@VendorID", request.VendorID);
            parameter.Add("@CityID", request.CityID);
            parameter.Add("@GuideServiceID", request.GuideServiceID);
            parameter.Add("@InfoForOperation", request.InfoForOperation);
            parameter.Add("@InfoForRemark", request.InfoForRemark);
            parameter.Add("@InfoForAgent", request.InfoForAgent);
            parameter.Add("@StateID", request.StateID);
            parameter.Add("@GstStatus", request.GstStatus);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@Notes", request.ValueAddOn);
            parameter.Add("@GuideRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CreatedBy", request.OperationBy);
            //parameter.Add("@CreatedBy", Guid.NewGuid().ToString());

            return parameter;
        }
        private static DynamicParameters GetGuideRateDetailParameters(GuideRateDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@TaxID", (int)request.TaxID);
            parameter.Add("@GuideRateID", request.GuideRateID);
            parameter.Add("@ValidFrom", CommonFunctions.ParseDate(request.ValidFrom));
            parameter.Add("@ValidTo", CommonFunctions.ParseDate(request.ValidTo));
            parameter.Add("@MISSequence", request.MISSequence);
            parameter.Add("@PaxMinimum", request.Commissions[0].PaxMinimum);
            parameter.Add("@PaxMaximum", request.Commissions[0].PaxMaximum);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@GuideRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);

            return parameter;
        }
        private static DynamicParameters GetGuideRateCommissionDetailParameters(GuideRateCommissionDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@TaxPercentage", request.TaxPercentage);
            parameter.Add("@TaxAmount", request.TaxAmount);
            parameter.Add("@NetAmountIncludingTax", request.NetAmountIncludingTax);
            parameter.Add("@NetAmountExcludingTax", request.NetAmountExcludingTax);
            parameter.Add("@PaxMinimum", request.PaxMinimum);
            parameter.Add("@PaxMaximum", request.PaxMaximum);
            parameter.Add("@GuideRateDetailID", request.GuideRateDetailID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@GuideRateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
    }
}
