                          
CREATE PROCEDURE [dbo].[usp_UpdateContactDetails_New]                            
(                               
@ContactDetailsID int,                               
@ParentID int,                                
@TypeID tinyint,                                
@IsPrimaryContact bit,                                
@SalutationID int,                                
@FirstName varchar(50),                                
@LastName varchar(50),                                
@DesignationOrDepartment varchar(100),                                
@EmailID varchar(200),                                
@OfficeNo varchar(20),                                
@MobileNo varchar(20),                                
@FaxNo varchar(20),                          
--@DateofBirth datetime,                      
@CityIATACode char(3)=NULL ,                    
@IsActive tinyint,              
@IsAccStatement bit,          
@IsCC BIT = 0,      
@IsForContracting BIT=0,      
--@UpdatedDate varchar(20),      
@IsBills BIT = 0   ,
@Action CHAR(2)  
)                                
AS                                
BEGIN                                
                              
IF EXISTS (SELECT  ContactDetailsID FROM ContactDetails WHERE ContactDetailsID=@ContactDetailsID)                            
 BEGIN                            
 UPDATE ContactDetails SET                              
                               
 TypeID=@TypeID,                              
 IsPrimaryContact=@IsPrimaryContact,                              
 SalutationID=@SalutationID,                              
 FirstName=@FirstName,                              
 LastName=@LastName,                              
 DesignationOrDepartment=@DesignationOrDepartment,                              
 EmailID=@EmailID,                              
 OfficeNo=@OfficeNo,                              
 MobileNo=@MobileNo,                              
 FaxNo=@FaxNo,                          
 --DateofBirth=@DateofBirth,                      
 CityIATACode=@CityIATACode ,                    
 IsActive=@IsActive,              
 IsAccStatement=@IsAccStatement,          
 IsCC = @IsCC ,--sagar     ,      
 IsForContracting= @IsForContracting,                                    
-- UpdatedDate = getdate() ,      
 IsBills = @IsBills                               
 WHERE ContactDetailsID=@ContactDetailsID     
 --added by Neha
 Select '200' as returnCode, 'Data Updated' as returnMessage
 END                            
ELSE                            
BEGIN                            
 INSERT INTO ContactDetails (ParentID,TypeID,IsPrimaryContact,SalutationID,FirstName,LastName,DesignationOrDepartment,EmailID,                            
    OfficeNo,MobileNo,FaxNo,CityIATACode,IsActive,IsAccStatement,IsCC,IsForContracting,InsertedDate, IsBills)                            
 VALUES(@ParentID,@TypeID,@IsPrimaryContact,@SalutationID,@FirstName,@LastName,@DesignationOrDepartment,@EmailID,@OfficeNo,@MobileNo,@FaxNo,                    
 @CityIATACode,@IsActive,@IsAccStatement,@IsCC,@IsForContracting,Getdate(), @IsBills )                            
 --added by Neha
 Select '200' as returnCode, 'Data Inserted' as returnMessage                            
END                            
END 