CREATE PROCEDURE [dbo].[usp_SearchMOTUploadDocuments]  --'M110600001',NULL,NULL          
(            
 @MOTCardNo varchar(15),            
 @MOTID INT,            
 @UploadedBy varchar(100) ,
 @ParentID int 
)            
AS            
BEGIN  

SELECT DISTINCT UDS.DocumentID,UDS.ParentTypeID,UDS.DocumentName,UDS.UploadedBy,UDS.UploadedOn,
		M.MOT,AU.UserName		 
FROM UploadDocuments UDS 
INNER JOIN LinkedDocuments LD ON LD.DocumentID=UDS.DocumentID
LEFT JOIN MOTRateMaster MRM ON MRM.MOTRateID = LD.ParentID
LEFT JOIN MOT M ON M.ID= MRM.MOTID         

       inner JOIN EmployeeMaster AU ON AU.EmpID = UDS.UploadedBy  
   LEFT JOIN DocumentType DT ON UDS.DocumentTypeId = DT.DocumentTypeId
	      
         
WHERE     
UDS.ParentTypeID=6    and     
          
 (isnull(MRM.MOTCardNo,'') LIKE           
CASE WHEN @MOTCardNo IS NOT NULL THEN @MOTCardNo+'%'           
ELSE isnull(MRM.MOTCardNo,'') END)       
       
AND (isnull(M.ID,'') =           
CASE WHEN @MOTID IS NOT NULL THEN @MOTID           
ELSE isnull(M.ID,'')     
END)          
      
AND (isnull(AU.UserName,'') LIKE           
CASE WHEN @UploadedBy IS NOT NULL THEN @UploadedBy+'%'           
ELSE isnull(AU.UserName,'') END)      
   AND LD.ParentID <> @ParentID
  
ORDER BY DocumentName       
END
