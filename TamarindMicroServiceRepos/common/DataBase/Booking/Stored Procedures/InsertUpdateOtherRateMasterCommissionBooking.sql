
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [Booking].[InsertUpdateOtherRateMasterCommissionBooking] 
(
  @QuotationID BIGINT, 
  @Action VARCHAR(1)

)
AS
BEGIN


INSERT INTO [Booking].[OthersRateCardMasterBooking]
           ([RateId]
           ,[ServiceID]
           ,[RateType]
           ,[CardNumber]
           ,[Heading]
           ,[ContractDate]
           ,[RateCardModeTypeID]
           ,[CurrencyID]
           ,[VendorID]
           ,[CityID]
           ,[StateID]
           ,[GstStatus]
           ,[InfoForOperation]
           ,[InfoForAgent]
           ,[InfoForRemark]
           ,[IsActive]
           ,[CreatedOn]
           ,[UpdatedOn]
           ,[CreatedBy]
           ,[UpdatedBy]
           ,[LanguageID]
           ,[Notes]
           ,[HotelID]
           ,[HrsPerDay]
           ,[KmPerDay]
           ,[TransportModeTypeID]
           ,[HotelZone]
           ,[CityID2]
           ,[ReferenceRateDetailID]
           ,[TaxID]
           ,[ValidFrom]
           ,[ValidTo]
           ,[MISSequence]
           ,[NationalityID]
           ,[RatePreferenceID]
           ,[VehicleCategoryID]
           ,[QuotationID]
           ,[Disclaimer]
           ,[ReasonID]) 

		   SELECT  
			   [RateId]
			  ,[ServiceID]
			  ,[RateType]
			  ,QM.QuotationNo 
			  ,[Heading]
			  ,[ContractDate]
			  ,[RateCardModeTypeID]
			  ,[CurrencyID]
			  ,[VendorID]
			  ,[CityID]
			  ,[StateID]
			  ,[GstStatus]
			  ,[InfoForOperation]
			  ,[InfoForAgent]
			  ,[InfoForRemark]
			  ,[IsActive]
			  ,[CreatedOn]
			  ,[UpdatedOn]
			  ,ORM.[CreatedBy]
			  ,ORM.[UpdatedBy]
			  ,[LanguageID]
			  ,[Notes]
			  ,[HotelID]
			  ,[HrsPerDay]
			  ,[KmPerDay]
			  ,[TransportModeTypeID]
			  ,[HotelZone]
			  ,[CityID2]
			  ,[ReferenceRateDetailID]
			  ,[TaxID]
			  ,[ValidFrom]
			  ,[ValidTo]
			  ,[MISSequence]
			  ,[NationalityID]
			  ,[RatePreferenceID]
			  ,[VehicleCategoryID]
			  ,ORM.[QuotationID]
			  ,ORM.[Disclaimer]
			  ,[ReasonID]
		  FROM [Quotation].[OthersRateCardMaster] ORM 
		  LEFT JOIN [Quotation].[QuotationMaster] QM ON 
		  ORM.QuotationID = QM.QuotationID 
		  Where QM.QuotationID = @QuotationID 


		  INSERT INTO [Booking].[OthersRateCardCommissionBooking]
           ([CommissionRefrenceID]
           ,[RateID]
           ,[CommissionMasterID]
           ,[MinimumPax]
           ,[MaximumPax]
           ,[IsAmtIncludedInBasic]
           ,[TaxPercentage]
           ,[TaxAmount]
           ,[NetAmountExcludingTax]
           ,[NetAmountIncludingTax]
           ,[Markup_IsRate]
           ,[NetRate]
           ,[SellingRates]
           ,[IsActive]
           ,[OthersRateRefrenceID]
           ,[MarkupRate]
           ,[GrossRate])

		   SELECT 
		   [CommissionRefrenceID]
		  ,ORCC.[RateID]
		  ,[CommissionMasterID]
		  ,[MinimumPax]
		  ,[MaximumPax]
		  ,[IsAmtIncludedInBasic]
		  ,[TaxPercentage]
		  ,[TaxAmount]
		  ,[NetAmountExcludingTax]
		  ,[NetAmountIncludingTax]
		  ,[Markup_IsRate]
		  ,[NetRate]
		  ,[SellingRates]
		  ,ORCC.[IsActive]
		  ,[OthersRateRefrenceID]
		  ,[MarkupRate]
		  ,[GrossRate]
	  FROM [Quotation].[OthersRateCardMaster] ORM 
	   INNER JOIN [Quotation].[OthersRateCardCommission] ORCC ON ORM.ID= ORCC.OthersRateRefrenceID 
		  LEFT JOIN [Quotation].[QuotationMaster] QM ON 
		  ORM.QuotationID = QM.QuotationID 
		  Where QM.QuotationID = @QuotationID 
	  
	  





END
