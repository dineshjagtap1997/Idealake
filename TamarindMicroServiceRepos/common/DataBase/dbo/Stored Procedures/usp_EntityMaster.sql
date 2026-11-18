<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_EntityMaster] @LegalName VARCHAR(150) = NULL            
=======
﻿

CREATE PROCEDURE [dbo].[usp_EntityMaster] @LegalName VARCHAR(150) = NULL            
>>>>>>> dev
=======
﻿

CREATE PROCEDURE [dbo].[usp_EntityMaster] @LegalName VARCHAR(150) = NULL            
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 ,@RegisteredAddress VARCHAR(150) = NULL            
 ,@CountryOfRegistration VARCHAR(150) = NULL            
 ,@PostalCode VARCHAR(15) = NULL            
 ,@SAPCompCode VARCHAR(4) = NULL            
 ,@CIN VARCHAR(30) = NULL            
 ,@PAN VARCHAR(10) = NULL            
 ,@TAN VARCHAR(10) = NULL            
 ,@VAT VARCHAR(30) = NULL            
 ,@TRN VARCHAR(30) = NULL            
 ,@MSMENo VARCHAR(30) = NULL            
 ,@RegisteredEmail VARCHAR(30) = NULL            
 ,@TwoCharacterCompCode VARCHAR(2) = NULL            
 ,@IsActive BIT = 0            
 ,@OperationBy uniqueidentifier  = NULL            
 ,@ID INT = NULL            
 ,@Action CHAR(2) = ''            
 ,@Active BIT = ''            
          
 ,@Fiscal_ID INT = ''            
 ,@IATA_Code VARCHAR(10) = NULL            
 ,@IATO_Code VARCHAR(10) = NULL            
 ,@TIDS_Code VARCHAR(10) = NULL      
 , @TaxType VARCHAR(30) = NULL
   , @SalesTaxRegNumber VARCHAR(30) = NULL
<<<<<<< HEAD
<<<<<<< HEAD
AS            
BEGIN           
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    ,@Row_Count VARCHAR(max) = '10'              
 ,@PageNumber INT = 0  
AS            
BEGIN 

DECLARE @TotalRecordCount INT              
  ,@SQL NVARCHAR(MAX); 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
      
 Declare @LogID int;       
 IF @Action = 'I'
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM EntityMaster 
        WHERE LegalName = @LegalName 
        AND CountryOfRegistration = @CountryOfRegistration
    )
    BEGIN
        SELECT '201' AS returnCode,
               'A record with the same Legal Name and Country of Registration already exists.' AS returnMessage,
               NULL AS ID;
        RETURN;
    END

    INSERT INTO EntityMaster (
        LegalName,
        RegisteredAddress,
        CountryOfRegistration,
        PostalCode,
        SAPCompCode,
        CIN,
        PAN,
        TAN,
        VAT,
        TRN,
        MSMENo,
        RegisteredEmailID,
        TwoCharacterCompCode,
        IsActive,
        Operation,
        OperationBy,
        OperationOn,
        Fiscal_ID,
        IATA_Code,
        IATO_Code,
        TIDS_Code,
        SalesTaxRegNumber,
        TaxType
    ) VALUES (
        @LegalName,
        @RegisteredAddress,
        @CountryOfRegistration,
        @PostalCode,
        @SAPCompCode,
        @CIN,
        @PAN,
        @TAN,
        @VAT,
        @TRN,
        @MSMENo,
        @RegisteredEmail,
        @TwoCharacterCompCode,
        @IsActive,
        'INSERT',
        @OperationBy,
        GETDATE(),
        @Fiscal_ID,
        @IATA_Code,
        @IATO_Code,
        @TIDS_Code,
        @SalesTaxRegNumber,
        @TaxType
    )

    SET @ID = @@IDENTITY;

    SELECT '200' AS returnCode,
           'New record added successfully.' AS returnMessage,
           @ID AS ID;

 
 END            
 ELSE IF @Action = 'U'            
 BEGIN            
  UPDATE EntityMaster            
  SET LegalName = ISNULL(@LegalName, LegalName)            
   ,RegisteredAddress = @RegisteredAddress            
   ,CountryOfRegistration = @CountryOfRegistration            
   ,PostalCode = @PostalCode            
   ,SAPCompCode = @SAPCompCode            
   ,CIN = @CIN            
   ,PAN = @PAN            
   ,TAN = @TAN            
   ,VAT = @VAT            
   ,TRN = @TRN            
   ,MSMENo = @MSMENo            
   ,RegisteredEmailID = @RegisteredEmail            
   ,TwoCharacterCompCode = @TwoCharacterCompCode            
   ,IsActive = @IsActive            
   ,Operation = 'UPDATE'            
   ,Fiscal_ID = @Fiscal_ID            
   ,IATA_Code = @IATA_Code            
   ,IATO_Code = @IATO_Code            
   ,TIDS_Code = @TIDS_Code  
    ,SalesTaxRegNumber = @SalesTaxRegNumber
    ,TaxType = @TaxType
   ,UpdatedBy = @OperationBy            
   ,UpdatedOn = GETDATE()    
   
  WHERE ID = @ID            
            
  --EXEC usp_UpdateEntityMaster_Log @ID                      
  -- ,@LegalName                      
  -- ,@RegisteredAddress                      
  -- ,@CountryOfRegistration                      
  -- ,@PostalCode                      
  -- ,@SAPCompCode                      
  -- ,@CIN                      
  -- ,@PAN                      
  -- ,@TAN                      
  -- ,@VAT                      
  -- ,@TRN                      
  -- ,@MSMENo                      
  -- ,@RegisteredEmail               
  -- ,@TwoCharacterCompCode                      
  -- ,@IsActive                      
  -- ,@OperationBy                      
  SELECT '200' AS returnCode            
   ,'Record updated successfully.' AS returnMessage, @ID AS ID;            
 END            
<<<<<<< HEAD
<<<<<<< HEAD
 ELSE IF @Action = 'S'            
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 ELSE IF @Action = 'SA'            
 
 BEGIN
    -- Drop temp table if it exists
    IF OBJECT_ID('TEMPDB..#TempEntity') IS NOT NULL
        DROP TABLE #TempEntity

    -- Select data with ROW_NUMBER() for pagination
    SELECT *
    INTO #TempEntity
    FROM (
        SELECT 
            ROW_NUMBER() OVER (ORDER BY ET.ID DESC) AS RowNum,
            ET.ID,
            ET.LegalName,
            ET.RegisteredAddress,
            C.IATACode AS CountryOfRegistration,
            C.Name AS CountryName,
            C.IATACode AS CountryIATACode,
            ET.PostalCode,
            ET.SAPCompCode,
            ET.CIN,
            ET.PAN,
            ET.TAN,
            ET.VAT,
            ET.TRN,
            ET.MSMENo,
            ET.RegisteredEmailID AS RegisteredEmail,
            ET.TwoCharacterCompCode,
            ET.IsActive,
            ET.Operation,
            ET.Fiscal_ID,
            ET.IATA_CODE,
            ET.IATO_CODE,
            ET.TIDS_CODE,
            ET.SalesTaxRegNumber,
            ET.TaxType
        FROM EntityMaster ET
        LEFT JOIN Country C ON ET.CountryOfRegistration = C.IATACode
        LEFT JOIN EmployeeMaster EM ON ET.OperationBy = EM.UserID
        WHERE (
            @ID IS NULL
            OR @ID = 0
            OR ET.ID = @ID
        )
    ) AS RowConstrainedResult

    -- Get total record count
    SELECT @TotalRecordCount = COUNT(*) FROM #TempEntity

    -- Set default row count if empty or -1
    IF @Row_Count = '' OR @Row_Count = -1
    BEGIN
        SET @Row_Count = @TotalRecordCount
    END

    -- Dynamic SQL to fetch paginated data
   
    SET @SQL = '
        SELECT *
        FROM #TempEntity
        ORDER BY RowNum
        OFFSET ' + CAST(@PageNumber * @Row_Count AS VARCHAR(20)) + ' ROWS
        FETCH NEXT ' + CAST(@Row_Count AS VARCHAR(20)) + ' ROWS ONLY'

    EXEC sp_executesql @SQL

    -- Return metadata
    SELECT CAST(@TotalRecordCount AS VARCHAR(20)) AS Row_Count,
           '200' AS returnCode,
           'Data Found' AS returnMessage

    SELECT '200' AS returnCode,
           'Data Found' AS returnMessage


  --SELECT ET.ID            
  -- ,ET.LegalName            
  -- ,ET.RegisteredAddress            
  -- ,C.IATACode AS 'CountryOfRegistration',            
  -- C.Name AS CountryName,      
  -- C.IATACode as CountryIATACode      
  -- ,ET.PostalCode            
  -- ,ET.SAPCompCode            
  -- ,ET.CIN            
  -- ,ET.PAN            
  -- ,ET.TAN            
  -- ,ET.VAT            
  -- ,ET.TRN            
  -- ,ET.MSMENo            
  -- ,ET.RegisteredEmailID AS RegisteredEmail            
  -- ,ET.TwoCharacterCompCode            
  -- ,ET.IsActive            
  -- ,ET.Operation            
  -- --,EM.EmpName AS 'OperationBy'            
  -- ,Fiscal_ID            
  -- ,ET.IATA_CODE                                              
  -- ,ET.IATO_CODE            
  -- ,ET.TIDS_CODE  
  --  ,ET.SalesTaxRegNumber
  -- , ET.TaxType
  --FROM EntityMaster ET            
  --LEFT JOIN Country C ON ET.CountryOfRegistration = C.IATACode            
  --LEFT JOIN EmployeeMaster EM ON ET.OperationBy = EM.UserID            
  --WHERE (            
  --  @ID IS NULL            
  --  OR @ID = 0            
  --  OR @ID = ET.ID          
  --  )            
  --ORDER BY ID DESC            
 END  
 
  ELSE IF @Action = 'S'            
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 BEGIN            
  SELECT ET.ID            
   ,ET.LegalName            
   ,ET.RegisteredAddress            
   ,C.IATACode AS 'CountryOfRegistration',            
   C.Name AS CountryName,      
   C.IATACode as CountryIATACode      
   ,ET.PostalCode            
   ,ET.SAPCompCode            
   ,ET.CIN            
   ,ET.PAN            
   ,ET.TAN            
   ,ET.VAT            
   ,ET.TRN            
   ,ET.MSMENo            
   ,ET.RegisteredEmailID AS RegisteredEmail            
   ,ET.TwoCharacterCompCode            
   ,ET.IsActive            
   ,ET.Operation            
   --,EM.EmpName AS 'OperationBy'            
   ,Fiscal_ID            
   ,ET.IATA_CODE                                              
   ,ET.IATO_CODE            
   ,ET.TIDS_CODE  
    ,ET.SalesTaxRegNumber
   , ET.TaxType
  FROM EntityMaster ET            
  LEFT JOIN Country C ON ET.CountryOfRegistration = C.IATACode            
  LEFT JOIN EmployeeMaster EM ON ET.OperationBy = EM.UserID            
  WHERE (            
    @ID IS NULL            
    OR @ID = 0            
    OR @ID = ET.ID          
    )            
  ORDER BY ID DESC            
 END     
 
<<<<<<< HEAD
<<<<<<< HEAD
=======
 
>>>>>>> dev
=======
 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 ELSE IF @Action = 'EX'            
 BEGIN            
  SELECT ET.LegalName            
   ,ET.RegisteredAddress,                     
   C.Name AS CountryName         
   ,ET.PostalCode            
   ,ET.SAPCompCode            
   ,ET.CIN            
   ,ET.PAN            
   ,ET.TAN            
   ,ET.VAT            
   ,ET.TRN            
   ,ET.MSMENo            
   ,ET.RegisteredEmailID AS RegisteredEmail            
   ,ET.TwoCharacterCompCode  ,
   CASE
		WHEN ET.IsActive = 1 THEN 'True'
		WHEN ET.IsActive = 0 THEN 'False'
		END AS IsActive
   --,EM.EmpName AS 'OperationBy'            
   --,Fiscal_ID            
   ,ET.IATA_CODE                                              
   ,ET.IATO_CODE            
   ,ET.TIDS_CODE            
  FROM EntityMaster ET            
  LEFT JOIN Country C ON ET.CountryOfRegistration = C.IATACode            
  LEFT JOIN EmployeeMaster EM ON ET.OperationBy = EM.UserID            
  WHERE (            
    @ID IS NULL            
    OR @ID = 0            
    OR @ID = ET.ID          
    )            
  ORDER BY ET.ID DESC            
 END      
END 