CREATE PROCEDURE [RateCards].[Get_GuideRateCard]
(
@Operation VARCHAR(50) = 'GETALL',
@ID BIGINT = 0,
@CardNumber VARCHAR(Max) = NULL,
@RateCardModeTypeID VARCHAR(200) = NULL,
@Heading VARCHAR(Max) = NULL,
@ContractDate VARCHAR(20) = NULL,
@GuideServiceID VARCHAR(Max) = NULL,
@GuideService VARCHAR(200) = NULL,
@CityID VARCHAR(Max) = NULL,
@VendorID VARCHAR(Max) = NULL,
@IsActive Varchar(20) = NULL,
@PageSize INT = 10,
@PageNumber INT = 1
)
AS
/******************************/
--EXEC [RateCards].[Get_GuideRateCard] @Operation = 'GETALL', @ID = 1 , @PageSize = 10, @PageNumber = 1,@RateCardModeTypeID='1,2'
/******************************/
BEGIN
	SET NOCOUNT ON;
	DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
	IF @Operation = 'GETALL'
	BEGIN
		DECLARE @IsActiveTable TABLE (BitValue BIT);
		IF @IsActive IS NOT NULL AND UPPER(@IsActive) NOT IN ('NULL', '')
		BEGIN
			INSERT INTO @IsActiveTable (BitValue)
			SELECT 
				CASE 
					WHEN UPPER(TRIM(value)) = 'TRUE' THEN 1
					WHEN UPPER(TRIM(value)) = 'FALSE' THEN 0
					ELSE NULL 
				END
			FROM STRING_SPLIT(@IsActive, '|')
			WHERE UPPER(TRIM(value)) IN ('TRUE', 'FALSE');  -- Only valid entries
		END;
-- First, create CTEs for splitting multiple comma-separated inputs
WITH 
RateCardModeTypeCTE AS (
    SELECT TRY_CAST(value AS TINYINT) AS RateCardModeTypeID
    FROM STRING_SPLIT(@RateCardModeTypeID, '|')
    WHERE TRY_CAST(value AS TINYINT) IS NOT NULL
),
CardNumberCTE AS (
    SELECT TRIM(value) AS CardNumber
    FROM STRING_SPLIT(@CardNumber, '|')
),
HeadingCTE AS (
    SELECT TRIM(value) AS Heading
    FROM STRING_SPLIT(@Heading, '|')
),
CityIDCTE AS (
    SELECT TRIM(value) AS CityID
    FROM STRING_SPLIT(@CityID, '|')
),
VendorIDCTE AS (
    SELECT TRIM(value) AS VendorID
    FROM STRING_SPLIT(@VendorID, '|')
),
GuideServiceIDCTE AS (
    SELECT TRIM(value) AS GuideServiceID
    FROM STRING_SPLIT(@GuideServiceID, '|')
),
TotalCountCTE AS (
    SELECT COUNT(*) AS TotalCount
    FROM [RateCards].[GuideRateMaster] grm       
    LEFT JOIN dbo.City city ON grm.CityID = city.IATACode                      
    LEFT JOIN dbo.GuideServices gs ON grm.GuideServiceID = gs.Code                    
    LEFT JOIN dbo.VendorMaster VM ON grm.VendorID = VM.VendorID           
    LEFT JOIN dbo.Currency curr ON grm.CurrencyID = curr.Code  
    WHERE 
        ((@CardNumber IS NULL OR @CardNumber = '') OR grm.CardNumber IN (SELECT CardNumber FROM CardNumberCTE))
        AND ((@Heading IS NULL OR @Heading = '') OR grm.Heading IN (SELECT Heading FROM HeadingCTE))
        --AND ((@RateCardModeTypeID IS NULL OR @RateCardModeTypeID = '') OR grm.RateCardModeTypeID IN (SELECT RateCardModeTypeID FROM RateCardModeTypeCTE))
        AND (
    (@RateCardModeTypeID IS NULL OR @RateCardModeTypeID = '')
    AND grm.RateCardModeTypeID <> 3
    OR (@RateCardModeTypeID IS NOT NULL AND @RateCardModeTypeID <> ''
        AND grm.RateCardModeTypeID IN (SELECT RateCardModeTypeID FROM RateCardModeTypeCTE)))
		AND ((@GuideServiceID IS NULL OR @GuideServiceID = '') OR gs.Name IN (SELECT GuideServiceID FROM GuideServiceIDCTE))
        AND ((@CityID IS NULL OR @CityID = '') OR city.Name IN (SELECT CityID FROM CityIDCTE))
        AND ((@VendorID IS NULL OR @VendorID = '') OR vm.VendorName IN (SELECT VendorID FROM VendorIDCTE))
		AND (
			NOT EXISTS (SELECT 1 FROM @IsActiveTable)  -- No filtering if table is empty
			OR grm.IsActive IN (SELECT BitValue FROM @IsActiveTable)
		)
	)

SELECT 
    grm.GuideRateID,
    grm.CardNumber,              
    CASE 
        WHEN grm.RateCardModeTypeID = 1 THEN 'Contract'
        WHEN grm.RateCardModeTypeID = 2 THEN 'Ad hoc'
        WHEN grm.RateCardModeTypeID = 3 THEN 'Negotiated'      
    END AS 'RateCardMode',
    grm.Heading,
    FORMAT(grm.ContractDate, 'dd-MM-yyyy') AS ContractDate,
    city.[Name] AS City,
    VM.VendorName AS Vendor,
    gs.[Name] AS GuideService,
    curr.[Name] AS Currency,
    grm.IsActive,
    grm.CreatedOn,
    TotalCountCTE.TotalCount,
    (
        SELECT 
            CASE 
                WHEN EXISTS (SELECT 1 FROM [RateCards].[Rules] WHERE RateCardID = grm.GuideRateID) 
                THEN CAST(1 AS BIT) 
                ELSE CAST(0 AS BIT) 
            END
    ) AS HasRules,
    (SELECT TOP 1 
        CASE 
            WHEN ud.DocumentID IS NOT NULL THEN CAST(1 AS BIT) 
            ELSE CAST(0 AS BIT) 
        END
     FROM dbo.LinkedDocuments ld 
     INNER JOIN dbo.UploadDocuments ud 
         ON ld.ParentID = grm.GuideRateID 
         AND ud.DocumentID = ld.DocumentID 
         AND ud.ParentTypeID = 2
    ) AS HasDocument,
    grm.RateCardModeTypeID,
    grm.Notes as ValueAddOn,
    grm.CurrencyID
		FROM [RateCards].[GuideRateMaster] grm       
		LEFT JOIN dbo.City city ON grm.CityID = city.IATACode                      
		LEFT JOIN dbo.GuideServices gs ON grm.GuideServiceID = gs.Code                    
		LEFT JOIN dbo.VendorMaster VM ON grm.VendorID = VM.VendorID           
		LEFT JOIN dbo.Currency curr ON grm.CurrencyID = curr.Code  
		CROSS JOIN TotalCountCTE
		WHERE 
			((@CardNumber IS NULL OR @CardNumber = '') OR grm.CardNumber IN (SELECT CardNumber FROM CardNumberCTE))
			AND ((@Heading IS NULL OR @Heading = '') OR grm.Heading IN (SELECT Heading FROM HeadingCTE))
			--AND ((@RateCardModeTypeID IS NULL OR @RateCardModeTypeID = '') OR grm.RateCardModeTypeID IN (SELECT RateCardModeTypeID FROM RateCardModeTypeCTE))
<<<<<<< HEAD
<<<<<<< HEAD
			AND ((@RateCardModeTypeID IS NULL OR @RateCardModeTypeID = '') AND grm.RateCardModeTypeID <> 3
=======
			AND ((@RateCardModeTypeID IS NULL OR @RateCardModeTypeID = '') 
			AND grm.RateCardModeTypeID <> 3
>>>>>>> dev
=======
			AND ((@RateCardModeTypeID IS NULL OR @RateCardModeTypeID = '') 
			AND grm.RateCardModeTypeID <> 3
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			OR (@RateCardModeTypeID IS NOT NULL AND @RateCardModeTypeID <> '' AND grm.RateCardModeTypeID IN (SELECT RateCardModeTypeID FROM RateCardModeTypeCTE)))
			AND ((@CityID IS NULL OR @CityID = '') OR city.Name IN (SELECT CityID FROM CityIDCTE))
			AND ((@VendorID IS NULL OR @VendorID = '') OR vm.VendorName IN (SELECT VendorID FROM VendorIDCTE))
			AND ((@GuideServiceID IS NULL OR @GuideServiceID = '') OR gs.Name IN (SELECT GuideServiceID FROM GuideServiceIDCTE))
			AND (
				NOT EXISTS (SELECT 1 FROM @IsActiveTable)  -- No filtering if table is empty
				OR grm.IsActive IN (SELECT BitValue FROM @IsActiveTable)
			)
		ORDER BY grm.CreatedOn DESC
		OFFSET @Offset ROWS
		FETCH NEXT @PageSize ROWS ONLY;
	END
	IF @Operation = 'GET_RATE_BYID' AND @ID > 0
	BEGIN
		SELECT grm.GuideRateID,grm.CardNumber,grm.ContractDate,grm.CityID,grm.GuideServiceID,grm.CurrencyID,grm.StateID,
		grm.VendorID,grm.LanguageID,grm.RateCardModeTypeID,grm.InfoForOperation,grm.InfoForAgent,grm.InfoForRemark,grm.GstStatus,
		grm.IsActive,grm.Notes as ValueAddOn,grm.Heading
		FROM [RateCards].[GuideRateMaster] grm WHERE grm.GuideRateID = @Id
	END
	IF @Operation = 'GET_RATEDETAILS_BYID' AND @ID > 0
	BEGIN
		--SELECT * FROM [RateCards].[GuideRateDetails]

		SELECT grd.GuideRateDetailID,grd.GuideRateID,grd.ValidFrom,grd.ValidTo,grd.MISSequence,grd.IsActive,grd.TaxID,grc.GuideRateCommissionID,
		-- grd.GuideRateDetailID,grc.GuideRateCommissionID,
		CONCAT(FORMAT(grd.ValidFrom, 'dd-MM-yyyy'), ' - ', FORMAT(grd.ValidTo, 'dd-MM-yyyy')) AS ValidityDate,
		grc.TaxAmount,grc.TaxPercentage,grc.PaxMinimum,grc.PaxMaximum,grc.NetAmountIncludingTax,grc.NetAmountExcludingTax
		FROM [RateCards].[GuideRateDetails] grd
		LEFT JOIN [RateCards].[GuideRateCommissionDetails] grc ON grd.GuideRateDetailID = grc.GuideRateDetailID
		WHERE 
		grd.GuideRateID = @ID 
		ORDER BY grd.MISSequence asc
		--OFFSET @Offset ROWS
		--FETCH NEXT @PageSize ROWS ONLY;
	END
	IF @Operation = 'GET_RATEDETAIL_BYID' AND @ID > 0
		BEGIN
			SELECT GuideRateDetailID,TaxID,ValidFrom,ValidTo,MISSequence,IsActive 
			FROM [RateCards].[GuideRateDetails] WHERE GuideRateDetailID = @ID

			SELECT GuideRateCommissionID,TaxPercentage,TaxAmount,NetAmountIncludingTax,NetAmountExcludingTax,GuideRateDetailID,
			IsActive
			FROM [RateCards].[GuideRateCommissionDetails] WHERE GuideRateDetailID = @ID
		END

	IF @Operation = 'GET_RATECARDNO' 
		BEGIN
			select distinct grm.CardNumber FROM [RateCards].[GuideRateMaster] grm where CardNumber like '%'+@CardNumber+'%'
		END
	IF @Operation = 'GET_RATECARDHEADER' 
		BEGIN
			select distinct grm.Heading FROM [RateCards].[GuideRateMaster] grm where Heading like '%'+@Heading+'%'
		END
	IF @Operation = 'GET_RATECARD_SERVICE' 
		BEGIN
			SELECT distinct [Name] as GuideService FROM dbo.GuideServices WHERE [Name] LIKE '%'+@GuideService+'%' AND IsActive = 1
		END
END