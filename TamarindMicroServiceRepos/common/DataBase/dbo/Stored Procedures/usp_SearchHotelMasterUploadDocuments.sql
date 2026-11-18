<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_SearchHotelMasterUploadDocuments]            
=======
﻿
CREATE PROCEDURE [dbo].[usp_SearchHotelMasterUploadDocuments]            
>>>>>>> dev
=======
﻿
CREATE PROCEDURE [dbo].[usp_SearchHotelMasterUploadDocuments]            
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
@HotelCode varchar(15) = null,                  
@HotelID int = null,                  
@DocumentName varchar(100) = null ,
@ParentTypeID int = null,
  @ParentID int -- New parameter for ParentID
AS            
BEGIN            
    SELECT HM.HotelID,
           UD.DocumentID,
           UD.DocumentName,
           LD.DocumentLinkID,
           UD.ParentTypeID,
           UD.Documents,
           UD.UploadedBy,
           UD.UploadedOn,
           HM.HotelCode AS HotelCodeNo,
           HM.HotelName AS HotelName,
<<<<<<< HEAD
<<<<<<< HEAD
           AU.UserName,
=======
           AU.EmpName AS UserName,
>>>>>>> dev
=======
           AU.EmpName AS UserName,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
           DT.DocumentTypeId,
           DT.DocumentType,
           AU.EmpName  
    FROM UploadDocuments UD                  
    INNER JOIN LinkedDocuments LD ON LD.DocumentID = UD.DocumentID                  
    LEFT JOIN HotelMaster HM ON HM.HotelID = LD.ParentID                 
    INNER JOIN EmployeeMaster AU ON AU.EmpID = UD.UploadedBy  
    LEFT JOIN DocumentType DT ON UD.DocumentTypeId = DT.DocumentTypeId  

    WHERE                  
        (HM.HotelCode LIKE '%'+ @HotelCode + '%' or @HotelCode = '' or @HotelCode is null)                
        AND ( @HotelID IS NULL or @HotelID = HM.HotelID or @HotelID = 0)                
        AND (@DocumentName IS NULL OR UD.DocumentName like '%'+ @DocumentName + '%'or @DocumentName = '')  -- Exact match filter
        AND (UD.ParentTypeID = @ParentTypeID or @ParentTypeID is null or @ParentTypeID = 0)  
		  AND UD.ParentTypeID = 10
		 AND LD.ParentID <> @ParentID  -- Exclude the records with the given ParentID
    ORDER BY UD.UploadedOn DESC   
END  
