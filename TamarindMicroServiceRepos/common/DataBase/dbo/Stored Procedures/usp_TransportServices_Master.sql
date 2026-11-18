
CREATE PROCEDURE [dbo].[usp_TransportServices_Master]                
    @Code INT = NULL,                              
    @Name VARCHAR(500) = '',                                  
    @ModeOfTransport TINYINT = NULL,                            
    @ShortDescription VARCHAR(500) = '',                                  
    @DetailedDescription VARCHAR(MAX) = '',                                  
    @IsActive BIT = 1,                                  
    @OperationBy UNIQUEIDENTIFIER = NULL,                         
    @IsPreferred BIT = 0,                      
    @Pickup INT = NULL,                    
    @DropOff INT = NULL,                   
    @TotalDays BIGINT = NULL,                   
    @IsViceVersa BIT = 0,                           
    @Action CHAR(2) = ''                
AS                
BEGIN                
    SET NOCOUNT ON;                

    DECLARE                  
<<<<<<< HEAD
<<<<<<< HEAD
        @ReturnCode NVARCHAR(3),                
=======
        @ReturnCode NVARCHAR(10),                
>>>>>>> dev
=======
        @ReturnCode NVARCHAR(10),                
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        @ReturnMessage NVARCHAR(MAX);            

    BEGIN TRY                
        IF UPPER(@Action) = 'I'                
        BEGIN                                  
            IF EXISTS (SELECT 1 FROM TransportServices WHERE UPPER(Name) = UPPER(@Name))                                  
            BEGIN                                  
                SET @ReturnCode = '201';                    
                SET @ReturnMessage = 'Service Name already exists. Please check and try again.';                                        
                SET @Code = 0;                              
            END                                  
            ELSE                                  
            BEGIN                                  
                INSERT INTO TransportServices                                  
                    (Name, ModeOfTransport, ShortDescription, DetailedDescription, IsActive, Operation, OperationBy,                  
                     OperationOn, IsPreferred, Pickup, DropOff, IsViceVersa, TotalDays)                                  
                VALUES                   
                    (@Name, @ModeOfTransport, @ShortDescription, @DetailedDescription, @IsActive, 'Insert', @OperationBy,                  
                     GETDATE(), @IsPreferred, @Pickup, @DropOff, @IsViceVersa, @TotalDays);                

                SET @Code = SCOPE_IDENTITY();                
                SET @ReturnCode = '200';                    
                SET @ReturnMessage = 'New record added successfully.';                

<<<<<<< HEAD
<<<<<<< HEAD
                EXEC usp_InsertTransportServices_Audit                 
                    @Code, 'Insert', @OperationBy, @Name, @ModeOfTransport, @ShortDescription,                  
                    @DetailedDescription, @IsActive, @IsPreferred, @Pickup, @DropOff, @IsViceVersa, @TotalDays;                
=======
                       
>>>>>>> dev
=======
                       
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            END                                  
        END -- Insert                

        ELSE IF UPPER(@Action) = 'U'                
        BEGIN                              
            IF NOT EXISTS (SELECT 1 FROM TransportServices WHERE UPPER(Name) = UPPER(@Name) AND Code != @Code)                              
            BEGIN                              
                UPDATE TransportServices                              
                SET                  
                    Name = @Name,                              
                    ModeOfTransport = @ModeOfTransport,      
                    ShortDescription = @ShortDescription,                              
                    DetailedDescription = @DetailedDescription,                               
                    IsActive = @IsActive,                              
                    Operation = 'Update',                          
                    UpdatedBy = @OperationBy,                
                    UpdatedOn = GETDATE(),           
                    IsPreferred = @IsPreferred,                  
                    Pickup = @Pickup,                    
                    DropOff = @DropOff,                       
                    IsViceVersa = @IsViceVersa,                  
                    TotalDays = @TotalDays                             
                WHERE Code = @Code;                
<<<<<<< HEAD
<<<<<<< HEAD

                EXEC usp_InsertTransportServices_Audit                 
                    @Code, 'Update', @OperationBy, @Name, @ModeOfTransport, @ShortDescription,                  
                    @DetailedDescription, @IsActive, @IsPreferred, @Pickup, @DropOff, @IsViceVersa, @TotalDays;                
=======
              
>>>>>>> dev
=======
              
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

                SET @ReturnCode = '200';                    
                SET @ReturnMessage = 'Record updated successfully.';               
            END                   
            ELSE                              
            BEGIN                              
                SET @ReturnCode = '201';                    
                SET @ReturnMessage = 'Service Name already exists. Please check and try again.';                
            END                              
        END -- Update            

       ELSE IF UPPER(@Action) = 'EX'                
BEGIN                
    SELECT                 
        Code,
        Name,                                      
        CASE ModeOfTransport
            WHEN 1 THEN 'Transfer'
            WHEN 2 THEN 'Tours'
            WHEN 3 THEN 'Excursions'
            ELSE ''
        END AS ModeOfTransport1,                
        IsActive,             -- Keep BIT
        IsPreferred,          -- Keep BIT
        CASE                 
            WHEN EXISTS (SELECT 1 FROM UploadImage WHERE ParentPageType = 2 AND ParentID = ts.Code) THEN 1                                        
            ELSE 0                 
        END AS ImageExists                
    FROM TransportServices ts
    WHERE (@Code IS NULL OR @Code = 0 OR Code = @Code)
    ORDER BY Code DESC;

    SET @ReturnCode = '200';                    
    SET @ReturnMessage = 'Export fetched successfully.';
END 
            

        ELSE IF UPPER(@Action) = 'S'
        BEGIN
            SELECT 
                Code, 
                Name,
                CASE ModeOfTransport
                    WHEN 1 THEN 'Transfer'
                    WHEN 2 THEN 'Tours'
                    WHEN 3 THEN 'Excursions'
                    ELSE ''
                END AS MOT,
                ModeOfTransport,
                ShortDescription, 
                DetailedDescription, 
                IsActive, 
                IsPreferred,
                CASE 
                    WHEN EXISTS (SELECT 1 FROM UploadImage WHERE ParentPageType = 2 AND ParentID = ts.Code) 
                    THEN 1 
                    ELSE 0 
                END AS ImageExists,
                Pickup, 
                DropOff, 
                IsViceVersa, 
                TotalDays,
                CASE Pickup
                    WHEN 1 THEN 'Airport'
                    WHEN 2 THEN 'Hotel'
                    WHEN 3 THEN 'Railway'
                    WHEN 4 THEN 'Port'
                    ELSE ''
                END AS PickupText,
                CASE DropOff
                    WHEN 1 THEN 'Airport'
                    WHEN 2 THEN 'Hotel'
                    WHEN 3 THEN 'Railway'
                    WHEN 4 THEN 'Port'
                    ELSE ''
                END AS DropOffText,
                CASE IsViceVersa
                    WHEN 1 THEN 'Yes'
                    ELSE 'No'
                END AS ViceVersaText
            FROM TransportServices ts
            WHERE (@Code IS NULL OR @Code = 0 OR Code = @Code)
            ORDER BY Code DESC;

            SET @ReturnCode = '200';
            SET @ReturnMessage = 'Records retrieved successfully.';
        END 

        ELSE
        BEGIN
            SET @ReturnCode = '201';
            SET @ReturnMessage = 'Invalid Action Specified.';
        END

        -- Final return
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @Code AS ID;

    END TRY                
    BEGIN CATCH                
<<<<<<< HEAD
<<<<<<< HEAD
        SET @ReturnCode = ERROR_NUMBER();                
=======
     --   SET @ReturnCode = ERROR_NUMBER();        
	 SET @ReturnCode = CAST(ERROR_NUMBER() AS NVARCHAR(10));

>>>>>>> dev
=======
     --   SET @ReturnCode = ERROR_NUMBER();        
	 SET @ReturnCode = CAST(ERROR_NUMBER() AS NVARCHAR(10));

>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        SET @ReturnMessage = ERROR_MESSAGE();                
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @Code AS ID;                
    END CATCH         
END
