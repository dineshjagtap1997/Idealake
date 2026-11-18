CREATE procedure [Quotation].[usp_DeleteRateCard]
	@ID int=null,
	@RateType int=null,
	@Action char(1)=null,
	@QuotationHotelRateCommissionId BIGINT = NULL
as
begin
	If(@RateType=1 OR @RateType=2 OR @RateType=3 OR @RateType=4)
		BEGIN
			Update Quotation.OthersRateCardCommission set IsActive=0 where OthersRateRefrenceID=@ID

			Update Quotation.OthersRateCardMaster set IsActive=0 where ID=@ID

			SELECT 
				'200' AS returnCode,
				'Delete Rate Card Successfully' AS returnMessage,
				CAST(@ID AS VARCHAR) AS ID;
		END
	ELSE IF(@RateType=5)
		BEGIN
			

			IF (@QuotationHotelRateCommissionId= NULL OR @QuotationHotelRateCommissionId=0)
			BEGIN 
			Update Quotation.HotelRateCommissionDetails set IsActive=0 where QuotationHotelRateID=@ID
			Update Quotation.HotelRateMealPlanMaster set IsActive=0 where QuotationHotelRateID=@ID
			Update Quotation.HotelRateCardMaster set IsActive=0 where ID=@ID
			END
			

			update Quotation.HotelRateCommissionDetails SET IsActive=0  where QuotationHotelRateID=@ID and QuotationHotelRateCommissionId= @QuotationHotelRateCommissionId

			SELECT 
				'200' AS returnCode,
				'Delete Rate Card Successfully' AS returnMessage,
				CAST(@ID AS VARCHAR) AS ID;
		END
end