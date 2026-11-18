
 

CREATE PROCEDURE [dbo].[usp_SearchHotelUploadDocuments]   
   
  @HotelCardNo VARCHAR(15) = NULL,    
  @HotelID INT = NULL,    
  @UploadedBy VARCHAR(100) = NULL,
  @ParentID int ,
  @DocumentName varchar(100) = null 
--EXEC [dbo].[usp_SearchHotelUploadDocuments] @HotelCardNo = 'H2503000004', @HotelID = 0, @UploadedBy = ''
AS    
BEGIN    
     
   SELECT UD.DocumentID,DocumentName,UploadedBy,UploadedOn,HR.CardNumber,HM.HotelName AS HotelName,AU.UserName ,LD.DocumentLinkID,ld.ParentID  ,Documents
   FROM UploadDocuments UD    
   INNER JOIN LinkedDocuments LD ON LD.DocumentID = UD.DocumentID    
   LEFT OUTER JOIN [RateCards].HotelRateMaster HR ON HR.HotelRateID = LD.ParentID    
   LEFT JOIN HotelMaster HM ON HM.HotelID = HR.HotelID   
   INNER JOIN EmployeeMaster AU ON AU.EmpID = UD.UploadedBy  
   LEFT JOIN DocumentType DT ON UD.DocumentTypeId = DT.DocumentTypeId
   WHERE    
   (ISNULL(HR.CardNumber,'') LIKE   
       CASE WHEN @HotelCardNo IS NOT NULL THEN @HotelCardNo +'%' ELSE ISNULL(HR.CardNumber,'') END)  
    AND (ISNULL(HM.HotelID,0) =   
       CASE WHEN @HotelID IS NOT NULL AND @HotelID > 0 THEN @HotelID ELSE ISNULL(HM.HotelID,0) END)  
	     AND (@DocumentName IS NULL OR UD.DocumentName like '%'+ @DocumentName + '%'or @DocumentName = '')  -- Exact match filter
    AND (ISNULL(AU.UserName,'') LIKE   
       CASE WHEN @UploadedBy IS NOT NULL THEN @UploadedBy+'%' ELSE ISNULL(AU.UserName,'') END)  
	   AND UD.ParentTypeID=1 
	   AND LD.ParentID <> @ParentID
	   
  
END
