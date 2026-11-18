<<<<<<< HEAD
<<<<<<< HEAD
﻿
--DECLARE @Action CHAR(1) = 'I';
--DECLARE @HotelRateID BIGINT = 2;
--DECLARE @HotelRateDetailID BIGINT=2;
--DECLARE @QuotationID BIGINT = 41;
--DECLARE @Disclaimer NVARCHAR(255) = 'This is a sample disclaimer.';
--DECLARE @CreatedBy UNIQUEIDENTIFIER = '9d3b0e45-1234-4abc-bdef-87654321abcd';
--DECLARE @CheckIn DATETIME = '2025-07-01T12:00:00';
--DECLARE @CheckOut DATETIME = '2025-07-02T10:00:00';
---- Declare table-valued parameters
--DECLARE @CommissionList dbo.HotelCommissionTableType;
--DECLARE @MealList dbo.HotelMealPlanTableType;
--DECLARE @QuoHotelRateID BIGINT = NULL;
--DECLARE @OthersRateCardCommissionID BIGINT = NULL;
--DECLARE @OthersRateCardMealID BIGINT = NULL;
--DECLARE @IsSummary BIT = 0;
--DECLARE @OfferInclueded BIT=1;
---- Populate @CommissionList
--INSERT INTO @CommissionList (CommissionMasterID, CommMstId,GrossRate, IsMarkup, MarkupValue, SellingRate, ReasonMasterId,Disclaimer)
--VALUES 
--    (77,1, 9563.00, 0, 852, 252.00, 2,'abc'),
--    (78,2, 752.00, 1, 5425, 25.00, 1,'test2'),
--	(79,3, 965.00, 0, 2482, 245.00, 4,'test3');
---- Populate @MealList
--INSERT INTO @MealList (MealTypeID, SellingRate, ReasonMasterId,Disclaimer)
--VALUES
--    (294, 952.00, 6,'test1'),
--	(295, 569.00, 9,'test2'),
--    (296, 669.00, 7,'test3');


CREATE PROCEDURE [Quotation].[usp_InsertHotelRateCardCommissionMealBackUp] @Action CHAR(1) = NULL
=======
﻿create PROCEDURE [Quotation].[usp_InsertHotelRateCardCommissionMealBackUp] @Action CHAR(1) = NULL
>>>>>>> dev
=======
﻿create PROCEDURE [Quotation].[usp_InsertHotelRateCardCommissionMealBackUp] @Action CHAR(1) = NULL
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	,@HotelRateID BIGINT = NULL
	,@HotelRateDetailID BIGINT = NULL
	,@QuotationID BIGINT = NULL
	,@Disclaimer NVARCHAR(255) = NULL
	,@CheckIn DATETIME = NULL
	,@CheckOut DATETIME = NULL
	,@CreatedBy UNIQUEIDENTIFIER = NULL
	,@CommissionList [dbo].[HotelCommissionTableType] READONLY
	,@MealList [dbo].[HotelMealPlanTableType] READONLY
	,@QuoHotelRateID BIGINT = NULL
	,@OthersRateCardCommissionID BIGINT = NULL
	,@OthersRateCardMealID BIGINT = NULL
	,@IsSummary BIT = 0
	,@offerIncluded BIT=0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @IsCustom BIT = CASE 
			WHEN @HotelRateDetailID = 0
				THEN 1
			ELSE 0
			END;
	DECLARE @ReturnCode NVARCHAR(3) = ''
		,@ReturnMessage NVARCHAR(MAX) = ''
		,@LogID BIGINT = 0
		,@QuotationHotelRateID INT = 0
		,@CurrencyID INT = 0;
	DECLARE @CurrencyName NVARCHAR(50) = '';

	--SET @CurrencyName=(SELECT TOP 1 CurrencyID FROM RateCards.HotelRateMaster WHERE HotelRateID=@HotelRateID)
	--SET @CurrencyID=(select top 1 CurrencyID from Currency where Code=@CurrencyName)
	IF @Action = 'I'
	BEGIN
		INSERT INTO Quotation.HotelRateCardMaster (
			HotelRateID
			,HotelRateDetailID
			,HotelID
			,CardNumber
			,ContractDate
			,Days
			,RoomCategoryID
			,MealPlanID
			,CurrencyID
			,InfoForRemark
			,StateID
			,GstStatus
			,CityID
			,Heading
			,InfoForAgent
			,InfoForOperation
			,PaymentTypeID
			,RateCardModeTypeID
			,RateTypeID
			,ValueAddOn
			,IsActive
			,QuotationID
			,Disclaimer
			,CheckIn
			,CheckOut
			,IsCustom
			,IsSummary
			,OfferTypeID
			)
		SELECT DISTINCT @HotelRateID
			,@HotelRateDetailID
			,HRM.HotelID
			,HRM.CardNumber
			,HRM.ContractDate
			,HRD.Days
			,HRD.RoomCategoryID
			,HRD.MealPlanID
			,HRM.CurrencyId
			,HRM.InfoForRemark
			,HRM.StateID
			,HRM.GstStatus
			,HRM.CityID
			,HRM.Heading
			,HRM.InfoForAgent
			,HRM.InfoForOperation
			,HRM.PaymentTypeID
			,HRM.RateCardModeTypeID
			,HRM.RateTypeID
			,HRM.ValueAddOn
			,HRD.IsActive
			,@QuotationID
			,@Disclaimer
			,@CheckIn
			,@CheckOut
			,@IsCustom
			,@IsSummary
			,CASE
				WHEN @offerIncluded=1 THEN HRD.OfferTypeID
			ELSE
				0
			END
		FROM RateCards.HotelRateDetails HRD
		LEFT JOIN RateCards.HotelRateMaster HRM ON HRD.HotelRateID = HRM.HotelRateID
		WHERE @IsCustom = 0
			AND HRD.HotelRateDetailID = @HotelRateDetailID
			AND HRM.HotelRateID = @HotelRateID
			AND HRD.IsActive = 1
		
		UNION ALL
		
		SELECT DISTINCT @HotelRateID
			,@HotelRateDetailID
			,CHRM.HotelID
			,''
			,NULL
			,''
			,CHRM.RoomCategoryID
			,CHRM.MealPlanID
			,CHRM.CurrencyID
			,''
			,0
			,''
			,CHRM.CityID
			,''
			,''
			,''
			,CHRM.PaymentTypeID
			,0
			,0
			,''
			,CHRM.IsActive
			,@QuotationID
			,@Disclaimer
			,@CheckIn
			,@CheckOut
			,@IsCustom
			,@IsSummary
			,0
		FROM CustomRateCards.HotelRateMaster CHRM
		WHERE @IsCustom = 1
			AND CHRM.HotelRateID = @HotelRateID;

		SET @QuotationHotelRateID = SCOPE_IDENTITY();

		INSERT INTO Quotation.HotelRateCommissionDetails (
			QuotationHotelRateID
			,RateCommisionID
			,CommissionMasterID
			,GrossRate
			,TaxPercentage
			,TaxAmount
			,GrossAmountIncludingTax
			,GrossAmountExcludingTax
			,CommisionPercentage
			,IsMarkup
			,MarkupValue
			,SellingRate
			,ReasonMasterId
			,CreatedOn
			,CreatedBy
			,IsActive
			,HotelRateID
			,HotelRateDetailID
			,QuotationID
			,NetAmountIncludingTax
			,NetAmountExcludingTax
			,Disclaimer
			,CommissionAmount
			)
		SELECT @QuotationHotelRateID
			,ISNULL(CL.CommissionMasterID, 0)
			,ISNULL(RCD.CommissionMasterID, 0)
			,ISNULL(CL.GrossRate, 0)
			,ISNULL(RCD.TaxPercentage, 0)
			,ISNULL(RCD.TaxAmount, 0)
			,ISNULL(RCD.GrossAmountIncludingTax, 0)
			,ISNULL(RCD.GrossAmountExcludingTax, 0)
			,ISNULL(RCD.CommisionPercentage, 0)
			,ISNULL(CL.IsMarkup, 0)
			,ISNULL(CL.MarkupValue, 0)
			,ISNULL(CL.SellingRate, 0)
			,ISNULL(CL.ReasonMasterId, 0)
			,GETDATE()
			,@CreatedBy
			,ISNULL(RCD.IsActive, 0)
			,@HotelRateID
			,@HotelRateDetailID
			,@QuotationID
			,RCD.NetAmountIncludingTax
			,RCD.NetAmountExcludingTax
			,CL.Disclaimer
			,RCD.CommissionAmount
		FROM @CommissionList AS CL
		LEFT JOIN RateCards.RateCommisionDetails RCD ON RCD.RateCommisionID = CL.CommissionMasterID
		LEFT JOIN RateCards.HotelRateDetails HRD ON RCD.HotelRateDetailID = HRD.HotelRateDetailID
			AND HRD.HotelRateDetailID = @HotelRateDetailID
		LEFT JOIN RateCards.HotelRateMaster HRM ON HRD.HotelRateID = HRM.HotelRateID
			AND HRM.HotelRateID = @HotelRateID
		WHERE @IsCustom = 0
		
		UNION ALL
		
		SELECT @QuotationHotelRateID
			,ISNULL(CL.CommissionMasterID, 0)
			,ISNULL(RC.CommissionMasterID, 0)
			,ISNULL(CL.GrossRate, 0)
			,ISNULL(RC.TaxPercentage, 0)
			,ISNULL(RC.TaxAmount, 0)
			,ISNULL(RC.GrossAmountIncludingTax, 0)
			,ISNULL(RC.GrossAmountExcludingTax, 0)
			,ISNULL(RC.CommisionPercentage, 0)
			,ISNULL(CL.IsMarkup, 0)
			,ISNULL(CL.MarkupValue, 0)
			,ISNULL(CL.SellingRate, 0)
			,ISNULL(CL.ReasonMasterId, 0)
			,GETDATE()
			,@CreatedBy
			,ISNULL(RC.IsActive, 0)
			,@HotelRateID
			,@HotelRateDetailID
			,@QuotationID
			,RC.NetAmountIncludingTax
			,RC.NetAmountExcludingTax
			,CL.Disclaimer
			,CommissionAmount
		FROM @CommissionList CL
		LEFT JOIN CustomRateCards.HotelRateCommisionDetails RC ON CL.CommissionMasterID = RC.RateCommisionID
		LEFT JOIN CustomRateCards.HotelRateMaster CHRM ON RC.HotelRateID = CHRM.HotelRateID
		WHERE @IsCustom = 1;

		INSERT INTO Quotation.HotelRateMealPlanMaster (
			QuotationHotelRateID
			,MealTypeID
			,GstPercentage
			,GstAmount
			,NetAmountIncludingTax
			,NetAmountExcludingTax
			,IsActive
			,CreatedBy
			,CreatedOn
			,MasterCommissionID
			,IsMealDetails
			,DefineAmount
			,SellingRate
			,ReasonMasterId
			,HotelRateID
			,HotelRateDetailID
			,QuotationID
			,Disclaimer
			)
		SELECT @QuotationHotelRateID
			,ML.MealTypeID
			,HMM.GstPercentage
			,HMM.GstAmount
			,HMM.NetAmountIncludingTax
			,HMM.NetAmountExcludingTax
			,HMM.IsActive
			,@CreatedBy
			,GETDATE()
			,HMM.MasterCommissionID
			,HMM.IsMealDetails
			,HMM.DefineAmount
			,ML.SellingRate
			,ML.ReasonMasterId
			,@HotelRateID
			,@HotelRateDetailID
			,@QuotationID
			,ML.Disclaimer
		FROM RateCards.HotelMealOverviewMaster HMM
		LEFT JOIN RateCards.HotelRateDetails HRD ON HMM.HotelRateDetailID = HRD.HotelRateDetailID
		LEFT JOIN RateCards.HotelRateMaster HRM ON HRD.HotelRateID = HRM.HotelRateID
		INNER JOIN @MealList AS ML ON HMM.HotelRateMealID = ML.MealTypeID
		WHERE @IsCustom = 0
			AND HRD.HotelRateDetailID = @HotelRateDetailID
			AND HRM.HotelRateID = @HotelRateID
			AND HMM.IsActive = 1
		
		UNION ALL
		
		SELECT @QuotationHotelRateID
			,ML.MealTypeID
			,HRM.GstPercentage
			,HRM.GstAmount
			,HRM.NetAmountIncludingTax
			,HRM.NetAmountExcludingTax
			,HRM.IsActive
			,@CreatedBy
			,GETDATE()
			,HRM.MasterCommissionID
			,HRM.IsMealDetails
			,HRM.DefineAmount
			,ML.SellingRate
			,ML.ReasonMasterId
			,@HotelRateID
			,@HotelRateDetailID
			,@QuotationID
			,ML.Disclaimer
		FROM CustomRateCards.HotelRateMealOverview HRM
		LEFT JOIN CustomRateCards.HotelRateMaster CHRM ON HRM.HotelRateID = CHRM.HotelRateID
		INNER JOIN @MealList ML ON HRM.HotelRateMealID = ML.MealTypeID
		WHERE @IsCustom = 1
			AND CHRM.HotelRateID = @HotelRateID
			AND HRM.IsActive = 1;

		IF (isnull(@offerIncluded,0) = 1)
			BEGIN
				IF EXISTS (
					SELECT 1
					FROM RateCards.HotelRateDetails HRD
					WHERE 
						@IsCustom = 0 AND
						HRD.HotelRateDetailID = @HotelRateDetailID AND
						HRD.IsActive = 1 AND
						HRD.OfferTypeID IN (1, 2)
				)
				BEGIN
					-- Insert Offer Configuration if it exists
					IF EXISTS (
						SELECT 1
						FROM RateCards.HotelRateOfferConfiguration
						WHERE HotelRateDetailID = @HotelRateDetailID
					)
					BEGIN
						INSERT INTO [Quotation].[HotelRateOfferConfiguration]
						(
							HotelRateDetailID,
							Days,
							FromDate,
							ToDate,
							TotalNights,
							PaidNights,
							FreeNights,
							IsExtendible,
							IsActive,
							IsDeleted,
							QuotationHotelRateID
						)
						SELECT
							HotelRateDetailID,
							Days,
							FromDate,
							ToDate,
							TotalNights,
							PaidNights,
							FreeNights,
							IsExtendible,
							IsActive,
							IsDeleted,
							@QuotationHotelRateID
						FROM RateCards.HotelRateOfferConfiguration
						WHERE HotelRateDetailID = @HotelRateDetailID
					END

					-- Insert Offer Configuration Commission if it exists
					IF EXISTS (
						SELECT 1
						FROM RateCards.HotelRateOfferConfigurationCommission
						WHERE OfferConfigurationID IN (
							SELECT OfferID
							FROM RateCards.HotelRateOfferConfiguration
							WHERE HotelRateDetailID = @HotelRateDetailID
						)
					)
					BEGIN
						INSERT INTO [Quotation].[HotelRateOfferConfigurationCommission]
						(
							OfferConfigurationID,
							MasterCommissionID,
							Discount,
							DiscountAmount,
							Tax,
							TaxAmount,
							PaidNightAmountExcludingTax,
							PaidNightAmountIncludingTax,
							FreeNightAmountExcludingTax,
							FreeNightAmountIncludingTax,
							GrossAmountExcludingTax,
							GrossAmountIncludingTax,
							NetAmountExcludingTax,
							NetAmountIncludingTax,
							IsActive,
							IsDeleted,
							QuotationHotelRateID
						)
						SELECT
							OfferConfigurationID,
							MasterCommissionID,
							Discount,
							DiscountAmount,
							Tax,
							TaxAmount,
							PaidNightAmountExcludingTax,
							PaidNightAmountIncludingTax,
							FreeNightAmountExcludingTax,
							FreeNightAmountIncludingTax,
							GrossAmountExcludingTax,
							GrossAmountIncludingTax,
							NetAmountExcludingTax,
							NetAmountIncludingTax,
							IsActive,
							IsDeleted,
							@QuotationHotelRateID
						FROM RateCards.HotelRateOfferConfigurationCommission
						WHERE OfferConfigurationID IN (
							SELECT OfferID
							FROM RateCards.HotelRateOfferConfiguration
							WHERE HotelRateDetailID = @HotelRateDetailID
						)
					END
				END
			END

		SET @LogID = @QuotationHotelrateID
		SET @ReturnCode = '200';
		SET @ReturnMessage = 'Record Inserted Successfully';

		SELECT @ReturnCode AS returnCode
			,@ReturnMessage AS returnMessage
			,@LogID AS ID;
	END
	ELSE IF @Action = 'U'
	BEGIN
		UPDATE QHRM
		SET QHRM.Disclaimer = ISNULL(@Disclaimer, QHRM.Disclaimer)
			,QHRM.IsCustom = @IsCustom
			,QHRM.IsSummary = @IsSummary
		FROM Quotation.HotelRateCardMaster QHRM
		WHERE ID = @QuoHotelRateID;

		UPDATE QHCD
		SET RateCommisionID = ISNULL(CL.CommissionMasterID, 0)
			,IsGrossRateModified = CASE 
				WHEN CL.GrossRate <> ISNULL(QHCD.GrossRate, 0)
					THEN 1
				ELSE 0
				END
			,ModifiedGrossRate = CASE 
				WHEN CL.GrossRate <> ISNULL(QHCD.GrossRate, 0)
					THEN CL.GrossRate
				ELSE QHCD.ModifiedGrossRate
				END
			,IsMarkup = ISNULL(CL.IsMarkup, 0)
			,MarkupValue = ISNULL(CL.MarkupValue, 0)
			,SellingRate = ISNULL(CL.SellingRate, 0)
			,ReasonMasterId = ISNULL(CL.ReasonMasterId, 0)
			,Disclaimer = ISNULL(CL.Disclaimer, '')
			,UpdatedOn = GETDATE()
			,UpdatedBy = @CreatedBy
		FROM Quotation.HotelRateCommissionDetails QHCD
		INNER JOIN @CommissionList AS CL ON QHCD.QuotationHotelRateCommissionId = CL.OthersRateCardCommissionID
		WHERE QHCD.QuotationHotelRateID = @QuoHotelRateID;

		UPDATE QHRM
		SET MealTypeID = ML.MealTypeID
			,SellingRate = ML.SellingRate
			,ReasonMasterId = ML.ReasonMasterId
			,Disclaimer = ISNULL(ML.Disclaimer, '')
		FROM Quotation.HotelRateMealPlanMaster QHRM
		INNER JOIN @MealList AS ML ON QHRM.QuotationHotelRateMealId = ML.OthersRateCardMealID
		WHERE QHRM.QuotationHotelRateID = @QuoHotelRateID;

		SET @LogID = @QuotationHotelrateID
		SET @ReturnCode = '200';
		SET @ReturnMessage = 'Record Updated Successfully';

		SELECT @ReturnCode AS returnCode
			,@ReturnMessage AS returnMessage
			,@LogID AS ID;
	END
END;