 CREATE PROCEDURE [dbo].[usp_Currency_Master]                         
@Code varchar(6) = ''                          
 ,@Name VARCHAR(50)=''                          
 ,@Symbol VARCHAR(5)  =''                        
 ,@IsActive BIT  =''                        
 ,@OperationBy UNIQUEIDENTIFIER =NULL                         
 ,@Action CHAR(2) = ''                          
 --,@PageNumber BIGINT = NULL                          
 --   ,@PageSize INT= NULL                          
AS                          
BEGIN              
    declare @LogID int ;        
 DECLARE @ReturnCode NVARCHAR(3)                          
  ,@ReturnMessage NVARCHAR(MAX);                          
                          
 IF @Action = 'I'                          
 BEGIN                          
  IF EXISTS (                          
    SELECT *                        
    FROM Currency                          
    WHERE UPPER(Name) = UPPER(@Name)                          
    )                          
  BEGIN                          
   SET @ReturnCode = '201';                          
   SET @ReturnMessage = 'This data already exists. Please check and try again.';               
   SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID as ID;                     
  END                          
  ELSE                          
  BEGIN                          
   --DECLARE @MaxID VARCHAR(100) = (                          
   --  SELECT MAX(OldID)                          
   --  FROM Currency                          
   --  ) + 1                                    
   INSERT INTO Currency (                          
    Code                          
    ,Name                          
    ,Symbol                          
    ,IsActive                          
    ,Operation                          
    ,OperationBy                          
    ,OperationOn                          
    --,OldID                          
    )                          
   VALUES (                          
    @Code                          
    ,@Name                          
    ,@Symbol                          
    ,@IsActive                          
    ,'Insert'                          
    ,@OperationBy                          
    ,GETDATE()                          
    --,@MaxID                          
    )                          
                          
   --EXEC  usp_InsertState_Audit @@Identity, 'Insert' , @OperationBy          
   SET @LogID = SCOPE_IDENTITY();        
   SET @ReturnCode = '200';                          
   SET @ReturnMessage = 'New record added successfully.';                          
   SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID AS ID;                                                          
  END                          
 END -- I                                  
 ELSE IF @Action = 'U'                          
 BEGIN                          
  --IF EXISTS(SELECT TOP 1 1 FROM State WHERE Name = @Name AND State_ID   != @State_ID  )                                                      
  --BEGIN                                                      
  -- SET  @ErrMsg = 'State created successfully!'                                                      
  --END                                        
  --ELSE                                                      
  BEGIN                          
   UPDATE Currency                          
   SET Name = @Name                          
    ,Symbol = @Symbol                          
    ,IsActive = @IsActive                          
    ,Operation = 'Update'                          
    ,UpdatedBy = @OperationBy                          
    ,UpdatedOn = GETDATE()                          
   WHERE Code = @Code              
           
   SET @LogID = (SELECT Currency.Code from Currency where Code = @Code )        
                          
   SET @ReturnCode = '200';                          
   SET @ReturnMessage = 'Record updated successfully.';                          
    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID as ID;                             
    --  EXEC usp_InsertState_Audit @State_ID  , 'Update' , @OperationBy                                                      
  END                          
 END                          
 ELSE IF @Action = 'S'                 
  BEGIN                          
 SELECT Code, Name, Symbol, IsActive            
FROM Currency            
WHERE (@Code = '' OR @Code IS NULL OR Code = @Code)            
ORDER BY CurrencyID DESC;            
                 
  END           
      
   ELSE IF @Action = 'EX'                 
 BEGIN                          
 SELECT Code, Name,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive            
FROM Currency            
WHERE (@Code = '' OR @Code IS NULL OR Code = @Code)            
ORDER BY CurrencyID DESC;            
                 
  END                 
END 