CREATE PROCEDURE [RateCards].[Usp_GetHotelRateCards]
(
@Operation VARCHAR(30) = 'GETALL',
@CardNumber VARCHAR(MAX) = NULL,
@RateCardModeTypeID VARCHAR(200) = NULL,
@Heading VARCHAR(MAX) = NULL,
@ContractDate VARCHAR(20) = NULL,
@HotelID VARCHAR(max) = NULL,
@IsActive varchar(20) = NULL,
@CityID VARCHAR(Max) = NULL,
@PaymentTypeID VARCHAR(50) = NULL,
@PageSize INT = 10,
@PageNumber INT = 1,
@ID BIGINT = 0
)
AS
--EXEC [RateCards].[Usp_GetHotelRateCards] @Operation = 'GET_RATEDETAILS_BYID', @ID=405542 @IsActive = 1,@CardNumber = '',@RateCardModeType = '', 
--@Heading = '',@ContractDate='',@Hotel =''

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
			HotelIDCTE AS (
				SELECT TRIM(value) AS HotelID
				FROM STRING_SPLIT(@HotelID, '|')
			),
			CityIDCTE AS (
				SELECT TRIM(value) AS CityID
				FROM STRING_SPLIT(@CityID, '|')
			),
			PaymentTypeCTE AS (
				SELECT TRIM(value) AS PaymentType
				FROM STRING_SPLIT(@PaymentTypeID, '|')
			),
			TotalCountCTE AS (
				SELECT COUNT(1) AS TotalCount
				FROM RateCards.HotelRateMaster hrm 
				LEFT JOIN [dbo].[HotelMaster] hm ON hrm.HotelID = hm.HotelID
				LEFT JOIN [dbo].[City] c ON c.IATACode = hrm.CityID
				LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = hrm.VendorID
				WHERE
					((@CardNumber IS NULL OR @CardNumber = '') OR hrm.CardNumber IN (SELECT CardNumber FROM CardNumberCTE))
					AND ((@Heading IS NULL OR @Heading = '') OR hrm.Heading IN (SELECT Heading FROM HeadingCTE))
					AND ((@RateCardModeTypeID IS NULL OR @RateCardModeTypeID = '') AND hrm.RateCardModeTypeID <> 3
					OR (@RateCardModeTypeID IS NOT NULL AND @RateCardModeTypeID <> '' AND hrm.RateCardModeTypeID IN (SELECT RateCardModeTypeID FROM RateCardModeTypeCTE)))
					AND ((@CityID IS NULL OR @CityID = '') OR c.Name IN (SELECT CityID FROM CityIDCTE))
					AND (
						NOT EXISTS (SELECT 1 FROM @IsActiveTable)  -- No filtering if table is empty
						OR hrm.IsActive IN (SELECT BitValue FROM @IsActiveTable)
					)
					AND ((@HotelID IS NULL OR @HotelID = '') OR hm.HotelName IN (SELECT HotelID FROM HotelIDCTE))
					AND ((@PaymentTypeID IS NULL OR @PaymentTypeID = '') OR hrm.PaymentTypeID  IN (SELECT PaymentType FROM PaymentTypeCTE))
			)
				SELECT 
					hrm.HotelRateID,
					hrm.CardNumber,
					hrm.Heading,
					CONVERT(VARCHAR, hrm.ContractDate, 23) AS ContractDate,
					hm.HotelName,
					ISNULL(c.[Name],'') AS CityName,
					CASE 
						WHEN hrm.RateCardModeTypeID = 1 THEN 'Contract' 
						WHEN hrm.RateCardModeTypeID = 2 THEN 'Ad hoc' 
						WHEN hrm.RateCardModeTypeID = 3 THEN 'Negotiated'      
					END AS RateCardMode,
					CASE 
						WHEN hrm.PaymentTypeID = 1 THEN 0
						WHEN hrm.PaymentTypeID = 2 THEN 1
					END AS PaymentType,
					CASE 
						WHEN hrm.PaymentTypeID = 1 THEN 'true'
						Else 'false'
					END AS DirectPayment,
					CASE 
						WHEN hrm.PaymentTypeID = 2 THEN 'true'
						Else 'false'
					END AS BTCCommission,
					hrm.IsActive,
					TotalCountCTE.TotalCount,
					(SELECT CASE WHEN EXISTS (SELECT 1 FROM [RateCards].[Rules] WHERE RateCardID=hrm.HotelrateID) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END) AS HasRules,
					(SELECT TOP 1 CASE WHEN ud.DocumentID IS NOT NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END FROM dbo.LinkedDocuments ld INNER JOIN dbo.UploadDocuments ud ON ld.ParentID = hrm.HotelrateID AND ud.DocumentID = ld.DocumentID AND ud.ParentTypeID = 1) AS HasDocument,
					curr.[Name] AS Currency, hrm.IsCommission,hrm.CurrencyID AS CurrencyID
				FROM RateCards.HotelRateMaster hrm 
				LEFT JOIN [dbo].[HotelMaster] hm ON hrm.HotelID = hm.HotelID
				LEFT JOIN [dbo].[City] c ON c.IATACode = hrm.CityID
				LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = hrm.VendorID
				LEFT JOIN dbo.Currency curr ON hrm.CurrencyID = curr.Code  
				CROSS JOIN TotalCountCTE
				WHERE
					((@CardNumber IS NULL OR @CardNumber = '') OR hrm.CardNumber IN (SELECT CardNumber FROM CardNumberCTE))
					AND ((@Heading IS NULL OR @Heading = '') OR hrm.Heading IN (SELECT Heading FROM HeadingCTE))
					AND ((@RateCardModeTypeID IS NULL OR @RateCardModeTypeID = '') AND hrm.RateCardModeTypeID <> 3
					OR (@RateCardModeTypeID IS NOT NULL AND @RateCardModeTypeID <> '' AND hrm.RateCardModeTypeID IN (SELECT RateCardModeTypeID FROM RateCardModeTypeCTE)))
					AND ((@CityID IS NULL OR @CityID = '') OR c.Name IN (SELECT CityID FROM CityIDCTE))
					AND (
						NOT EXISTS (SELECT 1 FROM @IsActiveTable)  -- No filtering if table is empty
						OR hrm.IsActive IN (SELECT BitValue FROM @IsActiveTable)
					)
					AND ((@HotelID IS NULL OR @HotelID = '') OR hm.HotelName IN (SELECT HotelID FROM HotelIDCTE))
					AND ((@PaymentTypeID IS NULL OR @PaymentTypeID = '') OR hrm.PaymentTypeID  IN (SELECT PaymentType FROM PaymentTypeCTE))
				ORDER BY hrm.HotelRateID DESC
				OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
		END
	IF @Operation = 'GET_RATE_BYID' AND @ID > 0
		BEGIN
			DECLARE @MinDate DATE;
			DECLARE @MaxDate DATE;
			SET NOCOUNT ON;

			SELECT @MinDate = MIN(RateValidFrom), @MaxDate = MAX(RateValidTo)
			FROM RateCards.RateValidityMaster RVM INNER JOIN RateCards.HotelRateDetails HRD ON HRD.HotelRateDetailID = RVM.HotelRateDetailID
			WHERE HRD.HotelRateID = @ID;
			SELECT hrm.HotelRateID,hrm.CardNumber,hrm.ContractDate,hm.HotelName,ISNULL(c.[Name],'') AS City,hrm.CurrencyID,cu.[Name] AS CurrencyName,
			hrm.InfoForRemark AS InfoForRemark,hrm.VendorID,hrm.HotelID,hrm.StateID,hrm.GstStatus,
			hrm.CityID AS CityID,hrm.Heading,hrm.InfoForAgent,hrm.InfoForOperation,hrm.PaymentTypeID,
			hrm.RateCardModeTypeID,hrm.RateTypeID,hrm.ValueAddOn,hrm.IsActive,hrm.IsCommission,
			XO.XoRemarks as RateType,(SELECT STRING_AGG(Rate_Type_Name, ', ') FROM (SELECT DISTINCT RT.Rate_Type_Name FROM RateCards.HotelRatesheetMasterLookup RS INNER JOIN dbo.Rate_Type RT ON RS.RateSheetID = RT.Rate_Type_ID WHERE RS.HotelRateID = @ID) AS DistinctRates) AS RateSheet,
			@MinDate as MinDate,@MaxDate as MaxDate			
			FROM RateCards.HotelRateMaster hrm 
			LEFT JOIN [dbo].[HotelMaster] hm ON hrm.HotelID = hm.HotelID
			INNER JOIN [dbo].[Currency] cu ON cu.Code = hrm.CurrencyID
			LEFT JOIN [dbo].[City] c ON c.IATACode = hrm.CityID
			Left JOIn dbo.XORemarks XO on XO.XOID=hrm.RateTypeID
			WHERE hrm.HotelRateID = @ID ORDER BY hrm.HotelRateID desc

			SELECT ID,MarketRateID FROM RateCards.HotelRateMarketMasterLookup WHERE HotelRateID = @ID AND IsActive = 1;
			SELECT ID,RateSheetID FROM RateCards.HotelRatesheetMasterLookup WHERE HotelRateID = @ID AND IsActive = 1;
			SELECT ID,VoucherTypeID FROM RateCards.HotelRateVoucherTypeLookup WHERE HotelRateID = @ID AND IsActive = 1;
		END
	IF @Operation = 'GET_RATEDETAILS_BYID' AND @ID > 0
		BEGIN
			SET NOCOUNT ON;
<<<<<<< HEAD
<<<<<<< HEAD
			SELECT HRD.HotelRateDetailID,HRD.HotelRateID,HRD.RoomCategoryID,HRD.Days,HRD.FITorGIT,HRD.MealPlanID,HRD.TransferID,
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			SELECT HRD.HotelRateDetailID,HRD.HotelRateID,HRD.RoomCategoryID,HRD.Days,
			CASE WHEN HRD.DAYS = '1111111' THEN 'ALL'
				ELSE
					CONCAT (
					CASE 
						WHEN SUBSTRING(HRD.Days, 1, 1) = '1'
							THEN '1'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(HRD.Days, 2, 1) = '1'
							THEN '2'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(HRD.Days, 3, 1) = '1'
							THEN '3'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(HRD.Days, 4, 1) = '1'
							THEN '4'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(HRD.Days, 5, 1) = '1'
							THEN '5'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(HRD.Days, 6, 1) = '1'
							THEN '6'
						ELSE '-'
						END
					,CASE 
						WHEN SUBSTRING(HRD.Days, 7, 1) = '1'
							THEN '7'
						ELSE '-'
						END
					)
				END AS DaysNumber,
			HRD.FITorGIT,HRD.MealPlanID,HRD.TransferID,
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			  HRD.MinNights,HRD.MaxNights,HRD.RateTypeID,HRD.OfferTypeID,HRD.MISSequence,HRD.IsActive,RC.Name as RoomCategory,TM.TransferValue as TransferValue, 
			  MP.Code as MealPlan,HRD.BusinessType,HRD.TaxID,HRD.FIT,HRD.GIT,
			  -- Commissions
			  (
				SELECT RC.CommisionPercentage as CommissionPercentage, RC.*,RCM.RateType, Rc.CommissionMasterID as MasterCommissionID, RC.RateCommisionID as RateCommissionID
				FROM RateCards.RateCommisionDetails RC left join RateCommissionMaster RCM on RC.CommissionMasterID=RCM.CommMasterID 
				WHERE RC.HotelRateDetailID = HRD.HotelRateDetailID
				FOR JSON PATH
			  ) AS Commissions,
			  -- Validities
			  (
				SELECT RV.* FROM [RateCards].[RateValidityMaster] RV
<<<<<<< HEAD
<<<<<<< HEAD
				WHERE RV.HotelRateDetailID = HRD.HotelRateDetailID
=======
				WHERE RV.HotelRateDetailID = HRD.HotelRateDetailID and RV.IsActive=1
				ORDER BY MONTH(RV.BookFrom) ASC
>>>>>>> dev
=======
				WHERE RV.HotelRateDetailID = HRD.HotelRateDetailID and RV.IsActive=1
				ORDER BY MONTH(RV.BookFrom) ASC
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				FOR JSON PATH
			  ) AS Validities,
			  -- Meals
			  (
				SELECT RM.*, RM.DefineAmount as DefinedAmount FROM [RateCards].[HotelMealOverviewMaster] RM
				WHERE RM.HotelRateDetailID = HRD.HotelRateDetailID
				FOR JSON PATH
			  ) AS Meals,

			  -- OfferConfiguration
			  (
			    SELECT
			      OC.*,
			      (
			        SELECT  OCM.*,OCM.Tax as TaxPercentage
			        FROM [RateCards].[HotelRateOfferConfigurationCommission] OCM
			        WHERE OCM.OfferConfigurationID = OC.OfferID AND (OCM.IsDeleted = 0 OR OCM.IsDeleted IS NULL)
			        FOR JSON PATH
			      ) AS OfferCommission

			    FROM [RateCards].[HotelRateOfferConfiguration] OC
			    WHERE OC.HotelRateDetailID = HRD.HotelRateDetailID AND (OC.IsDeleted = 0 OR OC.IsDeleted IS NULL)
			    FOR JSON PATH
			  ) AS OfferConfiguration

			FROM RateCards.HotelRateDetails HRD left join RoomCategory RC on HRD.RoomCategoryID=RC.ID
			left join TransferMaster TM on TM.TransferID=HRD.TransferID
			left join MealPlan MP on MP.ID=HRD.MealPlanID
<<<<<<< HEAD
<<<<<<< HEAD
			WHERE HRD.HotelRateID = @ID
			order by TRY_CAST(hrd.MISSequence AS INT)
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			-- Add OUTER APPLY to get the earliest BookFrom date
			OUTER APPLY (
				SELECT MIN(RV.RateValidFrom) AS MinBookFromDate
				FROM RateCards.RateValidityMaster RV
				WHERE RV.HotelRateDetailID = HRD.HotelRateDetailID AND RV.IsActive = 1
			) AS ValidityStart
			WHERE HRD.HotelRateID = @ID
			order by HRD.RoomCategoryID,
				ValidityStart.MinBookFromDate, 
			--ValidityStart.MinBookFromDate ASC,
			TRY_CAST(hrd.MISSequence AS INT)
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			FOR JSON PATH;
			--, WITHOUT_ARRAY_WRAPPER;
			--SELECT * FROM RateCards.HotelRateDetails
			--SELECT hrd.HotelRateDetailID,hrd.HotelRateID,hrd.FITORGIT,hrd.RoomCategoryID,hrd.RateTypeID,ISNULL(hrd.TaxID, 0) AS TaxID,
			--(
			--	CASE 
			--		WHEN SUBSTRING(hrd.[Days], 1, 1) = '1' THEN 'M' ELSE '' END +
			--	CASE 
			--		WHEN SUBSTRING(hrd.[Days], 2, 1) = '1' THEN 'T' ELSE '' END +
			--	CASE 
			--		WHEN SUBSTRING(hrd.[Days], 3, 1) = '1' THEN 'W' ELSE '' END +
			--	CASE 
			--		WHEN SUBSTRING(hrd.[Days], 4, 1) = '1' THEN 'T' ELSE '' END +
			--	CASE 
			--		WHEN SUBSTRING(hrd.[Days], 5, 1) = '1' THEN 'F' ELSE '' END +
			--	CASE 
			--		WHEN SUBSTRING(hrd.[Days], 6, 1) = '1' THEN 'S' ELSE '' END +
			--	CASE 
			--		WHEN SUBSTRING(hrd.[Days], 7, 1) = '1' THEN 'S' ELSE '' END) AS [Days],
			--hrd.MealPlanID,mp.[Description] AS MealPlan,hrd.OfferTypeID,hrd.TransferID,tm.TransferValue,hrd.MISSequence,hrd.MinNights,hrd.MaxNights,
			--rt.[NAME] AS RoomCategory,hrd.IsActive
			--FROM RateCards.HotelRateDetails hrd 
			--LEFT JOIN [dbo].[TransferMaster] tm ON tm.TransferID = hrd.TransferID
			--LEFT JOIN [dbo].[MealPlan] mp ON mp.ID = hrd.MealPlanID
			--LEFT JOIN [dbo].RoomCategory rt ON rt.ID = hrd.RoomCategoryID
			--WHERE hrd.IsActive = 1 
			--AND hrd.HotelRateDetailID = @ID
			--ORDER BY hrd.HotelRateDetailID desc
			--OFFSET @Offset ROWS
			--FETCH NEXT @PageSize ROWS ONLY;
		END
	IF @Operation = 'GET_RATEDETAIL_BYID' AND @ID > 0
		BEGIN
			SET NOCOUNT ON;

			SELECT hrd.HotelRateDetailID,hrd.HotelRateID,hrd.RoomCategoryID,hrd.RateTypeID,hrd.TransferID,hrd.IsActive,hrd.MinNights,hrd.MaxNights,
			hrd.OfferTypeID,hrd.MISSequence,hrd.[Days]
			FROM RateCards.HotelRateDetails hrd WHERE HotelRateID = @ID order by TRY_CAST(hrd.MISSequence AS INT);

			SELECT hmom.HotelRateMealID,hmom.HotelRateDetailID,hmom.MealTypeID,hmom.GstAmount,hmom.GstPercentage,hmom.NetAmountIncludingTax,
			hmom.NetAmountExcludingTax,hmom.IsActive
			FROM [RateCards].HotelMealOverviewMaster hmom WHERE HotelRateDetailID = @ID

			SELECT rvm.RateValidityID,rvm.HotelRateDetailID,rvm.BookFrom,rvm.BookTo,rvm.RateValidFrom,rvm.RateValidTo,rvm.IsActive
<<<<<<< HEAD
<<<<<<< HEAD
			FROM RateCards.RateValidityMaster rvm WHERE rvm.HotelRateDetailID = @ID 
=======
			FROM RateCards.RateValidityMaster rvm WHERE rvm.HotelRateDetailID = @ID and rvm.IsActive=1
>>>>>>> dev
=======
			FROM RateCards.RateValidityMaster rvm WHERE rvm.HotelRateDetailID = @ID and rvm.IsActive=1
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

			SELECT rcd.RateCommisionID,rcd.CommissionMasterID,rcd.HotelRateDetailID,rcd.TaxPercentage AS TaxPercentage,rcd.TaxAmount,rcd.GrossAmountIncludingTax,rcd.GrossAmountExcludingTax,
			rcd.CommisionPercentage,rcd.CommissionAmount,rcd.NetAmountIncludingTax,rcd.NetAmountExcludingTax,rcd.IsActive
			FROM RateCards.RateCommisionDetails rcd WHERE rcd.IsActive = 1 AND rcd.HotelRateDetailID = @ID
		END
	IF @Operation = 'GET_RATECARDNO' 
		BEGIN
			select distinct hrm.CardNumber FROM RateCards.HotelRateMaster hrm where CardNumber like '%'+@CardNumber+'%'
		END
	IF @Operation = 'GET_RATECARDHEADER' 
		BEGIN
			select distinct hrm.Heading FROM [RateCards].HotelRateMaster hrm where Heading like '%'+@Heading+'%'
		END
END

