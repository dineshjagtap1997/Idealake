CREATE PROCEDURE [dbo].[usp_SpecialServices_Master]                          
    @ID INT =NULL,                          
    @Name VARCHAR(500)=NULL,                          
    @ShortDescription VARCHAR(500)=NULL,                          
    @DetailedDescription VARCHAR(MAX) = NULL,                          
    @IsActive BIT=1,                          
    @OperationBy UNIQUEIDENTIFIER = null,                          
    @IsPreferred BIT = 0,                          
    @Action CHAR(2) = '',                          
    @Active BIT = 1                          
AS                          
BEGIN                          
    DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);                          
    DECLARE @MaxID INT;                          
                          
    IF @Action = 'I'  -- Insert Action                          
    BEGIN                          
        IF EXISTS(SELECT TOP 1 1 FROM SpecialServices WHERE UPPER(Name) = UPPER(@Name))                          
        BEGIN                          
            SELECT '201' AS returnCode, 'Service name already exists. Please check and try again.' AS returnMessage;                          
        END                          
        ELSE                          
        BEGIN                          
            -- Generate new MaxID (OldID)                          
            SET @MaxID = (SELECT ISNULL(MAX(CAST(OldID AS INT)), 0) FROM SpecialServices) + 1;                          
                          
            -- Insert new record into SpecialServices table                          
            INSERT INTO SpecialServices                          
                (Name, ShortDescription, DetailedDescription, IsActive, Operation, OperationBy, OperationOn, OldID, IsPreferred)                          
            VALUES                          
                (@Name, @ShortDescription, @DetailedDescription, @IsActive, 'Insert', @OperationBy, GETDATE(), @MaxID, @IsPreferred);                          
                          
            -- Get the newly inserted record's ID                          
            SET @ID = SCOPE_IDENTITY();                          
                          
            -- Call Audit Procedure for Insert Action                          
            --EXEC usp_InsertSpecialServices_Audit @ID, 'Insert', @OperationBy;                          
                          
            -- Return success message                          
            SET @ReturnCode = '200';                          
            SET @ReturnMessage = 'New record added successfully.';                          
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @ID as ID;                          
        END                          
    END                          
    ELSE IF @Action = 'U'  -- Update Action                          
    BEGIN                          
        -- Check if the name already exists for other records (to avoid duplicates)                          
        IF NOT EXISTS(SELECT TOP 1 1 FROM SpecialServices WHERE Name = @Name AND ID != @ID)                          
        BEGIN                          
            -- Update the record                          
            UPDATE SpecialServices                          
            SET Name = ISNULL(@Name, Name),                         
                ShortDescription = ISNULL(@ShortDescription, ShortDescription),                        
                DetailedDescription = ISNULL(@DetailedDescription, DetailedDescription) ,                       
                IsActive = isnull(@IsActive,IsActive),                          
                Operation = 'Update'                          
    ,UpdatedBy = isnull(@OperationBy,OperationBy)                          
    ,UpdatedOn = GETDATE(),                          
                IsPreferred = isnull(@IsPreferred,IsPreferred)                          
            WHERE ID = @ID;           
                          
            -- Call Audit Procedure for Update Action                          
   --EXEC usp_InsertSpecialServices_Audit @ID, 'Update', @OperationBy;                          
                          
  -- Return success message                          
            SET @ReturnCode = '200';                          
           SET @ReturnMessage = 'Record updated successfully.';                          
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @ID as ID;                          
        END                          
        ELSE                          
        BEGIN                          
            -- Return message if service name already exists                          
            SET @ReturnCode = '201';                          
            SET @ReturnMessage = 'Service name already exists. Please check and try again.';                          
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @ID as ID;                                    
        END                     
    END                          
    ELSE IF @Action = 'S'  -- Select Action                          
    BEGIN                          
        -- If Active filter is applied                          
        IF @Active = 1                          
        BEGIN                          
            -- Select active services and check for images associated                       
            SELECT ID, Name, ShortDescription, DetailedDescription, IsActive, IsPreferred,                          
                ImageExists = CASE WHEN EXISTS (SELECT ID FROM UploadImage WHERE ParentPageType = 3 AND ParentID = SS.ID) THEN 1 ELSE 0 END                          
            FROM SpecialServices SS                          
            WHERE  (@ID IS NULL OR @ID = 0 OR ID = @ID)                        
            ORDER BY ID DESC;                          
                          
            -- Select the first image record if exists                          
            SELECT TOP 1 ID, ParentID, ParentPageType, ImageName, [Image]                          
            FROM UploadImage;                          
                          
            -- Return success message                          
            SET @ReturnCode = '200';                          
            SET @ReturnMessage = 'Success';                          
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                          
        END                          
        ELSE                          
        BEGIN                          
            -- Select all services without filter                          
            SELECT ID, Name, ShortDescription, DetailedDescription, IsActive, IsPreferred,                          
                ImageExists = CASE WHEN EXISTS (SELECT ID FROM UploadImage WHERE ParentPageType = 3 AND ParentID = SS.ID) THEN 1 ELSE 0 END                          
            FROM SpecialServices SS where (@ID IS NULL OR @ID = 0 OR ID = @ID)                      
   order by 1 desc;                          
                          
            -- Select the first image record if exists                          
            SELECT TOP 1 ID, ParentID, ParentPageType, ImageName, [Image]                          
            FROM UploadImage;                          
                          
        END                          
    END          
 ELSE IF @Action = 'EX'                        
    BEGIN                          
          IF @Active = 1                          
        BEGIN                          
            -- Select active services and check for images associated                       
            SELECT  Name, ShortDescription, DetailedDescription,CASE           
        WHEN IsActive = 1 THEN 'True'          
        WHEN IsActive = 0 THEN 'False'          
    END AS IsActive  ,CASE           
        WHEN IsPreferred = 1 THEN 'Yes'          
        WHEN IsPreferred = 0 THEN 'No'          
    END AS IsPreferred,                          
                ImageExists = CASE WHEN EXISTS (SELECT ID FROM UploadImage WHERE ParentPageType = 3 AND ParentID = SS.ID) THEN 1 ELSE 0 END                          
            FROM SpecialServices SS                          
            WHERE  (@ID IS NULL OR @ID = 0 OR ID = @ID)                        
            ORDER BY ID DESC;                          
                          
            -- Select the first image record if exists                          
            SELECT TOP 1  ImageName, [Image]                          
            FROM UploadImage;                          
                          
            -- Return success message                          
            SET @ReturnCode = '200';                          
            SET @ReturnMessage = 'Success';                          
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                          
        END                          
        ELSE                          
        BEGIN                          
            -- Select all services without filter                          
            SELECT Name, ShortDescription, DetailedDescription,CASE           
        WHEN IsActive = 1 THEN 'True'          
        WHEN IsActive = 0 THEN 'False'          
    END AS IsActive  ,CASE           
        WHEN IsPreferred = 1 THEN 'Yes'          
        WHEN IsPreferred = 0 THEN 'No'          
    END AS IsPreferred,ImageExists = CASE WHEN EXISTS (SELECT ID FROM UploadImage WHERE ParentPageType = 3 AND ParentID = SS.ID) THEN 1 ELSE 0 END                          
            FROM SpecialServices SS where (@ID IS NULL OR @ID = 0 OR ID = @ID)                      
   order by 1 desc;                          
                          
            -- Select the first image record if exists                          
            SELECT TOP 1  ImageName, [Image]                          
            FROM UploadImage;                          
                          
        END                      
    END        
    ELSE                          
    BEGIN                          
        -- Return error if action is not found                          
        SET @ReturnCode = '201';                          
        SET @ReturnMessage = 'Action Not Found';                          
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                          
    END                          
END 