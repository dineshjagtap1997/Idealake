
CREATE PROCEDURE [dbo].[usp_DeleteEmployeeMarketMap]  
(  
 @EmpID INT  
)  
AS  
BEGIN  
  
 DELETE FROM EmployeeMarketMap WHERE EmpID=@EmpID  
  SELECT '200' AS returnCode, 'Market Deleted'   AS returnMessage;         

  
END  