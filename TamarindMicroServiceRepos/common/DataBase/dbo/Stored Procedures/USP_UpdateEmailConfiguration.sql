CREATE PROCEDURE [dbo].[USP_UpdateEmailConfiguration]                 
(                 
     @EmailTemplateId INT,                 
    @EmailCategory INT,                  
    @FromEmailAddress VARCHAR(50),                  
    @ToEmailAddress VARCHAR(1000),        
  @CCEmailAddress VARCHAR(1000)= NULL,     
    @Subject VARCHAR(200),                  
    @EmailBody NVARCHAR(MAX),                  
    @OperationBy INT = NULL,          
    @DocumentID INT = NULL,              
    @DocumentName VARCHAR(200) = NULL,  -- New Parameter  
    @DocMimeType VARCHAR(100) = NULL,  -- New Parameter  
    @UploadedBy INT = NULL,  -- New Parameter  
    @Documents NVARCHAR(MAX) = NULL, -- New Parameter  
    @DocumentTypeId INT = NULL, -- New Parameter  
    @ParentTypeID TINYINT = NULL, -- New Parameter  
    @Action CHAR(2) = ''    
)                 
AS                 
BEGIN                 
    SET NOCOUNT ON;  
  
    DECLARE @NewDocumentID INT;  
    SET @NewDocumentID = @DocumentID;  
  IF @Action = 'U' 
  begin
    -- If DocumentID is 0 and other document parameters are provided, insert into UploadDocuments
    IF @DocumentID = 0 AND @DocumentName IS NOT NULL AND @DocMimeType IS NOT NULL AND @UploadedBy IS NOT NULL   
    BEGIN  
        -- Insert the new document into UploadDocuments
        INSERT INTO UploadDocuments (ParentTypeID, DocumentName, DocMimeType, UploadedBy, UploadedOn, Documents, DocumentTypeId)  
        VALUES (@ParentTypeID, @DocumentName, @DocMimeType, @UploadedBy, GETDATE(), @Documents, @DocumentTypeId);  
              
        SET @NewDocumentID = SCOPE_IDENTITY();  
    END  
    -- If DocumentID is provided and other document details are provided, check if document exists or needs updating
    ELSE IF @DocumentID IS NOT NULL 
   AND @DocumentID != 0 
   AND @DocumentName IS NOT NULL 
   AND LTRIM(RTRIM(@DocumentName)) != ''
    BEGIN  
        -- Check if document details already exist
        IF not EXISTS (SELECT 1 
                   FROM UploadDocuments 
                   WHERE DocumentID = @DocumentID 
                     AND DocumentName = @DocumentName 
                     AND DocMimeType = @DocMimeType)
        
        BEGIN
            -- Insert new document and delete the old one
            INSERT INTO UploadDocuments (ParentTypeID, DocumentName, DocMimeType, UploadedBy, UploadedOn, Documents, DocumentTypeId)  
            VALUES (@ParentTypeID, @DocumentName, @DocMimeType, @UploadedBy, GETDATE(), @Documents, @DocumentTypeId);  
               
            SET @NewDocumentID = SCOPE_IDENTITY();  
               
            -- Delete the old document from UploadDocuments
            DELETE FROM UploadDocuments WHERE DocumentID = @DocumentID; 
			end
       
    END

    -- Always update Email Configuration table with the latest values
    UPDATE Email_Configuration   
    SET EmailCategory = @EmailCategory,                
        FromEmailAddress = @FromEmailAddress,  
        ToEmailAddress = @ToEmailAddress,  
        CCEmailAddress = @CCEmailAddress,  
        [Subject] = @Subject,  
        EmailBody = @EmailBody,                
        OperationBy = @OperationBy,  
        Operation = 'UPDATE',  
        OperationOn = GETDATE(),  
        DocumentID = @NewDocumentID  
    WHERE EmailTemplateID = @EmailTemplateId;  
  
    SELECT '200' AS returnCode, 'Data updated successfully.' AS returnMessage;  
	end

    -- If action is 'S', return the current email configuration details
   else IF @Action = 'S'   
    BEGIN  
        SELECT   
    E.EmailTemplateID,   
    E.FromEmailAddress,   
    E.ToEmailAddress,   
    E.[Subject],   
    E.EmailBody,   
    E.Operation,   
    E.OperationBy,                  
    E.OperationOn,   
    E.EmailCategory,   
    E.DocumentID,   
    E.CCEmailAddress,   
    U.DocumentName,   
    U.DocMimeType,   
    U.UploadedBy,   
    U.UploadedOn,   
    U.Documents,   
    U.ParentTypeID,   
    U.DocumentTypeId,  
    CASE   
        WHEN E.EmailCategory = 1 THEN 'New User Creation'                
        WHEN E.EmailCategory = 2 THEN 'Change Password'                
        WHEN E.EmailCategory = 3 THEN 'New Agent Registration Request'                
        WHEN E.EmailCategory = 4 THEN 'Login IDs for Agent'                
        WHEN E.EmailCategory = 5 THEN 'Send Request for Contacts Edit'                
        WHEN E.EmailCategory = 6 THEN 'Send Request for Monuments'               
        WHEN E.EmailCategory = 7 THEN 'Missing ROE'                
        WHEN E.EmailCategory = 8 THEN 'Email For Agent Approval'          
        WHEN E.EmailCategory = 9 THEN 'Outstanding Email'       
        WHEN E.EmailCategory = 10 THEN 'File Unlock Request'    
        WHEN E.EmailCategory = 11 THEN 'XO Unlock Request'        
    END AS 'EmailCategoryText'                
FROM Email_Configuration E    
LEFT JOIN UploadDocuments U ON E.DocumentID = U.DocumentID  
WHERE (@EmailTemplateID =0 OR E.EmailTemplateID = @EmailTemplateID)  
  
    END  
END
