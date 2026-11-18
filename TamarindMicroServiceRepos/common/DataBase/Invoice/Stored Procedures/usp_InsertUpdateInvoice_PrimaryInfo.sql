CREATE PROCEDURE [Invoice].[usp_InsertUpdateInvoice_PrimaryInfo]
    @Action VARCHAR(1),
	@ID INT,
    @InvoiceID VARCHAR(50),
    @TypeOfDoc VARCHAR(50),
    @Invoice_Date DATETIME,
	@PlaceOfSupplierId INT,
	@Tax_ID INT,
	@GuestName VARCHAR(100),
    @AgentID INT,
    @Curr_ID INT,
	@AgentBookerName Varchar(100),
	@AgentRefPO Varchar(50),
	@InvoiceType INT,
    @FileCode VARCHAR(20),
    @BookingID INT,
    @QuotationID INT,
	@CompanyID INT,
	@YearCode INT,
	@CreatedBy UNIQUEIDENTIFIER,
	@isTDSDeduction INT,
	@TANNumber Varchar(15),
	@PanNumber Varchar(15),
	@TAXNumber Varchar(15)


AS
BEGIN
<<<<<<< HEAD
<<<<<<< HEAD
    SET NOCOUNT ON;
=======
    SET NOCOUNT ON; 

>>>>>>> dev
=======
    SET NOCOUNT ON; 

>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

    DECLARE 
        @ReturnCode NVARCHAR(3),
        @ReturnMessage NVARCHAR(MAX),
<<<<<<< HEAD
<<<<<<< HEAD
        @LogID INT;

    IF @Action = 'I'
    BEGIN
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        @LogID INT,
		@FileCodeDate Datetime;

    IF @Action = 'I'
    BEGIN 
			
			 		SELECT @FileCodeDate = FileCodeGeneratedOn 
					FROM Booking.tbl_Booking  
					WHERE ID = @BookingID   

					IF (@TypeOfDoc <> 1)
					BEGIN
						PRINT 'A'
						IF (@FileCodeDate > GETDATE())
						BEGIN
							PRINT 'TYPE 2'
							SET @TypeOfDoc = 2
						END
					END
					ELSE IF (@FileCodeDate <= GETDATE())
					BEGIN
						PRINT 'type1'
						SET @TypeOfDoc = 1
					END
					if(@TypeOfDoc = 1 AND @FileCodeDate >= Getdate())
					begin
				      PRINT 'type1'
					SET  @TypeOfDoc = 1
					end
					IF (@TypeOfDoc = 2)
					BEGIN
						PRINT 'pf - 2'
						SET @TypeOfDoc = 2
					END


					--if(@TypeOfDoc != 1)
					--begin
					--if(@FileCodeDate > Getdate())
					--begin
				      
					--SET   @TypeOfDoc  = 2
					--end
			    
					--end

					--if(@FileCodeDate <= Getdate())
					--begin
				      
					--SET  @TypeOfDoc = 1
					--end
					--if(@TypeOfDoc = 2)
				 --	begin
				      
					--SET  @TypeOfDoc = 2
					--end

				--end 


	 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        INSERT INTO [Invoice].Invoice (
            InvoiceNumber,
            TypeOfDoc,
            Invoice_Date,
            PlaceOfSupplierId,
            Tax_ID,
            GuestName,
            AgentID,
            Curr_ID,
			AgentBookerName,
			AgentRefPO,
            InvoiceType,
            FileCode,
            BookingID,
            QuotationID,
			compcode,
			YearCode,
			CreatedBy,
			CreatedDateTime,
			isTDSDeduction,
			TANNumber,
			PanNumber,
<<<<<<< HEAD
<<<<<<< HEAD
			TAXNumber 
=======
			TAXNumber,
			VendorID
>>>>>>> dev
=======
			TAXNumber,
			VendorID
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        )
        VALUES (
            NULL,
            @TypeofDoc,
            @Invoice_Date,
            @PlaceOfSupplierId,
            @Tax_ID,
            @GuestName,
            @AgentID,
            CAST(@Curr_ID AS INT),
			@AgentBookerName,
			@AgentRefPO,
            @InvoiceType,
            @FileCode,
            @BookingID,
            @QuotationID,
			@CompanyID,
			@YearCode,
			@CreatedBy,
			GETDATE(),
			@isTDSDeduction,
			@TANNumber,
			@PanNumber,
<<<<<<< HEAD
<<<<<<< HEAD
			@TAXNumber
=======
			@TAXNumber,
			NULL 
>>>>>>> dev
=======
			@TAXNumber,
			NULL 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

        );

        SET @LogID = SCOPE_IDENTITY();
        SET @ReturnCode = '200';
        SET @ReturnMessage = 'New record added successfully';
    END

    ELSE IF @Action = 'U'
    BEGIN
        UPDATE [Invoice].Invoice
        SET
            TypeOfDoc = @TypeOfDoc,
            Curr_ID = Cast(@Curr_ID as int),
			AgentBookerName = @AgentBookerName,
			AgentRefPO = @AgentRefPO,
			LastUpdatedBy = @CreatedBy,
			LastUpdateDateTime = GETDATE()
        WHERE ID = @ID;

        SET @LogID = (SELECT ID FROM Invoice WHERE ID = @ID);
        SET @ReturnCode = '201';
        SET @ReturnMessage = 'Record updated successfully';
    END
    ELSE IF @Action = 'D'
    BEGIN
        DELETE FROM [Invoice].Invoice 
        WHERE ID = @ID;

        SET @LogID = (SELECT ID FROM Invoice WHERE ID = @ID);
        SET @ReturnCode = '201';
        SET @ReturnMessage = 'Record Deleted successfully';
    END

    ELSE
    BEGIN
        SET @ReturnCode = '400';
        SET @ReturnMessage = 'Invalid Action Code';
        SET @LogID = 0;
    END

    SELECT 
        @ReturnCode AS returnCode,
        @ReturnMessage AS returnMessage,
<<<<<<< HEAD
<<<<<<< HEAD
        @LogID AS ID;
=======
        @LogID AS ID,
		GETDATE() as LastSavedOn;
>>>>>>> dev
=======
        @LogID AS ID,
		GETDATE() as LastSavedOn;
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END;
