Create FUNCTION [dbo].[fnGetCurrencyConversionRate]
(
    @FromCurrency VARCHAR(3),
    @ToCurrency VARCHAR(10)
)
RETURNS @Result TABLE (
    PurchaseRate DECIMAL(18,6),
    ID INT
)
AS
BEGIN

    DECLARE @PurchaseRate DECIMAL(18,6) = 1;
	DECLARE @ID INT=0;
	DECLARE @FromCurrencyId INT;
    DECLARE @CurrentCurrencyId INT;
	 SELECT @FromCurrencyId = id FROM CurrencyMaster WHERE CurrencyCode = @FromCurrency;
    SELECT @CurrentCurrencyId = id FROM CurrencyMaster WHERE CurrencyCode = @ToCurrency;
	 IF (@FromCurrency <> @ToCurrency)                
    BEGIN    
            SELECT TOP 1 @PurchaseRate = ISNULL(Purchase_Value, 1.00),@ID=id
             FROM Currency_Con_Tab 
             WHERE FromCurrencyId = @FromCurrencyId 
               AND ToCurrencyId = @CurrentCurrencyId
             ORDER BY EffectiveDate DESC;
    END      
    INSERT INTO @Result (PurchaseRate, ID)
    VALUES (@PurchaseRate, @ID);

    RETURN;
END;
