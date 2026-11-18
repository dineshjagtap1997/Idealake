Create PROCEDURE [Quotation].[GetQuoVersion]
(
    @QuotationID INT,
    @Action VARCHAR(1)
)
AS
BEGIN

IF @Action = 'S'
BEGIN
SELECT 
    QuotationID,
    QuotationNo,
    QuotationSequence
FROM 
    [Quotation].[QuotationMaster]
WHERE 
    QuotationID = @QuotationID OR ParentID = @QuotationID;
	END

End