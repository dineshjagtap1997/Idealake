<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_AirlineCodemaster] @AirlineCode NVARCHAR(5)=''            
 ,@Airlinename NVARCHAR(80) =''           
 ,@IsActive BIT  =1          
 ,@OperationBy UNIQUEIDENTIFIER  =NULL          
 ,@Action CHAR(2)=''            
 ,@AirlineID INT =''            
AS            
BEGIN            
      
 Declare @LogID int;       
IF @Action='I'            
BEGIN            
 DECLARE @new_identity INT            
            
 IF EXISTS (            
   SELECT TOP 1 1            
   FROM AirlineCodemaster            
   WHERE AirlineCode = @AirlineCode            
   )            
 BEGIN            
 SELECT '201' AS returnCode, 'Airline Code already exists. Please check and try again.'   AS returnMessage;            
 END            
 ELSE            
 BEGIN            
  INSERT INTO AirlineCodemaster (            
   AirlineCode            
   ,Airlinename            
   ,IsActive            
   ,Operation            
   ,CreatedBy            
   ,CreatedDate            
   ,Updatedby            
   ,UpdatedOn            
   )            
  VALUES (            
   @AirlineCode            
   ,@Airlinename            
   ,@IsActive            
   ,'Insert'            
   ,@OperationBy            
   ,GETDATE()            
   ,@OperationBy            
   ,GETDATE()            
   )            
            
  SELECT @new_identity = SCOPE_IDENTITY()            
            
          
            
 SELECT '200' AS returnCode, 'New record added successfully.'   AS returnMessage, @new_identity AS ID;            
 END            
END--I            
ELSE IF @Action='U'            
BEGIN            
 IF EXISTS (            
   SELECT TOP 1 1            
   FROM AirlineCodemaster            
   WHERE AirlineCode = @AirlineCode            
    AND AirlineID != @AirlineID            
   )            
 BEGIN            
  SELECT '201' AS returnCode, 'Airline Code already exists. Please check and try again.'   AS returnMessage;            
 END            
 ELSE            
 BEGIN            
  UPDATE AirlineCodemaster            
  SET AirlineCode = @AirlineCode            
   ,Airlinename = @Airlinename            
   ,IsActive = @IsActive            
   ,Operation = 'Update'            
   ,Updatedby = @OperationBy            
   ,UpdatedOn = GETDATE()            
  WHERE AirlineID = @AirlineID            
            
  EXEC usp_InsertAirlineCodemaster_Audit @AirlineID            
   ,@AirlineCode            
   ,@Airlinename            
   ,@IsActive            
   ,'Update'            
   ,@OperationBy            
            
  SELECT '200' AS returnCode, 'Record updated successfully.'   AS returnMessage , @AirlineID AS ID ;            
 END            
END            
ELSE IF @Action='S'            
 SELECT A.AirlineID            
  ,A.AirlineCode            
  ,A.Airlinename            
  ,A.IsActive            
 -- ,e.EmpName AS 'CreatedName'            
  --,A.CreatedBy            
  --,A.Operation            
  --,A.CreatedDate            
  --,A.UpdatedBy            
  --,A.UpdatedOn            
 -- ,eu.EmpName AS 'UpdatedName'            
 FROM AirlineCodemaster A            
 --INNER  JOIN EmployeeMaster e ON A.CreatedBy = e.UserID            
 --INNER JOIN EmployeeMaster eu ON A.UpdatedBy = eu.UserID            
 WHERE (@AirlineID IS NULL OR @AirlineID = 0) OR A.Airlineid = @AirlineID             
 --A.IsActive = 1            
 ORDER BY A.AirlineID DESC            
 
 
 --ELSE IF @Action='EX'            
 --SELECT       
 -- A.AirlineCode            
 -- ,A.Airlinename   
 -- ,CASE 
	--	WHEN A.IsActive = 1 Then 'Yes'
	--	WHEN A.IsActive = 0 Then 'No'
	--	END AS IsActive
 ---- ,e.EmpName AS 'CreatedName'            
 -- --,A.CreatedBy            
 -- --,A.Operation            
 -- --,A.CreatedDate            
 -- --,A.UpdatedBy            
 -- --,A.UpdatedOn            
 ---- ,eu.EmpName AS 'UpdatedName'            
 --FROM AirlineCodemaster A            
 ----INNER  JOIN EmployeeMaster e ON A.CreatedBy = e.UserID            
 ----INNER JOIN EmployeeMaster eu ON A.UpdatedBy = eu.UserID            
 --WHERE (@AirlineID IS NULL OR @AirlineID = 0) OR A.Airlineid = @AirlineID             
 ----A.IsActive = 1            
 --ORDER BY A.AirlineID DESC            
      ELSE IF @Action='EX'
BEGIN
  SELECT       
    A.AirlineCode,
    A.Airlinename,
    A.IsActive  -- Return BIT (0/1) instead of 'Yes'/'No'
  FROM AirlineCodemaster A
  WHERE (@AirlineID IS NULL OR @AirlineID = 0) OR A.Airlineid = @AirlineID
  ORDER BY A.AirlineID DESC
END

=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿
CREATE PROCEDURE [dbo].[usp_AirlineCodemaster] @AirlineCode NVARCHAR(5)=''              
 ,@Airlinename NVARCHAR(80) =''             
 ,@IsActive BIT  =1            
 ,@OperationBy UNIQUEIDENTIFIER  =NULL            
 ,@Action CHAR(2)=''              
 ,@AirlineID INT =''              
AS              
BEGIN              
        
 Declare @LogID int;         
IF @Action='I'              
BEGIN              
 DECLARE @new_identity INT              
              
 IF EXISTS (              
   SELECT TOP 1 1              
   FROM AirlineCodemaster              
   WHERE AirlineCode = @AirlineCode              
   )              
 BEGIN              
 SELECT '201' AS returnCode, 'Airline Code already exists. Please check and try again.'   AS returnMessage;              
 END              
 ELSE              
 BEGIN              
  INSERT INTO AirlineCodemaster (              
   AirlineCode              
   ,Airlinename              
   ,IsActive              
   ,Operation              
   ,CreatedBy              
   ,CreatedDate              
   ,Updatedby              
   ,UpdatedOn              
   )              
  VALUES (              
   @AirlineCode              
   ,@Airlinename              
   ,@IsActive              
   ,'Insert'              
   ,@OperationBy              
   ,GETDATE()              
   ,@OperationBy              
   ,GETDATE()              
   )              
              
  SELECT @new_identity = SCOPE_IDENTITY()              
              
            
              
 SELECT '200' AS returnCode, 'New record added successfully.'   AS returnMessage, @new_identity AS ID;              
 END              
END--I              
ELSE IF @Action='U'              
BEGIN              
 IF EXISTS (              
   SELECT TOP 1 1              
   FROM AirlineCodemaster              
   WHERE AirlineCode = @AirlineCode              
    AND AirlineID != @AirlineID              
   )              
 BEGIN              
  SELECT '201' AS returnCode, 'Airline Code already exists. Please check and try again.'   AS returnMessage;              
 END              
 ELSE              
 BEGIN              
  UPDATE AirlineCodemaster              
  SET AirlineCode = @AirlineCode              
   ,Airlinename = @Airlinename              
   ,IsActive = @IsActive              
   ,Operation = 'Update'              
   ,Updatedby = @OperationBy              
   ,UpdatedOn = GETDATE()              
  WHERE AirlineID = @AirlineID                         
              
  SELECT '200' AS returnCode, 'Record updated successfully.'   AS returnMessage , @AirlineID AS ID ;              
 END              
END              
ELSE IF @Action='S'              
 SELECT A.AirlineID              
  ,A.AirlineCode              
  ,A.Airlinename              
  ,A.IsActive              
 -- ,e.EmpName AS 'CreatedName'              
  --,A.CreatedBy              
  --,A.Operation              
  --,A.CreatedDate              
  --,A.UpdatedBy              
  --,A.UpdatedOn              
 -- ,eu.EmpName AS 'UpdatedName'              
 FROM AirlineCodemaster A              
 --INNER  JOIN EmployeeMaster e ON A.CreatedBy = e.UserID              
 --INNER JOIN EmployeeMaster eu ON A.UpdatedBy = eu.UserID              
 WHERE (@AirlineID IS NULL OR @AirlineID = 0) OR A.Airlineid = @AirlineID               
 --A.IsActive = 1              
 ORDER BY A.AirlineID DESC              
   
   
 --ELSE IF @Action='EX'              
 --SELECT         
 -- A.AirlineCode              
 -- ,A.Airlinename     
 -- ,CASE   
 -- WHEN A.IsActive = 1 Then 'Yes'  
 -- WHEN A.IsActive = 0 Then 'No'  
 -- END AS IsActive  
 ---- ,e.EmpName AS 'CreatedName'              
 -- --,A.CreatedBy              
 -- --,A.Operation              
 -- --,A.CreatedDate              
 -- --,A.UpdatedBy              
 -- --,A.UpdatedOn              
 ---- ,eu.EmpName AS 'UpdatedName'              
 --FROM AirlineCodemaster A              
 ----INNER  JOIN EmployeeMaster e ON A.CreatedBy = e.UserID              
 ----INNER JOIN EmployeeMaster eu ON A.UpdatedBy = eu.UserID              
 --WHERE (@AirlineID IS NULL OR @AirlineID = 0) OR A.Airlineid = @AirlineID               
 ----A.IsActive = 1              
 --ORDER BY A.AirlineID DESC              
      ELSE IF @Action='EX'  
BEGIN  
  SELECT         
    A.AirlineCode,  
    A.Airlinename,  
    A.IsActive  -- Return BIT (0/1) instead of 'Yes'/'No'  
  FROM AirlineCodemaster A  
  WHERE (@AirlineID IS NULL OR @AirlineID = 0) OR A.Airlineid = @AirlineID  
  ORDER BY A.AirlineID DESC  
END  
  
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END 