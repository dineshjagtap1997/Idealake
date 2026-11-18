<<<<<<< HEAD
<<<<<<< HEAD
﻿--declare
--  @Action VARCHAR(50) = 'FFHE',
--  @Filter varchar(50) = 'dya'
CREATE PROCEDURE [dbo].[usp_AutoCompleteSearch] 
  @Action VARCHAR(50) = 'FQS',
  @Filter varchar(50) = ''
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿
CREATE PROCEDURE [dbo].[usp_AutoCompleteSearch] 
  @Action VARCHAR(50) = 'FB',
  @Filter varchar(50) = 'BTAM26000128'
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
AS                
BEGIN                
 DECLARE @ReturnCode NVARCHAR(3)                
  ,@ReturnMessage NVARCHAR(MAX)                
  ,@logStatus BIT;                
                
 IF @Action = 'FB'                
 BEGIN   
<<<<<<< HEAD
<<<<<<< HEAD
		Select 
		B.ID as ID,
=======
		Select Distinct
		null as ID,
>>>>>>> dev
=======
		Select Distinct
		null as ID,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		 (CASE 
            WHEN B.Status = 1 THEN CONCAT('D-', B.BookingID)
            WHEN B.Status = 0 THEN B.BookingID
            ELSE B.BookingID
        END) AS Name,
		B.Status
		from Booking.tbl_Booking B
		 where (    
    @Filter IS NULL                
    OR @Filter = ''                
    OR EXISTS (                
     SELECT 1                
     FROM STRING_SPLIT(@Filter, ',') s                
     WHERE  (CASE 
            WHEN B.Status = 1 THEN CONCAT('D-', B.BookingID)
            WHEN B.Status = 0 THEN B.BookingID
            ELSE B.BookingID
        END) LIKE '%' + s.value + '%'                
     )                
    )         
 END      
<<<<<<< HEAD
<<<<<<< HEAD
 IF @Action = 'FQ'                
=======
 ELSE IF @Action = 'FQ'                
>>>>>>> dev
=======
 ELSE IF @Action = 'FQ'                
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 BEGIN   
		Select 
		QuotationID as ID,
		QuotationNo as Name,
		Status
		from Quotation.QuotationMaster 
		where (    
			 @Filter IS NULL OR @Filter = '' OR EXISTS (                
     SELECT 1                
     FROM STRING_SPLIT(@Filter, ',') s                
     WHERE Upper(QuotationNo) LIKE '%' + Upper(s.value) + '%'                 
     )                
    )          
 END 
   
<<<<<<< HEAD
<<<<<<< HEAD
 IF @Action = 'FG'                
=======
 ELSE IF @Action = 'FG'                
>>>>>>> dev
=======
 ELSE IF @Action = 'FG'                
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 BEGIN   
		Select 
		GuestName as Name
		from Booking.tbl_Booking 
		where (    
			 @Filter IS NULL OR @Filter = '' OR EXISTS (                
     SELECT 1                
     FROM STRING_SPLIT(@Filter, ',') s                
     WHERE Upper(GuestName) LIKE '%' + Upper(s.value) + '%'                 
     )    and Status in (2,3)             
    )          
 END 
 
<<<<<<< HEAD
<<<<<<< HEAD
 IF @Action = 'FFHE'                
=======
 ELSE IF @Action = 'FFHE'                
>>>>>>> dev
=======
 ELSE IF @Action = 'FFHE'                
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 BEGIN   
		Select 
		distinct
		EmpName as Name,
		b.FHE as UNIQUEID
		from Booking.tbl_Booking b
		inner join EmployeeMaster em on em.UserID=b.FHE
		where (    
			 @Filter IS NULL OR @Filter = '' OR EXISTS (                
     SELECT 1                
     FROM STRING_SPLIT(@Filter, ',') s                
     WHERE Upper(EmpName) LIKE '%' + Upper(s.value) + '%'                 
     )                
    )       
	
 END 
 
<<<<<<< HEAD
<<<<<<< HEAD
 IF @Action = 'FQS'                
=======
 ELSE IF @Action = 'FQS'                
>>>>>>> dev
=======
 ELSE IF @Action = 'FQS'                
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 BEGIN   
		Select 
		b.StatusCode as ID,
		b.StatusName as Name,
		b.ColourCode as ColorCode
		from Booking.BookingStatus b
		where (    
			 @Filter IS NULL OR @Filter = '' OR EXISTS (                
     SELECT 1                
     FROM STRING_SPLIT(@Filter, ',') s                
     WHERE Upper(StatusName) LIKE '%' + Upper(s.value) + '%'                 
     )                
    )          
 END 

 
 
<<<<<<< HEAD
<<<<<<< HEAD
 IF @Action = 'FXO'                
=======
 ELSE IF @Action = 'FXO'                
>>>>>>> dev
=======
 ELSE IF @Action = 'FXO'                
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 BEGIN   
		Select 
		b.Xonumber as Name
		from XO b
		where (    
			 @Filter IS NULL OR @Filter = '' OR EXISTS (                
     SELECT 1                
     FROM STRING_SPLIT(@Filter, ',') s                
     WHERE Upper(Xonumber) LIKE '%' + Upper(s.value) + '%'                 
     )                
    )          
 END 
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

 ELSE IF @Action = 'FE'                
	 BEGIN   
			Select 
				E.EQID as ID,
				E.EnquiryID as Name  
			from 
				tbl_Enquiry E  
			where (    
						@Filter IS NULL OR @Filter = '' OR EXISTS (                
						 SELECT 1                
						 FROM STRING_SPLIT(@Filter, ',') s                
						 WHERE Upper(EnquiryID) LIKE '%' + Upper(s.value) + '%'                 
					 )                
				)          
	 END 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END