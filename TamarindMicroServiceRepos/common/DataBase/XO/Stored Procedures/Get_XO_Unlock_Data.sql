CREATE PROCEDURE [XO].[Get_XO_Unlock_Data] (
    @FileCode NVARCHAR(20) = 'TIN250800055',
    @XO_ID NVARCHAR(20) = null,
    @RequestedBy NVARCHAR(50) = 'diptiw',
    @Reason NVARCHAR(200) = 'test',
    @Responsibility NVARCHAR(100) = 'test',
    @Action CHAR(2) = 'S'
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @Action = 'S'
    BEGIN
        -- Get XO unlock data
        --SELECT 
        --    B.FileCode,
        --    X.XO_ID AS XOID,
        --    @RequestedBy AS RequestedBy,
        --    @Reason AS Reason,
        --    @Responsibility AS Responsibility,
        --    X.Curr_ID AS Currency,
        --    X.Curr_ID + ' ' + CONVERT(VARCHAR, ISNULL(X.XO_Amt, 0)) AS XOAmount,
        --    X.XO_Supplier_Name AS HotelName,
        --    VM.VendorName AS Vendor_Name,
        --    CASE 
        --        WHEN HRM.PaymentTypeID = 2 THEN 'BTC Commission'
        --        ELSE '-'
        --    END AS Commission,
        --    X.CheckINDate AS SVCStartDate,
        --    X.CheckOutDate AS SVCEndDate
        --FROM dbo.XO X
        --INNER JOIN Booking.tbl_Booking B ON B.ID = X.Qut_ID
        --LEFT JOIN dbo.VendorMaster VM ON VM.VendorID = (
        --    SELECT TOP 1 Vendor 
        --    FROM Booking.DayWiseBooking 
        --    WHERE BookingID = X.Qut_ID 
        --    AND ISNULL(GroupKey, -1) = ISNULL(X.GroupKey, -1)
        --)
        --LEFT JOIN Booking.DayWiseBooking DWB ON DWB.BookingID = X.Qut_ID 
        --    AND ISNULL(DWB.GroupKey, -1) = ISNULL(X.GroupKey, -1)
        --LEFT JOIN Booking.HotelRateCardMasterBooking HRMB ON HRMB.ID = DWB.BHRMID
        --LEFT JOIN RateCards.HotelRateMaster HRM ON HRM.HotelRateID = HRMB.HotelRateID
        --WHERE 
        --    (@FileCode IS NULL OR B.FileCode = @FileCode)
        --    AND (@XO_ID IS NULL OR X.XO_ID = @XO_ID)
		--Declare @Hotelname varchar(500) =''
		--select top 1 @Hotelname=DWB.HotelName from Booking.DayWiseBooking DWB
		--Inner join dbo.XO X ON DWB.BookingID = X.Qut_ID 
  --          AND ISNULL(DWB.GroupKey, -1) = ISNULL(X.GroupKey, -1) where 
		--	X.XO_ID = @XO_ID;

         SELECT 
            B.FileCode,
            X.XO_ID AS XOID,
			X.XO_ID,
            @RequestedBy AS RequestedBy,
            @Reason AS Reason,
            @Responsibility AS Responsibility,
            X.Curr_ID AS Currency,
            --X.Curr_ID + ' ' + 
			CONVERT(VARCHAR, ISNULL(X.XO_Amt, 0)) AS XOAmount,
            DWB.HotelName AS HotelName,
            VM.VendorName AS Vendor_Name,
			CASE 
                        WHEN HRM.PaymentTypeID = 2 THEN 
						--CASE when HRM.IsCommission=1 THEN 'BTC Commission' ELSE '-' END
      --                  ELSE 'Direct Payment'
						CASE when HRM.IsCommission=1 THEN 'yes' ELSE '-' END
                        ELSE 'no'
                    END AS Commission,
            -- Return as formatted strings to avoid C# DateTime conversion issues
            FORMAT(X.CheckINDate, 'dd/MM/yyyy') AS SVCStartDate,
            FORMAT(X.CheckOutDate, 'dd/MM/yyyy') AS SVCEndDate,
			CASE (DWB.RateTypeID)
                WHEN 1 THEN 'G' WHEN 2 THEN 'M' WHEN 3 THEN 'T'
                WHEN 4 THEN 'S' WHEN 5 THEN 'H' WHEN 7 THEN 'A'
                ELSE 'Unknown'
            END AS XOType
        FROM dbo.XO X
        INNER JOIN Booking.tbl_Booking B ON B.ID = X.Qut_ID
        LEFT JOIN dbo.VendorMaster VM ON VM.VendorID = (
            SELECT TOP 1 Vendor 
            FROM Booking.DayWiseBooking 
            WHERE BookingID = X.Qut_ID 
            AND ISNULL(GroupKey, -1) = ISNULL(X.GroupKey, -1)
        )
        LEFT JOIN Booking.DayWiseBooking DWB ON DWB.BookingID = X.Qut_ID 
            AND ISNULL(DWB.GroupKey, -1) = ISNULL(X.GroupKey, -1)
        LEFT JOIN Booking.HotelRateCardMasterBooking HRMB ON HRMB.ID = DWB.BHRMID
        LEFT JOIN RateCards.HotelRateMaster HRM ON HRM.HotelRateID = HRMB.HotelRateID
        WHERE 
            (@FileCode IS NULL OR LTRIM(RTRIM(B.FileCode)) = LTRIM(RTRIM(@FileCode)))
            AND (@XO_ID IS NULL OR LTRIM(RTRIM(X.XO_ID)) = LTRIM(RTRIM(@XO_ID)))
        
        -- Return success message
        SELECT '200' AS returnCode, 'Data Found' AS returnMessage;
    END
END
