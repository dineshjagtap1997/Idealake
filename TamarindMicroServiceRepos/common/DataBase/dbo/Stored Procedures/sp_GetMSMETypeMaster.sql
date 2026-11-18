CREATE PROCEDURE [dbo].[sp_GetMSMETypeMaster]    
    @MSMETypeID INT = NULL,    
    @Action CHAR(2) = 'S'    
AS    
BEGIN    
    IF (@Action = 'S')    
    BEGIN    
        SELECT *    
        FROM MSMETypeMaster    
        WHERE (@MSMETypeID IS NULL OR @MSMETypeID = 0 OR MSMETypeID = @MSMETypeID)    
            
  SELECT '' AS returnCode, '' AS returnMessage    
    END 
	ELSE IF @Action='EX'
	BEGIN
	   SELECT MSMETypeName,Description,CASE WHEN  IsActive = 1 THEN 'True'        
        WHEN IsActive = 0 THEN 'False' END AS IsActive , Operation  
        FROM MSMETypeMaster    
        WHERE (@MSMETypeID IS NULL OR @MSMETypeID = 0 OR MSMETypeID = @MSMETypeID)    
	END
    ELSE    
    BEGIN    
  SELECT '201' AS returnCode, 'Invalid Action.' AS returnMessage    
    END    
END;    