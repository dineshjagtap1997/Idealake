CREATE PROCEDURE [Invoice].[usp_GenerateAddendumNumber]
    @InvoiceDate DATE,
    @CompanyID VARCHAR(3),
    @AddendumType VARCHAR(2) = 'AD',
    @GeneratedAddendumNo VARCHAR(50) OUTPUT
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
	 From CompanyMaster where CompanyID=9 and IsActive=1

    IF @Month >= 4
        SET @FiscalYear = @Year;
    ELSE
        SET @FiscalYear = @Year - 1;

    SET @FiscalYearCode = RIGHT(CAST(@FiscalYear AS VARCHAR), 2); -- e.g., 2025 → '25'

    DECLARE @NextCounter INT;

    -- Check and insert or update the AddendumSequence table
    IF EXISTS (
        SELECT 1 FROM [Invoice].[AddendumSequence] 
        WHERE CompanyID = @SAPTWODigCompCode AND AddendumType = @AddendumType AND FiscalYear = @FiscalYear
    )
    BEGIN
        UPDATE [Invoice].[AddendumSequence]
        SET MaxCounterID = MaxCounterID + 1
        WHERE CompanyID = @SAPTWODigCompCode AND AddendumType = @AddendumType AND FiscalYear = @FiscalYear;

        SELECT @NextCounter = MaxCounterID
        FROM [Invoice].[AddendumSequence]
        WHERE CompanyID = @SAPTWODigCompCode AND AddendumType = @AddendumType AND FiscalYear = @FiscalYear;
    END
    ELSE
    BEGIN
        INSERT INTO [Invoice].[AddendumSequence] (CompanyID, AddendumType, FiscalYear, MaxCounterID)
        VALUES (@SAPTWODigCompCode, @AddendumType, @FiscalYear, 1);

        SET @NextCounter = 1;
    END

    -- Construct Invoice Number
    SET @GeneratedAddendumNo = 
        @Prefix + @FiscalYearCode + @AddendumType + CAST(@SAPTWODigCompCode AS VARCHAR)  + RIGHT('000000' + CAST(@NextCounter AS VARCHAR), 6);


END;
