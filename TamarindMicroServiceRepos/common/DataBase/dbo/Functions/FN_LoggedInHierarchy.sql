CREATE FUNCTION FN_LoggedInHierarchy    
(    
    @OperationBy UNIQUEIDENTIFIER    
)    
RETURNS TABLE    
AS    
RETURN    
(   
    SELECT 
	COALESCE(CAST(UserID AS nvarchar(36)), '') + ',' + 
        COALESCE(CAST(Level1 AS nvarchar(36)), '') + ',' +   
        COALESCE(CAST(Level2 AS nvarchar(36)), '') + ',' +   
        COALESCE(CAST(Level3 AS nvarchar(36)), '') AS UseriD  
    FROM EmployeeMaster    
    WHERE UserID = @OperationBy    
);  