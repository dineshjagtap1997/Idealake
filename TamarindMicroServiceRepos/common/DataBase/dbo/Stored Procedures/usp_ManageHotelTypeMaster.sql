CREATE PROCEDURE [dbo].[usp_ManageHotelTypeMaster] (          
 @Action VARCHAR(2) = ''          
 ,-- 'GET', 'INSERT', or 'UPDATE'                
 @HotelTypeID INT = NULL          
 ,-- Required for 'UPDATE'                
 @TypeValue VARCHAR(200) = NULL          
 ,-- Required for 'INSERT' or 'UPDATE'                
 @IsActive BIT = NULL          
 ,-- Optional for 'GET', 'INSERT', or 'UPDATE'                
 @OperationBy UNIQUEIDENTIFIER = NULL -- Required for 'INSERT' or 'UPDATE'                
 --@ErrMsg VARCHAR(50) OUT -- Output parameter for error messages                
 )          
AS          
BEGIN          
 SET NOCOUNT ON;          
    declare @LogID int ;       
 -- Handle 'GET' action                
 IF @Action = 'S'          
 BEGIN          
          
   SELECT HotelTypeID          
    ,TypeValue          
    ,IsActive          
   FROM HotelTypeMaster          
   WHERE (          
     @HotelTypeID IS NULL          
     OR @HotelTypeID = 0          
     OR HotelTypeID = @HotelTypeID          
     )          
   ORDER BY HotelTypeID DESC;          
          
 END          
IF @Action='EX'
BEGIN
 SELECT TypeValue          
   ,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive          
   FROM HotelTypeMaster          
   WHERE (          
     @HotelTypeID IS NULL          
     OR @HotelTypeID = 0          
     OR HotelTypeID = @HotelTypeID          
     )          
   ORDER BY HotelTypeID DESC; 
END
 -- Handle 'INSERT' action                
 IF @Action = 'I'          
 BEGIN          
  IF EXISTS (          
    SELECT 1          
    FROM HotelTypeMaster          
    WHERE UPPER(TypeValue) = UPPER(@TypeValue)          
    )          
  BEGIN       
   SELECT '201' AS returnCode,'Hotel Type already exists. Please check and try again.' AS returnMessage, @LogID as ID      
  END          
  ELSE          
  BEGIN          
   INSERT INTO HotelTypeMaster (          
    TypeValue          
    ,IsActive          
    ,Operation          
    ,OperationBy          
    ,InsertedDatetime          
    )          
   VALUES (          
    @TypeValue          
    ,@IsActive          
    ,'Insert'          
    ,@OperationBy          
    ,GETDATE()          
    );          
          
   SET @LogID = SCOPE_IDENTITY()    
     SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @LogID AS ID         
  END          
          
  RETURN;          
 END          
          
 -- Handle 'UPDATE' action                
 IF @Action = 'U'          
 BEGIN          
  IF NOT EXISTS (          
    SELECT 1          
    FROM HotelTypeMaster          
    WHERE UPPER(TypeValue) = UPPER(@TypeValue)          
     AND HotelTypeID <> @HotelTypeID          
    )          
  BEGIN          
   UPDATE HotelTypeMaster          
   SET TypeValue = @TypeValue          
    ,IsActive = @IsActive          
    ,Operation = 'Update'          
    ,OperationBy = @OperationBy          
    ,InsertedDatetime = GETDATE()          
   WHERE HotelTypeID = @HotelTypeID;     
       
       
          
SELECT '200' AS returnCode                                                    
    ,'Record updated successfully.' AS returnMessage, @HotelTypeID AS ID           
  END          
  ELSE          
  BEGIN          
   SELECT '201' AS returnCode,'Hotel Type already exists. Please check and try again.' AS returnMessage      
  END          
          
  RETURN;          
 END          
 ELSE          
 BEGIN          
 SELECT '201' AS returnCode, 'Invalid action specified.' AS returnMessage          
 END          
END;