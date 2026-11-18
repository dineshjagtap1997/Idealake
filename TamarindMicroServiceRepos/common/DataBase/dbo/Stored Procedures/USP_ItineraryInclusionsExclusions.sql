<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[USP_ItineraryInclusionsExclusions] @ID INT = 0
	,@Country_IATACode VARCHAR(5) = ''
	,@City_IATACode VARCHAR(5) = ''
	,@Type VARCHAR(20) = ''
	,@Header VARCHAR(200) = ''
	,@Description VARCHAR(MAX) = ''
	,@IsActive BIT = ''
	,@IsDefault BIT = ''
	,@SeqNo VARCHAR(MAX) = ''
	,@OperationBy UNIQUEIDENTIFIER = NULL
	,@Action CHAR(2) = ''
AS
BEGIN
	IF @Action = 'I'
	BEGIN
		DECLARE @new_identity INT

		BEGIN
			IF EXISTS (
					SELECT ID
					FROM ItineraryInclusionsExclusions
					WHERE UPPER(Type) = UPPER(@Type)
						AND (
							@SeqNo IS NOT NULL
							AND @SeqNo <> ''
							AND SeqNo = @SeqNo
							)
					)
			BEGIN
				SELECT '201' AS ReturnCode
					,'Type already exists. Please check and try again.' AS ReturnMessage
			END
			ELSE
			BEGIN
				INSERT INTO ItineraryInclusionsExclusions (
					Country_IATACode
					,City_IATACode
					,Type
					,Header
					,Description
					,IsActive
					,IsDefault
					,SeqNo
					,Operation
					,OperationBy
					,OperationOn
					)
				VALUES (
					@Country_IATACode
					,@City_IATACode
					,@Type
					,@Header
					,@Description
					,@IsActive
					,@IsDefault
					,@SeqNo
					,'INSERT'
					,@OperationBy
					,GETDATE()
					)

				SET @new_identity = SCOPE_IDENTITY()

				SELECT '200' AS ReturnCode
					,'New record added successfully.' AS ReturnMessage
					,@new_identity AS ID
			END
		END
	END
	ELSE IF @Action = 'U'
	BEGIN
		IF NOT EXISTS (
				SELECT ID
				FROM ItineraryInclusionsExclusions
				WHERE ID = @ID
				)
		BEGIN
			SELECT '404' AS ReturnCode
				,'Record not found to update.' AS ReturnMessage
		END
		ELSE
		BEGIN
			UPDATE ItineraryInclusionsExclusions
			SET Country_IATACode = @Country_IATACode
				,City_IATACode = @City_IATACode
				,Type = @Type
				,Header = @Header
				,Description = @Description
				,IsActive = @IsActive
				,IsDefault = @IsDefault
				,SeqNo = @SeqNo
				,Operation = 'UPDATE'
				,OperationBy = @OperationBy
				,OperationOn = GETDATE()
			WHERE ID = @ID

			SELECT '200' AS ReturnCode
				,'Record updated successfully.' AS ReturnMessage
				,@ID AS ID
		END
	END
	ELSE IF @Action = 'S'
	BEGIN
		SELECT IIE.ID
			,CR.Name AS 'CountryName'
			,CASE 
				WHEN IIE.City_IATACODE = '1'
					THEN 'AllCities'
				ELSE C.Name
				END AS 'CityName'
			,IIE.Type
			,IIE.Header
			,IIE.Description
			,IIE.IsActive
			,IIE.Country_IATACode
			,IIE.City_IATACode
			,IIE.IsDefault
			,IIE.SeqNo
		FROM ItineraryInclusionsExclusions IIE
		LEFT JOIN Country CR ON IIE.Country_IATACode = CR.IATACode
		LEFT JOIN City C ON IIE.City_IATACode = C.IATACode
		WHERE (
				@ID IS NULL
				OR @ID = 0
				)
			OR IIE.ID = @ID
			AND (
				@Country_IATACode IS NULL
				OR @Country_IATACode = ''
				OR CR.IATACode LIKE '%' + @Country_IATACode + '%'
				)
		ORDER BY IIE.OperationOn DESC
	END

	--ELSE IF @Action = 'EX'
	--BEGIN
	--	SELECT CR.Name AS 'CountryName'
	--		,CASE 
	--			WHEN IIE.City_IATACODE = '1'
	--				THEN 'AllCities'
	--			ELSE C.Name
	--			END AS 'CityName'
	--		--,IIE.Type
	--		,IIE.Header
	--		,IIE.Description
	--		,CASE
	--			WHEN IIE.IsActive = 1 THEN 'True'
	--			WHEN IIE.IsActive = 0 THEN 'False'
	--			END AS IsActive
	--		,IIE.Country_IATACode
	--		,IIE.City_IATACode
	--		,CASE
	--			WHEN IIE.IsDefault = 1 THEN 'Yes'
	--			WHEN IIE.IsDefault = 0 THEN 'No'
	--			END AS IsDefault
	--		,IIE.SeqNo
	--	FROM ItineraryInclusionsExclusions IIE
	--	LEFT JOIN Country CR ON IIE.Country_IATACode = CR.IATACode
	--	LEFT JOIN City C ON IIE.City_IATACode = C.IATACode
	--	WHERE (
	--			@ID IS NULL
	--			OR @ID = 0
	--			)
	--		OR IIE.ID = @ID
	--		AND (
	--			@Country_IATACode IS NULL
	--			OR @Country_IATACode = ''
	--			OR CR.IATACode LIKE '%' + @Country_IATACode + '%'
	--			)
	--	ORDER BY IIE.OperationOn DESC
	--END
	ELSE IF @Action = 'EX'
BEGIN
	SELECT 
		CR.Name AS CountryName,
		CASE 
			WHEN IIE.City_IATACODE = '1' THEN 'AllCities'
			ELSE C.Name
		END AS CityName,
		IIE.Header,
		IIE.Description,
		IIE.IsActive,           -- BIT
		IIE.Country_IATACode,
		IIE.City_IATACode,
		IIE.IsDefault,          -- BIT
		IIE.SeqNo
	FROM ItineraryInclusionsExclusions IIE
	LEFT JOIN Country CR ON IIE.Country_IATACode = CR.IATACode
	LEFT JOIN City C ON IIE.City_IATACode = C.IATACode
	WHERE (
			@ID IS NULL OR @ID = 0
		)
		OR IIE.ID = @ID
		AND (
			@Country_IATACode IS NULL
			OR @Country_IATACode = ''
			OR CR.IATACode LIKE '%' + @Country_IATACode + '%'
		)
	ORDER BY IIE.OperationOn DESC
END

=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿CREATE PROCEDURE [dbo].[USP_ItineraryInclusionsExclusions] @ID INT = 0  
 ,@Country_IATACode VARCHAR(5) = ''  
 ,@City_IATACode VARCHAR(5) = ''  
 ,@Type VARCHAR(20) = ''  
 ,@Header VARCHAR(200) = ''  
 ,@Description VARCHAR(MAX) = ''  
 ,@IsActive BIT = NULL
 ,@IsDefault BIT = NULL  
 ,@SeqNo VARCHAR(MAX) = ''  
 ,@OperationBy UNIQUEIDENTIFIER = NULL  
 ,@Action CHAR(2) = ''  
AS  
BEGIN  
 IF @Action = 'I'  
 BEGIN  
  DECLARE @new_identity INT  
  
  BEGIN  
   IF EXISTS (  
     SELECT ID  
     FROM ItineraryInclusionsExclusions  
     WHERE UPPER(Type) = UPPER(@Type)  
      AND (  
       @SeqNo IS NOT NULL  
       AND @SeqNo <> ''  
       AND SeqNo = @SeqNo  
       )  
     )  
   BEGIN  
    SELECT '201' AS ReturnCode  
     ,'Type already exists. Please check and try again.' AS ReturnMessage  
   END  
   ELSE  
   BEGIN  
    INSERT INTO ItineraryInclusionsExclusions (  
     Country_IATACode  
     ,City_IATACode  
     ,Type  
     ,Header  
     ,Description  
     ,IsActive  
     ,IsDefault  
     ,SeqNo  
     ,Operation  
     ,OperationBy  
     ,OperationOn  
     )  
    VALUES (  
     @Country_IATACode  
     ,@City_IATACode  
     ,@Type  
     ,@Header  
     ,@Description  
     ,@IsActive  
     ,@IsDefault  
     ,@SeqNo  
     ,'INSERT'  
     ,@OperationBy  
     ,GETDATE()  
     )  
  
    SET @new_identity = SCOPE_IDENTITY()  
  
    SELECT '200' AS ReturnCode  
     ,'New record added successfully.' AS ReturnMessage  
     ,@new_identity AS ID  
   END  
  END  
 END  
 ELSE IF @Action = 'U'  
 BEGIN  
  IF NOT EXISTS (  
    SELECT ID  
    FROM ItineraryInclusionsExclusions  
    WHERE ID = @ID  
    )  
  BEGIN  
   SELECT '404' AS ReturnCode  
    ,'Record not found to update.' AS ReturnMessage  
  END  
  ELSE  
  BEGIN  
   UPDATE ItineraryInclusionsExclusions  
   SET Country_IATACode = @Country_IATACode  
    ,City_IATACode = @City_IATACode  
    ,Type = @Type  
    ,Header = @Header  
    ,Description = @Description  
    ,IsActive = @IsActive  
    ,IsDefault = @IsDefault  
    ,SeqNo = @SeqNo  
    ,Operation = 'UPDATE'  
    ,OperationBy = @OperationBy  
    ,OperationOn = GETDATE()  
   WHERE ID = @ID  
  
   SELECT '200' AS ReturnCode  
    ,'Record updated successfully.' AS ReturnMessage  
    ,@ID AS ID  
  END  
 END  
 ELSE IF @Action = 'S'  
 BEGIN  
  SELECT IIE.ID  
   ,CR.Name AS 'CountryName'  
   ,CASE   
    WHEN IIE.City_IATACODE = '1'  
     THEN 'AllCities'  
    ELSE C.Name  
    END AS 'CityName'  
   ,IIE.Type  
   ,IIE.Header  
   ,IIE.Description  
   ,IIE.IsActive  
   ,IIE.Country_IATACode  
   ,IIE.City_IATACode  
   ,IIE.IsDefault  
   ,IIE.SeqNo  
  FROM ItineraryInclusionsExclusions IIE  
  LEFT JOIN Country CR ON IIE.Country_IATACode = CR.IATACode  
  LEFT JOIN City C ON IIE.City_IATACode = C.IATACode  
  WHERE (@ID IS NULL OR @ID = 0 OR IIE.ID = @ID)  
  AND (@Country_IATACode IS NULL OR @Country_IATACode = '' OR CR.IATACode LIKE '%' + @Country_IATACode + '%')  
  AND (@City_IATACode IS NULL OR @City_IATACode = '' OR IIE.City_IATACode LIKE '%' + @City_IATACode + '%')  
  AND (@Type IS NULL OR @Type = '' OR IIE.Type LIKE '%' + @Type + '%')  
  AND (@Header IS NULL OR @Header = '' OR IIE.Header LIKE '%' + @Header + '%')  
  AND (@Description IS NULL OR @Description = '' OR IIE.Description LIKE '%' + @Description + '%')  
  AND (@IsDefault IS NULL OR IIE.IsDefault = @IsDefault)  
  AND (@IsActive IS NULL OR IIE.IsActive = @IsActive)  
  AND (@SeqNo IS NULL OR @SeqNo = '' OR IIE.SeqNo = @SeqNo)  
  
  ORDER BY IIE.OperationOn DESC  
 END  
  
  ELSE IF @Action = 'EX'  
BEGIN  
 SELECT   
  CR.Name AS CountryName,  
  CASE   
   WHEN IIE.City_IATACODE = '1' THEN 'AllCities'  
   ELSE C.Name  
  END AS CityName,  
  IIE.Header,  
  IIE.Description,  
  IIE.IsActive,           -- BIT  
  IIE.Country_IATACode,  
  IIE.City_IATACode,  
  IIE.IsDefault,          -- BIT  
  IIE.SeqNo  
 FROM ItineraryInclusionsExclusions IIE  
 LEFT JOIN Country CR ON IIE.Country_IATACode = CR.IATACode  
 LEFT JOIN City C ON IIE.City_IATACode = C.IATACode  
 WHERE (@ID IS NULL OR @ID = 0 OR IIE.ID = @ID)  
  AND (@Country_IATACode IS NULL OR @Country_IATACode = '' OR CR.IATACode LIKE '%' + @Country_IATACode + '%')  
  AND (@City_IATACode IS NULL OR @City_IATACode = '' OR IIE.City_IATACode LIKE '%' + @City_IATACode + '%')  
  AND (@Type IS NULL OR @Type = '' OR IIE.Type LIKE '%' + @Type + '%')  
  AND (@Header IS NULL OR @Header = '' OR IIE.Header LIKE '%' + @Header + '%')  
  AND (@Description IS NULL OR @Description = '' OR IIE.Description LIKE '%' + @Description + '%')  
  AND (@IsDefault IS NULL OR IIE.IsDefault = @IsDefault)  
  AND (@IsActive IS NULL OR IIE.IsActive = @IsActive)  
  AND (@SeqNo IS NULL OR @SeqNo = '' OR IIE.SeqNo = @SeqNo)  
  
 ORDER BY IIE.OperationOn DESC  
END  
  
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END