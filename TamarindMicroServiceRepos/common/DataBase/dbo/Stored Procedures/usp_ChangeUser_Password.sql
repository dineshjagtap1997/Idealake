CREATE PROCEDURE [dbo].[usp_ChangeUser_Password]     
    @UserName VARCHAR(MAX),    
    @NewPassword NVARCHAR(MAX)    
AS    
BEGIN    
    DECLARE @CurrentPassword NVARCHAR(MAX);    

    -- Check if the user exists and retrieve the current password
    SELECT @CurrentPassword = Password    
    FROM EmployeeMaster    
    WHERE UserName = @UserName;    

    IF (@CurrentPassword IS NULL)    
    BEGIN    
        -- User does not exist
        SELECT '201' AS returnCode, 'User does not exist' AS returnMessage;   
        RETURN;    
    END    

    -- Update the password
    UPDATE EmployeeMaster    
    SET Password = @NewPassword    
    WHERE UserName = @UserName;    

    IF (@@ROWCOUNT = 0)    
    BEGIN    
        -- Password change failed
        SELECT '201' AS returnCode, 'Password change failed' AS returnMessage;          
    END    

    -- Success
    SELECT '200' AS returnCode, 'Password changed successfully' AS returnMessage; 

END;
