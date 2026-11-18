CREATE PROCEDURE [dbo].[USP_Lock_FileCode_Xo]    
    --@FileCode VARCHAR(50) = NULL, -- commented if unused
    @XOID VARCHAR(50) = NULL,             
<<<<<<< HEAD
<<<<<<< HEAD
    @YearCode INT,      
=======
    @YearCode INT, 
	@BookingID int,
	@YearID INT,
>>>>>>> dev
=======
    @YearCode INT, 
	@BookingID int,
	@YearID INT,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    @Action CHAR(2) = 'S'            
AS           
BEGIN     
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 
        FROM XO x 
<<<<<<< HEAD
<<<<<<< HEAD
        INNER JOIN Quotation q ON x.Qut_ID = q.QuotationID 
=======
        left JOIN Quotation.QuotationMaster q ON x.Qut_ID = q.QuotationID 
>>>>>>> dev
=======
        left JOIN Quotation.QuotationMaster q ON x.Qut_ID = q.QuotationID 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        WHERE x.XO_ID = @XOID AND x.YearCode = @YearCode
        --OR FileCode = @FileCode  -- uncomment if using FileCode
    )  
    BEGIN    
<<<<<<< HEAD
<<<<<<< HEAD
        UPDATE XO 
        SET IsPayment = 1 
        WHERE XO_ID = @XOID AND YearCode = @YearCode;  
=======
        UPDATE Booking.DayWiseBooking 
        SET xolock = 1 
        WHERE BookingID = @BookingID AND @YearID = @YearID;  
>>>>>>> dev
=======
        UPDATE Booking.DayWiseBooking 
        SET xolock = 1 
        WHERE BookingID = @BookingID AND @YearID = @YearID;  
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    END
END
