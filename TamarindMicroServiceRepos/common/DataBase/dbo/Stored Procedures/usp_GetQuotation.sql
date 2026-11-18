
CREATE   PROCEDURE [dbo].[usp_GetQuotation]
    @Action CHAR(1) = 'S', -- S = Search/Select
    @QuotationID NVARCHAR(50) = NULL,
    @EnquiryID BIGINT = NULL,
    @QuoteStatus INT = NULL,
    @Currency INT = NULL,
    @IncludingTax BIT = NULL,
    @OperationBy NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Action = 'S'
    BEGIN
        -- Main search query with all filters  
        SELECT   
            Q.QuotationNo AS QuotationID,  
            Q.EnquiryID,  
            Q.CreatedDate,  
            Q.Status,  
            Q.Currency,  
            Q.TaxonSale,  
            Q.Disclaimer,
            Q.ParentID,
            Q.VersionSequence,
            Q.OperationBy
        FROM QuotationMasterNew Q  
        WHERE   
            (@QuotationID IS NULL OR Q.QuotationNo LIKE ISNULL(@QuotationID, '') + '%')  
            AND (@EnquiryID IS NULL OR Q.EnquiryID = @EnquiryID)  
            AND (@Currency IS NULL OR Q.Currency = @Currency)  
            AND (@IncludingTax IS NULL OR Q.TaxonSale = @IncludingTax)  
            AND (@QuoteStatus IS NULL OR Q.Status = @QuoteStatus)  
            AND (@OperationBy IS NULL OR Q.OperationBy = @OperationBy)  
        ORDER BY Q.CreatedDate DESC;  
    END
    ELSE
    BEGIN
        SELECT '400' AS returnCode, 'Invalid action specified.' AS returnMessage;  
    END
END
