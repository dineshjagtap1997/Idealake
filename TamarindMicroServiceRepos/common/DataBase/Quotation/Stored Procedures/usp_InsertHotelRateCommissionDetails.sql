--DECLARE
--    @RateCommissionID BIGINT = 147,
--    @QuotationHotelRateID BIGINT = 7,
--    @HotelRateID INT = 405531,
--    @GrossRate DECIMAL(18,2) = 566.00,
--    @IsMarkup BIT = 1,
--    @MarkupValue DECIMAL(18,2) = 10.00,
--    @CreatedBy UNIQUEIDENTIFIER = NEWID(),
--	@ReasonMasterId	INT = 2,
--	@Action Char(1)='I'

CREATE PROCEDURE [Quotation].[usp_InsertHotelRateCommissionDetails]
	@RateCommissionID BIGINT=NULL,
	@QuotationHotelRateID BIGINT=NULL,
	@HotelRateID INT=NULL,
	@GrossRate decimal(18,2)=NULL,
	@IsMarkup BIT = NULL,
	@MarkupValue DECIMAL(18,2)=NULL,
	@CreatedBy uniqueidentifier=NULL,
	@ReasonMasterId	INT = NULL,
	@Action Char(1)=NULL

AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX), @LogID BIGINT;

	IF @Action = 'I'
		BEGIN
			Insert into Quotation.HotelRateCommissionDetails
			(
				QuotationHotelRateID,
				CommissionMasterID,
				GrossRate,
				TaxPercentage,
				TaxAmount,
				GrossAmountIncludingTax,
				GrossAmountExcludingTax,
				CommisionPercentage,
				IsMarkup,
				MarkupValue,
				ReasonMasterId,
				CreatedOn,
				CreatedBy,
				IsActive
			)
			Select
				DISTINCT
				@QuotationHotelrateID,
				RCD.RateCommisionID,--Q
				@GrossRate,
				RCD.TaxPercentage,
				RCD.TaxAmount,
				RCD.GrossAmountIncludingTax,
				RCD.GrossAmountExcludingTax,
				RCD.CommisionPercentage,
				@IsMarkup, --Q
				@MarkupValue, --Q
				@ReasonMasterId,
				GETDATE(),
				@CreatedBy,
				RCD.IsActive
			From
				RateCards.RateCommisionDetails RCD
				LEFT OUTER JOIN RateCards.HotelRateDetails HRD ON RCD.HotelRateDetailID=HRD.HotelRateDetailID
				LEFT OUTER JOIN RateCards.HotelRateMaster HRM ON HRD.HotelRateID=HRM.HotelRateID
			WHERE 
				HRM.HotelRateID=@HotelRateID  --Q

				
				SET @LogID = @QuotationHotelrateID
				SET @ReturnCode = '200';
				SET @ReturnMessage = 'Record inserted successfully';

		END
END
