CREATE PROCEDURE [dbo].[usp_GetEmpRightsToOverlapByEmpID] --  12           
(              
 @EmpID INT,  
 @YearID INT,  
 @CompanyID INT               
)              
AS              
BEGIN              
 SELECT EmpCompYearMapID,EmpID,CompanyID,YearID,ISNULL(ViewRights,0) AS ViewRights,ISNULL(AsPerAdminRules, 0) AS  AsPerAdminRules  FROM EmployeeCompanyYearMap           
 WHERE EmpID=@EmpID AND YearID = @YearID AND CompanyID = @CompanyID           
END    