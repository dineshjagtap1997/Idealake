CREATE PROCEDURE [dbo].[usp_City_Master] @IATACode CHAR(3) = ''              
 ,@StateIATACode INT = ''              
 ,@Name VARCHAR(50) = ''              
 ,@STDCode INT = ''              
 ,@IsActive BIT = ''              
 ,@OperationBy UNIQUEIDENTIFIER = NULL              
 ,@Action CHAR(2) = ''              
 ,@CountryName VARCHAR(500) = ''              
 ,@StateName VARCHAR(500) = ''              
 ,@State_ID INT = NULL              
 ,@Country_IATACode CHAR(3) = NULL              
 ,@CityName VARCHAR(500) = ''              
 --,@CityIATACode CHAR(5)=''                      
AS              
BEGIN              
 DECLARE @ReturnCode NVARCHAR(3)              
  ,@ReturnMessage NVARCHAR(MAX)              
  ,@logStatus BIT              
  ,@LogID int;              
              
 IF @Action = 'I'              
 BEGIN              
  IF EXISTS (              
    SELECT IATACode              
    FROM City              
    WHERE UPPER(IATACode) = UPPER(@IATACode)              
    )              
  BEGIN              
   SELECT '201' AS returnCode              
    ,'IATA Code already exists. Please check and try again.' AS returnMessage;              
  END              
  ELSE IF EXISTS (              
    SELECT Name              
    FROM City              
    WHERE UPPER(Name) = UPPER(@Name)              
     AND State_IATACode = @StateIATACode              
    )              
  BEGIN              
   SET @ReturnCode = '201';              
   SET @ReturnMessage = 'IATA Code already exists. Please check and try again.';              
              
   SELECT @ReturnCode AS returnCode              
    ,@ReturnMessage AS returnMessage;              
  END              
  ELSE              
  BEGIN              
   INSERT INTO City (              
    IATACode              
    ,State_IATACode              
    ,Name              
    ,STDCode              
    ,IsActive              
    ,Operation              
    ,OperationBy              
    ,OperationOn              
<<<<<<< HEAD
<<<<<<< HEAD
    ,OldID              
=======
    ,OldID 
	,UpdatedBy
	,UpdatedOn
>>>>>>> dev
=======
    ,OldID 
	,UpdatedBy
	,UpdatedOn
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    )              
   VALUES (              
    UPPER(@IATACode)              
    ,@StateIATACode              
    ,@Name              
    ,@STDCode              
    ,@IsActive              
    ,'Insert'              
    ,@OperationBy              
    ,GETDATE()              
<<<<<<< HEAD
<<<<<<< HEAD
    ,UPPER(@IATACode)              
=======
    ,UPPER(@IATACode)  
	,@OperationBy
	,GETDATE()
>>>>>>> dev
=======
    ,UPPER(@IATACode)  
	,@OperationBy
	,GETDATE()
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    );              
    Set @LogID =  @@identity              
   --EXEC usp_InsertCity_Audit @IATACode, 'Insert', @OperationBy;                                                                
   SET @ReturnCode = '200';              
   SET @ReturnMessage = 'New record added successfully';              
              
   SELECT @ReturnCode AS returnCode              
    ,@ReturnMessage AS returnMessage              
    ,@LogID AS ID;              
  END              
 END              
 ELSE IF @Action = 'U'              
 BEGIN              
  IF EXISTS (              
    SELECT TOP 1 1              
    FROM City              
    WHERE Name = @Name              
     AND State_IATACode = @StateIATACode              
     AND IATACode != @IATACode              
    )              
  BEGIN              
   SET @ReturnCode = '201';              
   SET @ReturnMessage = 'IATA Code already exists. Please check and try again.';              
              
   SELECT @ReturnCode AS returnCode              
    ,@ReturnMessage AS returnMessage;              
  END              
  ELSE              
  BEGIN              
   --SELECT *                                                  
   --FROM City                                                  
   --WHERE (                                                  
   --  @IATACode = ''                                               
   --  OR IATACode = @IATACode                                                  
   --  )                                                  
   -- AND (                                          
   --  @StateIATACode = ''                                                  
   --  OR State_IATACode = @StateIATACode                        
   --  )                                                  
   UPDATE City              
<<<<<<< HEAD
<<<<<<< HEAD
   SET State_IATACode = @StateIATACode              
=======
   SET State_IATACode = @StateIATACode
    ,IATACode= @IATACode
>>>>>>> dev
=======
   SET State_IATACode = @StateIATACode
    ,IATACode= @IATACode
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    ,Name = @Name              
    ,STDCode = @STDCode         
    ,IsActive = @IsActive              
    ,Operation = 'Update'              
    ,UpdatedBy = @OperationBy              
    ,UpdatedOn = GETDATE()              
   WHERE IATACode = @IATACode;              
    Set @LogID =  (SELECT ID FROM City WHERE IATACode = @IATACode)              
                  
              
   --EXEC usp_InsertCity_Audit @IATACode, 'Update', @OperationBy;                                                              
   SET @ReturnCode = '200';              
   SET @ReturnMessage = 'Record updated successfully.';              
              
   SELECT @ReturnCode AS returnCode              
    ,@ReturnMessage AS returnMessage              
    ,@LogID AS ID;              
  END              
 END                           
 ELSE IF @Action = 'S'              
 BEGIN              
  SELECT             
  C.ID AS ID,            
  C.IATACode              
   ,CR.IATACode AS Country_IATACode              
   ,CR.Name AS CountryName              
   ,State_IATACode AS StateIATACode              
   ,C.Name              
   ,STDCode              
   ,C.IsActive              
   ,S.State_ID              
   ,S.Name AS StateName              
   ,C.Name AS CityName              
  FROM City C              
  INNER JOIN [State] S ON C.State_IATACode = S.State_ID              
  INNER JOIN [Country] CR ON S.Country_IATACode = CR.IATACode              
  WHERE (              
    S.State_ID = CASE               
     WHEN ISNULL(@State_ID, 0) <> 0              
      THEN @State_ID              
     ELSE S.State_ID              
     END              
    OR S.State_ID IS NULL              
    )              
   AND (              
    CR.IATACode = CASE               
<<<<<<< HEAD
<<<<<<< HEAD
     WHEN ISNULL(@Country_IATACode, '') <> ''              
=======
     WHEN ISNULL(@Country_IATACode,0 ) <> ''              
>>>>>>> dev
=======
     WHEN ISNULL(@Country_IATACode,0 ) <> ''              
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
      THEN @Country_IATACode              
     ELSE CR.IATACode              
     END              
    OR CR.IATACode IS NULL              
    )                      
                  
   AND (              
<<<<<<< HEAD
<<<<<<< HEAD
    ISNULL(@IATACode, '') = ''              
    OR C.IATACode = @IATACode              
    )              
    AND (@Name IS NULL OR @Name = '' OR  C.Name LIKE '%' + @Name + '%')                
  ORDER BY C.OperationOn DESC              
 END              
 ELSE IF @Action = 'F'                
    BEGIN                
        SELECT Name, State_ID FROM STATE                
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    ISNULL(@IATACode, 0) = ''              
    OR C.IATACode = @IATACode              
    )              
    AND (@Name IS NULL OR @Name = '' OR  C.Name LIKE '%' + @Name + '%')                
  --ORDER BY C.OperationOn DESC   
  ORDER BY C.UpdatedOn DESC  
 END              
 ELSE IF @Action = 'F'                
    BEGIN                
        SELECT  C.ID AS ID, C.Name AS CityName    FROM  City C                 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        WHERE (@Name IS NULL OR @Name = '' OR Name LIKE '%' + @Name + '%')                
              
    END       
 ELSE IF @Action='EX'      
 BEGIN      
 BEGIN              
  SELECT             
  C.IATACode AS IATACode              
   ,CR.Name AS CountryName             
   ,C.Name   AS CityName            
   ,STDCode              
 ,CASE   
        WHEN C.IsActive = 1 THEN 'True'  
        WHEN C.IsActive = 0 THEN 'False'  
    END AS IsActive               
   ,S.Name AS StateName              
            
  FROM City C              
  INNER JOIN [State] S ON C.State_IATACode = S.State_ID              
  INNER JOIN [Country] CR ON S.Country_IATACode = CR.IATACode              
            
 END             
 END      
END 