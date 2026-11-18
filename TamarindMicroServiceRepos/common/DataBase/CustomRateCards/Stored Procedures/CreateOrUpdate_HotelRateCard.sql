CREATE PROCEDURE [CustomRateCards].[CreateOrUpdate_HotelRateCard]
    @Operation VARCHAR(10) = 'INSERT',
    @ID BIGINT = NULL,
    @CityID VARCHAR(3),
    @CurrencyID VARCHAR(5) = NULL,
    @HotelID BIGINT,
    @RoomCategoryID INT,
    @MealPlanID INT,
    @VendorID BIGINT = NULL,
    @PaymentTypeID INT = NULL,
    @IsCommission BIT,
    @IsActive BIT = 0,
    @CreatedBy UNIQUEIDENTIFIER = NULL,
    @UpdatedBy UNIQUEIDENTIFIER = NULL,
	@IsTax bit = false,
    @LanguageID varchar(100)=null,
    @VehicleCategoryID int=0,
    @ServiceID int=0,
    @NationalityID int =0,
    @RateType int=0,
	@CheckIn Datetime=null,
	@CheckOut datetime =null,
	@RatePreferenceID int =0,
	@Direct_BTC bit=null,
	@QuotationID int =0,
	@HotelRateID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CurrentDateTime DATETIME = GETDATE();
    DECLARE @ReturnCode VARCHAR(3);
    DECLARE @ReturnMessage VARCHAR(100);
    
    BEGIN TRY
        IF @Operation = 'INSERT'
        BEGIN
            INSERT INTO [CustomRateCards].[HotelRateMaster](CityID, CurrencyID, HotelID, RoomCategoryID, MealPlanID, VendorID, PaymentTypeID, IsCommission, IsActive, CreatedOn, CreatedBy,IsTax,LanguageID,VehicleCategoryID,ServiceID,NationalityID,RateType,RatePreferenceID,Direct_BTC,QuotationID,CheckIn,CheckOut) 
			VALUES (@CityID, @CurrencyID, @HotelID, @RoomCategoryID, @MealPlanID, @VendorID, @PaymentTypeID, @IsCommission, @IsActive, @CurrentDateTime, @CreatedBy,@IsTax,@LanguageID,@VehicleCategoryID,@ServiceID,@NationalityID,@RateType,@RatePreferenceID,@Direct_BTC,@QuotationID,@CheckIn,@CheckOut);
			SET @HotelRateID = @@IDENTITY;
            SET @ReturnCode = '200';
            SET @ReturnMessage = 'New record added successfully.';
        END
        ELSE IF @Operation = 'UPDATE'
        BEGIN
            IF @ID IS NULL
            BEGIN
                SET @ReturnCode = '400';
                SET @ReturnMessage = 'HotelRateID is required for update operation.';
            END
            ELSE
            BEGIN
                UPDATE [CustomRateCards].[HotelRateMaster] SET CityID = @CityID, CurrencyID = @CurrencyID, HotelID = @HotelID, RoomCategoryID = @RoomCategoryID, MealPlanID = @MealPlanID, VendorID = @VendorID, PaymentTypeID = @PaymentTypeID, IsCommission = @IsCommission, IsActive = @IsActive, UpdatedOn = @CurrentDateTime, UpdatedBy = @UpdatedBy 
				,IsTax=@IsTax,LanguageID=@LanguageID,VehicleCategoryID=@VehicleCategoryID,ServiceID=@ServiceID,NationalityID=@NationalityID,RateType=@RateType,RatePreferenceID=@RatePreferenceID,Direct_BTC=@Direct_BTC
				WHERE HotelRateID = @ID;
				SET @HotelRateID = @ID;
                IF @@ROWCOUNT = 0
                BEGIN
                    SET @ReturnCode = '404';
                    SET @ReturnMessage = 'Record not found for update.';
                END
                ELSE
                BEGIN
                    SET @ReturnCode = '200';
                    SET @ReturnMessage = 'Record updated successfully.';
                END
            END
        END
        ELSE
        BEGIN
            SET @ReturnCode = '400';
            SET @ReturnMessage = 'Invalid operation specified. Use ''INSERT'' or ''UPDATE''.';
        END
    END TRY
    BEGIN CATCH
        SET @ReturnCode = '500';
        SET @ReturnMessage = 'Error: ' + ERROR_MESSAGE();
    END CATCH
    
    SELECT @ReturnCode AS returnCode,@ReturnMessage AS returnMessage,@HotelRateID AS RateCardID;
END 