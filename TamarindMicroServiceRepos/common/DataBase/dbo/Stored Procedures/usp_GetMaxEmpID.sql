

CREATE PROCEDURE [dbo].[usp_GetMaxEmpID]  
(  
 @Prefix varchar(10)   
)  
AS  
BEGIN  
  
 SELECT COUNT(ISNULL(EmpCode, 0)) + 1 AS EmpCode FROM EmployeeMaster    
  
END  