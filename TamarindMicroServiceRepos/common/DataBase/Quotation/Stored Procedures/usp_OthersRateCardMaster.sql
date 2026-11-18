CREATE PROCEDURE [Quotation].[usp_OthersRateCardMaster]
    @Action VARCHAR(1),
    @ID BIGINT = NULL,
    @RateId BIGINT = NULL,
    @ServiceID INT = NULL,
    @RateType INT = NULL,
    @CardNumber VARCHAR(255) = NULL,
    @Heading VARCHAR(255) = NULL,
    @ContractDate DATETIME = NULL,
    @RateCardModeTypeID INT = NULL,
    @CurrencyID VARCHAR(50) = NULL,
    @VendorID INT = NULL,
    @CityID VARCHAR(255) = NULL,
    @StateID INT = NULL,
    @GstStatus VARCHAR(50) = NULL,
    @InfoForOperation VARCHAR(255) = NULL,
    @InfoForAgent VARCHAR(255) = NULL,
    @InfoForRemark VARCHAR(255) = NULL,
    @IsActive BIT = NULL,
    --@CreatedOn DATETIME = NULL,
    --@UpdatedOn DATETIME = NULL,
    --@CreatedBy UNIQUEIDENTIFIER = NULL,
    --@UpdatedBy UNIQUEIDENTIFIER = NULL,
    @LanguageID CHAR(5) = NULL,
    @Notes VARCHAR(255) = NULL,
    @HotelID INT = NULL,
    @HrsPerDay INT = NULL,
    @KmPerDay INT = NULL,
    @TransportModeTypeID INT = NULL,
    @HotelZone VARCHAR(255) = NULL,
    @CityID2 VARCHAR(255) = NULL,
    @ReferenceRateDetailID BIGINT = NULL,
    @TaxID INT = NULL,
    @ValidFrom DATETIME = NULL,
    @ValidTo DATETIME = NULL,
    @MISSequence VARCHAR(255) = NULL,
    @NationalityID INT = NULL,
    @RatePreferenceID INT = NULL,
    @VehicleCategoryID INT = NULL,
    @QuotationID BIGINT = NULL,
    @Disclaimer NVARCHAR(500) = NULL,
    @ReasonID INT = NULL,
	@OthersRateRefrenceID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX), @LogID BIGINT;

    IF @Action = 'I'
    BEGIN

	if(@RateType = 1)
	BEGIN
	   -- Check for duplicate record
        IF EXISTS (
            SELECT 1
            FROM [Quotation].OthersRateCardMaster
            WHERE RateId = @RateId 
              AND ServiceID = @ServiceID AND QuotationID = @QuotationID
        )
        BEGIN
            SET @ReturnCode = '201'; -- Conflict
            SET @ReturnMessage = 'Data already exists';
            SET @LogID = 0;

            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID AS ID;
            RETURN;
        END
	END
		if(@RateType = 2)
	BEGIN
	   -- Check for duplicate record
        IF EXISTS (
            SELECT 1
            FROM [Quotation].OthersRateCardMaster
            WHERE RateId = @RateId  
              AND ServiceID = @ServiceID 
        )
        BEGIN
            SET @ReturnCode = '409'; -- Conflict
            SET @ReturnMessage = 'Data already exists';
            SET @LogID = 0;

            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID AS ID;
            RETURN;
        END
	END

        INSERT INTO [Quotation].OthersRateCardMaster (
            RateId, ServiceID, RateType, CardNumber, Heading, ContractDate,
            RateCardModeTypeID, CurrencyID, VendorID, CityID, StateID, GstStatus,
            InfoForOperation, InfoForAgent, InfoForRemark, IsActive,
           LanguageID, Notes, HotelID,
            HrsPerDay, KmPerDay, TransportModeTypeID, HotelZone, CityID2,
            ReferenceRateDetailID, TaxID, ValidFrom, ValidTo,
            MISSequence, NationalityID, RatePreferenceID, VehicleCategoryID,
            QuotationID, Disclaimer, ReasonID
        )
        VALUES (
            @RateId, @ServiceID, @RateType, @CardNumber, @Heading, @ContractDate,
            @RateCardModeTypeID, @CurrencyID, @VendorID, @CityID, @StateID, @GstStatus,
            @InfoForOperation, @InfoForAgent, @InfoForRemark, @IsActive,
            @LanguageID, @Notes, @HotelID,
            @HrsPerDay, @KmPerDay, @TransportModeTypeID, @HotelZone, @CityID2,
            @ReferenceRateDetailID, @TaxID, @ValidFrom, @ValidTo,
            @MISSequence, @NationalityID, @RatePreferenceID, @VehicleCategoryID,
            @QuotationID, @Disclaimer, @ReasonID
        );

		SET @OthersRateRefrenceID = SCOPE_IDENTITY();
        SET @LogID = @OthersRateRefrenceID;
        SET @ReturnCode = '200';
        SET @ReturnMessage = 'Record inserted successfully';

        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID AS ID;
    END
    ELSE IF @Action = 'U'
    BEGIN
        UPDATE [Quotation].OthersRateCardMaster
        SET RateId = @RateId, ServiceID = @ServiceID, RateType = @RateType, CardNumber = @CardNumber,
            Heading = @Heading, ContractDate = @ContractDate, RateCardModeTypeID = @RateCardModeTypeID,
            CurrencyID = @CurrencyID, VendorID = @VendorID, CityID = @CityID, StateID = @StateID,
            GstStatus = @GstStatus, InfoForOperation = @InfoForOperation, InfoForAgent = @InfoForAgent,
            InfoForRemark = @InfoForRemark, IsActive = @IsActive, UpdatedOn = GETDATE(),
            LanguageID = @LanguageID, Notes = @Notes, HotelID = @HotelID,
            HrsPerDay = @HrsPerDay, KmPerDay = @KmPerDay, TransportModeTypeID = @TransportModeTypeID,
            HotelZone = @HotelZone, CityID2 = @CityID2, ReferenceRateDetailID = @ReferenceRateDetailID,
            TaxID = @TaxID, ValidFrom = @ValidFrom, ValidTo = @ValidTo, MISSequence = @MISSequence,
            NationalityID = @NationalityID, RatePreferenceID = @RatePreferenceID,
            VehicleCategoryID = @VehicleCategoryID, QuotationID = @QuotationID,
            Disclaimer = @Disclaimer, ReasonID = @ReasonID
        WHERE ID = @ID;

        SET @ReturnCode = '200';
        SET @ReturnMessage = 'Record updated successfully';

        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @ID AS ID;
    END
    ELSE IF @Action = 'S'
    BEGIN
        SELECT *
        FROM [Quotation].OthersRateCardMaster
        WHERE (@ID IS NULL OR ID = @ID);
    END
    ELSE
    BEGIN
        SET @ReturnCode = '400';
        SET @ReturnMessage = 'Invalid action specified';
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;
    END
END
