CREATE PROCEDURE [dbo].[usp_CurrencyConversionMaster]            
(            
    @Action CHAR(2) = '',                 
    @ID INT = NULL,                      
    @CCParentID INT = NULL,
    @FromCurrency VARCHAR(5) = NULL,      
    @ToCurrency VARCHAR(5) = NULL,        
    @FromDate DATE = NULL,               
    @ToDate DATE = NULL,                 
    @PurchaseRate_FTI DECIMAL(18, 5) = NULL, 
    @PurchaseRate_ITF DECIMAL(18, 5) = NULL, 
    @SalesRate_FTI DECIMAL(18, 5) = NULL,    
    @SalesRate_ITF DECIMAL(18, 5) = NULL,    
    @CostingRate_FTI DECIMAL(18, 5) = NULL,  
    @CostingRate_ITF DECIMAL(18, 5) = NULL,  
    @IsActive BIT = NULL,                
    @OperationBy UNIQUEIDENTIFIER = NULL 
)            
AS            
BEGIN            
    SET NOCOUNT ON;            

    DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);            

    -- Select Operation            
    IF @Action = 'S'            
    BEGIN            
        SELECT ID, CCParentID, FromCurrency, ToCurrency, FromDate, ToDate,
               PurchaseRate_FTI, PurchaseRate_ITF, SalesRate_FTI, SalesRate_ITF, 
               CostingRate_FTI, CostingRate_ITF, IsActive
        FROM CurrencyConversion_N    
        WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)      
        ORDER BY OperationOn DESC;            
        RETURN;
    END

    ELSE IF @Action = 'EX'
    BEGIN
        SELECT FromCurrency, ToCurrency, FromDate, ToDate,
               PurchaseRate_FTI, PurchaseRate_ITF, SalesRate_FTI, SalesRate_ITF,
               CostingRate_FTI, CostingRate_ITF,
               CASE WHEN IsActive = 1 THEN 'True' ELSE 'False' END AS IsActive
        FROM CurrencyConversion_N    
        WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)      
        ORDER BY OperationOn DESC;  
        RETURN;
    END

    -- Insert Operation            
    ELSE IF @Action = 'I'            
    BEGIN            
        IF EXISTS (
            SELECT 1 FROM CurrencyConversion_N
            WHERE ((@FromDate BETWEEN FromDate AND ToDate) OR 
                   (@ToDate BETWEEN FromDate AND ToDate) OR
                   (FromDate BETWEEN @FromDate AND @ToDate) OR
                   (ToDate BETWEEN @FromDate AND @ToDate))
              AND FromCurrency = @FromCurrency
              AND ToCurrency = @ToCurrency
        )
        BEGIN            
            SET @ReturnCode = '201';            
            SET @ReturnMessage = 'Please verify Timespans.';                    
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;        
            RETURN;
        END            

        INSERT INTO CurrencyConversion_N
        (
            CCParentID, FromCurrency, ToCurrency, FromDate, ToDate,
            PurchaseRate_FTI, PurchaseRate_ITF, SalesRate_FTI, SalesRate_ITF,
            CostingRate_FTI, CostingRate_ITF, IsActive,
            Operation, OperationBy, OperationOn
        )
        VALUES 
        (
            @CCParentID, @FromCurrency, @ToCurrency, @FromDate, @ToDate,
            @PurchaseRate_FTI, @PurchaseRate_ITF, @SalesRate_FTI, @SalesRate_ITF,
            @CostingRate_FTI, @CostingRate_ITF, @IsActive,
            'Insert', @OperationBy, GETDATE()
        );

        SET @ID = SCOPE_IDENTITY();    
        SET @ReturnCode = '200';            
        SET @ReturnMessage = 'New record added successfully.';          
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @ID AS ID;       
        RETURN;
    END            

    -- Update Operation            
    ELSE IF @Action = 'U'            
    BEGIN            
        IF EXISTS (
            SELECT 1 FROM CurrencyConversion_N
            WHERE ((@FromDate BETWEEN FromDate AND ToDate) OR 
                   (@ToDate BETWEEN FromDate AND ToDate) OR
                   (FromDate BETWEEN @FromDate AND @ToDate) OR
                   (ToDate BETWEEN @FromDate AND @ToDate))
              AND FromCurrency = @FromCurrency
              AND ToCurrency = @ToCurrency
              AND ID != @ID
        )
        BEGIN            
            SET @ReturnCode = '201';            
            SET @ReturnMessage = 'Please verify Timespans.';                    
            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;        
            RETURN;
        END            

        UPDATE CurrencyConversion_N            
        SET CCParentID = @CCParentID,
            FromCurrency = @FromCurrency,            
            ToCurrency = @ToCurrency,            
            FromDate = @FromDate,            
            ToDate = @ToDate,            
            PurchaseRate_FTI = @PurchaseRate_FTI,            
            PurchaseRate_ITF = @PurchaseRate_ITF,            
            SalesRate_FTI = @SalesRate_FTI,            
            SalesRate_ITF = @SalesRate_ITF,            
            CostingRate_FTI = @CostingRate_FTI,            
            CostingRate_ITF = @CostingRate_ITF,            
            IsActive = @IsActive,            
            Operation = 'Update',           
            UpdatedBy = @OperationBy,          
            UpdatedOn = GETDATE()          
        WHERE ID = @ID;            

        SET @ReturnCode = '200';            
        SET @ReturnMessage = 'Record updated successfully.';                    
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @ID AS ID;            
        RETURN;
    END            

    -- Invalid Action            
    ELSE            
    BEGIN            
        SET @ReturnCode = '400';            
        SET @ReturnMessage = 'Invalid Action Flag';                    
        SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;            
        RETURN;
    END            
END
