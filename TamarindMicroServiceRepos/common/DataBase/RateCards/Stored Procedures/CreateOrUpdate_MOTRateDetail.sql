

ALTER PROCEDURE [RateCards].[CreateOrUpdate_MOTRateDetail]
(
@Operation VARCHAR(20) = 'INSERT',
@ClassTypeID       INT            = NULL,
@TaxType       bit            = NULL,
@ValidFrom         DATETIME       = NULL,
@ValidTo           DATETIME       = NULL,
@MISSequence       VARCHAR(100)   = NULL,
@IsActive          BIT            = NULL,
@CreatedOn         DATETIME       = NULL,
@UpdatedOn         DATETIME       = NULL,
@MOTRateID         BIGINT         = NULL,
@ApplicableTo      VARCHAR(500)   = NULL,
@Description       VARCHAR(500)   = NULL,
@CreatedBy         UNIQUEIDENTIFIER = NULL,
@UpdatedBy         UNIQUEIDENTIFIER = NULL,
@MOTRateDetailID   BIGINT OUTPUT
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
		--SELECT *FROM [RateCards].MOTRateDetail
		--INSERT INTO [RateCards].MOTRateDetail(ClassTypeID,ValidFrom,ValidTo,MISSequence,IsActive,CreatedBy,CreatedOn)
		--VALUES(@ClassTypeID,@ValidFrom,@ValidTo,@MISSeqeunce,@IsActive,@CreatedBy,GETDATE())
		INSERT INTO [RateCards].MOTRateDetail
(
    ClassTypeID,
	TaxTypeID,
    ValidFrom,
    ValidTo,
    MISSequence,
    IsActive,
    MOTRateID,
    ApplicableTo,
    Description,
    CreatedBy,
    CreatedOn
)
VALUES
(
    @ClassTypeID,
	@TaxType,
    @ValidFrom,
    @ValidTo,
    @MISSequence,
    @IsActive,
    @MOTRateID,
    @ApplicableTo,
    @Description,
    @CreatedBy,
    GETDATE()
);
		SET @MOTRateDetailID = @@IDENTITY
	END
	IF @Operation = 'UPDATE' AND @MOTRateDetailID > 0
	BEGIN
		IF EXISTS (SELECT 1 FROM [RateCards].MOTRateDetail WHERE MOTRateDetailID = @MOTRateDetailID)
			BEGIN
			UPDATE [RateCards].MOTRateDetail
			SET
				ClassTypeID    = ISNULL(@ClassTypeID, ClassTypeID),
				TaxType    = ISNULL(@TaxType, TaxType),
				ValidFrom      = ISNULL(@ValidFrom, ValidFrom),
				ValidTo        = ISNULL(@ValidTo, ValidTo),
				MISSequence    = ISNULL(@MISSequence, MISSequence),
				IsActive       = ISNULL(@IsActive, IsActive),
				MOTRateID      = ISNULL(@MOTRateID, MOTRateID),
				ApplicableTo   = ISNULL(@ApplicableTo, ApplicableTo),
				Description    = ISNULL(@Description, Description),
				UpdatedBy      = ISNULL(@UpdatedBy, UpdatedBy),
				UpdatedOn      = GETDATE()
			WHERE MOTRateDetailID = @MOTRateDetailID;
			END
	END
END