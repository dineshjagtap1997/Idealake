--==    
CREATE PROCEDURE [dbo].[usp_DeleteLinkedDocuments]    
(    
    @DocumentLinkID INT    
)    
AS    
BEGIN    
    SET NOCOUNT ON;
    
    -- Check if the DocumentLinkID exists
    IF EXISTS (SELECT 1 FROM LinkedDocuments WHERE DocumentLinkID = @DocumentLinkID)
    BEGIN
        -- Delete the record
        DELETE FROM LinkedDocuments WHERE DocumentLinkID = @DocumentLinkID;
        
        -- Return success message
        SELECT 200 AS returnCode, 'Delinked Successfully' AS returnMessage;
    END
    ELSE
    BEGIN
        -- Return failure message
        SELECT 404 AS returnCode, 'Document Not Linked ' AS returnMessage;
    END
END;
 