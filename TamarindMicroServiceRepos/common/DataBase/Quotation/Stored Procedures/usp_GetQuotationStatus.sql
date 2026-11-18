CREATE procedure [Quotation].[usp_GetQuotationStatus]
	@Action char(1)=null
AS
BEGIN
IF @Action = 'S'
	select 
		StatusCode AS  StatusID,
		StatusName,
		ColourCode  
	from 
		Quotation.QuotationStatus
END