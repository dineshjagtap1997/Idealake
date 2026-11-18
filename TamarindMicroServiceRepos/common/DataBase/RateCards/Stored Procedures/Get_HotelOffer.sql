
ALTER PROCEDURE [RateCards].[Get_HotelOffer]
(
@Operation VARCHAR(30) = 'GETALL',
@ID BIGINT = 0,
@CardNumber VARCHAR(30) = NULL,
@Heading VARCHAR(50) = NULL,
--@HotelGroupName VARCHAR(20) = NULL,
@City VARCHAR(50) = NULL,
@Vendor VARCHAR(50) = NULL,
@Hotel VARCHAR(50) = NULL,
@ValidFrom VARCHAR(20) = NULL,
@ValidTo VARCHAR(20) = NULL,
@IsActive BIT = NULL,
@PageSize INT = 10,
@PageNumber INT = 1
)
AS
/******************************/
--EXEC [RateCards].[Get_HotelOffer] @Operation = 'GETALL', @ID = 0
/******************************/
BEGIN
	SET NOCOUNT ON;

	IF @Operation = 'GETALL'
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    SET @sql = '
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    WITH TotalCountCTE AS (
        SELECT COUNT(1) AS TotalCount
        FROM RateCards.HotelOfferMaster hom
        LEFT JOIN [dbo].City c ON c.IATACode = hom.CityID
        LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = hom.VendorID
        WHERE (
            (@CardNumber IS NULL OR @CardNumber = '''') OR hom.CardNumber LIKE ''%'' + @CardNumber + ''%''
        )
        AND (
            (@Heading IS NULL OR @Heading = '''') OR hom.Heading LIKE ''%'' + @Heading + ''%''
        )
        AND (
            (@City IS NULL OR @City = '''') OR c.Name LIKE ''%'' + @City + ''%''
        )
        AND (
            (@Vendor IS NULL OR @Vendor = '''') OR vm.VendorName LIKE ''%'' + @Vendor + ''%''
        )
        ';

    IF @IsActive IS NOT NULL
        SET @sql = @sql + ' AND hom.IsActive = @IsActive '

    SET @sql = @sql + '
    )

    SELECT 
        hom.HotelOfferID,
        hom.CardNumber,
        hom.Heading,
        c.[Name] AS City,
        vm.VendorName,
        hom.IsActive,
        TotalCountCTE.TotalCount,
        CONVERT(VARCHAR(10), hom.ValidFrom, 120) AS ValidFrom,
        CONVERT(VARCHAR(10), hom.ValidTo, 120) AS ValidTo,
        hom.[Rule],
        hg.Name AS HotelGroupName,
        CAST(0 AS BIT) AS HasRules,
        ISNULL((
            SELECT TOP 1 CAST(1 AS BIT)
            FROM dbo.LinkedDocuments ld
            INNER JOIN dbo.UploadDocuments ud 
                ON ud.DocumentID = ld.DocumentID 
                AND ud.ParentTypeID = 7
            WHERE ld.ParentID = hom.HotelOfferID
        ), CAST(0 AS BIT)) AS HasDocument,
        (
            SELECT DISTINCT null AS HotelID, null AS HotelName, vm.VendorID, vm.VendorName
            FROM  RateCards.HotelOfferMaster map 
            INNER JOIN dbo.VendorMaster VM ON map.VendorID = VM.VendorID 
            WHERE map.IsActive = 1 AND map.HotelOfferID = hom.HotelOfferID   
            FOR JSON PATH
        ) AS HotelDetailsJson
    FROM RateCards.HotelOfferMaster hom
    LEFT JOIN [dbo].City c ON c.IATACode = hom.CityID
    LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = hom.VendorID
    LEFT JOIN [dbo].HotelGroups hg ON hg.HotelGroupID = hom.HotelGroupID
    CROSS JOIN TotalCountCTE
    WHERE (
        (@CardNumber IS NULL OR @CardNumber = '''') OR hom.CardNumber LIKE ''%'' + @CardNumber + ''%''
    )
    AND (
        (@Heading IS NULL OR @Heading = '''') OR hom.Heading LIKE ''%'' + @Heading + ''%''
    )
    AND (
        (@City IS NULL OR @City = '''') OR c.Name LIKE ''%'' + @City + ''%''
    )
    AND (
        (@Vendor IS NULL OR @Vendor = '''') OR vm.VendorName LIKE ''%'' + @Vendor + ''%''
    )
    ';

    IF @IsActive IS NOT NULL
        SET @sql = @sql + ' AND hom.IsActive = @IsActive '

    SET @sql = @sql + '
    ORDER BY hom.CreatedOn DESC     
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
    ';

    -- Optional: uncomment to debug the generated SQL
    -- PRINT @sql;

    EXEC sp_executesql @sql,
        N'@CardNumber NVARCHAR(30),
          @Heading VARCHAR(50),
          @City VARCHAR(50),
          @Vendor VARCHAR(50),
          @IsActive BIT,
          @PageSize INT,
          @PageNumber INT',
        @CardNumber = @CardNumber,
        @Heading = @Heading,
        @City = @City,
        @Vendor = @Vendor,
        @IsActive = @IsActive,
        @PageSize = @PageSize,
        @PageNumber = @PageNumber;
END

--	IF @Operation = 'GETALL'
--		BEGIN
--			DECLARE @sql NVARCHAR(MAX);
--			SET @sql = 'DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;'
--			SET @sql  = @sql + 'WITH TotalCountCTE AS (
--				SELECT COUNT(1) AS TotalCount
--				FROM RateCards.HotelOfferMaster hom
--				LEFT JOIN [dbo].City c ON c.IATACode = hom.CityID
--				LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = hom.VendorID'
				
--				SET @sql = @sql + ' WHERE '
--				SET @sql = @sql + '((@CardNumber IS NULL OR @CardNumber = '''') OR hom.CardNumber LIKE ''%'' + @CardNumber + ''%'')
--				AND ((@Heading IS NULL OR @Heading = '''') OR hom.Heading LIKE ''%'' + @Heading + ''%'')
--				AND ((@City IS NULL OR @City = '''') OR c.Name LIKE ''%'' + @City + ''%'')
--				AND ((@Vendor IS NULL OR @Vendor = '''') OR vm.VendorName LIKE ''%'' + @Vendor + ''%'''
--				--IF(@IsActive IS NOT NULL)
--				--	BEGIN
--				--		SET @sql = @sql + 'AND hom.IsActive = @IsActive'
--				--	END
--				 IF @IsActive IS NOT NULL
--					SET @sql = @sql + ' AND hom.IsActive = @IsActive'

--				SET @sql = @sql + '))'

--			SET @sql = @sql + ' SELECT hom.HotelOfferID,hom.CardNumber,hom.Heading,c.[Name] AS City,vm.VendorName,hom.IsActive,TotalCountCTE.TotalCount,CONVERT(VARCHAR(10), hom.ValidFrom, 120) AS ValidFrom,
--       CONVERT(VARCHAR(10), hom.ValidTo, 120) AS ValidTo,hom.[Rule],hg.Name AS HotelGroupName,
--			--0 AS HasRules,
--			--(CASE WHEN ud.DocumentID IS NOT NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END) AS HasDocument,
--		CAST(0 AS BIT) AS HasRules,
--		--CAST(IIF(NULLIF(LTRIM(RTRIM(hom.[Rule])), '''') IS NOT NULL, 1, 0) AS BIT) AS HasRules,
--ISNULL((
--    SELECT TOP 1 CAST(1 AS BIT)
--    FROM dbo.LinkedDocuments ld
--    INNER JOIN dbo.UploadDocuments ud 
--        ON ud.DocumentID = ld.DocumentID 
--        AND ud.ParentTypeID = 7
--    WHERE ld.ParentID = hom.HotelOfferID
--), CAST(0 AS BIT)) AS HasDocument,

--	--CAST(CASE WHEN ud.DocumentID IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS HasDocument,
			
--    (

--	--SELECT DISTINCT hm.HotelID, hm.HotelName, '' AS VendorID,'' AS VendorName

--	--INNER JOIN dbo.HotelMaster hm ON map.HotelID = hm.HotelID 
--	--WHERE map.HotelOfferID = hom.HotelOfferID AND map.IsActive = 1 
--	--UNION ALL 
--	SELECT DISTINCT null AS HotelID, null AS HotelName,vm.VendorID,vm.VendorName
--	FROM  RateCards.HotelOfferMaster map 
--	INNER JOIN dbo.VendorMaster VM ON map.VendorID = VM.VendorID 
--	WHERE map.IsActive = 1 AND map.HotelOfferID = hom.HotelOfferID   
--	FOR JSON PATH
--) AS HotelDetailsJson
			
--			FROM RateCards.HotelOfferMaster hom
--			LEFT JOIN [dbo].City c ON c.IATACode = hom.CityID
--			LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = hom.VendorID
--			LEFT JOIN [dbo].HotelGroups hg ON hg.HotelGroupID = hom.HotelGroupID
--			--LEFT JOIN dbo.LinkedDocuments ld ON ld.ParentID = hom.HotelOfferID
--			--LEFT JOIN dbo.UploadDocuments ud ON ud.DocumentID = ld.DocumentID AND ud.ParentTypeID = 4
--			CROSS JOIN TotalCountCTE
--			WHERE 
--            ((@CardNumber IS NULL OR @CardNumber = '''') OR hom.CardNumber LIKE ''%'' + @CardNumber + ''%'')
--            AND ((@Heading IS NULL OR @Heading = '''') OR hom.Heading LIKE ''%'' + @Heading + ''%'')
--            AND ((@City IS NULL OR @City = '''') OR c.Name LIKE ''%'' + @City + ''%'')
--            AND ((@Vendor IS NULL OR @Vendor = '''') OR vm.VendorName LIKE ''%'' + @Vendor + ''%'') '


--			IF @IsActive IS NOT NULL
--                SET @sql = @sql + ' AND hom.IsActive = @IsActive '


--			SET @sql = @sql + 'ORDER BY hom.CreatedOn DESC     
--			OFFSET @Offset ROWS
--			FETCH NEXT @PageSize ROWS ONLY';
--		PRINT @sql 
--		EXEC sp_executesql @sql,N'@CardNumber NVARCHAR(30),@Heading VARCHAR(50),@City VARCHAR(50),@Vendor VARCHAR(50),
--		@IsActive BIT,@PageSize INT,@PageNumber INT',
--		@CardNumber = @CardNumber, @Heading = @Heading, @City = @City, @Vendor = @Vendor, @PageSize = @PageSize, @PageNumber = @PageNumber,
--		@IsActive = @IsActive;
--		END
	IF @Operation = 'GET_RATE_BYID' AND @ID > 0
		BEGIN
			SELECT HotelOfferID,CardNumber,CityID,VendorID,HotelID,HotelGroupID,Heading,ValidFrom,ValidTo,[Rule],HOM.IsActive,InfoForOperation,HospitalityPartnerID,
			IsMarketOrAgent,C.name as CityName
			FROM RateCards.HotelOfferMaster HOM
			left join city  C on C.IATACode=HOM.CityID
			WHERE HotelOfferID = @ID

			SELECT ID,MarketRateID FROM [RateCards].[HotelOfferMarketMasterLookup] WHERE IsActive = 1 AND HotelOfferID = @ID

			SELECT ID,RateSheetID,RT.Rate_Type_Name as RateTypeName FROM [RateCards].[HotelOfferRateSheetMasterLookup] HOR
			inner join Rate_Type RT on RT.Rate_Type_ID =HOR.RateSheetID
			WHERE HOR.IsActive = 1 AND HotelOfferID = @ID

			SELECT hm.HotelID, hm.HotelName
	FROM RateCards.HotelOfferMapping map
	INNER JOIN dbo.HotelMaster hm ON hm.HotelID = map.HotelID
	WHERE map.HotelOfferID = @ID AND map.IsActive = 1

		

		END
END