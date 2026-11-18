CREATE PROCEDURE [XO].[USP_Lock_FileCode_Xo]    
    --@FileCode VARCHAR(50) = NULL, -- commented if unused
    @XOID VARCHAR(50) = NULL,             
    @BookingID BIGINT,
	@YearID INT
   -- @Action CHAR(2) = 'S'            
AS           
BEGIN     
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 
        FROM XO x 
        left JOIN Quotation.QuotationMaster q ON x.Qut_ID = q.QuotationID 
        WHERE x.XO_ID = @XOID AND x.YearCode = @YearID
        --OR FileCode = @FileCode  -- uncomment if using FileCode
    )  
    BEGIN    
        UPDATE Booking.DayWiseBooking 
        SET xolock = 0 
        WHERE BookingID = @BookingID AND @YearID = @YearID;  


		UPDATE t1
        SET t1.IsLock = 0
        FROM Booking.DayWiseBooking t1
        JOIN dbo.XO t2 ON t1.GroupKey = t2.GroupKey
            AND t1.BookingID = t2.Qut_ID
            AND t2.XO_ID = @XOID;

		Update BB set BB.LOCK=0 FROM Booking.tbl_booking BB
		inner join Booking.DayWiseBooking  BD on BD.BookingID=BB.ID
		inner JOIN dbo.XO t2 ON BD.GroupKey = t2.GroupKey           
		where ISNULL(BD.IsLock,0)=0 AND t2.XO_ID = @XOID
		 
		 SELECT '200' AS returnCode                
    ,'XO LOCKED SUCCESSFULLY.' AS returnMessage;         
    END
END
