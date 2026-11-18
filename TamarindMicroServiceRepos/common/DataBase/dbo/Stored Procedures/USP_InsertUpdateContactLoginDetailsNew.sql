<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[USP_InsertUpdateContactLoginDetailsNew] (                      
=======
﻿
CREATE PROCEDURE [dbo].[USP_InsertUpdateContactLoginDetailsNew] (                      
>>>>>>> dev
=======
﻿
CREATE PROCEDURE [dbo].[USP_InsertUpdateContactLoginDetailsNew] (                      
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    @Action char(2)='',                      
    @ContactDetailsID INT = NULL,                      
    @ParentID INT = NULL,                      
    @TypeID TINYINT = NULL,                      
    @IsPrimaryContact BIT = NULL,                      
    @SalutationID INT = NULL,                      
    @FirstName VARCHAR(50) = NULL,                      
    @DesignationOrDepartment VARCHAR(100) = NULL,                      
    @EmailID VARCHAR(200) = NULL,                      
    @MobileNo VARCHAR(20) = NULL,                      
    @DateofBirth DATETIME = NULL,                      
    @CityIATACode VARCHAR(13) = NULL,                      
    @IsActive BIT = 0,                      
    @UserID VARCHAR(150) = NULL,                      
    @Password VARCHAR(150) = NULL,                      
    @IsAdminUser BIT = NULL,                      
    @IsEmail BIT = NULL,                      
    @IsAccStatement BIT = NULL,                      
    @IsCCtoAdmin BIT = NULL,                      
    @IsOnlineBookingAccess BIT = NULL,                      
    @IsXMLUser BIT = NULL,                      
    @IsCC BIT = 0,                      
    @IsB2BLogin BIT = 0,                      
    @IsB2CLogin BIT = 0,          
<<<<<<< HEAD
<<<<<<< HEAD
 @OperationBy UNIQUEIDENTIFIER = NULL           
=======
 @OperationBy UNIQUEIDENTIFIER = NULL         ,
	@OfficeNo nvarchar(30)=''      
>>>>>>> dev
=======
 @OperationBy UNIQUEIDENTIFIER = NULL         ,
	@OfficeNo nvarchar(30)=''      
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
          
)                      
AS                      
BEGIN               
declare @LogID int ;              
    DECLARE @ReturnCode INT                      
    DECLARE @ReturnMessage NVARCHAR(200)                      
                      
    IF @Action = 'S'                      
    BEGIN                      
                           
            SELECT *                       
            FROM ContactDetails                      
<<<<<<< HEAD
<<<<<<< HEAD
            WHERE (@ParentID IS NULL OR @ParentID =0 OR ParentID = @ParentID)      AND  (@ContactDetailsID IS NULL OR @ContactDetailsID =0 OR ContactDetailsID = @ContactDetailsID)                
              ORDER BY     ContactDetailsID DESC     
=======
            WHERE (@ParentID IS NULL OR @ParentID =0 OR ParentID = @ParentID)      AND  (@ContactDetailsID IS NULL OR @ContactDetailsID =0 OR ContactDetailsID = @ContactDetailsID)
				AND TypeID=3
              ORDER BY     ContactDetailsID DESC        
>>>>>>> dev
=======
            WHERE (@ParentID IS NULL OR @ParentID =0 OR ParentID = @ParentID)      AND  (@ContactDetailsID IS NULL OR @ContactDetailsID =0 OR ContactDetailsID = @ContactDetailsID)
				AND TypeID=3
              ORDER BY     ContactDetailsID DESC        
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            SET @ReturnCode = 200                      
            SET @ReturnMessage = 'Data retrieved successfully.'                     
   --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage                      
                       
    END                      
    ELSE IF @Action = 'U'      
   
  IF NOT EXISTS (                                              
    SELECT TOP 1 1                                              
    FROM ContactDetails                       
    WHERE  EmailID != @EmailID                                              
    )                                                                             
 BEGIN                                                                                 
                                          
  SELECT '201' AS returnCode, 'Email ID  already exist. Please check and try again.' AS returnMessage                                        
 END          
 ELSE        
  IF NOT EXISTS (                                              
    SELECT TOP 1 1                                              
    FROM ContactDetails                       
    WHERE  MobileNo != @MobileNo                                              
    )                                                                         
 BEGIN                                                                                 
                                          
  SELECT '201' AS returnCode, 'Mobile no already exist. Please check and try again.' AS returnMessage                                        
 END        
 ELSE         
        
    BEGIN                      
        IF EXISTS (                      
            SELECT 1                       
            FROM ContactDetails                      
            WHERE ContactDetailsID = @ContactDetailsID                      
        )                      
        BEGIN                      
            UPDATE ContactDetails                      
            SET IsPrimaryContact = @IsPrimaryContact,                      
                SalutationID = @SalutationID,                      
 FirstName = @FirstName,                      
                DesignationOrDepartment = @DesignationOrDepartment,                      
                EmailID = @EmailID,                      
         MobileNo = @MobileNo,                      
                DateofBirth = @DateofBirth,                      
                CityIATACode = @CityIATACode,                      
                IsActive = @IsActive,                      
                IsAccStatement = @IsAccStatement,                      
<<<<<<< HEAD
<<<<<<< HEAD
                IsCC = @IsCC                      
=======
                IsCC = @IsCC   ,
				OfficeNo=@OfficeNo                   
>>>>>>> dev
=======
                IsCC = @IsCC   ,
				OfficeNo=@OfficeNo                   
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
         WHERE ContactDetailsID = @ContactDetailsID                      
                      
            SET @ReturnCode = 200                      
            SET @ReturnMessage = 'Record updated successfully.'                     
   SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage , @ContactDetailsID AS ID                      
        END                      
        ELSE                      
        BEGIN                      
            SET @ReturnCode = 404                      
            SET @ReturnMessage = 'Record not found.'                      
   SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage                      
        END                      
    END               
   
   
    ELSE IF @Action = 'I'           
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
        INSERT INTO ContactDetails (                      
            ParentID, TypeID, IsPrimaryContact, SalutationID,                      
            FirstName, DesignationOrDepartment, EmailID, MobileNo,                      
<<<<<<< HEAD
<<<<<<< HEAD
            DateofBirth, CityIATACode, IsActive, IsCC, IsAccStatement                      
=======
            DateofBirth, CityIATACode, IsActive, IsCC, IsAccStatement ,OfficeNo                        
>>>>>>> dev
=======
            DateofBirth, CityIATACode, IsActive, IsCC, IsAccStatement ,OfficeNo                        
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        )                      
        VALUES (                      
            @ParentID, @TypeID, @IsPrimaryContact, @SalutationID,                      
            @FirstName, @DesignationOrDepartment, @EmailID, @MobileNo,                      
<<<<<<< HEAD
<<<<<<< HEAD
            @DateofBirth, @CityIATACode, @IsActive, @IsCC, @IsAccStatement                      
=======
            @DateofBirth, @CityIATACode, @IsActive, @IsCC, @IsAccStatement  ,@OfficeNo                    
>>>>>>> dev
=======
            @DateofBirth, @CityIATACode, @IsActive, @IsCC, @IsAccStatement  ,@OfficeNo                    
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        )                      
                      
  set @LogID = SCOPE_IDENTITY()              
        SET @ReturnCode = 200                
        SET @ReturnMessage = 'New record added successfully.'                    
  SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID AS ID                      
  END                      
                   
                      
    --SELECT @ReturnCode AS ReturnCode, @ReturnMessage AS ReturnMessage        
   
 else if @Action = 'ex'  
 begin  
   SELECT   
   CASE   
        WHEN IsPrimaryContact = 1 THEN 'Yes'  
        WHEN IsPrimaryContact = 0 THEN 'No'  
    END AS IsPrimaryContact,   
   FirstName,   
   LastName,    
   DesignationOrDepartment,   
   EmailID,   
   OfficeNo,   
   MobileNo,   
   FaxNo,   
   DateofBirth,   
   CityIATACode,  
   CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive,   
   CASE   
        WHEN IsAccStatement = 1 THEN 'Yes'  
        WHEN IsAccStatement = 0 THEN 'No'  
    END AS IsAccStatement,  
   CASE   
        WHEN IsCC = 1 THEN 'Yes'  
        WHEN IsCC = 0 THEN 'No'  
    END AS IsCC,  
   CASE   
        WHEN IsForContracting = 1 THEN 'Yes'  
        WHEN IsForContracting = 0 THEN 'No'  
    END AS IsForContracting,  
      
   CASE   
        WHEN IsBills = 1 THEN 'Yes'  
        WHEN IsBills = 0 THEN 'No'  
    END AS IsBills  
            FROM ContactDetails                      
            WHERE (@ParentID IS NULL OR @ParentID =0 OR ParentID = @ParentID)      AND  (@ContactDetailsID IS NULL OR @ContactDetailsID =0 OR ContactDetailsID = @ContactDetailsID)                
              ORDER BY     ContactDetailsID DESC     
 end  
  
 ELSE                     
  BEGIN                      
        SET @ReturnCode = 400              SET @ReturnMessage = 'Invalid action specified.'                     
  SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage                      
  END       
END                      