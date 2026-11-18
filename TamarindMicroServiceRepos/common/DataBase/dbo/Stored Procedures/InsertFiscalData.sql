CREATE PROCEDURE [dbo].[InsertFiscalData]
    @Fiscal_Year INT,
    @Fiscal_Code INT,
    @Variant VARCHAR(10),
    @Start_Date DATETIME,
    @End_Date DATETIME
AS
BEGIN
    INSERT INTO [dbo].[tbl_FiscalData] 
        ([Fiscal_Year], [Fiscal_Code], [Variant], [Start_Date], [End_Date])
    VALUES
        (@Fiscal_Year, @Fiscal_Code, @Variant, @Start_Date, @End_Date);
END;
