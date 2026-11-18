<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[USP_ItineraryDescriptionMaster]                               
=======
﻿
CREATE PROCEDURE [dbo].[USP_ItineraryDescriptionMaster]                               
>>>>>>> dev
=======
﻿
CREATE PROCEDURE [dbo].[USP_ItineraryDescriptionMaster]                               
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 @ItineraryDescID INT = NULL,                              
 @ItineraryCode VARCHAR(100) = NULL,                               
 @Country_IATACode VARCHAR(4) = NULL,                              
 @City_IATACode VARCHAR(3) = NULL,                              
 @Header VARCHAR(500) = NULL,                              
 @ShortDescription VARCHAR(MAX) = NULL,                              
 @DetailDescription VARCHAR(MAX) = NULL,                              
 @IsActive BIT = NULL,                              
 @OperationBy UNIQUEIDENTIFIER = NULL,                              
 @City2_IATACode VARCHAR(3) = NULL,                              
 @DetailedHeader VARCHAR(500) = NULL,                              
 @Action CHAR(2) = ''  
 --@PageNumber BIGINT=NULL,  
 --@PageSize INT=NULL  
AS                               
BEGIN    
DECLARE @LogID INT;    
    
IF @Action = 'I'                              
BEGIN    
    DECLARE @CardNoMax INT;    
    
    SELECT @CardNoMax = MAX(CAST(SUBSTRING(ItineraryCode, 2, 10) AS INT))    
    FROM ItineraryDescription;    
    
    SET @CardNoMax = ISNULL(@CardNoMax, 0);    
    
    SET @ItineraryCode = 'I' + REPLICATE('0', 9 - LEN(@CardNoMax + 1)) + CAST(@CardNoMax + 1 AS VARCHAR);    
    
    IF EXISTS (SELECT 1 FROM ItineraryDescription WHERE UPPER(DetailedHeader) = UPPER(@DetailedHeader))    
    BEGIN    
        SELECT '201' AS returnCode, 'Detailed Header already exists. Please check and try again.' AS returnMessage;    
    END    
    ELSE    
    BEGIN    
        INSERT INTO ItineraryDescription (    
            ItineraryCode,    
            Country_IATACode,    
            City_IATACode,    
            City2_IATACode,    
            DetailedHeader,    
            Header,    
            ShortDescription,    
            DetailDescription,    
            IsActive,    
            Operation,    
            OperationBy,    
            OperationOn    
        )    
        VALUES (    
            @ItineraryCode,    
            LTRIM(RTRIM(@Country_IATACode)),    
            LTRIM(RTRIM(@City_IATACode)),    
            LTRIM(RTRIM(@City2_IATACode)),    
            @DetailedHeader,    
            @Header,    
            @ShortDescription,    
            @DetailDescription,    
            @IsActive,    
            'Insert',    
            @OperationBy,    
            GETDATE()    
        );    
    
        SET @ItineraryDescID = SCOPE_IDENTITY();    
    
        SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @ItineraryDescID AS ID;    
    END    
END    
    
ELSE IF @Action = 'U'                              
BEGIN    
<<<<<<< HEAD
<<<<<<< HEAD
    IF EXISTS (    
        SELECT 1 FROM ItineraryDescription     
        WHERE UPPER(Header) = UPPER(@Header) AND ItineraryDescID <> @ItineraryDescID    
    )    
    BEGIN    
        SELECT '201' AS returnCode, 'Header already exists. Please check and try again.' AS returnMessage;    
    END    
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    --IF EXISTS (    
    --    SELECT 1 FROM ItineraryDescription     
    --    WHERE UPPER(Header) = UPPER(@Header) AND ItineraryDescID <> @ItineraryDescID    
    --)    
	IF EXISTS (
    SELECT 1 FROM ItineraryDescription 
    WHERE UPPER(LTRIM(RTRIM(Header))) = UPPER(LTRIM(RTRIM(@Header))) 
      AND ItineraryDescID <> @ItineraryDescID
      AND IsActive = 1  
)
BEGIN    
    SELECT '201' AS returnCode, 'Header already exists. Please check and try again.' AS returnMessage;    
END

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    ELSE    
    BEGIN    
        UPDATE ItineraryDescription    
        SET     
            Header = @Header,    
            ShortDescription = @ShortDescription,    
            DetailDescription = @DetailDescription,    
            IsActive = @IsActive,    
            Operation = 'Update',    
            OperationBy = @OperationBy,    
            OperationOn = GETDATE(),    
            Country_IATACode = LTRIM(RTRIM(@Country_IATACode)),    
            City_IATACode = LTRIM(RTRIM(@City_IATACode)),    
            City2_IATACode = LTRIM(RTRIM(@City2_IATACode))    
        WHERE ItineraryDescID = @ItineraryDescID;    
    
        SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @ItineraryDescID AS ID;    
    END    
END    
    
ELSE IF @Action = 'S'    
BEGIN    
    --SELECT    
    --    ID.ItineraryDescID,    
    --    ID.ItineraryCode,    
    --    ID.Header,    
    --    CASE WHEN ID.IsActive = 1 THEN 'True' ELSE 'False' END AS IsActive,    
    --    ID.ShortDescription,    
    --    C.Name AS CountryName,    
    --    CT.Name AS CityName,    
    --    CT2.Name AS City2Name,    
    --    ID.DetailDescription,    
    --    ID.OperationOn AS OperationDate    
    --FROM ItineraryDescription ID    
    --LEFT JOIN Country C ON C.IATACode = ID.Country_IATACode    
    --LEFT JOIN City CT ON CT.IATACode = ID.City_IATACode    
    --LEFT JOIN City CT2 ON CT2.IATACode = ID.City2_IATACode    
  SELECT    
        ID.ItineraryDescID,    
        ID.ItineraryCode,    
        ID.Header,    
        CASE WHEN ID.IsActive = 1 THEN 'True' ELSE 'False' END AS IsActive,    
        ID.ShortDescription,    
        C.Name AS CountryName,    
        CT.Name AS CityName,    
        CT2.Name AS City2Name,    
  CT2.IATACode AS City2_IATACode,    
  CT.IATACode AS City_IATACode,    
  C.IATACode AS Country_IATACode,    
        ID.DetailDescription,    
        ID.OperationOn AS OperationDate    
    FROM ItineraryDescription ID    
    LEFT JOIN Country C ON C.IATACode = ID.Country_IATACode    
    LEFT JOIN City CT ON CT.IATACode = ID.City_IATACode    
    LEFT JOIN City CT2 ON CT2.IATACode = ID.City2_IATACode    
    WHERE (@ItineraryDescID IS NULL OR @ItineraryDescID = 0 OR ID.ItineraryDescID = @ItineraryDescID)    
      AND (@Country_IATACode IS NULL OR @Country_IATACode = '' OR C.IATACode LIKE '%' + LTRIM(RTRIM(@Country_IATACode)) + '%')    
    ORDER BY ID.ItineraryDescID DESC  
   -- OFFSET (@PageNumber - 1) * @PageSize ROWS     FETCH NEXT @PageSize ROWS ONLY;  
END    
    
ELSE IF @Action = 'EX'    
BEGIN    
    SELECT    
        ID.ItineraryDescID,    
        ID.ItineraryCode,    
        ID.Header,    
        CASE WHEN ID.IsActive = 1 THEN 'True' ELSE 'False' END AS IsActive,    
        ID.ShortDescription,    
        ID.Country_IATACode,    
        C.Name AS CountryName,    
        ID.City2_IATACode,    
        CT2.Name AS City2Name,    
        ID.City_IATACode,    
        CT.Name AS CityName,    
        ID.DetailDescription,    
        ID.OperationOn AS OperationDate    
    FROM ItineraryDescription ID    
    LEFT JOIN Country C ON C.IATACode = ID.Country_IATACode    
    LEFT JOIN City CT ON CT.IATACode = ID.City_IATACode    
    LEFT JOIN City CT2 ON CT2.IATACode = ID.City2_IATACode    
    WHERE (@ItineraryDescID IS NULL OR @ItineraryDescID = 0 OR ID.ItineraryDescID = @ItineraryDescID)    
      AND (@Country_IATACode IS NULL OR @Country_IATACode = '' OR C.IATACode LIKE '%' + LTRIM(RTRIM(@Country_IATACode)) + '%')    
    ORDER BY ID.ItineraryDescID DESC;    
END    
    
END    