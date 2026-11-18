using Dapper;
using System.Data;
using TamarindAstra.Common;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards;
using TamarindAstra.WebApi.RateCards.BusinessLogic.DTOs.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Entities.RateCards.Hotel;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Enums;
using TamarindAstra.WebApi.RateCards.BusinessLogic.Interfaces.RateCards.Hotel;

namespace TamarindAstra.WebApi.RateCards.BusinessLogic.Implementations.Repositories.RateCards.Hotel
{
    public class UpdateHotelRateRepository : IUpdateHotelRateRepository
    {
        public async Task<ApiResponseWrapper> UpdateHotelRateCardAsync(HotelRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetHotelRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_HotelRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@HotelRateID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_HotelRateCard");
        
            await CreateHotelRateSheetAsync(request.Ratesheet, respone.RateCardID);
            await CreateHotelRateMarketAsync(request.Market, respone.RateCardID);
            await CreateHotelRateVouchersAsync(request.Voucher, respone.RateCardID);
            respone.Message = "Rate card updated successfully.";
            return respone;
        }

        public async Task<ApiResponseWrapper> UpdateCustomHotelRateCardAsync(CustomHotelRateRequestDto request,RateCardType type)
        {
            var respone = new ApiResponseWrapper();
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "UPDATE"); // "INSERT" or "UPDATE"
            parameters.Add("@ID", request.HotelRateID);
            parameters.Add("@CityID", request.CityID);
            parameters.Add("@CurrencyID", request.CurrencyID);
            parameters.Add("@HotelID", request.HotelID);
            parameters.Add("@RoomCategoryID", request.RoomCategoryID);
            parameters.Add("@MealPlanID", request.MealPlanID);
            parameters.Add("@VendorID", request.VendorID);
            parameters.Add("@PaymentTypeID", request.PaymentTypeID);
            parameters.Add("@IsCommission", request.IsCommission);
            parameters.Add("@IsActive", request.IsActive);
            parameters.Add("@CreatedBy", request.OperationBy); // Use OperationBy as CreatedBy
            parameters.Add("@UpdatedBy", request.OperationBy); // Use OperationBy as UpdatedBy
            parameters.Add("@IsTax", request.IsTax);
            parameters.Add("@LanguageID", request.LanguageID);
            parameters.Add("@VehicleCategoryID", request.VehicleCategoryID);
            parameters.Add("@ServiceID", request.ServiceID);
            parameters.Add("@NationalityID", request.NationalityID);
            parameters.Add("@RatePreferenceID", request.RatePreferenceID);
            parameters.Add("@QuotationID", request.QuotationID);
            parameters.Add("@RateType", (int)type);
            parameters.Add("@HotelRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            await SqlHelper.SaveAsync("[CustomRateCards].[CreateOrUpdate_HotelRateCard]", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@HotelRateID"));
            //TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_HotelRateCard");
            await UpdateCustomHotelRateCommissionDetailAsync(request.Commissions, respone.RateCardID);
            await UpdateCustomHotelRateMealAsync(request.Meals, respone.RateCardID);
            respone.Message = "Rate card updated successfully.";
            return respone;
        }

        public async Task<ApiResponseWrapper> UpdateHotelRateDetailAsync(HotelRateDetailRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetHotelRateDetailParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_HotelRateDetail", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@HotelRateDetailID"));
            Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_HotelRateDetail");
            respone.Message = "Rate detail updated successfully.";
            await UpdateHotelRateValidityAsync(request.Validities);
            await UpdateHotelRateCommissionDetailAsync(request.Commissions);
            await UpdateHotelRateMealAsync(request.Meals);
            await UpdateHotelRateOfferConfigurationAsync(request.OfferConfiguration, request.HotelRateDetailID);
            return respone;
        }
        private static async Task CreateHotelRateSheetAsync(List<HotelRatesheetMasterRequestDto> ratesheetMasters, long hotelRateID)
        {
            if (ratesheetMasters == null || ratesheetMasters.Count == 0) return;
            await DeleteHotelRateSheetAsync(hotelRateID);
            foreach (var item in ratesheetMasters)
            {
                if(item.RateSheetID == 0) continue;
                var parameters = new DynamicParameters();
                parameters.Add("@Operation", "ADD");
                parameters.Add("@HotelRateID", hotelRateID);
                parameters.Add("@RateSheetID", item.RateSheetID);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_HotelRateMarketSheet", parameters);
            }
        }
        private static async Task CreateHotelRateMarketAsync(List<HotelRateMarketMasterRequestDto> ratesheetMasters, long hotelRateID)
        {
            if (ratesheetMasters == null || ratesheetMasters.Count == 0) return;
            await DeleteHotelRateMarketAsync(hotelRateID);
            foreach (var item in ratesheetMasters)
            {
                if(item.MarketRateID == 0) continue;
                var parameters = new DynamicParameters();
                parameters.Add("@Operation", "ADD");
                parameters.Add("@HotelRateID", hotelRateID);
                parameters.Add("@RateSheetID", item.MarketRateID);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_HotelRateMarket", parameters);
            }
        }
        private static async Task CreateHotelRateVouchersAsync(List<HotelRateVoucherTypeRequestDto> ratesheetMasters, long hotelRateID)
        {
            if (ratesheetMasters == null || ratesheetMasters.Count == 0) return;
            await DeleteHotelRateVouchersAsync(hotelRateID);
            foreach (var item in ratesheetMasters)
            {
                if(item.VoucherTypeID == 0) continue;
                var parameters = new DynamicParameters();
                parameters.Add("@Operation", "ADD");
                parameters.Add("@HotelRateID", hotelRateID);
                parameters.Add("@VoucherTypeID", item.VoucherTypeID);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_HotelRateVoucherType", parameters);
            }
        }
        private static async Task UpdateHotelRateOfferConfigurationAsync(List<HotelRateOfferConfigurationRequestDto> request, long hotelRateDetailID)
        {
            //await DeleteAllOfferConfigurationAsync(hotelRateDetailID);
            if (request is null || request.Count == 0) return;
            foreach (var config in request)
            {
                var parameters = new DynamicParameters();
                var Operation = config.OfferID > 0 ? "UPDATE" : "INSERT";
                parameters.Add("@Operation", Operation);
                parameters.Add("@HotelRateDetailID", hotelRateDetailID);
                parameters.Add("@ID", config.OfferID);
                parameters.Add("@Days", config.Days);
                parameters.Add("@FromDate", CommonFunctions.ParseDate(config.FromDate));
                parameters.Add("@ToDate", CommonFunctions.ParseDate(config.ToDate));
                parameters.Add("@TotalNights", config.TotalNights);
                parameters.Add("@PaidNights", config.PaidNights);
                parameters.Add("@FreeNights", config.FreeNights);
                parameters.Add("@IsExtendible", config.IsExtendible);
                parameters.Add("@IsActive", config.IsActive);
                parameters.Add("@IsDeleted", config.IsDeleted);
                parameters.Add("@OfferID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
                await SqlHelper.SaveAsync("RateCards.CreateOrUpdate_HotelRateOfferConfiguration", parameters);
                long offerID = Convert.ToInt64(parameters.Get<string>("@OfferID"));

                await DeleteAndCreateOfferConfigurationCommissions(config, offerID, Operation);
            }
        }

        private static async Task DeleteAllOfferConfigurationAsync(long hotelRateDetailID)
        {
            var deleteCommissionParameters = new DynamicParameters();
            deleteCommissionParameters.Add("@Operation", "DELETEALL");
            deleteCommissionParameters.Add("@OfferID", 0);
            deleteCommissionParameters.Add("@HotelRateDetailID", hotelRateDetailID);
            await SqlHelper.SaveAsync("RateCards.Delete_HotelRateOfferConfigurationCommission", deleteCommissionParameters);
        }

        private static async Task DeleteAndCreateOfferConfigurationCommissions(HotelRateOfferConfigurationRequestDto request, long offerID,string Operation)
        {
            //await DeleteOfferConfigurationCommissions(offerID);
            foreach (var commission in request.OfferCommission)
            {
                var commissionParameters = new DynamicParameters();
                commissionParameters.Add("@Operation", Operation);
                commissionParameters.Add("@OfferID", offerID);
                commissionParameters.Add("@MasterCommissionID", commission.MasterCommissionID);
                commissionParameters.Add("@Discount", commission.Discount);
                commissionParameters.Add("@DiscountAmount", commission.DiscountAmount);
                commissionParameters.Add("@Tax", commission.TaxPercentage);
                commissionParameters.Add("@TaxAmount", commission.TaxAmount);
                commissionParameters.Add("@PaidNightAmountExcludingTax", commission.PaidNightAmountExcludingTax);
                commissionParameters.Add("@PaidNightAmountIncludingTax", commission.PaidNightAmountIncludingTax);
                commissionParameters.Add("@FreeNightAmountExcludingTax", commission.FreeNightAmountExcludingTax);
                commissionParameters.Add("@FreeNightAmountIncludingTax", commission.FreeNightAmountIncludingTax);
                commissionParameters.Add("@GrossAmountExcludingTax", commission.GrossAmountExcludingTax);
                commissionParameters.Add("@GrossAmountIncludingTax", commission.GrossAmountIncludingTax);
                commissionParameters.Add("@NetAmountExcludingTax", commission.NetAmountExcludingTax);
                commissionParameters.Add("@NetAmountIncludingTax", commission.NetAmountIncludingTax);
                commissionParameters.Add("@OfferCommissionID", commission.OfferCommissionID);
                await SqlHelper.SaveAsync("RateCards.CreateOrUpdate_HotelRateOfferConfigurationCommission", commissionParameters);
            }
        }
        public static async Task DeleteOfferConfigurationCommissions(long offerID)
        {
            var deleteCommissionParameters = new DynamicParameters();
            deleteCommissionParameters.Add("@Operation", "DELETEALL");
            deleteCommissionParameters.Add("@OfferID", offerID);
            deleteCommissionParameters.Add("@HotelRateDetailID", 0);
            await SqlHelper.SaveAsync("RateCards.Delete_HotelRateOfferConfigurationCommission", deleteCommissionParameters);
        }
        private static async Task DeleteHotelRateSheetAsync(long hotelRateID)
        {
            if (hotelRateID == 0) return;
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "DELETE");
            parameters.Add("@HotelRateID", hotelRateID);
            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_HotelRateMarketSheet", parameters);
        }
        private static async Task DeleteHotelRateMarketAsync(long hotelRateID)
        {
            if (hotelRateID == 0) return;
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "DELETE");
            parameters.Add("@HotelRateID", hotelRateID);
            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_HotelRateMarket", parameters);
        }
        private static async Task DeleteHotelRateVouchersAsync(long hotelRateID)
        {
            if (hotelRateID == 0) return;
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "DELETE");
            parameters.Add("@HotelRateID", hotelRateID);
            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_HotelRateVoucherType", parameters);
        }
        private static async Task UpdateHotelRateValidityAsync(List<HotelRateValidityRequestDto> request)
        {
            if(request == null || request.Count == 0) return;
            int IsUpdated = 0;
            foreach (var item in request)
            {
                item.IsUpdated = IsUpdated;
                var parameters = GetHotelRateValidityParameters(item);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_RateValidityMaster", parameters);
                IsUpdated = 1;
            }
        }
        private static async Task UpdateHotelRateCommissionDetailAsync(List<HotelRateCommissionDetailRequestDto> request)
        {
            if (request == null || request.Count == 0) return;
            foreach (var item in request)
            {
                var parameters = GetHotelRateCommissionDetailParameters(item);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_RateCommissionDetail", parameters);
            }
        }
        private static async Task UpdateHotelRateMealAsync(List<HotelRateMealRequestDto> request)
        {
            if (request == null || request.Count == 0) return;
            foreach (var item in request)
            {
                var parameters = GetHotelRateMealParameters(item);
                await SqlHelper.SaveAsync("[RateCards].[CreateOrUpdate_HotelRateMeal]", parameters);
            }
        }
        private static DynamicParameters GetHotelRateParameters(HotelRateRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.HotelRateID);
            parameter.Add("@RateCardModeTypeID", (int) request.RateCardModeTypeID);
            parameter.Add("@Heading", request.Heading);
            parameter.Add("@ContractDate", CommonFunctions.ParseDate(request.ContractDate));
            parameter.Add("@HotelID", request.HotelID);
            parameter.Add("@CityID", request.CityID);
            parameter.Add("@ValueAddOn", request.ValueAddOn);
            parameter.Add("@CurrencyID", request.CurrencyID);
            parameter.Add("@VendorID", request.VendorID);
            parameter.Add("@RateTypeID", request.RateTypeID);
            parameter.Add("@InfoForOperation", request.InfoForOperation);
            parameter.Add("@InfoForRemark", request.InfoForRemark);
            parameter.Add("@InfoForAgent", request.InfoForAgent);
            parameter.Add("@StateID", request.StateID);
            parameter.Add("@GstStatus", request.GstStatus);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@PaymentTypeID", (int)request.PaymentTypeID);
            parameter.Add("@IsCommission", request.IsCommission);
            parameter.Add("@HotelRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@UpdatedBy", request.OperationBy);

            return parameter;
        }
        private static DynamicParameters GetHotelRateMealParameters(HotelRateMealRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.HotelRateMealID);
            parameter.Add("@IsMealDetails", request.IsMealDetails);
            parameter.Add("@DefineAmount", request.DefinedAmount);
            parameter.Add("@MasterCommissionID", request.MealTypeID);
            parameter.Add("@GstPercentage", request.GstPercentage);
            parameter.Add("@GstAmount", request.GstAmount);
            parameter.Add("@NetAmountIncludingTax", request.NetAmountIncludingTax);
            parameter.Add("@NetAmountExcludingTax", request.NetAmountExcludingTax);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@UpdatedBy", request.OperationBy);
            //parameter.Add("@RateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetHotelRateDetailParameters(HotelRateDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.HotelRateDetailID);
            parameter.Add("@TaxID", (int) request.TaxID);
            parameter.Add("@RoomCategoryID", request.RoomCategoryID);
            parameter.Add("@Days", request.Days);
            parameter.Add("@FIT", request.FIT);
            parameter.Add("@GIT", request.GIT);
            parameter.Add("@MealPlanID", request.MealPlanID);
            parameter.Add("@TransferID", request.TransferID);
            parameter.Add("@MinNights", request.MinNights);
            parameter.Add("@MaxNights", request.MaxNights);
            parameter.Add("@RateTypeID", request.RateTypeID);
            parameter.Add("@OfferTypeID", (int)request.OfferTypeID);
            parameter.Add("@MISSequence", request.MISSequence);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@UpdatedBy", request.OperationBy);
            parameter.Add("@HotelRateID", request.HotelRateID);
            parameter.Add("@BusinessType", request.BusinessType);
            parameter.Add("@HotelRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetHotelRateValidityParameters(HotelRateValidityRequestDto request)
        {
            var parameter = new DynamicParameters();

            parameter.Add("@Operation", request.RateValidityID == 0 ? "INSERT" : "UPDATE");
            parameter.Add("@ID", request.RateValidityID);
            parameter.Add("@BookFrom", CommonFunctions.ParseDate(request.BookFrom));
            parameter.Add("@BookTo", CommonFunctions.ParseDate(request.BookTo));
            parameter.Add("@RateValidFrom", CommonFunctions.ParseDate(request.RateValidFrom));
            parameter.Add("@RateValidTo", CommonFunctions.ParseDate(request.RateValidTo));
            parameter.Add("@UpdatedBy", request.OperationBy);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@IsUpdated", request.IsUpdated);
            parameter.Add("@HotelRateDetailID", request.HotelRateDetailID);
            parameter.Add("@RateValidityID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetHotelRateCommissionDetailParameters(HotelRateCommissionDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "UPDATE");
            parameter.Add("@ID", request.RateCommissionID);
            parameter.Add("@TaxPercentage", request.TaxPercentage);
            parameter.Add("@TaxAmount", request.TaxAmount);
            parameter.Add("@GrossAmountIncludingTax", request.GrossAmountIncludingTax);
            parameter.Add("@GrossAmountExcludingTax", request.GrossAmountExcludingTax);
            parameter.Add("@NetAmountIncludingTax", request.NetAmountIncludingTax);
            parameter.Add("@NetAmountExcludingTax", request.NetAmountExcludingTax);
            parameter.Add("@CommissionPercentage", request.CommissionPercentage);
            parameter.Add("@CommissionAmount", request.CommissionAmount);
            parameter.Add("@MasterCommissionID", request.MasterCommissionID);
            parameter.Add("@IsTax", request.IsTax);
            parameter.Add("@UpdatedBy", request.OperationBy);
            parameter.Add("@RateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }


        private static async Task UpdateCustomHotelRateCommissionDetailAsync(List<CustomRateCommission> request,long hotelrateid)
        {
            if (request == null || request.Count == 0) return;
            foreach (var item in request)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@Operation", "UPDATE"); // "INSERT" or "UPDATE"
                parameters.Add("@RateCommisionID", item.RateCommissionID);
                parameters.Add("@CommissionMasterID", item.MasterCommissionID);
                parameters.Add("@NetAmountExcludingTax", item.NetAmountExcludingTax);
                parameters.Add("@NetAmountIncludingTax", item.NetAmountIncludingTax);
                parameters.Add("@GrossAmountIncludingTax", item.GrossAmountIncludingTax);
                parameters.Add("@GrossAmountExcludingTax", item.GrossAmountExcludingTax);
                parameters.Add("@CommisionPercentage", item.CommissionPercentage);
                parameters.Add("@CommissionAmount", item.CommissionAmount);
                parameters.Add("@IsTax", item.IsTax);
                parameters.Add("@TaxPercentage", item.TaxPercentage);
                parameters.Add("@TaxAmount", item.TaxAmount);
                parameters.Add("@HotelRateID", hotelrateid);
                parameters.Add("@IsActive", item.IsActive);
                parameters.Add("@CreatedBy", item.OperationBy); // Assuming OperationBy is used for both insert/update
                parameters.Add("@UpdatedBy", item.OperationBy);
                parameters.Add("@IsAmtIncludedInBasic", item.IsAmtIncludedInBasic);
                parameters.Add("@MinimumPax", item.MinimumPax);
                parameters.Add("@MaximumPax", item.MaximumPax);
                await SqlHelper.SaveAsync("[CustomRateCards].[CreateOrUpdate_HotelRateCommission]", parameters);
            }
        }
        private static async Task UpdateCustomHotelRateMealAsync(List<HotelRateMealRequestDto> request,long hotelrateid)
        {
            if (request == null || request.Count == 0) return;
            foreach (var item in request)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@Operation", "Update"); // "INSERT" or "UPDATE"
                parameters.Add("@HotelRateMealID", item.HotelRateMealID);
                parameters.Add("@HotelRateID", hotelrateid);
                parameters.Add("@MealTypeID", item.MealTypeID);
                parameters.Add("@GstPercentage", item.GstPercentage);
                parameters.Add("@GstAmount", item.GstAmount);
                parameters.Add("@NetAmountIncludingTax", item.NetAmountIncludingTax);
                parameters.Add("@NetAmountExcludingTax", item.NetAmountExcludingTax);
                parameters.Add("@IsActive", item.IsActive);
                parameters.Add("@MasterCommissionID", item.MasterCommissionID);
                parameters.Add("@IsMealDetails", item.IsMealDetails);
                parameters.Add("@DefineAmount", item.DefinedAmount);
                parameters.Add("@CreatedBy", item.OperationBy); // Used during INSERT
                parameters.Add("@UpdatedBy", item.OperationBy); // Used during UPDATE
                await SqlHelper.SaveAsync("[CustomRateCards].[CreateOrUpdate_HotelRateMeal]", parameters);
            }
        }
    }
}
