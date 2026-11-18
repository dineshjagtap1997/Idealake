Create PROCEDURE [dbo].[USP_GetMultipleInvoiceNo_New_1]                        
(                        
@FromDate VARCHAR(50)=null,                        
@ToDate VARCHAR(50)=null,                        
@FileCode VARCHAR(50)=null,                        
@InvoiceNo VARCHAR(5000)=null,                        
@ViewAll BIT=null,                    
@UserId varchar(100)=null,                    
@CompId INT,                        
@YearID INT                      
)                        
AS                        
BEGIN                        
SELECT Invoice_ID,ID,Qut_ID,File_ID,flag  
 FROM Invoice_New I WHERE                         
isnull(File_ID,'')= CASE WHEN @FileCode IS NOT NULL then  @FileCode ELSE isnull(File_ID,'') END                        
--AND isnull(Invoice_ID,'')= CASE WHEN @InvoiceNo IS NOT NULL then  @InvoiceNo ELSE isnull(Invoice_ID,'') END 
AND isnull(Invoice_ID,'') IN (select items from [SplitCommaToTable](@InvoiceNo,','))                         
AND convert(VARCHAR,cast(Invoice_Date AS datetime),112) BETWEEN                         
CASE WHEN @FromDate IS NOT NULL THEN convert(VARCHAR,cast(@FromDate AS datetime),112)                         
 ELSE convert(VARCHAR,cast(Invoice_Date AS datetime),112) END                        
 AND CASE WHEN @ToDate IS NOT NULL then convert(VARCHAR,cast(@ToDate AS datetime),112)                        
 ELSE convert(VARCHAR,cast(Invoice_Date AS datetime),112) END                        
AND compcode=@CompId AND YearCode=@YearID          
--AND flag is null        
--AND flag=1                      
AND Type_Of_Doc='Invoice' AND Invoice_Type<>'Proforma'                 
AND (@ViewAll=1 OR                    
(I.CreatedBy IN (Select UserID from EmployeeMaster Where ReportHeadID IN (Select EmpID from EmployeeMaster Where UserID = @UserID))                                             
 OR I.CreatedBy =@UserID))            
 order  by CreatedDateTime asc                        
END 