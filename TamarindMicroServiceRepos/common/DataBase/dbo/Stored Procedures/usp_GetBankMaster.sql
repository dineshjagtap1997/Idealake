<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_GetBankMaster]   
 @Action char(2)='',
 @BankName Varchar(100) = NULL 
     
AS  
BEGIN  
IF @Action='S'  
BEGIN    
  SELECT BankID,BankName FROM BankMaster    
END  
ELSE IF @Action='EX'
BEGIN
 SELECT BankName FROM BankMaster 
END

ELSE IF @Action='I'
BEGIN

IF EXISTS (
    SELECT 1 
    FROM [dbo].[BankMaster] 
    WHERE BankName = @BankName
)
BEGIN
    SELECT '201' AS returnCode,
           'Bank Name already exists.' AS returnMessage;
END
ELSE
BEGIN
    INSERT INTO [dbo].[BankMaster] ([BankName])
    VALUES (@BankName);

    SELECT '200' AS returnCode,
           'Bank Name inserted successfully.' AS returnMessage;
END


END

=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿CREATE PROCEDURE [dbo].[usp_GetBankMaster]     
 @Action char(2)='',  
 @BankName Varchar(100) = NULL   
       
AS    
BEGIN    
IF @Action='S'    
BEGIN      
  SELECT BankID,BankName FROM BankMaster     ORDER by 1 DESC  
END    
ELSE IF @Action='EX'  
BEGIN  
 SELECT BankName FROM BankMaster   
END  
  
ELSE IF @Action='I'  
BEGIN  
  
IF EXISTS (  
    SELECT 1   
    FROM [dbo].[BankMaster]   
    WHERE BankName = @BankName  
)  
BEGIN  
    SELECT '201' AS returnCode,  
           'Bank Name already exists.' AS returnMessage;  
END  
ELSE  
BEGIN  
    INSERT INTO [dbo].[BankMaster] ([BankName])  
    VALUES (@BankName);  
  
    SELECT '200' AS returnCode,  
           'Bank Name inserted successfully.' AS returnMessage;  
END  
  
  
END  
  
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END