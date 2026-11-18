CREATE PROCEDURE [RateCards].[CreateOrUpdate_GuideRateCard]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@ContractDate DATETIME = NULL,
@CurrencyID VARCHAR(5) = NULL,
@Heading VARCHAR(100)= NULL,
@RateCardModeTypeID INT= NULL,
@LanguageID CHAR(3) = NULL,
@VendorID INT = NULL,
@CityID VARCHAR(10) = NULL,
@StateID VARCHAR(10) = NULL,
@GstStatus VARCHAR(10) = NULL,
@GuideServiceID INT = NULL,
@InfoForOperation VARCHAR(MAX) = NULL,
@InfoForRemark VARCHAR(MAX) = NULL,
@InfoForAgent VARCHAR(MAX) = NULL,
@Notes VARCHAR(MAX) = NULL,
@IsActive BIT = 1,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
<<<<<<< HEAD
<<<<<<< HEAD
=======
@BookingID INT = null,
>>>>>>> dev
=======
@BookingID INT = null,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
@GuideRateID BIGINT OUTPUT,
@CardNumber VARCHAR(25) OUTPUT
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
                  FROM [RateCards].[GuideRateMaster]
                  WHERE SUBSTRING(CardNumber, 2, 4) = @CurrentMonthPrefix)

		-- If no records exist for the current month, start from 1
		SET @CardNoMax = CASE WHEN @CardNoMax IS NULL THEN '1' ELSE CAST(@CardNoMax AS INT) + 1 END
		-- Generate the new CardNo
		SET @CardNumber = 'G' + @CurrentMonthPrefix + RIGHT('000000' + CAST(@CardNoMax AS VARCHAR), 6)
		--SELECT * FROM [RateCards].[GuideRateMaster]
		INSERT INTO [RateCards].[GuideRateMaster](CardNumber,Heading,ContractDate,RateCardModeTypeID,CurrencyID,VendorID,LanguageID,
<<<<<<< HEAD
<<<<<<< HEAD
		CityID,GuideServiceID,InfoForOperation,InfoForRemark,InfoForAgent,Notes,CreatedBy,IsActive,CreatedOn,GstStatus,StateID)
		VALUES(@CardNumber,@Heading,@ContractDate,@RateCardModeTypeID,@CurrencyID,@VendorID,@LanguageID,
		@CityID,@GuideServiceID,@InfoForOperation,@InfoForRemark,@InfoForAgent,@Notes,@CreatedBy,@IsActive,GETDATE(),@GstStatus,@StateID)
=======
		CityID,GuideServiceID,InfoForOperation,InfoForRemark,InfoForAgent,Notes,CreatedBy,IsActive,CreatedOn,GstStatus,StateID,BookingID)
		VALUES(@CardNumber,@Heading,@ContractDate,@RateCardModeTypeID,@CurrencyID,@VendorID,@LanguageID,
		@CityID,@GuideServiceID,@InfoForOperation,@InfoForRemark,@InfoForAgent,@Notes,@CreatedBy,@IsActive,GETDATE(),@GstStatus,@StateID,@BookingID)
>>>>>>> dev
=======
		CityID,GuideServiceID,InfoForOperation,InfoForRemark,InfoForAgent,Notes,CreatedBy,IsActive,CreatedOn,GstStatus,StateID,BookingID)
		VALUES(@CardNumber,@Heading,@ContractDate,@RateCardModeTypeID,@CurrencyID,@VendorID,@LanguageID,
		@CityID,@GuideServiceID,@InfoForOperation,@InfoForRemark,@InfoForAgent,@Notes,@CreatedBy,@IsActive,GETDATE(),@GstStatus,@StateID,@BookingID)
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

		SET @GuideRateID = @@IDENTITY
		SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @GuideRateID AS ID  
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		UPDATE [RateCards].[GuideRateMaster]
		SET Heading = @Heading,ContractDate = @ContractDate,RateCardModeTypeID = @RateCardModeTypeID,CurrencyID = @CurrencyID,
		VendorID = @VendorID,LanguageID = @LanguageID, CityID = @CityID,GuideServiceID = @GuideServiceID,InfoForOperation = @InfoForOperation,
		InfoForRemark = @InfoForRemark,InfoForAgent = @InfoForAgent,Notes = @Notes,UpdatedBy = @UpdatedBy,
		IsActive = @IsActive,UpdatedOn = GETDATE(), GstStatus = @GstStatus, StateID = @StateID
		WHERE GuideRateID = @ID

		SET @GuideRateID = @ID
		SET @CardNumber = (SELECT CardNumber FROM [RateCards].[GuideRateMaster] WHERE GuideRateID = @ID)
		SELECT '200' AS returnCode, 'New record updated successfully.' AS returnMessage, @GuideRateID AS ID  
	END
END