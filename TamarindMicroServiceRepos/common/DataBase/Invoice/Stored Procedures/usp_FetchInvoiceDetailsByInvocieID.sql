


CREATE PROCEDURE [Invoice].[usp_FetchInvoiceDetailsByInvocieID]                                                              
(                                                              
@ID INT,
@Action VARCHAR(1)
)                                                              
AS                                                              
BEGIN  

IF @Action='S'   
BEGIN 
SELECT 
Invoice_ID, Invoice_Desc, Invoice_Value, YearCode, TotalBasicAmount,  TotalTaxable_Amount , TotalTax_Amount, TotalInvoiceAmount , flag,
SAC, Tax_Per, Allocate, StateCode, SACID, Tax_ID, CGST, SGST, UTGST, IGST, 
StateCodeID, SM.State_Code as PlaceofSupply , InvGenerated, Commercial_ID, Parent_ID, 
TotalTktCost, MarkUp, TTC_MarkUp, BaseFare,  TCSAmount, TCSRateID, Invoice_Desc_ID


 FROM [Invoice].[InvoiceDetails] ID 
 LEFT JOIN State_Code_Master SM ON SM.ID = ID.StateCodeID 
 Where ID.ID = @ID  

 END 

END