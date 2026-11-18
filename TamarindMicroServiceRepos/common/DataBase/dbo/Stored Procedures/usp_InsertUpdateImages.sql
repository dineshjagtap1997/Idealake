CREATE PROCEDURE [dbo].[usp_InsertUpdateImages]        
(        
    @ID INT,              
    @ParentID INT,              
    @ParentPageType INT,              
    @ImageName VARCHAR(200),              
    @Image VARBINARY(MAX)              
)        
AS              
BEGIN              
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM UploadImage WHERE ID = @ID)        
        BEGIN        
            IF @Image IS NOT NULL      
            BEGIN      
                UPDATE UploadImage 
                SET ParentID = @ParentID,        
                    ParentPageType = @ParentPageType,        
                    ImageName = REPLACE(@ImageName, ' ', '_'),         
                    [Image] = @Image        
                WHERE ID = @ID;        
            END        
        END        
        ELSE        
        BEGIN        
            INSERT INTO UploadImage (ParentID, ParentPageType, ImageName, [Image])              
            VALUES (@ParentID, @ParentPageType, REPLACE(@ImageName, ' ', '_'), @Image);
        END
        
        SELECT 1 AS Status, 'Operation Successful' AS Message;
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
