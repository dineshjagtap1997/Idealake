CREATE PROCEDURE [XO].[CreateGroup]                          
(
    @DWID BIGINT = null
)      
AS           
BEGIN    
 --   SET NOCOUNT ON;
	--DECLARE @TargetID INT = @DWID;
	---- Step 1: Get group-defining values
	--DECLARE 
	--	@BookingID INT,
	--	@XOType INT,
	--	@City VARCHAR(100),
	--	@HotelName VARCHAR(200),
	--	@VendorID INT,
	--	@RateCardCurrency VARCHAR(10);
	--SELECT 
	--	@BookingID = BookingID,
	--	@XOType = RateTypeID,
	--	@City = City,
	--	@HotelName = HotelName,
	--	--@VendorID = Vendor,
	--	@RateCardCurrency = Currency
	--FROM Booking.DayWiseBooking
	--WHERE ID = @TargetID And XOLock=0;
	----select @BookingID,@XOType,@City,@HotelName,@VendorID,@RateCardCurrency
	---- Step 2: Apply grouping only to affected rows
	--;WITH Ranked AS (
 --   SELECT 
 --       ID,
 --       DayWiseDate,
 --       ROW_NUMBER() OVER (
 --           ORDER BY DayWiseDate
 --       ) AS RowNum
 --   FROM Booking.DayWiseBooking
 --   WHERE 
 --       BookingID = @BookingID AND
 --       RateTypeID = @XOType AND
 --       City = @City AND
 --       HotelName = @HotelName AND
 --       --VendorID = @VendorID AND
 --       Currency = @RateCardCurrency
	--)
	--, Grouped AS (
	--	SELECT 
	--		ID,
	--		DayWiseDate,
	--		DATEADD(DAY, -RowNum, DayWiseDate) AS DateShiftKey
	--	FROM Ranked
	--)

	--, AssignGroupNumbers AS (
	--	SELECT 
	--		ID,
	--		DENSE_RANK() OVER (
	--			ORDER BY DateShiftKey
	--		) AS NewGroupKey
	--	FROM Grouped
	--)
	---- Step 3: Update only those affected rows
	--UPDATE BDW
	--SET GroupKey = AGN.NewGroupKey
	--FROM Booking.DayWiseBooking BDW
	--JOIN AssignGroupNumbers AGN ON BDW.ID = AGN.ID;
	
    DECLARE 
        @BookingID INT,
        @RateTypeID INT,
        @City VARCHAR(100),
        @HotelName VARCHAR(200),
		@VendorID INT,
        @Currency VARCHAR(10),
        @ExistingGroupKey INT,
		@ThisDate DATE,
        @NewGroupKey INT;

    -- Step 1: Get metadata of the current DayWiseBooking row
    -- First, get the DayWiseDate of the current row
		-- Step 1: Get booking & line details
		SELECT 
			@BookingID = BookingID,
			@RateTypeID = RateTypeID,
			@City = City,
			@HotelName = HotelName,
			@VendorID = Vendor,
			@Currency = Currency,
			@ThisDate = DayWiseDate
		FROM Booking.DayWiseBooking
		WHERE ID = @DWID AND GroupKey IS NULL AND XOLock = 0;

		IF @BookingID IS NULL RETURN;

		-- Step 2: Find consecutive group key from previous or next day
		;WITH EligibleDays AS (
			SELECT
				ID,
				GroupKey,
				DayWiseDate
<<<<<<< HEAD
<<<<<<< HEAD
			FROM Booking.DayWiseBooking
=======
			FROM Booking.DayWiseBooking DWB
>>>>>>> dev
=======
			FROM Booking.DayWiseBooking DWB
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			WHERE
				BookingID = @BookingID
				AND RateTypeID = @RateTypeID
				AND City = @City
				AND Currency = @Currency
				AND GroupKey IS NOT NULL
				AND XOLock = 0
<<<<<<< HEAD
<<<<<<< HEAD
=======
				AND GroupKey NOT IN (select GroupKey from DBO.XO X where DWB.GroupKey=X.GroupKey and DWB.BookingID=X.Qut_ID)
>>>>>>> dev
=======
				AND GroupKey NOT IN (select GroupKey from DBO.XO X where DWB.GroupKey=X.GroupKey and DWB.BookingID=X.Qut_ID)
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				AND (
					(@RateTypeID = 5 AND HotelName = @HotelName)
					OR (@RateTypeID <> 5 AND Vendor = @VendorID)
				)
		),
		MatchedDay AS (
			SELECT TOP 1 GroupKey
			FROM EligibleDays
			WHERE DATEDIFF(DAY, DayWiseDate, @ThisDate) = 1 -- Previous day
			   OR DATEDIFF(DAY, DayWiseDate, @ThisDate) = -1 -- Next day
			ORDER BY DayWiseDate
		)
		SELECT @ExistingGroupKey = GroupKey FROM MatchedDay;

		-- Step 3: Assign group key
		IF @ExistingGroupKey IS NOT NULL
		BEGIN
			UPDATE Booking.DayWiseBooking
			SET GroupKey = @ExistingGroupKey
			WHERE ID = @DWID AND GroupKey IS NULL AND XOLock = 0;
		END
		ELSE
		BEGIN
			SELECT @NewGroupKey = ISNULL(MAX(GroupKey), 0) + 1 FROM Booking.DayWiseBooking;

			UPDATE Booking.DayWiseBooking
			SET GroupKey = @NewGroupKey
			WHERE ID = @DWID AND GroupKey IS NULL AND XOLock = 0;
		END
END
<<<<<<< HEAD
<<<<<<< HEAD



=======
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
