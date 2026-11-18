--sp_helptext 'usp_TCSRateConfig'                  
CREATE PROCEDURE [dbo].[usp_TCSRateConfig]            
@BillingTo NVARCHAR(50)       = null     
 ,@FromDate NVARCHAR(500) = NULL            
 ,@ToDate NVARCHAR(500) = NULL            
 ,@PANExists BIT  = 0          
 ,@AddressonRecord BIT    = 0         
 ,@AgentMasterCountryIN BIT   = 0          
 ,@Resident BIT          = 0   
 ,@TCSRateID BIGINT    = 0         
 ,@ViewDetailsID INT  = 0           
 ,@IsActive BIT     = 0        
 ,@OperationBy UNIQUEIDENTIFIER = NULL            
 ,@Action CHAR(2) = ''            
 ,@TCSRateConfigID INT = NULL -- Set default to NULL                 
 , @TDSDeduction BIT = 0          
AS            
BEGIN            
 -- Insert Action             
  Declare @LogID int;           
 IF @Action = 'I'            
 BEGIN            
  DECLARE @new_identity INT;            
            
  -- Insert data into TCSRateConfig table                  
  INSERT INTO TCSRateConfig (            
   BillingTo            
   ,FromDate            
   ,ToDate            
   ,PANExists            
   ,AddressonRecord            
   ,AgentMasterCountryIN            
   ,Resident            
   ,TCSRateID            
   ,IsActive            
   ,Operation            
   ,CreatedBy            
   ,CreatedDate            
   ,ViewDetailsID  ,          
   TDSDeduction          
   )            
  VALUES (            
   @BillingTo            
   ,CAST(@FromDate AS DATETIME)            
   ,CAST(@ToDate AS DATETIME)            
   ,@PANExists            
   ,@AddressonRecord            
   ,@AgentMasterCountryIN            
   ,@Resident            
   ,@TCSRateID            
   ,@IsActive            
   ,'Insert'            
   ,@OperationBy            
   ,GETDATE()            
   ,@ViewDetailsID  ,          
   @TDSDeduction          
   );            
            
  -- Get the new identity of the inserted record                  
  --SELECT @new_identity = SCOPE_IDENTITY();            
            
  -- Call audit procedure for insert action                  
  --EXEC usp_InsertTCSRateConfig_Audit                   
  --    @new_identity,                  
  --    @BillingTo,                  
  --    @FromDate,                  
  --    @ToDate,                  
  --    @PANExists,                  
  --    @AddressonRecord,                  
  --    @AgentMasterCountryIN,                  
  --    @Resident,                  
  --    @TCSRateID,                  
  --    @ViewDetailsID,                  
  --    @IsActive,                  
  --    'Insert',                  
  --    @OperationBy;                  
  -- Return success response            
            
  SET @LogID = SCOPE_IDENTITY()          
  SELECT '200' AS returnCode            
   ,'New record added successfully.' AS returnMessage, @LogID AS ID;            
 END            
   -- Update Action                  
 ELSE IF @Action = 'U'            
 BEGIN            
  -- Update data in TCSRateConfig table                  
  UPDATE TCSRateConfig            
  SET BillingTo = @BillingTo            
   ,FromDate = CAST(@FromDate AS DATETIME)            
   ,ToDate = CAST(@ToDate AS DATETIME)            
   ,PANExists = @PANExists            
   ,AddressonRecord = @AddressonRecord            
   ,AgentMasterCountryIN = @AgentMasterCountryIN            
   ,Resident = @Resident            
   ,TCSRateID = @TCSRateID            
   ,IsActive = @IsActive            
   ,ViewDetailsID = @ViewDetailsID           
   ,TDSDeduction = @TDSDeduction          
   ,Operation = 'Update'            
   ,Updatedby = @OperationBy            
   ,UpdatedDate = GETDATE()            
  WHERE TCSRateConfigID = @TCSRateConfigID;            
            
  ---- Call audit procedure for update action                  
  --EXEC usp_InsertTCSRateConfig_Audit                   
  --    @TCSRateConfigID,                  
  --    @BillingTo,                  
  --    @FromDate,                  
  --    @ToDate,                  
  --    @PANExists,                  
  --    @AddressonRecord,                  
  --    @AgentMasterCountryIN,                  
  --    @Resident,                  
  --    @TCSRateID,                  
  --    @ViewDetailsID,                  
  --    @IsActive,                  
  --    'Update',                  
  --    @OperationBy;                  
  -- Return success response                  
  SELECT '200' AS returnCode            
   ,'Record updated successfully.' AS returnMessage, @TCSRateConfigID AS ID;            
 END          
   -- Select Action          
 ELSE IF @Action = 'S'          
 BEGIN          
   SELECT c.*          
    ,t.TCSRate          
    ,CASE          
     WHEN c.ViewDetailsID = 1          
      THEN 'Disable Pass/Resident/Upload'          
     WHEN c.ViewDetailsID = 2          
      THEN 'Allow PAN Or PASS selection'          
     END AS ViewDetails          
  FROM TCSRateConfig c          
   INNER JOIN TCSRateMaster t ON c.TCSRateID = t.TCSID          
  WHERE (  @TCSRateConfigID IS NULL  OR @TCSRateConfigID = 0  OR TCSRateConfigID = @TCSRateConfigID )          
           
   ORDER BY c.TCSRateConfigID DESC;          
  END            
 
--  ELSE IF @Action = 'EX'          
-- BEGIN          
--   SELECT c.BillingTo,
--   c.FromDate, 
--   c.ToDate,
--CASE 
--	WHEN c.PANExists = 1 THEN 'Yes'
--	WHEN c.PANExists = 0 THEN 'No'
--	END AS PANExists,
--CASE 
--	WHEN c.AddressonRecord = 1 THEN 'Yes'
--	WHEN c.AddressonRecord = 0 THEN 'No'
--	END  as AddressonRecord,
--CASE 
--	WHEN c.AgentMasterCountryIN = 1 THEN 'Yes'
--	WHEN c.AgentMasterCountryIN = 0 THEN 'No'
--	END  as AgentMasterCountryIN,
--CASE 
--	WHEN c.Resident = 1 THEN 'Yes'
--	WHEN c.Resident = 0 THEN 'No'
--	END  as Resident, 
--CASE 
--	WHEN c.IsActive = 1 THEN 'True'
--	WHEN c.IsActive = 0 THEN 'False'
--	END  as IsActive 
--    ,t.TCSRate          
--    ,CASE          
--     WHEN c.ViewDetailsID = 1          
--      THEN 'Disable Pass/Resident/Upload'          
--     WHEN c.ViewDetailsID = 2          
--      THEN 'Allow PAN Or PASS selection'          
--     END AS ViewDetails          
--  FROM TCSRateConfig c          
--   INNER JOIN TCSRateMaster t ON c.TCSRateID = t.TCSID          
--  WHERE (  @TCSRateConfigID IS NULL  OR @TCSRateConfigID = 0  OR TCSRateConfigID = @TCSRateConfigID )          
           
--   ORDER BY c.TCSRateConfigID DESC;          
--  END  
ELSE IF @Action = 'EX'          
BEGIN          
   SELECT c.BillingTo,
          c.FromDate, 
          c.ToDate,
          c.PANExists,
          c.AddressonRecord,
          c.AgentMasterCountryIN,
          c.Resident, 
          c.IsActive,
          t.TCSRate,          
          CASE          
             WHEN c.ViewDetailsID = 1 THEN 'Disable Pass/Resident/Upload'          
             WHEN c.ViewDetailsID = 2 THEN 'Allow PAN Or PASS selection'          
          END AS ViewDetails          
   FROM TCSRateConfig c          
   INNER JOIN TCSRateMaster t ON c.TCSRateID = t.TCSID          
   WHERE (@TCSRateConfigID IS NULL OR @TCSRateConfigID = 0 OR TCSRateConfigID = @TCSRateConfigID)          
   ORDER BY c.TCSRateConfigID DESC;          
END

END