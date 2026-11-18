CREATE PROCEDURE [RateCards].[CreateOrUpdate_GuideRateDetail]
(
@Operation VARCHAR(10) = 'INSERT',
@ID BIGINT = 0,
@GuideRateID BIGINT = 0,
@TaxID INT NULL,
@ValidFrom DATETIME = NULL,
@ValidTo DATETIME = NULL,
@MISSequence VARCHAR(30) = NULL,
@IsActive BIT = 1,
@PaxMinimum INT = NULL,
@PaxMaximum INT = NULL,
@CreatedBy UNIQUEIDENTIFIER = NULL,
@UpdatedBy UNIQUEIDENTIFIER = NULL,
@GuideRateDetailID BIGINT OUTPUT
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
		--IF EXISTS (SELECT 1 FROM [RateCards].[GuideRateCommissionDetails] C inner join [RateCards].[GuideRateDetails] RD
		--on RD.GuideRateDetailID=C.GuideRateDetailID WHERE RD.GuideRateID = @GuideRateID AND @PaxMinimum <= PaxMaximum AND @PaxMaximum >= PaxMinimum)
		--BEGIN
		--	SET @GuideRateDetailID=0;
		--END
		--ELSE
		--BEGIN
			INSERT INTO [RateCards].[GuideRateDetails](GuideRateID,TaxID,ValidFrom,ValidTo,MISSequence,IsActive,CreatedBy,CreatedOn)
			VALUES(@GuideRateID,@TaxID,@ValidFrom,@ValidTo,@MISSequence,@IsActive,@CreatedBy,GETDATE())
			SET @GuideRateDetailID = @@IDENTITY
		--END
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
		UPDATE [RateCards].[GuideRateDetails]
		SET TaxID = @TaxID, ValidFrom = @ValidFrom, ValidTo = @ValidTo, MISSequence = @MISSequence, IsActive = @IsActive,
		UpdatedBy = @UpdatedBy,UpdatedOn = GETDATE()
		WHERE GuideRateDetailID = @ID

		SET @GuideRateDetailID = @ID
	END
END