--alter PROCEDURE [dbo].[usp_InsertUpdateLinkedDocuments]            
--(            
--    @ParentID INT,            
--    @ParentTypeID TINYINT,            
--    @DocumentIDs NVARCHAR(MAX)  -- Comma-separated list of DocumentIDs         
--)            
--AS            
--BEGIN            
--    SET NOCOUNT ON;        
      
--    -- Table variable to store parsed Document IDs      
--    DECLARE @DocumentTable TABLE (DocumentID INT);            
      
--    -- Split the @DocumentIDs string into a table      
--    INSERT INTO @DocumentTable (DocumentID)            
--    SELECT TRIM(value) AS DocumentID            
--    FROM STRING_SPLIT(@DocumentIDs, ',');            
      
--    -- Declare a variable to store the first generated DocumentLinkID      
--    DECLARE @GeneratedDocumentLinkID INT = NULL;            
--    DECLARE @CurrentDocumentID INT;            
      
--    -- Cursor to iterate through document IDs      
--    DECLARE docCursor CURSOR FOR            
--    SELECT DocumentID FROM @DocumentTable;            
      
--    OPEN docCursor;            
--    FETCH NEXT FROM docCursor INTO @CurrentDocumentID;            
      
--    WHILE @@FETCH_STATUS = 0            
--    BEGIN            
--        -- If this is the first document, insert and capture the generated DocumentLinkID      
--        --IF @GeneratedDocumentLinkID IS NULL            
--        --BEGIN            
--		If exists (select 1 from LinkedDocuments where ParentID = @ParentID and ParentTypeID = @ParentTypeID and DocumentID = @CurrentDocumentID)
--		begin
--		Select '201' as returnCode, 'This document is already linked. Please check and try again' as returnMessage
--		end
--		else 
--		begin

--            INSERT INTO LinkedDocuments (ParentID, ParentTypeID, DocumentID)            
--            VALUES (@ParentID, @ParentTypeID, @CurrentDocumentID);            
      
--  --          -- Capture the newly created DocumentLinkID      
--  --          SET @GeneratedDocumentLinkID = SCOPE_IDENTITY();            
--  --      END            
--  --      ELSE            
--  --      BEGIN            
--  --SET IDENTITY_INSERT LinkedDocuments ON;      
--  --          -- Use the same DocumentLinkID for subsequent records            
--  --          INSERT INTO LinkedDocuments (DocumentLinkID, ParentID, ParentTypeID, DocumentID)            
--  --          VALUES (@GeneratedDocumentLinkID, @ParentID, @ParentTypeID, @CurrentDocumentID);            
--  -- SET IDENTITY_INSERT LinkedDocuments Off;      
--        --END            
      
--        FETCH NEXT FROM docCursor INTO @CurrentDocumentID;            
--    END            
      
--    CLOSE docCursor;            
--    DEALLOCATE docCursor;            
      
--    -- Return success message      
--    SELECT '200' AS returnCode, 'Document linked successfully.' as returnMessage, @GeneratedDocumentLinkID AS id;           
--	end
--END 

CREATE PROCEDURE [dbo].[usp_InsertUpdateLinkedDocuments]            
(            
    @ParentID INT,            
    @ParentTypeID TINYINT,            
    @DocumentIDs NVARCHAR(MAX)  -- Comma-separated list of DocumentIDs         
)            
AS            
BEGIN            
    SET NOCOUNT ON;        

    -- Table variable to store parsed Document IDs      
    DECLARE @DocumentTable TABLE (DocumentID INT);            

    -- Split the @DocumentIDs string into a table      
    INSERT INTO @DocumentTable (DocumentID)            
    SELECT TRIM(value) AS DocumentID            
    FROM STRING_SPLIT(@DocumentIDs, ',');            

    -- Declare variables for cursor processing      
    DECLARE @CurrentDocumentID INT;            
    DECLARE @AlreadyLinked BIT = 0;

    -- Cursor to iterate through document IDs      
    DECLARE docCursor CURSOR FOR            
    SELECT DocumentID FROM @DocumentTable;            

    OPEN docCursor;            
    FETCH NEXT FROM docCursor INTO @CurrentDocumentID;            

    WHILE @@FETCH_STATUS = 0            
    BEGIN            
        -- Check if the document is already linked
        IF EXISTS (SELECT 1 FROM LinkedDocuments WHERE ParentID = @ParentID AND ParentTypeID = @ParentTypeID AND DocumentID = @CurrentDocumentID)
        BEGIN
            SET @AlreadyLinked = 1;
        END
        ELSE 
        BEGIN
            -- Insert the document if not already linked
            INSERT INTO LinkedDocuments (ParentID, ParentTypeID, DocumentID)            
            VALUES (@ParentID, @ParentTypeID, @CurrentDocumentID);
        END

        FETCH NEXT FROM docCursor INTO @CurrentDocumentID;            
    END            

    CLOSE docCursor;            
    DEALLOCATE docCursor;            

    -- Return appropriate success or warning message      
    IF @AlreadyLinked = 1
        SELECT '201' AS returnCode, 'This document is already linked. Please check and try again.' AS returnMessage;
    ELSE
        SELECT '200' AS returnCode, 'Document linked successfully.' AS returnMessage;
END
