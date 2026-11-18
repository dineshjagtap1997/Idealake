CREATE PROCEDURE [dbo].[usp_SupplyTypeMaster] @Code NVARCHAR(10)      
 ,@Description NVARCHAR(50)      
 ,@LongDescription NVARCHAR(150)      
 ,@IsActive BIT      
 ,@OperationBy UNIQUEIDENTIFIER      
 --,@ErrMsg VARCHAR(50) OUT      
 ,@Action CHAR(2)=''      
 ,@SuppTypeID bigint =''      
 ,@Active BIT =''      
AS      
BEGIN      
IF @Action='I'      
BEGIN      
 DECLARE @new_identity INT      
      
 INSERT INTO SupplyTypeMaster (      
  Code      
  ,Description      
  ,LongDescription      
  ,IsActive      
  ,Operation      
  ,CreatedBy      
  ,CreatedDate      
  --,Updatedby      
  --,UpdatedOn      
  )      
 VALUES (      
  @code      
  ,@Description      
  ,@LongDescription      
  ,@IsActive      
  ,'Insert'      
  ,@OperationBy      
  ,GETDATE()      
  --,@OperationBy      
  --,GETDATE()      
  )      
      
 SELECT @new_identity = SCOPE_IDENTITY()      
       
      
       
SELECT '201' AS returnCode, 'New record added successfully.'   AS returnMessage, @new_identity as ID;      
END      
ELSE IF @Action='U'      
BEGIN      
 UPDATE SupplyTypeMaster      
 SET Code = @Code      
  ,Description = @Description      
  ,LongDescription = @LongDescription      
  ,IsActive = @IsActive      
  ,Operation = 'Update'      
    ,UpdatedBy = @OperationBy      
    ,UpdatedOn = GETDATE()      
 WHERE SuppTypeID = @SuppTypeID      
      
    
      
       
SELECT '200' AS returnCode, 'Record updated successfully.'   AS returnMessage,  @SuppTypeID AS ID;END      
ELSE IF @Action='S'      
BEGIN      
 IF (@Active = 0)      
 BEGIN      
  SELECT *      
  FROM SupplyTypeMaster C      
  ORDER BY C.SuppTypeID DESC      
 END      
 ELSE      
 BEGIN      
  SELECT *    
  FROM SupplyTypeMaster C      
  WHERE C.IsActive = 1      
  ORDER BY C.SuppTypeID DESC      
 END      
END      
      
ELSE IF @Action='EX'      
BEGIN          
  SELECT  Code,
Description,
LongDescription,
IsActive        
  FROM SupplyTypeMaster C      
  ORDER BY C.SuppTypeID DESC      
 END            
      
END 