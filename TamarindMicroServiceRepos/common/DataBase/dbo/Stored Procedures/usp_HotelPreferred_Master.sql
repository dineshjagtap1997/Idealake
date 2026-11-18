ALTER PROCEDURE [dbo].[usp_HotelPreferred_Master] (              
 @HotelID INT              
 ,@ValidFrom DATETIME              
 ,@ValidTo DATETIME              
 ,@IsPreferred BIT              
 ,@OperationBy UNIQUEIDENTIFIER              
 ,              
 -- @ErrMsg VARCHAR(50) OUT                  
 @Action CHAR(2) = ''              
 ,@PreferredHotelID INT = ''              
 )              
AS              
BEGIN              
 IF @Action = 'I'              
 BEGIN              
  IF EXISTS (              
    SELECT PreferredHotelID              
    FROM HotelPreferred              
    WHERE HotelID = @HotelID              
     AND CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112) BETWEEN CONVERT(VARCHAR, ValidFrom, 112)              
      AND CONVERT(VARCHAR, ValidTo, 112)              
    )              
  BEGIN              
   SELECT '201' AS returnCode              
    ,'Valid peroid already exists for this hotel. Please check and try again.' AS returnMessage;              
  END              
  ELSE              
  BEGIN              
   INSERT INTO HotelPreferred (              
    HotelID              
    ,ValidFrom              
    ,ValidTo              
    ,IsPreferred              
    ,Operation              
    ,OperationBy              
    ,OperationOn              
    )              
   VALUES (              
    @HotelID              
    ,@ValidFrom              
    ,@ValidTo              
    ,@IsPreferred              
    ,'Insert'              
    ,@OperationBy              
    ,GETDATE()              
    )              
              
  SET @PreferredHotelID = SCOPE_IDENTITY()        
   SELECT '200' AS returnCode              
    ,'New record added successfully.' AS returnMessage, @PreferredHotelID AS ID;              
  END              
 END              
 ELSE IF @Action = 'U'              
 BEGIN              
  IF EXISTS (              
    SELECT PreferredHotelID              
    FROM HotelPreferred              
    WHERE HotelID = @HotelID              
     AND CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112) BETWEEN CONVERT(VARCHAR, ValidFrom, 112)              
      AND CONVERT(VARCHAR, ValidTo, 112)              
     AND PreferredHotelID <> @PreferredHotelID              
    )              
  BEGIN              
   SELECT '201' AS returnCode              
    ,'Valid peroid already exists for this hotel. Please check and try again.' AS returnMessage;              
  END              
  ELSE              
  BEGIN              
   UPDATE HotelPreferred              
   SET HotelID = @HotelID              
    ,ValidFrom = @ValidFrom              
    ,ValidTo = @ValidTo              
    ,IsPreferred = @IsPreferred              
    ,Operation = 'Update'              
    ,UpdatedBy = @OperationBy              
    ,UpdatedOn = GETDATE()              
   WHERE PreferredHotelID = @PreferredHotelID              
              
   SELECT '200' AS returnCode              
    ,'Record updated successfully.' AS returnMessage, @PreferredHotelID AS  ID;              
  END              
 END              
 ELSE IF @Action = 'S'              
 BEGIN              
  SELECT PreferredHotelID              
   ,HotelPreferred.HotelID              
   ,ValidFrom              
   ,ValidTo              
   ,IsPreferred              
   ,HotelName              
   ,HotelMaster.CityIATACode AS CityCode              
   ,City.Name AS CityName              
 --  ,HotelRating.Code AS Rating              
  FROM HotelPreferred              
  INNER JOIN HotelMaster ON HotelMaster.HotelID = HotelPreferred.HotelID              
  INNER JOIN City ON City.IATACode = HotelMaster.CityIATACode              
--  LEFT JOIN HotelRating ON HotelRating.ID = HotelMaster.HotelRatingID              
 
	WHERE (
    (@PreferredHotelID IS NULL OR @PreferredHotelID = 0 OR PreferredHotelID = @PreferredHotelID)
    AND HotelMaster.IsActive = 1
)

 ORDER BY PreferredHotelID DESC        
              
           
 END   
-- ELSE IF @Action='EX'
-- BEGIN
-- SELECT               
-- ValidFrom              
--   ,ValidTo              
--  , CASE   
--        WHEN IsPreferred = 1 THEN 'Yes'  
--        WHEN IsPreferred = 0 THEN 'No'  
--    END AS IsPreferred               
--   ,HotelName              
--   ,HotelMaster.CityIATACode AS CityCode              
--   ,City.Name AS CityName              
-- --  ,HotelRating.Code AS Rating              
--  FROM HotelPreferred              
--  INNER JOIN HotelMaster ON HotelMaster.HotelID = HotelPreferred.HotelID              
--  INNER JOIN City ON City.IATACode = HotelMaster.CityIATACode              
----  LEFT JOIN HotelRating ON HotelRating.ID = HotelMaster.HotelRatingID              
-- WHERE (
--    (@PreferredHotelID IS NULL OR @PreferredHotelID = 0 OR PreferredHotelID = @PreferredHotelID)
--    AND HotelMaster.IsActive = 1
--)
    
-- ORDER BY PreferredHotelID DESC 
-- END
ELSE IF @Action='EX'
BEGIN 
    SELECT 
       PreferredHotelID,              
       HotelPreferred.HotelID,  
       ValidFrom,              
       ValidTo,              
       IsPreferred,  
       HotelName,              
       HotelMaster.CityIATACode AS CityCode,              
       City.Name AS CityName              
    FROM HotelPreferred              
    LEFT JOIN HotelMaster ON HotelMaster.HotelID = HotelPreferred.HotelID              
    LEFT JOIN City ON City.IATACode = HotelMaster.CityIATACode
    WHERE 
       HotelMaster.IsActive = 1 AND 
       City.IsActive = 1
    ORDER BY PreferredHotelID DESC 
END

 ELSE IF @Action = 'F'              
 BEGIN              
  SELECT PreferredHotelID              
   ,HotelPreferred.HotelID              
   ,ValidFrom              
   ,ValidTo              
   ,IsPreferred              
   ,HotelName              
   ,HotelMaster.CityIATACode AS CityCode              
   ,City.Name AS CityName              
 --  ,HotelRating.Code AS Rating              
  FROM HotelPreferred              
  INNER JOIN HotelMaster ON HotelMaster.HotelID = HotelPreferred.HotelID              
  INNER JOIN City ON City.IATACode = HotelMaster.CityIATACode              
--  LEFT JOIN HotelRating ON HotelRating.ID = HotelMaster.HotelRatingID              
WHERE (
    (@PreferredHotelID IS NULL OR @PreferredHotelID = 0 OR PreferredHotelID = @PreferredHotelID)
    AND HotelMaster.IsActive = 1
)
        
 ORDER BY PreferredHotelID DESC        
              
END

ELSE IF @Action = 'D'
BEGIN
    DELETE FROM HotelPreferred
    WHERE PreferredHotelID = @PreferredHotelID
END

END