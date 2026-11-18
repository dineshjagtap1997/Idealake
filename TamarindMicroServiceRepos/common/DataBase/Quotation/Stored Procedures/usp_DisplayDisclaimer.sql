
CREATE PROCEDURE [Quotation].[usp_DisplayDisclaimer]
	@QuotationRateCardId int=NULL,
	@RateType int =NULL,
    @QuotationID BIGINT = NULL
AS
BEGIN
    SET NOCOUNT ON;
		BEGIN
			If(isnull(@RateType,0)=0)
				BEGIN
					Select
						QuotationID,
						isnull(Disclaimer,'NA') as Disclaimer
					FROM
						[Quotation].[QuotationMaster]
					WHERE 
						QuotationID = @QuotationID;
				END
			Else if(@RateType= 1 OR @RateType= 2 OR @RateType= 3 OR @RateType= 4)
				BEGIN
					Select
						QuotationID,
						isnull(Disclaimer,'NA') as Disclaimer
					FROM
						Quotation.OthersRateCardMaster
					WHERE 
						ID=@QuotationRateCardId
						AND RateType=@RateType
						AND QuotationID = @QuotationID;
				END
			Else if(@RateType= 5)
				BEGIN
					Select
						QuotationID,
						isnull(Disclaimer,'NA') as Disclaimer
					FROM
						Quotation.HotelRateCardMaster
					WHERE 
						ID=@QuotationRateCardId
						AND QuotationID = @QuotationID;
				END
		END
END
