CREATE PROCEDURE [dbo].[usp_SearchTransportUploadDocuments] --'',0,'',0,10             
(                    
 @TransportCardNo varchar(15),                    
 @TransportServiceID INT,                    
 @UploadedBy varchar(100),    
 @VendorID INT=null  ,  
  @ParentID int   
)                    
AS                    
BEGIN          
        
SELECT DISTINCT UDS.DocumentID,UDS.ParentTypeID,UDS.DocumentName,TRM.CardNumber,UDS.UploadedBy,UDS.UploadedOn,TS.Name as 'Service',AU.UserName ,DocumentLinkID    ,Documents , TRM.VendorID,                        -- already present  
    VM.VendorName  ,TransportServceID   
FROM UploadDocuments UDS         
INNER JOIN LinkedDocuments LD ON LD.DocumentID=UDS.DocumentID        
LEFT JOIN RateCards.TransportRateMaster TRM ON TRM.TransportRateID = LD.ParentID        
LEFT JOIN TransportServices TS ON TS.Code= TRM.TransportServceID               
LEFT JOIN VendorMaster VM ON TRM.VendorID = VM.VendorID    
INNER JOIN EmployeeMaster AU ON AU.EmpID = UDS.UploadedBy    
LEFT JOIN DocumentType DT ON UDS.DocumentTypeId = DT.DocumentTypeId  
WHERE UDS.ParentTypeID=3  AND (isnull(TRM.CardNumber,'') LIKE                   
CASE WHEN @TransportCardNo IS NOT NULL THEN @TransportCardNo+'%'                   
ELSE isnull(TRM.CardNumber,'') END)               
AND (  
    @TransportServiceID IS NULL OR @TransportServiceID = 0   
    OR ISNULL(TS.Code, '') = @TransportServiceID  
)                
              
--AND (isnull(AU.UserName,'') LIKE                   
--CASE WHEN @UploadedBy IS NOT NULL THEN @UploadedBy+'%'                   
--ELSE isnull(AU.UserName,'') END)       
AND (isnull(UDS.DocumentName,'') LIKE   
CASE WHEN @UploadedBy IS NOT NULL THEN @UploadedBy+'%'
ELSE isnull(UDS.DocumentName,'') END)
    
AND    
(@VendorID IS NULL OR @VendorID = 0 OR   
 TransportRateID IN (SELECT TransportRateID   
                     FROM RateCards.TransportRateMaster   
                     WHERE VendorID = @VendorID))  
  
         
        AND LD.ParentID <> @ParentID  
 
ORDER BY DocumentName               
END     
    