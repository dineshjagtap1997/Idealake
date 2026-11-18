-- [PrintInvoiceAll_New] '20230222','20230222',148,1,'b9783a30-1fcd-4bcc-943c-0c1397ed94e0',190    
create Procedure [dbo].[PrintInvoiceAll_New]      
 @FromDate VARCHAR(50)=null,                          
 @ToDate VARCHAR(50)=null,                        
 @AgentID int= null,                          
 @ViewAll BIT=0,                      
 @UserId varchar(100)=null,                      
 @YearID INT = null      
as      
begin      
  SELECT Invoice_ID,ID,Qut_ID,File_ID,flag       
  FROM Invoice_New I            
  inner join AgentMaster H on I.Agent_ID = H.AgentCode                     
  WHERE      
  convert(VARCHAR,cast(Invoice_Date AS datetime),112) BETWEEN                           
  CASE WHEN @FromDate IS NOT NULL THEN convert(VARCHAR,cast(@FromDate AS datetime),112)                           
  ELSE convert(VARCHAR,cast(Invoice_Date AS datetime),112) END                          
  AND CASE WHEN @ToDate IS NOT NULL then convert(VARCHAR,cast(@ToDate AS datetime),112)                          
  ELSE convert(VARCHAR,cast(Invoice_Date AS datetime),112) END                          
  --AND YearCode=@YearID            
  AND Type_Of_Doc='Invoice' AND Invoice_Type<>'Proforma'                   
  AND (@ViewAll=1 OR                      
  (I.CreatedBy IN (Select UserID from EmployeeMaster Where ReportHeadID      
  IN (Select EmpID from EmployeeMaster Where UserID = @UserID))                                               
  OR I.CreatedBy =@UserID))      
  and (IsDirectPayment = 0 or IsDirectPayment is null or IsBTCComm = 1 or IsBTCComm is null)       
  and AgentID = @AgentID             
  order  by CreatedDateTime asc      
end