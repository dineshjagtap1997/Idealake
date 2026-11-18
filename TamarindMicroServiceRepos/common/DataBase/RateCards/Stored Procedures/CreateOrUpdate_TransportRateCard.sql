<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [RateCards].[CreateOrUpdate_TransportRateCard]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@ContractDate DATETIME = NULL,
@CurrencyID VARCHAR(10),
@StateID INT = NULL,
@GstStatus VARCHAR(20) = NULL,
@Heading VARCHAR(100)= NULL,
@RateCardModeTypeID INT= NULL,
@TransportModeTypeID INT =  NULL,
@TransportServiceID INT = NULL,
@HotelID INT = NULL,
@HotelZone varchar(25) = NULL,
@VendorID INT = NULL,
@CityID VARCHAR(3) = NULL,
@CityID2 VARCHAR(3) = NULL,
@InfoForOperation VARCHAR(200) = NULL,
@InfoForRemark VARCHAR(200) = NULL,
@InfoForAgent VARCHAR(MAX) = NULL,
@IsActive BIT = 1,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
@TransportRateID BIGINT OUTPUT,
@CardNumber VARCHAR(20) OUTPUT
)
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿
CREATE PROCEDURE [RateCards].[CreateOrUpdate_TransportRateCard] (
	@Operation VARCHAR(10) = 'INSERT'
	,@ID BIGINT = 0
	,@ContractDate DATETIME = NULL
	,@CurrencyID VARCHAR(10)
	,@StateID INT = NULL
	,@GstStatus VARCHAR(20) = NULL
	,@Heading VARCHAR(100) = NULL
	,@RateCardModeTypeID INT = NULL
	,@TransportModeTypeID INT = NULL
	,@TransportServiceID INT = NULL
	,@HotelID INT = NULL
	,@HotelZone VARCHAR(25) = NULL
	,@VendorID INT = NULL
	,@CityID VARCHAR(3) = NULL
	,@CityID2 VARCHAR(3) = NULL
	,@InfoForOperation VARCHAR(200) = NULL
	,@InfoForRemark VARCHAR(max) = NULL
	,@InfoForAgent VARCHAR(MAX) = NULL
	,@IsActive BIT = 1
	,@CreatedBy UNIQUEIDENTIFIER = NULL
	,@UpdatedBy UNIQUEIDENTIFIER = NULL
	,@BookingID bigint=null
	,@TransportRateID BIGINT OUTPUT
	,@CardNumber VARCHAR(20) OUTPUT
	)
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
<<<<<<< HEAD
<<<<<<< HEAD
		DECLARE @CardNoMax VARCHAR(10),@CurrentMonthPrefix VARCHAR(6)
		-- Generate current month prefix (YYMM)
		SET @CurrentMonthPrefix = SUBSTRING(CONVERT(VARCHAR, DATEPART(yy, GETDATE())), 3, 2) +
                          RIGHT('0' + CONVERT(VARCHAR, DATEPART(mm, GETDATE())), 2)

		-- Get the max CardNo for the current month
		SET @CardNoMax = (SELECT MAX(CAST(SUBSTRING(CardNumber, 6, 6) AS INT)) FROM RateCards.TransportRateMaster 
        WHERE SUBSTRING(CardNumber, 2, 4) = @CurrentMonthPrefix)

		-- If no records exist for the current month, start from 1
		SET @CardNoMax = CASE WHEN @CardNoMax IS NULL THEN '1' ELSE CAST(@CardNoMax AS INT) + 1 END
		-- Generate the new CardNo
		SET @CardNumber = 'T' + @CurrentMonthPrefix + RIGHT('000000' + CAST(@CardNoMax AS VARCHAR), 6)
		INSERT INTO RateCards.TransportRateMaster(CardNumber,ContractDate,CurrencyID,Heading,TransportModeTypeID,TransportServceID,
		RateCardModeTypeID,HotelID,HotelZone,VendorID,CityID,CityID2,InfoForOperation,InfoForRemark,InfoForAgent,
		IsActive,CreatedBy,CreatedOn,StateID,GstStatus)
		VALUES(@CardNumber,@ContractDate,@CurrencyID,@Heading,@TransportModeTypeID,@TransportServiceID,@RateCardModeTypeID,
		@HotelID,@HotelZone,@VendorID,@CityID,@CityID2,@InfoForOperation,@InfoForRemark,@InfoForAgent,@IsActive,
		@CreatedBy,GETDATE(),@StateID,@GstStatus)

		SET @TransportRateID = @@IDENTITY
				SELECT '200' AS returnCode, 'New record added  successfully.' AS returnMessage, @TransportRateID AS ID 
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		
		UPDATE RateCards.TransportRateMaster
		SET ContractDate = @ContractDate,CurrencyID = @CurrencyID,TransportModeTypeID = @TransportModeTypeID,
		Heading = @Heading, RateCardModeTypeID = @RateCardModeTypeID,HotelID = @HotelID,HotelZone=@HotelZone,VendorID = @VendorID,CityID = @CityID,
		TransportServceID = @TransportServiceID,InfoForOperation = @InfoForOperation,
		InfoForRemark = @InfoForRemark,InfoForAgent = @InfoForAgent,CityID2 = @CityID2,
		IsActive = @IsActive, UpdatedBy = @UpdatedBy, UpdatedOn = GETDATE(), StateID = @StateID, GstStatus = @GstStatus
		WHERE TransportRateID = @ID

		SET @TransportRateID = @ID
		SET @CardNumber = (SELECT CardNumber FROM RateCards.TransportRateMaster WHERE TransportRateID = @ID)
		SELECT '200' AS returnCode, 'New record updated  successfully.' AS returnMessage, @TransportRateID AS ID 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		DECLARE @CardNoMax VARCHAR(10)
			,@CurrentMonthPrefix VARCHAR(6)

		-- Generate current month prefix (YYMM)
		SET @CurrentMonthPrefix = SUBSTRING(CONVERT(VARCHAR, DATEPART(yy, GETDATE())), 3, 2) + RIGHT('0' + CONVERT(VARCHAR, DATEPART(mm, GETDATE())), 2)
		-- Get the max CardNo for the current month
		SET @CardNoMax = (
				SELECT MAX(CAST(SUBSTRING(CardNumber, 6, 6) AS INT))
				FROM RateCards.TransportRateMaster
				WHERE SUBSTRING(CardNumber, 2, 4) = @CurrentMonthPrefix
				)
		-- If no records exist for the current month, start from 1
		SET @CardNoMax = CASE 
				WHEN @CardNoMax IS NULL
					THEN '1'
				ELSE CAST(@CardNoMax AS INT) + 1
				END
		-- Generate the new CardNo
		SET @CardNumber = 'T' + @CurrentMonthPrefix + RIGHT('000000' + CAST(@CardNoMax AS VARCHAR), 6)

		INSERT INTO RateCards.TransportRateMaster (
			CardNumber
			,ContractDate
			,CurrencyID
			,Heading
			,TransportModeTypeID
			,TransportServceID
			,RateCardModeTypeID
			,HotelID
			,HotelZone
			,VendorID
			,CityID
			,CityID2
			,InfoForOperation
			,InfoForRemark
			,InfoForAgent
			,IsActive
			,CreatedBy
			,CreatedOn
			,StateID
			,GstStatus
			--,XORemark
			,BookingID
			)
		VALUES (
			@CardNumber
			,@ContractDate
			,@CurrencyID
			,@Heading
			,@TransportModeTypeID
			,@TransportServiceID
			,@RateCardModeTypeID
			,@HotelID
			,@HotelZone
			,@VendorID
			,@CityID
			,@CityID2
			,@InfoForOperation
			,@InfoForRemark
			,@InfoForAgent
			,@IsActive
			,@CreatedBy
			,GETDATE()
			,@StateID
			,@GstStatus
			--,@InfoForRemark
			,@BookingID
			)

		SET @TransportRateID = @@IDENTITY

		SELECT '200' AS returnCode
			,'New record added  successfully.' AS returnMessage
			,@TransportRateID AS ID
	END

	IF @Operation = 'UPDATE'
		AND @ID > 0
	BEGIN
		UPDATE RateCards.TransportRateMaster
		SET ContractDate = @ContractDate
			,CurrencyID = @CurrencyID
			,TransportModeTypeID = @TransportModeTypeID
			,Heading = @Heading
			,RateCardModeTypeID = @RateCardModeTypeID
			,HotelID = @HotelID
			,HotelZone = @HotelZone
			,VendorID = @VendorID
			,CityID = @CityID
			,TransportServceID = @TransportServiceID
			,InfoForOperation = @InfoForOperation
			,InfoForRemark = @InfoForRemark
			,InfoForAgent = @InfoForAgent
			,CityID2 = @CityID2
			,IsActive = @IsActive
			,UpdatedBy = @UpdatedBy
			,UpdatedOn = GETDATE()
			,StateID = @StateID
			,GstStatus = @GstStatus
			--,XORemark = @InfoForRemark
		WHERE TransportRateID = @ID

		SET @TransportRateID = @ID
		SET @CardNumber = (
				SELECT CardNumber
				FROM RateCards.TransportRateMaster
				WHERE TransportRateID = @ID
				)

		SELECT '200' AS returnCode
			,'New record updated  successfully.' AS returnMessage
			,@TransportRateID AS ID
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	END
END