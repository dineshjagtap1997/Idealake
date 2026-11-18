CREATE PROCEDURE [dbo].[usp_PLBMaster]              
(              
    @Action CHAR(1), -- 'I' for Insert, 'U' for Update, 'S' for Select              
    @PLBID INT = NULL, -- Used for Update and Select              
    @CityCode CHAR(3) = NULL,              
    @HotelID INT = NULL,              
    @ValidFrom DATETIME = NULL,              
    @ValidTo DATETIME = NULL,              
    @Target VARCHAR(40) = NULL,              
    @ValidonRateType VARCHAR(50) = NULL,              
    @PLBClaim VARCHAR(50) = NULL,              
    @PLBType VARCHAR(20) = NULL,              
    @ClaimPeriod VARCHAR(20) = NULL,              
    @IsActive VARCHAR(20) = 0 ,  
 @HotelGroupID INT = NULL,  
 @OperationBy uniqueidentifier = NULL  
  
)              
AS              
BEGIN              
    SET NOCOUNT ON;              
              
    BEGIN TRY   
	
	 DECLARE @LogID int;  

        IF @Action = 'I' -- Insert logic              
        BEGIN              
            -- Check for mandatory fields              
            IF @CityCode IS NULL OR @HotelID IS NULL OR @ValidFrom IS NULL OR @ValidTo IS NULL              
            BEGIN              
                SELECT '201' AS returnCode, 'Mandatory fields are missing for Insert.' AS returnMessage, @LogID AS ID;              
                RETURN;              
            END              
      
            -- Check if the data already exists              
            IF NOT EXISTS (              
                SELECT 1              
                FROM [PLBMaster]              
                WHERE [CityCode] = @CityCode              
                  AND [HotelID] = @HotelID              
                  AND [ValidFrom] = @ValidFrom              
                  AND [ValidTo] = @ValidTo              
            )              
            BEGIN              
                -- Insert the new record              
                INSERT INTO [PLBMaster]              
                (              
                    [CityCode],              
                    [HotelID],              
                    [ValidFrom],              
                    [ValidTo],              
                    [Target],              
                    [ValidonRateType],              
                    [PLBClaim],              
                    [PLBType],              
                    [ClaimPeriod],              
                    [IsActive],              
                    [Operation],              
                    [OperationBy],              
                    [OperationOn],  
     [HotelGroupID]  
                )              
                VALUES              
                (              
                    @CityCode,              
                    @HotelID,              
                    @ValidFrom,              
                    @ValidTo,              
                    @Target,              
                    @ValidonRateType,              
                    @PLBClaim,              
                    @PLBType,              
                    @ClaimPeriod,              
                    @IsActive,              
                    'INS',              
                    @OperationBy,              
                    GETDATE() ,  
     @HotelGroupID  
                );  
				

                SET @LogID = SCOPE_IDENTITY()      
                SELECT '200' AS returnCode, 'Data inserted successfully.' AS returnMessage, @LogID AS ID;              
            END              
            ELSE              
            BEGIN              
                SELECT '202' AS returnCode, 'Data already exists. No new record inserted.' AS returnMessage;              
            END              
        END              
              
        ELSE IF @Action = 'U' -- Update logic              
        BEGIN              
            IF @PLBID IS NULL OR @CityCode IS NULL OR @HotelID IS NULL              
            BEGIN              
                SELECT '201' AS returnCode, 'Mandatory fields are missing for Update.' AS returnMessage;              
                RETURN;     
            END              
      
            -- Update the record              
            UPDATE [PLBMaster]              
            SET              
                [CityCode] = @CityCode,              
 [HotelID] = @HotelID,              
                [ValidFrom] = @ValidFrom,              
                [ValidTo] = @ValidTo,              
                [Target] = @Target,              
     [ValidonRateType] = @ValidonRateType,              
                [PLBClaim] = @PLBClaim,              
                [PLBType] = @PLBType,              
                [ClaimPeriod] = @ClaimPeriod,              
                [IsActive] = @IsActive,              
                [Operation] = 'UPD',              
                [UpdatedBy] = @OperationBy,              
                [UpdatedOn] = GETDATE(),  
    [HotelGroupID]=@HotelGroupID  
            WHERE [ID] = @PLBID;              
      
            IF @@ROWCOUNT = 0              
            BEGIN              
                SELECT '201' AS returnCode, 'No matching record found for Update.' AS returnMessage;              
                RETURN;              
            END              
            ELSE              
            BEGIN              
                SELECT '200' AS returnCode, 'Data updated successfully.' AS returnMessage , @PLBID AS ID;             
            END              
        END              
              
        ELSE IF @Action = 'S' -- Select logic              
        BEGIN            
            SELECT              
                PM.ID AS PLBID,              
                [CityCode],     
    C.Name As CityName,    
                PM.[HotelID],    
    HM.HotelName,  
                PM.[ValidFrom],              
                [ValidTo],              
                [Target],              
                [ValidonRateType],              
                [PLBClaim],              
                [PLBType],              
                [ClaimPeriod],              
                PM.[IsActive],              
                PM.[Operation],              
               PM. [OperationBy],              
                PM.[OperationOn] ,  
      
    HG.Name as HotelGroupName,  
    HG.IATACode,  
    HG.HotelGroupID  
            FROM [PLBMaster] PM    
   INNER JOIN  City C ON PM.CityCode=C.IATACode   
   INNER JOIN HotelMaster HM ON HM.HotelID= PM.HotelID  
    INNER JOIN HotelGroups HG ON HG.HotelGroupID= PM.HotelGroupID  
            WHERE       
         --     (@ClaimPeriod IS NULL OR @ClaimPeriod = ClaimPeriod)      
         --AND     
   (@PLBID IS NULL OR @PLBID = 0 OR  PM.ID = @PLBID)  
   ORDER by PM.ID DESC  
        END              
              
        ELSE              
        BEGIN              
            SELECT '201' AS returnCode, 'Invalid Action performed!' AS returnMessage;              
        END              
    END TRY              
    BEGIN CATCH              
        SELECT ERROR_NUMBER() AS returnCode, ERROR_MESSAGE() AS returnMessage;              
    END CATCH;              
END; 