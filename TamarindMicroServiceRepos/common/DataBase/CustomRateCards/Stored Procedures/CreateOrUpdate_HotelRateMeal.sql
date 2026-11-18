CREATE PROCEDURE [CustomRateCards].[CreateOrUpdate_HotelRateMeal]
    @Operation VARCHAR(10) = 'INSERT',
    @HotelRateMealID BIGINT = NULL,
    @HotelRateID BIGINT = NULL,
    @MealTypeID INT = NULL,
    @GstPercentage DECIMAL(18, 2) = NULL,
    @GstAmount DECIMAL(18, 2) = NULL,
    @NetAmountIncludingTax DECIMAL(18, 2) = NULL,
    @NetAmountExcludingTax DECIMAL(18, 2) = NULL,
    @IsActive BIT = 1,
    @MasterCommissionID INT = NULL,
    @IsMealDetails BIT = NULL,
    @DefineAmount BIT = NULL,
    @CreatedBy UNIQUEIDENTIFIER = NULL,
    @UpdatedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CurrentDateTime DATETIME = GETDATE();
    DECLARE @ReturnCode VARCHAR(3);
    DECLARE @ReturnMessage VARCHAR(100);
    
    BEGIN TRY
        IF @Operation = 'INSERT'
        BEGIN
            INSERT INTO [CustomRateCards].[HotelRateMealOverview](HotelRateID,MealTypeID,GstPercentage,GstAmount,NetAmountIncludingTax,NetAmountExcludingTax,IsActive,CreatedOn,MasterCommissionID,CreatedBy,IsMealDetails,DefineAmount) 
			VALUES (@HotelRateID,@MealTypeID,@GstPercentage,@GstAmount,@NetAmountIncludingTax,@NetAmountExcludingTax,@IsActive,@CurrentDateTime,@MasterCommissionID,@CreatedBy,@IsMealDetails,@DefineAmount);

            
            SET @HotelRateMealID = @@IDENTITY;
            SET @ReturnCode = '200';
            SET @ReturnMessage = 'New record added successfully.';
        END
        ELSE IF @Operation = 'UPDATE'
        BEGIN
            IF @HotelRateMealID IS NULL
            BEGIN
                SET @ReturnCode = '400';
                SET @ReturnMessage = 'HotelRateMealID is required for update operation.';
            END
            ELSE
            BEGIN
                UPDATE [CustomRateCards].[HotelRateMealOverview] SET HotelRateID=@HotelRateID,MealTypeID=@MealTypeID,GstPercentage=@GstPercentage,GstAmount=@GstAmount,NetAmountIncludingTax=@NetAmountIncludingTax,NetAmountExcludingTax=@NetAmountExcludingTax,IsActive=@IsActive,UpdatedOn=@CurrentDateTime,MasterCommissionID=@MasterCommissionID,UpdatedBy=@UpdatedBy,IsMealDetails=@IsMealDetails,DefineAmount=@DefineAmount 
				WHERE HotelRateMealID=@HotelRateMealID;

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
    
    SELECT @ReturnCode AS returnCode,@ReturnMessage AS returnMessage,@HotelRateMealID AS ID;
END 