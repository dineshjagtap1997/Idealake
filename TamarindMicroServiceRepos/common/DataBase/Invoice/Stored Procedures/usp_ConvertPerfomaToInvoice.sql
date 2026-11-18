


CREATE Procedure [Invoice].[usp_ConvertPerfomaToInvoice]
   @Action VARCHAR(1),
   @ID INT,
   @InvoiceID VARCHAR(50),
   @YearCode VARCHAR(50)


AS
BEGIN
    SET NOCOUNT ON;

	 DECLARE 
        @ReturnCode NVARCHAR(3),
        @ReturnMessage NVARCHAR(MAX),
        @RecordID BIGINT;

    IF @Action = 'I'
	BEGIN


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
			CreatedDateTime
        )
		SELECT InvoiceNumber,
<<<<<<< HEAD
<<<<<<< HEAD
            TypeOfDoc,
            Invoice_Date,
=======
            1,
            GETDATE(),
>>>>>>> dev
=======
            1,
            GETDATE(),
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
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
			CreatedDateTime FROM [Invoice].Invoice WHERE ID = @ID 

           
		   DECLARE @NewInvoiceID INT 
		   SET @NewInvoiceID = (SELECT SCOPE_IDENTITY())

			
			DECLARE @InvoiceDate DATE;
			DECLARE @CompanyID VARCHAR(3) = 9;
			DECLARE @InvoiceTypeID INT;
			DECLARE @InvoiceType VARCHAR(2);
			DECLARE @GeneratedInvoiceNo VARCHAR(50);

			SELECT @InvoiceDate = I.Invoice_Date , @CompanyID = I.compcode , @InvoiceTypeID = TypeOfDoc 
			FROM [Invoice].[Invoice] I where ID = @ID 

			IF @InvoiceTypeID = 2
				SET @InvoiceType = 'IN'



			-- Call to generate invoice number
			EXEC [Invoice].[usp_GenerateInvoiceNumber]
			@InvoiceDate = @InvoiceDate,
			@CompanyID = @CompanyID,
			@InvoiceType = @InvoiceType,
			@YearID = @YearCode,
			@GeneratedInvoiceNo = @GeneratedInvoiceNo OUTPUT;

			
		UPDATE [Invoice].Invoice SET InvoiceNumber = @GeneratedInvoiceNo  Where ID = @NewInvoiceID   
		UPDATE [Invoice].Invoice SET ConvertedInvNo = @GeneratedInvoiceNo  Where ID = @ID 
		 
        INSERT INTO [Invoice].InvoiceDetails (
            Invoice_ID, Invoice_Desc, SACID, Tax_ID,
            TotalBasicAmount, TotalTaxable_Amount, TotalTax_Amount, TotalInvoiceAmount,
<<<<<<< HEAD
<<<<<<< HEAD
            YearCode, CGST, SGST, UTGST, IGST, Invoice_Desc_ID, CreatedBy, CreatedDateTime
        )

		SELECT Invoice_ID, Invoice_Desc, SACID, Tax_ID,
            TotalBasicAmount, TotalTaxable_Amount, TotalTax_Amount, TotalInvoiceAmount,
            YearCode, CGST, SGST, UTGST, IGST, Invoice_Desc_ID, CreatedBy, CreatedDateTime 
			FROM  [Invoice].InvoiceDetails WHERE  Invoice_ID = @ID 
   
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
            YearCode, CGST, SGST, UTGST, IGST, Invoice_Desc_ID, CreatedBy, CreatedDateTime,
				TaxableAmountDetail , TotalAmount , TaxAmount, BasicAmount  
        )

		SELECT @NewInvoiceID, Invoice_Desc, SACID, Tax_ID,
            TotalBasicAmount, TotalTaxable_Amount, TotalTax_Amount, TotalInvoiceAmount,
            YearCode, CGST, SGST, UTGST, IGST, Invoice_Desc_ID, CreatedBy, CreatedDateTime,
				TaxableAmountDetail , TotalAmount , TaxAmount, BasicAmount   
			FROM  [Invoice].InvoiceDetails WHERE  Invoice_ID = @ID 
   
		


		    -- Insert new Addendum
                INSERT INTO [Invoice].[Addendum]
                (
                    [Amount],
                    [InvoiceID],
                    [CreatedBy],
                    [YearCode]
                )
				Select DISTINCT [Amount], [InvoiceID], [CreatedBy], [YearCode] from [Invoice].[Addendum] where   InvoiceID = @ID    

				DECLARE @NewAddendumID INT 
				SET @NewAddendumID = (SELECT SCOPE_IDENTITY())
			
			  -- Insert into AddendumDetails
				INSERT INTO [Invoice].[AddendumDetails]
				(
					[AddendumID],
					[Description],
					[InvoiceID],
					[Currency],
					[Amount],
					[CreatedDate],
					[YearCode]
				)

				Select  @NewAddendumID,  [Description], [InvoiceID], [Currency],  [Amount],  [CreatedDate],  [YearCode] 
				from  [Invoice].[AddendumDetails] where   InvoiceID = @ID  

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

		SET @RecordID = @NewInvoiceID 
        SET @ReturnCode = '200';
        SET @ReturnMessage = 'Record inserted successfully'; 
   END
        SELECT 
        @ReturnCode AS ReturnCode,
        @ReturnMessage AS ReturnMessage,
<<<<<<< HEAD
<<<<<<< HEAD
        @RecordID AS ID; 
=======
        @RecordID AS ID,
		GETDATE() as LastSavedOn; 
>>>>>>> dev
=======
        @RecordID AS ID,
		GETDATE() as LastSavedOn; 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END