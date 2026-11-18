<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_MonumentServices_Master] @ID INT = ''                
=======
﻿
CREATE PROCEDURE [dbo].[usp_MonumentServices_Master] @ID INT = ''                
>>>>>>> dev
=======
﻿
CREATE PROCEDURE [dbo].[usp_MonumentServices_Master] @ID INT = ''                
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 ,@Name VARCHAR(500) = ''                
 ,@StateIATACode INT = ''                
 ,@CityIATACode CHAR(3) = ''                
 ,@Timing VARCHAR(50) = ''                
 ,@ClosedOn VARCHAR(200) = ''                
 ,@Holidays VARCHAR(200) = ''                
 ,@Remarks VARCHAR(500) = ''                
 ,@ShortDescription VARCHAR(500) = ''                
 ,@DetailedDescription VARCHAR(MAX) = ''                
 ,@IsActive BIT = ''                
 ,@OperationBy UNIQUEIDENTIFIER = NULL                
 ,@IsPreferred BIT = 0                
 ,@Action CHAR(2) = ''                
 ,@PageNumber BIGINT = NULL                
 ,@PageSize INT = NULL                
AS                
BEGIN                
 -- Procedure body remains the same                          
 DECLARE @OldID VARCHAR(10)                
  ,@ReturnCode NVARCHAR(3)                
  ,@ReturnMessage NVARCHAR(MAX);                
                
 IF @Action = 'I'                
 BEGIN                
  IF EXISTS (                
    SELECT TOP 1 1                
    FROM MonumentService                
    WHERE UPPER(Name) = UPPER(@Name)                
    )                
  BEGIN                
   SET @ReturnCode = '201';                
   SET @ReturnMessage = 'Monument name already exists. Please check and try again.';                
   SET @ID = 0;                
  END                
  ELSE                
  BEGIN                
   SELECT @OldID = @CityIATACode + '' + REPLICATE('0', 3 - LEN(MAX(SUBSTRING(OldID, 4, 3)) + 1)) + '' + CAST(MAX(SUBSTRING(OldID, 4, 3)) + 1 AS VARCHAR(10))                
   FROM MonumentService                
   WHERE City_IATACode = @CityIATACode;                
                
   INSERT INTO MonumentService (                
    Name                
    ,State_IATACode                
    ,City_IATACode                
    ,Timing                
    ,ClosedOn                
    ,Holidays                
    ,Remarks                
    ,ShortDescription                
    ,DetailedDescription                
    ,IsActive                
    ,Operation                
    ,OperationBy                
    ,OperationOn                
    ,OldID                
    ,IsPreferred                
    )                
   VALUES (                
    @Name                
    ,@StateIATACode                
    ,@CityIATACode                
    ,@Timing                
    ,@ClosedOn                
    ,@Holidays                
    ,@Remarks                
    ,@ShortDescription                
    ,@DetailedDescription                
    ,@IsActive                
    ,'Insert'                
    ,@OperationBy                
    ,GETDATE()                
    ,@OldID                
    ,@IsPreferred                
    );                
                
   SET @ReturnCode = '200';                
   SET @ReturnMessage = 'New record added successfully.';                
   SET @ID = @@IDENTITY;                
              
   SELECT @ReturnCode AS returnCode  ,@ReturnMessage AS returnMessage  ,@ID AS ID;               
              
    --EXEC usp_InsertMonumentServices_Audit @@IDENTITY                      
    --,'Insert'                      
    --,@OperationBy;                      
  END                
 END -- I                          
 ELSE IF @Action = 'S'                
 BEGIN                
  IF (                
    @ID IS NULL                
    OR @ID = 0                
    )                
  BEGIN                
   SELECT MS.ID                
    ,MS.Name                
    ,MS.State_IATACode AS StateIATACode                
    ,City_IATACode AS CityIATACode                
    ,Timing                
    ,ClosedOn                
    ,Holidays                
    ,Remarks                
    ,ShortDescription                
    ,DetailedDescription                
    ,MS.IsActive                
    ,MS.IsPreferred                
    ,C.Name AS CityName                
    ,S.Name AS StateName              
    ,ImageExists = CASE                 
     WHEN EXISTS (                
       SELECT ID                
       FROM UploadImage                
       WHERE ParentPageType = 4                
        AND ParentID = MS.ID                
       )                
      THEN 1                
     ELSE 0                
     END                
   FROM MonumentService MS                
   INNER JOIN City C ON C.IATACode = MS.City_IATACode                
   INNER JOIN STATE S ON S.State_ID = MS.State_IATACode                
   ORDER BY MS.ID DESC                
                
   -- added for pagination                        
   -- OFFSET @PageNumber * @PageSize ROWS                      
   --FETCH NEXT @PageSize ROWS ONLY;                     
 SELECT TOP 1 ID                
    ,ParentID                
    ,ParentPageType                
    ,ImageName                
    ,[Image]                
   FROM UploadImage;                
                
   SET @ReturnCode = '200';                
   SET @ReturnMessage = 'Success';                
  END                
  ELSE                
 BEGIN                
   SELECT MS.ID                
    ,MS.Name                
    ,MS.State_IATACode AS StateIATACode                
    ,City_IATACode AS CityIATACode                
    ,Timing                
    ,ClosedOn                
    ,Holidays                
    ,Remarks                
    ,ShortDescription                
    ,DetailedDescription                
    ,MS.IsActive                
    ,MS.IsPreferred                
    ,C.Name AS CityName                
    ,S.Name AS StateName                
    ,ImageExists = CASE                 
     WHEN EXISTS (                
       SELECT ID                
       FROM UploadImage                
       WHERE ParentPageType = 4                
        AND ParentID = MS.ID                
       )                
      THEN 1                
     ELSE 0                
    END                
   FROM MonumentService MS                
   INNER JOIN City C ON C.IATACode = MS.City_IATACode                
   INNER JOIN STATE S ON S.State_ID = MS.State_IATACode                
   --WHERE (                
   --  (                
   --   @IsActive IS NOT NULL                
   --   AND @IsPreferred IS NOT NULL                
   --   AND MS.IsActive = @IsActive                
   --   AND MS.IsPreferred = @IsPreferred                
   --   )                
   --  OR (                
   --   @IsActive IS NOT NULL                
   --   AND @IsPreferred IS NULL                
   --   AND MS.IsActive = @IsActive                
   --   )                
   --  OR (                
   --   @IsActive IS NULL                
   --   AND @IsPreferred IS NOT NULL                
   --   AND MS.IsPreferred = @IsPreferred                
   --   )                
   --  )            
   WHERE            
    (                
     @ID IS NULL                
     OR @ID = 0                
     OR MS.ID = @ID                
     )                
   ORDER BY MS.Name                
                
   -- -- added for pagination                        
   -- OFFSET @PageNumber * @PageSize ROWS                      
   --FETCH NEXT @PageSize ROWS ONLY;                      
   --SELECT TOP 1 ID                      
   -- ,ParentID                      
   -- ,ParentPageType                      
   -- ,ImageName                      
   -- ,[Image]                      
   --FROM UploadImage;                      
   SET @ReturnCode = '200';                
   SET @ReturnMessage = 'Success';                
  END                
 END -- S       
 -- ELSE IF @Action = 'EX'                
 --BEGIN                
 -- IF (                
 --   @ID IS NULL                
 --   OR @ID = 0                
 --   )                
 -- BEGIN                
 --  SELECT                 
 --   MS.Name                
 --   ,Timing                
 --   ,ClosedOn                
 --   ,Holidays                
 --   ,Remarks                
 --   ,CASE   
 --       WHEN MS.IsActive = 1 THEN 'True'  
 --       WHEN MS.IsActive = 0 THEN 'False'  
 --   END AS IsActive   , CASE   
 --       WHEN MS.IsPreferred = 1 THEN 'Yes'  
 --       WHEN MS.IsPreferred = 0 THEN 'No'  
 --   END AS IsPreferred             
 --   ,C.Name AS CityName                
 --   ,S.Name AS StateName                
 --   ,ImageExists = CASE                 
 --    WHEN EXISTS (                
 --      SELECT ID                
 --      FROM UploadImage                
 --      WHERE ParentPageType = 4                
 --       AND ParentID = MS.ID                
 --      )                
 --     THEN 1                
 --    ELSE 0                
 --    END                
 --  FROM MonumentService MS                
 --  INNER JOIN City C ON C.IATACode = MS.City_IATACode                
 --  INNER JOIN STATE S ON S.State_ID = MS.State_IATACode                
 --  ORDER BY MS.ID DESC                
                
 --  -- added for pagination                        
 --  -- OFFSET @PageNumber * @PageSize ROWS                      
 --  --FETCH NEXT @PageSize ROWS ONLY;                     
 --SELECT TOP 1                 
 --   ImageName                
 --   ,[Image]                
 --  FROM UploadImage;                
                
 --  SET @ReturnCode = '200';                
 --  SET @ReturnMessage = 'Success';                
 -- END                
 -- ELSE                
 --BEGIN                
 --  SELECT              
 --   MS.Name                
 --   ,Timing                
 --   ,ClosedOn                
 --   ,Holidays                
 --   ,Remarks                
 --  ,CASE   
 --       WHEN MS.IsActive = 1 THEN 'True'  
 --       WHEN MS.IsActive = 0 THEN 'False'  
 --   END AS IsActive   , CASE   
 --       WHEN MS.IsPreferred = 1 THEN 'Yes'  
 --       WHEN MS.IsPreferred = 0 THEN 'No'  
 --   END AS IsPreferred               
 --   ,C.Name AS CityName                
 --   ,S.Name AS StateName                
 --   ,ImageExists = CASE                 
 --    WHEN EXISTS (                
 --      SELECT ID                
 --      FROM UploadImage                
 --      WHERE ParentPageType = 4                
 --       AND ParentID = MS.ID                
 --      )                
 --     THEN 1                
 --    ELSE 0                
 --   END                
 --  FROM MonumentService MS                
 --  INNER JOIN City C ON C.IATACode = MS.City_IATACode                
 --  INNER JOIN STATE S ON S.State_ID = MS.State_IATACode                
 --  --WHERE (                
 --  --  (                
 --  --   @IsActive IS NOT NULL                
 --  --   AND @IsPreferred IS NOT NULL                
 --  --   AND MS.IsActive = @IsActive                
 --  --   AND MS.IsPreferred = @IsPreferred                
 --  --   )                
 --  --  OR (                
 --  --   @IsActive IS NOT NULL                
 --  --   AND @IsPreferred IS NULL                
 --  --   AND MS.IsActive = @IsActive                
 --  --   )                
 --  --  OR (                
 --  --   @IsActive IS NULL                
 --  --   AND @IsPreferred IS NOT NULL                
 --  --   AND MS.IsPreferred = @IsPreferred                
 --  --   )                
 --  --  )            
 --  WHERE            
 --   (                
 --    @ID IS NULL                
 --    OR @ID = 0                
 --    OR MS.ID = @ID                
 --    )                
 --  ORDER BY MS.Name                
                
 --  -- -- added for pagination                        
 --  -- OFFSET @PageNumber * @PageSize ROWS                      
 --  --FETCH NEXT @PageSize ROWS ONLY;                      
 --  --SELECT TOP 1 ID                      
 --  -- ,ParentID                      
 --  -- ,ParentPageType                      
 --  -- ,ImageName                      
 --  -- ,[Image]                      
 --  --FROM UploadImage;                      
 --  SET @ReturnCode = '200';                
 --  SET @ReturnMessage = 'Success';                
 -- END                
 --END -- EX      
<<<<<<< HEAD
<<<<<<< HEAD
 --ELSE IF @Action = 'U'                
 --BEGIN                
 -- IF NOT EXISTS (                
 --   SELECT TOP 1 1                
 --   FROM MonumentService                
 --   WHERE Name = @Name                
 --    AND ID != @ID                
 --   )                
 -- BEGIN                
 --  UPDATE MonumentService                
 --  SET Name = @Name                
 --   ,State_IATACode = @StateIATACode                
 --   ,City_IATACode = @CityIATACode                
 --   ,Timing = @Timing                
 --   ,ClosedOn = @ClosedOn                
 --   ,Holidays = @Holidays       
 --   ,Remarks = @Remarks                
 --   ,ShortDescription = @ShortDescription                
 --   ,DetailedDescription = @DetailedDescription                
 --   ,IsActive = @IsActive                
 --   ,Operation = 'Update'                
 --   ,UpdatedBy = @OperationBy                
 --   ,UpdatedOn = GETDATE()                
 --   ,IsPreferred = @IsPreferred                
 --  WHERE ID = @ID;                
                
 --  --EXEC usp_InsertMonumentServices_Audit @ID                      
 --  -- ,'Update'                      
 --  -- ,@OperationBy;                      
 --  SET @ReturnCode = '200';                
 --  SET @ReturnMessage = 'Record updated successfully.';                
              
 --   SELECT @ReturnCode AS returnCode  ,@ReturnMessage AS returnMessage  ,@ID AS ID;               
              
 -- END                
 -- ELSE                
 -- BEGIN                
 --  SET @ReturnCode = '201';                
 --  SET @ReturnMessage = 'Monument name already exists. Please check and try again.';                
 -- END                
 --END -- U                          
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 ELSE IF @Action = 'U'                
 BEGIN                
  IF NOT EXISTS (                
    SELECT TOP 1 1                
    FROM MonumentService                
    WHERE Name = @Name                
     AND ID != @ID                
    )                
  BEGIN                
   UPDATE MonumentService                
   SET Name = @Name                
    ,State_IATACode = @StateIATACode                
    ,City_IATACode = @CityIATACode                
    ,Timing = @Timing                
    ,ClosedOn = @ClosedOn                
    ,Holidays = @Holidays       
    ,Remarks = @Remarks                
    ,ShortDescription = @ShortDescription                
    ,DetailedDescription = @DetailedDescription                
    ,IsActive = @IsActive                
    ,Operation = 'Update'                
    ,UpdatedBy = @OperationBy                
    ,UpdatedOn = GETDATE()                
    ,IsPreferred = @IsPreferred                
   WHERE ID = @ID;                
                
   --EXEC usp_InsertMonumentServices_Audit @ID                      
   -- ,'Update'                      
   -- ,@OperationBy;                      
   SET @ReturnCode = '200';                
   SET @ReturnMessage = 'Record updated successfully.';                
              
    SELECT @ReturnCode AS returnCode  ,@ReturnMessage AS returnMessage  ,@ID AS ID;               
              
  END                
  ELSE                
  BEGIN                
   SET @ReturnCode = '201';                
   SET @ReturnMessage = 'Monument name already exists. Please check and try again.';                
  END                
 END -- U                          
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 --ELSE                
 --BEGIN                
 -- SET @ReturnCode = '201';                
 -- SET @ReturnMessage = 'Invalid Action';                
 --END                
                ELSE IF @Action = 'EX'
BEGIN
  IF (
    @ID IS NULL
    OR @ID = 0
    )
  BEGIN
   SELECT
    MS.Name
    ,Timing
    ,ClosedOn
    ,Holidays
    ,Remarks
    ,MS.IsActive              -- return as BIT (0/1)
    ,MS.IsPreferred           -- return as BIT (0/1)
    ,C.Name AS CityName
    ,S.Name AS StateName
    ,ImageExists = CASE
     WHEN EXISTS (
       SELECT ID
       FROM UploadImage
       WHERE ParentPageType = 4
        AND ParentID = MS.ID
       )
      THEN 1
     ELSE 0
     END
   FROM MonumentService MS
   INNER JOIN City C ON C.IATACode = MS.City_IATACode
   INNER JOIN STATE S ON S.State_ID = MS.State_IATACode
   ORDER BY MS.ID DESC

   -- added for pagination
   -- OFFSET @PageNumber * @PageSize ROWS
   --FETCH NEXT @PageSize ROWS ONLY;

   SELECT TOP 1
    ImageName
    ,[Image]
   FROM UploadImage;

   SET @ReturnCode = '200';
   SET @ReturnMessage = 'Success';
  END
  ELSE
  BEGIN
   SELECT
    MS.Name
    ,Timing
    ,ClosedOn
    ,Holidays
    ,Remarks
    ,MS.IsActive              -- return as BIT (0/1)
    ,MS.IsPreferred           -- return as BIT (0/1)
    ,C.Name AS CityName
    ,S.Name AS StateName
    ,ImageExists = CASE
     WHEN EXISTS (
       SELECT ID
       FROM UploadImage
       WHERE ParentPageType = 4
        AND ParentID = MS.ID
       )
      THEN 1
     ELSE 0
    END
   FROM MonumentService MS
   INNER JOIN City C ON C.IATACode = MS.City_IATACode
   INNER JOIN STATE S ON S.State_ID = MS.State_IATACode
   WHERE
    (
     @ID IS NULL
     OR @ID = 0
     OR MS.ID = @ID
    )
   ORDER BY MS.Name

   -- added for pagination
   -- OFFSET @PageNumber * @PageSize ROWS
   --FETCH NEXT @PageSize ROWS ONLY;

   SET @ReturnCode = '200';
   SET @ReturnMessage = 'Success';
  END
END -- EX

 SELECT @ReturnCode AS returnCode                
  ,@ReturnMessage AS returnMessage                
END