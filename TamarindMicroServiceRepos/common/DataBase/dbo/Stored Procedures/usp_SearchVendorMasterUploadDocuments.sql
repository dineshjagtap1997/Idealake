CREATE PROCEDURE [dbo].[usp_SearchVendorMasterUploadDocuments] --'',null,'Pdf'            
@VendorCode varchar(15),                  
@VendorID int,                  
@DocumentName varchar(100) ,
@ParentID int -- New parameter for ParentID
AS            
BEGIN            
 SELECT UD.DocumentID,DocumentName,LD.DocumentLinkID,Documents,UploadedBy,UploadedOn,VM.VendorCode AS VendorCode,VM.VendorName AS VendorName,AU.UserName ,  
  DT.DocumentTypeId,    DT.DocumentType ,AU.EmpName   
  
   FROM UploadDocuments UD                  
   INNER JOIN LinkedDocuments LD ON LD.DocumentID = UD.DocumentID                  
   LEFT JOIN VendorMaster VM ON VM.VendorID = LD.ParentID                 
   INNER JOIN EmployeeMaster AU ON AU.EmpID = UD.UploadedBy    
    left JOIN DocumentType DT ON UD.DocumentTypeId = DT.DocumentTypeId  
   WHERE (ISNULL(VM.VendorCode,'') LIKE CASE WHEN @VendorCode IS NOT NULL THEN @VendorCode+'%' ELSE ISNULL(VM.VendorCode,'') END)                
    AND (ISNULL(VM.VendorID,'') = CASE WHEN @VendorID IS NOT NULL THEN @VendorID ELSE ISNULL(VM.VendorID,'') END)                
    AND (ISNULL(UD.DocumentName,'') LIKE CASE WHEN @DocumentName IS NOT NULL THEN @DocumentName+'%' ELSE ISNULL(UD.DocumentName,'') END)          
 AND UD.ParentTypeID=9  
<<<<<<< HEAD
<<<<<<< HEAD
  AND LD.ParentID <> @ParentID  -- Exclude the records with the given ParentID
=======
 -- AND LD.ParentID <> @ParentID  
>>>>>>> dev
=======
 -- AND LD.ParentID <> @ParentID  
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 order by UploadedOn desc   
 end