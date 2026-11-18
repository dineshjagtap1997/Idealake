CREATE PROCEDURE [dbo].[QuotationSearch_Details]  
    @QuotationID NVARCHAR(50) = NULL,  
    @EnquiryID BIGINT = NULL,  
    @Currency INT = NULL,  
    @IncludingTax BIT = NULL,  
    @AgentStaffName NVARCHAR(100) = NULL,  
    @CustomerName NVARCHAR(100) = NULL,  
    @QuoteStatus INT = NULL,  
    @OperationBy UNIQUEIDENTIFIER = NULL,  
    @Action CHAR(2) = '',  
    @TaxType INT = NULL, -- Declare @TaxType parameter  
    @TaxonSale INT = NULL, -- Declare @TaxonSale parameter  
    @ParentID INT = NULL, -- Declare @ParentID parameter  
    @Disclaimer NVARCHAR(500) = NULL -- Declare @Disclaimer parameter  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    -- Clean input for string fields  
    SET @QuotationID = NULLIF(@QuotationID, '');  
    SET @AgentStaffName = NULLIF(@AgentStaffName, '');  
    SET @CustomerName = NULLIF(@CustomerName, '');  
  
    -- Status validation  
    IF @QuoteStatus IS NOT NULL AND @QuoteStatus NOT IN (0, 1, 2, 3, 4)  
    BEGIN  
        SELECT '400' AS returnCode, 'Invalid status value.' AS returnMessage;  
        RETURN;  
    END  
  
    -- Insert case (Action = 'I')  
    IF @Action = 'I'   
    BEGIN  
        -- Generate QuotationNo if not provided  
        IF @QuotationID IS NULL  
        BEGIN  
            DECLARE @Year CHAR(2) = RIGHT(CAST(YEAR(GETDATE()) AS VARCHAR(4)), 2);  
            DECLARE @NextSeq INT;  
            SELECT @NextSeq = ISNULL(MAX(CAST(SUBSTRING(QuotationNo, 3, 6) AS INT)), 0) + 1  
            FROM QuotationMasterNew  
            WHERE QuotationNo LIKE 'Q' + @Year + '%' AND LEN(QuotationNo) = 9;  
            SET @QuotationID = 'Q' + @Year + RIGHT('000000' + CAST(@NextSeq AS VARCHAR(6)), 6);  
        END  
  
        -- Check if Quotation already exists  
        IF EXISTS (SELECT 1 FROM QuotationMasterNew WHERE QuotationNo = @QuotationID)  
        BEGIN  
            SELECT '409' AS returnCode, 'Quotation already exists.' AS returnMessage;  
            RETURN;  
        END  
  
        -- Insert new quotation  
        INSERT INTO QuotationMasterNew (  
            QuotationNo, EnquiryID, Status, Currency, TaxType,   
            TaxonSale, ParentID, Disclaimer, CreatedBy, CreatedDate,   
            OperationBy  
        )  
        VALUES (  
            @QuotationID, @EnquiryID, 0, ISNULL(@Currency, 1),   
            ISNULL(@TaxType, 0), ISNULL(@TaxonSale, 0), @ParentID, @Disclaimer,   
            'System', GETDATE(), @OperationBy  
        );  
  
        SELECT '200' AS returnCode, 'Quotation created successfully.' AS returnMessage, @QuotationID AS QuotationID;  
    END  
  
    -- Update case (Action = 'U')  
    ELSE IF @Action = 'U'   
    BEGIN  
        -- Ensure Quotation exists  
        IF NOT EXISTS (SELECT 1 FROM QuotationMasterNew WHERE QuotationNo = @QuotationID)  
        BEGIN  
            SELECT '404' AS returnCode, 'Quotation not found.' AS returnMessage;  
            RETURN;  
        END  
  
        -- Prevent update of confirmed quotations without file code  
        IF EXISTS (  
            SELECT 1 FROM QuotationMasterNew   
            WHERE QuotationNo = @QuotationID   
              AND Status = 2   
        )  
        BEGIN  
            SELECT '403' AS returnCode, 'Cannot update confirmed quotation. Create a new version instead.' AS returnMessage;  
            RETURN;  
        END  
  
        -- Update quotation  
        UPDATE QuotationMasterNew  
        SET   
            EnquiryID = @EnquiryID,  
            Status = ISNULL(@QuoteStatus, Status),  -- Ensure status is updated or preserved  
            Currency = ISNULL(@Currency, Currency),  
            TaxType = ISNULL(@TaxType, 0),  -- Ensure this is assigned  
            TaxonSale = ISNULL(@TaxonSale, 0), -- Ensure this is assigned  
            ParentID = ISNULL(@ParentID, ParentID),  -- Ensure ParentID is updated  
            Disclaimer = ISNULL(@Disclaimer, Disclaimer),  -- Ensure Disclaimer is updated  
            ModifiedBy = 'System',  
            ModifiedDate = GETDATE(),  
            OperationBy = @OperationBy  
        WHERE QuotationNo = @QuotationID;  
  
        SELECT '200' AS returnCode, 'Quotation updated successfully.' AS returnMessage;  
    END  
  
    -- Search case (Action = 'S')  
    ELSE IF @Action = 'S'   
    BEGIN  
        -- Main search query with all filters  
     SELECT     
            Q.QuotationNo AS QuotationID,    
            Q.EnquiryID,    
            Q.CreatedDate AS CreatedDate,    
            Q.Status,    
            Q.Currency,    
            Q.TaxonSale,    
            Q.Disclaimer    
        FROM     
            QuotationMasterNew Q    
        WHERE     
            (@QuotationID IS NULL OR Q.QuotationNo LIKE ISNULL(@QuotationID, '') + '%')    
            AND (@EnquiryID IS NULL OR Q.EnquiryID = @EnquiryID)    
            AND (@Currency IS NULL OR Q.Currency = @Currency)    
            AND (@IncludingTax IS NULL OR Q.TaxonSale = @IncludingTax)    
            AND (@QuoteStatus IS NULL OR Q.Status = @QuoteStatus)    
            AND (@OperationBy IS NULL OR Q.OperationBy = @OperationBy)    
        ORDER BY    
            Q.CreatedDate DESC;    
    END    
    ELSE    
    BEGIN    
        SELECT '400' AS returnCode, 'Invalid action specified.' AS returnMessage;    
    END    
    END  
 