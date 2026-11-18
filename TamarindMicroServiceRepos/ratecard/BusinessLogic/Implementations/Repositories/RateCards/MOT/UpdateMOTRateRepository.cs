using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.MOT;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.MOT
{
    public class UpdateMOTRateRepository : IUpdateMOTRateRepository
    {
        public async Task<ApiResponseWrapper> UpdateMOTRateAsync(UpdateMOTRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetMOTRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MOTRateMaster", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@MOTRateID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_MOTRateMaster");
            respone.Message = "Rate card updated successfully";
            return respone;
        }
        public async Task<ApiResponseWrapper> UpdateMOTRateDetailAsync(UpdateMOTRateDetailRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetMOTRateDetailParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MOTRateDetail", parameters);
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_MOTRateDetail");
            respone.Message = "Rate detail updated successfully";
            await UpdateMOTRateCommissionDetailAsync(request.Commissions);
            return respone;
        }
        private async Task UpdateMOTRateCommissionDetailAsync(IList<MOTRateCommissionDetail> commissions)
        {
            foreach (var commission in commissions)
            {
                var parameters = GetMOTRateCommissionDetailParameters(commission);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MOTRateCommissionDetail", parameters);
            }
        }
        private static DynamicParameters GetMOTRateParameters(UpdateMOTRateRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.ID);
            parameter.Add("@ContractDate", request.ContractDate);
            parameter.Add("@ValidFrom", request.ValidFrom);
            parameter.Add("@ValidTo", request.ValidTo);
            parameter.Add("@FromDate", request.FromDate);
            parameter.Add("@ToDate", request.ToDate);
            parameter.Add("@ContractHeading", request.ContractHeading);
            parameter.Add("@TravelModeTypeID", request.TravelModeTypeID);
            parameter.Add("@MOTNameORNumber", request.MOTNameORNumber);
            parameter.Add("@Sector", request.Sector);
            parameter.Add("@RateCardModeTypeID", request.RateCardModeTypeID);
            parameter.Add("@InformationToOperations", request.InformationToOperations);
            parameter.Add("@XORemarks", request.XORemarks);
            parameter.Add("@VendorID", request.VendorID);
            parameter.Add("@CurrencyCode", request.CurrencyCode);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@CompanyID", request.CompanyID);
            parameter.Add("@YearID", request.YearID);
            parameter.Add("@CreatedBy", request.CreatedBy);
            parameter.Add("@ModifiedBy", request.ModifiedBy);
            parameter.Add("@MOTRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);

            return parameter;
        }
        private static DynamicParameters GetMOTRateDetailParameters(UpdateMOTRateDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ClassTypeID", request.ClassTypeID);
            parameter.Add("@ValidFrom", request.ValidFrom);
            parameter.Add("@ValidTo", request.ValidTo);
            parameter.Add("@MISSequence", request.MISSequence);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@CreatedOn", request.CreatedOn);
            parameter.Add("@UpdatedOn", request.UpdatedOn);
            parameter.Add("@MOTRateID", request.MOTRateID);
            parameter.Add("@ApplicableTo", request.ApplicableTo);
            parameter.Add("@Description", request.Description);
            parameter.Add("@CreatedBy", request.CreatedBy);
            parameter.Add("@UpdatedBy", request.UpdatedBy);
            parameter.Add("@MOTRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetMOTRateCommissionDetailParameters(MOTRateCommissionDetail request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.MotRateCommissionDetailID);
            parameter.Add("@MOTRateDetailID", request.MOTRateDetailID);
            parameter.Add("@CategoryID", request.CategoryID);
            parameter.Add("@Tax", request.Tax);
            parameter.Add("@TaxAmount", request.TaxAmount);
            parameter.Add("@NetAmountIncludingTax", request.NetAmountIncludingTax);
            parameter.Add("@NetAmountExcludingTax", request.NetAmountExcludingTax);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@CreatedBy", request.CreatedBy);
            parameter.Add("@UpdatedBy", request.UpdatedBy);
            parameter.Add("@CommissionMasterID", request.CommissionMasterID);
            return parameter;
        }
    }
}
