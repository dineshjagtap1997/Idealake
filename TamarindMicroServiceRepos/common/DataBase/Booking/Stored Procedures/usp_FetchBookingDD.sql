CREATE PROCEDURE [Booking].[usp_FetchBookingDD]
   @Action CHAR(1)-- 'I', 'U', 'S', or 'SA'
AS
begin
	IF(@Action='S')
	BEGIN
		SELECT 
			B.ID as BookingID,
			B.QuotationID,
			CASE 
			    WHEN B.Status = 1 THEN CONCAT('D-', B.BookingID)
			    ELSE B.BookingID
			END AS BookingNo,
			Q.QuotationNo
			
		FROM 
			[Booking].[tbl_Booking] B
			INNER JOIN [Booking].[BookingStatus] BS ON B.Status = BS.StatusCode
			INNER JOIN [Quotation].[QuotationMaster] Q ON B.QuotationID = Q.QuotationID
		where 
			isnull(B.Status,0)<>0
	END
end
