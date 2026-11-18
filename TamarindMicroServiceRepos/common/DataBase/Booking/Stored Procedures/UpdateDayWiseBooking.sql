CREATE PROCEDURE [Booking].[UpdateDayWiseBooking]
    @Action CHAR(5) = NULL,
    @ID BIGINT = NULL,
    @SGL INT = NULL,
    @Twin INT = NULL,

    @DBL INT = NULL,
    @EBA INT = NULL,
    @EBC INT = NULL,
    @CNB INT = NULL,
    @SGL_Rate DECIMAL(18, 2),
    @DBL_Rate DECIMAL(18, 2) = NULL,
    @EBA_Rate DECIMAL(18, 2) = NULL,
    @EBC_Rate DECIMAL(18, 2) = NULL,
    @CNB_Rate DECIMAL(18, 2) = NULL,
    @Count INT = NULL,
    @Adult_Count INT = NULL,
    @Child_Count INT = NULL,
    @Adult_Rate DECIMAL(18, 2) = NULL,
    @Child_Rate DECIMAL(18, 2) = NULL,
    @TCountRate DECIMAL(18, 2) = NULL,
	@Twin_Rate DECIMAL(18, 2) = NULL,
    @Consolidated INT = NULL,

	@MealList [dbo].[BookingMealPlanTableType] READONLY
AS
BEGIN
	DECLARE @IsOKXO INT,@GroupKey INT,@BookingID bigint,@RateTypeID INT, @value INT;;
    IF @Action = 'U'
    BEGIN
        -- Step 1: Get RateTypeID and reference ID (value)
        SELECT 
            @RateTypeID = RateTypeID,
            @value = CASE 
                        WHEN RateTypeID = 5 THEN BHRMID 
                        ELSE BORMID 
                     END
        FROM Booking.DayWiseBooking
        WHERE ID = @ID;
 
        -- Step 2: Update DayWiseBooking
        UPDATE Booking.DayWiseBooking
        SET
            [Count] = ISNULL(@Count, [Count]),
            Adult = ISNULL(@Adult_Count, Adult),
            Child = ISNULL(@Child_Count, Child),
            SGL = ISNULL(@SGL, SGL),
            Twin = ISNULL(@Twin, Twin),

            DBL = ISNULL(@DBL, DBL),
            EBA = ISNULL(@EBA, EBA),
            EBC = ISNULL(@EBC, EBC),
            CNB = ISNULL(@CNB, CNB),
            SGL_Rate = ISNULL(@SGL_Rate, SGL_Rate),
            Twin_Rate = ISNULL(@Twin_Rate, Twin_Rate),

            DBL_Rate = ISNULL(@DBL_Rate, DBL_Rate),
            EBA_Rate = ISNULL(@EBA_Rate, EBA_Rate),
            EBC_Rate = ISNULL(@EBC_Rate, EBC_Rate),
            CNB_Rate = ISNULL(@CNB_Rate, CNB_Rate),
            Adult_Rate = ISNULL(@Adult_Rate, Adult_Rate),
            Child_Rate = ISNULL(@Child_Rate, Child_Rate),
			Consolidated= ISNULL(@Consolidated, Consolidated)
         --   TCountRate = ISNULL(@TCountRate, TCountRate)
        WHERE ID = @ID;
 
		UPDATE BHRM
			SET IsSupplementary=ML.IsSupplementary
		FROM 
			Booking.HotelRateMealPlanMasterBooking BHRM
			INNER JOIN @MealList AS ML ON BHRM.QuotationHotelRateMealId = ML.HotelRateMealID
		WHERE BHRM.QuotationHotelRateMealId = ML.HotelRateMealID;

 
 
		SELECT '200' AS returnCode, GETDATE() as LastSavedOn, 'The selected item has been added to XO successfully.' AS returnMessage;   
        -- Step 3: Update IsOKXO
        IF @RateTypeID = 5
        BEGIN
            UPDATE Booking.DayWiseBooking
            SET IsOKXO = (
                SELECT CASE WHEN IsCustom = 1 THEN 0 ELSE 1 END
                FROM Booking.HotelRateCardMasterBooking
                WHERE ID = @value
            )
            WHERE ID = @ID;
 
			SELECT '200' AS returnCode, GETDATE() as LastSavedOn,'The selected item has been added to XO successfully.' AS returnMessage;   
        END
        ELSE
        BEGIN
            UPDATE Booking.DayWiseBooking
            SET IsOKXO = (
                SELECT CASE WHEN IsCustom = 1 THEN 0 ELSE 1 END
                FROM Booking.OthersRateCardMasterBooking
                WHERE ID = @value
            )
            WHERE ID = @ID;
			SELECT '200' AS returnCode, GETDATE() as LastSavedOn, 'The selected item has been added to XO successfully.' AS returnMessage;   
        END
 
        -- Step 4: Re-fetch updated IsOKXO and GroupKey

 
        SELECT 
            @IsOKXO = IsOKXO,
            @GroupKey = GroupKey
        FROM Booking.DayWiseBooking
        WHERE ID = @ID;
 
        -- Step 5: Call CreateGroup if conditions met
        IF @IsOKXO = 1 AND ISNULL(@GroupKey, 0) = 0
        BEGIN
            EXEC [XO].[CreateGroup] @ID;
        END
 
        -- Step 6: Final result return
        SELECT
            ID,
            ISNULL([Count], 0) AS [Count],
            ISNULL(Adult, 0) AS Adult,
            ISNULL(Child, 0) AS Child,
            ISNULL(SGL, 0) AS SGL,
            ISNULL(Twin, 0) AS Twin,

            ISNULL(DBL, 0) AS DBL,
            ISNULL(EBA, 0) AS EBA,
            ISNULL(EBC, 0) AS EBC,
            ISNULL(CNB, 0) AS CNB,
            ISNULL(SGL_Rate, 0) AS SGL_Rate,
            ISNULL(Twin_Rate, 0) AS Twin_Rate,

            ISNULL(DBL_Rate, 0) AS DBL_Rate,
            ISNULL(EBA_Rate, 0) AS EBA_Rate,
            ISNULL(EBC_Rate, 0) AS EBC_Rate,
            ISNULL(CNB_Rate, 0) AS CNB_Rate,
            ISNULL(Adult_Rate, 0) AS Adult_Rate,
            ISNULL(Child_Rate, 0) AS Child_Rate,
            ISNULL(Consolidated, 0) AS Consolidated,

			IsOkXO
        FROM Booking.DayWiseBooking
        WHERE ID = @ID;
 
		 update book set book.ModifiedOn=GETDATE() FROM Booking.DayWiseBooking DWB
		left join Booking.tbl_Booking book on book.ID=DWB.BookingID
        WHERE DWB.ID = @ID;
	SELECT '200' AS returnCode, GETDATE() as LastSavedOn, 'The selected item has been added to XO successfully.' AS returnMessage;                                                 
 
    END
 
	 ELSE IF @Action='UXO'
	 BEGIN
		IF NOT EXISTS(select * from Booking.DayWiseBooking DWB inner Join dbo.XO X on DWB.Bookingid=X.QUT_ID and DWB.GroupKey=X.GroupKey where DWB.ID=@ID and X.Undo=0)
		BEGIN
			SELECT @IsOKXO = IsOKXO,@GroupKey = GroupKey,@BookingID=BookingID FROM Booking.DayWiseBooking WHERE ID = @ID;
			UPDATE Booking.DayWiseBooking SET IsOKXO = 0, GroupKey=NULL WHERE ID = @ID;
			DECLARE @DayWiseBookingID INT;
 
			-- For each GroupKey, loop through all related DayWiseBookingIDs
			DECLARE BookingIDCursor CURSOR FOR
				SELECT ID FROM Booking.DayWiseBooking WHERE GroupKey = @GroupKey and BookingID=@BookingID;
			OPEN BookingIDCursor;
			FETCH NEXT FROM BookingIDCursor INTO @DayWiseBookingID;
 
			WHILE @@FETCH_STATUS = 0
			BEGIN
				-- Call your procedure
				UPDATE Booking.DayWiseBooking SET GroupKey=NULL WHERE ID = @DayWiseBookingID;
				EXEC [XO].[CreateGroup] @DayWiseBookingID;
 
				FETCH NEXT FROM BookingIDCursor INTO @DayWiseBookingID;
			END
 
			CLOSE BookingIDCursor;
			DEALLOCATE BookingIDCursor;
			SELECT '200' AS returnCode, GETDATE() as LastSavedOn, 'The selected item has been removed from XO successfully.' AS returnMessage;              
		END
		ELSE
		BEGIN
			SELECT '201' AS returnCode, GETDATE() as LastSavedOn, 'XO Number is already generated' AS returnMessage;                                             
		END
	 END
	 ELSE IF @Action = 'IXO'
	 BEGIN
 
        -- Step 1: Get RateTypeID and reference ID (value)
        SELECT 
            @RateTypeID = RateTypeID,
            @value = CASE 
                        WHEN RateTypeID = 5 THEN BHRMID 
                        ELSE BORMID 
                     END
        FROM Booking.DayWiseBooking
        WHERE ID = @ID;
 


		IF @RateTypeID = 5
        BEGIN
            UPDATE Booking.DayWiseBooking
            SET IsOKXO = (
                SELECT CASE WHEN IsCustom = 1 THEN 0 ELSE 1 END
                FROM Booking.HotelRateCardMasterBooking
                WHERE ID = @value
            )
            WHERE ID = @ID; 
        END
        ELSE
        BEGIN
            UPDATE Booking.DayWiseBooking
            SET IsOKXO = (
                SELECT CASE WHEN IsCustom = 1 THEN 0 ELSE 1 END
                FROM Booking.OthersRateCardMasterBooking
                WHERE ID = @value
            )
            WHERE ID = @ID; 
        END


			SELECT @IsOKXO = IsOKXO,@GroupKey = GroupKey FROM Booking.DayWiseBooking WHERE ID = @ID;


			IF @IsOKXO = 1 AND ISNULL(@GroupKey, 0) = 0
			BEGIN
				EXEC [XO].[CreateGroup] @ID;
			END
	 END
END