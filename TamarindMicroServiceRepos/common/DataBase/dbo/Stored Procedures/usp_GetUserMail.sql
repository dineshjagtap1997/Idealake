CREATE PROCEDURE usp_GetUserMail
(                      
 @userid UNIQUEIDENTIFIER
)                    
AS                    
BEGIN              
 SELECT OffEmail FROM EmployeeMaster WHERE UserID = @userid
         
END
