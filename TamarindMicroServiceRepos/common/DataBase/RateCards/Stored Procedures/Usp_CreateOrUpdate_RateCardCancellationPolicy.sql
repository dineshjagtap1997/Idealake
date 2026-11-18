CREATE PROCEDURE [RateCards].[Usp_CreateOrUpdate_RateCardCancellationPolicy]
(
@Operation VARCHAR(30) NULL,
@ID BIGINT = NULL,
@RateCardTypeID INT NULL,
@RateCardID BIGINT NULL,
@ValidFrom DATETIME NULL,
@ValidTo DATETIME NULL,
@TsStart VARCHAR(100) NULL,
@TsEnd VARCHAR(100) NULL,
@AgentStart VARCHAR(100) NULL,
@AgentEnd VARCHAR(100) NULL,
@ChangePercent VARCHAR(100) NULL,
@ChargeNight VARCHAR(100) NULL,
@IsActive BIT,
@LogID BIGINT OUTPUT
)
AS 
BEGIN
<<<<<<< HEAD
<<<<<<< HEAD

	IF @Operation = 'INSERT'
	BEGIN
		SET @LogID = 0;
		IF NOT EXISTS (SELECT 1 FROM RateCards.CancellationPolicy WHERE RateCardID = @RateCardID 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	IF @Operation = 'INSERT'
	BEGIN
		SET @LogID = 0;
		IF NOT EXISTS (SELECT * FROM RateCards.CancellationPolicy WHERE RateCardID = @RateCardID 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			 AND (
				-- New ValidFrom falls inside an existing range
				(@ValidFrom BETWEEN ValidFrom AND ValidTo)
				-- OR New ValidTo falls inside an existing range
				OR (@ValidTo BETWEEN ValidFrom AND ValidTo)
				-- OR New range completely covers an existing range
				OR (ValidFrom BETWEEN @ValidFrom AND @ValidTo)
				OR (ValidTo BETWEEN @ValidFrom AND @ValidTo)
			)
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			AND (
				(@TsStart BETWEEN TsStart AND TsEnd) --start
				OR (@TsEnd BETWEEN TsEnd AND TsStart) --END
			) 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		)
		BEGIN
			
				INSERT INTO RateCards.CancellationPolicy(RateCardTypeID,RateCardID,ValidFrom,ValidTo,TsStart,TsEnd,
				AgentStart,AgentEnd,ChangePercent,ChargeNight,IsActive,CreatedBy,CreatedOn)
				VALUES(@RateCardTypeID,@RateCardID,@ValidFrom,@ValidTo,@TsStart,@TsEnd,@AgentStart,@AgentEnd,@ChangePercent,
				@ChargeNight,@IsActive,NEWID(),GETDATE())

			
			SET @LogID = @@IDENTITY   

<<<<<<< HEAD
<<<<<<< HEAD
=======

>>>>>>> dev
=======

>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			END
	END
	ELSE IF @Operation = 'UPDATE' AND @ID > 0
		BEGIN
			UPDATE RateCards.CancellationPolicy
<<<<<<< HEAD
<<<<<<< HEAD
			SET ValidFrom = @ValidFrom,TsStart = @TsStart,TsEnd = @TsEnd, AgentStart= @AgentStart,AgentEnd = @AgentEnd,
=======
			SET ValidFrom = @ValidFrom,ValidTo=@ValidTo, TsStart = @TsStart,TsEnd = @TsEnd, AgentStart= @AgentStart,AgentEnd = @AgentEnd,
>>>>>>> dev
=======
			SET ValidFrom = @ValidFrom,ValidTo=@ValidTo, TsStart = @TsStart,TsEnd = @TsEnd, AgentStart= @AgentStart,AgentEnd = @AgentEnd,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			ChangePercent = @ChangePercent, ChargeNight = @ChargeNight,
			IsActive = @IsActive,UpdatedBy = NEWID(), UpdatedOn = GETDATE()
			WHERE PolicyID = @ID


		SET @LogID = @ID
 

		END
END

