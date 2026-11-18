--DECLARE
--    @MealTypeID BIGINT = 90,
--    @HotelRateCommissionDetailId BIGINT = 3,
--    @HotelRateID INT = 405539,
--    @CreatedBy UNIQUEIDENTIFIER = NEWID(),
--	@Action Char(1)='I'

CREATE PROCEDURE [Quotation].[usp_InsertHotelRateMealPlanMaster]
	@MealTypeID BIGINT=NULL,
	@QuotationHotelRateID	int ,
	@HotelRateCommissionDetailId BIGINT=NULL,
	@HotelRateID INT =NULL,
	@CreatedBy uniqueidentifier=NULL,
	@Action Char(1)=NULL
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX), @LogID BIGINT;

	IF @Action = 'I'
		BEGIN
			INSERT INTO Quotation.HotelRateMealPlanMaster
			(
				QuotationHotelRateID,
				HotelRateDetailID,
				MealTypeID,
				GstPercentage,
				GstAmount,
				NetAmountIncludingTax,
				NetAmountExcludingTax,
				IsActive,
				CreatedBy,
				CreatedOn,
				MasterCommissionID,
				IsMealDetails,
				DefineAmount
			)
			Select
				--HMM.HotelRateDetailID, --Q
				@QuotationHotelRateID,
				@HotelRateCommissionDetailId,
				HMM.MealTypeID,
				HMM.GstPercentage,
				HMM.GstAmount,
				HMM.NetAmountIncludingTax,
				HMM.NetAmountExcludingTax,
				HMM.IsActive,
				@CreatedBy,
				GETDATE(),
				HMM.MasterCommissionID,
				HMM.IsMealDetails,
				HMM.DefineAmount
			From
				RateCards.HotelMealOverviewMaster HMM
				LEFT OUTER JOIN RateCards.HotelRateDetails HRD ON HMM.HotelRateDetailID=HRD.HotelRateDetailID
				LEFT OUTER JOIN RateCards.HotelRateMaster HRM ON HRD.HotelRateID=HRM.HotelRateID
			WHERE 
				HRM.HotelRateID=@HotelRateID  --Q

				
			SET @LogID = SCOPE_IDENTITY();
			SET @ReturnCode = '200';
			SET @ReturnMessage = 'Record inserted successfully';

		END
END
