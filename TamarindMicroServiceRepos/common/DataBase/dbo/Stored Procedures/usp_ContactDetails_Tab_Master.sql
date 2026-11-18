<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_ContactDetails_Tab_Master] (                              
 @ParentID INT = ''                              
 ,@TypeID TINYINT = ''                              
 ,@IsPrimaryContact BIT = 0                              
 ,@SalutationID INT = ''                              
 ,@FirstName VARCHAR(50) = ''                              
 ,@LastName VARCHAR(50) = ''                              
 ,@DesignationOrDepartment VARCHAR(100) = ''                              
 ,@EmailID VARCHAR(200) = ''                              
 ,@OfficeNo VARCHAR(20) = ''                              
 ,@MobileNo VARCHAR(20)= ''                              
 ,@FaxNo VARCHAR(20) = ''                              
 ,@DateofBirth DATETIME = ''                              
 ,@CityIATACode VARCHAR(13) = NULL                              
 ,@InsertedDate DATETIME = ''                              
 ,@IsActive BIT = 1                              
 ,@IsAccStatement BIT = 0                              
 ,@IsCC BIT = 0                              
 ,@IsForContracting BIT = 0                              
 ,@IsBills BIT = 0                              
 ,@CreatedBy UNIQUEIDENTIFIER = NULL                              
 ,@ContactDetailsID INT=''                              
 ,@ID INT=''                              
 ,@Action char=''                 
 ,@OperationBy UNIQUEIDENTIFIER = NULL                              
              
 )                              
AS                              
BEGIN                  
              
declare @LogID INT;              
IF @Action='I'           
IF EXISTS (SELECT 1 FROM ContactDetails WHERE EmailID =@EmailID  AND EmailID IS NOT NULL           
           AND TRIM(EmailID) <> '' and ParentID = @ParentID)                                                                                
 BEGIN                                                                                   
                                            
  SELECT '201' AS returnCode, 'Email ID  already exist. Please check and try again.' AS returnMessage                                          
 END            
           
         
 ELSE           
BEGIN           
 INSERT INTO ContactDetails (                              
  ParentID                              
  ,TypeID                              
  ,IsPrimaryContact                              
  ,SalutationID                              
  ,FirstName                              
  ,LastName                              
  ,DesignationOrDepartment                              
  ,EmailID                              
  ,OfficeNo                              
  ,MobileNo                              
  ,FaxNo                              
  ,DateofBirth                              
  ,CityIATACode                              
  ,IsActive                              
  ,IsAccStatement                              
  ,IsCC                              
  ,IsForContracting                              
  ,InsertedDate                              
  ,IsBills                              
  ,CreatedBy                              
  )                              
 VALUES (                              
  @ParentID                              
  ,@TypeID                              
  ,@IsPrimaryContact                              
  ,@SalutationID                              
  ,@FirstName                              
  ,@LastName                              
  ,@DesignationOrDepartment                              
  ,@EmailID                              
  ,@OfficeNo                              
  ,@MobileNo                              
  ,@FaxNo                              
  ,@DateofBirth                              
  ,@CityIATACode                              
  ,@IsActive                              
  ,@IsAccStatement                              
  ,@IsCC                              
  ,@IsForContracting                              
  ,GETDATE()                              
  ,@IsBills                              
  ,@CreatedBy                      
  )                            
                
  SET @LogID = SCOPE_IDENTITY()              
  SELECT '200' as returnCode,'New record added successfully.' AS returnMessage , @LogID AS ID                        
END                              
ELSE IF @Action='U'          
      
IF NOT EXISTS (                                              
    SELECT TOP 1 1                                              
    FROM ContactDetails                       
    WHERE  EmailID != @EmailID                                              
    )                                                                               
 BEGIN                                          
                                            
  SELECT '201' AS returnCode, 'Email ID  already exist. Please check and try again.' AS returnMessage                                          
 END            
         
 ELSE           
BEGIN                              
 IF EXISTS (                              
   SELECT ContactDetailsID                              
   FROM ContactDetails                              
   WHERE ContactDetailsID = @ContactDetailsID                              
   )                              
 BEGIN                              
  UPDATE ContactDetails                              
  SET TypeID = @TypeID                              
   ,IsPrimaryContact = @IsPrimaryContact                              
   ,SalutationID = @SalutationID                              
   ,FirstName = @FirstName                              
   ,LastName = @LastName                              
   ,DesignationOrDepartment = @DesignationOrDepartment                              
   ,EmailID = @EmailID                              
   ,OfficeNo = @OfficeNo                              
   ,MobileNo = @MobileNo                              
   ,FaxNo = @FaxNo                              
   ,DateofBirth = @DateofBirth                              
   ,CityIATACode = @CityIATACode                              
   ,IsActive = @IsActive                              
   ,IsAccStatement = @IsAccStatement                              
   ,IsCC = @IsCC                              
   ,--sagar     ,                                  
   IsForContracting = @IsForContracting                              
   ,UpdatedOn = GETDATE()                              
   ,IsBills = @IsBills                              
   ,UpdatedBy = @CreatedBy                              
  WHERE ContactDetailsID = @ContactDetailsID                              
    SELECT '200' as returnCode,'Record updated successfully.' AS returnMessage , @ContactDetailsID AS ID                             
                              
 END                              
 ELSE           
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
ParentID                              
   ,TypeID                              
   ,IsPrimaryContact                              
   ,SalutationID                              
   ,FirstName                              
   ,LastName                              
   ,DesignationOrDepartment                              
   ,EmailID                        
   ,OfficeNo                              
   ,MobileNo             
   ,FaxNo                
   ,DateofBirth                              
   ,CityIATACode                              
   ,IsActive                              
   ,IsAccStatement                              
   ,IsCC                              
   ,IsForContracting                              
  ,InsertedDate                              
   ,IsBills                              
   ,CreatedBy                              
   )                              
  VALUES (                              
   @ParentID                              
   ,@TypeID                              
   ,@IsPrimaryContact                              
   ,@SalutationID                              
   ,@FirstName                              
   ,@LastName                              
   ,@DesignationOrDepartment                    
   ,@EmailID                              
   ,@OfficeNo                              
   ,@MobileNo                              
   ,@FaxNo                              
   ,@DateofBirth                              
   ,@CityIATACode                              
   ,@IsActive                              
   ,@IsAccStatement                              
   ,@IsCC                              
   ,@IsForContracting                              
   ,Getdate()                              
,@IsBills                              
   ,@CreatedBy                              
   )                              
 END                              
END                              
ELSE IF @Action='S'                              
BEGIN                              
                           
                              
 IF (@TypeID = 1)                              
 BEGIN                              
  SELECT Country.IATACode ,FirstName                              
  ,LastName                                 
   ,HM.HotelName AS DisplayName,--City.IATACode as CityIATACode,   
   cd.CityIATACode,  
   City.Name as CityName, CD.DesignationOrDepartment, CD.EmailID, CD.ContactDetailsID, CD.DateofBirth, CD.CreatedBy, HM.FaxNo, HM.HotelID                    
  ,cd.IsPrimaryContact, CD.IsForContracting, CD.IsCC, CD.IsActive, CD.IsBills, CD.IsAccStatement, CD.InsertedDate, CD.TypeID, CD.SalutationID, CD.ParentID, CD.OfficeNo, CD.MobileNo                    
  FROM HotelMaster HM                        
  INNER JOIN ContactDetails  CD ON CD.ParentID = HM.HotelID AND cd.TypeID=1                        
  INNER JOIN City ON HM.CityIATACode = City.IATACode                              
  INNER JOIN STATE ON City.State_IATACode = STATE.State_ID                              
  INNER JOIN Country ON STATE.Country_IATACode = Country.IATACode                          
                         
  WHERE                   
 -- HotelID = @ID or @ID = 0 or @ID = null                       
  --AND                    
  (ContactDetailsID = @ContactDetailsID    or @ContactDetailsID = 0 or @ContactDetailsID = null)                   
   and (@ParentID is null or @ParentID = 0 or @ParentID = CD.ParentID)               
   order by ContactDetailsID desc            
 END                              
 ELSE IF (@TypeID = 2)                              
 BEGIN                              
  SELECT Country.IATACode                              
   ,VendorMaster.VendorName AS DisplayName, City.Name as CityName, VendorMaster.EmailID     ,City.IATACode as CityIATACode                    
  FROM VendorMaster                              
  INNER JOIN City ON VendorMaster.CityIATACode = City.IATACode                              
  INNER JOIN STATE ON City.State_IATACode = STATE.State_ID                              
  INNER JOIN Country ON STATE.Country_IATACode = Country.IATACode                  
  WHERE VendorID = @ID    or @ID = 0 or @ID = null                         
  order by VendorID desc            
 END                              
 ELSE IF (@TypeID = 3)                              
 BEGIN                              
  SELECT Country.IATACode                              
   ,AgentMaster.AgentName AS DisplayName, City.Name as CityName, AgentMaster.EmailID  ,City.IATACode as CityIATACode                     
  FROM AgentMaster      
  INNER JOIN City ON AgentMaster.City_IATACode = City.IATACode                              
  INNER JOIN STATE ON City.State_IATACode = STATE.State_ID                              
  INNER JOIN Country ON STATE.Country_IATACode = Country.IATACode                              
  WHERE AgentID = @ID    or @ID = 0 or @ID = null                     
  order by agentid desc            
 END                              
 else -----------------------------------------------------------------------------------------------------------------------------                          
 SELECT ContactDetailsID                              
  ,ParentID                              
  ,TypeID                              
  ,IsPrimaryContact                              
  ,Cd.SalutationID                              
  ,FirstName                              
  ,LastName                              
  ,DesignationOrDepartment                              
  ,EmailID                              
  ,OfficeNo                              
  ,MobileNo                              
  ,FaxNo                              
,S.Salutation AS Salutation                              
  ,Replace(CONVERT(VARCHAR(15), DateOfBirth, 106), ' ', '-') AS DateOfBirth                              
  ,CityIATACode                              
  ,City.Name AS CityName                              
  --,Cd.IsActive   commneted by sanket @ 23/11/2015                                
  ,CASE                               
   WHEN Cd.TypeID = 3                              
THEN Cd.IsActive                              
   ELSE Cd.IsActive                              
   END AS IsActive -- if agent then contact isactive from  AgentLogin else contactdetails page                                                                       
  ,Cd.IsForContracting                              
  ,ISNULL(Cd.IsAccStatement, 0) AS IsAccStatement                              
  ,ISNULL(AL.IsB2BLogin, 0) AS IsB2BLogin                              
  ,isnull(AL.IsB2CLogin, 0) AS IsB2CLogin                              
  ,ISNULL(Cd.IsCC, 0) AS IsCC --Sagar                                                                      
  ,IsForContracting                              
  ,InsertedDate                              
  --,UpdatedDate                              
  ,IsBills                              
  ,CreatedBy                              
 FROM ContactDetails Cd                              
 LEFT JOIN City ON Cd.CityIATACode = City.IATACode                              
 LEFT JOIN Salutation S ON Cd.SalutationID = S.SalutationID                              
 LEFT JOIN AgentLogin AL ON AL.AgentContactID = Cd.ContactDetailsID                              
 AND Cd.TypeID = 3 --added by sanket @ 23/11/2015                                    
 WHERE --(TypeID = @TypeID    or @ID = 0 or @ID = null)                          
  --AND (ParentID = @ID    or @ID = 0 or @ID = null)                      
 -- AND                  
 (ContactDetailsID = @ContactDetailsID    or @ContactDetailsID = 0 or @ContactDetailsID = null)                  
 and (@ParentID is null or @ParentID = 0 or @ParentID = CD.ParentID)    and (@TypeID is null or @TypeID = 0 or @TypeID = cd.TypeID)            
 order by ContactDetailsID desc            
END                              
                              
                        
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿CREATE PROCEDURE [dbo].[usp_ContactDetails_Tab_Master] (
	@ParentID INT = ''
	,@TypeID TINYINT = ''
	,@IsPrimaryContact BIT = 0
	,@SalutationID INT = ''
	,@FirstName VARCHAR(50) = ''
	,@LastName VARCHAR(50) = ''
	,@DesignationOrDepartment VARCHAR(100) = ''
	,@EmailID VARCHAR(200) = ''
	,@OfficeNo VARCHAR(20) = ''
	,@MobileNo VARCHAR(20) = ''
	,@FaxNo VARCHAR(20) = ''
	,@DateofBirth DATETIME = ''
	,@CityIATACode VARCHAR(13) = NULL
	,@InsertedDate DATETIME = ''
	,@IsActive BIT = 1
	,@IsAccStatement BIT = 0
	,@IsCC BIT = 0
	,@IsForContracting BIT = 0
	,@IsBills BIT = 0
	,@CreatedBy UNIQUEIDENTIFIER = NULL
	,@ContactDetailsID INT = ''
	,@ID INT = ''
	,@Action CHAR = ''
	,@OperationBy UNIQUEIDENTIFIER = NULL
	,@HideNumberEmail BIT = NULL
	)
AS
BEGIN
	DECLARE @LogID INT;

	IF @Action = 'I'
		IF EXISTS (
				SELECT 1
				FROM ContactDetails
				WHERE EmailID = @EmailID
					AND EmailID IS NOT NULL
					AND TRIM(EmailID) <> ''
					AND ParentID = @ParentID
				)
		BEGIN
			SELECT '201' AS returnCode
				,'Email ID  already exist. Please check and try again.' AS returnMessage
		END
		ELSE
		BEGIN
			INSERT INTO ContactDetails (
				ParentID
				,TypeID
				,IsPrimaryContact
				,SalutationID
				,FirstName
				,LastName
				,DesignationOrDepartment
				,EmailID
				,OfficeNo
				,MobileNo
				,FaxNo
				,DateofBirth
				,CityIATACode
				,IsActive
				,IsAccStatement
				,IsCC
				,IsForContracting
				,InsertedDate
				,IsBills
				,CreatedBy
				,HideNumberEmail
				)
			VALUES (
				@ParentID
				,@TypeID
				,@IsPrimaryContact
				,@SalutationID
				,@FirstName
				,@LastName
				,@DesignationOrDepartment
				,@EmailID
				,@OfficeNo
				,@MobileNo
				,@FaxNo
				,@DateofBirth
				,@CityIATACode
				,@IsActive
				,@IsAccStatement
				,@IsCC
				,@IsForContracting
				,GETDATE()
				,@IsBills
				,@CreatedBy
				,@HideNumberEmail
				)

			SET @LogID = SCOPE_IDENTITY()

			SELECT '200' AS returnCode
				,'New record added successfully.' AS returnMessage
				,@LogID AS ID
		END
	ELSE IF @Action = 'U'
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM ContactDetails
				WHERE EmailID != @EmailID
				)
		BEGIN
			SELECT '201' AS returnCode
				,'Email ID  already exist. Please check and try again.' AS returnMessage
		END
		ELSE
		BEGIN
			IF EXISTS (
					SELECT ContactDetailsID
					FROM ContactDetails
					WHERE ContactDetailsID = @ContactDetailsID
					)
			BEGIN
				UPDATE ContactDetails
				SET TypeID = @TypeID
					,IsPrimaryContact = @IsPrimaryContact
					,SalutationID = @SalutationID
					,FirstName = @FirstName
					,LastName = @LastName
					,DesignationOrDepartment = @DesignationOrDepartment
					,EmailID = @EmailID
					,OfficeNo = @OfficeNo
					,MobileNo = @MobileNo
					,FaxNo = @FaxNo
					,DateofBirth = @DateofBirth
					,CityIATACode = @CityIATACode
					,IsActive = @IsActive
					,IsAccStatement = @IsAccStatement
					,IsCC = @IsCC
					,--sagar     ,                                    
					IsForContracting = @IsForContracting
					,UpdatedOn = GETDATE()
					,IsBills = @IsBills
					,UpdatedBy = @CreatedBy
					,HideNumberEmail = @HideNumberEmail
				WHERE ContactDetailsID = @ContactDetailsID

				SELECT '200' AS returnCode
					,'Record updated successfully.' AS returnMessage
					,@ContactDetailsID AS ID
			END
			ELSE IF EXISTS (
					SELECT 1
					FROM ContactDetails
					WHERE EmailID = @EmailID
						AND EmailID IS NOT NULL
						AND TRIM(EmailID) <> ''
					)
			BEGIN
				SELECT '201' AS returnCode
					,'Email ID  already exist. Please check and try again.' AS returnMessage
			END
			ELSE IF EXISTS (
					SELECT 1
					FROM ContactDetails
					WHERE MobileNo = @MobileNo
						AND MobileNo = @MobileNo
						AND MobileNo IS NOT NULL
						AND TRIM(MobileNo) <> ''
					)
			BEGIN
				SELECT '201' AS returnCode
					,'Mobile no already exist. Please check and try again.' AS returnMessage
			END
			ELSE
			BEGIN
				INSERT INTO ContactDetails (
					ParentID
					,TypeID
					,IsPrimaryContact
					,SalutationID
					,FirstName
					,LastName
					,DesignationOrDepartment
					,EmailID
					,OfficeNo
					,MobileNo
					,FaxNo
					,DateofBirth
					,CityIATACode
					,IsActive
					,IsAccStatement
					,IsCC
					,IsForContracting
					,InsertedDate
					,IsBills
					,CreatedBy
					,HideNumberEmail
					)
				VALUES (
					@ParentID
					,@TypeID
					,@IsPrimaryContact
					,@SalutationID
					,@FirstName
					,@LastName
					,@DesignationOrDepartment
					,@EmailID
					,@OfficeNo
					,@MobileNo
					,@FaxNo
					,@DateofBirth
					,@CityIATACode
					,@IsActive
					,@IsAccStatement
					,@IsCC
					,@IsForContracting
					,Getdate()
					,@IsBills
					,@CreatedBy
					,@HideNumberEmail
					)
			END
		END
	ELSE IF @Action = 'S'
	BEGIN
		IF (@TypeID = 1)
		BEGIN
			SELECT Country.IATACode
				,FirstName
				,LastName
				,HM.HotelName AS DisplayName
				,--City.IATACode as CityIATACode,     
				cd.CityIATACode
				,City.Name AS CityName
				,CD.DesignationOrDepartment
				,CD.EmailID
				,CD.ContactDetailsID
				,CD.DateofBirth
				,CD.CreatedBy
				,HM.FaxNo
				,HM.HotelID
				,cd.IsPrimaryContact
				,CD.IsForContracting
				,CD.IsCC
				,CD.IsActive
				,CD.IsBills
				,CD.IsAccStatement
				,CD.InsertedDate
				,CD.TypeID
				,CD.SalutationID
				,CD.ParentID
				,CD.OfficeNo
				,CD.MobileNo
				,CD.HideNumberEmail
			FROM HotelMaster HM
			INNER JOIN ContactDetails CD ON CD.ParentID = HM.HotelID
				AND cd.TypeID = 1
			INNER JOIN City ON HM.CityIATACode = City.IATACode
			INNER JOIN STATE ON City.State_IATACode = STATE.State_ID
			INNER JOIN Country ON STATE.Country_IATACode = Country.IATACode
			WHERE
				-- HotelID = @ID or @ID = 0 or @ID = null                         
				--AND                      
				(
					ContactDetailsID = @ContactDetailsID
					OR @ContactDetailsID = 0
					OR @ContactDetailsID = NULL
					)
				AND (
					@ParentID IS NULL
					OR @ParentID = 0
					OR @ParentID = CD.ParentID
					)
			ORDER BY ContactDetailsID DESC
		END
		ELSE IF (@TypeID = 2)
		BEGIN
			SELECT Country.IATACode
				,VendorMaster.VendorName AS DisplayName
				,City.Name AS CityName
				,VendorMaster.EmailID
				,City.IATACode AS CityIATACode
			FROM VendorMaster
			INNER JOIN City ON VendorMaster.CityIATACode = City.IATACode
			INNER JOIN STATE ON City.State_IATACode = STATE.State_ID
			INNER JOIN Country ON STATE.Country_IATACode = Country.IATACode
			WHERE VendorID = @ID
				OR @ID = 0
				OR @ID = NULL
			ORDER BY VendorID DESC
		END
		ELSE IF (@TypeID = 3)
		BEGIN
			SELECT Country.IATACode
				,AgentMaster.AgentName AS DisplayName
				,City.Name AS CityName
				,AgentMaster.EmailID
				,City.IATACode AS CityIATACode
			FROM AgentMaster
			INNER JOIN City ON AgentMaster.City_IATACode = City.IATACode
			INNER JOIN STATE ON City.State_IATACode = STATE.State_ID
			INNER JOIN Country ON STATE.Country_IATACode = Country.IATACode
			WHERE AgentID = @ID
				OR @ID = 0
				OR @ID = NULL
			ORDER BY agentid DESC
		END
		ELSE -----------------------------------------------------------------------------------------------------------------------------                            
			SELECT ContactDetailsID
				,ParentID
				,TypeID
				,IsPrimaryContact
				,Cd.SalutationID
				,FirstName
				,LastName
				,DesignationOrDepartment
				,EmailID
				,OfficeNo
				,MobileNo
				,FaxNo
				,S.Salutation AS Salutation
				,Replace(CONVERT(VARCHAR(15), DateOfBirth, 106), ' ', '-') AS DateOfBirth
				,CityIATACode
				,City.Name AS CityName
				--,Cd.IsActive   commneted by sanket @ 23/11/2015                                  
				,CASE 
					WHEN Cd.TypeID = 3
						THEN Cd.IsActive
					ELSE Cd.IsActive
					END AS IsActive -- if agent then contact isactive from  AgentLogin else contactdetails page                                                                         
				,Cd.IsForContracting
				,ISNULL(Cd.IsAccStatement, 0) AS IsAccStatement
				,ISNULL(AL.IsB2BLogin, 0) AS IsB2BLogin
				,isnull(AL.IsB2CLogin, 0) AS IsB2CLogin
				,ISNULL(Cd.IsCC, 0) AS IsCC --Sagar                                                                        
				,IsForContracting
				,InsertedDate
				--,UpdatedDate                                
				,IsBills
				,CreatedBy
				,Cd.HideNumberEmail
			FROM ContactDetails Cd
			LEFT JOIN City ON Cd.CityIATACode = City.IATACode
			LEFT JOIN Salutation S ON Cd.SalutationID = S.SalutationID
			LEFT JOIN AgentLogin AL ON AL.AgentContactID = Cd.ContactDetailsID
				AND Cd.TypeID = 3 --added by sanket @ 23/11/2015                                      
			WHERE --(TypeID = @TypeID    or @ID = 0 or @ID = null)                            
				--AND (ParentID = @ID    or @ID = 0 or @ID = null)                        
				-- AND                    
				(
					ContactDetailsID = @ContactDetailsID
					OR @ContactDetailsID = 0
					OR @ContactDetailsID = NULL
					)
				AND (
					@ParentID IS NULL
					OR @ParentID = 0
					OR @ParentID = CD.ParentID
					)
				AND (
					@TypeID IS NULL
					OR @TypeID = 0
					OR @TypeID = cd.TypeID
					)
			ORDER BY ContactDetailsID DESC
	END

	ELSE IF @Action= 'D'

	BEGIN
	DELETE FROM ContactDetails WHERE ContactDetailsID = @ContactDetailsID

				SELECT '200' AS returnCode
					,'Record deleted successfully.' AS returnMessage
					,@ContactDetailsID AS ID
	END
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END