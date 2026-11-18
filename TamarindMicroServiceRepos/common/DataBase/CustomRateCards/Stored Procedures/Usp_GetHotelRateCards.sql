CREATE PROCEDURE [CustomRateCards].[Usp_GetHotelRateCards]
(
@Operation VARCHAR(30) = 'GETALL',
@CardNumber VARCHAR(MAX) = NULL,
@RateCardModeTypeID VARCHAR(200) = NULL,
@Heading VARCHAR(MAX) = NULL,
@ContractDate VARCHAR(20) = NULL,
@HotelID VARCHAR(max) = NULL,
@IsActive varchar(20) = NULL,
@CityID VARCHAR(Max) = NULL,
@PaymentTypeID VARCHAR(50) = NULL,
@PageSize INT = 10,
@PageNumber INT = 1,
@ID BIGINT = 0,
@RateType int
)
AS
--EXEC [RateCards].[Usp_GetHotelRateCards] @Operation = 'GET_RATEDETAILS_BYID', @ID=405542 @IsActive = 1,@CardNumber = '',@RateCardModeType = '', 
--@Heading = '',@ContractDate='',@Hotel =''

BEGIN
	--Fetch all hote rate card details 
	--DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
	IF @Operation = 'GET_RATEDETAILS_BYID' AND @ID > 0
		BEGIN
			SET NOCOUNT ON;
			SELECT HRD.HotelRateID,HRD.CityID,HRD.CurrencyID,HRD.HotelID,HRD.RoomCategoryID,HRD.MealPlanID,HRD.VendorID,HRD.PaymentTypeID,HRD.IsCommission,
			HRD.IsActive, ISNULL(c.[Name],'') AS City,hm.HotelName,vm.VendorName as Vendor,HRD.IsTax,HRD.LanguageID,HRD.VehicleCategoryID,HRD.ServiceID,
			HRD.NationalityID,HRD.RateType,HRD.RatePreferenceID,HRD.QuotationID,
			--,RC.Name as RoomCategory,TM.TransferValue as TransferValue,MP.Code as MealPlan,HRD.BusinessType,HRD.TaxID,HRD.FIT,HRD.GIT,
			 -- -- Commissions
			  (
				SELECT RC.CommisionPercentage as CommissionPercentage, RC.*,RCM.RateType, RC.CommissionMasterID as MasterCommissionID, RC.RateCommisionID as RateCommissionID
				FROM [CustomRateCards].[HotelRateCommisionDetails] RC left join RateCommissionMaster RCM on RC.CommissionMasterID=RCM.CommMasterID 
				WHERE RC.HotelRateID = HRD.HotelRateID
				FOR JSON PATH
			  ) AS Commissions,
			 -- -- Meals
			  (
				SELECT RM.*, RM.DefineAmount as DefinedAmount FROM [CustomRateCards].[HotelRateMealOverview] RM
				WHERE RM.HotelRateID = HRD.HotelRateID
				FOR JSON PATH
			  ) AS Meals
			FROM CustomRateCards.HotelRateMaster HRD 
			LEFT JOIN [dbo].[HotelMaster] hm ON HRD.HotelID = hm.HotelID
			LEFT JOIN [dbo].[City] c ON c.IATACode = HRD.CityID
			LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = HRD.VendorID
			WHERE HRD.HotelRateID = @ID and HRD.RateType=@RateType
			FOR JSON PATH
		END
END

