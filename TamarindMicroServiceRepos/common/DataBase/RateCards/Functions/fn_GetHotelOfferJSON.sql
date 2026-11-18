

CREATE FUNCTION [RateCards].[fn_GetHotelOfferJSON]
(
   @Hotel BIGINT = NULL,
   @ValidFrom DATETIME = NULL,
   @ValidTo DATETIME = NULL
)
RETURNS @Result TABLE
(
    HotelOfferJSON NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @json NVARCHAR(MAX)



    SELECT @json = (
        SELECT
            hom.HotelOfferID,
            hom.CardNumber,
            hom.Heading,
            c.[Name] AS City,
            Isnull(vm.VendorName,'') as VendorName,
            hom.IsActive,
            CONVERT(VARCHAR(10), hom.ValidFrom, 120) AS ValidFrom,
            CONVERT(VARCHAR(10), hom.ValidTo, 120) AS ValidTo,
            hom.[Rule],
            Isnull(hg.Name,'') AS HotelGroupName,
            CAST(IIF(NULLIF(LTRIM(RTRIM(hom.[Rule])), '') IS NOT NULL, 1, 0) AS BIT) AS HasRules,
            ISNULL((
                SELECT TOP 1 CAST(1 AS BIT)
                FROM dbo.LinkedDocuments ld
                INNER JOIN dbo.UploadDocuments ud 
                    ON ud.DocumentID = ld.DocumentID 
                    AND ud.ParentTypeID = 7
                WHERE ld.ParentID = hom.HotelOfferID
            ), CAST(0 AS BIT)) AS HasDocument,
            (
                SELECT hm.HotelID, hm.HotelName
                FROM RateCards.HotelOfferMapping map
                INNER JOIN dbo.HotelMaster hm ON map.HotelID = hm.HotelID
                WHERE map.HotelOfferID = hom.HotelOfferID AND map.IsActive = 1
                FOR JSON PATH
            ) AS HotelDetailsJson
        FROM RateCards.HotelOfferMaster hom
        LEFT JOIN [dbo].City c ON c.IATACode = hom.CityID
        LEFT JOIN [dbo].VendorMaster vm ON vm.VendorID = hom.VendorID
        LEFT JOIN [dbo].HotelGroups hg ON hg.HotelGroupID = hom.HotelGroupID
        WHERE 
			(@ValidFrom>=hom.ValidFrom And @ValidTo<=hom.ValidTo) AND
            (@Hotel IS NULL OR EXISTS (
                SELECT 1
                FROM RateCards.HotelOfferMapping map
                WHERE map.HotelOfferID = hom.HotelOfferID
                  AND map.HotelID = @Hotel
                  AND map.IsActive = 1
            ))
        ORDER BY hom.CreatedOn DESC

        FOR JSON PATH
    )

    INSERT INTO @Result(HotelOfferJSON)
    VALUES (@json)

    RETURN
END
