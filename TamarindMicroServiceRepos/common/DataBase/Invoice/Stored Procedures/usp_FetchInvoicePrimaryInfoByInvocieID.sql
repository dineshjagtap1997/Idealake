


CREATE PROCEDURE [Invoice].[usp_FetchInvoicePrimaryInfoByInvocieID]                                                              
(  
@Action VARCHAR(1),
@ID INT

)                                                              
AS                                                              
BEGIN  

IF @Action = 'S'
BEGIN 


SELECT 
ID,
Invoice_ID,
Type_Of_Doc,
Invoice_Type,
Invoice_Date,
File_ID,
BookingID,
Qut_ID,
Customer_Name,
Agent_ID,
Curr_ID,
Tax_ID,
AgentRefPO,
PlaceOfSupplierId

 FROM [Invoice].[Invoice] I  Where I.ID = @ID 

 END 
END