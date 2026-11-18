  
  
  
  
-- =============================================                                                                                                                                
-- Author: sanket                                                                                                                               
-- Create date: 03 Jan 2012                                                                                                                                
-- Description: get hotel offers data                                                                                         
--Update By Sagar for hotelgroup                                                                                                                           
-- =============================================                                                                                                                  
CREATE PROCEDURE [dbo].[usp_SearchHotelOffers] -- null,'Club Mahindra Backwater Retreat, Ashtamudi',null,null,null,'20130814','20130914'                                                          
	(
	@City CHAR(3) = NULL
	,@HotelVendorName VARCHAR(200) = NULL
	,@HotelGroup VARCHAR(200) = NULL
	,@RateHeader VARCHAR(200) = NULL
	,@HotelRating INT = NULL
	,@ValidFrom VARCHAR(10) = NULL
	,@ValidTo VARCHAR(10) = NULL
	)
AS
BEGIN
	SELECT *
	FROM (
		SELECT CASE 
				WHEN HO.IsVendorHotel = 1
					THEN C1.Name
				WHEN ISNULL(HOM.CityIATACode, '') <> ''
					THEN C.Name
				ELSE C2.Name
				END AS City
			,
			--CASE WHEN HO.HotelGroupCode IS NOT NULL THEN HG.Name ELSE HO.HotelGroupName END AS HotelGroupName,                          
			HG.Name AS HotelGroupName
			,HOM.CityIATACode AS HOMCITY
			,CASE 
				WHEN HO.IsVendorHotel = 1
					THEN 'Vendor'
				ELSE 'Hotel'
				END AS IsHotelVendor
			,CASE 
				WHEN HO.IsVendorHotel = 1
					THEN CASE 
							WHEN HotelVendorID IS NOT NULL
								THEN VM.VendorName
							ELSE HotelVendorName
							END --Update Sagar for Null VendorName not showing properly 17 Oct 2013                                                     
				ELSE CASE 
						WHEN ISNULL(HotelVendorName, '') = ''
							THEN HM.HotelName
						ELSE HotelVendorName
						END
					--THEN CASE WHEN ISNULL(HotelVendorName,'')='' THEN  VM.VendorName ELSE HotelVendorName END                                                                      
					-- THEN CASE WHEN HO.HotelVendorID IS NOT NULL THEN  VM.VendorName ELSE HotelVendorName END          comment by sagar                                                
					--ELSE CASE WHEN HO.HotelVendorID IS NOT NULL THEN HM.HotelName ELSE HotelVendorName END                                                           
				END AS VendorHotelName
			,Heading
			,HO.RateValidFrom
			,HO.RateValidTo
			,dbo.udf_StripHTML(HO.Rules) AS Rules
			,HO.InfoForOps
			,HO.HotelOfferID
			,CASE 
				WHEN HO.IsVendorHotel = 1
					THEN C1.IATACode
				WHEN ISNULL(HOM.CityIATACode, '') <> ''
					THEN HOM.CityIATACode
				ELSE c2.IATACode
				END AS IATACode
			,HO.HotelRatingID
			,HO.IsActive
			,HO.CardNo
			,dbo.fnGetHotelOfferRateType(HO.HotelOfferID) AS RateSheet
			,dbo.fnGetHotelOfferMarket(HO.HotelOfferID) AS MarketName
			,HR.Code AS HotelRating
			,convert(VARCHAR(15), cast(HO.RateValidFrom AS DATE), 106) + ' - ' + convert(VARCHAR(15), cast(HO.RateValidTo AS DATE), 106) AS 'StayFromTo'
			,'' AS 'BookFromTo'
			,'' AS 'Links'
		FROM HotelOffers HO
		LEFT JOIN VendorMaster VM ON VM.VendorID = HO.HotelVendorID
			AND HO.IsVendorHotel = 1
		LEFT JOIN HotelOfferMapping HOM ON HO.HotelOfferID = HOM.HotelOfferID
		LEFT JOIN City C ON C.IATACode = HOM.CityIATACode
		LEFT JOIN City C1 ON C1.IATACode = HO.CityIATACode
			AND HO.IsVendorHotel = 1
		LEFT JOIN HotelMaster HM ON HM.HotelID = HOM.HotelID
			AND HO.IsVendorHotel IN (
				2
				,3
				) --in condition is added by sagar                      
		LEFT JOIN City C2 ON C2.IATACode = HM.CityIATACode
			AND HO.IsVendorHotel IN (
				2
				,3
				)
		LEFT JOIN HotelRating HR ON HR.ID = HM.HotelRatingID
		LEFT JOIN HotelGroups HG ON HG.IATACode = HM.ChainIATACode
		) THO
	WHERE (@City IS NULL OR @City = '' OR ISNULL(THO.IATACode, '') = @City)
	AND (@HotelVendorName IS NULL OR @HotelVendorName = '' OR ISNULL(THO.VendorHotelName, '') LIKE '%' + @HotelVendorName + '%')
	AND (@HotelGroup IS NULL OR @HotelGroup = '' OR ISNULL(THO.HotelGroupName, '') LIKE '%' + @HotelGroup + '%')
	AND (@RateHeader IS NULL OR @RateHeader = '' OR ISNULL(Heading, '') LIKE '%' + @RateHeader + '%')
	AND (@HotelRating IS NULL OR ISNULL(THO.HotelRatingID, 0) = @HotelRating)
	AND (
		(@ValidFrom IS NULL or @ValidFrom = '') AND (@ValidTo IS NULL or @ValidTo = '')
		OR (
			(
				CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112) BETWEEN CONVERT(VARCHAR, THO.RateValidFrom, 112)
				AND CONVERT(VARCHAR, THO.RateValidTo, 112)
			)
			OR (
				CONVERT(VARCHAR, CAST(@ValidTo AS DATETIME), 112) BETWEEN CONVERT(VARCHAR, THO.RateValidFrom, 112)
				AND CONVERT(VARCHAR, THO.RateValidTo, 112)
			)
			OR (
				CONVERT(VARCHAR, THO.RateValidFrom, 112) BETWEEN 
					ISNULL(CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112), CONVERT(VARCHAR, THO.RateValidFrom, 112))
				AND 
					ISNULL(CONVERT(VARCHAR, CAST(@ValidTo AS DATETIME), 112), CONVERT(VARCHAR, THO.RateValidTo, 112))
			)
			OR (
				CONVERT(VARCHAR, THO.RateValidTo, 112) BETWEEN 
					ISNULL(CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112), CONVERT(VARCHAR, THO.RateValidFrom, 112))
				AND 
					ISNULL(CONVERT(VARCHAR, CAST(@ValidTo AS DATETIME), 112), CONVERT(VARCHAR, THO.RateValidTo, 112))
			)
		)
	)
	AND IsActive = 1
END