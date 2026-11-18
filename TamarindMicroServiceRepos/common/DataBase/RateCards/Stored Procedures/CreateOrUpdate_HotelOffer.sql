CREATE PROCEDURE [RateCards].[CreateOrUpdate_HotelOffer]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@HospitalityPartnerID INT NULL,
@CityID VARCHAR(10) NULL,
@HotelID INT NULL,
@HotelGroupID INT NULL,
@VendorID INT NULL,
@Heading VARCHAR(200),
@ValidFrom DATETIME NULL,
@ValidTo DATETIME NULL,
@InfoForOperation VARCHAR(300)NULL,
@Rule VARCHAR(100) NULL,
@IsMarketOrAgent BIT NULL,
@IsActive BIT NULL,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
@HotelOfferID BIGINT OUTPUT,
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
		SET @CardNoMax = (SELECT MAX(CAST(SUBSTRING(CardNumber, 7, 6) AS INT)) FROM RateCards.HotelOfferMaster
        WHERE SUBSTRING(CardNumber, 3, 4) = @CurrentMonthPrefix)

		-- If no records exist for the current month, start from 1
		SET @CardNoMax = CASE WHEN @CardNoMax IS NULL THEN '1' ELSE CAST(@CardNoMax AS INT) + 1 END
		-- Generate the new CardNo
		SET @CardNumber = 'HO' + @CurrentMonthPrefix + RIGHT('000000' + CAST(@CardNoMax AS VARCHAR), 6)
		INSERT INTO RateCards.HotelOfferMaster(CardNumber,CityID,HospitalityPartnerID,HotelGroupID,HotelID,InfoForOperation,IsActive,IsMarketOrAgent,
		ValidFrom,ValidTo,Heading,[Rule],VendorID,CreatedBy,CreatedOn)
		VALUES(@CardNumber,@CityID,@HospitalityPartnerID,@HotelGroupID,@HotelID,@InfoForOperation,@IsActive,@IsMarketOrAgent,
		@ValidFrom,@ValidTo,@Heading,@Rule,@VendorID,@CreatedBy,GETDATE())

		SET @HotelOfferID = @@IDENTITY
		SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @HotelOfferID AS ID 
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		
		UPDATE RateCards.HotelOfferMaster
		SET HotelID = @HotelID,VendorID = @VendorID,CityID = @CityID,[Rule] = @Rule,ValidFrom = @ValidFrom, ValidTo = @ValidTo,
		InfoForOperation = @InfoForOperation, Heading = @Heading, HospitalityPartnerID = @HospitalityPartnerID,
		IsActive = @IsActive, UpdatedBy = @UpdatedBy, UpdatedOn = GETDATE(), HotelGroupID = @HotelGroupID, IsMarketOrAgent = @IsMarketOrAgent
		WHERE HotelOfferID = @ID

		SET @HotelOfferID = @ID
		SET @CardNumber = (SELECT CardNumber FROM RateCards.HotelOfferMaster WHERE HotelOfferID = @ID)
		SELECT '200' AS returnCode, 'New record updated  successfully.' AS returnMessage, @HotelOfferID AS ID 
	END
END