   
CREATE PROCEDURE [dbo].[usp_InsertClassType]      
@MOT   INT,      
@Class   VARCHAR(50),      
@IsActive  BIT,      
@OperationBy UNIQUEIDENTIFIER,      
@ErrMsg   VARCHAR(50)='',
@Action char(2)=''
,@ID INT =''
AS  
BEGIN 
IF @Action='I'
BEGIN  

 IF NOT EXISTS(SELECT TOP 1 1 FROM ClassType WHERE Class=@Class AND MOT = @MOT)      
 BEGIN      
     
 declare @MaxID int  = (Select MAX(OldID) from ClassType) + 1     
     
  INSERT INTO  ClassType      
      (MOT,  Class , IsActive,  Operation , OperationBy , OperationOn,OldID)      
  VALUES   (@MOT, @Class, @IsActive, 'Insert'  , @OperationBy, GETDATE() ,@MaxID)      
        
  EXEC   usp_InsertClassType_Audit @@IDENTITY, 'Insert', @OperationBy      
        
  SET    @ErrMsg =''      
 END      
 ELSE      
 BEGIN      
  SET    @ErrMsg ='Class Type already exists!'      
 END      
END--I
ELSE IF @Action='U'
BEGIN 
UPDATE ClassType  
  SET  MOT   = @MOT,  
    Class  = @Class,  
    IsActive = @IsActive,  
    Operation = 'Update' 
    ,UpdatedBy = @OperationBy
				,UpdatedOn = GETDATE() 
  WHERE ID   = @ID  
     
  EXEC usp_InsertClassType_Audit @ID, 'Update', @OperationBy  
END
ELSE IF @Action='S'
BEGIN
SELECT c.ID,c.MOT as MOT_ID,c.Class,m.MOT,c.IsActive     
 FROM ClassType c WITH(NOLOCK)    
 INNER JOIN MOT m ON m.ID=c.MOT     
END
END
