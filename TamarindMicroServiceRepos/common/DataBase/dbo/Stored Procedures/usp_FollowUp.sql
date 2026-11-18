CREATE PROCEDURE [dbo].[usp_FollowUp]             
@FollowUpDate DATETIME = ''            
 ,@FollowUpTime VARCHAR(50) = ''            
 ,@FollowUpRemark VARCHAR(255) = ''            
 ,@RescheduleFollowUp VARCHAR(255) = ''            
 --,@CreatedBy INT = ''            
 ,@CreatedDateTime DATETIME = ''            
<<<<<<< HEAD
<<<<<<< HEAD
 --,@UpdatedBy INT = ''            
=======
 --,@UpdatedBy INT = '' 
-- ,@UserID uniqueidentifier = NULL
>>>>>>> dev
=======
 --,@UpdatedBy INT = '' 
-- ,@UserID uniqueidentifier = NULL
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 ,@UpdatedDateTime DATETIME = ''            
 ,@EnquiryID BIGINT = ''            
 ,@Action CHAR(2) = ''            
 ,@FollowUPID INT = ''            
<<<<<<< HEAD
<<<<<<< HEAD
 ,@EmpID INT=''            
=======
 ,@EmpID uniqueidentifier=NULL  ,
 @EnquiryNID Nvarchar(500)= nULL
>>>>>>> dev
=======
 ,@EmpID uniqueidentifier=NULL  ,
 @EnquiryNID Nvarchar(500)= nULL
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
AS            
BEGIN          
Declare @LogID INT        
 IF @Action = 'I'            
 BEGIN            
 IF  EXISTS (SELECT 1 FROM [TBL_Follow_Up_Section] WHERE [FollowUpDate] =@FollowUpDate AND [FollowUpTime] = @FollowUpTime)        
 BEGIN        
 SELECT '201' AS returnCode, 'This data already exists. Please check and try again.' as returnMessage        
 END        
 ELSE         
 BEGIN        
  INSERT INTO [dbo].[TBL_Follow_Up_Section] (            
   [FollowUpRemark]            
   ,[RescheduleFollowUp]            
   ,[CreatedBy]            
   ,[CreatedDateTime]            
   ,[UpdatedBy]            
   ,[UpdatedDateTime]            
   ,[EnquiryID]            
   ,[FollowUpDate]            
   ,[FollowUpTime]            
   )            
  VALUES (            
   @FollowUpRemark            
   ,@RescheduleFollowUp            
   ,@EmpID            
   ,GETDATE()            
   ,@EmpID            
   ,GETDATE()           
   ,@EnquiryID            
   ,@FollowUpDate            
   ,@FollowUpTime            
   );            
            
   SET @LogID = SCOPE_IDENTITY()        
   SELECT '200' AS returnCode, 'Follow-Up Details Saved Successfully ' AS returnMessage, @LogID AS ID;            
 END         
 END        
 ELSE IF @Action = 'U'            
 BEGIN            
  UPDATE [dbo].[TBL_Follow_Up_Section]            
  SET [FollowUpRemark] = @FollowUpRemark            
   ,[RescheduleFollowUp] = @RescheduleFollowUp            
   ,[UpdatedBy] = @EmpID            
   ,[UpdatedDateTime] =  GETDATE()             
   ,[EnquiryID] = @EnquiryID            
   ,[FollowUpDate]= @FollowUpDate            
   ,[FollowUpTime] =@FollowUpTime            
  WHERE [FollowUPID] = @FollowUPID;            
     SELECT '200' AS returnCode, 'Data Updated Successfully ' AS returnMessage, @FollowUPID AS ID;            
            
<<<<<<< HEAD
<<<<<<< HEAD
 END            
=======
 END     
  
>>>>>>> dev
=======
 END     
  
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 ELSE IF @Action = 'S'            
 BEGIN            
 SELECT             
    [FollowUPID],            
    [FollowUpDate],            
    [FollowUpTime],            
    [FollowUpRemark],            
    EMC.EmpName AS CreatedBy,            
    [CreatedDateTime],            
    EMU.EmpName AS UpdatedBy,            
    [UpdatedDateTime],            
    [EnquiryID]            
FROM [dbo].[TBL_Follow_Up_Section] FUS            
<<<<<<< HEAD
<<<<<<< HEAD
INNER JOIN EmployeeMaster EMC ON FUS.CreatedBy = EMC.EmpID            
INNER JOIN EmployeeMaster EMU ON FUS.UpdatedBy = EMU.EmpID            
=======
INNER JOIN EmployeeMaster EMC ON FUS.CreatedBy = EMC.UserID            
INNER JOIN EmployeeMaster EMU ON FUS.UpdatedBy = EMU.UserID            
>>>>>>> dev
=======
INNER JOIN EmployeeMaster EMC ON FUS.CreatedBy = EMC.UserID            
INNER JOIN EmployeeMaster EMU ON FUS.UpdatedBy = EMU.UserID            
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            
  where (       @FollowUPID IS NULL       OR @FollowUPID = 0       OR FollowUPID = @FollowUPID       )           
  and (@EnquiryID is null or @EnquiryID = 0 or EnquiryID = @EnquiryID)      
  ORDER by 1 desc          
 END         
 ELSE IF @Action = 'EX'            
 BEGIN            
 SELECT             
    [FollowUpDate],            
    [FollowUpTime],            
    [FollowUpRemark]          
FROM [dbo].[TBL_Follow_Up_Section] FUS            
<<<<<<< HEAD
<<<<<<< HEAD
INNER JOIN EmployeeMaster EMC ON FUS.CreatedBy = EMC.EmpID            
INNER JOIN EmployeeMaster EMU ON FUS.UpdatedBy = EMU.EmpID            
=======
INNER JOIN EmployeeMaster EMC ON FUS.CreatedBy = EMC.UserID            
INNER JOIN EmployeeMaster EMU ON FUS.UpdatedBy = EMU.UserID            
>>>>>>> dev
=======
INNER JOIN EmployeeMaster EMC ON FUS.CreatedBy = EMC.UserID            
INNER JOIN EmployeeMaster EMU ON FUS.UpdatedBy = EMU.UserID            
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            
  where (       @FollowUPID IS NULL       OR @FollowUPID = 0       OR FollowUPID = @FollowUPID       )           
  and (@EnquiryID is null or @EnquiryID = 0 or EnquiryID = @EnquiryID)      
  ORDER by 1 desc          
 END         
END