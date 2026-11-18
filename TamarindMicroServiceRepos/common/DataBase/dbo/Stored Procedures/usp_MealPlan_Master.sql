CREATE PROCEDURE [dbo].[usp_MealPlan_Master] @Code VARCHAR(5) = ''          
 ,@Description VARCHAR(500) = ''          
 ,@Breakfast BIT = 0          
 ,@Lunch BIT = 0          
 ,@Dinner BIT = 0          
 ,@IsActive BIT = 0          
 ,@OperationBy UNIQUEIDENTIFIER = NULL          
 ,          
 --@ErrMsg   VARCHAR(50) OUT                    
 @Action CHAR(2) = ''          
 ,@ID INT = ''          
AS          
BEGIN          
        
 Declare @LogID int;         
 IF @Action = 'I'          
 BEGIN          
  IF EXISTS (          
    SELECT Code          
    FROM MealPlan          
    WHERE UPPER(Code) = UPPER(@Code)          
    )          
  BEGIN          
   SELECT '201' AS returnCode          
    ,'Code already exists. Please check and try again.' AS returnMessage, @LogID AS ID;          
  END          
  ELSE          
  BEGIN          
   DECLARE @MaxID INT = (          
     SELECT MAX(OldID)          
     FROM MealPlan          
     ) + 1          
          
   INSERT INTO MealPlan (          
    Code          
    ,Description          
    ,Breakfast          
    ,Lunch          
    ,Dinner          
    ,IsActive          
    ,Operation          
    ,OperationBy          
    ,OperationOn          
    ,OldID          
    )          
   VALUES (          
    UPPER(@Code)          
    ,@Description          
    ,@Breakfast          
    ,@Lunch          
    ,@Dinner          
    ,@IsActive          
    ,'Insert'          
    ,@OperationBy          
    ,GETDATE()          
    ,@MaxID          
    )          
          
   -- EXEC  usp_InsertMealPlan_Audit @@IDENTITY, 'Insert', @OperationBy        
   SET @LogID = SCOPE_IDENTITY()    
   SELECT '200' AS returnCode          
    ,'New record added successfully.' AS returnMessage, @LogID as ID;          
  END          
 END --I                  
 ELSE IF @Action = 'U'          
 BEGIN          
  IF EXISTS (          
    SELECT Code          
    FROM MealPlan          
    WHERE UPPER(Code) = UPPER(@Code)          
     AND ID <> @ID          
    )          
  BEGIN          
   SELECT 'Code already exists. Please check and try again.'          
  END          
  ELSE          
  BEGIN          
   UPDATE MealPlan          
   SET Code = UPPER(@Code)          
    ,Description = @Description          
    ,Breakfast = @Breakfast          
    ,Lunch = @Lunch          
    ,Dinner = @Dinner          
    ,IsActive = @IsActive          
    ,Operation = 'Update'          
    ,OperationBy = @OperationBy          
    ,OperationOn = GETDATE()          
   WHERE ID = @ID          
          
   --EXEC  usp_InsertMealPlan_Audit @ID, 'Update', @OperationBy                    
   SELECT '200' AS returnCode          
    ,'Record updated successfully.' AS returnMessage, @ID as ID;          
    -- SET   @ErrMsg = ''                    
  END          
 END --U                  
 ELSE IF @Action = 'S'          
 BEGIN          
  IF (@IsActive = 0)          
  BEGIN          
   SELECT ID          
    ,Code          
    ,Description          
    ,Breakfast          
    ,Lunch          
    ,Dinner          
    ,IsActive          
    ,OperationOn          
   FROM MealPlan          
   WHERE (          
     @ID IS NULL          
     OR @ID = 0          
     OR ID = @ID          
     ) ---AND (Breakfast=@Breakfast AND Lunch=@Lunch AND Dinner=@Dinner)                 
   ORDER BY ID DESC          
  END          
  ELSE          
  BEGIN          
   SELECT ID          
    ,Code          
    ,Description          
    ,Breakfast          
    ,Lunch          
    ,Dinner          
    ,IsActive          
    ,OperationOn          
    ,(cast(ID AS VARCHAR) + '|' + cast(Breakfast AS VARCHAR) + cast(Lunch AS VARCHAR) + cast(Dinner AS VARCHAR)) AS IDFlags          
   FROM MealPlan          
   WHERE IsActive = 1          
    AND (          
     @ID IS NULL          
     OR @ID = 0          
     OR ID = @ID          
     )          
   ORDER BY ID DESC          
  END          
 END          
          
-- BEGIN          
--    IF (@IsActive = 0)          
--    BEGIN       
--        SELECT           
--            ID,          
--            Code,          
--            Description,          
--            Breakfast,          
--            Lunch,          
--            Dinner,          
--            IsActive,          
--            OperationOn         
--        FROM MealPlan          
--        WHERE           
--            (          
--                @ID IS NULL          
--                OR @ID = 0          
--                OR ID = @ID          
--            )          
--            AND           
--            (          
--                (@Breakfast IS NULL OR Breakfast = @Breakfast) AND          
--                (@Lunch IS NULL OR Lunch = @Lunch) AND          
--                (@Dinner IS NULL OR Dinner = @Dinner)          
--            )          
--        ORDER BY ID DESC          
--    END          
--    ELSE          
--    BEGIN          
--        SELECT           
--            ID,          
--            Code,          
--            Description,          
--            Breakfast,          
--            Lunch,          
--            Dinner,          
--            IsActive,          
--            OperationOn,          
--            (CAST(ID AS VARCHAR) + '|' + CAST(Breakfast AS VARCHAR) + CAST(Lunch AS VARCHAR) + CAST(Dinner AS VARCHAR)) AS IDFlags          
--        FROM MealPlan          
--        WHERE           
--            IsActive = 1          
--            AND           
--            (          
--                @ID IS NULL          
--                OR @ID = 0          
--                OR ID = @ID          
--            )          
--            AND           
--            (          
--                (@Breakfast IS NULL OR Breakfast = @Breakfast) AND          
--                (@Lunch IS NULL OR Lunch = @Lunch) AND          
--                (@Dinner IS NULL OR Dinner = @Dinner)          
--            )          
--        ORDER BY ID DESC          
--    END          
--END          
 --     ELSE IF @Action='EX'  
 --  BEGIN          
 -- IF (@IsActive = 0)          
 -- BEGIN          
 --  SELECT Code          
 --   ,Description          
 --   , CASE   
 --       WHEN Breakfast = 1 THEN 'Yes'  
 --       WHEN Breakfast = 0 THEN 'No'  
 --   END AS Breakfast           
 --   , CASE   
 --       WHEN Lunch = 1 THEN 'Yes'  
 --       WHEN Lunch = 0 THEN 'No'  
 --   END AS Lunch         
 --  , CASE   
 --       WHEN Dinner = 1 THEN 'Yes'  
 --       WHEN Dinner = 0 THEN 'No'  
 --   END AS Dinner           
 --  ,CASE   
 --       WHEN IsActive = 1 THEN 'True'  
 --       WHEN IsActive = 0 THEN 'False'  
 --   END AS IsActive         
 --  FROM MealPlan          
 --  WHERE (          
 --    @ID IS NULL          
 --    OR @ID = 0          
 --    OR ID = @ID          
 --    ) ---AND (Breakfast=@Breakfast AND Lunch=@Lunch AND Dinner=@Dinner)                 
 --  ORDER BY ID DESC          
 -- END          
 -- ELSE          
 -- BEGIN          
 --  SELECT Code          
 --   ,Description          
 --  , CASE   
 --       WHEN Breakfast = 1 THEN 'Yes'  
 --       WHEN Breakfast = 0 THEN 'No'  
 --   END AS Breakfast           
 --   , CASE   
 --       WHEN Lunch = 1 THEN 'Yes'  
 --       WHEN Lunch = 0 THEN 'No'  
 --   END AS Lunch         
 --  , CASE   
 --       WHEN Dinner = 1 THEN 'Yes'  
 --       WHEN Dinner = 0 THEN 'No'  
 --   END AS Dinner           
 --  ,CASE   
 --       WHEN IsActive = 1 THEN 'True'  
 --       WHEN IsActive = 0 THEN 'False'  
 --   END AS IsActive           
 --   ,(cast(ID AS VARCHAR) + '|' + cast(Breakfast AS VARCHAR) + cast(Lunch AS VARCHAR) + cast(Dinner AS VARCHAR)) AS IDFlags          
 --  FROM MealPlan          
 --  WHERE IsActive = 1          
 --   AND (          
 --    @ID IS NULL          
 --    OR @ID = 0          
 --    OR ID = @ID          
 --    )          
 --  ORDER BY ID DESC          
 -- END          
 --END    
 ELSE IF @Action='EX'  
BEGIN
  SELECT
    Code,
    Description,
    Breakfast,
    Lunch,
    Dinner,
    IsActive
  FROM MealPlan
  WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)
  ORDER BY ID DESC
END


END 