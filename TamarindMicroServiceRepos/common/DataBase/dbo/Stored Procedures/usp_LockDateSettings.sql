                    
CREATE PROCEDURE [dbo].[usp_LockDateSettings]       
 @Year VARCHAR(100)=''      
 ,@MonthID INT=''      
 ,@LockDate INT=''      
 ,@OperationBy UNIQUEIDENTIFIER=''      
 --,@ErrMsg VARCHAR(50) OUT      
 ,@Action char(2)=''      
AS      
BEGIN       
      
 Declare @LogID int;       
IF @Action='I'      
BEGIN      
IF EXISTS (      
  SELECT MonthID      
  FROM LockDateSettings      
  WHERE MonthID = @MonthID      
  )      
BEGIN      
 SELECT '201' AS returnCode,'Month already exists. Please check and try again.' AS returnMessage;      
END      
ELSE      
BEGIN      
 INSERT INTO LockDateSettings (      
  Year      
  ,MonthID      
  ,LockTillDate      
  ,CreatedDate      
  )      
 VALUES (      
  @Year      
  ,@MonthID      
  ,@LockDate      
  ,GETDATE()      
  )      
      
  SET @LogID =  SCOPE_IDENTITY()      
SELECT '200' AS returnCode,'New record added successfully.' AS returnMessage, @LogID as ID;END      
      
END      
ELSE IF @Action='U'      
BEGIN      
 IF EXISTS (      
   SELECT MonthID      
   FROM LockDateSettings      
   WHERE MonthID = @MonthID      
    AND LockTillDate = @LockDate      
   )      
 BEGIN      
  SELECT '201' AS returnCode,'LockDate already exists. Please check and try again.' AS returnMessage;      
 END      
 ELSE      
 BEGIN      
  UPDATE LockDateSettings      
  SET LockTillDate = @LockDate      
  WHERE MonthID = @MonthID      
    SELECT '200' AS returnCode,'Record updated successfully.' AS returnMessage,  @LogID as ID;      
 END      
END      
ELSE IF @Action='S'      
BEGIN      
 SELECT ID      
  ,Year      
  ,MM.MonthName AS 'MonthName'      
  ,LockTillDate AS LockDate      
  ,LS.MonthID      
 FROM LockDateSettings LS      
 INNER JOIN MonthMaster MM ON LS.MonthID = MM.MonthID      
 WHERE (@MonthID IS NULL OR @MonthID = 0 OR LS.MonthID = @MonthID)       
END      
     
ELSE IF @Action='EX'      
BEGIN      
 SELECT Year      
  ,MM.MonthName AS 'MonthName'      
  ,LockTillDate AS LockDate           
 FROM LockDateSettings LS      
 INNER JOIN MonthMaster MM ON LS.MonthID = MM.MonthID      
 WHERE (@MonthID IS NULL OR @MonthID = 0 OR LS.MonthID = @MonthID)       
END     
END 