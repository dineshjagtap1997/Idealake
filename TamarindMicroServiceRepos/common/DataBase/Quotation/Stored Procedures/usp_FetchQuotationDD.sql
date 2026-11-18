CREATE PROCEDURE [Quotation].[usp_FetchQuotationDD]
   @Action CHAR(1)-- 'I', 'U', 'S', or 'SA'
AS
begin
	IF(@Action='S')
	BEGIN
		SELECT 
			Q.QuotationID,
			CASE 
			    WHEN Q.Status = 1 THEN CONCAT('D-', Q.QuotationNo)
			    ELSE Q.QuotationNo
			END AS QuotationNo
			
		FROM 
			[Quotation].[QuotationMaster] Q
			INNER JOIN [Quotation].[QuotationStatus] QS ON Q.Status = QS.StatusCode
		where 
			isnull(Q.Status,0)<>0
	END
end
