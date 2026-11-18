CREATE PROCEDURE [dbo].[usp_DeleteImages]      
@ID INT      
AS      
BEGIN      
    SET NOCOUNT ON;

    BEGIN TRY
        DELETE FROM UploadImage WHERE ID = @ID;

        IF @@ROWCOUNT = 0
            SELECT 0 AS Status, 'No record found to delete' AS Message;
        ELSE
            SELECT 1 AS Status, 'Image deleted successfully' AS Message;
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
