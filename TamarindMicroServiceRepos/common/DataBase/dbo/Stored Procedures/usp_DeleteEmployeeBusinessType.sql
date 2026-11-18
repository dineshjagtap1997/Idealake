CREATE PROCEDURE [dbo].[usp_DeleteEmployeeBusinessType]    
(    
 @EmpID INT    
)    
AS    
BEGIN    
    
 DELETE FROM EmployeeBusinessTypeMap WHERE EmpID=@EmpID    
END 