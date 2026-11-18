CREATE PROCEDURE [dbo].[USP_UpdateemployeeCompanyYearMap]        
(      
@EmpCompYearMapID INT,      
@EmpID int,      
@CompanyID INT,        
@YearID INT,      
@ViewRights BIT,      
@AsPerAdminRules BIT          
)      
AS      
BEGIN      
UPDATE EmployeeCompanyYearMap SET       
 EmpID=@EmpID,      
 CompanyID=@CompanyID,      
 YearID=@YearID,      
 ViewRights = @ViewRights ,      
 AsPerAdminRules=@AsPerAdminRules      
WHERE EmpCompYearMapID=@EmpCompYearMapID      
END