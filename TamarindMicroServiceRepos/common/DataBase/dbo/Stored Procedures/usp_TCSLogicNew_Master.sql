<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_TCSLogicNew_Master]                           
=======
﻿
CREATE PROCEDURE [dbo].[usp_TCSLogicNew_Master]                           
>>>>>>> dev
=======
﻿
CREATE PROCEDURE [dbo].[usp_TCSLogicNew_Master]                           
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
@BillingTo NVARCHAR(50)  =''                        
 ,@FromDate DATETIME =''                         
 ,@ToDate DATETIME  =''                        
 ,@PANExists BIT  =''                        
 ,@AddressonRecord BIT  =''                        
 ,@AgentMasterCountryIN BIT=''                          
 ,@NonResident BIT  =''                        
 ,@TCSRateID BIGINT =''                         
 ,@Blockdetails NVARCHAR(50) =''                         
 ,@TANonRecord BIT  =''                        
 ,@IsActive BIT  = 0                        
 ,@TDSDeduction BIT  =''                        
 ,@OperationBy UNIQUEIDENTIFIER  =null                        
-- ,@ErrMsg VARCHAR(50) OUT                          
 ,@Action char(2)=''                          
 --,@Active bit=''                          
 --,@Updatedby UNIQUEIDENTIFIER =''                          
 ,@TCSLogicID INT =''                          
AS                          
BEGIN                    
            
 Declare @LogID int;             
IF @Action='I'                          
BEGIN                          
 DECLARE @new_identity INT                          
                          
 INSERT INTO TCSLogicNew (                          
  BillingTo                          
  ,FromDate                          
  ,ToDate                          
  ,PANExists                          
  ,AddressonRecord                          
  ,AgentMasterCountryIN                          
  ,NonResident                          
  ,TCSRateID                          
  ,IsActive                          
  ,Operation                          
  ,CreatedBy                          
  ,CreatedDate                          
  ,Blockdetails                          
  ,TDSDeduction                          
  ,TANonRecord                          
  )                          
 VALUES (                          
  @BillingTo                          
  ,@FromDate                          
  ,@ToDate                          
  ,@PANExists                          
  ,@AddressonRecord                          
  ,@AgentMasterCountryIN                          
  ,@NonResident                          
  ,@TCSRateID                          
  ,@IsActive                          
  ,'Insert'                          
  ,@OperationBy                          
  ,GETDATE()                          
  ,@Blockdetails                          
  ,@TDSDeduction                          
  ,@TANonRecord                          
  )                          
<<<<<<< HEAD
<<<<<<< HEAD
                          
 --SELECT @new_identity = SCOPE_IDENTITY()                          
                          
 --EXEC usp_InsertTCSLogicNew_Audit @new_identity                          
 -- ,@BillingTo                          
 -- ,@FromDate                          
 -- ,@ToDate                          
 -- ,@PANExists                          
 -- ,@AddressonRecord                          
 -- ,@AgentMasterCountryIN                          
 -- ,@NonResident                          
 -- ,@TCSRateID                          
 -- ,@Blockdetails                          
 -- ,@TANonRecord                          
 -- ,@IsActive                          
 -- ,@TDSDeduction                          
 -- ,'Insert'                          
 -- ,@OperationBy                          
                          
        SET @LogID = SCOPE_IDENTITY()                  
=======
   SET @LogID = SCOPE_IDENTITY()                  
>>>>>>> dev
=======
   SET @LogID = SCOPE_IDENTITY()                  
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
  SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @LogID AS ID;                              
    END--i                          
ELSE IF @Action='S'                          
BEGIN                                      
<<<<<<< HEAD
<<<<<<< HEAD
  SELECT TCSLogicID,BillingTo,TCSRateID,AgentMasterCountryIN,AddressonRecord,TANonRecord,NonResident,TDSDeduction,PANExists , t.TCSRate , CAST (FromDate AS date) AS FromDate, CAST(ToDate   AS date) AS ToDate                       
  ,c.blockdetails AS BlockDetails , case when c.blockdetails = 'P' then 'PAN'                             
          when c.blockdetails = 'T' then 'TDS'                             
          when c.blockdetails = 'N' then 'NonResident'                             
          when c.blockdetails = 'P,N' then 'PAN/NonResident'                             
          when c.blockdetails = 'T,N' then 'TDS/NonResident'                             
          when c.blockdetails = 'P,T' then 'PAN/TDS'                             
          when c.blockdetails = 'P,N,T' then 'PAN/NonResident/TDS'                             
          end  AS BlockdetailsName, C.IsActive          
  FROM TCSLogicNew C                                   
  inner join  TCSRateMaster t on c.TCSRateID = t.TCSRate               
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            
  SELECT 
  TCSLogicID, BillingTo, TCSRateID, AgentMasterCountryIN, AddressonRecord,
  TANonRecord, NonResident, TDSDeduction, PANExists,
  t.TCSRate, 
  CAST(FromDate AS date) AS FromDate, 
  CAST(ToDate AS date) AS ToDate,
  c.blockdetails AS BlockDetails, 
  CASE 
    WHEN c.blockdetails = 'P' THEN 'PAN'
    WHEN c.blockdetails = 'T' THEN 'TDS'
    WHEN c.blockdetails = 'N' THEN 'NonResident'
    WHEN c.blockdetails = 'P,N' THEN 'PAN/NonResident'
    WHEN c.blockdetails = 'T,N' THEN 'TDS/NonResident'
    WHEN c.blockdetails = 'P,T' THEN 'PAN/TDS'
    WHEN c.blockdetails = 'P,N,T' THEN 'PAN/NonResident/TDS'
  END AS BlockdetailsName, 
  C.IsActive
FROM TCSLogicNew C
LEFT JOIN TCSRateMaster t ON c.TCSRateID = t.TCSID

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
  WHERE (       @TCSLogicID IS NULL       OR @TCSLogicID = 0       OR TCSLogicID = @TCSLogicID     )                
  Order by C.TCSLogicID desc                                  
 END                            
 --SELECT '200' AS returnCode, 'Data Fetched!' AS returnMessage;                             
                        
ELSE IF @Action='U'                          
BEGIN                
UPDATE TCSLogicNew                          
 SET BillingTo = @BillingTo                          
  ,FromDate = @FromDate                          
  ,ToDate = @ToDate                          
  ,PANExists = @PANExists                          
  ,AddressonRecord = @AddressonRecord                          
  ,AgentMasterCountryIN = @AgentMasterCountryIN                          
  ,NonResident = @NonResident                          
  ,TCSRateID = @TCSRateID                          
  ,IsActive = @IsActive                          
  ,TDSDeduction = @TDSDeduction                          
  ,Blockdetails = @Blockdetails                          
  ,TANonRecord = @TANonRecord                          
  ,Operation = 'Update'                          
  ,Updatedby = @OperationBy                          
  ,UpdatedDate = GETDATE()                          
 WHERE TCSLogicID = @TCSLogicID                          
                          
<<<<<<< HEAD
<<<<<<< HEAD
 --EXEC usp_InsertTCSLogicNew_Audit @TCSLogicID                          
 -- ,@BillingTo                          
 -- ,@FromDate                          
 -- ,@ToDate                          
 -- ,@PANExists                          
 -- ,@AddressonRecord                          
 -- ,@AgentMasterCountryIN                          
 -- ,@NonResident                          
 -- ,@TCSRateID                          
 -- ,@Blockdetails                          
 -- ,@TANonRecord                          
 -- ,@IsActive                          
 -- ,@TDSDeduction                          
 -- ,'Update'                          
 -- ,@OperationBy                          
=======
                      
>>>>>>> dev
=======
                      
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
                          
SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @TCSLogicID AS ID;                             
END                          

ELSE IF @Action='EX'                          
BEGIN                                      
<<<<<<< HEAD
<<<<<<< HEAD
  SELECT BillingTo,AgentMasterCountryIN,AddressonRecord,TANonRecord,NonResident,TDSDeduction,PANExists , t.TCSRate , CAST (FromDate AS date) AS FromDate, CAST(ToDate   AS date) AS ToDate                       
  ,c.blockdetails AS BlockDetails , case when c.blockdetails = 'P' then 'PAN'                             
          when c.blockdetails = 'T' then 'TDS'                             
          when c.blockdetails = 'N' then 'NonResident'                             
          when c.blockdetails = 'P,N' then 'PAN/NonResident'                             
          when c.blockdetails = 'T,N' then 'TDS/NonResident'                             
          when c.blockdetails = 'P,T' then 'PAN/TDS'                             
          when c.blockdetails = 'P,N,T' then 'PAN/NonResident/TDS'                             
          end  AS BlockdetailsName, C.IsActive          
  FROM TCSLogicNew C                                   
  inner join  TCSRateMaster t on c.TCSRateID = t.TCSRate               
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    
  SELECT 
  TCSLogicID, BillingTo, TCSRateID, AgentMasterCountryIN, AddressonRecord,
  TANonRecord, NonResident, TDSDeduction, PANExists,
  t.TCSRate, 
  CAST(FromDate AS date) AS FromDate, 
  CAST(ToDate AS date) AS ToDate,
  c.blockdetails AS BlockDetails, 
  CASE 
    WHEN c.blockdetails = 'P' THEN 'PAN'
    WHEN c.blockdetails = 'T' THEN 'TDS'
    WHEN c.blockdetails = 'N' THEN 'NonResident'
    WHEN c.blockdetails = 'P,N' THEN 'PAN/NonResident'
    WHEN c.blockdetails = 'T,N' THEN 'TDS/NonResident'
    WHEN c.blockdetails = 'P,T' THEN 'PAN/TDS'
    WHEN c.blockdetails = 'P,N,T' THEN 'PAN/NonResident/TDS'
  END AS BlockdetailsName, 
  C.IsActive
FROM TCSLogicNew C
LEFT JOIN TCSRateMaster t ON c.TCSRateID = t.TCSID

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
  WHERE (       @TCSLogicID IS NULL       OR @TCSLogicID = 0       OR TCSLogicID = @TCSLogicID     )                
  Order by C.TCSLogicID desc                                  
 END    
 
END 