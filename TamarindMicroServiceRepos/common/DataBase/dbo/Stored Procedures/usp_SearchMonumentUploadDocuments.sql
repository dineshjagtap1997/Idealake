CREATE PROCEDURE [dbo].[usp_SearchMonumentUploadDocuments]    
(    
  @MonumentCardNo varchar(15),    
  @MonumentName varchar(100),    
  @UploadedBy varchar(100),  
  @ParentID int   
)    
AS    
BEGIN    
     
   SELECT UD.DocumentID,DocumentName,UploadedBy,UploadedOn,MR.CardNumber,MS.Name AS MonumentService,AU.UserName  ,DocumentLinkID,Documents  
   FROM UploadDocuments UD    
   inner JOIN LinkedDocuments LD ON LD.DocumentID = UD.DocumentID    
   LEFT JOIN RateCards.MonumentRateMaster MR ON MR.MonumentRateID = LD.ParentID    
   LEFT JOIN MonumentService MS ON MS.ID = MR.MonumentServiceID    
     
   inner JOIN EmployeeMaster AU ON AU.EmpID = UD.UploadedBy    
   LEFT JOIN DocumentType DT ON UD.DocumentTypeId = DT.DocumentTypeId  
   WHERE UD.ParentTypeID=4    
   AND (ISNULL(MR.CardNumber,'') LIKE CASE WHEN @MonumentCardNo IS NOT NULL THEN @MonumentCardNo+'%' ELSE ISNULL(MR.CardNumber,'') END)  
   AND (ISNULL(MS.Name,'') LIKE CASE WHEN @MonumentName IS NOT NULL THEN @MonumentName+'%' ELSE ISNULL(MS.Name,'') END)  
 AND (isnull(UD.DocumentName,'') LIKE   
CASE WHEN @UploadedBy IS NOT NULL THEN @UploadedBy+'%'
ELSE isnull(UD.DocumentName,'') END)
 -- AND (ISNULL(AU.UserName,'') LIKE CASE WHEN @UploadedBy IS NOT NULL THEN @UploadedBy+'%' ELSE ISNULL(AU.UserName,'') END)  
    AND LD.ParentID <> @ParentID  
    --AND UD.DocumentID NOT IN   
    --(SELECT LD2.DocumentID  
    -- FROM LinkedDocuments LD2  
    -- WHERE LD2.ParentID = @ParentID)  
END  
  