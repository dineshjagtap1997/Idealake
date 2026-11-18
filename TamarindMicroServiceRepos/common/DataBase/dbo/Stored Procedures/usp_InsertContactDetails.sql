CREATE PROCEDURE [dbo].[usp_InsertContactDetails]                                  (                          
@ContactDetailsID int = null ,                  
@ParentID int = null ,                                                    
@TypeID tinyint = null ,                                                   
@IsPrimaryContact bit = 0 ,                                                    
@SalutationID int = null ,                                                   
@FirstName varchar(50) = '' ,                                                    
@LastName varchar(50)= '' ,                                                     
@DesignationOrDepartment varchar(100)= '' ,                                                    
@EmailID varchar(200)= '' ,                                                     
@OfficeNo varchar(20)= '' ,                                                    
@MobileNo varchar(20)= '' ,                                                     
@FaxNo varchar(20)= '' ,                                                
@DateOfBirth datetime= '' ,                                           
@CityIATACode VARCHAR(13)=NULL ,                       
@InsertedDate datetime = '',                                    
@IsActive bit = 0,                             
@IsAccStatement bit = 0,                          
@IsCC BIT = 0   ,                      
@IsForContracting BIT=0,                      
@IsBills BIT = 0,                      
@CreatedBy UNIQUEIDENTIFIER = NULL,                  
@Action CHAR(2) = 'S'       
,@OperationBy UNIQUEIDENTIFIER = NULL      
)                                                    
AS                                                    
BEGIN          
declare @LogID int ;        
IF @Action = 'I'     
IF EXISTS (SELECT 1 FROM ContactDetails WHERE EmailID =@EmailID  AND EmailID IS NOT NULL     
           AND TRIM(EmailID) <> '' )                                                                          
 BEGIN                                                                             
                                      
  SELECT '201' AS returnCode, 'Email ID  already exist. Please check and try again.' AS returnMessage                                    
 END      
 ELSE    
  IF EXISTS (SELECT 1 FROM ContactDetails WHERE  MobileNo = @MobileNo AND MobileNo = @MobileNo AND MobileNo IS NOT NULL     
           AND TRIM(MobileNo) <> '')                                                                          
 BEGIN                                                                             
                                      
  SELECT '201' AS returnCode, 'Mobile no already exist. Please check and try again.' AS returnMessage                                    
 END    
 ELSE     
    
BEGIN                  
INSERT INTO ContactDetails (ParentID,TypeID,IsPrimaryContact,SalutationID,FirstName,LastName,                                                    
       DesignationOrDepartment,EmailID,OfficeNo,MobileNo,FaxNo,DateofBirth,CityIATACode ,IsActive,IsAccStatement,IsCC ,IsForContracting , InsertedDate , IsBills , CreatedBy                                                 
       )                                                    
   VALUES (@ParentID,@TypeID,@IsPrimaryContact,@SalutationID,@FirstName,@LastName,@DesignationOrDepartment,                                                    
     @EmailID,@OfficeNo,@MobileNo,@FaxNo,@DateOfBirth,@CityIATACode,@IsActive,@IsAccStatement ,@IsCC,@IsForContracting ,GETDATE(), @IsBills , @CreatedBy                                    
     )                              
             
  SET @LogID = SCOPE_IDENTITY()        
  SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @LogID AS ID                     
END          
    
    
ELSE IF @Action = 'U'       
IF NOT EXISTS (                                          
    SELECT TOP 1 1                                          
    FROM ContactDetails                   
    WHERE  EmailID != @EmailID        
    )                                                                     
 BEGIN                                                                             
                                      
  SELECT '201' AS returnCode, 'Email ID  Already Exist. Please check and try again.' AS returnMessage                                    
 END      
 ELSE    
  IF NOT EXISTS (                                          
    SELECT TOP 1 1                                          
    FROM ContactDetails                   
    WHERE  MobileNo != @MobileNo                                          
    )                                                                       
 BEGIN                                                                             
                                      
  SELECT '201' AS returnCode, 'Contact Details Already Exist. Please check and try again.' AS returnMessage                                    
 END    
 ELSE     
BEGIN                  
UPDATE ContactDetails                  
SET                   
    ParentID = @ParentID,                  
    TypeID = @TypeID,                  
    IsPrimaryContact = @IsPrimaryContact,                  
    SalutationID = @SalutationID,                  
    FirstName = @FirstName,                  
    LastName = @LastName,                  
    DesignationOrDepartment = @DesignationOrDepartment,                  
    EmailID = @EmailID,                  
    OfficeNo = @OfficeNo,                  
    MobileNo = @MobileNo,                  
    FaxNo = @FaxNo,                  
    DateOfBirth = @DateOfBirth,                  
    CityIATACode = @CityIATACode,                  
    IsActive = @IsActive,                  
    IsAccStatement = @IsAccStatement,                  
    IsCC = @IsCC,                  
    IsForContracting = @IsForContracting,                  
    IsBills = @IsBills,                  
    CreatedBy = @CreatedBy,                  
    InsertedDate = GETDATE()                  
WHERE ContactDetailsID = @ContactDetailsID;                  
                          
                      
  SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage,   @ContactDetailsID AS ID                  
END                  
ELSE IF @Action = 'S'                  
BEGIN                  
Select *, C.Name AS CityName from ContactDetails  CD                
INNER JOIN CITY C ON C.IATACode = CD.CityIATACode                
WHERE (@ContactDetailsID IS NULL OR @ContactDetailsID = 0 OR ContactDetailsID = @ContactDetailsID)               
and ( @ParentID is null or @ParentID = ParentID or @ParentID = 0)              
ORDER BY ContactDetailsID DESC                  
--SELECT '' AS returnCode, '' AS returnMessage                  
END    
ELSE IF @Action = 'EX'                  
BEGIN                  
Select IsPrimaryContact, FirstName, LastName, DesignationOrDepartment, EmailID, OfficeNo, MobileNo, FaxNo, DateofBirth, CityIATACode,
CD.IsActive, IsAccStatement, IsCC, IsForContracting, IsBills, C.Name AS CityName 
from ContactDetails  CD                
INNER JOIN CITY C ON C.IATACode = CD.CityIATACode                
WHERE (@ContactDetailsID IS NULL OR @ContactDetailsID = 0 OR ContactDetailsID = @ContactDetailsID)               
and ( @ParentID is null or @ParentID = ParentID or @ParentID = 0)              
ORDER BY ContactDetailsID DESC                  
--SELECT '' AS returnCode, '' AS returnMessage                  
END    
END                 