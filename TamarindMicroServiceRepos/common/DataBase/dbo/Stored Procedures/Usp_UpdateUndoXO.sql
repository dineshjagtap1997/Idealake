<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[Usp_UpdateUndoXO]              
(              
    @XOID INT,              
    @YearCode INT,
    @XO_UserID Uniqueidentifier   = NULL,
    @XOUpdated_Dt DATETIME = NULL,
    @XO_UNDODt DATETIME = NULL,
    @Action CHAR(2) = 'U'
)            
AS              
BEGIN  
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿--USE [tamarind_devdb]
--GO
--/****** Object:  StoredProcedure [dbo].[Usp_UpdateUndoXO]    Script Date: 10-07-2025 16:43:14 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER PROCEDURE [dbo].[Usp_UpdateUndoXO]              
--(              
--    @XOID INT,              
--    @YearCode INT,
--    @XO_UserID Uniqueidentifier   = NULL,
--    @XOUpdated_Dt DATETIME = NULL,
--    @XO_UNDODt DATETIME = NULL,
--    @Action CHAR(2) = 'U'
--)            
--AS              
--BEGIN  
--    SET NOCOUNT ON;

--    IF @Action = 'U'
--    BEGIN
--        UPDATE XO 
--        SET 
--            Undo = 1,
--            UndoDate =  GETDATE(),
--            UpdatedDate = GETDATE(),
--            UpdatedBy = @XO_UserID  ,
--			XONumber =''
--        WHERE DayWiseID = @XOID              
--          AND YearCode = @YearCode;

		  
--		 IF EXISTS (SELECT TOP 1 1 FROM [XO_Instructions] WHERE DayWiseID = @XOID)
--BEGIN
--    UPDATE [XO_Instructions]
--    SET isactive = 0
--    WHERE DayWiseID = @XOID;
--END
--        -- Return success message
--        SELECT '200' AS returnCode, 'Record updated successful.' AS returnMessage;
--    END
--END

--ALTER PROCEDURE [dbo].[Usp_UpdateUndoXO]              
--(              
--    @XOID NVARCHAR(50),     -- changed from BIGINT
--    @YearCode INT,
--    @XO_UserID UNIQUEIDENTIFIER = NULL,
--    @XOUpdated_Dt DATETIME = NULL,
--    @XO_UNDODt DATETIME = NULL,
--    @Action CHAR(2) = 'U'
--)
--AS
--BEGIN
--    SET NOCOUNT ON;

--    IF @Action = 'U'
--    BEGIN
		
--		IF NOT exists(select top 1 * from dbo.AdvancePaySendRequest A inner join dbo.xo X on X.XO_ID=A.XO_ID and X.ID=@XOID)
--		 BEGIN
--		 Update dwb
--		  set IsXoGen=0
--		  from Booking.DayWiseBooking dwb
--		  inner join xo x on x.GroupKey=dwb.GroupKey and dwb.BookingID=x.Qut_ID
--		  WHERE x.ID = @XOID         
--			--AND x.YearCode = @YearCode
--			ANd Isnull(dwb.XOLock,0)=0 AND Isnull(dwb.IsLock,0)=0; 

--        UPDATE XO 
--        SET 
--            Undo = 1,
--            UndoDate = GETDATE(),
--            UpdatedDate = GETDATE(),
--            UpdatedBy = @XO_UserID,
--            XONumber = '',GroupKey=0,Qut_ID=0,XO_ID=''
--        WHERE ID = @XOID         
--          AND YearCode = @YearCode;
--        IF EXISTS (SELECT TOP 1 1 FROM [XO_Instructions] WHERE DayWiseID = @XOID)
--        BEGIN
--            UPDATE [XO_Instructions]
--            SET isactive = 0
--            WHERE DayWiseID = @XOID;
--        END

--        SELECT '200' AS returnCode, 'Record updated successful.' AS returnMessage,GETDATE() as LastSavedOn;
--		END
--		ELSE
--		BEGIN
--		SELECT '201' AS returnCode, 'Cannot Undo XO as XO is locked' AS returnMessage,GETDATE() as LastSavedOn;
--		END
--    END


--END


CREATE PROCEDURE [dbo].[Usp_UpdateUndoXO]              
(              
    @XOID NVARCHAR(50),     -- XO_ID is nvarchar in DB
    @YearCode INT,
    @XO_UserID UNIQUEIDENTIFIER = NULL,
    @XOUpdated_Dt DATETIME = NULL,
    @XO_UNDODt DATETIME = NULL,
    @Action CHAR(2) = 'U'
)
AS
BEGIN
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    SET NOCOUNT ON;

    IF @Action = 'U'
    BEGIN
<<<<<<< HEAD
<<<<<<< HEAD
        UPDATE XO 
        SET 
            Undo = 1,
            UndoDate =  GETDATE(),
            UpdatedDate = GETDATE(),
            UpdatedBy = @XO_UserID  ,
			XONumber =''
        WHERE DayWiseID = @XOID              
          AND YearCode = @YearCode;

		  
		 IF EXISTS (SELECT TOP 1 1 FROM [XO_Instructions] WHERE DayWiseID = @XOID)
BEGIN
    UPDATE [XO_Instructions]
    SET isactive = 0
    WHERE DayWiseID = @XOID;
END
        -- Return success message
        SELECT '200' AS returnCode, 'Record updated successful.' AS returnMessage;
    END
END
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        -- Check if the XO is locked via AdvancePaySendRequest
        IF NOT EXISTS (
            SELECT TOP 1 1
            FROM dbo.AdvancePaySendRequest A
            INNER JOIN dbo.XO X ON X.XO_ID = A.XO_ID
            WHERE X.XO_ID = @XOID
        )
        BEGIN
            -- Update DayWiseBooking to reset IsXoGen
            UPDATE dwb
            SET IsXoGen = 0,XOLock=0
            FROM Booking.DayWiseBooking dwb
            INNER JOIN XO x ON x.GroupKey = dwb.GroupKey AND dwb.BookingID = x.Qut_ID
            WHERE x.XO_ID = @XOID

            -- Update XO to reflect Undo
            UPDATE XO
            SET 
                Undo = 1,
                UndoDate = GETDATE(),
                UpdatedDate = GETDATE(),
                UpdatedBy = @XO_UserID
            WHERE XO_ID = @XOID 


            -- Deactivate related XO Instructions
            IF EXISTS (
                SELECT TOP 1 1 
                FROM [XO_Instructions] 
                WHERE XO_ID = @XOID
            )
            BEGIN
                UPDATE [XO_Instructions]
                SET isactive = 0
                WHERE XO_ID = @XOID;
            END

            -- Success response
            SELECT 
                '200' AS returnCode, 
                'Record updated successful.' AS returnMessage,
                GETDATE() AS LastSavedOn;
        END
        ELSE
        BEGIN
            -- If XO is locked
            SELECT 
                '201' AS returnCode, 
                'Cannot Undo XO as XO is locked' AS returnMessage,
                GETDATE() AS LastSavedOn;
        END
    END
<<<<<<< HEAD
END
>>>>>>> dev
=======
END
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
