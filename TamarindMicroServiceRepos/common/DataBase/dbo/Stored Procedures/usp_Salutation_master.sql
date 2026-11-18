        
        
        
CREATE PROCEDURE [dbo].[usp_Salutation_master] (          
 @SalutationID INT = NULL          
 ,@Salutation VARCHAR(15) = ''          
 ,@IsActive BIT = NULL          
 ,@OperationBy UNIQUEIDENTIFIER = NULL          
 ,@Action CHAR(2) = ''          
 )          
AS          
BEGIN          
 DECLARE @ReturnCode NVARCHAR(3)          
  ,@ReturnMessage NVARCHAR(MAX);          
          
 IF @Action = 'I'          
 BEGIN          
  IF EXISTS (          
    SELECT TOP 1 1          
    FROM Salutation          
    WHERE Salutation = @Salutation          
    )          
  BEGIN          
   SET @ReturnCode = '201';          
   SET @ReturnMessage = 'Salutation already exists. Please check and try again.';          
  END          
  ELSE          
  BEGIN          
   --declare @MaxID int  = (Select MAX(OldID) from Salutation) + 1                     
   DECLARE @MaxID INT          
          
   --EXEC usp_InsertCustomCaption 'Salutation'          
   -- ,'Title'          
   -- ,@Salutation          
   -- ,99          
   -- ,@MaxID OUT          
          
   INSERT INTO Salutation (          
    Salutation          
    ,IsActive          
    ,Operation          
    ,OperationBy          
    ,OperationOn          
    ,OldID          
    )          
   VALUES (          
    @Salutation          
    ,@IsActive          
    ,'INSERT'          
    ,@OperationBy          
    ,GETDATE()          
    ,@MaxID          
    )          
          
   SET @SalutationID = SCOPE_IDENTITY()      
   SET @ReturnCode = '200';          
   SET @ReturnMessage = 'New record added successfully.';          
    --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;             
  END          
 END          
 ELSE IF @ACTION = 'U'          
 BEGIN          
  IF NOT EXISTS (          
    SELECT TOP 1 1          
    FROM Salutation          
    WHERE UPPER(Salutation) = UPPER(@Salutation)          
     AND SalutationID <> @SalutationID          
    )          
  BEGIN          
   UPDATE Salutation          
   SET Salutation = @Salutation          
    ,IsActive = @IsActive          
    ,Operation = 'UPDATE'          
      ,UpdatedBy = @OperationBy          
    ,UpdatedOn = GETDATE()          
   WHERE SalutationID = @SalutationID          
          
   DECLARE @ID INT          
          
   --SELECT @ID = OldID          
   --FROM Salutation          
   --WHERE SalutationID = @SalutationID          
          
   --EXEC usp_UpdateCustomCaption @SalutationID          
   -- ,@Salutation          
   -- ,999          
   -- ,@ID          
   -- ,@Action          
           
   SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage;                       
  END          
  ELSE          
  BEGIN          
   SET @ReturnCode = '201';          
   SET @ReturnMessage = 'Salutation already exists. Please check and try again.';          
    --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                       
  END          
 END          
 ELSE IF @ACTION = 'S'          
 BEGIN          
  SELECT SalutationID          
   ,Salutation,IsActive         
  FROM Salutation          
  WHERE IsActive = 1          
 END          
  ELSE IF @ACTION = 'EX'          
 BEGIN          
  SELECT           
   Salutation,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive          
  FROM Salutation          
  WHERE IsActive = 1          
 END           
 SELECT @ReturnCode AS returnCode ,@ReturnMessage AS returnMessage, @SalutationID AS ID;          
END 