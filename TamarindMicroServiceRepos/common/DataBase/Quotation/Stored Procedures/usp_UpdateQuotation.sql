
CREATE PROCEDURE [Quotation].[usp_UpdateQuotation]
	@QuotationRateCardId int=NULL,
	@RateType int =NULL,
    @QuotationID BIGINT = NULL,
    @Disclaimer NVARCHAR(500) = NULL,
	@Status INT=NULL,
    @CreatedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON;
		BEGIN
			If(isnull(@RateType,0)=0)
				BEGIN
					UPDATE [Quotation].[QuotationMaster]
					SET
						Disclaimer = Isnull(@Disclaimer,Disclaimer),
						--Status=Isnull(@Status,Status),
						UpdatedBy = @CreatedBy,
						UpdatedDate = GETDATE()
					WHERE 
						QuotationID = @QuotationID;
				END
			Else if(@RateType= 1 OR @RateType= 2 OR @RateType= 3 OR @RateType= 4)
				BEGIN
					UPDATE Quotation.OthersRateCardMaster
					SET
<<<<<<< HEAD
<<<<<<< HEAD
						Disclaimer = Isnull(@Disclaimer,Disclaimer),
=======
						Disclaimer = @Disclaimer,
>>>>>>> dev
=======
						Disclaimer = @Disclaimer,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						UpdatedBy = @CreatedBy,
						UpdatedOn = GETDATE()
					WHERE 
						ID=@QuotationRateCardId
						AND RateType=@RateType
						AND QuotationID = @QuotationID;
				END
			Else if(@RateType= 5)
				BEGIN
					UPDATE Quotation.HotelRateCardMaster
					SET
						Disclaimer = Isnull(@Disclaimer,Disclaimer),
						
						UpdatedBy = @CreatedBy,
						UpdatedOn = GETDATE()
					WHERE 
						ID=@QuotationRateCardId
						AND QuotationID = @QuotationID;
				END
			
			SELECT 
				'200' AS returnCode,
				'Disclaimer added successfully' AS returnMessage,
				@QuotationID AS ID;
		END
END
