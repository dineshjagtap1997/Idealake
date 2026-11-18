CREATE   FUNCTION [dbo].[fnGetPurchaseRate]
(
    @FromCurrency VARCHAR(3),
    @ToCurrency VARCHAR(10),
    @Date DATETIME
)
RETURNS DECIMAL(18,6)
AS
BEGIN

    DECLARE @PurchaseRate DECIMAL(18,6) = 1;
	DECLARE @FromCurrencyId INT;
    DECLARE @CurrentCurrencyId INT;
	 SELECT @FromCurrencyId = id FROM CurrencyMaster WHERE CurrencyCode = @FromCurrency;
    SELECT @CurrentCurrencyId = id FROM CurrencyMaster WHERE CurrencyCode = @ToCurrency;

    
	
	 IF (@FromCurrency <> @ToCurrency)                
    BEGIN    
        SELECT @PurchaseRate = ISNULL(
            (SELECT TOP 1 Purchase_Value 
             FROM Currency_Con_Tab 
             WHERE FromCurrencyId = @FromCurrencyId 
               AND ToCurrencyId = @CurrentCurrencyId
             ORDER BY EffectiveDate DESC), 1.00);
    END  
        --IF (@FromCurrency <> 'INR' AND @ToCurrency <> 'INR')  
        --BEGIN  
            --SELECT @PurchaseRate = ISNULL(
            --    (SELECT TOP 1  Purchase_Value FROM Currency_Con_Tab 
            --     WHERE EffectiveDate = (SELECT MAX(EffectiveDate) FROM Currency_Con_Tab WHERE EffectiveDate <= @Date 
            --                            AND FromCurrencyId = @FromCurrencyId AND ToCurrencyId = @CurrentCurrencyId)
            --     AND FromCurrencyId = @FromCurrencyId AND ToCurrencyId = @CurrentCurrencyId), 1.00);  
       
        --ELSE IF (@FromCurrency <> 'INR') -- Foreign to INR Currency                
        --BEGIN  
        --    SELECT @PurchaseRate = ISNULL(
        --        (SELECT TOP 1 Purchase_Value FROM Currency_Con_Tab 
        --         WHERE EffectiveDate = (SELECT MAX(EffectiveDate) FROM Currency_Con_Tab WHERE EffectiveDate <= @Date 
        --                                AND FromCurrencyId = @FromCurrencyId)
        --         AND FromCurrencyId = @FromCurrencyId), 1.00);  
        --END  
        --ELSE -- INR to Foreign Currency                
        --BEGIN  
        --    SELECT @PurchaseRate = ISNULL(
        --        (SELECT TOP 1 Purchase_Value FROM Currency_Con_Tab 
        --         WHERE EffectiveDate = (SELECT MAX(EffectiveDate) FROM Currency_Con_Tab WHERE EffectiveDate <= @Date 
        --                                AND ToCurrencyId = @CurrentCurrencyId)
        --         AND ToCurrencyId = @CurrentCurrencyId), 1.00);  
        --END                
    --END     
    RETURN @PurchaseRate;
END;
