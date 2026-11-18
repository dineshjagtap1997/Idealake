USE [tamarinddev_db]
GO
/****** Object:  StoredProcedure [dbo].[usp_EmployeeTargetNew]    Script Date: 12-09-2025 10:15:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_EmployeeTargetNew]                                          
 @EmployeeTargetID INT OUT                                          
 ,@CompanyID INT                             
 ,@EmpID INT                           
 ,@StaffName VARCHAR(20)                                          
 ,@YearID INT                                          
 ,@YearCode VARCHAR(20)                                          
 ,@Currency INT = NULL                                         
 ,@Type VARCHAR(200)                                          
 ,@Apr_Topline DECIMAL(18, 2)                                          
 ,@Apr_GOP DECIMAL(18, 2)                                          
 ,@May_Topline DECIMAL(18, 2)                                          
 ,@May_GOP DECIMAL(18, 2)                                          
 ,@Jun_Topline DECIMAL(18, 2)                                          
 ,@Jun_GOP DECIMAL(18, 2)                                          
 ,@Jul_Topline DECIMAL(18, 2)                                          
 ,@Jul_GOP DECIMAL(18, 2)                                          
 ,@Aug_Topline DECIMAL(18, 2)                                          
 ,@Aug_GOP DECIMAL(18, 2)                                          
 ,@Sep_Topline DECIMAL(18, 2)                                          
 ,@Sep_GOP DECIMAL(18, 2)                                          
 ,@Oct_Topline DECIMAL(18, 2)                                          
 ,@Oct_GOP DECIMAL(18, 2)                                          
 ,@Nov_Topline DECIMAL(18, 2)                                          
 ,@Nov_GOP DECIMAL(18, 2)                                          
 ,@Dec_Topline DECIMAL(18, 2)                                          
 ,@Dec_GOP DECIMAL(18, 2)                                          
 ,@Jan_Topline DECIMAL(18, 2)                                          
 ,@Jan_GOP DECIMAL(18, 2)                                          
 ,@Feb_Topline DECIMAL(18, 2)                                          
 ,@Feb_GOP DECIMAL(18, 2)                                          
 ,@Mar_Topline DECIMAL(18, 2)                                          
 ,@Mar_GOP DECIMAL(18, 2)                                          
 ,@OperationBy UNIQUEIDENTIFIER =NULL                                         
 ,@Action char(2)=''                                          
 ,@UpdatedBy UNIQUEIDENTIFIER=NULL
 --,@PageNumber BIGINT=NULL
 --,@PageSize INT=NULL
 ,@Row_Count VARCHAR(max) = '10' ,                     
 @PageNumber INT = 0   
AS                                          
BEGIN   

DECLARE @TotalRecordCount INT                      
  ,@SQL NVARCHAR(MAX); 

IF @Action='I'                                          
BEGIN                                          
IF EXISTS (                                          
  SELECT ID                                          
   ,EmpID                                          
  FROM EmployeeTargetNew                                          
  WHERE EmpID = @EmpID                                          
   AND YearCode = @YearCode                                          
   AND YearID = @YearID                                          
   AND Type = @Type                                          
  )                                          
BEGIN                                          
  Select  '201' AS ReturnCode, 'Same Staff - Same Year cannot be added again.' AS ReturnMessage                                                
END                                          
ELSE                                          
BEGIN                                          
 INSERT INTO EmployeeTargetNew (                                          
  CompanyID                                          
  ,EmpID                            
  ,etn.StaffName                          
  ,YearID                                          
  ,YearCode                                          
  ,CurrencyCode                                          
  ,Type                                          
  ,Apr_Topline                                          
  ,Apr_GOP                                          
  ,May_Topline                                          
  ,May_GOP                                          
  ,Jun_Topline                            
  ,Jun_GOP                                          
  ,Jul_Topline                                          
  ,Jul_GOP                                          
  ,Aug_Topline                                          
  ,Aug_GOP                                          
  ,Sep_Topline                                          
  ,Sep_GOP                                          
  ,Oct_Topline                                          
  ,Oct_GOP                                          
  ,Nov_Topline                                          
  ,Nov_GOP                                          
  ,Dec_Topline                            
  ,Dec_GOP                                          
  ,Jan_Topline                                          
  ,Jan_GOP                                          
  ,Feb_Topline                                         
  ,Feb_GOP                                          
  ,Mar_Topline                                          
  ,Mar_GOP                                          
  ,Operation                               
  ,OperationBy                                          
  ,OperationOn                                          
  )                                          
 VALUES (                                          
  @CompanyID                                         
  ,@EmpID                           
  ,@StaffName                          
  ,@YearID                                          
  ,@YearCode                                          
  ,@Currency                                          
  ,@Type                                    
  ,@Apr_Topline                                          
  ,@Apr_GOP                                          
  ,@May_Topline                                          
  ,@May_GOP                                          
  ,@Jun_Topline                          
  ,@Jun_GOP                                          
  ,@Jul_Topline                                          
  ,@Jul_GOP                                          
  ,@Aug_Topline                                          
  ,@Aug_GOP                                          
  ,@Sep_Topline                                          
  ,@Sep_GOP                                          
  ,@Oct_Topline                                          
  ,@Oct_GOP                                          
  ,@Nov_Topline                                          
  ,@Nov_GOP                                          
  ,@Dec_Topline                                          
  ,@Dec_GOP                                          
  ,@Jan_Topline                                          
  ,@Jan_GOP                                          
  ,@Feb_Topline                                          
  ,@Feb_GOP                                          
  ,@Mar_Topline                                          
  ,@Mar_GOP                                          
  ,'INSERT'                                          
  ,@OperationBy                                
  ,GETDATE()                                          
  )                                          
                          
   SET @EmployeeTargetID = @@IDENTITY                             
  Select  '200' AS ReturnCode, 'New record added successfully.' AS ReturnMessage, @EmployeeTargetID AS ID                                                 
                                     
                                          
 --EXEC usp_InsertEmployeeTargetNew_Log @EmployeeTargetID                                          
 -- ,@CompanyID                                          
 -- ,@StaffName                                          
 -- ,@YearID                                          
 -- ,@YearCode                                          
 -- ,@Currency                                          
 -- ,@Type                                          
 -- ,@Apr_Topline                                          
 -- ,@Apr_GOP                                  
 -- ,@May_Topline                                          
 -- ,@May_GOP                                          
 -- ,@Jun_Topline      
 -- ,@Jun_GOP                                          
 -- ,@Jul_Topline                                          
 -- ,@Jul_GOP                                          
 -- ,@Aug_Topline                                          
 -- ,@Aug_GOP                                          
 -- ,@Sep_Topline                                        
 -- ,@Sep_GOP                                          
 -- ,@Oct_Topline                                         
 -- ,@Oct_GOP                                          
 -- ,@Nov_Topline                                          
 -- ,@Nov_GOP                                          
 -- ,@Dec_Topline                                          
 -- ,@Dec_GOP                                          
 -- ,@Jan_Topline                                          
 -- ,@Jan_GOP                                          
 -- ,@Feb_Topline                                          
 -- ,@Feb_GOP                                          
 -- ,@Mar_Topline                                   
 -- ,@Mar_GOP                                          
 -- ,@OperationBy                                          
END        END                                          
ELSE IF @Action='U'                                          
BEGIN                                          
 UPDATE EmployeeTargetNew              
 SET CompanyID = @CompanyID                                          
  ,EmpID = @EmpID                            
  ,StaffName = @StaffName                          
  ,YearID = @YearID                                          
  ,YearCode = @YearCode                                          
  ,CurrencyCode = @Currency                                          
  ,Type = @Type                 
  ,Apr_Topline = @Apr_Topline                                          
  ,Apr_GOP = @Apr_GOP                                          
  ,May_Topline = @May_Topline                                          
  ,May_GOP = @May_GOP                                          
  ,Jun_Topline = @Jun_Topline                                          
  ,Jun_GOP = @Jun_GOP                                          
  ,Jul_Topline = @Jul_Topline                                          
  ,Jul_GOP = @Jul_GOP                                          
  ,Aug_Topline = @Aug_Topline                                          
  ,Aug_GOP = @Aug_GOP                                          
  ,Sep_Topline = @Sep_Topline                                          
  ,Sep_GOP = @Sep_GOP                                          
  ,Oct_Topline = @Oct_Topline                                          
  ,Oct_GOP = @Oct_GOP                                          
  ,Nov_Topline = @Nov_Topline      ,Nov_GOP = @Nov_GOP                                          
  ,Dec_Topline = @Dec_Topline                                          
  ,Dec_GOP = @Dec_GOP                                          
  ,Jan_Topline = @Jan_Topline                                          
  ,Jan_GOP = @Jan_GOP                                          
  ,Feb_Topline = Feb_Topline                                          
  ,Feb_GOP = @Feb_GOP                                          
  ,Mar_Topline = @Mar_Topline                                          
  ,Mar_GOP = @Mar_GOP                                          
  ,Operation = 'UPDATE'                                          
  ,UpdatedBy = @UpdatedBy                                          
  ,UpdatedOn = GETDATE()                                          
 WHERE ID = @EmployeeTargetID                                          
                                          
  Select  '200' AS ReturnCode, 'Record updated successfully.' AS ReturnMessage, @EmployeeTargetID as ID                                                
                                     
 --EXEC usp_UpdateEmployeeTargetNew_Log @EmployeeTargetID                                          
 -- ,@CompanyID                                          
 -- ,@StaffName                                          
 -- ,@YearID                                          
 -- ,@YearCode                                          
 -- ,@Currency                                          
 -- ,@Type                                          
 -- ,@Apr_Topline                                          
 -- ,@Apr_GOP                                          
 -- ,@May_Topline                                          
 -- ,@May_GOP                                          
 -- ,@Jun_Topline                                          
 -- ,@Jun_GOP                                          
 -- ,@Jul_Topline                                          
 -- ,@Jul_GOP                                          
 -- ,@Aug_Topline                                          
 -- ,@Aug_GOP                                          
 -- ,@Sep_Topline                                          
 -- ,@Sep_GOP                                          
 -- ,@Oct_Topline                                          
 -- ,@Oct_GOP                                          
 -- ,@Nov_Topline                            
 -- ,@Nov_GOP                                          
 -- ,@Dec_Topline                                          
 -- ,@Dec_GOP                                          
 -- ,@Jan_Topline                                          
 -- ,@Jan_GOP                                          
 -- ,@Feb_Topline                                          
 -- ,@Feb_GOP                                          
 -- ,@Mar_Topline                                          
 -- ,@Mar_GOP                        
 -- ,@UpdatedBy                                          
END   

ELSE IF @Action = 'S'
BEGIN
    -- Drop temp table if exists
    IF OBJECT_ID('tempdb..#TempEmployeeTarget') IS NOT NULL
        DROP TABLE #TempEmployeeTarget;

    -- Insert paginated data into a temp table using ROW_NUMBER()
    SELECT *
    INTO #TempEmployeeTarget
    FROM (
        SELECT 
            ROW_NUMBER() OVER (ORDER BY ETN.ID DESC) AS RowNum,
            ETN.ID, 
            Apr_Topline, Apr_GOP,        
            ETN.EmpID, May_Topline, May_GOP, Jun_Topline, Jun_GOP, Jul_Topline, Jul_GOP,
            Aug_Topline, Aug_GOP, Sep_Topline, Sep_GOP, Oct_Topline, Oct_GOP,
            Nov_Topline, Nov_GOP, Dec_Topline, Dec_GOP, Jan_Topline, Jan_GOP,
            Feb_Topline, Feb_GOP, Mar_Topline, Mar_GOP,
            ETN.ID AS EmployeeTargetID,
            ETN.CompanyID,
            StaffName,
            ETN.YearID,
            ETN.YearCode,
            CM.Name AS Currency,
            CM.Name AS CurrencyCode,
            CM.ID AS CurrencyID,
            Type,
            EM.UserIDN AS USERID,
            YM.FiscalYear
        FROM EmployeeTargetNew ETN
        LEFT JOIN EmployeeMaster EM ON EM.EmpID = ETN.EmpID
        LEFT JOIN CurrencyMaster CM ON CM.ID = ETN.CurrencyCode
        LEFT JOIN YearMaster YM ON YM.YearID = ETN.YearID
        WHERE (
            @EmployeeTargetID IS NULL
            OR @EmployeeTargetID = 0
            OR ETN.ID = @EmployeeTargetID
        )
    ) AS RowConstrainedResult;

    -- Get total record count
    SELECT @TotalRecordCount = COUNT(*) FROM #TempEmployeeTarget;

    -- Handle default row count
    IF @Row_Count = '' OR @Row_Count = -1
    BEGIN
        SET @Row_Count = @TotalRecordCount;
    END;

    -- Construct and execute paginated query
    SET @SQL = '
        SELECT * FROM #TempEmployeeTarget
        ORDER BY RowNum
        OFFSET ' + CAST(@PageNumber * @Row_Count AS VARCHAR(20)) + ' ROWS
        FETCH NEXT ' + CAST(@Row_Count AS VARCHAR(20)) + ' ROWS ONLY';

    EXEC sp_executesql @SQL;

    -- Return metadata
    SELECT CAST(@TotalRecordCount AS VARCHAR(20)) AS Row_Count,
           '200' AS returnCode,
           'Data Found' AS returnMessage;
END

                                          
--ELSE IF @Action='S'                                          
--BEGIN             
----IF @PageNumber IS NULL OR @PageNumber < 1
----        SET @PageNumber = 1
        
----    IF @PageSize IS NULL OR @PageSize < 1
----        SET @PageSize = 10  
-- SELECT ETN.ID, Apr_Topline,Apr_GOP,                                
-- ETN.EmpID,May_Topline,May_GOP,Jun_Topline,Jun_GOP,Jul_Topline,Jul_GOP,Aug_Topline          
-- ,Aug_GOP,Sep_Topline,Sep_GOP,Oct_Topline,Oct_GOP,Nov_Topline,Nov_GOP,Dec_Topline          
-- ,Dec_GOP,Jan_Topline,Jan_GOP,Feb_Topline,Feb_GOP,Mar_Topline,Mar_GOP          
-- ,ETN.ID AS EmployeeTargetID                      
--  ,ETN.CompanyID                      
--  ,StaffName              
                
--  ,ETN.YearID                      
--  ,ETN.YearCode                      
--  ,CM.Name  as Currency,         
--    CM.Name  as currencyCode,      
--  CM.id as CurrencyID                  
--  ,Type                      
-- -- ,ENTOperationBy                                
--  ,EM.UserIDN AS USERID ,                
--  YM.FiscalYear                
--  from EmployeeTargetNew  ETN                      
--  left  JOIN EmployeeMaster EM ON EM.EmpID=ETN.EmpID                      
--  left join CurrencyMaster CM ON CM.id = ETN.CurrencyCode                  
--  left JOIN YearMaster YM ON YM.YearID = ETN.YearID                
--  WHERE (                          
--    @EmployeeTargetID IS NULL                          
--    OR @EmployeeTargetID = 0                          
--    OR ETN.ID = @EmployeeTargetID                        
                        
--    )  
	
----ORDER BY etn.id DESC  
----    OFFSET (@PageNumber - 1) * @PageSize ROWS
----    FETCH NEXT @PageSize ROWS ONLY; --WHERE 1 = 2                                          
                                           
--END                                          
                                          
--ELSE IF @Action='EX'                                          
--BEGIN                                          
-- SELECT  Apr_Topline,Apr_GOP                                
--,May_Topline,May_GOP,Jun_Topline,Jun_GOP,Jul_Topline,Jul_GOP,Aug_Topline          
-- ,Aug_GOP,Sep_Topline,Sep_GOP,Oct_Topline,Oct_GOP,Nov_Topline,Nov_GOP,Dec_Topline          
-- ,Dec_GOP,Jan_Topline,Jan_GOP,Feb_Topline,Feb_GOP,Mar_Topline,Mar_GOP                      
--  ,StaffName              
                              
--  ,ETN.YearCode                      
--  ,CM.Name  as Currency,         
--    CM.Name  as currencyCode,               
--  Type             ,         
-- -- ,ENTOperationBy                      
--  YM.FiscalYear                
--  from EmployeeTargetNew  ETN                      
--  left  JOIN EmployeeMaster EM ON EM.EmpID=ETN.EmpID                      
--  left join CurrencyMaster CM ON CM.id = ETN.CurrencyCode                  
--  left JOIN YearMaster YM ON YM.YearID = ETN.YearID                
--  WHERE (                          
--    @EmployeeTargetID IS NULL                          
--    OR @EmployeeTargetID = 0                          
--    OR ETN.ID = @EmployeeTargetID                        
                        
--    )                          
-- ORDER BY etn.id DESC                        
-- --WHERE 1 = 2                                          
                                           
--END                                                
END 