USE [tamarinddev_db]
GO
/****** Object:  StoredProcedure [dbo].[usp_Rules_Master]    Script Date: 12-09-2025 10:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_Rules_Master] @RuleGroupID INT =''                 
 ,@Header VARCHAR(50)  =''                
 ,@Description VARCHAR(500) =''                 
 ,@IsActive BIT =''                 
 ,@IsMandatory BIT =''                 
 ,@OperationBy UNIQUEIDENTIFIER =''                 
 ,@SequenceNo INT = 0                  
 ,--by sanket                      
 @RuleHeaderType INT = 0                  
 ,--by sanket                           
 --@ErrMsg   VARCHAR(50) OUT                         
 @Action CHAR(3) = ''                  
 --,@Active BIt=''                  
 ,@ID INT =''                  
AS                  
BEGIN                  
 IF @Action = 'I'                  
 BEGIN                  
  IF EXISTS (                  
    SELECT TOP 1 1                  
    FROM Rules                  
    WHERE Header = @Header                  
     AND RuleGroupID = @RuleGroupID                  
    )                  
  BEGIN                  
  SELECT '201' AS returnCode,  'Rule already exists. Please check and try again.'   AS returnMessage;                   
  END                  
  ELSE                  
  BEGIN                  
   DECLARE @MaxID INT = (                  
     SELECT MAX(OldID)                  
     FROM Rules                  
     ) + 1                  
                  
   INSERT INTO Rules (                  
    RuleGroupID                  
    ,Header                  
    ,Description                  
    ,IsActive                  
    ,IsMandatory                  
    ,Operation                  
    ,OperationBy                  
    ,OperationOn                  
    ,OldID                  
    ,SequenceNo                  
    ,RuleHeaderType                  
    )                  
   VALUES (                  
    @RuleGroupID                  
    ,@Header                  
    ,@Description                  
    ,@IsActive                  
    ,@IsMandatory                  
    ,'Insert'                  
    ,@OperationBy                  
    ,GETDATE()                  
    ,@MaxID                  
    ,@SequenceNo                  
    ,@RuleHeaderType                  
    )                  
                  
   --EXEC usp_InsertRules_Audit @@IDENTITY                  
   -- ,'Insert'                  
   -- ,@OperationBy                  
    -- SET   @ErrMsg = ''               
 set @ID = SCOPE_IDENTITY()      
 select '200' as returnCode, 'New record added successfully.' as returnMessage , @ID AS ID;            
  END --I                  
  END                    
                  
  ELSE IF @Action = 'U'                  
  BEGIN                  
   IF EXISTS (                  
     SELECT TOP 1 1                  
     FROM Rules                  
     WHERE Header = @Header                  
      AND RuleGroupID = @RuleGroupID                  
      AND ID != @ID                  
     )                  
   BEGIN                  
   SELECT '201' AS returnCode, 'Rule already exists. Please check and try again.'   AS returnMessage;                   
   END                  
   ELSE                  
   BEGIN                  
    UPDATE Rules                  
    SET RuleGroupID = @RuleGroupID                  
     ,Header = @Header                  
     ,Description = @Description                  
     ,IsActive = @IsActive                  
     ,IsMandatory = @IsMandatory                  
     ,Operation = 'Update'                  
       ,UpdatedBy = @OperationBy                
    ,UpdatedOn = GETDATE()                
     ,SequenceNo = @SequenceNo                  
     ,RuleHeaderType = @RuleHeaderType                  
    WHERE ID = @ID                  
                  
 select '200' as returnCode, 'Record updated successfully.' as returnMessage,  @ID AS ID;                 
    --EXEC usp_InsertRules_Audit @ID                  
    -- ,'Update'                  
    -- ,@OperationBy                  
   END                  
  END --U                  
  ELSE IF @Action='S'                               
 BEGIN                                  
  SELECT r.ID, r.RuleGroupID, r.Header, r.Description, r.IsActive,rg.Name as RuleGroup,r.IsMandatory                       
    ,SequenceNo,RuleHeaderType --added by sanket @ 13/01/2016                        
  ,Case when RuleHeaderType=1 then 'Hotel / Vendor Master'                         
   when RuleHeaderType=2 then 'RateCards'                         
   when RuleHeaderType=3 then  'Both' end   AS RuleHeaderTypeName                      
                                    
  FROM Rules r                                  
  INNER JOIN RuleGroups rg ON rg.ID=r.RuleGroupID      
  WHERE (                
    @ID IS NULL               
    OR @ID = 0                
    OR r.ID = @ID                
    )  
	
  AND (
    @RuleGroupID IS NULL OR @RuleGroupID = 0 OR r.RuleGroupID = @RuleGroupID
  )
   ORDER BY r.OperationOn DESC                             
  --ORDER BY r.OperationOn Desc                                 
 END               
 --ELSE IF @Action='EX'
 --BEGIN
 --SELECT r.Header, r.Description ,CASE   
 --       WHEN r.IsActive = 1 THEN 'True'  
 --       WHEN r.IsActive = 0 THEN 'False'  
 --   END AS IsActive ,rg.Name as RuleGroup,CASE   
 --       WHEN r.IsMandatory = 1 THEN 'Yes'  
 --       WHEN r.IsMandatory = 0 THEN 'No'  
 --   END AS IsMandatory                        
 --  ,RuleHeaderType --added by sanket @ 13/01/2016                        
 -- ,Case when RuleHeaderType=1 then 'Hotel / Vendor Master'                         
 --  when RuleHeaderType=2 then 'RateCards'                         
 --  when RuleHeaderType=3 then  'Both' end   AS RuleHeader                      
                                    
 -- FROM Rules r                                  
 -- INNER JOIN RuleGroups rg ON rg.ID=r.RuleGroupID      
 -- WHERE (                
 --   @ID IS NULL               
 --   OR @ID = 0                
 --   OR r.ID = @ID                
 --   )                              
 --  ORDER BY r.OperationOn DESC 
 --END
 ELSE IF @Action='EX'
BEGIN
    SELECT 
        r.Header, 
        r.Description,
        r.IsActive,         
        rg.Name as RuleGroup,
        r.IsMandatory,      
        RuleHeaderType,
        CASE 
            WHEN RuleHeaderType = 1 THEN 'Hotel / Vendor Master'
            WHEN RuleHeaderType = 2 THEN 'RateCards'
            WHEN RuleHeaderType = 3 THEN 'Both'
        END AS RuleHeader
    FROM Rules r
    INNER JOIN RuleGroups rg ON rg.ID = r.RuleGroupID
  WHERE (@ID IS NULL OR @ID = 0 OR r.ID = @ID)
  AND (
    @RuleGroupID IS NULL OR @RuleGroupID = 0 OR r.RuleGroupID = @RuleGroupID
  )
    ORDER BY r.OperationOn DESC
END

END 