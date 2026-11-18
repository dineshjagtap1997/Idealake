CREATE Procedure [dbo].[USP_GETSAPCompCode]          
 @Action Char(2) =null ,      
 @ID INT =NULL    
as       
BEGIN       
if @Action = 'S'      
begin      
Select ID, SAPCompCode, IsActive from EntityMaster where  (ID = @ID OR @ID = 0 OR @ID IS NULL) order by 1 desc      
end
else if @Action = 'ex'      
begin      
Select SAPCompCode, 
CASE 
WHEN IsActive =0 THEN 'True'
WHEN IsActive = 1 THEN 'False'
END AS IsActive
from EntityMaster 
where  (ID = @ID OR @ID = 0 OR @ID IS NULL) 
order by 1 desc      
        
end      
END   