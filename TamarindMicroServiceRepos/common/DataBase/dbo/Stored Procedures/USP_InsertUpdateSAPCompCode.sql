<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE Procedure [dbo].[USP_InsertUpdateSAPCompCode]                                      
 @SAPCompCodeID bigint=null,                                      
 @ParentId bigint=null,                                      
 @TypeId int=null,                                      
 --@SAPCompCodename nvarchar(100)=null,                                      
 @BPCode nvarchar(15) = '',                                      
 @IsActive bit=null,                                      
 @CreatedBy UNIQUEIDENTIFIER=null,                                      
 @UpdatedBy UNIQUEIDENTIFIER=null    ,                                  
 @Action Varchar(10)='S' ,                          
 @ID INT = NULL,    
 @OperationBy UNIQUEIDENTIFIER = NULL     
as                                      
begin                      
declare @LogID int ;                    
If @Action = 'I'                                  
BEGIN                                  
 IF EXISTS (SELECT 1 FROM SAPCompCode WHERE ParentID=@ParentId and SAPID = @ID)                                                                      
 BEGIN                                      
  --Update SAPCompCode set                                        
  --ParentId = @ParentId,                                        
  --TypeId = @TypeId,                                        
  --SAPCompCodename = @ID,                                        
  --BPCode = @BPCode,                                        
  --IsActive = @IsActive,                                        
  --UpdatedBy = @UpdatedBy,                                        
  --UpdatedDate = Getdate()                                         
  --Where SAPCompCodeID = @SAPCompCodeID                                       
                                  
  SELECT '201' AS returnCode, 'This Sap Comp Code already exists. Please check and try again.' AS returnMessage, @SAPCompCodeID as ID                                  
 END                                      
 Else                                      
 BEGIN                                      
  Insert into SAPCompCode                                      
  (ParentId,TypeId,SAPCompCodename,BPCode,IsActive,CreatedBy,InsertedDate, SAPID)                                      
  values                                      
  (@ParentId,@TypeId,@ID,@BPCode,@IsActive,@OperationBy,Getdate(), @ID)                          
                      
   SET @LogID = SCOPE_IDENTITY()                    
    SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage , @LogID AS ID                                  
                          
 END                                      
 END                                  
 ELSE IF @Action = 'U'                                  
 BEGIN                                  
  IF EXISTS (SELECT 1 FROM SAPCompCode WHERE ParentID=@ParentId and SAPID = @ID)        
  begin       
  SELECT '201' AS returnCode, 'This Sap Comp Code already exists. Please check and try again.' AS returnMessage             
  end      
   else      
  BEGIN                                      
  Update SAPCompCode set                                        
  ParentId = @ParentId,                                        
  TypeId = @TypeId,                                        
  SAPCompCodename = @ID,                                        
  BPCode = @BPCode,                                        
  IsActive = @IsActive,                                        
  UpdatedBy = @OperationBy,                                        
  UpdatedDate = Getdate() ,        
  SAPID = @ID        
  Where SAPCompCodeID = @SAPCompCodeID                                    
                                  
  SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @SAPCompCodeID AS ID                                  
  END                                   
                                  
                                  
  END                                  
ELSE IF @Action = 'S'             
BEGIN                                   
Select EM.SAPCompCode AS SAPCompCodename,                              
SAPCompCodeId,                        
ParentID,                              
TypeID,                                 
BPCode,                              
SC.IsActive,                              
InsertedDate,                      
UpdatedDate,                              
CreatedBy,                              
SC.UpdatedBy                           
,EM.ID AS EntityID                          
,EM.ID,        
SAPID        
from SAPCompCode SC                              
INNER JOIN EntityMaster EM ON SC.SAPCompCodename= EM.ID                              
Where (SAPCompCodeID = @SAPCompCodeID OR @SAPCompCodeID = 0 OR @SAPCompCodeID IS NULL)                            
AND                        
(TypeId = @TypeId OR @TypeId = 0 OR @TypeId IS NULL) AND (ParentID = @ParentId or @ParentId = 0 or @ParentId is null)                           
order by SAPCompCodeId desc                          
  --SELECT '' AS returnCode, '' AS returnMessage                                  
END        

ELSE IF @Action = 'EX'             
BEGIN                                   
Select EM.SAPCompCode AS SAPCompCodename,                              
--SAPCompCodeId,                        
--ParentID,                              
--TypeID,                                 
BPCode,    
CASE 
WHEN SC.IsActive = 1 THEN 'True'
WHEN SC.IsActive = 0 THEN 'False'
END as IsActive
--,                              
--InsertedDate,                      
--UpdatedDate,                              
--CreatedBy,                              
--SC.UpdatedBy                           
--,EM.ID AS EntityID                          
--,EM.ID,        
--SAPID        
from SAPCompCode SC                              
INNER JOIN EntityMaster EM ON SC.SAPCompCodename= EM.ID                              
Where (SAPCompCodeID = @SAPCompCodeID OR @SAPCompCodeID = 0 OR @SAPCompCodeID IS NULL)                            
AND                        
(TypeId = @TypeId OR @TypeId = 0 OR @TypeId IS NULL) AND (ParentID = @ParentId or @ParentId = 0 or @ParentId is null)                           
order by SAPCompCodeId desc                          
  --SELECT '' AS returnCode, '' AS returnMessage                                  
END         
end
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿  
CREATE Procedure [dbo].[USP_InsertUpdateSAPCompCode]                                         
@SAPCompCodeID bigint=null,                                         
@ParentId bigint=null,                                         
@TypeId int=null,                                         
--@SAPCompCodename nvarchar(100)=null,                                         
@BPCode nvarchar(15) = '',                                         
@IsActive bit=null,                                         
@CreatedBy UNIQUEIDENTIFIER=null,                                         
@UpdatedBy UNIQUEIDENTIFIER=null    ,                                     
@Action Varchar(10)='S' ,                             
@ID INT = NULL,       
@OperationBy UNIQUEIDENTIFIER = NULL        
as                                         
begin                         
declare @LogID int ;                       
If @Action = 'I'                                     
BEGIN                                     
IF EXISTS (SELECT 1 FROM SAPCompCode WHERE ParentID=@ParentId and SAPID = @ID)                                                                         
BEGIN                                         
  --Update SAPCompCode set                                           
  --ParentId = @ParentId,                                           
  --TypeId = @TypeId,                                           
  --SAPCompCodename = @ID,                                           
  --BPCode = @BPCode,                                           
  --IsActive = @IsActive,                                           
  --UpdatedBy = @UpdatedBy,                                           
  --UpdatedDate = Getdate()                                            
  --Where SAPCompCodeID = @SAPCompCodeID                                          
  SELECT '201' AS returnCode, 'This Sap Comp Code already exists. Please check and try again.' AS returnMessage, @SAPCompCodeID as ID                                     
END                                         
Else                                         
BEGIN                                         
  Insert into SAPCompCode                                         
  (ParentId,TypeId,SAPCompCodename,BPCode,IsActive,CreatedBy,InsertedDate, SAPID)                                         
  values                                         
  (@ParentId,@TypeId,@ID,@BPCode,@IsActive,@OperationBy,Getdate(), @ID)                             
   SET @LogID = SCOPE_IDENTITY()                       
    SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage , @LogID AS ID                                     
END                                         
END                                     
ELSE IF @Action = 'U'                                     
BEGIN                                     
  IF EXISTS (SELECT 1 FROM SAPCompCode WHERE ParentID=@ParentId and SAPID = @ID AND SAPCompCodeID <> @SAPCompCodeID)           
  begin          
  SELECT '201' AS returnCode, 'This Sap Comp Code already exists. Please check and try again.' AS returnMessage                
  end         
   else         
  BEGIN                                         
  Update SAPCompCode set                                           
  ParentId = @ParentId,                                           
  TypeId = @TypeId,                                           
  SAPCompCodename = @ID,                                           
  BPCode = @BPCode,                                           
  IsActive = @IsActive,                                           
  UpdatedBy = @OperationBy,                                           
  UpdatedDate = Getdate() ,           
  SAPID = @ID           
  Where SAPCompCodeID = @SAPCompCodeID                                       
  SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @SAPCompCodeID AS ID                                     
  END                                       
  END                                     
ELSE IF @Action = 'S'                
BEGIN                    
Select EM.SAPCompCode AS SAPCompCodename,                                 
SAPCompCodeId,                           
ParentID,                                 
TypeID,                                    
BPCode,                                 
SC.IsActive,                                 
InsertedDate,                         
UpdatedDate,                                 
CreatedBy,                                 
SC.UpdatedBy                              
,EM.ID AS EntityID                             
,EM.ID,           
SAPID           
from SAPCompCode SC                                 
INNER JOIN EntityMaster EM ON SC.SAPCompCodename= EM.ID                                 
Where (SAPCompCodeID = @SAPCompCodeID OR @SAPCompCodeID = 0 OR @SAPCompCodeID IS NULL)                               
AND                           
(TypeId = @TypeId OR @TypeId = 0 OR @TypeId IS NULL) AND (ParentID = @ParentId or @ParentId = 0 or @ParentId is null)                              
order by SAPCompCodeId desc                             
  --SELECT '' AS returnCode, '' AS returnMessage                                     
END           ELSE IF @Action = 'EX'                
BEGIN                                      
Select EM.SAPCompCode AS SAPCompCodename,                                 
--SAPCompCodeId,                           
--ParentID,                                 
--TypeID,                                    
BPCode,       
CASE    
WHEN SC.IsActive = 1 THEN 'True'   
WHEN SC.IsActive = 0 THEN 'False'   
END as IsActive   
--,                                 
--InsertedDate,                         
--UpdatedDate,                                 
--CreatedBy,                                 
--SC.UpdatedBy                              
--,EM.ID AS EntityID                             
--,EM.ID,           
--SAPID           
from SAPCompCode SC                                 
INNER JOIN EntityMaster EM ON SC.SAPCompCodename= EM.ID                                 
Where (SAPCompCodeID = @SAPCompCodeID OR @SAPCompCodeID = 0 OR @SAPCompCodeID IS NULL)                               
AND                           
(TypeId = @TypeId OR @TypeId = 0 OR @TypeId IS NULL) AND (ParentID = @ParentId or @ParentId = 0 or @ParentId is null)                              
order by SAPCompCodeId desc                             
  --SELECT '' AS returnCode, '' AS returnMessage                                     
END            
<<<<<<< HEAD
end  
>>>>>>> dev
=======
end  
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
