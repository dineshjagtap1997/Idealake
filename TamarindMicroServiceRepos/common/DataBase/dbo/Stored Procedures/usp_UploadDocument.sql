<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_UploadDocument]    
=======
﻿
CREATE PROCEDURE [dbo].[usp_UploadDocument]    
>>>>>>> dev
=======
﻿
CREATE PROCEDURE [dbo].[usp_UploadDocument]    
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    @Action CHAR(1),     
    @ParentID INT= NULL,    
    @ParentTypeID INT= NULL,    
    @DocumentID INT = NULL,    
    @DocumentName VARCHAR(200) = NULL,    
    @DocMimeType VARCHAR(100) = NULL,    
    @Documents NVARCHAR(MAX) = NULL,    
    @UploadedBy INT= NULL,    
 @DocumentTypeId INT = NULL ,  
  @DocumentLinkID INT= NULL,  
  @OperationBy UNIQUEIDENTIFIER = NULL   
AS    
BEGIN    
    BEGIN TRANSACTION;    
    
    DECLARE @NewDocumentID INT,    
               
            @ReturnCode NVARCHAR(3),    
            @ReturnMessage NVARCHAR(MAX);    
    
    BEGIN TRY    
        IF @Action = 'I'     
        BEGIN    
            -- Check if the document name already exists for the same ParentTypeID    
            IF EXISTS (SELECT 1 FROM [dbo].[UploadDocuments] WHERE [ParentTypeID] = @ParentTypeID AND [DocumentName] = @DocumentName)    
            BEGIN    
                ROLLBACK TRANSACTION;    
                SET @ReturnCode = '409';    
                SET @ReturnMessage = 'A document with the same name already exists for the same ParentTypeID';    
            END    
            ELSE    
            BEGIN    
                INSERT INTO [dbo].[UploadDocuments]     
                (    
                    [ParentTypeID],    
                    [DocumentName],    
                    [DocMimeType],    
                    [Documents],    
                    [UploadedBy],    
                    [UploadedOn],    
     [DocumentTypeId]    
                )    
                VALUES    
                (    
                    @ParentTypeID,    
                    @DocumentName,    
                    @DocMimeType,    
                    @Documents,    
                    @UploadedBy,    
                    GETDATE(),    
     @DocumentTypeId    
                );    
                SET @NewDocumentID = SCOPE_IDENTITY();    
    
                INSERT INTO [dbo].[LinkedDocuments]    
                (    
                    [ParentID],    
                    [ParentTypeID],    
                    [DocumentID]    
                )    
                VALUES    
                (    
                    @ParentID,    
                    @ParentTypeID,    
                    @NewDocumentID    
                );    
    
                COMMIT TRANSACTION;    
                SET @ReturnCode = '200';    
                SET @ReturnMessage = 'Document uploaded successfully.';    
            END    
        END    
        ELSE IF @Action = 'U'     
        BEGIN    
            -- Check if the document name already exists for the same ParentTypeID (excluding itself)    
            IF EXISTS (SELECT 1 FROM [dbo].[UploadDocuments] WHERE [ParentTypeID] = @ParentTypeID AND [DocumentName] = @DocumentName AND [DocumentID] <> @DocumentID)    
            BEGIN    
                ROLLBACK TRANSACTION;    
                SET @ReturnCode = '409';    
                SET @ReturnMessage = 'A document with the same name already exists for the same ParentTypeID';    
            END    
            ELSE IF EXISTS(SELECT DocumentID FROM UploadDocuments WHERE DocumentID = @DocumentID)    
            BEGIN    
                IF (ISNULL(CONVERT(VARCHAR, @Documents), '') <> '')      
                BEGIN    
                    UPDATE UploadDocuments    
                    SET    
                        [ParentTypeID] = @ParentTypeID,      
                        [DocumentName] = @DocumentName,      
                        [DocMimeType] = @DocMimeType,        
                        [Documents] = @Documents,            
                        [UpdatedBy] = @UploadedBy,          
                        [UpdatedOn] = GETDATE() ,    
      [DocumentTypeId] = @DocumentTypeId    
                    WHERE [DocumentID] = @DocumentID;       
                        
                    COMMIT TRANSACTION;    
                    SET @ReturnCode = '200';    
                    SET @ReturnMessage = 'Document Updated successfully.';    
                END    
            END    
        END    
        --ELSE IF @Action = 'S'     
--        BEGIN    
----            --SELECT              --    u.[DocumentID],             --    u.[DocumentName],             --    u.[DocMimeType],             --    u.[Documents],             --    l.[ParentID],             --    l.[DocumentLinkID],             --    u.[
--Uplo  
----adedBy],             --    e.[EmpName],             --    u.[UploadedOn],             --    u.[UpdatedBy],             --    u.[UpdatedOn],             --    l.[ParentTypeID]             --FROM [dbo].[UploadDocuments] u             --JOIN [dbo].[Linke
--dDoc  
----uments] l ON u.[DocumentID] = l.[DocumentID]             --JOIN [dbo].[EmployeeMaster] e ON u.[UploadedBy] = e.[EmpID]             --WHERE l.[ParentID] = @ParentID AND l.ParentTypeID = @ParentTypeID;    
    
--   SELECT u.[DocumentID], u.[DocumentName], u.[DocMimeType], u.[Documents], l.[ParentID], l.[DocumentLinkID], u.[UploadedBy], e.[EmpName], u.[UploadedOn], u.[UpdatedBy], u.[UpdatedOn], l.[ParentTypeID], u.[DocumentTypeId], d.[DocumentType],e.username   
    
--        FROM [dbo].[UploadDocuments] u             JOIN [dbo].[LinkedDocuments] l ON u.[DocumentID] = l.[DocumentID]             JOIN [dbo].[EmployeeMaster] e ON u.[UploadedBy] = e.[EmpID]             left JOIN [dbo].[DocumentType] d ON u.[DocumentTypeI
--d]  
-- = d.[DocumentTypeId]             WHERE l.[ParentID] = @ParentID AND l.ParentTypeID = @ParentTypeID and DocumentLinkID = @DocumentLinkID   
                
--            COMMIT TRANSACTION;    
--            SET @ReturnCode = '200';    
--            SET @ReturnMessage = 'Document Retrieved successfully';    
        --END    
  ELSE IF @Action = 'S'     
BEGIN  
    -- Declare the base query  
    DECLARE @sql NVARCHAR(MAX);  
  
    -- Construct the base query  
    SET @sql = N'SELECT   
                    u.[DocumentID],   
                    u.[DocumentName],   
                    u.[DocMimeType],   
                    u.[Documents],   
                    l.[ParentID],   
                    l.[DocumentLinkID],   
                    u.[UploadedBy],   
                    e.[EmpName],   
                    u.[UploadedOn],   
                    u.[UpdatedBy],   
                    u.[UpdatedOn],   
                    l.[ParentTypeID],   
                    u.[DocumentTypeId],   
                    d.[DocumentType],   
                    e.username  
                FROM   
                    [dbo].[UploadDocuments] u  
                JOIN   
                    [dbo].[LinkedDocuments] l ON u.[DocumentID] = l.[DocumentID]  
                JOIN   
                    [dbo].[EmployeeMaster] e ON u.[UploadedBy] = e.[EmpID]  
                LEFT JOIN   
                    [dbo].[DocumentType] d ON u.[DocumentTypeId] = d.[DocumentTypeId]  
                WHERE   
                    l.[ParentID] = @ParentID   
                    AND l.ParentTypeID = @ParentTypeID
					Order by 1 desc';  
  
    -- If @DocumentLinkID is not 0, add the filter for DocumentLinkID  
   IF @DocumentLinkID IS NOT NULL AND @DocumentLinkID <> 0  
    BEGIN  
        SET @sql = @sql + ' AND l.[DocumentLinkID] = @DocumentLinkID';  
    END  
  
    -- Execute the dynamic SQL with the provided parameters  
    EXEC sp_executesql @sql,   
                       N'@ParentID INT, @ParentTypeID INT, @DocumentLinkID INT',   
                       @ParentID, @ParentTypeID, @DocumentLinkID;  
  
    COMMIT TRANSACTION;    
    SET @ReturnCode = '200';    
    SET @ReturnMessage = 'Document Retrieved successfully';    
END  
  
        ELSE    
        BEGIN    
            ROLLBACK TRANSACTION;    
            SET @ReturnCode = '500';    
            SET @ReturnMessage = 'Invalid ActionFlag. Allowed values are "I", "U", and "S".';    
        END    
    END TRY    
    BEGIN CATCH    
        ROLLBACK TRANSACTION;    
        SET @ReturnCode = '500';    
        SET @ReturnMessage = ERROR_MESSAGE();    
    END CATCH    
    
    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;    
END 