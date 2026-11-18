CREATE PROCEDURE [RateCards].[Get_MonumentRate]
(
@Operation VARCHAR(30) = 'GETALL',
@ID BIGINT = 0,
@CardNumber VARCHAR(Max) = NULL,
@RateCardModeType VARCHAR(Max) = NULL,
@Heading VARCHAR(Max) = NULL,
@ContractDate VARCHAR(20) = NULL,
@Monument VARCHAR(Max) = NULL,
@City VARCHAR(Max) = NULL,
@Vendor VARCHAR(Max) = NULL,
@IsActive varchar(20) = NULL,
@PageSize INT = 10,
@PageNumber INT = 1
)
AS
/******************************/
--EXEC [RateCards].Get_MonumentRate @Operation = 'GETALL', @ID = 1
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
					SELECT TRY_CAST(value AS TINYINT) AS RateCardModeType
					FROM STRING_SPLIT(@RateCardModeType, '|')
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
					SELECT TRIM(value) AS City
					FROM STRING_SPLIT(@City, '|')
				),
				VendorIDCTE AS (
					SELECT TRIM(value) AS Vendor
					FROM STRING_SPLIT(@Vendor, '|')
				),
				MonumentServiceIDCTE AS (
					SELECT TRIM(value) AS Monument
					FROM STRING_SPLIT(@Monument, '|')
				), TotalCountCTE AS (
				SELECT COUNT(*) AS TotalCount
				FROM RateCards.MonumentRateMaster mrm
				LEFT JOIN [dbo].[MonumentService] ms ON ms.ID = mrm.MonumentServiceID 
				LEFT JOIN [dbo].City c ON c.IATACode = mrm.CityID
				LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = mrm.VendorID
				WHERE 
				((@CardNumber IS NULL OR @CardNumber = '') OR mrm.CardNumber IN (SELECT CardNumber FROM CardNumberCTE))
				AND ((@Heading IS NULL OR @Heading = '') OR mrm.Heading IN (SELECT Heading FROM HeadingCTE))
				AND ((@RateCardModeType IS NULL OR @RateCardModeType = '') AND mrm.RateCardModeTypeID <> 3
				OR (@RateCardModeType IS NOT NULL AND @RateCardModeType <> '' AND mrm.RateCardModeTypeID IN (SELECT RateCardModeType FROM RateCardModeTypeCTE)))
				--AND ((@RateCardModeType IS NULL OR @RateCardModeType = '') OR mrm.RateCardModeTypeID IN (SELECT RateCardModeType FROM RateCardModeTypeCTE))
				AND ((@City IS NULL OR @City = '') OR c.Name IN (SELECT City FROM CityIDCTE))
				AND ((@Vendor IS NULL OR @Vendor = '') OR vm.VendorName IN (SELECT Vendor FROM VendorIDCTE))
				AND ((@Monument IS NULL OR @Monument = '') OR ms.Name IN (SELECT Monument FROM MonumentServiceIDCTE))
				AND (
					NOT EXISTS (SELECT 1 FROM @IsActiveTable)  -- No filtering if table is empty
					OR mrm.IsActive IN (SELECT BitValue FROM @IsActiveTable)
				)
			)

			SELECT mrm.MonumentRateID,mrm.CardNumber,              
			CASE 
				WHEN mrm.RateCardModeTypeID =1 THEN 'Contract' 
				WHEN mrm.RateCardModeTypeID =2 THEN 'Ad hoc' 
				WHEN mrm.RateCardModeTypeID =3 THEN 'Negotiated'      
			END AS 'RateCardMode',mrm.Heading,CONVERT(VARCHAR,CAST(CONVERT(VARCHAR,mrm.ContractDate,101) AS DATETIME),103) AS ContractDate,
			ms.Name AS MonumentService,c.Name AS City,vm.VendorName,mrm.IsActive,TotalCountCTE.TotalCount,
    (SELECT CASE WHEN EXISTS (SELECT 1 FROM [RateCards].[Rules] WHERE RateCardID  = mrm.MonumentRateID) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END) AS HasRules,
    (SELECT TOP 1 CASE WHEN ud.DocumentID IS NOT NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END FROM dbo.LinkedDocuments ld INNER JOIN dbo.UploadDocuments ud ON ld.ParentID = mrm.MonumentRateID AND ud.DocumentID = ld.DocumentID AND ud.ParentTypeID = 4) AS HasDocument,
    --(SELECT CASE WHEN EXISTS (SELECT 1 FROM [RateCards].[Rules] WHERE RateCardID=mrm.MonumentRateID) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END) AS HasRules,
    --(CASE WHEN ud.DocumentID IS NOT NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END) AS HasDocument,
	mrm.RateCardModeTypeID,curr.[Name] AS Currency,mrm.CurrencyID
			FROM RateCards.MonumentRateMaster mrm
			LEFT JOIN [dbo].[MonumentService] ms ON ms.ID = mrm.MonumentServiceID 
			LEFT JOIN [dbo].City c ON c.IATACode = mrm.CityID
			LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = mrm.VendorID
			LEFT JOIN dbo.Currency curr ON mrm.CurrencyID= curr.Code  
			--LEFT JOIN dbo.LinkedDocuments ld ON ld.ParentID = mrm.MonumentRateID
			--LEFT JOIN dbo.UploadDocuments ud ON ud.DocumentID = ld.DocumentID AND ud.ParentTypeID = 4
			CROSS JOIN TotalCountCTE
			WHERE 
            ((@CardNumber IS NULL OR @CardNumber = '') OR mrm.CardNumber IN (SELECT CardNumber FROM CardNumberCTE))
				AND ((@Heading IS NULL OR @Heading = '') OR mrm.Heading IN (SELECT Heading FROM HeadingCTE))
				AND ((@RateCardModeType IS NULL OR @RateCardModeType = '') AND mrm.RateCardModeTypeID <> 3
				OR (@RateCardModeType IS NOT NULL AND @RateCardModeType <> '' AND mrm.RateCardModeTypeID IN (SELECT RateCardModeType FROM RateCardModeTypeCTE)))
				AND ((@City IS NULL OR @City = '') OR c.Name IN (SELECT City FROM CityIDCTE))
				AND ((@Vendor IS NULL OR @Vendor = '') OR vm.VendorName IN (SELECT Vendor FROM VendorIDCTE))
				AND ((@Monument IS NULL OR @Monument = '') OR ms.Name IN (SELECT Monument FROM MonumentServiceIDCTE))
				AND (
					NOT EXISTS (SELECT 1 FROM @IsActiveTable)  -- No filtering if table is empty
					OR mrm.IsActive IN (SELECT BitValue FROM @IsActiveTable)
				)
			ORDER BY mrm.CreatedOn DESC     
			OFFSET @Offset ROWS
			FETCH NEXT @PageSize ROWS ONLY;
		END
	IF @Operation = 'GET_RATEDETAILS_BYRATEID' AND @ID > 0
		BEGIN
			SELECT mrd.MonumentDetailID,mrd.TaxID,mrd.ValidFrom,mrd.ValidTo,mrd.MISSequence, mrc.CommissionMasterID,mrd.IsActive,n.Nationality, mrc.MonumentCommissionDetailID,
			CONCAT(FORMAT(mrd.ValidFrom, 'dd-MM-yyyy'), ' - ', FORMAT(mrd.ValidTo, 'dd-MM-yyyy')) AS ValidityDate,RCM.Ratetype,mrd.NationalityID ,
			mrc.TaxPercentage,mrc.TaxAmount,mrc.NetAmountIncludingTax,mrc.NetAmountExcludingTax,mrc.MonumentDetailID
			FROM RateCards.MonumentRateDetails mrd 
			LEFT JOIN [RateCards].[MonumentRateCommissionDetails] mrc ON mrd.MonumentDetailID = mrc.MonumentDetailID
			LEFT JOIN [dbo].[Nationality] n ON n.ID = mrd.NationalityID 
			LEFT JOIN RateCommissionMaster RCM on RCM.CommMasterID=mrc.CommissionMasterID
			WHERE mrd.MonumentRateID = @ID
			ORDER BY mrd.MISSequence Asc     
			--OFFSET @Offset ROWS
			--FETCH NEXT @PageSize ROWS ONLY;
			
		END
	IF @Operation = 'GET_RATE_BYID' AND @ID > 0
		BEGIN
			SELECT MonumentRateID,CardNumber,ContractDate,Heading,MonumentServiceID,RateCardModeTypeID,InfoForOperation,InfoForAgent,InfoForRemark,
			CityID,StateID,GstStatus,VendorID,CurrencyID,IsActive
			FROM RateCards.MonumentRateMaster 
			WHERE MonumentRateID = @ID
		END
	IF @Operation = 'GET_RATEDETAIL_BYID' AND @ID > 0
		BEGIN
			SELECT MonumentDetailID,TaxID,ValidFrom,ValidTo,NationalityID,MISSequence,IsActive 
			FROM RateCards.MonumentRateDetails WHERE MonumentDetailID = @ID

			SELECT MonumentCommissionDetailID,CommissionMasterID,TaxPercentage,TaxAmount,NetAmountIncludingTax,NetAmountExcludingTax,MonumentDetailID,
			IsActive,CreatedOn,UpdatedOn
			FROM RateCards.MonumentRateCommissionDetails WHERE MonumentDetailID = @ID
		END
	IF @Operation = 'GET_RATECARDNO' 
		BEGIN
			select distinct grm.CardNumber FROM [RateCards].MonumentRateMaster grm where CardNumber like '%'+@CardNumber+'%'
		END
	IF @Operation = 'GET_RATECARDHEADER' 
		BEGIN
			select distinct grm.Heading FROM [RateCards].MonumentRateMaster grm where Heading like '%'+@Heading+'%'
		END
	IF @Operation = 'GET_RATECARD_SERVICE' 
		BEGIN
			SELECT distinct [Name] as MonumentService from [dbo].[MonumentService] WHERE [Name] LIKE '%'+@Monument+'%' AND IsActive = 1
		END
END