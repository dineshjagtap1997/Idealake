<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_GuideInfoMaster]                    
 --@GuideID  int,                              
 @Name VARCHAR(100) = ''                    
 ,@Salutation VARCHAR(10) = ''                    
 ,@Gender VARCHAR(10) = ''                    
 ,@State_IATACode INT = ''                    
 ,@City_IATACode VARCHAR(5) = ''                    
 ,@StarRating VARCHAR(20) = ''                    
 ,@PhoneNo VARCHAR(15) = ''                    
 ,@MobileNo VARCHAR(15) = ''                    
 ,@Address VARCHAR(500) = ''                    
 ,@Languages VARCHAR(500) = ''                    
 ,@IsActive BIT = ''                    
 ,@OperationBy UNIQUEIDENTIFIER = NULL                    
 ,@Ranking VARCHAR(15) = NULL                    
 ,@IsDOT BIT = ''                    
 ,@IsState BIT = 0                   
 ,@IsASI BIT = 0                    
 ,                    
 --@ErrMsg   VARCHAR(50)='',                      
 @Action CHAR(2) = 'I'                    
 ,@GuideID INT = ''                    
 ,@Active BIT = ''                    
AS                    
IF @Action = 'I'                    
BEGIN               
DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX), @LogID INT;        
    
 IF EXISTS (                    
   SELECT *                    
   FROM GuideInfoMaster                    
   WHERE Name = @Name                    
   )                    
 BEGIN                    
  SELECT '201' AS returnCode                    
   ,'Guide name already exists. Please check and try again.' AS returnMessage;                    
 END                    
 ELSE                    
 BEGIN                    
  INSERT INTO GuideInfoMaster (                    
   Name                    
   ,Salutation                    
   ,Gender                    
   ,StateIATACode                    
   ,CityIATACode                    
   ,StarRating                    
   ,PhoneNo                    
   ,MobileNo                    
   ,[Address]                    
   ,Languages                    
   ,IsActive                    
   ,Operation                    
   ,OperationBy                    
   ,OperationOn                    
   ,Ranking                    
   ,IsDOT                    
   ,IsState                    
   ,IsASI                    
   )                    
  VALUES (                    
   @Name                    
   ,@Salutation                    
   ,@Gender                    
   ,@State_IATACode                    
   ,@City_IATACode                    
   ,@StarRating                    
   ,@PhoneNo                    
   ,@MobileNo                    
   ,@Address                    
   ,@Languages                    
   ,@IsActive                    
   ,'INSERT'                    
   ,@OperationBy                    
   ,GETDATE()                    
   ,@Ranking                    
   ,@IsDOT                    
   ,@IsState                    
   ,@IsASI                    
   )                    
                    
  --EXEC usp_InsertGuideInfoMaster_Audit @@IDENTITY                    
  -- ,'Insert'                    
  -- ,@OperationBy                    
                  
  SET @LogID = SCOPE_IDENTITY();             
  SELECT '200' AS returnCode                    
   ,'New record added successfully.' AS returnMessage,  @LogID AS ID;                    
 END                    
END -- I                      
ELSE IF @Action = 'U'                    
BEGIN                    
 IF EXISTS (                    
   SELECT *                    
   FROM GuideInfoMaster                    
   WHERE Name = @Name                    
    AND GuideID != @GuideID                    
   )                    
 BEGIN                    
  SELECT '201' AS returnCode                    
   ,'Guide name already exists. Please check and try again.' AS returnMessage;                    
 END                    
 ELSE                    
 BEGIN                    
  UPDATE GuideInfoMaster                    
  SET Name = @Name                    
   ,Salutation = @Salutation                    
   ,Gender = @Gender                    
   ,StateIATACode = @State_IATACode                    
   ,CityIATACode = @City_IATACode                    
   ,StarRating = @StarRating                    
 ,PhoneNo = @PhoneNo                    
   ,MobileNo = @MobileNo                    
   ,[Address] = @Address                    
   ,Languages = @Languages                    
   ,IsActive = @IsActive                    
   ,Operation = 'Update'                    
   ,UpdatedBy = @OperationBy                    
    ,UpdatedOn = GETDATE()                    
   ,Ranking = @Ranking               
   ,IsDOT = @IsDOT                    
   ,IsState = @IsState                    
   ,IsASI = @IsASI                    
  WHERE GuideID = @GuideID                    
                    
  --EXEC usp_InsertGuideInfoMaster_Audit @@IDENTITY                    
  -- ,'Update'                    
  -- ,@OperationBy                    
                    
  SELECT '200' AS returnCode                    
   ,'Record updated successfully.' AS returnMessage , @GuideID AS ID      ;                    
 END                    
END --U                      
ELSE IF @Action = 'S'                    
BEGIN                 
                    
                   
  SELECT GuideID                    
   ,GIM.Name                    
   ,Salutation                    
   ,Gender                    
   ,StateIATACode   AS State_IATACode             
   ,StateIATACode            
   ,CityIATACode AS City_IATACode               
   ,CityIATACode            
   ,StarRating                    
   ,PhoneNo                    
   ,MobileNo                    
   ,[Address]                    
   ,Languages                    
  ,GIM.IsActive                    
   ,GIM.Operation                    
   ,GIM.OperationBy                    
   ,GIM.OperationOn                    
   ,C.Name AS CityName                    
   ,S.Name AS StateName                    
   ,GIM.Ranking                    
   ,ISNULL(GIM.IsDOT, 0) AS IsDOT                    
   ,ISNULL(GIM.IsState, 0) AS IsState                    
   ,ISNULL(GIM.IsASI, 0) AS IsASI                    
  FROM GuideInfoMaster GIM WITH (NOLOCK)                    
  INNER JOIN City C ON C.IATACode = GIM.CityIATACode                    
  INNER JOIN [State] S ON S.State_ID = GIM.StateIATACode                    
 where               
 GIM.Name LIKE CASE                           
    WHEN ISNULL(@Name, '') <> ''                          
     THEN '%' + @Name + '%'                          
    ELSE GIM.Name                          
    END               
 AND StarRating LIKE CASE                           
    WHEN ISNULL(@StarRating, '') <> ''                          
     THEN  '%' + @StarRating + '%'                           
    ELSE StarRating                          
    END               
 AND  CityIATACode LIKE CASE                           
    WHEN ISNULL(@City_IATACode, '') <> ''                          
     THEN @City_IATACode                          
    ELSE CityIATACode                          
    END                  
 --AND Ranking LIKE CASE                           
 --   WHEN ISNULL(@Ranking, '') <> ''                          
 --    THEN  '%' + @Ranking + '%'                           
 --   ELSE Ranking                          
 --   END               
 --AND  IsDOT LIKE CASE                           
 --   WHEN ISNULL(@IsDOT, '') <> ''                          
 --    THEN  @IsDOT                           
 --   ELSE IsDOT                  
 --END               
  AND  IsState LIKE CASE                           
    WHEN ISNULL(@IsState, '') <> ''                          
     THEN @IsState                          
    ELSE IsState                          
    END                 
  AND  IsState LIKE CASE                           
    WHEN ISNULL(@IsASI, '') <> ''                          
     THEN @IsASI                          
    ELSE IsState                          
    END                 
   AND  GuideID LIKE CASE                           
    WHEN ISNULL(@GuideID, '') <> ''                          
     THEN @GuideID                          
    ELSE GuideID          
      
    END      
	

  order by GuideID desc      
 --and(@IsState IS NULL OR IsState = @IsState)                
 --AND  (@IsASI IS NULL OR IsASI = @IsASI)                
 -- AND               
 --(@GuideID is null OR  @GuideID = 0 or GuideID = @GuideID  )                
                   
END 
ELSE IF @Action = 'EX'                    
BEGIN                 
                    
                   
  SELECT                     
   GIM.Name                    
   ,Salutation                    
   ,Gender                    
   ,StarRating                    
   ,PhoneNo                    
   ,MobileNo                    
   ,[Address]                    
   ,Languages                    
 ,CASE         
        WHEN GIM.IsActive = 1 THEN 'True'        
        WHEN GIM.IsActive = 0 THEN 'False'        
    END AS IsActive                  
   ,C.Name AS CityName                    
   ,S.Name AS StateName                    
   ,GIM.Ranking                    
   ,ISNULL(GIM.IsDOT, 0) AS IsDOT                    
   ,ISNULL(GIM.IsState, 0) AS IsState                    
   ,ISNULL(GIM.IsASI, 0) AS IsASI                    
  FROM GuideInfoMaster GIM WITH (NOLOCK)                    
  INNER JOIN City C ON C.IATACode = GIM.CityIATACode                    
  INNER JOIN [State] S ON S.State_ID = GIM.StateIATACode                    
 where               
 GIM.Name LIKE CASE                           
    WHEN ISNULL(@Name, '') <> ''                          
     THEN '%' + @Name + '%'                          
    ELSE GIM.Name                          
    END               
 AND StarRating LIKE CASE                           
    WHEN ISNULL(@StarRating, '') <> ''                          
     THEN  '%' + @StarRating + '%'                           
    ELSE StarRating                          
    END               
 AND  CityIATACode LIKE CASE                           
    WHEN ISNULL(@City_IATACode, '') <> ''                          
     THEN @City_IATACode                          
    ELSE CityIATACode                          
    END                  
 --AND Ranking LIKE CASE                           
 --   WHEN ISNULL(@Ranking, '') <> ''                          
 --    THEN  '%' + @Ranking + '%'                           
 --   ELSE Ranking                          
 --   END               
 --AND  IsDOT LIKE CASE                           
 --   WHEN ISNULL(@IsDOT, '') <> ''                          
 --    THEN  @IsDOT                           
 --   ELSE IsDOT                  
 --END               
  AND  IsState LIKE CASE                           
    WHEN ISNULL(@IsState, '') <> ''                          
     THEN @IsState                          
    ELSE IsState                          
    END                 
  AND  IsState LIKE CASE                           
    WHEN ISNULL(@IsASI, '') <> ''                          
     THEN @IsASI                          
    ELSE IsState                          
    END                 
   AND  GuideID LIKE CASE                           
    WHEN ISNULL(@GuideID, '') <> ''                          
     THEN @GuideID                          
    ELSE GuideID          
      
    END      
	

  order by GuideID desc      
 --and(@IsState IS NULL OR IsState = @IsState)                
 --AND  (@IsASI IS NULL OR IsASI = @IsASI)                
 -- AND               
 --(@GuideID is null OR  @GuideID = 0 or GuideID = @GuideID  )                
                   
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿CREATE PROCEDURE [dbo].[usp_GuideInfoMaster]                            
 --@GuideID  int,                                      
 @Name VARCHAR(100) = ''                            
 ,@Salutation VARCHAR(10) = ''                            
 ,@Gender VARCHAR(10) = ''                            
 ,@State_IATACode INT = ''                            
 ,@City_IATACode VARCHAR(5) = ''                            
 ,@StarRating VARCHAR(20) = ''                            
 ,@PhoneNo VARCHAR(15) = ''                            
 ,@MobileNo VARCHAR(15) = ''                            
 ,@Address VARCHAR(500) = ''                            
 ,@Languages VARCHAR(500) = ''                            
 ,@IsActive BIT = NULL                            
 ,@OperationBy UNIQUEIDENTIFIER = NULL                            
 ,@Ranking VARCHAR(15) = NULL                            
 ,@IsDOT BIT = NULL                            
 ,@IsState BIT = NULL                           
 ,@IsASI BIT = NULL                            
 ,@LanguagesID NVARCHAR(500)= NULL                      
 --@ErrMsg   VARCHAR(50)='',                              
 ,@Action CHAR(2) = 'I'                            
 ,@GuideID INT = ''                            
 ,@Active BIT = ''                            
AS                            
IF @Action = 'I'                            
BEGIN                       
DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX), @LogID INT;                
            
 IF EXISTS (                            
   SELECT *                            
   FROM GuideInfoMaster                            
   WHERE Name = @Name                            
   )                            
 BEGIN                            
  SELECT '201' AS returnCode                            
   ,'Guide name already exists. Please check and try again.' AS returnMessage;                            
 END                            
 ELSE                            
 BEGIN                            
  INSERT INTO GuideInfoMaster (                            
   Name                            
   ,Salutation                            
   ,Gender                            
   ,StateIATACode                            
   ,CityIATACode                            
   ,StarRating                            
   ,PhoneNo                            
   ,MobileNo                            
   ,[Address]                            
   ,Languages                            
   ,IsActive                            
   ,Operation                            
   ,OperationBy                            
   ,OperationOn                            
   ,Ranking                            
   ,IsDOT                            
   ,IsState                            
   ,IsASI                            
   )                            
  VALUES (                            
   @Name                            
   ,@Salutation                            
   ,@Gender                            
   ,@State_IATACode                            
   ,@City_IATACode                            
   ,@StarRating                            
   ,@PhoneNo                            
   ,@MobileNo                            
   ,@Address                            
   ,@LanguagesID                            
   ,@IsActive                            
   ,'INSERT'                            
   ,@OperationBy                            
   ,GETDATE()                            
   ,@Ranking                            
   ,@IsDOT                            
   ,@IsState                            
   ,@IsASI                            
   )                            
                            
  --EXEC usp_InsertGuideInfoMaster_Audit @@IDENTITY                            
  -- ,'Insert'                            
  -- ,@OperationBy                            
                          
  SET @LogID = SCOPE_IDENTITY();                     
  SELECT '200' AS returnCode                            
   ,'New record added successfully.' AS returnMessage,  @LogID AS ID;                            
 END                            
END -- I                              
ELSE IF @Action = 'U'                            
BEGIN                            
 IF EXISTS (        
   SELECT *                            
   FROM GuideInfoMaster                            
   WHERE Name = @Name                            
    AND GuideID != @GuideID                            
  )                            
 BEGIN                            
  SELECT '201' AS returnCode                            
   ,'Guide name already exists. Please check and try again.' AS returnMessage;                       END                            
 ELSE                            
 BEGIN                            
  UPDATE GuideInfoMaster                            
  SET Name = @Name                            
   ,Salutation = @Salutation                            
   ,Gender = @Gender                            
   ,StateIATACode = @State_IATACode                            
   ,CityIATACode = @City_IATACode                            
   ,StarRating = @StarRating                            
 ,PhoneNo = @PhoneNo                            
   ,MobileNo = @MobileNo                            
   ,[Address] = @Address                            
   ,Languages = @LanguagesID                            
   ,IsActive = @IsActive                            
   ,Operation = 'Update'                            
   ,UpdatedBy = @OperationBy                            
    ,UpdatedOn = GETDATE()                            
   ,Ranking = @Ranking                       
   ,IsDOT = @IsDOT                            
   ,IsState = @IsState                            
   ,IsASI = @IsASI                            
  WHERE GuideID = @GuideID                            
                            
  --EXEC usp_InsertGuideInfoMaster_Audit @@IDENTITY                            
  -- ,'Update'                            
  -- ,@OperationBy                            
                            
  SELECT '200' AS returnCode                            
   ,'Record updated successfully.' AS returnMessage , @GuideID AS ID      ;                            
 END                            
END --U                              
ELSE IF @Action = 'S'                            
BEGIN                         
                            
                           
  SELECT GuideID                            
   ,GIM.Name                            
   ,Salutation                            
   ,Gender                            
   ,StateIATACode   AS State_IATACode                     
   ,StateIATACode                    
   ,CityIATACode AS City_IATACode                       
   ,CityIATACode                    
   ,StarRating                            
   ,PhoneNo                            
   ,MobileNo                            
   ,[Address]                            
   ,Languages = (  
        SELECT STRING_AGG(l.Language, ', ')  
        FROM STRING_SPLIT(GIM.Languages, ',') AS ss  
        JOIN Language l ON TRY_CAST(ss.value AS nvarchar) = l.ID  
    )  
	,GIM.Languages AS LanguagesID 
  ,GIM.IsActive                            
   ,GIM.Operation                            
   ,GIM.OperationBy                            
   ,GIM.OperationOn                            
   ,C.Name AS CityName                            
   ,S.Name AS StateName                            
   ,GIM.Ranking                            
   ,ISNULL(GIM.IsDOT, 0) AS IsDOT                            
   ,ISNULL(GIM.IsState, 0) AS IsState                            
   ,ISNULL(GIM.IsASI, 0) AS IsASI                            
  FROM GuideInfoMaster GIM WITH (NOLOCK)                            
  INNER JOIN City C ON C.IATACode = GIM.CityIATACode                            
  INNER JOIN [State] S ON S.State_ID = GIM.StateIATACode    
 where             
 (  
    @LanguagesID IS NULL  
    OR @LanguagesID = ''  
    OR EXISTS (  
        SELECT 1  
        FROM STRING_SPLIT(@LanguagesID, ',') AS searchLang  
        WHERE EXISTS (  
            SELECT 1  
            FROM STRING_SPLIT(GIM.Languages, ',') AS rowLang  
            WHERE LTRIM(RTRIM(LOWER(rowLang.value))) = LTRIM(RTRIM(LOWER(searchLang.value)))  
        )  
    )  
) and  
 GIM.Name LIKE CASE                                   
    WHEN ISNULL(@Name, '') <> ''                                  
     THEN '%' + @Name + '%'                                  
    ELSE GIM.Name                                  
    END                       
 AND StarRating LIKE CASE                                   
    WHEN ISNULL(@StarRating, '') <> ''                                  
     THEN  '%' + @StarRating + '%'                                   
    ELSE StarRating                                  
    END                       
 AND  CityIATACode LIKE CASE                                   
    WHEN ISNULL(@City_IATACode, '') <> ''                                  
     THEN @City_IATACode                              
    ELSE CityIATACode                                  
    END                                      
 AND (@IsState IS NULL OR IsState = @IsState)      
       
  AND (@IsASI IS NULL OR IsASI = @IsASI)      
  --AND (@IsActive IS NULL OR GIM.IsActive =@IsActive)      
   AND  GuideID LIKE CASE                                   
WHEN ISNULL(@GuideID, '') <> ''                                  
     THEN @GuideID                                  
    ELSE GuideID                  
              
    END              
         
        
  order by GuideID desc              
 --and(@IsState IS NULL OR IsState = @IsState)                        
 --AND  (@IsASI IS NULL OR IsASI = @IsASI)                        
 -- AND                       
 --(@GuideID is null OR  @GuideID = 0 or GuideID = @GuideID  )                        
                           
END         
ELSE IF @Action = 'EX'                            
BEGIN                         
                            
                           
  SELECT                             
   GIM.Name                            
   ,Salutation                            
   ,Gender                            
   ,StarRating                            
   ,PhoneNo                            
   ,MobileNo                            
   ,[Address]                            
   ,Languages                            
 ,CASE                 
        WHEN GIM.IsActive = 1 THEN 'True'                
        WHEN GIM.IsActive = 0 THEN 'False'                
    END AS IsActive                          
   ,C.Name AS CityName                            
   ,S.Name AS StateName                            
   ,GIM.Ranking                            
   ,ISNULL(GIM.IsDOT, 0) AS IsDOT                            
   ,ISNULL(GIM.IsState, 0) AS IsState                            
   ,ISNULL(GIM.IsASI, 0) AS IsASI                            
  FROM GuideInfoMaster GIM WITH (NOLOCK)                            
  INNER JOIN City C ON C.IATACode = GIM.CityIATACode                            
  INNER JOIN [State] S ON S.State_ID = GIM.StateIATACode                            
 where     
   
 GIM.Name LIKE CASE                                   
    WHEN ISNULL(@Name, '') <> ''                                  
     THEN '%' + @Name + '%'                                  
    ELSE GIM.Name                                  
    END                       
 AND StarRating LIKE CASE                                   
    WHEN ISNULL(@StarRating, '') <> ''                                  
     THEN  '%' + @StarRating + '%'                                   
    ELSE StarRating                                  
    END                       
 AND  CityIATACode LIKE CASE                                   
    WHEN ISNULL(@City_IATACode, '') <> ''                                  
     THEN @City_IATACode                                  
    ELSE CityIATACode                                  
    END                          
 --AND Ranking LIKE CASE                                   
 --   WHEN ISNULL(@Ranking, '') <> ''                                  
 --    THEN  '%' + @Ranking + '%'                            
 --   ELSE Ranking                                  
 --   END                       
 --AND  IsDOT LIKE CASE                                   
 --   WHEN ISNULL(@IsDOT, '') <> ''                                  
 --    THEN  @IsDOT                                   
 --   ELSE IsDOT                          
 --END                       
  and(@IsState IS NULL OR IsState = @IsState)                              
 and(@IsASI IS NULL OR IsASI = @IsASI)                         
   AND  GuideID LIKE CASE                                   
    WHEN ISNULL(@GuideID, '') <> ''                                  
     THEN @GuideID                                  
    ELSE GuideID                  
              
    END              
         
        
  order by GuideID desc              
 --and(@IsState IS NULL OR IsState = @IsState)                        
 --AND  (@IsASI IS NULL OR IsASI = @IsASI)                   
 -- AND                       
 --(@GuideID is null OR  @GuideID = 0 or GuideID = @GuideID  )                        
                           
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END 