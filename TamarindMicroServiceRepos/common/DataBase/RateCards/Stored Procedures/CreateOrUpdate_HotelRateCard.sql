CREATE PROCEDURE [RateCards].[CreateOrUpdate_HotelRateCard]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@ContractDate DATETIME = NULL,
@CurrencyID VARCHAR(10),
@PaymentTypeID INT NULL,
@StateID INT = NULL,
@GstStatus VARCHAR(20) = NULL,
@Heading VARCHAR(100)= NULL,
@RateCardModeTypeID INT= NULL,
@HotelID INT = NULL,
@VendorID INT = NULL,
@CityID VARCHAR(3) = NULL,
@RateTypeID INT = NULL,
@ValueAddOn VARCHAR(MAX) = NULL,
@InfoForOperation VARCHAR(200) = NULL,
@InfoForRemark VARCHAR(200) = NULL,
@InfoForAgent VARCHAR(MAX) = NULL,
@IsActive BIT = 1,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
@IsCommission BIT = 0,
<<<<<<< HEAD
<<<<<<< HEAD
=======
@BookingID bigint =null,
>>>>>>> dev
=======
@BookingID bigint =null,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
@HotelRateID BIGINT OUTPUT,
@CardNumber VARCHAR(20) OUTPUT
)
AS
BEGIN

	IF @Operation = 'INSERT'
	BEGIN
		DECLARE @CardNoMax VARCHAR(10),@CurrentMonthPrefix VARCHAR(6)
		-- Generate current month prefix (YYMM)
		SET @CurrentMonthPrefix = SUBSTRING(CONVERT(VARCHAR, DATEPART(yy, GETDATE())), 3, 2) +
                          RIGHT('0' + CONVERT(VARCHAR, DATEPART(mm, GETDATE())), 2)

		-- Get the max CardNo for the current month
		SET @CardNoMax = (SELECT MAX(CAST(SUBSTRING(CardNumber, 6, 6) AS INT)) FROM [RateCards].HotelRateMaster 
        WHERE SUBSTRING(CardNumber, 2, 4) = @CurrentMonthPrefix)

		-- If no records exist for the current month, start from 1
		SET @CardNoMax = CASE WHEN @CardNoMax IS NULL THEN '1' ELSE CAST(@CardNoMax AS INT) + 1 END
		-- Generate the new CardNo
		SET @CardNumber = 'H' + @CurrentMonthPrefix + RIGHT('000000' + CAST(@CardNoMax AS VARCHAR), 6)
		INSERT INTO [RateCards].HotelRateMaster(CardNumber,ContractDate,CurrencyID,PaymentTypeID,Heading,
		RateCardModeTypeID,HotelID,VendorID,CityID,RateTypeID,ValueAddOn,InfoForOperation,InfoForRemark,InfoForAgent,
<<<<<<< HEAD
<<<<<<< HEAD
		IsActive,CreatedBy,CreatedOn,StateID,GstStatus,IsCommission)
		VALUES(@CardNumber,@ContractDate,@CurrencyID,@PaymentTypeID,@Heading,@RateCardModeTypeID,
		@HotelID,@VendorID,@CityID,@RateTypeID,@ValueAddOn,@InfoForOperation,@InfoForRemark,@InfoForAgent,@IsActive,
		@CreatedBy,GETDATE(),@StateID,@GstStatus,@IsCommission)
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		IsActive,CreatedBy,CreatedOn,StateID,GstStatus,IsCommission,BookingID)
		VALUES(@CardNumber,@ContractDate,@CurrencyID,@PaymentTypeID,@Heading,@RateCardModeTypeID,
		@HotelID,@VendorID,@CityID,@RateTypeID,@ValueAddOn,@InfoForOperation,@InfoForRemark,@InfoForAgent,@IsActive,
		@CreatedBy,GETDATE(),@StateID,@GstStatus,@IsCommission,@BookingID)
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

		SET @HotelRateID = @@IDENTITY
		SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @HotelRateID AS ID     
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		
		UPDATE [RateCards].HotelRateMaster
		SET ContractDate = @ContractDate,CurrencyID = @CurrencyID,PaymentTypeID = @PaymentTypeID,
		Heading = @Heading, RateCardModeTypeID = @RateCardModeTypeID,HotelID = @HotelID,VendorID = @VendorID,CityID = @CityID,
		RateTypeID = @RateTypeID,ValueAddOn = @ValueAddOn,InfoForOperation = @InfoForOperation,InfoForRemark = @InfoForRemark,InfoForAgent = @InfoForAgent,
		IsActive = @IsActive,UpdatedBy = @UpdatedBy, UpdatedOn = GETDATE(), StateID = @StateID, GstStatus = @GstStatus,IsCommission=@IsCommission
		WHERE HotelRateID = @ID

		SET @HotelRateID = @ID
		SET @CardNumber = (SELECT CardNumber FROM [RateCards].HotelRateMaster WHERE HotelRateID = @ID)

		SELECT '200' AS returnCode, 'New record updated successfully.' AS returnMessage, @HotelRateID AS ID  
	END
END