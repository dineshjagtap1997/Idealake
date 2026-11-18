CREATE PROCEDURE [dbo].[usp_SearchSpecialServiceUploadDocuments]    
(    
 @SpecialServiceCardNo varchar(15),    
 @SpecialService varchar(100),    
 @UploadedBy varchar(100) ,  
 @ParentID int  
)    
AS    
BEGIN    
SELECT UD.DocumentID,DocumentName,UploadedBy,UploadedOn,SRM.CardNumber,SS.Name AS SpecialService,AU.UserName,DocumentLinkID,Documents  
FROM UploadDocuments UD  
INNER JOIN LinkedDocuments LD ON LD.DocumentID = UD.DocumentID  
LEFT JOIN Ratecards.SpecialServiceRateMaster SRM ON SRM.SpecialServiceRateID = LD.ParentID  
LEFT JOIN SpecialServices SS ON SS.ID = SRM.SpecialServiceID  
  
INNER JOIN EmployeeMaster AU ON AU.EmpID = UD.UploadedBy    
LEFT JOIN DocumentType DT ON UD.DocumentTypeId = DT.DocumentTypeId  
WHERE UD.ParentTypeID=5   and  
  
(isnull(SRM.CardNumber,'') LIKE   
  CASE WHEN @SpecialServiceCardNo IS NOT NULL THEN @SpecialServiceCardNo+'%'   
  ELSE isnull(SRM.CardNumber,'') END)  
AND (isnull(SS.Name,'') LIKE   
  CASE WHEN @SpecialService IS NOT NULL THEN @SpecialService+'%'   
  ELSE isnull(SS.Name,'') END)  
--AND (isnull(AU.UserName,'') LIKE   
--  CASE WHEN @UploadedBy IS NOT NULL THEN @UploadedBy+'%'   
--  ELSE isnull(AU.UserName,'') END) 
AND (isnull(UD.DocumentName,'') LIKE   
CASE WHEN @UploadedBy IS NOT NULL THEN @UploadedBy+'%'
ELSE isnull(UD.DocumentName,'') END)
  AND LD.ParentID <> @ParentID  
  
    
ORDER BY DocumentName     
END