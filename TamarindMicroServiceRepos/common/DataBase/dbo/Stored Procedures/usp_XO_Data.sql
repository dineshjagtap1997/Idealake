<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_XO_Data]                          
(                          
 @FILEID VARCHAR(50) = '',       
 @YearCode INT = 0,      
 @CompCode INT = 0 )     
AS           
BEGIN              
    SELECT 
        X.XO_ID, 
        HM.HotelName, 
        VM.VendorName, 
        C.Code,                
        X.Xo_Amt AS [XoAmount],
        ISNULL(CONVERT(VARCHAR(10), X.XO_Date, 103), '') AS XODate,
        CONVERT(VARCHAR(10), X.UndoDate, 103) AS XOUndoDate,  
        Q.QuotationID, 
        Q.filecode AS FILEID,      
        CASE 
            WHEN X.ISDIRECTPAYMENT = 1 THEN 'True'       
            WHEN X.ISDIRECTPAYMENT = 0 THEN 'False' 
        END AS ISDIRECTPAYMENT      
    FROM XO X   
	LEFT JOIN Booking.DayWiseBooking DWB ON DWB.GroupKey=X.GroupKey and DWB.BookingID=X.Qut_ID
	LEFT JOIN Booking.tbl_Booking Q ON Q.ID=DWB.BookingID And Q.ID=X.Qut_ID
    -- LEFT JOIN Quotation Q ON X.Qut_ID = Q.QuotationID AND X.YearCode = Q.YearID       
    LEFT JOIN HotelMaster HM ON X.HotelCode = HM.HotelCode       
    LEFT JOIN VendorMaster VM ON X.VendorCode = VM.VendorCode      
    LEFT JOIN CURRENCY C ON LEFT(X.Curr_ID, 3) = C.CODE      
    WHERE 
        (Q.filecode = @FILEID  OR @FILEID IS NULL OR @FILEID = '')  
        AND (Q.ComPanyID = @CompCode OR @CompCode IS NULL OR @CompCode = 0)   
        AND (X.YearCode = @YearCode OR @YearCode IS NULL OR @YearCode = 0)
        AND X.UndoDate IS NOT NULL 
    ORDER BY X.XO_ID ASC       
 
    SELECT '200' AS returnCode, 'Data Retrieved Successfully.' AS returnMessage
END
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿CREATE PROCEDURE [dbo].[usp_XO_Data]                            
(                            
 @FILEID VARCHAR(50) = '',         
 @YearCode INT = 0,        
 @CompCode INT = 0 )       
AS             
BEGIN                
    SELECT   
        X.XO_ID,   
		HM.HotelName,   
        VM.VendorName,   
        C.Code,                  
        X.Xo_Amt AS [XoAmount],  
        ISNULL(CONVERT(VARCHAR(10), X.XO_Date, 103), '') AS XODate,  
        CONVERT(VARCHAR(10), X.UndoDate, 103) AS XOUndoDate,    
       tb.QuotationID,   
        TB.filecode AS FILEID,        
        CASE   
            WHEN X.ISDIRECTPAYMENT = 1 THEN 'True'         
            WHEN X.ISDIRECTPAYMENT = 0 THEN 'False'   
        END AS ISDIRECTPAYMENT ,
		Q.ComPanyID,
		X.YearCode
    FROM XO X     
 INNER JOIN Booking.DayWiseBooking DWB ON DWB.GroupKey = X.GroupKey 
 INNER JOIN Booking.tbl_Booking TB ON TB.ID=DWB.BookingID 
 INNER JOIN Quotation.QuotationMaster Q ON X.Qut_ID = Q.QuotationID --AND X.YearCode = Q.YearID         
 LEFT JOIN HotelMaster HM ON X.HotelCode = HM.HotelCode         
 LEFT JOIN VendorMaster VM ON X.VendorCode = VM.VendorCode        
 LEFT JOIN CURRENCY C ON LEFT(X.Curr_ID, 3) = C.CODE     
    WHERE   
        (TB.filecode = @FILEID  OR @FILEID IS NULL OR @FILEID = '')    
       -- AND (Q.ComPanyID = @CompCode OR @CompCode IS NULL OR @CompCode = 0)     
       -- AND (X.YearCode = @YearCode OR @YearCode IS NULL OR @YearCode = 0)  
        AND X.UndoDate IS NOT NULL   
    ORDER BY X.XO_ID ASC         
   
    SELECT '200' AS returnCode, 'Data Retrieved Successfully.' AS returnMessage  
<<<<<<< HEAD
END  
>>>>>>> dev
=======
END  
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
