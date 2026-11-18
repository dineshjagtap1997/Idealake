CREATE FUNCTION [dbo].[fnSearchCalculateROE]                
(@Rate numeric(18,2), @FDate DateTime, @FromCurrency varchar(10), @CurrentCurrency varchar(10))                
RETURNS NUMERIC(18,2)                        
AS                          
BEGIN                 
    DECLARE @ROE NUMERIC(18,5) = 1.00;                 
    DECLARE @FromCurrencyId INT;
    DECLARE @CurrentCurrencyId INT;

    -- Fetch Currency IDs
    SELECT @FromCurrencyId = id FROM CurrencyMaster WHERE CurrencyCode = @FromCurrency;
    SELECT @CurrentCurrencyId = id FROM CurrencyMaster WHERE CurrencyCode = @CurrentCurrency;
                  
    IF (@FromCurrency <> @CurrentCurrency)                
    BEGIN    
        IF (@FromCurrency <> 'INR' AND @CurrentCurrency <> 'INR')  
        BEGIN  
            SELECT @ROE = ISNULL(
                (SELECT TOP 1 Sales_Value * Purchase_Value FROM Currency_Con_Tab 
                 WHERE EffectiveDate = (SELECT MAX(EffectiveDate) FROM Currency_Con_Tab WHERE EffectiveDate <= @FDate 
                                        AND FromCurrencyId = @FromCurrencyId AND ToCurrencyId = @CurrentCurrencyId)
                 AND FromCurrencyId = @FromCurrencyId AND ToCurrencyId = @CurrentCurrencyId), 1.00);  
        END  
        ELSE IF (@FromCurrency <> 'INR') -- Foreign to INR Currency                
        BEGIN  
            SELECT @ROE = ISNULL(
                (SELECT TOP 1 Purchase_Value FROM Currency_Con_Tab 
                 WHERE EffectiveDate = (SELECT MAX(EffectiveDate) FROM Currency_Con_Tab WHERE EffectiveDate <= @FDate 
                                        AND FromCurrencyId = @FromCurrencyId)
                 AND FromCurrencyId = @FromCurrencyId), 1.00);  
        END  
        ELSE -- INR to Foreign Currency                
        BEGIN  
            SELECT @ROE = ISNULL(
                (SELECT TOP 1 Sales_Value FROM Currency_Con_Tab 
                 WHERE EffectiveDate = (SELECT MAX(EffectiveDate) FROM Currency_Con_Tab WHERE EffectiveDate <= @FDate 
                                        AND ToCurrencyId = @CurrentCurrencyId)
                 AND ToCurrencyId = @CurrentCurrencyId), 1.00);  
        END                
    END        
                 
    IF (@Rate IS NOT NULL AND @Rate > 0 AND @ROE <> 0)                
        SET @Rate = @Rate * @ROE;                
    ELSE IF (@Rate = '-1.00')    
        SET @Rate = -1;      
    ELSE    
        SET @Rate = -101;      
                
    RETURN @Rate;                 
END;
