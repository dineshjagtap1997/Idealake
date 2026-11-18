<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_InsertUpdate_CurrencyCon]                          
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿--declare
--@FromCurrencyId INT = 2,                          
--    @ToCurrencyId INT = 1,                          
--    @Actual_Value DECIMAL(10,4)= 0,                          
--    @Hedge_Perc DECIMAL(5,2) = 0,                          
--    @EffectiveDate DATETIME = null,                          
--    @Purchase_Value DECIMAL(10,4) = 0,                          
--    @Sales_Value DECIMAL(10,4) = 0,                          
--    @CreatedBy INT = NULL,                          
--    @UpdatedBy INT = NULL,                          
--    @Action VARCHAR(10) ='S'   
CREATE PROCEDURE [dbo].[usp_InsertUpdate_CurrencyCon]                          
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    @FromCurrencyId INT = null,                          
    @ToCurrencyId INT = null,                          
    @Actual_Value DECIMAL(10,4)= null,                          
    @Hedge_Perc DECIMAL(5,2) = NULL,                          
    @EffectiveDate DATETIME = '',                          
    @Purchase_Value DECIMAL(10,4) = NULL,                          
    @Sales_Value DECIMAL(10,4) = NULL,                          
    @CreatedBy INT = NULL,                          
    @UpdatedBy INT = NULL,                          
    @Action VARCHAR(10)                    
AS                          
BEGIN                          
    SET NOCOUNT ON;                          
                              
    DECLARE @ExistingValue DECIMAL(10,4);                          
    DECLARE @ExistingHedge DECIMAL(5,2);                          
    DECLARE @ExistingPurchase DECIMAL(10,4);                          
    DECLARE @ExistingSales DECIMAL(10,4);                          
    DECLARE @ExistingRecord BIT = 0;                          
                          
    -- Set default EffectiveDate if NULL                          
    IF @EffectiveDate IS NULL                          
        SET @EffectiveDate = GETDATE();                          
                          
    -- Check if the record already exists                          
    SELECT                           
        @ExistingValue = Actual_Value,                           
        @ExistingHedge = Hedge_Perc,                          
        @ExistingPurchase = Purchase_Value,                          
        @ExistingSales = Sales_Value,                          
        @ExistingRecord = 1                          
    FROM Currency_Con_Tab                           
    WHERE FromCurrencyId = @FromCurrencyId AND ToCurrencyId = @ToCurrencyId and   EffectiveDate = @EffectiveDate    ;                    
                          
    IF @Action = 'I'                          
    BEGIN                          
        IF @ExistingRecord = 1                          
        BEGIN                          
            --SELECT '201' AS returnCode, 'Entry already exists for the effective date:'+ EffectiveDate as returnMessage;                    
   SELECT '199' AS returnCode, 'Entry already exists for the effective date.' AS returnMessage;                   
            RETURN;                          
        END                          
                          
        -- Insert new record into Currency_Con_Tab                          
        INSERT INTO Currency_Con_Tab                           
        (FromCurrencyId, ToCurrencyId, Actual_Value, Hedge_Perc, EffectiveDate, Purchase_Value, Sales_Value, CreatedBy, CreatedDateTime)                          
        VALUES                           
        (@FromCurrencyId, @ToCurrencyId, @Actual_Value, @Hedge_Perc, @EffectiveDate, @Purchase_Value, @Sales_Value, @CreatedBy, GETDATE());                          
                          
        -- Insert the same value into Currency_Con_History                          
        INSERT INTO Currency_Con_History                           
        (FromCurrencyId, ToCurrencyId, Actual_Value, Hedge_Perc, EffectiveDate, Purchase_Value, Sales_Value, CreatedBy, CreatedDateTime)                          
        VALUES                           
        (@FromCurrencyId, @ToCurrencyId, @Actual_Value, @Hedge_Perc, @EffectiveDate, @Purchase_Value, @Sales_Value, @CreatedBy, GETDATE());                          
                          
        SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage;                          
    END                          
    ELSE IF @Action = 'U'                          
    BEGIN                          
        IF @ExistingRecord = 0                          
        BEGIN                          
            SELECT '404' AS returnCode, 'Record not found.' AS returnMessage;                          
            RETURN;                          
        END                          
             
        -- Insert the previous values into Currency_Con_History before updating                          
        INSERT INTO Currency_Con_History                           
        (FromCurrencyId, ToCurrencyId, Actual_Value, Hedge_Perc, EffectiveDate, Purchase_Value, Sales_Value, CreatedBy, CreatedDateTime)                          
        VALUES                           
        (@FromCurrencyId, @ToCurrencyId, @ExistingValue, @ExistingHedge, @EffectiveDate, @ExistingPurchase, @ExistingSales, @UpdatedBy, GETDATE());                          
                          
        -- Update the Currency_Con_Tab table                          
        UPDATE Currency_Con_Tab                          
SET                           
            Actual_Value = @Actual_Value,                          
            Hedge_Perc = @Hedge_Perc,                          
            EffectiveDate = @EffectiveDate,                          
    Purchase_Value = @Purchase_Value,                          
            Sales_Value = @Sales_Value,                          
            UpdatedBy = @UpdatedBy,                           
      UpdatedDateTime = GETDATE()                          
        WHERE FromCurrencyId = @FromCurrencyId AND ToCurrencyId = @ToCurrencyId and   EffectiveDate = @EffectiveDate;                         
                          
        SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage;                          
    END                          
    ELSE IF @Action = 'S'                          
    BEGIN                      
  -- Select record(s)                          
        SELECT CCT.*, CM.CurrencyCode AS FROMCURRENCY, CM2.CurrencyCode AS TOCURRENCY FROM Currency_Con_Tab CCT                    
  INNER JOIN CurrencyMaster CM ON CM.ID = CCT.FromCurrencyId              
  INNER JOIN CurrencyMaster CM2 ON CM2.ID = CCT.ToCurrencyId              
      WHERE (FromCurrencyId = @FromCurrencyId or @FromCurrencyId= 0  or @FromCurrencyId is null)                        
  and (ToCurrencyId = @ToCurrencyId or @ToCurrencyId = 0 or @ToCurrencyId is null)  
  
  --and (@EffectiveDate is null or @EffectiveDate = '' or EffectiveDate= @EffectiveDate)
<<<<<<< HEAD
<<<<<<< HEAD
  order by EffectiveDate DESC
=======
  --AND EffectiveDate>=GETDATE()
  order by CCT.id DESC
>>>>>>> dev
=======
  --AND EffectiveDate>=GETDATE()
  order by CCT.id DESC
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
   END     
  
   ELSE IF @Action='EX'    
   BEGIN    
           SELECT CCT.Hedge_Perc,CCT.Actual_Value,CCT.Purchase_Value,CCT.Sales_Value, CCT.*, CM.CurrencyCode AS FROMCURRENCY, CM2.CurrencyCode AS TOCURRENCY FROM Currency_Con_Tab CCT                    
  INNER JOIN CurrencyMaster CM ON CM.ID = CCT.FromCurrencyId              
  INNER JOIN CurrencyMaster CM2 ON CM2.ID = CCT.ToCurrencyId              
    
   END    
    ELSE                          
    BEGIN                          
        SELECT '400' AS returnCode, 'Invalid Action.' AS returnMessage;                          
    END                          
END; 