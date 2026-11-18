CREATE FUNCTION [dbo].[fn_GetQuotationDateForBooking]
(
    @QuotationId INT,
    @IsFromDate BIT  
)
RETURNS DATE
AS
BEGIN
    DECLARE @Result DATE;

    SELECT @Result = 
        CASE 
            WHEN @IsFromDate = 1 THEN MIN(Dates.FromDate)
            ELSE MAX(Dates.ToDate)
        END
    FROM
    (
        -- Guide
        SELECT CAST(O.FromDate AS DATE) AS FromDate, CAST(O.ToDate AS DATE) AS ToDate
        FROM Quotation.OthersRateCardMaster O
        WHERE O.QuotationID = @QuotationId AND O.RateType = 1 AND ISNULL(O.IsActive, 0) = 1

        UNION ALL

        -- Monument
        SELECT CAST(O.FromDate AS DATE), CAST(O.ToDate AS DATE)
        FROM Quotation.OthersRateCardMaster O
        WHERE O.QuotationID = @QuotationId AND O.RateType = 2 AND ISNULL(O.IsActive, 0) = 1

        UNION ALL

        -- Transport
        SELECT CAST(O.FromDate AS DATE), CAST(O.ToDate AS DATE)
        FROM Quotation.OthersRateCardMaster O
        WHERE O.QuotationID = @QuotationId AND O.RateType = 3 AND ISNULL(O.IsActive, 0) = 1

        UNION ALL

        -- Special Service
        SELECT CAST(O.FromDate AS DATE), CAST(O.ToDate AS DATE)
        FROM Quotation.OthersRateCardMaster O
        WHERE O.QuotationID = @QuotationId AND O.RateType = 4 AND ISNULL(O.IsActive, 0) = 1

        UNION ALL

        -- Hotel
        SELECT CAST(H.CheckIn AS DATE), CAST(H.CheckOut AS DATE)
        FROM Quotation.HotelRateCardMaster H
        WHERE H.QuotationID = @QuotationId AND ISNULL(H.IsActive, 0) = 1
    ) AS Dates;

    RETURN @Result;
END;
