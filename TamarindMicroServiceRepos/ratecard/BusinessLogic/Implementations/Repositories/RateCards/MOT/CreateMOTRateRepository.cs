using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.MOT;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.MOT;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.MOT
{
    public class CreateMOTRateRepository : ICreateMOTRateRepository
    {
        public async Task<ApiResponseWrapper> CreateMOTRateAsync(CreateMOTRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetMOTRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MOTRateMaster", parameters);
            respone.Message = "Rate card created successfully";
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@MOTRateID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            request.CardNumber = respone.CardNumber;
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_MOTRateMaster");

            return respone;
        }

        public async Task<ApiResponseWrapper> CreateMOTRateDetailAsync(CreateMOTRateDetailRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetMOTRateDetailParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MOTRateDetail", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@MOTRateDetailID"));
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_MOTRateDetail");
            respone.Message = "Rate detail created successfully";
            await CreateMOTRateCommissionDetailAsync(request.Commissions, respone.RateCardID);
            return respone;
        }

        private async Task CreateMOTRateCommissionDetailAsync(IList<MOTRateCommissionDetail> commissions, long motRateDetailID)
        {
            foreach (var commission in commissions)
            {
                commission.MOTRateDetailID = motRateDetailID;
                var parameters = GetMOTRateCommissionDetailParameters(commission);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MOTRateCommissionDetail", parameters);
            }
        }
        private static async Task CreateMOTRateCommissionDetailAsync(List<CreateMOTRateCommissionDetailRequestDto> request, long MOTRateDetailID)
        {
            foreach (var commission in request)
            {
                commission.MOTRateDetailID = MOTRateDetailID;
                var parameters = GetMOTRateCommissionDetailParameters(commission);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MOTRateCommissionDetail", parameters);
            }
        }
        private static DynamicParameters GetMOTRateParameters(CreateMOTRateRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
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
        private static DynamicParameters GetMOTRateDetailParameters(CreateMOTRateDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@ClassTypeID", request.ClassTypeID);
            parameter.Add("@TaxType", request.TaxType);
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
            parameter.Add("@Operation", "INSERT");
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
        public async Task<ApiResponseWrapper> CreateNegotiateMOTRateAsync(CustomHotelRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@ContractDate", request.ContractDate);
            parameter.Add("@ValidFrom", request.Validfrom);
            parameter.Add("@ValidTo", request.ValidTo);
            parameter.Add("@ContractHeading", request.Heading);
            parameter.Add("@MOTNameORNumber", request.MOTNameORNumber);
            parameter.Add("@Sector", request.Sector);
            parameter.Add("@TravelModeTypeID", request.TravelModeTypeID);
            parameter.Add("@RateCardModeTypeID", request.RateCardModeTypeID);
            parameter.Add("@InformationToOperations", request.InfoForOperation);
            parameter.Add("@XORemarks", request.XORemark);
            parameter.Add("@VendorID", request.VendorID);
            parameter.Add("@CurrencyCode", request.CurrencyID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@CreatedBy", request.CreatedBy);
            parameter.Add("@ModifiedBy", request.OperationBy);
            parameter.Add("@MOTRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@BookingID", request.BookingID);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MOTRateMaster", parameter);
            respone.RateCardID = Convert.ToInt64(parameter.Get<string>("@MOTRateID"));
            respone.CardNumber = parameter.Get<string>("@CardNumber");
            request.CardNumber = respone.CardNumber;
            if (respone.RateCardID != null && respone.RateCardID != 0)
            {
                TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_MOTRateMaster");
                parameter = new DynamicParameters();
                parameter.Add("@Operation", "INSERT");

                parameter.Add("@ClassTypeID", request.ClassTypeID);
                parameter.Add("@TaxType", request.TaxType);
                parameter.Add("@ValidFrom", CommonFunctions.ParseDate(request.Validfrom));
                parameter.Add("@ValidTo", CommonFunctions.ParseDate(request.ValidTo));
                parameter.Add("@MISSequence", request.MISSequence);
                parameter.Add("@IsActive", request.IsActive);
                parameter.Add("@MOTRateID", respone.RateCardID);
                parameter.Add("@CreatedBy", request.OperationBy);
                parameter.Add("@CreatedOn", request.CreatedOn);
                parameter.Add("@MOTRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);

                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_MOTRateDetail", parameter);
                var RateCardDetailID = Convert.ToInt64(parameter.Get<string>("@MOTRateDetailID"));
                if (RateCardDetailID > 0)
                {
                    TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_MOTRateDetail");
                    List<CreateMOTRateCommissionDetailRequestDto> ComissionList = new List<CreateMOTRateCommissionDetailRequestDto>();
                    if (request.Commissions != null || request.Commissions.Count > 0)
                        foreach (var item in request.Commissions)
                        {
                            CreateMOTRateCommissionDetailRequestDto CommissionsObj = new CreateMOTRateCommissionDetailRequestDto();
                            CommissionsObj.CommissionMasterID = item.MasterCommissionID;
                            CommissionsObj.Tax = item.TaxPercentage;
                            CommissionsObj.TaxAmount = item.TaxAmount;
                            //CommissionsObj. = item.GrossAmountIncludingTax;
                            //CommissionsObj.GrossAmountExcludingTax = item.GrossAmountExcludingTax;
                            CommissionsObj.NetAmountIncludingTax = item.NetAmountIncludingTax;
                            CommissionsObj.NetAmountExcludingTax = item.NetAmountExcludingTax;
                            CommissionsObj.Tax = item.TaxPercentage;
                            CommissionsObj.TaxAmount = item.TaxAmount;
                            CommissionsObj.MOTRateDetailID = RateCardDetailID;
                            CommissionsObj.CreatedBy = request.OperationBy;
                            parameter.Add("@RateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
                            ComissionList.Add(CommissionsObj);
                        }
                    await CreateMOTRateCommissionDetailAsync(ComissionList, RateCardDetailID);
                }
            }
            //respone.Message = "New rate configuration added successfully";
            return respone;
        }

    }
}
