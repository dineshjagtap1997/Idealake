CREATE PROCEDURE [dbo].[USP_SearchFileCode_XoNo_Quotation]         
@ISLocked VARCHAR(10)=NULL,              
@FileCode VARCHAR(50)=NULL,          
@XoNo VARCHAR(50)=NULL,              
@CompID VARCHAR(10),              
@YearID VARCHAR(10)              
AS         
BEGIN       
 SELECT QuotationID,        
 FileCode,        
 XO_ID,        
 XO_Supplier_Name,        
 C.CompanyName,         
 IsPayment,
Q.YearID,
 --CASE WHEN 1 IS NOT NULL then @ISLocked ELSE IsLocked END as 'IsLocked'        
 ISNULL((CASE WHEN IsPayment=1 THEN 'Yes' ELSE 'No' END ) ,0)AS 'IsLocked'        
 FROM Quotation Q              
  INNER JOIN XO X ON Q.QuotationID = X.Qut_ID           
  INNER JOIN CompanyMaster C ON Q.CompanyID = C.CompanyID         
  INNER JOIN YearMaster Y ON  Q.YearID= Y.YearID         
 WHERE               
 --IsLocked=(CASE WHEN 1 IS NOT NULL then @ISLocked ELSE IsLocked END) AND             
 FileCode=CASE WHEN isnull(@FileCode,'') <> '' THEN @FileCode ELSE FileCode END  AND         
 XO_ID=CASE WHEN isnull(@XoNo,'') <> '' THEN @XoNo ELSE XO_ID END             
 --AND IsLocked IS NOT NULL         
 --AND FileCode IS NOT NULL            
 --AND XO_ID IS NOT NULL              
 AND Q.CompanyID=@CompID         
 AND Q.YearID=@YearID       
 --AND (Undo is null Or Undo=0)      
END        
        
--Update Quotation set YearID =71 where FileCode='UNI12040001 ' 