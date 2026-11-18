


CREATE PROCEDURE [Invoice].[usp_FetchInvoicePrimaryFromBookingByBookingID]                                                              
(  
@Action VARCHAR(1),
@ID INT

)                                                              
AS                                                              
BEGIN  

IF @Action = 'S'
BEGIN 


<<<<<<< HEAD
<<<<<<< HEAD
select DISTINCT '' as InvoiceNumber ,  NULL as Invoice_Date,  SCM.ID AS PlaceOfSupplierId ,  SCM.State_Code  as PlaceOfSupplier
, AM.GSTIN AS TaxNumber,
B.GuestName, B.AgentID ,AM.AgentName,  C.ID  AS Curr_ID , C.CurrencyCode  as CurrencyName,  '' as AgentBookerName, '' as AgentRefName , 
B.FileCode, B.FileCodeGeneratedOn AS FileCodeDate , AM.AddressCountry as AgentCountry,   
B.ID,
B.BookingID,
B.QuotationID, 
I.isVoid,
0 AS TypeofDoc,
0 AS isTDSDeduction,
B.TANNo AS TANNumber,
B.PANNo AS PanNumber,
0 as Performa,
1 as Invoice


  from [Booking].[tbl_Booking]  B 
  LEFT JOIN AgentMaster AM ON B.AgentID = AM.AgentID 
  LEFT JOIN CurrencyMaster C ON B.Currency = C.ID  
  LEFT JOIN [Invoice].[Invoice] I ON I.BookingID = B.ID
  LEFT JOIN State_Code_Master SCM ON AM.StateCodeID  = SCM.ID  
  Where B.ID = @ID 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	select 
		DISTINCT '' as InvoiceNumber ,  NULL as Invoice_Date,  SCM.ID AS PlaceOfSupplierId ,  SCM.State_Code  as PlaceOfSupplier
		, AM.STRegNo AS TaxNumber,
		B.GuestName, B.AgentID ,AM.AgentName, 
		CASE
			WHEN CM.Country='IN' AND AM.AddressCountry='IN'
			THEN (
					select TOP 1 Id from CurrencyMaster where CurrencyCode='INR'	
				 )
			ELSE C.ID
		END
		AS Curr_ID , 
		CASE
			WHEN CM.Country='IN' AND AM.AddressCountry='IN'
			THEN (
					select TOP 1 CurrencyCode from CurrencyMaster where CurrencyCode='INR'
				 )
			ELSE C.CurrencyCode
		END  
		AS CurrencyName, 
		'' as AgentBookerName, '' as AgentRefName , 
		B.FileCode, B.FileCodeGeneratedOn AS FileCodeDate , AM.AddressCountry as AgentCountry,   
		B.ID,
		B.BookingID,
		B.QuotationID, 
		I.isVoid,
		0 AS TypeofDoc,
		I.isTDSDeduction AS isTDSDeduction,
		AM.TANDetails AS TANNumber,
		AM.PANNo AS PanNumber,
		0 as Performa,
		1 as Invoice
	from [Booking].[tbl_Booking]  B 
	LEFT JOIN AgentMaster AM ON B.AgentID = AM.AgentID 
	LEFT JOIN [Invoice].[Invoice] I ON I.BookingID = B.ID
	LEFT JOIN CurrencyMaster C ON B.Currency  = C.ID  
	LEFT JOIN State_Code_Master SCM ON AM.StateCodeID  = SCM.ID  
	LEFT JOIN CompanyMaster CM ON B.CompanyID=CM.CompanyID
	Where B.ID = @ID 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

 END 
END