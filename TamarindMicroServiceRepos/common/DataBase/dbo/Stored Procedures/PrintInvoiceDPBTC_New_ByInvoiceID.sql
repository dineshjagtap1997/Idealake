



  
  
  
  
CREATE Procedure [dbo].[PrintInvoiceDPBTC_New_ByInvoiceID]            
 @InvoiceNo VARCHAR(500)=null                                                  
as            
begin      
   --Select '200' as returnCode, 'data retrieved' as returnMessage      
    
  SELECT Invoice_ID,ID,Qut_ID,File_ID,flag             
  FROM Invoice_New I                              
  WHERE                                      
   Type_Of_Doc='Invoice' AND Invoice_Type<>'Proforma'                         
  --AND (@ViewAll=1 OR                            
  --(I.CreatedBy IN (Select UserID from EmployeeMaster Where ReportHeadID            
  --IN (Select EmpID from EmployeeMaster Where UserID = @UserID))                                                     
  --OR I.CreatedBy =@UserID))            
  AND isnull(Invoice_ID,'') IN (select items from [SplitCommaToTable](@InvoiceNo,','))               
  --and (IsDirectPayment = 1 or IsBTCComm = 1)                   
  order  by CreatedDateTime asc            
      
end 