
CREATE Procedure [Booking].[GenerateFileCode]
    @CompanyID INT = 9,
    @BookingID INT = 153
AS
BEGIN 
	IF(ISNULL(@CompanyId,0)<>0 AND ISNULL(@BookingId,0)<>0)
		BEGIN
			Declare 
			@CompCode NVARCHAR(50) = '',
			@StartDate DATETIME,
			@Year INT,
			@Month INT,
			@Counter INT,
			@FinalCode VARCHAR(20);

	
			SELECT @CompCode = ISNULL(CompCode, '')
			FROM CompanyMaster
			WHERE CompanyId = @CompanyId;

			SELECT @StartDate = StartDate
			FROM Booking.tbl_Booking
			WHERE ID = @BookingId;

			SET @Year = YEAR(@StartDate);
			SET @Month = MONTH(@StartDate);

			CREATE TABLE #TempCounter (Counter INT);

			IF EXISTS (
				SELECT 1 FROM Booking.FileCodeCounter
				WHERE CompCode = @CompCode AND Year = @Year AND Month = @Month
			)
			BEGIN
				UPDATE Booking.FileCodeCounter
				SET Counter = Counter + 1, LastUpdatedOn = GETDATE()
				OUTPUT INSERTED.Counter INTO #TempCounter
				WHERE CompCode = @CompCode AND Year = @Year AND Month = @Month;

				SELECT @Counter = Counter FROM #TempCounter;
			END
			ELSE
			BEGIN
				INSERT INTO Booking.FileCodeCounter (CompCode, Year, Month, Counter)
				VALUES (@CompCode, @Year, @Month, 1);

				SET @Counter = 1;
			END

			SET @FinalCode = @CompCode + 
							 RIGHT('00' + CAST(@Year % 100 AS VARCHAR), 2) + 
							 RIGHT('00' + CAST(@Month AS VARCHAR), 2) + 
							 RIGHT('00000' + CAST(@Counter AS VARCHAR), 5);

			UPDATE 
				Booking.tbl_Booking
			SET
				FileCode=@FinalCode
			WHERE
				ID=@BookingId

			SELECT @FinalCode AS FileCode;
			--SELECT @OthersRateRefrenceID AS ID, '200' AS returnCode, 'Record inserted successfully' AS returnMessage;
			DROP table #TempCounter
		END
END