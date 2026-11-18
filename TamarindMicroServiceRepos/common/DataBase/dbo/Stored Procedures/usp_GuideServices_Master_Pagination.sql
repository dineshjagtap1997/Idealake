  
  
    
  
  
CREATE PROCEDURE [dbo].[usp_GuideServices_Master_Pagination]              
@Code   int out,              
@Name   VARCHAR(500),              
@ShortDescription VARCHAR(500),              
@DetailedDescription VARCHAR(MAX),              
@IsActive  BIT,              
@OperationBy UNIQUEIDENTIFIER,         
@IsPreferred BIT=0,             
@ErrMsg VARCHAR(50) ='',  
@Action CHAR(2)='',  
@Active BIT ='',  
 @Row_Count VARCHAR(max) = '100' ,                
    @PageNumber INT = 0  
AS    
BEGIN  
DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX),@TotalRecordCount INT  ,
		   @SQL NVARCHAR(MAX) ;          
  
IF @Action='I'  
BEGIN              
 IF EXISTS (SELECT TOP 1 1 FROM GuideServices WHERE Name = @Name)              
 BEGIN              
  SET @ReturnCode = '201';    
  SET @ReturnMessage = 'Service Name already exists!';  
  SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;   
  RETURN;  
 END              
 ELSE              
 BEGIN              
  INSERT INTO GuideServices              
      (Name, ShortDescription, DetailedDescription, IsActive, Operation, OperationBy, OperationOn, IsPreferred)              
  VALUES (@Name, @ShortDescription, @DetailedDescription, @IsActive, 'Insert', @OperationBy, GETDATE(), @IsPreferred);              
              
  SET @Code = SCOPE_IDENTITY();  
  EXEC usp_InsertGuideServices_Audit @Code, 'Insert', @OperationBy;  
            
  SET @ReturnCode = '200';            
  SET @ReturnMessage = 'Service Inserted Successfully.';  
  SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;  
 END              
END  
ELSE IF @Action='U'  
BEGIN          
 IF EXISTS (SELECT TOP 1 1 FROM GuideServices WHERE Name = @Name AND Code != @Code)          
 BEGIN          
  SET @ReturnCode = '201';    
  SET @ReturnMessage = 'Service already exists!';  
  SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;   
  RETURN;  
 END          
 ELSE          
 BEGIN          
  UPDATE GuideServices          
  SET  Name = @Name,          
       ShortDescription = @ShortDescription,          
       DetailedDescription = @DetailedDescription,          
       IsActive = @IsActive,          
       Operation = 'Update'          
       ,UpdatedBy = @OperationBy
				,UpdatedOn = GETDATE()   ,   
       IsPreferred = @IsPreferred         
  WHERE Code = @Code;  
          
  EXEC usp_InsertGuideServices_Audit @Code, 'Update', @OperationBy;  
            
  SET @ReturnCode = '200';            
  SET @ReturnMessage = 'Service Updated Successfully.';  
  SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;   
 END          
END  
ELSE IF @Action='S'  
BEGIN              
 IF @Active = 1             
 BEGIN 
 IF OBJECT_ID('TEMPDB..#TempReport') IS NOT NULL                  
   DROP TABLE #TempReport 

  SELECT Code, Name, ShortDescription, DetailedDescription, IsActive, IsPreferred,  
         ImageExists = CASE WHEN EXISTS (SELECT ID FROM UploadImage WHERE ParentPageType = 1 AND ParentID = Code) THEN 1 ELSE 0 END  
		 INTO #TempReport
  FROM GuideServices               
  WHERE IsActive = 1             
  ORDER BY Name
  
 SELECT @TotalRecordCount = count(*)                  
  FROM #TempReport                  
                  
  IF @Row_Count = ''                  
   OR @Row_Count = - 1                  
  BEGIN                  
   SET @Row_Count = @TotalRecordCount                  
  END                  
                  
  SELECT @SQL = 'select * FROM #TempReport                                                                                                                          
    ORDER BY Name                                                                              
    OFFSET ' + CAST((@PageNumber * @Row_Count) AS VARCHAR(20)) + ' ROWS                      
    FETCH NEXT ' + CAST(@Row_Count AS VARCHAR(20)) + ' ROWS ONLY'                  
                  
  
  SET @ReturnCode = '200';  
  SET @ReturnMessage = 'Success';  
 END              
 ELSE              
 BEGIN 
 
 IF OBJECT_ID('TEMPDB..#TempReport1') IS NOT NULL                  
   DROP TABLE #TempReport1 
  SELECT Code, Name, ShortDescription, DetailedDescription, IsActive, IsPreferred,  
         ImageExists = CASE WHEN EXISTS (SELECT ID FROM UploadImage WHERE ParentPageType = 1 AND ParentID = Code) THEN 1 ELSE 0 END   
		 INTO #TempReport1
  FROM GuideServices             
  ORDER BY Name 
  
  SELECT @TotalRecordCount = count(*)                  
  FROM #TempReport1                  
                  
  IF @Row_Count = ''                  
   OR @Row_Count = - 1                  
  BEGIN                  
   SET @Row_Count = @TotalRecordCount                  
  END                  
                  
  SELECT @SQL = 'select * FROM #TempReport1                                                                                                                          
    ORDER BY Name                                                                              
    OFFSET ' + CAST((@PageNumber * @Row_Count) AS VARCHAR(20)) + ' ROWS                      
    FETCH NEXT ' + CAST(@Row_Count AS VARCHAR(20)) + ' ROWS ONLY'                  
                  
 
  SET @ReturnCode = '200';  
  SET @ReturnMessage = 'Success';  
 END  
 
  EXEC sys.sp_executesql @SQL
    
	select  CAST(@TotalRecordCount AS VARCHAR(20))  as Row_Count

 SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;   
END  
ELSE    
BEGIN    
  SET @ReturnCode = '201';    
  SET @ReturnMessage = 'Invalid Action';  
  SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;    
END    
END  
