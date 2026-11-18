CREATE PROCEDURE [CustomRateCards].[CreateOrUpdate_HotelRateCommission]
    @Operation VARCHAR(10) = 'INSERT',
    @RateCommisionID BIGINT = NULL,
    @CommissionMasterID INT = NULL,
    @NetAmountExcludingTax DECIMAL(18, 2) = NULL,
    @NetAmountIncludingTax DECIMAL(18, 2) = NULL,
    @GrossAmountIncludingTax DECIMAL(18, 2) = NULL,
    @GrossAmountExcludingTax DECIMAL(18, 2) = NULL,
    @CommisionPercentage DECIMAL(18, 2) = NULL,
    @CommissionAmount DECIMAL(18, 2) = NULL,
    @IsTax BIT = 0,
    @TaxPercentage DECIMAL(18, 2) = 0,
    @TaxAmount DECIMAL(18, 2) = NULL,
    @HotelRateID BIGINT = NULL,
    @IsActive BIT = 0,
    @CreatedBy UNIQUEIDENTIFIER = NULL,
    @UpdatedBy UNIQUEIDENTIFIER = NULL,
	@IsAmtIncludedInBasic BIT = true,
	@MinimumPax int=0,
	@MaximumPax int=0
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CurrentDateTime DATETIME = GETDATE();
    DECLARE @ReturnCode VARCHAR(3);
    DECLARE @ReturnMessage VARCHAR(100);
    
    BEGIN TRY
        IF @Operation = 'INSERT'
        BEGIN
			INSERT INTO [CustomRateCards].[HotelRateCommisionDetails](CommissionMasterID,NetAmountExcludingTax,NetAmountIncludingTax,GrossAmountIncludingTax,GrossAmountExcludingTax,CommisionPercentage,CommissionAmount,IsTax,TaxPercentage,TaxAmount,HotelRateID,CreatedOn,IsActive,CreatedBy,IsAmtIncludedInBasic,MinimumPax,MaximumPax) 
			VALUES (@CommissionMasterID,@NetAmountExcludingTax,@NetAmountIncludingTax,@GrossAmountIncludingTax,@GrossAmountExcludingTax,@CommisionPercentage,@CommissionAmount,@IsTax,@TaxPercentage,@TaxAmount,@HotelRateID,@CurrentDateTime,@IsActive,@CreatedBy,@IsAmtIncludedInBasic,@MinimumPax,@MaximumPax);
  
            SET @RateCommisionID = @@IDENTITY;
            SET @ReturnCode = '200';
            SET @ReturnMessage = 'New record added successfully.';
        END
        ELSE IF @Operation = 'UPDATE'
        BEGIN
            IF @RateCommisionID IS NULL
            BEGIN
                SET @ReturnCode = '400';
                SET @ReturnMessage = 'RateCommisionID is required for update operation.';
            END
            ELSE
            BEGIN
                UPDATE [CustomRateCards].[HotelRateCommisionDetails] SET CommissionMasterID=@CommissionMasterID,NetAmountExcludingTax=@NetAmountExcludingTax,NetAmountIncludingTax=@NetAmountIncludingTax,GrossAmountIncludingTax=@GrossAmountIncludingTax,GrossAmountExcludingTax=@GrossAmountExcludingTax,CommisionPercentage=@CommisionPercentage,CommissionAmount=@CommissionAmount,IsTax=@IsTax,TaxPercentage=@TaxPercentage,TaxAmount=@TaxAmount,HotelRateID=@HotelRateID,UpdatedOn=@CurrentDateTime,IsActive=@IsActive,UpdatedBy=@UpdatedBy 
				,IsAmtIncludedInBasic=@IsAmtIncludedInBasic,MinimumPax=@MinimumPax,MaximumPax=@MaximumPax WHERE RateCommisionID=@RateCommisionID;

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
    
    SELECT @ReturnCode AS returnCode,@ReturnMessage AS returnMessage,@RateCommisionID AS ID;
END 