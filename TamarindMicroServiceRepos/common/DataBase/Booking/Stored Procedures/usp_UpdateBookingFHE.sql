--declare
CREATE procedure [Booking].[usp_UpdateBookingFHE]
	@BookingID int=0,
	@FHE uniqueidentifier=NULL,
	@UserID uniqueidentifier=NULL,
	@Action char(2)=null
AS
BEGIN
	if(@Action='U')
		BEGIN
			UPDATE Booking.tbl_Booking 
			SET
				FHE=@FHE,
				ModifiedBy=@UserID,
				ModifiedOn=GETDATE()
			WHERE
				ID=@BookingID

			SELECT 
				'200' as returnCode,
				'Resigned Successfully' as returnMessage
		END
END