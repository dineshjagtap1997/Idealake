<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_CountryMarketMapping_Master]               
    @Country_IATACode NVARCHAR(MAX) = NULL,                
    @CountryName VARCHAR(50) = '',                
    @Market_ID INT = NULL,                
    @MarketName VARCHAR(50) = NULL,                
    @IsActive BIT = 1,                
    @OperationBy UNIQUEIDENTIFIER = NULL,                
    @ID INT = NULL,                
    @Action CHAR(2) = ''                
AS                
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @LogID INT;  
    DECLARE @returnCode NVARCHAR(3) = '200';                
    DECLARE @returnMessage NVARCHAR(MAX) = 'Success';
    DECLARE @CurrentCode CHAR(4);
    
    -- VALIDATION: Ensure parameters are provided when needed
    IF @Action IN ('I', 'U') AND (@Country_IATACode IS NULL OR @Market_ID IS NULL)
    BEGIN
        SELECT '400' AS returnCode, 'Country code and Market ID are required' AS returnMessage;
        RETURN;
    END
    
    IF @Action = 'I'                
    BEGIN
        -- Split input if multiple codes provided (though UI should prevent this)
        DECLARE @IATACodes TABLE (Code CHAR(4));
        INSERT INTO @IATACodes
        SELECT DISTINCT TRIM(value) FROM STRING_SPLIT(@Country_IATACode, ',');
        
        -- Process each country code
        DECLARE code_cursor CURSOR FOR SELECT Code FROM @IATACodes;
        OPEN code_cursor;
        FETCH NEXT FROM code_cursor INTO @CurrentCode;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Check if country already mapped to ANY market
            IF EXISTS (SELECT 1 FROM CountryMarket_Mapping 
                      WHERE Country_IATACode = @CurrentCode)
            BEGIN
                CLOSE code_cursor;
                DEALLOCATE code_cursor;
                SELECT '409' AS returnCode, 
                       'Country ' + @CurrentCode + ' is already mapped to a market' AS returnMessage;
                RETURN;
            END
            
            -- Get market name if not provided
            IF @MarketName IS NULL
                SELECT @MarketName = Name FROM Market WHERE id = @Market_ID;
            
            -- Insert new mapping
            INSERT INTO CountryMarket_Mapping (
                Country_IATACode, CountryName, Market_ID, 
                MarketName, IsActive, Operation, 
                OperationBy, OperationOn
            ) VALUES (
                @CurrentCode, @CountryName, @Market_ID,
                @MarketName, @IsActive, 'Insert',
                @OperationBy, GETDATE()
            );
            
            SET @LogID = SCOPE_IDENTITY();
            
            FETCH NEXT FROM code_cursor INTO @CurrentCode;
        END
        
        CLOSE code_cursor;
        DEALLOCATE code_cursor;
        
        SELECT '200' AS returnCode, 'Mapping created successfully' AS returnMessage, @LogID AS ID;
    END
    ELSE IF @Action = 'U'
    BEGIN
        -- Get current mapping
        DECLARE @ExistingCountryCode CHAR(4);
        SELECT @ExistingCountryCode = Country_IATACode 
        FROM CountryMarket_Mapping 
        WHERE ID = @ID;
        
        -- If changing country code, validate it's not already mapped to another market (exclude current record)
        IF @Country_IATACode <> @ExistingCountryCode
            AND EXISTS (
                SELECT 1 FROM CountryMarket_Mapping 
                WHERE Country_IATACode = @Country_IATACode
                  AND ID <> @ID
            )
        BEGIN
            SELECT '409' AS returnCode, 
                   'Country ' + @Country_IATACode + ' is already mapped to another market' AS returnMessage;
            RETURN;
        END
        
        -- Get market name if not provided
        IF @MarketName IS NULL
            SELECT @MarketName = Name FROM Market WHERE id = @Market_ID;
        
        -- Update the mapping
        UPDATE CountryMarket_Mapping
        SET Country_IATACode = @Country_IATACode,
            CountryName = @CountryName,
            Market_ID = @Market_ID,
            MarketName = @MarketName,
            IsActive = @IsActive,
            Operation = 'Update',
            UpdatedBy = @OperationBy,
            UpdatedOn = GETDATE()
        WHERE ID = @ID;
        
        SELECT '200' AS returnCode, 'Mapping updated successfully' AS returnMessage, @ID AS ID;
    END
    ELSE IF @Action = 'S'
    BEGIN
        SELECT 
            CM.ID,
            CM.Country_IATACode,
            C.Name AS CountryName,
            CM.Market_ID,
            CM.MarketName,
            CM.IsActive
        FROM CountryMarket_Mapping CM
        INNER JOIN Country C ON C.IATACode = CM.Country_IATACode
        --WHERE (@ID IS NULL OR CM.ID = @ID)
        ORDER BY CM.ID DESC;
    END
    ELSE IF @Action = 'D'
    BEGIN
        DELETE FROM CountryMarket_Mapping WHERE ID = @ID;
        SELECT '200' AS returnCode, 'Mapping deleted successfully' AS returnMessage, @ID AS ID;
    END
    ELSE
    BEGIN
        SELECT '400' AS returnCode, 'Invalid action specified' AS returnMessage;
    END
END
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿
CREATE PROCEDURE [dbo].[usp_CountryMarketMapping_Master]               

    @Country_IATACode NVARCHAR(MAX) = NULL,                

    @CountryName VARCHAR(50) = '',                

    @Market_ID INT = NULL,                

    @MarketName VARCHAR(50) = NULL,                

    @IsActive BIT = 1,                

    @OperationBy UNIQUEIDENTIFIER = NULL,                

    @ID INT = NULL,                

    @Action CHAR(2) = ''                

AS                

BEGIN

    SET NOCOUNT ON;

    DECLARE @LogID INT;  

    DECLARE @returnCode NVARCHAR(3) = '200';                

    DECLARE @returnMessage NVARCHAR(MAX) = 'Success';

    DECLARE @CurrentCode CHAR(4);

    -- VALIDATION: Ensure parameters are provided when needed

    IF @Action IN ('I', 'U') AND (@Country_IATACode IS NULL OR @Market_ID IS NULL)

    BEGIN

        SELECT '400' AS returnCode, 'Country code and Market ID are required' AS returnMessage;

        RETURN;

    END

    IF @Action = 'I'                

    BEGIN

        -- Split input if multiple codes provided (though UI should prevent this)

        DECLARE @IATACodes TABLE (Code CHAR(4));

        INSERT INTO @IATACodes

        SELECT DISTINCT TRIM(value) FROM STRING_SPLIT(@Country_IATACode, ',');

        -- Process each country code

        DECLARE code_cursor CURSOR FOR SELECT Code FROM @IATACodes;

        OPEN code_cursor;

        FETCH NEXT FROM code_cursor INTO @CurrentCode;

        WHILE @@FETCH_STATUS = 0

        BEGIN

            -- Check if country already mapped to ANY market

            IF EXISTS (SELECT 1 FROM CountryMarket_Mapping 

                      WHERE Country_IATACode = @CurrentCode)

            BEGIN

                CLOSE code_cursor;

                DEALLOCATE code_cursor;

                SELECT '409' AS returnCode, 

                       'Country ' + @CurrentCode + ' is already mapped to a market' AS returnMessage;

                RETURN;

            END

            -- Get market name if not provided

            IF @MarketName IS NULL

                SELECT @MarketName = Name FROM Market WHERE id = @Market_ID;

            -- Insert new mapping

            INSERT INTO CountryMarket_Mapping (

                Country_IATACode, CountryName, Market_ID, 

                MarketName, IsActive, Operation, 

                OperationBy, OperationOn

            ) VALUES (

                @CurrentCode, @CountryName, @Market_ID,

                @MarketName, @IsActive, 'Insert',

                @OperationBy, GETDATE()

            );

            SET @LogID = SCOPE_IDENTITY();

            FETCH NEXT FROM code_cursor INTO @CurrentCode;

        END

        CLOSE code_cursor;

        DEALLOCATE code_cursor;

        SELECT '200' AS returnCode, 'Mapping created successfully' AS returnMessage, @LogID AS ID;

    END

    ELSE IF @Action = 'U'

    BEGIN

        -- Get current mapping

        DECLARE @ExistingCountryCode CHAR(4);

        SELECT @ExistingCountryCode = Country_IATACode 

        FROM CountryMarket_Mapping 

        WHERE ID = @ID;

        -- If changing country code, validate it's not already mapped to another market (exclude current record)

        IF @Country_IATACode <> @ExistingCountryCode

            AND EXISTS (

                SELECT 1 FROM CountryMarket_Mapping 

                WHERE Country_IATACode = @Country_IATACode

                  AND ID <> @ID

            )

        BEGIN

            SELECT '409' AS returnCode, 

                   'Country ' + @Country_IATACode + ' is already mapped to another market' AS returnMessage;

            RETURN;

        END

        -- Get market name if not provided

        IF @MarketName IS NULL

            SELECT @MarketName = Name FROM Market WHERE id = @Market_ID;

        -- Update the mapping

        UPDATE CountryMarket_Mapping

        SET Country_IATACode = @Country_IATACode,

            CountryName = @CountryName,

            Market_ID = @Market_ID,

            MarketName = @MarketName,

            IsActive = @IsActive,

            Operation = 'Update',

            UpdatedBy = @OperationBy,

            UpdatedOn = GETDATE()

        WHERE ID = @ID;

        SELECT '200' AS returnCode, 'Mapping updated successfully' AS returnMessage, @ID AS ID;

    END

    ELSE IF @Action = 'S'

    BEGIN

        SELECT 

            CM.ID,

            CM.Country_IATACode,

            C.Name AS CountryName,

            CM.Market_ID,

            CM.MarketName,

            CM.IsActive

        FROM CountryMarket_Mapping CM

        INNER JOIN Country C ON C.IATACode = CM.Country_IATACode

        --WHERE (@ID IS NULL OR CM.ID = @ID)

        ORDER BY CM.ID DESC;

    END

	 ELSE IF @Action = 'EX'

    BEGIN

        SELECT 

            CM.ID,

            CM.Country_IATACode,

            C.Name AS CountryName,

            CM.Market_ID,

            CM.MarketName,

            CM.IsActive

        FROM CountryMarket_Mapping CM

        INNER JOIN Country C ON C.IATACode = CM.Country_IATACode

        --WHERE (@ID IS NULL OR CM.ID = @ID)

        ORDER BY CM.ID DESC;

    END

    ELSE IF @Action = 'D'

    BEGIN

        DELETE FROM CountryMarket_Mapping WHERE ID = @ID;

        SELECT '200' AS returnCode, 'Mapping deleted successfully' AS returnMessage, @ID AS ID;

    END

    ELSE

    BEGIN

        SELECT '400' AS returnCode, 'Invalid action specified' AS returnMessage;

    END

END

<<<<<<< HEAD
 
>>>>>>> dev
=======
 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
