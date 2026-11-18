<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_fetchHotelCity]      
    @Name NVARCHAR(100) = NULL,      
    @Action CHAR(2) = NULL      
AS      
BEGIN      
    SET NOCOUNT ON;  
  
    IF (@Action = 'S' AND ISNULL(@Name, '') <> '')      
    BEGIN      
        DECLARE @HotelSearch NVARCHAR(100) = NULL,  
                @CitySearch NVARCHAR(100) = NULL;  
  
        IF CHARINDEX(',', @Name) > 0  
        BEGIN  
            -- Split into two parts by comma  
            SET @HotelSearch = LTRIM(RTRIM(SUBSTRING(@Name, 1, CHARINDEX(',', @Name) - 1)));  
            SET @CitySearch = LTRIM(RTRIM(SUBSTRING(@Name, CHARINDEX(',', @Name) + 1, LEN(@Name))));  
              
            -- Both conditions must be true (AND)  
            SELECT      
                CONVERT(VARCHAR, HM.HotelID) AS ID, 
				C.IATACode AS CityCode,    
				C.Name As CityName,
                ISNULL(HM.HotelName, '') + ', ' + ISNULL(C.Name, '') AS Name      
            FROM      
                HotelMaster HM       
                LEFT OUTER JOIN City C ON HM.CityIATACode = C.IATACode      
            WHERE      
                HM.HotelName LIKE @HotelSearch + '%'  
                AND C.Name LIKE @CitySearch + '%';  
        END  
        ELSE  
        BEGIN  
            -- Single term: filter where either hotel OR city starts with the term (OR)  
            SET @HotelSearch = @Name;  
  
            SELECT      
               CONVERT(VARCHAR, HM.HotelID) AS ID, 
				C.IATACode AS CityCode,  
				C.Name As CityName,
                ISNULL(HM.HotelName, '') + ', ' + ISNULL(C.Name, '') AS Name      
            FROM      
                HotelMaster HM       
                LEFT OUTER JOIN City C ON HM.CityIATACode = C.IATACode      
            WHERE      
                HM.HotelName LIKE @HotelSearch + '%'  
                OR C.Name LIKE @HotelSearch + '%';  
        END  
    END      
END;  
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿CREATE PROCEDURE [dbo].[usp_fetchHotelCity] 
    @Name NVARCHAR(100) = NULL,
    @Action CHAR(2) = 'S'
AS
BEGIN
    SET NOCOUNT ON;

    IF @Action = 'S' AND ISNULL(@Name, '') <> ''
    BEGIN
        -- Normalize input
        SET @Name = LTRIM(RTRIM(@Name));

        SELECT 
            CONVERT(VARCHAR, HM.HotelID) AS ID,
            C.IATACode AS CityCode,
            C.Name AS CityName,
            ISNULL(HM.HotelName, '') + ', ' + ISNULL(C.Name, '') AS Name,
            ISNULL(C.IsActive, 0) AS IsCityActive,
            ISNULL(HM.IsActive, 0) AS IsHotelActive
        FROM HotelMaster HM
        LEFT JOIN City C ON HM.CityIATACode = C.IATACode
        WHERE LOWER(HM.HotelName) LIKE '%' + LOWER(@Name) + '%'
           OR LOWER(C.Name) LIKE '%' + LOWER(@Name) + '%'
        ORDER BY HM.HotelName ASC;
    END
END
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
