CREATE PROCEDURE [dbo].[usp_ProcessDayWiseBookingGroup]
    @BookingID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DWBID INT;
    DECLARE @ISOKXO BIT;

    DECLARE db_cursor CURSOR FOR
        SELECT ID, ISOKXO
        FROM Booking.DayWiseBooking
        WHERE BookingID = @BookingID AND ISNULL(GroupKey, 0) = 0;

    OPEN db_cursor;
    FETCH NEXT FROM db_cursor INTO @DWBID, @ISOKXO;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @ISOKXO = 1
        BEGIN
            EXEC [XO].[CreateGroup] @DWBID;
        END

        FETCH NEXT FROM db_cursor INTO @DWBID, @ISOKXO;
    END

    CLOSE db_cursor;
    DEALLOCATE db_cursor;
END;