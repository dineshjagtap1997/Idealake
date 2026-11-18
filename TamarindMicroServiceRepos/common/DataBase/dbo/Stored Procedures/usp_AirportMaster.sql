CREATE PROCEDURE [dbo].[usp_AirportMaster] (          
 @AirportCode CHAR(3)=''          
 ,@AirportCityName VARCHAR(50)  =''        
 ,@AirportName VARCHAR(75)=''          
 ,@AirportCountry VARCHAR(50) =''         
 ,@IsActive BIT  =''        
 ,@OperationBy UNIQUEIDENTIFIER =null         
 --,@ErrMsg VARCHAR(50) OUT          
 ,@Action CHAR(2)=''          
 --,@Active BIT =''          
 ,@ID INT =''          
 )          
AS          
BEGIN        
    
 Declare @LogID int;     
IF @Action='I'          
          
BEGIN          
 IF EXISTS (          
   SELECT Airport_Code          
   FROM AirportMaster          
   WHERE UPPER(Airport_Code) = UPPER(@AirportCode)          
   )          
 BEGIN          
 SELECT '201' AS returnCode, 'Airport Code already exists. Please check and try again.'   AS returnMessage;          
 END          
 ELSE IF EXISTS (          
   SELECT Airport_Name          
   FROM AirportMaster          
   WHERE UPPER(Airport_Name) = UPPER(@AirportName)          
   )          
 BEGIN          
 SELECT '201' AS returnCode, 'Airport Name already exists. Please check and try again.'   AS returnMessage;           
 END          
 ELSE          
 BEGIN          
  INSERT INTO [dbo].[AirportMaster] (          
   [Airport_Code]          
   ,[Airport_City_Name]          
   ,[Airport_Name]          
   ,[Airport_Country]          
   ,[IsActive]          
   ,[Operation]          
   ,[OperationBy]          
   ,[OperationDate]          
   ,[UpdatedBy]          
   ,[UpdatedOn]          
   )          
  VALUES (          
   @AirportCode          
   ,@AirportCityName          
   ,@AirportName          
   ,@AirportCountry          
   ,@IsActive          
   ,'Insert'          
   ,@OperationBy          
   ,GETDATE()          
   ,@OperationBy          
   ,GETDATE()          
   )          
          
  --INSERT INTO Country              
  --   (IATACode,  Name,  Nationality,  ISDCode,  IsActive,  Operation, OperationBy,  OperationDate,OldID, PostalCode)              
  --VALUES  (UPPER(@IATACode), @Name, @Nationality, @ISDCode, @IsActive, 'Insert',  @OperationBy, GETDATE(),UPPER(@IATACode), @PostalCode )                
  --EXEC  usp_InsertCountry_Audit    @IATACode, 'Insert', @OperationBy              
  SET @LogID = SCOPE_IDENTITY()    
   SELECT '200' AS returnCode, 'New record added successfully.'   AS returnMessage, @LogID AS ID;          
 END          
END -- I          
ELSE IF @Action='U'          
BEGIN          
 IF EXISTS (          
   SELECT TOP 1 1          
   FROM AirportMaster          
   WHERE Airport_Code = @AirportCode          
    AND ID != @ID          
   )          
 BEGIN          
 SELECT '201' AS returnCode, 'Airport Code already exists. Please check and try again.'  AS returnMessage;          
          
 END          
 ELSE          
 BEGIN          
  UPDATE AirportMaster          
  SET Airport_Code = @AirportCode          
   ,Airport_City_Name = @AirportCityName          
   ,Airport_Name = @AirportName          
   ,Airport_Country = @AirportCountry          
   ,IsActive = @IsActive          
   ,Operation = 'Update'        
   ,UpdatedBy = @OperationBy        
   ,UpdatedOn = GETDATE()        
  WHERE ID = @ID          
          
  --EXEC usp_InsertAirlineCodemaster_Audit @AirlineID,@AirlineCode,@Airlinename,                
  --@IsActive,'Update', @OperationBy                
  SELECT '200' AS returnCode, 'Record updated successfully.'  AS returnMessage, @ID AS ID;          
          
 END          
END          
ELSE IF @Action='S'          
IF (@IsActive = 0)          
BEGIN          
 SELECT A.ID          
  ,A.Airport_Code    AS AirportCode      
  ,A.Airport_City_Name  AS   AirportCityName      
  ,A.Airport_Name  AS  AirportName      
  ,A.Airport_Country   AS AirportCountry       
  ,A.IsActive          
  ,e.EmpName AS 'CreatedName'          
  ,A.Operation          
  ,A.OperationDate AS 'CreatedDate'          
  ,A.Updatedby          
  ,A.UpdatedOn          
  ,eu.EmpName AS 'UpdatedName'          
 FROM AirportMaster A          
 LEFT JOIN EmployeeMaster e ON A.OperationBy = e.UserID          
 LEFT JOIN EmployeeMaster eu ON A.Updatedby = eu.UserID       
 WHERE (       @ID IS NULL       OR @ID = 0       OR ID = @ID      )        
 ORDER BY A.ID DESC          
END          
ELSE          
BEGIN          
 SELECT A.ID        
   ,A.Airport_Code    AS AirportCode      
  ,A.Airport_City_Name  AS   AirportCityName      
  ,A.Airport_Name  AS  AirportName      
  ,A.Airport_Country   AS AirportCountry       
  ,A.IsActive          
  ,e.EmpName AS 'CreatedName'          
  ,A.Operation          
  ,A.OperationDate AS 'CreatedDate'          
  ,A.Updatedby          
  ,A.UpdatedOn         
  ,eu.EmpName AS 'UpdatedName'          
 FROM AirportMaster A          
 LEFT JOIN EmployeeMaster e ON A.OperationBy = e.UserID          
 LEFT JOIN EmployeeMaster eu ON A.Updatedby = eu.UserID          
 WHERE A.IsActive = 1  AND  (       @ID IS NULL       OR @ID = 0       OR ID = @ID      )         
 ORDER BY A.ID DESC          
END       

ELSE IF @Action='ex'          
BEGIN          
 SELECT A.Airport_Code    AS AirportCode      
  ,A.Airport_City_Name  AS   AirportCityName      
  ,A.Airport_Name  AS  AirportName      
  ,A.Airport_Country   AS AirportCountry       
  ,CASE
	WHEN A.IsActive = 1 THEN 'True'
	WHEN A.IsActive = 0 THEN 'False'
	END AS IsActive
  ,e.EmpName AS 'CreatedName'          
     
  ,eu.EmpName AS 'UpdatedName'          
 FROM AirportMaster A          
 LEFT JOIN EmployeeMaster e ON A.OperationBy = e.UserID          
 LEFT JOIN EmployeeMaster eu ON A.Updatedby = eu.UserID       
 WHERE (       @ID IS NULL       OR @ID = 0       OR ID = @ID      )        
 ORDER BY A.ID DESC          
END                 
END 