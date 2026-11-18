CREATE PROCEDURE [RateCards].[Usp_CreateOrUpdateRules]
(
@Operation VARCHAR(30) = NULL,
@ID BIGINT = NULL,
@RateCardTypeID INT = NULL,
@RateCardID BIGINT = NULL,
@RuleID INT = NULL,
@MISSeqeunce VARCHAR(40) = NULL,
@ApplicableID INT = NULL,
@Description VARCHAR(300) = NULL,
@OperationBy UNIQUEIDENTIFIER = NULL,
@IsActive BIT
,@GuideRateID BIGINT OUTPUT
)
AS
BEGIN
--Declare @GuideRateID BIGINT;
	IF @Operation = 'INSERT'
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM RateCards.Rules WHERE RateCardID = @RateCardID and RateCardTypeID=@RateCardTypeID and RuleID=@RuleID and ApplicableID=@ApplicableID and MISSeqeunce=@MISSeqeunce)
			BEGIN
				INSERT INTO RateCards.Rules(RateCardTypeID,RateCardID,RuleID,MISSeqeunce,ApplicableID,[Description],IsActive,CreatedBy,CreateOn)
				VALUES(@RateCardTypeID,@RateCardID,@RuleID,@MISSeqeunce,@ApplicableID,@Description,@IsActive,@OperationBy,GETDATE())
				SET @GuideRateID = @@IDENTITY
				SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage--, @GuideRateID AS ID
			END
			ELSE
			BEGIN
				SET @GuideRateID = 0;
				SELECT '201' AS returnCode, 'Rule for similar combination already exist' AS returnMessage
			END
		END
	IF @Operation = 'UPDATE' AND @ID > 0
		BEGIN
			UPDATE RateCards.Rules
			SET RuleID = @RuleID,MISSeqeunce = @MISSeqeunce,ApplicableID = @ApplicableID, [Description]= @Description,
			IsActive = @IsActive,ModifiedBy = @OperationBy, ModifiedOn = GETDATE()
			WHERE ID = @ID

			SET @GuideRateID = @ID
			SELECT '200' AS returnCode, 'New record updated successfully.' AS returnMessage--, @GuideRateID AS ID  
		END
END


