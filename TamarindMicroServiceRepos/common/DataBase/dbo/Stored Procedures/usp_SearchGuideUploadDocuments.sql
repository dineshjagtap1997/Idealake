CREATE PROCEDURE [dbo].[usp_SearchGuideUploadDocuments]  --0,2,NULL    
(      
 @GuideCardNo varchar(15)=NULL,      
 @GuideService varchar(100)=NULL,      
 @UploadedBy varchar(100)=NULL ,    
 @ParentID int =NULL    
)      
AS      
BEGIN      
SELECT UD.DocumentID,DocumentName,UploadedBy,UploadedOn,GRM.CardNumber,GS.Name AS GuideService,AU.UserName,DocumentLinkID,Documents    
FROM UploadDocuments UD    
inner JOIN LinkedDocuments LD ON LD.DocumentID = UD.DocumentID    
LEFT JOIN RateCards.GuideRateMaster GRM ON GRM.GuideRateID = LD.ParentID    
LEFT JOIN GuideServices GS ON GS.Code = GRM.GuideServiceID    
    
inner JOIN EmployeeMaster AU ON AU.EmpID = UD.UploadedBy      
   LEFT JOIN DocumentType DT ON UD.DocumentTypeId = DT.DocumentTypeId    
WHERE UD.ParentTypeID=2    
    
AND (isnull(GRM.CardNumber,'') LIKE     
CASE WHEN @GuideCardNo IS NOT NULL THEN @GuideCardNo+'%'     
ELSE isnull(GRM.CardNumber,'') END)    
AND (isnull(GS.Name,'') LIKE     
CASE WHEN @GuideService IS NOT NULL THEN @GuideService+'%'     
ELSE isnull(GS.Name,'') END)    
--AND (isnull(AU.UserName,'') LIKE     
--CASE WHEN @UploadedBy IS NOT NULL THEN @UploadedBy+'%' this will change for uploaded by to Document Name.   
--ELSE isnull(AU.UserName,'') END)  
AND (isnull(UD.DocumentName,'') LIKE     
CASE WHEN @UploadedBy IS NOT NULL THEN @UploadedBy+'%'  
ELSE isnull(UD.DocumentName,'') END)  
AND  UD.ParentTypeID=2   
 AND LD.ParentID <> @ParentID    
  
END 