CREATE PROCEDURE [dbo].[usp_GuideServices_Master]                                        
@Code   int=NULL ,                                       
@Name   VARCHAR(500)=NULL,                                        
@ShortDescription VARCHAR(500)=NULL,                                        
@DetailedDescription VARCHAR(MAX)=NULL,                                        
@IsActive  BIT=0,                                        
@OperationBy UNIQUEIDENTIFIER=NULL,                                   
@IsPreferred BIT=0,                                       
@ErrMsg VARCHAR(50) = NULL,                            
@Action CHAR(2)= NULL,                            
--@Active BIT =NULL,                            
 @PageNumber BIGINT = NULL,                            
    @PageSize INT= NULL                            
AS                              
BEGIN                            
DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);                                    
                            
IF @Action='I'                            
BEGIN                                        
 IF EXISTS (SELECT TOP 1 1 FROM GuideServices WHERE Name = @Name)                                        
 BEGIN                                        
  SET @ReturnCode = '201';                              
  SET @ReturnMessage = 'Service name already exists. Please check and try again.';                            
  SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                             
  RETURN;                            
 END                                        
 ELSE                                        
 BEGIN                                        
  INSERT INTO GuideServices                                        
      (Name, ShortDescription, DetailedDescription, IsActive, Operation, OperationBy, OperationOn, IsPreferred)                                        
  VALUES (@Name, @ShortDescription, @DetailedDescription, @IsActive, 'Insert', @OperationBy, GETDATE(), @IsPreferred);                                        
                                        
  SET @Code = SCOPE_IDENTITY();                            
  --EXEC usp_InsertGuideServices_Audit @Code, 'Insert', @OperationBy;                            
                                      
  SET @ReturnCode = '200';                                      
  SET @ReturnMessage = 'New record added successfully.';                            
  SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @Code as ID ;                            
 END                                        
END                            
ELSE IF @Action='U'                            
BEGIN                                    
 IF EXISTS (SELECT TOP 1 1 FROM GuideServices WHERE Name = @Name AND Code != @Code)                                    
 BEGIN                                    
  SET @ReturnCode = '201';                              
  SET @ReturnMessage = 'Service name already exists. Please check and try again.';                            
  SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @Code as ID ;                                
  RETURN;                            
 END                                    
 ELSE                                    
 BEGIN                                    
  UPDATE GuideServices                                    
  SET  Name = isnull(@Name,Name) ,                                   
       --ShortDescription = isnull(@ShortDescription,                                  
       --DetailedDescription = @DetailedDescription,                                    
       IsActive = @IsActive,                                    
       Operation = 'Update'                                    
       ,UpdatedBy = @OperationBy                          
    ,UpdatedOn = GETDATE()  ,                              
       IsPreferred = @IsPreferred                                   
  WHERE Code = @Code;                            
      
  --EXEC usp_InsertGuideServices_Audit @Code, 'Update', @OperationBy;                            
               
  SET @ReturnCode = '200';                                      
  SET @ReturnMessage = 'Record updated successfully.';                            
  SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @Code as ID ;                    
 END                                    
END                            
ELSE IF @Action='S'                            
BEGIN               
 BEGIN                                        
  SELECT Code, Name, ShortDescription, DetailedDescription, IsActive, IsPreferred,                            
         ImageExists = CASE WHEN EXISTS (SELECT ID FROM UploadImage WHERE ParentPageType = 1 AND ParentID = Code) THEN 1 ELSE 0 END                             
  FROM GuideServices              
  --WHERE (@Code IS NULL OR @Code = 0 OR Code = @Code)                                      
 ORDER BY  Code  DESC                  
 ---- added for pagination                            
  --  OFFSET @PageNumber * @PageSize ROWS                            
  --  FETCH NEXT @PageSize ROWS ONLY;                            
                              
  --SET @ReturnCode = '200';                            
  --SET @ReturnMessage = 'Success';                            
 END                                
 --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                             
END               
--ELSE IF @Action='EX'                            
--BEGIN               
-- BEGIN                                        
--  SELECT  Name,CASE   
--        WHEN IsActive = 1 THEN 'True'  
--        WHEN IsActive = 0 THEN 'False'  
--    END AS IsActive   , CASE   
--        WHEN IsPreferred = 1 THEN 'Yes'  
--        WHEN IsPreferred = 0 THEN 'No'  
--    END AS IsPreferred,                            
--         ImageExists = CASE WHEN EXISTS (SELECT ID FROM UploadImage WHERE ParentPageType = 1 AND ParentID = Code) THEN 1 ELSE 0 END                             
--  FROM GuideServices              
--  WHERE (@Code IS NULL OR @Code = 0 OR Code = @Code)                                      
-- ORDER BY  Code  DESC                  
-- ---- added for pagination                            
--  --  OFFSET @PageNumber * @PageSize ROWS                            
--  --  FETCH NEXT @PageSize ROWS ONLY;                            
                              
--  --SET @ReturnCode = '200';                            
--  --SET @ReturnMessage = 'Success';                            
-- END                                
-- --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                             
--END            
ELSE IF @Action='EX'                            
BEGIN                                      
  SELECT  
    Name,
    IsActive,           -- return BIT directly
    IsPreferred,        -- return BIT directly
    CASE 
        WHEN EXISTS (SELECT ID FROM UploadImage WHERE ParentPageType = 1 AND ParentID = Code) 
        THEN 1 
        ELSE 0 
    END AS ImageExists
  FROM GuideServices              
  WHERE (@Code IS NULL OR @Code = 0 OR Code = @Code)                                      
  ORDER BY Code DESC;
END 

          
            
            
ELSE                              
BEGIN                              
  SET @ReturnCode = '201';                              
  SET @ReturnMessage = 'Invalid Action';                            
  SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                              
END                              
END 