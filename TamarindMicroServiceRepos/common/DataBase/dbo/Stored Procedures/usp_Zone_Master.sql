ALTER PROCEDURE [dbo].[usp_Zone_Master] @ZoneID INT = NULL    
 ,@ZoneName VARCHAR(50) = ''    
 ,@HeaderInfo_Zone VARCHAR(50) = ''    
 ,-- Additional header field for zones                            
 @IsActive BIT = ''    
 ,@OperationBy UNIQUEIDENTIFIER = NULL    
 ,@Action CHAR(2) = ''    
AS    
BEGIN    
 DECLARE @ReturnCode NVARCHAR(3)    
  ,@ReturnMessage NVARCHAR(MAX);    
    
 IF @Action = 'I'    
 BEGIN    
  -- Check if the zone already exists                      
  IF EXISTS (    
    SELECT 1    
    FROM ZoneMaster    
    WHERE UPPER(ZoneName) = UPPER(@ZoneName)    
    )    
  BEGIN    
   SET @ReturnCode = '201';    
   SET @ReturnMessage = 'Zone name already exists. Please check and try again.';    
    
   SELECT @ReturnCode AS returnCode    
    ,@ReturnMessage AS returnMessage;    
    
   RETURN;    
  END    
  ELSE    
  BEGIN    
   -- Insert the new zone                            
   INSERT INTO ZoneMaster (    
    ZoneName    
    ,HeaderInfo_Zone    
    ,IsActive    
    ,Operation    
    ,OperationBy    
    ,OperationOn    
    )    
   VALUES (    
    @ZoneName    
    ,@HeaderInfo_Zone    
    ,@IsActive    
    ,'Insert'    
    ,@OperationBy    
    ,GETDATE()    
    );    
    
   -- Capture the new ID for the inserted zone                            
   DECLARE @NewZoneID INT = SCOPE_IDENTITY();    
    
   -- Audit call can be added here if applicable                            
   -- EXEC usp_InsertZone_Audit @ZoneID = @NewZoneID, @Operation = 'Insert', @OperationBy = @OperationBy;                            
   SET @ReturnCode = '200';    
   SET @ReturnMessage = 'New record added successfully.';    
    
   SELECT @ReturnCode AS returnCode    
    ,@ReturnMessage AS returnMessage    
    ,@NewZoneID AS ID;    
  END    
 END    
 ELSE IF @Action = 'U'    
 BEGIN    
  -- Check if the zone name exists with a different ID                            
  IF NOT EXISTS (    
    SELECT 1    
    FROM ZoneMaster    
    WHERE UPPER(ZoneName) = UPPER(@ZoneName)    
     AND ZoneID != @ZoneID    
    )    
  BEGIN    
   -- Update the zone record                            
   UPDATE ZoneMaster    
   SET ZoneName = @ZoneName    
    ,HeaderInfo_Zone = @HeaderInfo_Zone    
    ,IsActive = @IsActive    
    ,Operation = 'Update'    
    ,UpdatedBy = @OperationBy    
    ,UpdatedOn = GETDATE()    
   WHERE ZoneID = @ZoneID;    
    
   -- Audit call can be added here if applicable                            
   -- EXEC usp_InsertZone_Audit @ZoneID = @ZoneID, @Operation = 'Update', @OperationBy = @OperationBy;                            
   SET @ReturnCode = '200';    
   SET @ReturnMessage = 'Record updated successfully.';    
    
   SELECT @ReturnCode AS returnCode    
    ,@ReturnMessage AS returnMessage    
    ,@ZoneID AS ID;    
  END    
  ELSE    
  BEGIN    
   SET @ReturnCode = '201';    
   SET @ReturnMessage = 'Zone name already exists. Please check and try again.';    
    
   SELECT @ReturnCode AS returnCode    
    ,@ReturnMessage AS returnMessage;    
  END    
 END    
 ELSE IF @Action = 'S'    
    
  BEGIN    
   SELECT zm.ZoneID    
    ,zm.ZoneName    
    ,zm.HeaderInfo_Zone    
    ,zm.IsActive    
     ,HM.HotelName          
    ,C.Name AS CityName    
   FROM ZoneMaster ZM    
   LEFT JOIN HotelMaster HM ON HM.ZoneID = ZM.ZoneID    
   LEFT JOIN City C ON C.IATACode = HM.CityIATACode    
   WHERE (    
     @ZoneID IS NULL    
     OR @ZoneID = 0    
     OR zm.ZoneID = @ZoneID    
     )    
   ORDER BY ZoneID DESC;    
  END    
   --    ELSE                            
   --    BEGIN                            
   --        SELECT ZoneID, ZoneName, HeaderInfo_Zone, IsActive                            
   --        FROM ZoneMaster                            
   --        WHERE IsActive = 1   AND (                       
   --@ZoneID IS NULL                       
   --OR @ZoneID = 0                       
   --OR ZoneID = @ZoneID                       
   --)                         
   --        ORDER BY ZoneID;                            
   --    END       
   --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;  
   
    ELSE IF @Action = 'F'    
    
  
BEGIN
    SELECT 
        ZM.ZoneID,
        ZM.ZoneName,
        ZM.HeaderInfo_Zone,
        ZM.IsActive,

        -- Comma-separated list of hotel names
        STRING_AGG(HM.HotelName, ',') AS HotelName,

        -- Comma-separated list of city names (could have duplicates)
        STRING_AGG(C.Name, ',') AS CityName

    FROM ZoneMaster ZM
    LEFT JOIN HotelMaster HM ON HM.ZoneID = ZM.ZoneID
    LEFT JOIN City C ON C.IATACode = HM.CityIATACode
    WHERE (@ZoneID IS NULL OR ZM.ZoneID = @ZoneID)
    GROUP BY 
        ZM.ZoneID, ZM.ZoneName, ZM.HeaderInfo_Zone, ZM.IsActive
		  ORDER BY ZM.ZoneID DESC
END
  
    
   ELSE IF @Action='EX'  
   BEGIN  
     SELECT  
    zm.ZoneName    
    ,zm.IsActive    
    -- ,HM.HotelName          
   -- ,C.Name AS CityName    
   FROM ZoneMaster ZM    
   --INNER JOIN HotelMaster HM ON HM.ZoneID = ZM.ZoneID    
   --INNER JOIN City C ON C.IATACode = HM.CityIATACode    
   WHERE (    
     @ZoneID IS NULL    
     OR @ZoneID = 0    
     OR zm.ZoneID = @ZoneID    
     )    
   ORDER BY ZoneID DESC;    
   END  
 ELSE    
 BEGIN    
  -- Handle invalid action                            
  SET @ReturnCode = '201';    
  SET @ReturnMessage = 'Invalid Action!';    
    
  SELECT @ReturnCode AS returnCode    
   ,@ReturnMessage AS returnMessage;    
 END    
END