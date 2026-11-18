CREATE PROCEDURE [dbo].[usp_SearchCustomerUploadDocuments] --'',null,'Pdf'          
@CustomerCode varchar(max),                
@CustomerID int,                
@DocumentName varchar(100)  ,
@ParentID int
AS          
BEGIN          
 SELECT UD.DocumentID,DocumentName,LD.DocumentLinkID,Documents,UploadedBy,UploadedOn,CM.CustomerCode,cm.Fullname AS CustomerName,AU.UserName ,
  DT.DocumentTypeId,
   DT.DocumentType ,AU.EmpName ,CM.CID as CustomerID ,LD.ParentID

   FROM UploadDocuments UD                
   INNER JOIN LinkedDocuments LD ON LD.DocumentID = UD.DocumentID                
   LEFT JOIN customer CM ON CM.CID = LD.ParentID               
   INNER JOIN EmployeeMaster AU ON AU.EmpID = UD.UploadedBy  
    left JOIN DocumentType DT ON UD.DocumentTypeId = DT.DocumentTypeId
   WHERE (ISNULL(CM.CustomerCode,'') LIKE CASE WHEN @CustomerCode IS NOT NULL THEN @CustomerCode+'%' ELSE ISNULL(CM.CustomerCode,'') END)              
    AND (ISNULL(CM.CID,'') = CASE WHEN @CustomerID IS NOT NULL THEN @CustomerID ELSE ISNULL(CM.CID,'') END)              
    AND (ISNULL(UD.DocumentName,'') LIKE CASE WHEN @DocumentName IS NOT NULL THEN @DocumentName+'%' ELSE ISNULL(UD.DocumentName,'') END)        
 AND UD.ParentTypeID=25 
 AND LD.ParentID <> @ParentID 
 order by UploadedOn desc 
 end