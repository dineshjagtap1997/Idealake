CREATE PROCEDURE [dbo].[USP_InsertPackageCodeMaster]          
 @Action CHAR(1)='', -- 'I' for Insert, 'U' for Update, 'S' for Select        
 @PkgMktCode VARCHAR(5)='',          
 @Nights INT='',          
 @StateRouteCode VARCHAR(5)=null,          
 @ExtnAssignedCode VARCHAR(3)='',        
 @PackageName VARCHAR(80)='',        
 @Remarks VARCHAR(80)='',        
 @PackageCode NVARCHAR(50)=NULL,        
 @IsActive BIT=NULL,        
 @OperationBy UNIQUEIDENTIFIER=NULL                   
AS            
BEGIN            
    SET NOCOUNT ON;        
    BEGIN TRY  
	
	DECLARE  @LogID int;  
        IF @Action = 'I' -- Insert logic        
        BEGIN        
            -- Check if the record already exists        
            IF EXISTS (SELECT 1 FROM PackageCodeMaster WHERE PackageCode = @PackageCode AND IsActive = 1)                  
            BEGIN                  
                SELECT '201' AS ReturnCode, 'PackageCode already exists in the database.' AS ReturnMessage, @LogID AS ID;                       
                RETURN;                 
            END                  
                
            -- Insert new record        
            INSERT INTO PackageCodeMaster (PkgMktCode, Nights, StateRouteCode, ExtnAssignedCode, PackageName, Remarks, PackageCode, IsActive,        
                                           Operation, OperationBy, OperationOn)            
            VALUES (@PkgMktCode, @Nights, @StateRouteCode, @ExtnAssignedCode, @PackageName, @Remarks, @PackageCode, @IsActive,        
                    'INSERT', @OperationBy, GETDATE());     
					
		    SET @LogID = SCOPE_IDENTITY() 
            SELECT '200' AS ReturnCode, 'Data inserted successfully.' AS ReturnMessage, @LogID AS ID;       
        END        
        ELSE IF @Action = 'U' -- Update logic        
        BEGIN        
            -- Check if PackageCode is provided for update        
            IF (@PackageCode IS NULL OR @PackageCode = '')      
            BEGIN      
                SELECT '201' AS ReturnCode, 'PackageCode is required for Update.' AS ReturnMessage;        
                RETURN;      
            END        
        
            -- Update the record        
            UPDATE PackageCodeMaster        
            SET PkgMktCode = @PkgMktCode,        
                Nights = @Nights,        
                StateRouteCode = @StateRouteCode,        
                ExtnAssignedCode = @ExtnAssignedCode,        
                PackageName = @PackageName,        
                Remarks = @Remarks,        
                IsActive = @IsActive,        
                Operation = 'UPDATE',        
                UpdatedBy = @OperationBy,        
                UpdatedOn = GETDATE()        
            WHERE PackageCode = @PackageCode --AND IsActive = 1;      
			
			SET @LogID = (select PackageID from PackageCodeMaster WHERE PackageCode = @PackageCode)
        
            IF @@ROWCOUNT = 0        
            BEGIN        
                SELECT '201' AS ReturnCode, 'No record found to update.' AS ReturnMessage, @LogID AS ID;         
                RETURN;      
            END        
        
            SELECT '200' AS ReturnCode, 'Data updated successfully.' AS ReturnMessage, @LogID AS ID;        
        END        
        ELSE   
  IF @Action = 'S' -- Select logic        
        BEGIN        
            -- Select records based on input parameters        
            SELECT PackageID,
			       PkgMktCode,        
                   Nights,        
                   StateRouteCode,        
                   ExtnAssignedCode,        
                   PackageName,        
                   Remarks,        
                   PackageCode,        
                   IsActive        
            FROM PackageCodeMaster        
            WHERE (@PackageCode IS NULL  OR @PackageCode = '' OR PackageCode = @PackageCode)        
              --AND (@IsActive IS NULL OR IsActive = @IsActive)  
     order by PackageId desc  
        END        
        ELSE        
        BEGIN        
            SELECT '201' AS ReturnCode, 'Invalid Action performed!' AS ReturnMessage;        
        END        
    END TRY        
    BEGIN CATCH        
        -- Capture and handle any errors        
        SELECT ERROR_NUMBER() AS ErrorCode, ERROR_MESSAGE() AS ErrorMessage;        
    END CATCH        
END; 