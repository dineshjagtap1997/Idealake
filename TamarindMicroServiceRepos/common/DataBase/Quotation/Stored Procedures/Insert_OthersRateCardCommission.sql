CREATE PROCEDURE [Quotation].[Insert_OthersRateCardCommission]
    @Action						  VARCHAR(1),
	@ID							  BIGINT = NULL,
    @CommissionRefrenceID         BIGINT,
    @RateID                       BIGINT,
    @CommissionMasterID           INT,
    @MinimumPax                   INT = NULL,
    @MaximumPax                   INT = NULL,
    @IsAmtIncludedInBasic         BIT = NULL,
    @TaxPercentage                DECIMAL(10, 2) = NULL,
    @TaxAmount                    DECIMAL(18, 2) = NULL,
    @NetAmountExcludingTax        DECIMAL(18, 2) = NULL,
    @NetAmountIncludingTax        DECIMAL(18, 2) = NULL,
    @Markup_IsRate                BIT = NULL,
    @NetRate                      DECIMAL(18, 2) = NULL,
    @SellingRates                 DECIMAL(18, 2) = NULL,
	@GrossRate					  DECIMAL(18, 2) = NULL,
    @GrossRateAdult               DECIMAL(18, 2) = NULL,
    @GrossRateChild               DECIMAL(18, 2) = NULL,
	@MarkupRate					  DECIMAL(18, 2) = NULL,
    @IsActive                     BIT = NULL,
    @CreatedBy                    UNIQUEIDENTIFIER = NULL,
	@OthersRateRefrenceID		  BIGINT
AS
BEGIN
			
	SET NOCOUNT ON;

DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX), @LogID BIGINT;

IF @Action = 'I'
BEGIN
    INSERT INTO [Quotation].[OthersRateCardCommission] (
        CommissionRefrenceID,
        RateID,
        CommissionMasterID,
        MinimumPax,
        MaximumPax,
        IsAmtIncludedInBasic,
        TaxPercentage,
        TaxAmount,
        NetAmountExcludingTax,
        NetAmountIncludingTax,
        Markup_IsRate,
        NetRate,
        SellingRates,
		GrossRate,
        GrossRateAdult,
        GrossRateChild,
		MarkupRate,
        IsActive,
        CreatedOn,
        CreatedBy,
		OthersRateRefrenceID
    )
    VALUES (
        @CommissionRefrenceID,
        @RateID,
        @CommissionMasterID,
        @MinimumPax,
        @MaximumPax,
        @IsAmtIncludedInBasic,
        @TaxPercentage,
        @TaxAmount,
        @NetAmountExcludingTax,
        @NetAmountIncludingTax,
        @Markup_IsRate,
        @NetRate,
        @SellingRates,
		@GrossRate,
        @GrossRateAdult,
        @GrossRateChild,
		@MarkupRate,
        @IsActive,
        GETDATE(),
        @CreatedBy,
		@OthersRateRefrenceID
    );

    SET @LogID = SCOPE_IDENTITY();
    SET @ReturnCode = '200';
    SET @ReturnMessage = 'Record inserted successfully';

    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID AS ID;
END
ELSE IF @Action = 'U'
BEGIN
    UPDATE [Quotation].[OthersRateCardCommission]
    SET
        CommissionRefrenceID = @CommissionRefrenceID,
        RateID = @RateID,
        CommissionMasterID = @CommissionMasterID,
        MinimumPax = @MinimumPax,
        MaximumPax = @MaximumPax,
        IsAmtIncludedInBasic = @IsAmtIncludedInBasic,
        TaxPercentage = @TaxPercentage,
        TaxAmount = @TaxAmount,
        NetAmountExcludingTax = @NetAmountExcludingTax,
        NetAmountIncludingTax = @NetAmountIncludingTax,
        Markup_IsRate = @Markup_IsRate,
        NetRate = @NetRate,
        SellingRates = @SellingRates,
        GrossRateAdult = @GrossRateAdult,
        GrossRateChild = @GrossRateChild,
		@MarkupRate = @MarkupRate,
        IsActive = @IsActive,
        UpdatedOn = GETDATE()
    WHERE ID = @ID;

    SET @ReturnCode = '200';
    SET @ReturnMessage = 'Record updated successfully';

    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @ID AS ID;
END
ELSE IF @Action = 'S'
BEGIN
    SELECT *
    FROM [Quotation].[OthersRateCardCommission]
    WHERE (@ID IS NULL OR ID = @ID);
END
ELSE
BEGIN
    SET @ReturnCode = '400';
    SET @ReturnMessage = 'Invalid action specified';
    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;
END

END
