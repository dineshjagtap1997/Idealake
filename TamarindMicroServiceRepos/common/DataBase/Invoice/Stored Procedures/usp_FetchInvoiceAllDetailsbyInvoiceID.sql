


CREATE PROCEDURE [Invoice].[usp_FetchInvoiceAllDetailsbyInvoiceID]                                                              
(  
@Action VARCHAR(1),
@InvoiceID INT

)                                                              
AS                                                              
BEGIN  

IF @Action = 'S'
BEGIN 


select  I.InvoiceNumber , I.Invoice_Date  as InvoiceDate,  I.PlaceOfSupplierId , SCM.State_Code  as PlaceofSupply
,I.TAXNumber,
 I.GuestName, I.AgentID ,AM.AgentName,  I.Curr_ID  AS CurrencyID , C.Code as CurrencyName,  '' as AgentBookerName, '' as AgentRefName , 
I.FileCode,
B.ID as BID,
B.BookingID,
B.QuotationID, 
I.TypeofDoc,
I.isTDSDeduction  AS isTDSDeduction,
I.TANNumber AS TANNumber,
I.PanNumber  AS PanNumber


  from [Invoice].[Invoice] I 
  LEFT JOIN  [Booking].[tbl_Booking]  B ON I.BookingID = B.ID
  LEFT JOIN AgentMaster AM ON B.AgentID = AM.AgentID 
  LEFT JOIN Currency C ON B.Currency = C.CurrencyID  
  LEFT JOIN State_Code_Master SCM ON I.PlaceOfSupplierId  = SCM.ID  
  Where I.ID = @InvoiceID 

 END 
END