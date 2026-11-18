CREATE PROCEDURE [dbo].[usp_GetMaxNoID] --1,'MIS'           
 (  
 @Type TINYINT  
 ,@Prefix VARCHAR(10) = NULL 
 )  
AS  
BEGIN  
 IF (@Type = 1)  
 BEGIN  
  --SELECT CASE   
    --WHEN ISNULL(MAX(CAST(SUBSTRING(HotelCode, 5, 8) AS INT)), 0) = 0  
    -- THEN ISNULL(MAX(CAST(SUBSTRING(HotelCode, 5, 8) AS INT)), 0)  
    --ELSE ISNULL(MAX(CAST(SUBSTRING(HotelCode, 5, 8) AS INT)), 0) + 1  
    --END AS HotelCode  
	--FROM HotelMaster  
 -- WHERE (SUBSTRING(HotelCode, 2, 3)) = @Prefix  
	 SELECT ISNULL(MAX(CAST(SUBSTRING(HotelCode, 5, 8) AS INT)), 0) + 1 AS HotelCode  
        FROM HotelMaster  
        WHERE SUBSTRING(HotelCode, 2, 3) = @Prefix  
  
 END  
 ELSE IF (@Type = 2)  
 BEGIN  
  DECLARE @VendorCode VARCHAR(20)  
  DECLARE @MaxNo VARCHAR(20)  
  DECLARE @MaxNo_Str VARCHAR(20)  
  
  SET @MaxNo_Str = (  
    SELECT SUBSTRING(MAX(VendorCode), 3, LEN(MAX(VendorCode)))  
    FROM VendorMaster  
    WHERE VendorCode LIKE 'CR0%'  
    )  
  SET @MaxNo = LEFT(@MaxNo_Str, 6)  
  
  PRINT '@MaxNo'  
  PRINT @MaxNo  
  
  SET @MaxNo = CASE   
    WHEN @MaxNo IS NULL  
     THEN '1'  
    ELSE CAST(@MaxNo AS INT) + 1  
    END  
  
  PRINT 'NEW'  
  PRINT @MaxNo  
  
  SET @VendorCode = 'CR' + REPLICATE('0', 6 - LEN(@MaxNo)) + @MaxNo  
  
  SELECT @VendorCode AS VendorCode  
 END  
END