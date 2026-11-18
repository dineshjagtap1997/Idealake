
CREATE FUNCTION [dbo].[fn_Get_All_Reporting]                 
(                
@CompanyID INT = 0                 
, @UserID uniqueidentifier = NULL                  
)         


RETURNS @Rporting Table (UserId uniqueidentifier)           
       
                
                
AS                  

BEGIN   
Declare @EmpID int;
set @EmpID=(select EmpID from EmployeeMaster where UserID=@UserID)

insert into @Rporting      
 SELECT a.UserID                  
  FROM EmployeeMaster a                  
  WHERE a.userid=@userid           
   AND a.IsActive = 1
   --AND Convert(varchar(500),@CompanyID)  in (a.CompanyID)      
     --AND @CompanyID IN (SELECT value FROM STRING_SPLIT(a.CompanyID, ',')) 
       AND EXISTS (
    SELECT 1 
    FROM STRING_SPLIT(a.CompanyID, ',') AS c
    WHERE c.value = CAST(@CompanyID AS VARCHAR)
)
DECLARE @Count AS INT      
Select @Count = count (*) from @Rporting      
       
If @Count >  0       
 begin       
 insert into @Rporting      
 SELECT  a.UserID                
   FROM EmployeeMaster a                  
   WHERE @EmpID IN (                                                                                                                           
     SELECT Item                                                                                                                              
    -- FROM dbo.[SplitString](a.Teamid, ','))          
     FROM dbo.[SplitString](CAST(a.ReportHeadID AS NVARCHAR(50)), ','))  -- Ensure proper casting   
  AND a.IsActive = 1                  
     --AND @CompanyID IN (SELECT value FROM STRING_SPLIT(a.CompanyID, ',')) 
	 AND EXISTS (
    SELECT 1 
    FROM STRING_SPLIT(a.CompanyID, ',') AS c
    WHERE c.value = CAST(@CompanyID AS VARCHAR)
)
   end      
 RETURN                 
  END 