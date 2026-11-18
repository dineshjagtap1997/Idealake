--declare
CREATE PROCEDURE [Quotation].[usp_InsertHotelRateCardMaster]
	@HotelRateID BIGINT=NULL,
	@QuotationID BIGINT=NULL,
	@Disclaimer NVARCHAR(255)=NULL,
	@Action Char(1)=NULL
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX), @LogID BIGINT,@QuotationHotelRateID INT, @CurrencyID INT;
	Declare @CurrencyName NVARCHAR(50);

	SET @CurrencyName=(SELECT TOP 1 CurrencyID FROM RateCards.HotelRateMaster WHERE HotelRateID=@HotelRateID)

	
	SET @CurrencyID=(select top 1 CurrencyID from Currency where Code=@CurrencyName)

	IF @Action = 'I'
		BEGIN

			IF NOT EXISTS (
				SELECT 1
				FROM Quotation.HotelRateCardMaster
				WHERE HotelRateID = @HotelRateID AND QuotationID = @QuotationID
			)
			BEGIN
				INSERT INTO Quotation.HotelRateCardMaster (
					HotelRateID,
					HotelID,
					CardNumber,
					ContractDate,
					Days,
					RoomCategoryID,
					MealPlanID,
					CurrencyID,
					CurrencyName,
					InfoForRemark,
					StateID,
					GstStatus,
					CityID,
					Heading,
					InfoForAgent,
					InfoForOperation,
					PaymentTypeID,
					RateCardModeTypeID,
					RateTypeID,
					ValueAddOn,
					IsActive,
					QuotationID,
					Disclaimer
				)
				Select
					Distinct
					@HotelRateID,
					HRM.HotelID,
					HRM.CardNumber,
					HRM.ContractDate,
					HRD.Days,
					HRD.RoomCategoryID,
					HRD.MealPlanID,
					@CurrencyID,
					@CurrencyName,
					HRM.InfoForRemark,
					HRM.StateID,
					HRM.GstStatus,
					HRM.CityID,
					HRM.Heading,
					HRM.InfoForAgent,
					HRM.InfoForOperation,
					HRM.PaymentTypeID,
					HRM.RateCardModeTypeID,
					HRM.RateTypeID,
					HRM.ValueAddOn,
					HRM.IsActive,
					@QuotationID,
					@Disclaimer
				From
					RateCards.HotelRateMaster HRM
					LEFT OUTER JOIN RateCards.HotelRateDetails HRD ON HRM.HotelRateID=HRD.HotelRateID

				set @QuotationHotelRateID=SCOPE_IDENTITY();

				SET @LogID = @QuotationHotelrateID
				SET @ReturnCode = '200';
				SET @ReturnMessage = 'Record Inserted Successfully';

				SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID AS ID;
			END
			ELSE
			BEGIN
				SET @ReturnCode = '409';
				SET @ReturnMessage = 'Record Already Exist';
				SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;
			END
		END
END;
