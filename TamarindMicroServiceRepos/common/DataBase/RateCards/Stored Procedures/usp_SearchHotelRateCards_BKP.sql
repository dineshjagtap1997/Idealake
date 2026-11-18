


CREATE PROCEDURE [RateCards].[usp_SearchHotelRateCards_BKP] --@CityID VARCHAR(3)='BOM'
@CityID VARCHAR(3) = 'BOM',
@HotelID BIGINT = NULL,
@CheckIn DATETIME = NULL,--'2025-08-02 00:00:00.000',
@CheckOut DATETIME =NULL,-- '2025-08-08 00:00:00.000',
@Occupancy VARCHAR(MAX) = NULL,--'["SGL","DBL"]',  -- JSON-style array string
@CurrencyCode VARCHAR(10) = NULL,--'INR',
@RateCardModeType NVARCHAR(MAX) = '1,2,3,4',
@TaxID INT = 0,
@RatingFrom INT = 0,
@RatingTo INT = 0,
@MISSequence NVARCHAR(50) = null,  -- Empty from JSON
@PreferredMarketIDs VARCHAR(MAX) = '',  -- Empty from JSON
@RateSheetIDs VARCHAR(MAX) = '',  -- Empty from JSON
@PreferredHotel BIT = 0,
@QuotationID INT = 0,
@IsFromBooking BIT = NULL,
@BookingID BIGINT = null,
@FIT BIT = 1,
@GIT BIT = NULL,
@BusinessType INT = NULL,
@VendorID BIGINT = NULL

AS
BEGIN
	SET NOCOUNT ON;

	-- Temp Tables
	CREATE TABLE #PreferredMarkets (ID INT);

	CREATE TABLE #RateSheets (ID INT);

	CREATE TABLE #OccupancyRateTypes (RateType VARCHAR(10));

	-- Parse PreferredMarketIDs
	IF NULLIF(@PreferredMarketIDs, '') IS NOT NULL
	BEGIN
		INSERT INTO #PreferredMarkets (ID)
		SELECT TRY_CAST(value AS INT)
		FROM STRING_SPLIT(@PreferredMarketIDs, ',')
		WHERE TRY_CAST(value AS INT) IS NOT NULL;
	END
	print @PreferredMarketIDs;
	-- Parse RateSheetIDs
	IF NULLIF(@RateSheetIDs, '') IS NOT NULL
	BEGIN
		INSERT INTO #RateSheets (ID)
		SELECT TRY_CAST(value AS INT)
		FROM STRING_SPLIT(@RateSheetIDs, ',')
		WHERE TRY_CAST(value AS INT) IS NOT NULL;
	END
	print @RateSheetIDs
	-- Parse Occupancy
	IF @Occupancy IS NOT NULL
	BEGIN

	IF (@IsFromBooking = 1)
	BEGIN
		INSERT INTO #OccupancyRateTypes (RateType)
		SELECT TRIM(value)
		FROM STRING_SPLIT('SGL,DBL,EBA,EBC,CNB', ',')
		WHERE TRIM(value) <> '';
		END
		ELSE
		BEGIN
		INSERT INTO #OccupancyRateTypes (RateType)
		SELECT TRIM(value)
		FROM STRING_SPLIT(@Occupancy, ',')
		WHERE TRIM(value) <> '';
		END
	END

	-- Parse RateCardModeType
	DECLARE @RateCardModeTable TABLE (ModeID INT);

	INSERT INTO @RateCardModeTable (ModeID)
	SELECT DISTINCT TRY_CAST(value AS INT)
	FROM STRING_SPLIT(@RateCardModeType, ',')
	WHERE TRY_CAST(value AS INT) IS NOT NULL;

	DECLARE @HasRegular BIT = 0
		,@HasCustom BIT = 0;

	IF EXISTS (
			SELECT 1
			FROM @RateCardModeTable
			WHERE ModeID IN (
					1
					,2
					,3
					)
			)
		SET @HasRegular = 1;

	IF EXISTS (
			SELECT 1
			FROM @RateCardModeTable
			WHERE ModeID = 4
			)
		SET @HasCustom = 1;
	select @HasRegular;
END