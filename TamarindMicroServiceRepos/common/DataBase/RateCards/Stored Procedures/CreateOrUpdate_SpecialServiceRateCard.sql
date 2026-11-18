CREATE PROCEDURE [RateCards].[CreateOrUpdate_SpecialServiceRateCard]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@ContractDate DATETIME = NULL,
@CurrencyID VARCHAR(10),
@Heading VARCHAR(100)= NULL,
@RateCardModeTypeID INT= NULL,
@VendorID INT = NULL,
@SpecialServiceID INT = NULL,
@CityID VARCHAR(3) = NULL,
@InfoForOperation VARCHAR(200) = NULL,
<<<<<<< HEAD
<<<<<<< HEAD
@InfoForRemark VARCHAR(200) = NULL,
=======
@InfoForRemark VARCHAR(max) = NULL,
>>>>>>> dev
=======
@InfoForRemark VARCHAR(max) = NULL,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
@InfoForAgent VARCHAR(200) = NULL,
@GSTStatus VARCHAR(20) NULL,
@StateID INT = 0,
@HrsPerDay INT = 0,
@KmPerDay INT = 0,
@IsActive BIT = 1,
@HotelId BigInt = 0,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
<<<<<<< HEAD
<<<<<<< HEAD
=======
@BookingID bigint =null,
>>>>>>> dev
=======
@BookingID bigint =null,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
@SpecialServiceRateID BIGINT OUTPUT,
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
		SET @CardNoMax = (SELECT MAX(CAST(SUBSTRING(CardNumber, 6, 6) AS INT)) 
                  FROM [RateCards].[SpecialServiceRateMaster] WHERE SUBSTRING(CardNumber, 2, 4) = @CurrentMonthPrefix)

		-- If no records exist for the current month, start from 1
		SET @CardNoMax = CASE WHEN @CardNoMax IS NULL THEN '1' ELSE CAST(@CardNoMax AS INT) + 1 END
		-- Generate the new CardNo
		SET @CardNumber = 'M' + @CurrentMonthPrefix + RIGHT('000000' + CAST(@CardNoMax AS VARCHAR), 6)
		INSERT INTO [RateCards].[SpecialServiceRateMaster](ID,CardNumber,ContractDate,Heading,SpecialServiceID,RateCardModeTypeID,InfoForOperation,
<<<<<<< HEAD
<<<<<<< HEAD
		InfoForAgent,InfoForRemark,CityID,StateID,GSTStatus,VendorID,CurrencyID,HrsPerDay,KmPerDay,IsActive,CreatedBy,CreatedOn,HotelID)
		VALUES(NEWID(),@CardNumber,@ContractDate,@Heading,@SpecialServiceID,@RateCardModeTypeID,@InfoForOperation,@InfoForAgent,
		@InfoForRemark,@CityID,@StateID,@GSTStatus,@VendorID,@CurrencyID,@HrsPerDay,@KmPerDay,@IsActive,@CreatedBy,GETDATE(),@HotelId)
=======
		InfoForAgent,InfoForRemark,CityID,StateID,GSTStatus,VendorID,CurrencyID,HrsPerDay,KmPerDay,IsActive,CreatedBy,CreatedOn,HotelID,BookingID)
		VALUES(NEWID(),@CardNumber,@ContractDate,@Heading,@SpecialServiceID,@RateCardModeTypeID,@InfoForOperation,@InfoForAgent,
		@InfoForRemark,@CityID,@StateID,@GSTStatus,@VendorID,@CurrencyID,@HrsPerDay,@KmPerDay,@IsActive,@CreatedBy,GETDATE(),@HotelId,@BookingID)
>>>>>>> dev
=======
		InfoForAgent,InfoForRemark,CityID,StateID,GSTStatus,VendorID,CurrencyID,HrsPerDay,KmPerDay,IsActive,CreatedBy,CreatedOn,HotelID,BookingID)
		VALUES(NEWID(),@CardNumber,@ContractDate,@Heading,@SpecialServiceID,@RateCardModeTypeID,@InfoForOperation,@InfoForAgent,
		@InfoForRemark,@CityID,@StateID,@GSTStatus,@VendorID,@CurrencyID,@HrsPerDay,@KmPerDay,@IsActive,@CreatedBy,GETDATE(),@HotelId,@BookingID)
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

		SET @SpecialServiceRateID = @@IDENTITY
		SELECT '200' AS returnCode, 'New record added  successfully.' AS returnMessage, @SpecialServiceRateID AS ID  

	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		
		UPDATE [RateCards].[SpecialServiceRateMaster]
		SET ContractDate = @ContractDate,Heading = @Heading,SpecialServiceID = @SpecialServiceID,RateCardModeTypeID = @RateCardModeTypeID,
		InfoForOperation = @InfoForOperation, InfoForAgent = @InfoForAgent,InfoForRemark = @InfoForRemark,CityID = @CityID,StateID = @StateID,
		GSTStatus = @GSTStatus,VendorID = @VendorID,CurrencyID = @CurrencyID,
		HrsPerDay = @HrsPerDay,KmPerDay = @KmPerDay,
		IsActive = @IsActive,UpdatedBy = @UpdatedBy, UpdatedOn = GETDATE(), HotelID=@HotelId
		WHERE SpecialServiceRateID = @ID

		SET @SpecialServiceRateID = @ID
		SET @CardNumber = (SELECT CardNumber FROM [RateCards].[SpecialServiceRateMaster] WHERE SpecialServiceRateID = @ID)

		SELECT '200' AS returnCode, 'New record updated  successfully.' AS returnMessage, @SpecialServiceRateID AS ID  

	END
END