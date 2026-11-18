<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_ManageYearMaster]                          
(                  
    @Action CHAR(1),               -- 'S' for Select, 'I' for Insert, 'U' for Update                          
    @YearId INT = NULL,                                          
    @YearCode VARCHAR(100) = NULL,                               
    @ToDate DATETIME = NULL,                                     
    @FromDate DATETIME = NULL,                                   
   -- @CompanyId INT = NULL,                                       
    @FiscalYear BIGINT = NULL,                                   
    @IsLocked BIT = NULL,                
 @IsActive BIT = NULL,               
 @EntityID INT = NULL,                    
 @VID INT= null,            
 @OperationBy UNIQUEIDENTIFIER= ''          
)                  
AS                          
BEGIN                          
    SET NOCOUNT ON;                          
   declare @LogID int ;                         
 DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);                          
                          
    -- Select Operation (S)                          
    IF (@Action = 'S')                          
BEGIN                          
    -- Select specific columns for the 'S' action                      
    SELECT                       
        YM.CompanyID,                          
        YM.FromDate,                          
        YM.ToDate,                          
        YM.YearCode,                          
        YM.YearID,                          
       -- CM.CompanyName,                          
       -- YM.FiscalYear,                          
        YM.IsLocked ,                    
  EM.LegalName,                
  EM.ID AS EntityID,                
  FV.Variant,                
  FV.variantDuration                
  ,VID ,              
  YM.IsActive      
  ,FiscalYear    
                
    FROM                       
        YearMaster YM                           
  INNER JOIN                       
        EntityMaster EM ON EM.ID = YM.EntityID                 
  INNER JOIN fiscal_variant FV ON FV.ID =YM.VID                
    WHERE                       
        (@YearId IS NULL OR  @YearId = 0 OR YM.YearId = @YearId) 
		AND(@EntityID IS NULL OR  @EntityID = 0 OR EM.ID = @EntityID)  
		
		order by FiscalYear desc;                 
              
            
 SET @ReturnCode = '200';                          
 SET @ReturnMessage = 'Data Retrieved Successfully.';                                  
   END                      
    ------EX OPeration   
 ELSE IF(@Action='EX')  
 BEGIN  
 -- Select specific columns for the 'S' action                      
    SELECT                       
                                
        YM.FromDate,                          
        YM.ToDate,                          
        YM.YearCode,                          
  EM.LegalName,                
  FV.Variant                
 ,CASE     
        WHEN YM.IsActive = 1 THEN 'True'    
        WHEN YM.IsActive = 0 THEN 'False'    
    END AS IsActive        
  ,FiscalYear    
                
    FROM                       
        YearMaster YM                           
  INNER JOIN                       
        EntityMaster EM ON EM.ID = YM.EntityID                 
  INNER JOIN fiscal_variant FV ON FV.ID =YM.VID                
    WHERE                       
        (@YearId IS NULL OR  @YearId = 0 OR YM.YearId = @YearId) order by YearID desc;       
 END  
  
    -- Insert Operation (I)                          
    ELSE IF (@Action = 'I')                          
    BEGIN                          
        IF EXISTS(SELECT YearID FROM YearMaster                           
                  WHERE CONVERT(VARCHAR(50), ToDate, 112) = CONVERT(VARCHAR(50), @ToDate, 112)                                  
                  AND CONVERT(VARCHAR(50), FromDate, 112) = CONVERT(VARCHAR(50), @FromDate, 112)                                  
                  AND EntityID = @EntityID)                          
        BEGIN                
    set @LogID = SCOPE_IDENTITY()             
   SET @ReturnCode = '201';                          
   SET @ReturnMessage = 'Record  already exists.Please check and try again.';                                  
   SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                          
        END                          
        ELSE                          
        BEGIN                          
            DECLARE @MaxID INT = (SELECT ISNULL(MAX(Old_ID), 0) FROM YearMaster) + 1;                          
                          
            INSERT INTO YearMaster (FromDate,                    
   ToDate,                     
   --CompanyID,                     
   YearCode,                       
   Old_ID,                     
   FiscalYear,                     
   IsLocked,                    
   EntityID,                    
   VID,              
   IsActive,          
   OpreationBy)                          
            VALUES (@FromDate,                    
   @ToDate,                     
   --@CompanyId,                    
   @YearCode,                     
   @MaxID,                     
   @FiscalYear,                     
   @IsLocked                    
   ,@EntityID            
   ,@VID,              
   @IsActive          
   ,@OperationBy);                    
               
   SET @LogID = SCOPE_IDENTITY()            
   SET @ReturnCode = '200';                          
   SET @ReturnMessage = 'New record added successfully.';                                  
   SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID as ID;                          
        END                          
   END                          
                          
    -- Update Operation (U)                          
    ELSE IF (@Action = 'U')                          
    BEGIN                          
        IF EXISTS(SELECT YearID FROM YearMaster                           
                  WHERE CONVERT(VARCHAR(50), ToDate, 112) = CONVERT(VARCHAR(50), @ToDate, 112)                           
                  AND CONVERT(VARCHAR(50), FromDate, 112) = CONVERT(VARCHAR(50), @FromDate, 112)                               
                  AND EntityID = @EntityID                           
                  AND YearID <> @YearId)                          
        BEGIN               
            SET @ReturnCode = '201';                          
   SET @ReturnMessage = 'Record  already exists. Please check and try again.';                          
   SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                          
        END                          
        ELSE                   
        BEGIN                          
            UPDATE YearMaster                          
            SET YearCode = @YearCode,                          
                ToDate = @ToDate,                          
                FromDate = @FromDate,                          
              --  CompanyID = @CompanyId,                          
                FiscalYear = @FiscalYear,                          
             IsLocked = @IsLocked,                    
    EntityID = @EntityID,                    
    VID = @VID ,              
 IsActive = @IsActive,          
 OpreationBy = @OperationBy          
                        
            WHERE YearID = @YearId;                        
                          
            SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @YearId AS ID;                        
        END                          
    END                          
    ELSE                          
    BEGIN                          
  SET @ReturnCode = '201';                          
  SET @ReturnMessage = 'Invalid Action Flag';                          
  --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                          
 END                          
 --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                          
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿  
  
CREATE PROCEDURE [dbo].[usp_ManageYearMaster]                              
(                      
    @Action CHAR(2) = 'S',               -- 'S' for Select, 'I' for Insert, 'U' for Update                              
@YearId INT = 0,                                              
@YearCode VARCHAR(100) = NULL,                                   
@FromDate DATETIME = NULL,                                       
@ToDate DATETIME = NULL,                                         
@FiscalYear BIGINT = NULL,                                       
@IsLocked BIT = 1,                   -- true maps to 1                    
@EntityID INT = 0,                        
@CompanyId INT = 0,                                           
@VID INT = 0,                
@OperationBy UNIQUEIDENTIFIER = 'feeceb69-c92c-41a9-98de-fa86fcc009e9',    
@IsActive BIT = NULL  -- not provided in original JSON, set to NULL           
)                      
AS                              
BEGIN                              
    SET NOCOUNT ON;                              
   declare @LogID int ;                             
 DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);                              
                              
    -- Select Operation (S)                              
    IF (@Action = 'S')                              
BEGIN                              
    -- Select specific columns for the 'S' action                          
    SELECT DISTINCT                          
        YM.CompanyID,                              
        YM.FromDate,                              
        YM.ToDate,                              
        YM.YearCode,                              
        YM.YearID,                              
       -- CM.CompanyName,                              
       -- YM.FiscalYear,                              
        YM.IsLocked ,                        
  EM.LegalName,                    
  EM.ID AS EntityID,                    
  FV.Variant,                    
  FV.variantDuration                    
  ,VID ,                  
  YM.IsActive          
  ,FiscalYear        
                    
    FROM                           
        YearMaster YM                               
  INNER JOIN  EntityMaster EM ON EM.ID = YM.EntityID                     
  INNER JOIN fiscal_variant FV ON FV.ID =YM.VID          
  INNER JOIN CompanyMaster CM ON CM.TEntity_ID =EM.ID                    
    
    WHERE                           
  (@YearId IS NULL OR  @YearId = 0 OR YM.YearId = @YearId)     
  AND(@EntityID IS NULL OR  @EntityID = 0 OR EM.ID = @EntityID)   
  AND(@CompanyId IS NULL OR  @CompanyId = 0 OR CM.CompanyID = @CompanyId)  
  and (ym.IsActive=@IsActive or @IsActive is null) --and em.IsActive=1  
  order by FiscalYear desc;                     
                  
                
 SET @ReturnCode = '200';                              
 SET @ReturnMessage = 'Data Retrieved Successfully.';                                      
   END                          
    ------EX OPeration       
ELSE IF(@Action='EX')      
BEGIN      
     SELECT                            
        YM.CompanyID,                              
        YM.FromDate,                              
        YM.ToDate,                              
        YM.YearCode,                              
        YM.YearID,                              
        YM.IsLocked,                        
        EM.LegalName,                    
        EM.ID AS EntityID,                    
        FV.Variant,                    
        FV.variantDuration,                    
        YM.VID,                  
        YM.IsActive,          
        YM.FiscalYear        
    FROM                            
        YearMaster YM                               
    LEFT JOIN EntityMaster EM ON EM.ID = YM.EntityID                     
    LEFT JOIN fiscal_variant FV ON FV.ID = YM.VID                    
    ORDER BY FiscalYear DESC;  
  
    -- ✅ Return message expected by API  
    SET @ReturnCode = '200';  
    SET @ReturnMessage = 'Data Retrieved Successfully.';  
    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;  
END  
  
  
    -- Insert Operation (I)                              
    ELSE IF (@Action = 'I')                              
    BEGIN                              
        IF EXISTS(SELECT YearID FROM YearMaster                               
                  WHERE CONVERT(VARCHAR(50), ToDate, 112) = CONVERT(VARCHAR(50), @ToDate, 112)                                      
                  AND CONVERT(VARCHAR(50), FromDate, 112) = CONVERT(VARCHAR(50), @FromDate, 112)                                      
                  AND EntityID = @EntityID)                              
   BEGIN                    
    set @LogID = SCOPE_IDENTITY()                 
      SET @ReturnCode = '201';                              
      SET @ReturnMessage = 'Record  already exists.Please check and try again.';                                      
      SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                              
   END     
  ELSE IF EXISTS(SELECT YearID FROM YearMaster                               
                  WHERE     
     EntityID = @EntityID    
     AND FiscalYear= @FiscalYear    
     AND VID <> @VID)                              
   BEGIN                    
    set @LogID = SCOPE_IDENTITY()                 
    SET @ReturnCode = '201';                              
    SET @ReturnMessage = 'Legal Entity already exists for selected Variant and Fiscal Year.';                                      
    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                              
   END          
        ELSE                              
   BEGIN                              
    DECLARE @MaxID INT = (SELECT ISNULL(MAX(Old_ID), 0) FROM YearMaster) + 1;                              
                              
    INSERT INTO YearMaster (FromDate,                        
       ToDate,                         
       CompanyID,                         
       YearCode,                           
       Old_ID,                         
       FiscalYear,                         
       IsLocked,                        
       EntityID,                        
       VID,                  
       IsActive,              
       OpreationBy)                              
       VALUES (@FromDate,                        
       @ToDate,                         
       @CompanyId,                        
       @YearCode,                         
       @MaxID,                         
       @FiscalYear,                         
       @IsLocked                        
       ,@EntityID                
       ,@VID,                  
       @IsActive              
       ,@OperationBy);                        
                   
       SET @LogID = SCOPE_IDENTITY()                
       SET @ReturnCode = '200';                              
       SET @ReturnMessage = 'New record added successfully.';                                      
       SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID as ID;                              
   END                              
   END                              
                              
    -- Update Operation (U)                              
    ELSE IF (@Action = 'U')                              
    BEGIN                              
        IF EXISTS(SELECT YearID FROM YearMaster                               
                  WHERE CONVERT(VARCHAR(50), ToDate, 112) = CONVERT(VARCHAR(50), @ToDate, 112)                               
                  AND CONVERT(VARCHAR(50), FromDate, 112) = CONVERT(VARCHAR(50), @FromDate, 112)                                   
                  AND EntityID = @EntityID                               
                  AND YearID <> @YearId)                              
        BEGIN                   
            SET @ReturnCode = '201';                              
   SET @ReturnMessage = 'Record  already exists. Please check and try again.';                              
   SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                              
        END                              
        ELSE                       
        BEGIN                              
            UPDATE YearMaster                              
            SET YearCode = @YearCode,                              
                ToDate = @ToDate,                              
                FromDate = @FromDate,                              
               CompanyID = @CompanyId,                              
                FiscalYear = @FiscalYear,                              
             IsLocked = @IsLocked,                        
    EntityID = @EntityID,                        
    VID = @VID ,                  
 IsActive = @IsActive,              
 OpreationBy = @OperationBy              
                            
            WHERE YearID = @YearId;                            
                              
            SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @YearId AS ID;                            
        END                              
    END                              
    ELSE                              
    BEGIN                              
  SET @ReturnCode = '201';                              
  SET @ReturnMessage = 'Invalid Action Flag';                              
  --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                              
 END                              
 --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;                              
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END 