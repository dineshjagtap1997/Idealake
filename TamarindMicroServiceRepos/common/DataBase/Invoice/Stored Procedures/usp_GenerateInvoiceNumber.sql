CREATE PROCEDURE [Invoice].[usp_GenerateInvoiceNumber]
    @InvoiceDate DATE,
    @CompanyID VARCHAR(3) = 9,
    @InvoiceType VARCHAR(2), -- 'IN' or 'PF' 
	@YearID INT, 
    @GeneratedInvoiceNo VARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Constants
    DECLARE @Prefix VARCHAR(3) = 'TIN';

    -- Derive fiscal year code
    DECLARE @Month INT = MONTH(@InvoiceDate);
    DECLARE @Year INT = YEAR(@InvoiceDate);
    DECLARE @FiscalYear INT;
    DECLARE @FiscalYearCode VARCHAR(2); 
	DECLARE @SAPTWODigCompCode INT 


	 Select top 1  @Prefix=CompCode   
	 ,@SAPTWODigCompCode=TwoDigitStateCode 
<<<<<<< HEAD
<<<<<<< HEAD
	 From CompanyMaster where CompanyID=9 and IsActive=1
=======
	 From CompanyMaster where CompanyID=@CompanyID and IsActive=1
>>>>>>> dev
=======
	 From CompanyMaster where CompanyID=@CompanyID and IsActive=1
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6


    IF @Month >= 4
        SET @FiscalYear = @Year;
    ELSE
        SET @FiscalYear = @Year - 1;

    SET @FiscalYearCode = RIGHT(CAST(@FiscalYear AS VARCHAR), 2); -- e.g., 2025 → '25'

    DECLARE @NextCounter INT;

    -- Check and insert or update the InvoiceSequence table
    IF EXISTS (
        SELECT 1 FROM [Invoice].[InvoiceSequence] 
        WHERE CompanyID = @CompanyID AND InvoiceType = @InvoiceType AND FiscalYear = @FiscalYear
    )
    BEGIN
        UPDATE [Invoice].[InvoiceSequence]
        SET MaxCounterID = MaxCounterID + 1
        WHERE CompanyID = @CompanyID AND InvoiceType = @InvoiceType AND FiscalYear = @FiscalYear;

        SELECT @NextCounter = MaxCounterID
        FROM [Invoice].[InvoiceSequence]
        WHERE CompanyID = @CompanyID AND InvoiceType = @InvoiceType AND FiscalYear = @FiscalYear;
    END
    ELSE
    BEGIN
        INSERT INTO [Invoice].[InvoiceSequence] (CompanyID, InvoiceType, FiscalYear, MaxCounterID, YearCode)
        VALUES (@CompanyID, @InvoiceType , @FiscalYear, 1, @YearID);

        SET @NextCounter = 1;
    END

    -- Construct Invoice Number
    SET @GeneratedInvoiceNo = 
        @Prefix + @FiscalYearCode + @InvoiceType + CAST(@SAPTWODigCompCode AS VARCHAR) + RIGHT('000000' + CAST(@NextCounter AS VARCHAR), 6);
END;
