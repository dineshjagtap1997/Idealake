CREATE PROCEDURE [dbo].[usp_SearchHotelOfferUploadDocuments]              
(                    
  @DocumentName varchar(200),        
  @CardNo varchar(100)=null  ,
   @ParentID int 

)                    
AS                    
BEGIN                  
<<<<<<< HEAD
<<<<<<< HEAD
   SELECT UD.DocumentID,DocumentName,UploadedBy,UploadedOn,AU.UserName                    
=======
   SELECT UD.DocumentID,DocumentName,UploadedBy,UploadedOn,AU.UserName,DocumentLinkID                    
>>>>>>> dev
=======
   SELECT UD.DocumentID,DocumentName,UploadedBy,UploadedOn,AU.UserName,DocumentLinkID                    
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
   FROM UploadDocuments UD                       
   inner JOIN LinkedDocuments LD ON LD.DocumentID = UD.DocumentID           
    LEFT JOIN RateCards.HotelOfferMaster HO ON HO.HotelOfferID = LD.ParentID        
   INNER JOIN EmployeeMaster AU ON AU.EmpID = UD.UploadedBy   
   LEFT JOIN DocumentType DT ON UD.DocumentTypeId = DT.DocumentTypeId

   WHERE UD.ParentTypeID=7 AND           
   (ISNULL(HO.CardNumber,'') LIKE             
       CASE WHEN @CardNo IS NOT NULL THEN '%'+ @CardNo+'%' ELSE ISNULL(HO.CardNumber,'') END)        
       AND                 
   (ISNULL(UD.DocumentName,'') LIKE                   
       CASE WHEN @DocumentName IS NOT NULL THEN '%'+ @DocumentName+'%' ELSE ISNULL(UD.DocumentName,'') END)   
	   AND LD.ParentID <> @ParentID
	
                     
END  