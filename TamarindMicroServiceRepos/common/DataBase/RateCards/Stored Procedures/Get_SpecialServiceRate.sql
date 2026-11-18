CREATE PROCEDURE [RateCards].[Get_SpecialServiceRate]
(
@Operation VARCHAR(30) = 'GETALL',
@ID BIGINT = 0,
@CardNumber VARCHAR(Max) = NULL,
@RateCardModeType VARCHAR(Max) = NULL,
@Heading VARCHAR(Max) = NULL,
@ContractDate VARCHAR(20) = NULL,
@SpecialService VARCHAR(Max) = NULL,
@City VARCHAR(Max) = NULL,
@Vendor VARCHAR(Max) = NULL,
@IsActive varchar(20) = NULL,
@PageSize INT = 10,
@PageNumber INT = 1
)
AS
/******************************/
--EXEC [RateCards].Get_SpecialServiceRate @Operation = 'GETALL', @ID = 1
--SELECT * FROM [RateCards].[SpecialServiceRateMaster]
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
				SpecialServiceIDCTE AS (
					SELECT TRIM(value) AS SpecialService
					FROM STRING_SPLIT(@SpecialService, '|')
				), TotalCountCTE AS (
				SELECT COUNT(*) AS TotalCount
				FROM [RateCards].[SpecialServiceRateMaster] ssrm
			LEFT JOIN [dbo].[SpecialServices] ss ON ss.ID = ssrm.SpecialServiceID 
			LEFT JOIN [dbo].City c ON c.IATACode = ssrm.CityID
			LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = ssrm.VendorID
			Left Join dbo.HotelMaster HM on HM.HotelID=ssrm.HotelID
			WHERE 
            ((@CardNumber IS NULL OR @CardNumber = '') OR ssrm.CardNumber IN (SELECT CardNumber FROM CardNumberCTE))
				AND ((@Heading IS NULL OR @Heading = '') OR ssrm.Heading IN (SELECT Heading FROM HeadingCTE))
				--AND ((@RateCardModeType IS NULL OR @RateCardModeType = '') OR ssrm.RateCardModeTypeID IN (SELECT RateCardModeType FROM RateCardModeTypeCTE))
				AND ((@RateCardModeType IS NULL OR @RateCardModeType = '') AND ssrm.RateCardModeTypeID <> 3
				OR (@RateCardModeType IS NOT NULL AND @RateCardModeType <> '' AND ssrm.RateCardModeTypeID IN (SELECT RateCardModeType FROM RateCardModeTypeCTE)))
				AND ((@City IS NULL OR @City = '') OR c.Name IN (SELECT City FROM CityIDCTE))
				AND ((@Vendor IS NULL OR @Vendor = '') OR vm.VendorName IN (SELECT Vendor FROM VendorIDCTE))
				AND ((@SpecialService IS NULL OR @SpecialService = '') OR ss.Name IN (SELECT SpecialService FROM SpecialServiceIDCTE))
				AND (
					NOT EXISTS (SELECT 1 FROM @IsActiveTable)  -- No filtering if table is empty
					OR ssrm.IsActive IN (SELECT BitValue FROM @IsActiveTable)
				)
			)

			SELECT ssrm.SpecialServiceRateID,ssrm.CardNumber,              
			CASE 
				WHEN ssrm.RateCardModeTypeID =1 THEN 'Contract' 
				WHEN ssrm.RateCardModeTypeID =2 THEN 'Ad hoc' 
				WHEN ssrm.RateCardModeTypeID =3 THEN 'Negotiated'      
			END AS 'RateCardMode',ssrm.Heading,CONVERT(VARCHAR,CAST(CONVERT(VARCHAR,ssrm.ContractDate,101) AS DATETIME),103) AS ContractDate,
			ss.Name AS SpecialService,c.Name AS City,vm.VendorName,ssrm.IsActive, ssrm.HotelID, HM.HotelName
			,curr.[Name] AS Currency,ssrm.CurrencyID,TotalCountCTE.TotalCount,
					--(SELECT CASE WHEN EXISTS (SELECT 1 FROM [RateCards].[Rules] WHERE RateCardID=ssrm.SpecialServiceRateID) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END) AS HasRules,
					--(CASE WHEN ud.DocumentID IS NOT NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END) AS HasDocument
			(
        SELECT 
            CASE 
                WHEN EXISTS (SELECT 1 FROM [RateCards].[Rules] WHERE RateCardID = ssrm.SpecialServiceRateID) 
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
         ON ld.ParentID = ssrm.SpecialServiceRateID
         AND ud.DocumentID = ld.DocumentID 
         AND ud.ParentTypeID = 4
    ) AS HasDocument
			FROM [RateCards].[SpecialServiceRateMaster] ssrm
			LEFT JOIN [dbo].[SpecialServices] ss ON ss.ID = ssrm.SpecialServiceID 
			LEFT JOIN [dbo].City c ON c.IATACode = ssrm.CityID
			LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = ssrm.VendorID
			LEFT Join dbo.HotelMaster HM on HM.HotelID=ssrm.HotelID
			LEFT JOIN dbo.Currency curr ON ssrm.CurrencyID= curr.Code  
			--LEFT JOIN dbo.LinkedDocuments ld ON ld.ParentID = ssrm.SpecialServiceRateID
			--LEFT JOIN dbo.UploadDocuments ud ON ud.DocumentID = ld.DocumentID AND ud.ParentTypeID = 4
			CROSS JOIN TotalCountCTE
			WHERE 
            ((@CardNumber IS NULL OR @CardNumber = '') OR ssrm.CardNumber IN (SELECT CardNumber FROM CardNumberCTE))
				AND ((@Heading IS NULL OR @Heading = '') OR ssrm.Heading IN (SELECT Heading FROM HeadingCTE))
				--AND ((@RateCardModeType IS NULL OR @RateCardModeType = '') OR ssrm.RateCardModeTypeID IN (SELECT RateCardModeType FROM RateCardModeTypeCTE))
				AND ((@RateCardModeType IS NULL OR @RateCardModeType = '') AND ssrm.RateCardModeTypeID <> 3
				OR (@RateCardModeType IS NOT NULL AND @RateCardModeType <> '' AND ssrm.RateCardModeTypeID IN (SELECT RateCardModeType FROM RateCardModeTypeCTE)))
				AND ((@City IS NULL OR @City = '') OR c.Name IN (SELECT City FROM CityIDCTE))
				AND ((@Vendor IS NULL OR @Vendor = '') OR vm.VendorName IN (SELECT Vendor FROM VendorIDCTE))
				AND ((@SpecialService IS NULL OR @SpecialService = '') OR ss.Name IN (SELECT SpecialService FROM SpecialServiceIDCTE))
				AND (
					NOT EXISTS (SELECT 1 FROM @IsActiveTable)  -- No filtering if table is empty
					OR ssrm.IsActive IN (SELECT BitValue FROM @IsActiveTable)
			)
			ORDER BY ssrm.CreatedOn DESC     
			OFFSET @Offset ROWS
			FETCH NEXT @PageSize ROWS ONLY;
		END
	IF @Operation = 'GET_RATEDETAILS_BYRATEID' AND @ID > 0
		BEGIN
			select ssrd.SpecialServiceRateDetailID,ssrd.TaxID,ssrd.ValidFrom,ssrd.ValidTo,ssrd.RatePreferenceID,ssrc.CommissionMasterID,
			ssrd.MISSequence, ssrc.SpecialServiceRateCommissionID,ssrd.IsActive,n.Nationality, ssrd.SpecialServiceRateID,
			CONCAT(FORMAT(ssrd.ValidFrom, 'dd-MM-yyyy'), ' - ', FORMAT(ssrd.ValidTo, 'dd-MM-yyyy')) AS ValidityDate,RCM.Ratetype,
			ssrc.TaxPercentage,ssrc.TaxAmount,ssrc.NetAmountIncludingTax,ssrc.NetAmountExcludingTax, ssrc.SpecialServiceRateDetailID,
			CASE 
                 WHEN ssrd.RatePreferenceID = 1 THEN 'Consolidated'
                 WHEN ssrd.RatePreferenceID = 2 THEN 'Per Person'
            END AS RatePreference,ssrc.MinimumPax,ssrc.MaximumPax,ssrd.NationalityID 
			FROM [RateCards].[SpecialServiceRateDeatils] ssrd 
			LEFT JOIN [RateCards].SpecialServiceRateCommissionDeatils ssrc ON ssrd.SpecialServiceRateDetailID = ssrc.SpecialServiceRateDetailID 
			LEFT JOIN [dbo].[Nationality] n ON n.ID = ssrd.NationalityID 
			LEFT Join RateCommissionMaster RCM on RCM.CommMasterID=ssrc.CommissionMasterID
			WHERE ssrd.SpecialServiceRateID =  @ID
			ORDER BY ssrd.MISSequence Asc  
			--OFFSET @Offset ROWS
			--FETCH NEXT @PageSize ROWS ONLY;
		END
	IF @Operation = 'GET_RATE_BYID' AND @ID > 0
		BEGIN
			SELECT SpecialServiceRateID,CardNumber,ContractDate,Heading,SpecialServiceID,RateCardModeTypeID,InfoForOperation,InfoForAgent,InfoForRemark,
			CityID,StateID,GstStatus,VendorID,CurrencyID,IsActive,HotelID
			FROM [RateCards].[SpecialServiceRateMaster] WHERE SpecialServiceRateID = @ID
		END
	IF @Operation = 'GET_RATEDETAIL_BYID' AND @ID > 0
		BEGIN
			SELECT SpecialServiceRateDetailID,TaxID,
			CASE 
                 WHEN TaxID = 1 THEN 'Inclusive'
                 WHEN TaxID = 2 THEN 'Exclusive'
                 ELSE NULL
            END AS TaxPreference,
			ValidFrom,ValidTo,NationalityID,MISSequence,IsActive 
			FROM [RateCards].[SpecialServiceRateDeatils] WHERE SpecialServiceRateDetailID = @ID

			SELECT SpecialServiceRateCommissionID,MinimumPax,MaximumPax,TaxPercentage,TaxAmount,NetAmountIncludingTax,NetAmountExcludingTax,
			SpecialServiceRateDetailID,IsActive,CreatedOn,UpdatedOn
			FROM RateCards.SpecialServiceRateCommissionDeatils WHERE SpecialServiceRateDetailID = @ID
		END
		IF @Operation = 'GET_RATECARDNO' 
		BEGIN
			select distinct CardNumber FROM [RateCards].[SpecialServiceRateMaster] ssrc where CardNumber like '%'+@CardNumber+'%'
		END
	IF @Operation = 'GET_RATECARDHEADER' 
		BEGIN
			select distinct Heading FROM [RateCards].[SpecialServiceRateMaster] grm where Heading like '%'+@Heading+'%'
		END
	IF @Operation = 'GET_RATECARD_SERVICE' 
		BEGIN
			SELECT distinct Name as SpecialService from  [dbo].[SpecialServices] WHERE [Name] LIKE '%'+@SpecialService+'%' AND IsActive = 1
		END
END