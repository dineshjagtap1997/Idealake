
CREATE Procedure [Booking].[ConvertCommissionRateTonegotiateRate]
    @dwID INT = NULL,
	@RateCardID INT = NULL
AS
BEGIN 
	IF(ISNULL(@dwID,0)<>0)
		BEGIN
			DECLARE @RateTypeID INT,@value INT;
				SELECT @RateTypeID = RateTypeID,@value = CASE WHEN RateTypeID = 5 THEN BHRMID ELSE BORMID END
				FROM Booking.DayWiseBooking WHERE ID = @dwID;
				IF @RateTypeID = 5
				BEGIN
					UPDATE Booking.HotelRateCardMasterBooking SET IsCustom = 2 WHERE ID = @value
				END
				ELSE
				BEGIN
					Update [Booking].[OthersRateCardMasterBooking] SET IsCustom = 2 WHERE ID = @value
				END
			SELECT '200' AS returnCode, 'Record Updated successfully.' AS returnMessage, @dwID AS ID; 			
		END
END