create PROCEDURE [XO].[Get_XO_Data_bkp]                          
(
    @BookingID INT = NULL,
    @Action CHAR(2) = 'S'
)      
AS           
BEGIN    
    SET NOCOUNT ON;

    IF @Action = 'S'
    BEGIN
        -- New XO suggestion
        SELECT 
            CASE MIN(DWB.RateTypeID)
                WHEN 1 THEN 'G'
                WHEN 2 THEN 'M'
                WHEN 3 THEN 'T'
                WHEN 4 THEN 'S'
                WHEN 5 THEN 'H'
                WHEN 7 THEN 'A'
                ELSE 'Unknown'
            END AS XOType,
            NULL AS AdvanceXOID,
            MIN(DWB.BookingID) AS BookingID,
            '' AS XONumber,
            MIN(DWB.HotelName) AS Supplier,
            SUM(DWB.GrossRate) AS XOAmount,
            MIN(DWB.Currency) AS Currency,
            SUM(DWB.GrossRate) AS GrossRate,
            MIN(DWB.DayWiseDate) AS Checkin,
            MAX(DWB.DayWiseDate) AS Checkout,
			(
				SELECT TOP 1 CAST(HRM.IsCommission AS INT)
				FROM RateCards.HotelRateMaster HRM
				LEFT JOIN Booking.HotelRateCardMasterBooking HRMID 
					ON HRM.HotelRateID = HRMID.HotelRateID
				WHERE HRMID.ID = (SELECT MIN(BORMID) FROM Booking.DayWiseBooking WHERE GroupKey = DWB.GroupKey)
			) AS IsBTCComm,
            0 AS CommInv,
            MIN(DWB.City) AS City,
            (SELECT TOP 1 CASE WHEN Qut_ID IS NOT NULL THEN 'Yes' ELSE 'No' END 
             FROM dbo.XO_Instructions 
             WHERE Qut_ID = MIN(DWB.BookingID)) AS XOInstruction,
            DWB.GroupKey,
            STRING_AGG(CAST(DWB.ID AS VARCHAR(MAX)), ',') AS IDList
        FROM Booking.DayWiseBooking DWB
        WHERE 
            (@BookingID IS NULL OR DWB.BookingID = @BookingID)
            AND NOT EXISTS (
                SELECT 1
                FROM dbo.XO XO
                WHERE XO.Qut_ID = DWB.BookingID
                  AND ISNULL(XO.GroupKey, -1) = ISNULL(DWB.GroupKey, -1)
            )
        GROUP BY DWB.GroupKey

        UNION ALL

        -- Existing XO
        SELECT 
            XO.XoType,
            A.XO_ID AS AdvanceXOID,
            XO.Qut_ID AS BookingID,
            XO.XO_ID AS XONumber,
            XO.XO_Supplier_Name AS Supplier,
            XO.AmtInINR AS XOAmount,
            XO.Curr_ID AS Currency,
            XO.XO_Amt AS GrossRate,
            NULL AS Checkin,
            NULL AS Checkout,
            XO.IsBTCComm,
            0 AS CommInv,
            NULL AS City,
            (SELECT TOP 1 CASE WHEN Qut_ID IS NOT NULL THEN 'Yes' ELSE 'No' END 
             FROM dbo.XO_Instructions 
             WHERE Qut_ID = XO.Qut_ID) AS XOInstruction,
            XO.GroupKey,
            '' AS IDList
        FROM dbo.XO XO
        LEFT JOIN AdvancePaySendRequest A ON A.XO_ID = XO.XO_ID 
        WHERE 
            (@BookingID IS NULL OR XO.Qut_ID = @BookingID)
            AND ISNULL(XO.Undo, 0) = 0 AND XO.Undo IS NULL;

        SELECT '200' AS returnCode, 'Data Found' AS returnMessage;
    END
END
