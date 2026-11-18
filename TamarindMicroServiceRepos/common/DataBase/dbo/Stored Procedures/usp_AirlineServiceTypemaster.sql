CREATE PROCEDURE [dbo].[usp_AirlineServiceTypemaster]         
@AirlineServiceType NVARCHAR(50)  =''        
 ,@ShortCode NVARCHAR(5)  =''        
 ,@IsActive BIT  =''        
 ,@OperationBy UNIQUEIDENTIFIER = null        
 ,@Action char(2)=''          
 ,@AirlineServiceTypeID BIGINT=''          
 --,@ErrMsg VARCHAR(50) OUT          
AS          
BEGIN          
IF @Action='I'          
          
BEGIN           
 DECLARE @new_identity INT          
          
 IF EXISTS (          
   SELECT TOP 1 1          
   FROM AirlineServiceTypemaster          
   WHERE (          
     ShortCode = @ShortCode          
     OR AirlineServiceType = @AirlineServiceType          
     )          
   )          
 BEGIN          
  SELECT '201' AS returnCode, 'AirlineServiceType already exists. Please check and try again.' AS returnMessage;            
 END          
 ELSE          
 BEGIN          
  INSERT INTO AirlineServiceTypemaster (          
   AirlineServiceType          
   ,ShortCode          
   ,IsActive          
   ,Operation          
   ,CreatedBy          
   ,CreatedDate          
   ,Updatedby          
   ,UpdatedOn          
   )          
  VALUES (          
   @AirlineServiceType          
   ,@ShortCode          
   ,@IsActive          
   ,'Insert'          
   ,@OperationBy          
   ,GETDATE()          
   ,@OperationBy          
   ,GETDATE()          
   )          
          
  SELECT @new_identity = SCOPE_IDENTITY()          
      
          
SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @new_identity as ID;             
END          
END          
ELSE IF @Action='S'          
BEGIN          
        
SELECT A.AirlineServiceTypeID          
   ,A.AirlineServiceType          
   ,A.ShortCode          
   ,A.IsActive          
 --  ,e.EmpName AS 'CreatedName'          
   --,A.CreatedBy          
   --,A.Operation          
   --,A.CreatedDate          
   --,A.Updatedby          
   --,A.UpdatedOn          
  -- ,eu.EmpName AS 'UpdatedName'          
  FROM AirlineServiceTypeMaster A          
 -- LEFT JOIN EmployeeMaster e ON A.CreatedBy = e.UserID          
 -- LEFT JOIN EmployeeMaster eu ON A.Updatedby = eu.UserID          
  WHERE (@AirlineServiceTypeID IS NULL OR @AirlineServiceTypeID = 0) OR AirlineServiceTypeID = @AirlineServiceTypeID        
  ORDER BY A.AirlineServiceTypeID DESC          
        
--IF (@IsActive = 0)          
-- BEGIN          
--  SELECT *          
--  FROM AirlineServiceTypeMaster C          
--  ORDER BY C.AirlineServiceTypeID DESC          
-- END          
-- ELSE          
-- BEGIN          
--  SELECT A.AirlineServiceTypeID          
--   ,A.AirlineServiceType          
--   ,A.ShortCode          
--   ,A.IsActive          
--   ,e.EmpName AS 'CreatedName'          
--   ,A.CreatedBy          
--   ,A.Operation          
--   ,A.CreatedDate          
--   ,A.Updatedby          
--   ,A.UpdatedOn          
--   ,eu.EmpName AS 'UpdatedName'          
--  FROM AirlineServiceTypeMaster A          
--  LEFT JOIN EmployeeMaster e ON A.CreatedBy = e.UserID          
--  LEFT JOIN EmployeeMaster eu ON A.Updatedby = eu.UserID          
--  WHERE A.IsActive = 1          
--  ORDER BY A.AirlineServiceTypeID DESC          
-- END          
END          
ELSE IF @Action='U'          
BEGIN          
 IF EXISTS (          
   SELECT TOP 1 1          
   FROM AirlineServiceTypemaster          
   WHERE (          
     ShortCode = @ShortCode          
     OR AirlineServiceType = @AirlineServiceType          
     )          
    AND AirlineServiceTypeID != @AirlineServiceTypeID          
   )          
 BEGIN          
  SELECT '201' AS returnCode, 'AirlineServiceType already exists. Please check and try again.' AS returnMessage;             
 END          
 ELSE          
 BEGIN          
  UPDATE AirlineServiceTypemaster          
  SET AirlineServiceType = @AirlineServiceType          
   ,ShortCode = @ShortCode          
   ,IsActive = @IsActive          
   ,Operation = 'Update'          
   ,UpdatedBy = @OperationBy        
   ,UpdatedOn = GETDATE()        
  WHERE AirlineServiceTypeID = @AirlineServiceTypeID          
          
      
          
SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @AirlineServiceTypeID AS ID;             
END          
END          
      

--ELSE IF @Action='EX'          
--BEGIN          
        
--SELECT A.AirlineServiceType          
--   ,A.ShortCode          
--   ,CASE 
--		WHEN A.IsActive = 1 THEN 'Yes'
--		WHEN A.IsActive = 0 THEN 'No'
--	END AS IsActive
--  FROM AirlineServiceTypeMaster A                 
--  WHERE (@AirlineServiceTypeID IS NULL OR @AirlineServiceTypeID = 0) OR AirlineServiceTypeID = @AirlineServiceTypeID        
--  ORDER BY A.AirlineServiceTypeID DESC          

--END    
ELSE IF @Action = 'EX'
BEGIN
    SELECT 
        A.AirlineServiceType,
        A.ShortCode,
        A.IsActive  -- Return BIT directly without converting to 'Yes'/'No'
    FROM AirlineServiceTypeMaster A
    WHERE (@AirlineServiceTypeID IS NULL OR @AirlineServiceTypeID = 0) OR AirlineServiceTypeID = @AirlineServiceTypeID
    ORDER BY A.AirlineServiceTypeID DESC
END


END        
        
