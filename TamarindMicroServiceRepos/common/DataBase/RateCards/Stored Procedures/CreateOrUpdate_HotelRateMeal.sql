CREATE PROCEDURE [RateCards].[CreateOrUpdate_HotelRateMeal]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@MasterCommissionID INT = 0,
@HotelRateDetailID BIGINT = 0,
@MealTypeID INT = 0,
@IsMealDetails BIT = NULL,
@DefineAmount DECIMAL(18,2) = NULL,
@GstPercentage DECIMAL(18,2) = NULL,
@GstAmount DECIMAL(18,2) = NULL,
@NetAmountIncludingTax DECIMAL(18,2) = NULL,
@NetAmountExcludingTax DECIMAL(18,2) = NULL,
@IsActive BIT = 1,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN

		INSERT INTO [RateCards].HotelMealOverviewMaster(HotelRateDetailID,MealTypeID,GstPercentage,GstAmount,NetAmountIncludingTax,
		NetAmountExcludingTax,CreatedBy,CreatedOn,IsActive,MasterCommissionID,IsMealDetails,DefineAmount)
		VALUES (@HotelRateDetailID,@MealTypeID,@GstPercentage,@GstAmount,@NetAmountIncludingTax,@NetAmountExcludingTax,
		NEWID(),GETDATE(),@IsActive,@MasterCommissionID,@IsMealDetails,@DefineAmount)
	END

	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		UPDATE [RateCards].HotelMealOverviewMaster
		SET MealTypeID = @MealTypeID, GstPercentage = @GstPercentage,GstAmount = @GstAmount,
		NetAmountIncludingTax = @NetAmountIncludingTax,
		NetAmountExcludingTax = @NetAmountExcludingTax, 
		UpdatedOn = GETDATE(),UpdatedBy = NEWID(), IsActive = @IsActive,
		IsMealDetails = @IsMealDetails, DefineAmount = @DefineAmount
		WHERE HotelRateMealID = @ID
	END
END
