<<<<<<< HEAD
<<<<<<< HEAD
﻿          
CREATE PROCEDURE [dbo].[usp_RoomCategory_Master]                                
	@Name   VARCHAR(50)='',                                
	@IsActive BIT = NULL,                          
	@OperationBy UNIQUEIDENTIFIER=NULL,  
	@HotelID int=null,
	--@ErrMsg   VARCHAR(50) OUT                            
	@Action CHAR(2)='',   

	@ID INT=''                          
AS                           
BEGIN           
        
Declare @LogID int;         
IF @Action='I'                          
BEGIN                                
 IF EXISTS(SELECT Name FROM RoomCategory WHERE UPPER(Name) = UPPER(@Name))                                
 BEGIN                           
SELECT '201' AS returnCode, 'Room category already exists. Please check and try again.' AS returnMessage;                           
 END                                
 ELSE                                
 BEGIN                                
    declare @MaxID int  = (Select MAX(OldID) from RoomCategory) + 1                               
                              
  INSERT INTO RoomCategory                                 
     (Name,  IsActive,  Operation, OperationBy,  OperationOn,OldID)                                
  VALUES  (@Name, @IsActive, 'Insert',  @OperationBy, GETDATE(),@MaxID  )                                
                                
  --EXEC  usp_InsertRoomCategory_Audit @@IDENTITY, 'Insert', @OperationBy      
  set @LogID = SCOPE_IDENTITY()  
SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @LogID as ID;                                
 END                                
END--I                          
ELSE IF @Action='U'                          
BEGIN                              
 IF EXISTS(SELECT TOP 1 1 FROM RoomCategory WHERE Name = @Name AND ID != @ID)                              
 BEGIN                              
 SELECT '201' AS returnCode, 'Room category already exists. Please check and try again.' AS returnMessage;                                 
 END                              
 ELSE                              
 BEGIN                              
  UPDATE RoomCategory                              
  SET  Name  = ISNULL(@Name,Name),                            
    IsActive = @IsActive,                              
    Operation = 'Update'  ,UpdatedBy = @OperationBy                        
    ,UpdatedOn = GETDATE()                            
  WHERE ID   = @ID                              
                              
  --EXEC  usp_InsertRoomCategory_Audit @ID, 'Update', @OperationBy                              
                              
  SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @ID as ID;                              
 END                              
END--U                          
ELSE IF @Action='S'                          
BEGIN                                
                               
  SELECT 
	ID, Name, RC.IsActive                                
  FROM 
	RoomCategory RC
	LEFT JOIN HotelRoomCategory HRC ON RC.ID = HRC.RoomCategoryID
  WHERE 
	(@ID IS NULL OR @ID = 0 OR ID = @ID)     
	AND (ISNULL(@HotelID,0)=0 OR HRC.HotelID=@HotelID)
                  
  order by ID DESC                                
                            
END                             
ELSE IF @Action='EX'
BEGIN
SELECT Name, CASE WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive                                 
  FROM RoomCategory                                
  WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)                         
                  
  order by ID DESC    
END
                          
END 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿CREATE PROCEDURE [dbo].[usp_RoomCategory_Master] @Name VARCHAR(50) = ''
	,@IsActive BIT = NULL
	,@OperationBy UNIQUEIDENTIFIER = NULL
	,@HotelID INT = NULL
	,
	--@ErrMsg   VARCHAR(50) OUT                                
	@Action CHAR(2) = ''
	,@ID INT = NULL
AS
BEGIN
	DECLARE @LogID INT;

	IF @Action = 'I'
	BEGIN
		IF EXISTS (
				SELECT Name
				FROM RoomCategory
				WHERE UPPER(Name) = UPPER(@Name)
				)
		BEGIN
			SELECT '201' AS returnCode
				,'Room category already exists. Please check and try again.' AS returnMessage;
		END
		ELSE
		BEGIN
			DECLARE @MaxID INT = (
					SELECT MAX(OldID)
					FROM RoomCategory
					) + 1

			INSERT INTO RoomCategory (
				Name
				,IsActive
				,Operation
				,OperationBy
				,OperationOn
				,OldID
				)
			VALUES (
				@Name
				,@IsActive
				,'Insert'
				,@OperationBy
				,GETDATE()
				,@MaxID
				)

			--EXEC  usp_InsertRoomCategory_Audit @@IDENTITY, 'Insert', @OperationBy          
			SET @LogID = SCOPE_IDENTITY()

			SELECT '200' AS returnCode
				,'New record added successfully.' AS returnMessage
				,@LogID AS ID;
		END
	END --I                              
	ELSE IF @Action = 'U'
	BEGIN
		IF EXISTS (
				SELECT TOP 1 1
				FROM RoomCategory
				WHERE Name = @Name
					AND ID != @ID
				)
		BEGIN
			SELECT '201' AS returnCode
				,'Room category already exists. Please check and try again.' AS returnMessage;
		END
		ELSE
		BEGIN
			UPDATE RoomCategory
			SET Name = ISNULL(@Name, Name)
				,IsActive = @IsActive
				,Operation = 'Update'
				,UpdatedBy = @OperationBy
				,UpdatedOn = GETDATE()
			WHERE ID = @ID

			--EXEC  usp_InsertRoomCategory_Audit @ID, 'Update', @OperationBy                                  
			SELECT '200' AS returnCode
				,'Record updated successfully.' AS returnMessage
				,@ID AS ID;
		END
	END --U                              
	ELSE IF @Action = 'S'
	BEGIN
		SELECT ID
			,Name
			,RC.IsActive
		FROM RoomCategory RC
		INNER JOIN HotelRoomCategory HRC ON RC.ID = HRC.RoomCategoryID
		WHERE
		(
				@ID IS NULL
				OR @ID = 0
				OR ID = @ID
				)
			AND 
			(
				ISNULL(@HotelID, 0) = 0
				OR HRC.HotelID = @HotelID
				)
		ORDER BY ID DESC
	END
	ELSE IF @Action = 'EX'
	BEGIN
		SELECT Name
			,CASE 
				WHEN IsActive = 1
					THEN 'True'
				WHEN IsActive = 0
					THEN 'False'
				END AS IsActive
		FROM RoomCategory
		WHERE (
				@ID IS NULL
				OR @ID = 0
				OR ID = @ID
				)
		ORDER BY ID DESC
	END
	ELSE IF @Action = 'F'
	BEGIN
		-- SELECT     
		--ID, Name, RC.IsActive                                    
		-- FROM     
		--RoomCategory RC    
		----INNER JOIN HotelRoomCategory HRC ON RC.ID = HRC.RoomCategoryID    
		-- WHERE     
		--Name LIKE '%'+ @Name +'%'  
		-- order by  CHARINDEX(@Name, Name),  -- Sort by match position  
		-- Name ASC,  
		-- ID DESC    
		SELECT ID
			,Name
			,RC.IsActive
			,
			-- part after search term  
			LTRIM(SUBSTRING(Name, LEN(@Name) + 1, LEN(Name))) AS AfterSearch
		FROM RoomCategory RC
		WHERE Name LIKE '%' + @Name + '%' COLLATE SQL_Latin1_General_CP1_CI_AS
		ORDER BY CHARINDEX(@Name COLLATE SQL_Latin1_General_CP1_CI_AS, Name COLLATE SQL_Latin1_General_CP1_CI_AS)
			,-- match position  
			LTRIM(SUBSTRING(Name, LEN(@Name) + 1, LEN(Name))) ASC
			,-- alphabetical after search term  
			Name ASC
			,ID DESC;
	END
<<<<<<< HEAD
END
>>>>>>> dev
=======
END
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
