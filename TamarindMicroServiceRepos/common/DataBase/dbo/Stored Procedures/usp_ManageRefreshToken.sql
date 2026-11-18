CREATE PROCEDURE [dbo].[usp_ManageRefreshToken]    
    @UserId NVARCHAR(500),    
    @RefreshToken NVARCHAR(500),    
    @ExpirationDate DATETIME = null,    
    @Action NVARCHAR(10), -- 'S', 'I', or 'U'   
	@AccessToken NVARCHAR(500)=null,
	@IsRemembered bit=NULL
AS    
BEGIN    
    IF @Action = 'S'    
    BEGIN    
        SELECT * FROM RefreshTokens WHERE EmpId = @UserId and RefreshToken=@RefreshToken;;    
        SELECT '200' AS returnCode, 'Data Retrieved.' AS returnMessage;    
    END    

     
--    END    
    ELSE IF @Action = 'U'    
    BEGIN    
      

UPDATE RefreshTokens
SET RefreshToken = @RefreshToken,
    ExpirationDate = @ExpirationDate,
	IsRemembered=@IsRemembered
WHERE EmpId = @UserId AND RefreshToken = @AccessToken;

SELECT  Id as ID,RefreshToken as token,'200' as returnCode,'Data Updated.' AS returnMessage,EmpId AS UserId FROM RefreshTokens
WHERE EmpId = @UserId AND RefreshToken = @RefreshToken;

    END    

	ELSE IF @Action = 'I'
BEGIN


-- Fetch EMPID for the given UserID
DECLARE @EmpId NVARCHAR(500);

SELECT @EmpId = EMPID FROM EmployeeMaster WHERE UserName = @UserId;


    INSERT INTO RefreshTokens (EmpId, RefreshToken, ExpirationDate,IsRemembered)
    VALUES (@EmpId, @RefreshToken, @ExpirationDate,@IsRemembered);

SELECT Id AS ID, RefreshToken AS token, '200' AS returnCode, 
       'Login Token Processed.' AS returnMessage, EmpId AS UserId
FROM RefreshTokens
WHERE EmpId = @EmpId;

END

		
		

     

END 