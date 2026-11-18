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
    public class CreateHotelRateRepository : ICreateHotelRateRepository
    {
        public async Task<ApiResponseWrapper> CreateHotelRateCardAsync(HotelRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetHotelRateCardParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_HotelRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@HotelRateID"));
            respone.CardNumber = parameters.Get<string>("@CardNumber");
            request.CardNumber = respone.CardNumber;
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_HotelRateCard");

            await CreateHotelRateSheetAsync(request.Ratesheet, respone.RateCardID);
            await CreateHotelRateMarketAsync(request.Market, respone.RateCardID);
            await CreateHotelRateVouchersAsync(request.Voucher, respone.RateCardID);

            respone.Message = "Rate card created successfully";
            return respone;
        }

        public async Task<ApiResponseWrapper> CreateCustomHotelRateCardAsync(CustomHotelRateRequestDto request, RateCardType type)
        {
            var respone = new ApiResponseWrapper();
            var parameters = new DynamicParameters();
            parameters.Add("@Operation", "INSERT"); // "INSERT" or "UPDATE"
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
            parameters.Add("@RateType", (int)type);
            parameters.Add("@RatePreferenceID", request.RatePreferenceID);
            parameters.Add("@CheckIn", request.CheckIn);
            parameters.Add("@CheckOut", request.CheckOut);
            parameters.Add("@QuotationID", request.QuotationID);
            parameters.Add("@HotelRateID", dbType: DbType.Int64, direction: ParameterDirection.Output);
            await SqlHelper.SaveAsync("[CustomRateCards].[CreateOrUpdate_HotelRateCard]", parameters);

            //respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@HotelRateID"));
            respone.RateCardID = Convert.ToInt64(parameters.Get<long>("@HotelRateID"));

            //respone.RateCardID = parameters.Get<long>("@HotelRateID");
            //respone.CardNumber = parameters.Get<string>("@CardNumber") ?? string.Empty;

            //TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CustomRateCards_CreateOrUpdate_HotelRateCard");

            await CreateCustomHotelRateCommissionDetailAsync(request.Commissions, respone.RateCardID);
            await CreateCustomHotelRateMealAsync(request.Meals, respone.RateCardID);

            respone.Message = "Rate card created successfully";
            return respone;
        }

        public async Task<ApiResponseWrapper> CreateNegotiateHotelRateCardAsync(CustomHotelRateRequestDto request, RateCardType type)
        {
            var respone = new ApiResponseWrapper();
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
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
            parameter.Add("@StateID", 0);
            parameter.Add("@GstStatus", 0);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@PaymentTypeID", (int)request.PaymentTypeID);
            parameter.Add("@IsCommission", request.IsCommission);
            parameter.Add("@HotelRateID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CardNumber", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@RateCardModeTypeID",3);
            parameter.Add("@BookingID", request.BookingID);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_HotelRateCard", parameter);
            respone.RateCardID = Convert.ToInt64(parameter.Get<string>("@HotelRateID"));
            respone.CardNumber = parameter.Get<string>("@CardNumber");
            request.CardNumber = respone.CardNumber;
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_HotelRateCard");
            if (respone.RateCardID != null && respone.RateCardID != 0)
            {
                parameter = new DynamicParameters();
                parameter.Add("@Operation", "INSERT");
                parameter.Add("@RoomCategoryID", request.RoomCategoryID);
                parameter.Add("@Days", request.Days);
                parameter.Add("@TaxID", (int)request.TaxID);
                parameter.Add("@FIT", request.FIT);
                parameter.Add("@GIT", request.GIT);
                parameter.Add("@MealPlanID", request.MealPlanID);
                parameter.Add("@TransferID", request.TransferID);
                parameter.Add("@MinNights", request.MinNights);
                parameter.Add("@MaxNights", request.MaxNights);
                parameter.Add("@RateTypeID", request.RateTypeID);
                parameter.Add("@OfferTypeID", request.OfferTypeID);
                parameter.Add("@MISSequence", request.MISSequence);
                parameter.Add("@IsActive", request.IsActive);
                parameter.Add("@CreatedBy", request.OperationBy);
                parameter.Add("@HotelRateID", respone.RateCardID);
                parameter.Add("@BusinessType", request.BusinessType);
                parameter.Add("@HotelRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_HotelRateDetail", parameter);
                var HotelRateDetailID = Convert.ToInt64(parameter.Get<string>("@HotelRateDetailID"));
                //Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_HotelRateDetail");
                //respone.Message = "Rate detail created successfully";

                List<HotelRateValidityRequestDto> Validity = new List<HotelRateValidityRequestDto>();
                HotelRateValidityRequestDto ValidityObj = new HotelRateValidityRequestDto();
                ValidityObj.RateValidFrom = request.Validfrom;
                ValidityObj.RateValidTo = request.ValidTo;
                ValidityObj.BookFrom = request.Validfrom;
                ValidityObj.BookTo = request.Validfrom;
                ValidityObj.HotelRateDetailID = HotelRateDetailID;
                Validity.Add(ValidityObj);

                await CreateHotelRateValidityAsync(Validity, HotelRateDetailID);
                if (request.Commissions != null || request.Commissions.Count > 0)
                    foreach (var item in request.Commissions)
                    {
                        HotelRateCommissionDetailRequestDto CommissionsObj = new HotelRateCommissionDetailRequestDto();
                        CommissionsObj.MasterCommissionID = item.MasterCommissionID;
                        CommissionsObj.TaxPercentage = item.TaxPercentage;
                        CommissionsObj.TaxAmount = item.TaxAmount;
                        CommissionsObj.GrossAmountIncludingTax = item.GrossAmountIncludingTax;
                        CommissionsObj.GrossAmountExcludingTax = item.GrossAmountExcludingTax;
                        CommissionsObj.NetAmountIncludingTax = item.NetAmountIncludingTax;
                        CommissionsObj.NetAmountExcludingTax = item.NetAmountExcludingTax;
                        CommissionsObj.CommissionPercentage = item.CommissionPercentage;
                        CommissionsObj.CommissionAmount = item.CommissionAmount;
                        CommissionsObj.HotelRateDetailID = HotelRateDetailID;
                        CommissionsObj.CreatedBy = request.OperationBy.ToString();
                        parameter.Add("@RateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
                        item.HotelRateDetailID = HotelRateDetailID;
                        var parameters = GetHotelRateCommissionDetailParameters(CommissionsObj);
                        await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_RateCommissionDetail", parameters);
                    }
                await CreateHotelRateMealAsync(request.Meals, HotelRateDetailID);
            }
            else
            {
                respone.RateCardID = 0;
            }
            respone.Message = "Rate card created successfully";
            return respone;
        }

        public async Task<ApiResponseWrapper> CopyHotelRateAsync(HotelRateRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = CopyHotelRateParameters(request);

            await SqlHelper.SaveAsync("[RateCards].Copy_HotelRateCard", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<Int64>("@HotelRateID"));
            TamarindAstra.Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_HotelRateCard");
            respone.Message = "New rate configuration added successfully";
            return respone;
        }
        public async Task<ApiResponseWrapper> CreateHotelRateDetailAsync(HotelRateDetailRequestDto request)
        {
            var respone = new ApiResponseWrapper();
            var parameters = GetHotelRateDetailParameters(request);

            await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_HotelRateDetail", parameters);
            respone.RateCardID = Convert.ToInt64(parameters.Get<string>("@HotelRateDetailID"));
            Common.RabbitMQService.StoreDataInQueue(request, Convert.ToInt32(respone.RateCardID), "CreateOrUpdate_HotelRateDetail");
            respone.Message = "Rate detail created successfully";

            await CreateHotelRateValidityAsync(request.Validities, respone.RateCardID);
            await CreateHotelRateCommissionDetailAsync(request.Commissions, respone.RateCardID);
            await CreateHotelRateMealAsync(request.Meals, respone.RateCardID);
            await CreateHotelRateOfferConfigurationAsync(request.OfferConfiguration, respone.RateCardID);
            return respone;
        }
        private static async Task CreateHotelRateOfferConfigurationAsync(List<HotelRateOfferConfigurationRequestDto> request, long hotelRateDetailID)
        {
            if (request is null || request.Count == 0) return;
            foreach (var config in request)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@Operation", "INSERT");
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
                parameters.Add("@OfferID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
                await SqlHelper.SaveAsync("RateCards.CreateOrUpdate_HotelRateOfferConfiguration", parameters);
                long offerID = Convert.ToInt64(parameters.Get<string>("@OfferID"));
                await CreateOfferConfigurationCommissions(config, offerID);
            }
        }
        private static async Task CreateOfferConfigurationCommissions(HotelRateOfferConfigurationRequestDto request, long offerID)
        {
            foreach (var commission in request.OfferCommission)
            {
                var commissionParameters = new DynamicParameters();
                commissionParameters.Add("@Operation", "INSERT");
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
                await SqlHelper.SaveAsync("RateCards.CreateOrUpdate_HotelRateOfferConfigurationCommission", commissionParameters);
            }
        }
        private static async Task CreateHotelRateSheetAsync(List<HotelRatesheetMasterRequestDto> ratesheetMasters, long hotelRateID)
        {
            if (ratesheetMasters == null || ratesheetMasters.Count == 0) return;
            foreach (var item in ratesheetMasters)
            {
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
            foreach (var item in ratesheetMasters)
            {
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
            foreach (var item in ratesheetMasters)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@Operation", "ADD");
                parameters.Add("@HotelRateID", hotelRateID);
                parameters.Add("@VoucherTypeID", item.VoucherTypeID);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_HotelRateVoucherType", parameters);
            }
        }
        private static async Task CreateHotelRateValidityAsync(List<HotelRateValidityRequestDto> request, long hotelRateDetailID)
        {
            if (request == null || request.Count == 0) return;
            foreach (var item in request)
            {
                item.HotelRateDetailID = hotelRateDetailID;
                var parameters = GetHotelRateValidityParameters(item);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_RateValidityMaster", parameters);
            }
        }
        private static async Task CreateHotelRateCommissionDetailAsync(List<HotelRateCommissionDetailRequestDto> request, long hotelRateDetailID)
        {
            if (request == null || request.Count == 0) return;
            foreach (var item in request)
            {

                item.HotelRateDetailID = hotelRateDetailID;
                var parameters = GetHotelRateCommissionDetailParameters(item);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_RateCommissionDetail", parameters);
            }
        }
        private static async Task CreateHotelRateMealAsync(List<HotelRateMealRequestDto> request, long hotelRateDetailID)
        {
            if (request == null || request.Count == 0) return;
            foreach (var item in request)
            {
                item.HotelRateDetailID = hotelRateDetailID;
                var parameters = GetHotelRateMealParameters(item);
                await SqlHelper.SaveAsync("[RateCards].CreateOrUpdate_HotelRateMeal", parameters);
            }
        }
        private static async Task CreateCustomHotelRateCommissionDetailAsync(List<CustomRateCommission> request, long HotelRateID)
        {
            if (request == null || request.Count == 0) return;
            foreach (var item in request)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@Operation", "INSERT"); // "INSERT" or "UPDATE"
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
                parameters.Add("@HotelRateID", HotelRateID);
                parameters.Add("@IsActive", item.IsActive);
                parameters.Add("@CreatedBy", item.OperationBy); // Assuming OperationBy is used for both insert/update
                parameters.Add("@UpdatedBy", item.OperationBy);
                parameters.Add("@IsAmtIncludedInBasic", item.IsAmtIncludedInBasic);
                parameters.Add("@MinimumPax", item.MinimumPax);
                parameters.Add("@MaximumPax", item.MaximumPax);
                await SqlHelper.SaveAsync("[CustomRateCards].[CreateOrUpdate_HotelRateCommission]", parameters);
            }
        }
        private static async Task CreateCustomHotelRateMealAsync(List<HotelRateMealRequestDto> request, long hotelRateID)
        {
            if (request == null || request.Count == 0) return;
            foreach (var item in request)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@Operation", "INSERT"); // "INSERT" or "UPDATE"
                parameters.Add("@HotelRateMealID", item.HotelRateMealID);
                parameters.Add("@HotelRateID", hotelRateID);
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
        private static DynamicParameters GetHotelRateMealParameters(HotelRateMealRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@IsMealDetails", request.IsMealDetails);
            parameter.Add("@DefineAmount", request.DefinedAmount);
            parameter.Add("@MasterCommissionID", request.MealTypeID);
            parameter.Add("@GstPercentage", request.GstPercentage);
            parameter.Add("@GstAmount", request.GstAmount);
            parameter.Add("@NetAmountIncludingTax", request.NetAmountIncludingTax);
            parameter.Add("@NetAmountExcludingTax", request.NetAmountExcludingTax);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@HotelRateDetailID", request.HotelRateDetailID);
            //parameter.Add("@RateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetHotelRateDetailParameters(HotelRateDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@RoomCategoryID", request.RoomCategoryID);
            parameter.Add("@Days", request.Days);
            parameter.Add("@TaxID", (int)request.TaxID);
            parameter.Add("@FIT", request.FIT);
            parameter.Add("@GIT", request.GIT);
            parameter.Add("@MealPlanID", request.MealPlanID);
            parameter.Add("@TransferID", request.TransferID);
            parameter.Add("@MinNights", request.MinNights);
            parameter.Add("@MaxNights", request.MaxNights);
            parameter.Add("@RateTypeID", request.RateTypeID);
            parameter.Add("@OfferTypeID", request.OfferTypeID);
            parameter.Add("@MISSequence", request.MISSequence);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@HotelRateID", request.HotelRateID);
            parameter.Add("@BusinessType", request.BusinessType);
            parameter.Add("@HotelRateDetailID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetHotelRateCardParameters(HotelRateRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@RateCardModeTypeID", (int)request.RateCardModeTypeID);
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
            parameter.Add("@CreatedBy", request.OperationBy);
            return parameter;
        }
        private static DynamicParameters GetHotelRateValidityParameters(HotelRateValidityRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@BookFrom", CommonFunctions.ParseDate(request.BookFrom));
            parameter.Add("@BookTo", CommonFunctions.ParseDate(request.BookTo));
            parameter.Add("@RateValidFrom", CommonFunctions.ParseDate(request.RateValidFrom));
            parameter.Add("@RateValidTo", CommonFunctions.ParseDate(request.RateValidTo));
            parameter.Add("@CreatedBy", Guid.NewGuid().ToString());
            parameter.Add("@HotelRateDetailID", request.HotelRateDetailID);
            parameter.Add("@IsActive", request.IsActive);
            parameter.Add("@RateValidityID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters GetHotelRateCommissionDetailParameters(HotelRateCommissionDetailRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@Operation", "INSERT");
            parameter.Add("@MasterCommissionID", request.MasterCommissionID);
            parameter.Add("@TaxPercentage", request.TaxPercentage);
            parameter.Add("@TaxAmount", request.TaxAmount);
            parameter.Add("@GrossAmountIncludingTax", request.GrossAmountIncludingTax);
            parameter.Add("@GrossAmountExcludingTax", request.GrossAmountExcludingTax);
            parameter.Add("@NetAmountIncludingTax", request.NetAmountIncludingTax);
            parameter.Add("@NetAmountExcludingTax", request.NetAmountExcludingTax);
            parameter.Add("@CommissionPercentage", request.CommissionPercentage);
            parameter.Add("@CommissionAmount", request.CommissionAmount);
            parameter.Add("@HotelRateDetailID", request.HotelRateDetailID);
            parameter.Add("@CreatedBy", request.OperationBy);
            parameter.Add("@RateCommissionID", dbType: DbType.String, size: 100, direction: ParameterDirection.Output);
            return parameter;
        }
        private static DynamicParameters CopyHotelRateParameters(HotelRateRequestDto request)
        {
            var parameter = new DynamicParameters();
            parameter.Add("@RateCardID", request.HotelRateID, DbType.Int64);
            parameter.Add("@CreatedBy", request.OperationBy, DbType.Guid);
            parameter.Add("@HotelRateID", dbType: DbType.Int64, direction: ParameterDirection.Output);
            return parameter;
        }
    }
}
