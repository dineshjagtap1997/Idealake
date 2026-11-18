CREATE PROCEDURE [dbo].[USP_UnlockUser]        
    @EmpID INT,        
    @UserName NVARCHAR(256),      
 @Action CHAR(2)='',      
    @OperatedBy uniqueidentifier =''-- User making the update        
AS       
BEGIN      
IF @Action='U'      
BEGIN        
       
    BEGIN TRY        
        BEGIN TRANSACTION        
        
        -- Check if the employee exists        
        IF EXISTS (        
            SELECT 1        
            FROM EmployeeMaster        
            WHERE EmpID = @EmpID AND UserName = @UserName        
        )        
        BEGIN        
            -- Update the EmployeeMaster table to unlock the user        
            UPDATE EmployeeMaster        
            SET IsLockedOut = 0,                  -- Unlock the user        
                FailedPasswordAttemptCount = 0,   -- Reset the failed attempt count        
                UpdatedBy = @OperatedBy,           -- Track who updated        
                UpdatedOn = GETDATE()           -- Track when updated        
            WHERE EmpID = @EmpID AND UserName = @UserName;        
        
            -- Successful update; return success message        
            SELECT '200' AS returnCode,        
                   'User is unlocked successfully.' AS returnMessage;        
        END        
        ELSE        
        BEGIN        
            -- Employee does not exist; return error message        
            SELECT '404' AS returnCode,        
                   'Employee does not exist.' AS returnMessage;        
        END        
        
        -- Commit transaction        
        COMMIT TRANSACTION        
    END TRY        
    BEGIN CATCH        
        -- Rollback transaction in case of error        
        ROLLBACK TRANSACTION;        
        
        -- Return error details        
        SELECT '500' AS returnCode,        
               ERROR_MESSAGE() AS returnMessage;        
    END CATCH        
END       
      
ELSE IF @Action='S'      
BEGIN       
 SELECT UserName      
  ,m.CreateDate      
  ,m.LastLoginDate      
  ,M.EmpID      
  ,m.IsLockedOut      
  --,m.LastLockoutDate      
 FROM EmployeeMaster m      
 WHERE (IsLockedOut=1) and (@EmpID = 0 OR @EmpID IS NULL OR EmpID= @EmpID)    
 order by EmpID desc
END      
      
END