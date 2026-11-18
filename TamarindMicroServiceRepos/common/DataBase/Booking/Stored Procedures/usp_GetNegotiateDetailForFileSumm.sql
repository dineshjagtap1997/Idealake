CREATE PROCEDURE [Booking].[usp_GetNegotiateDetailForFileSumm]
	@Action char(1)='S',
	@bookingId int=0
AS
BEGIN
	
	SET NOCOUNT ON;

		IF(@Action='S')
		BEGIN

			DECLARE @CommaSeparatedRateIDs nvarchar(max)='', @BaseCurrencyCode varchar(10)='';
    
			;WITH Combined AS (
				SELECT RateId AS RateID
				FROM Booking.OthersRateCardMasterBooking 
				WHERE BookingID = @bookingId AND RateCardModeTypeID = 3

				UNION

				SELECT HotelRateID AS RateID
				FROM Booking.HotelRateCardMasterBooking 
				WHERE BookingID = @bookingId AND RateCardModeTypeID = 3
			)

			SELECT @CommaSeparatedRateIDs=
				STUFF((
					SELECT ',' + CAST(RateID AS VARCHAR)
					FROM Combined
					FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 1, '');
		
			SELECT 
				@BaseCurrencyCode = ISNULL(C.CurrencyCode, 'INR')
			FROM 
				CompanyMaster CM 
				Left JOIN Dbo.CurrencyMaster C on CM.CurrencyComp_id=C.id
			WHERE 
				CompanyID = @CompanyID;

			SELECT
				@bookingId as BookingID,
				(
					SELECT   
						u.[DocumentID],   
						u.[DocumentName],   
						u.[DocMimeType],   
						u.[Documents],   
						d.[DocumentType]
					FROM   
						[dbo].[UploadDocuments] u  
						JOIN [dbo].[LinkedDocuments] l ON u.[DocumentID] = l.[DocumentID]  
						LEFT JOIN [dbo].[DocumentType] d ON u.[DocumentTypeId] = d.[DocumentTypeId]  
					WHERE   
						l.[ParentID] IN (SELECT items from dbo.SplitCommaToTable(@CommaSeparatedRateIDs,','))
					ORDER BY 1 DESC
					FOR JSON PATH
				) 
				AS strNegoDoc,
				(
					SELECT 
						DISTINCT 
						[RefNo] as CreditNoteNo,
						FORMAT(CreatedDate, 'dd-MMM-yyyy') as CreditNoteDate,
						DocCurr as Currency, 
						convert(nvarchar,FORMAT(CAST(cast(([TotalDocAmt])as money) AS INT), 'N0', 'en-IN'))  as Amount      
					FROM SAP_ASTRA_SALES WHERE            
					[RefNo] LIKE 'CN%' AND DocType = 'DG' AND ISNULL(IsReversed,0)!= '1' 
					AND FileCode IN (    
					SELECT DISTINCT  FileCode  from Booking.tbl_Booking where ID = @bookingId)
					FOR JSON PATH
				)
				AS CreditNoteJson,
				ISNULL
				(
					(
						Select										--Revenue -- Added by Dinesh
							SUM(ID.TotalTaxable_Amount)
						from 
							Invoice.InvoiceDetails ID	
							INNER JOIN Invoice.Invoice I ON ID.Invoice_ID=I.ID
						where 
							I.BookingID=@bookingId
							AND I.TypeOfDoc=1
					),0
				)
				AS Revenue,
				ISNULL
				(
					(
						Select										--Expense  -- Added by Dinesh
							SUM(LocalCurrencyAmt)
						FROM
							dbo.XO
						WHERE 
							Qut_ID=@bookingId
							AND IsDirectPayment=0
							AND ISNULL(Undo,0)=0
					),0
				)
				AS Expense,
				MIN(@BaseCurrencyCode) AS CurrencyCode
				FOR JSON PATH;
		END

END