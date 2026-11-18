CREATE PROCEDURE [RateCards].[Usp_GetTransportRateCards]
(
@Operation VARCHAR(30) = 'GETALL',
@CardNumber VARCHAR(Max) = NULL,
@RateCardModeTypeID VARCHAR(Max) = NULL,
@Heading VARCHAR(Max) = NULL,
@ServiceID VARCHAR(max) = NULL,
@HotelID VARCHAR(max) = NULL,
@VendorID VARCHAR(max) = NULL,
@ContractDate VARCHAR(50)= NULL,
@IsActive varchar(20) = NULL,
@CityID VARCHAR(Max) = NULL,
@PageSize INT = 10,
@PageNumber INT = 1,
@ID INT = 0
)
AS
--EXEC [RateCards].[Usp_GetTransportRateCards] @Operation = 'GETALL',@IsActive = 1,@CardNumber = '',@RateCardModeType = '', @Heading = '',@ContractDate='',@Hotel =''

BEGIN
	--Fetch all hote rate card details 
	DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
	IF @Operation = 'GETALL'
		BEGIN
			SET NOCOUNT ON;
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
			TransportServiceIDCTE AS (
				SELECT TRIM(value) AS TransportServiceID
				FROM STRING_SPLIT(@ServiceID, '|')
			)
			,HotelIDCTE AS (
				SELECT TRIM(value) AS HotelID
				FROM STRING_SPLIT(@HotelID, '|')
			),TotalCountCTE AS (
				SELECT COUNT(*) AS TotalCount
				FROM RateCards.TransportRateMaster trm 
				LEFT JOIN [dbo].[HotelMaster] hm ON trm.HotelID = hm.HotelID
				LEFT JOIN [dbo].[City] c ON c.IATACode = trm.CityID
				LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = trm.VendorID
				LEFT JOIN dbo.TransportServices ts ON ts.Code = trm.TransportServceID
				WHERE
				 ((@CardNumber IS NULL OR @CardNumber = '') OR trm.CardNumber IN (SELECT CardNumber FROM CardNumberCTE))
					AND ((@Heading IS NULL OR @Heading = '') OR trm.Heading IN (SELECT Heading FROM HeadingCTE))
					--AND ((@RateCardModeTypeID IS NULL OR @RateCardModeTypeID = '') OR trm.RateCardModeTypeID IN (SELECT RateCardModeTypeID FROM RateCardModeTypeCTE))
					AND ((@RateCardModeTypeID IS NULL OR @RateCardModeTypeID = '') AND trm.RateCardModeTypeID <> 3
			OR (@RateCardModeTypeID IS NOT NULL AND @RateCardModeTypeID <> '' AND trm.RateCardModeTypeID IN (SELECT RateCardModeTypeID FROM RateCardModeTypeCTE)))
			
					AND ((@ServiceID IS NULL OR @ServiceID = '') OR ts.Name IN (SELECT TransportServiceID FROM TransportServiceIDCTE))
					AND ((@CityID IS NULL OR @CityID = '') OR c.Name IN (SELECT CityID FROM CityIDCTE))
					AND ((@VendorID IS NULL OR @VendorID = '') OR vm.VendorName IN (SELECT VendorID FROM VendorIDCTE))
					AND ((@HotelID IS NULL OR @HotelID = '') OR hm.HotelName IN (SELECT HotelID FROM HotelIDCTE))
					AND (
						NOT EXISTS (SELECT 1 FROM @IsActiveTable)  -- No filtering if table is empty
						OR trm.IsActive IN (SELECT BitValue FROM @IsActiveTable)
					)
				)
			SELECT trm.TransportRateID,trm.CardNumber,trm.Heading,CONVERT(VARCHAR, trm.ContractDate, 23) AS ContractDate,trm.HotelID, ZM.ZoneName as HotelZoneName,
			hm.HotelName,ISNULL(c.[Name],'') AS City,vm.VendorName,vm.VendorID,trm.HotelZone,ISNULL(c1.[Name],'') AS City1,
			CASE 
				WHEN trm.RateCardModeTypeID =1 THEN 'Contract' 
				WHEN trm.RateCardModeTypeID =2 THEN 'Ad hoc' 
				WHEN trm.RateCardModeTypeID =3 THEN 'Negotiated'      
			END AS 'RateCardMode',trm.InfoForAgent,trm.InfoForOperation,trm.InfoForRemark,ts.[Name] AS TransportService,
			trm.IsActive, trm.RateCardModeTypeID,trm.CityID,trm.CityID2,curr.[Name] AS Currency,trm.CurrencyID,
			TotalCountCTE.TotalCount,
			(SELECT CASE WHEN EXISTS (SELECT 1 FROM [RateCards].[Rules] WHERE RateCardID=trm.TransportRateID) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END) AS HasRules,
			(select TOP 1 (CASE WHEN ud.DocumentID IS NOT NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END) AS HasDocument
			from dbo.LinkedDocuments ld inner join dbo.UploadDocuments ud ON ld.ParentID = trm.TransportRateID and ud.DocumentID = ld.DocumentID AND ud.ParentTypeID = 5),
			trm.TransportServceID,trm.TransportModeTypeID, ts.Name as TransportServiceName,trm.TransportServceID as TransportServiceID
			FROM RateCards.TransportRateMaster trm 
			LEFT JOIN [dbo].[HotelMaster] hm ON trm.HotelID = hm.HotelID
			LEFT JOIN [dbo].[City] c ON c.IATACode = trm.CityID
			LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = trm.VendorID
			LEFT JOIN [dbo].City c1 ON c1.IATACode = trm.CityID2
			LEFT JOIN dbo.Currency curr ON trm.CurrencyID= curr.Code 
			LEFT JOIN dbo.TransportServices ts ON ts.Code = trm.TransportServceID
			LEFT JOin dbo.ZoneMaster ZM on ZM.ZoneID=trm.HotelZone
			CROSS JOIN TotalCountCTE
			WHERE
		    ((@CardNumber IS NULL OR @CardNumber = '') OR trm.CardNumber IN (SELECT CardNumber FROM CardNumberCTE))
					AND ((@Heading IS NULL OR @Heading = '') OR trm.Heading IN (SELECT Heading FROM HeadingCTE))
					--AND ((@RateCardModeTypeID IS NULL OR @RateCardModeTypeID = '') OR trm.RateCardModeTypeID IN (SELECT RateCardModeTypeID FROM RateCardModeTypeCTE))
					AND ((@RateCardModeTypeID IS NULL OR @RateCardModeTypeID = '') AND trm.RateCardModeTypeID <> 3
			OR (@RateCardModeTypeID IS NOT NULL AND @RateCardModeTypeID <> '' AND trm.RateCardModeTypeID IN (SELECT RateCardModeTypeID FROM RateCardModeTypeCTE)))
					AND ((@ServiceID IS NULL OR @ServiceID = '') OR ts.Name IN (SELECT TransportServiceID FROM TransportServiceIDCTE))
					AND ((@CityID IS NULL OR @CityID = '') OR c.Name IN (SELECT CityID FROM CityIDCTE))
					AND ((@VendorID IS NULL OR @VendorID = '') OR vm.VendorName IN (SELECT VendorID FROM VendorIDCTE))
					AND ((@HotelID IS NULL OR @HotelID = '') OR hm.HotelName IN (SELECT HotelID FROM HotelIDCTE))
					AND (
						NOT EXISTS (SELECT 1 FROM @IsActiveTable)  -- No filtering if table is empty
						OR trm.IsActive IN (SELECT BitValue FROM @IsActiveTable)
					)
			ORDER BY trm.TransportRateID DESC
			OFFSET @Offset ROWS
			FETCH NEXT @PageSize ROWS ONLY;
		END
	IF @Operation = 'GET_RATE_BYID' AND @ID > 0
		BEGIN
			SET NOCOUNT ON;
			SELECT TransportRateID,RateCardModeTypeID,CardNumber,ContractDate,Heading,TransportServceID,TransportModeTypeID,
			HotelID,VendorID,HotelZone,CityID,CityID2,CurrencyID,StateID,GstStatus,InfoForOperation,InfoForAgent,InfoForRemark,IsActive,TransportServceID as TransportServiceID, HotelZone
			FROM RateCards.TransportRateMaster
			WHERE TransportRateID = @ID
		END
	IF @Operation = 'GET_RATEDETAILS_BYID' AND @ID > 0
		BEGIN
			SET NOCOUNT ON;
			select VTM.VehicleType,VTM.VehicleType as VehicleName,trd.TransportRateDetailID,trd.TaxID,trd.VehicleCategoryID,trd.VehicleBaseID,
			trd.ValidFrom,trd.ValidTo,CONCAT(FORMAT(trd.ValidFrom, 'dd-MM-yyyy'), ' - ', FORMAT(trd.ValidTo, 'dd-MM-yyyy')) AS ValidityDate,trd.MISSequence,trd.IsActive,trd.TransportRateID,
			trcd.TransportCommissionDetailID,trcd.CommissionMasterID,rcm.RateType,trcd.IsAmtIncludedInBasic,trcd.TaxPercentage,trcd.TaxAmount,trcd.NetAmountIncludingTax,trcd.NetAmountExcludingTax
			FROM [RateCards].[TransportRateDetails] trd LEFT JOIN [RateCards].[TransportRateCommissionDetails] trcd on trd.TransportRateDetailID=trcd.TransportRateDetailID
			Left join [dbo].VehicleTypeMaster VTM on VTM.ID=trd.VehicleCategoryID
			LEFT Join RateCommissionMaster RCM on RCM.CommMasterID=trcd.CommissionMasterID
			WHERE trd.TransportRateID =  @ID
			ORDER BY trd.MISSequence Asc  
		END
	IF @Operation = 'GET_COMMISSIONDETAILS_BYDETAILID' AND @ID > 0
		BEGIN
			SET NOCOUNT ON;
			SELECT TransportCommissionDetailID,TransportRateDetailID,CommissionMasterID,IsAmtIncludedInBasic,TaxPercentage,TaxAmount,NetAmountExcludingTax,
			NetAmountIncludingTax,IsActive
			FROM [RateCards].[TransportRateCommissionDetails]
			WHERE TransportRateDetailID = @ID
		END
	IF @Operation = 'GET_RATEDETAIL_BYID' AND @ID > 0
		BEGIN
			SET NOCOUNT ON;
			SELECT TransportRateDetailID,TaxID,VehicleCategoryID,VehicleBaseID,ValidFrom,ValidTo,MISSequence,IsActive FROM [tamarind_devdb].[RateCards].[TransportRateDetails] WHERE TransportRateDetailID = @ID
			SELECT TransportCommissionDetailID,TransportRateDetailID,CommissionMasterID,IsAmtIncludedInBasic,TaxAmount,NetAmountIncludingTax,NetAmountExcludingTax,
			TaxPercentage,IsActive
			FROM [tamarind_devdb].[RateCards].[TransportRateCommissionDetails] WHERE TransportRateDetailID = @ID
		END
	IF @Operation = 'GET_RATECARDNO' 
		BEGIN
			select distinct CardNumber FROM [RateCards].TransportRateMaster ssrc where CardNumber like '%'+@CardNumber+'%'
		END
	IF @Operation = 'GET_RATECARDHEADER' 
		BEGIN
			select distinct Heading FROM [RateCards].TransportRateMaster grm where Heading like '%'+@Heading+'%'
		END
	IF @Operation = 'GET_RATECARD_SERVICE' 
		BEGIN
			SELECT distinct Name as TransportServiceName from  [dbo].TransportServices WHERE [Name] LIKE '%'+@ServiceID+'%' AND IsActive = 1
		END
END