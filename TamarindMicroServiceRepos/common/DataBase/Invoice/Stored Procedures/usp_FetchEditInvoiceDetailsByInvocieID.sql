

<<<<<<< HEAD
<<<<<<< HEAD

=======
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
CREATE PROCEDURE [Invoice].[usp_FetchEditInvoiceDetailsByInvocieID]                                                              
(                                                              
@InvoiceID INT,
@Action VARCHAR(1)
)                                                              
AS                                                              
BEGIN  

IF @Action='S'   
BEGIN 

SELECT 
    I.ID,
    I.InvoiceNumber,
    I.TypeOfDoc,
    I.InvoiceType,
    I.Invoice_Date,
    I.FileCode,
    I.BookingID,
<<<<<<< HEAD
<<<<<<< HEAD
    I.QuotationID,
    I.GuestName,
    I.AgentID,
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	B.CompanyID,
    I.QuotationID,
    I.GuestName,
    I.AgentID,
	AM.AgentName, 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    I.Curr_ID,
    I.Invoice_No_Of_Pax,
    I.Reference,
    I.compcode,
    I.YearCode,
    I.MiscAcc,
    I.RefNo,
    I.PreviousYear,
    I.isVoid,
    I.ConvertedInvNo,
    I.IsDirectPayment,
<<<<<<< HEAD
<<<<<<< HEAD
    I.SAC_ID AS 'SACID',
=======
    IDT.SACID AS 'SACID',
	IDT.Tax_ID,
	IDT.TCSRateID,
>>>>>>> dev
=======
    IDT.SACID AS 'SACID',
	IDT.Tax_ID,
	IDT.TCSRateID,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    I.StateCode_ID,
    I.IsTaxReverseCharge,
    I.flag,
    I.TaxIDOps,
    I.GSTIN,
    I.GST_Perc,
    I.GSTTypeID,
    I.PlaceOfSupplierId,
    I.Allocate,
    I.KindAttn,
    I.SAP_StateCode,
    I.ParentInvoiceID,
    I.SubQuotationRank,
    I.CityIATACode,
    I.flag_InvOrTktInv,
    I.IsStatewiseflag,
    I.IsBillOfSupply,
    I.IsTcsInvoice,
    I.IsBTCComm,
	I.AgentRefPO,
	IDT.Invoice_Desc_ID ,
	AD.Amount as 'AddendumTotalAmount',
	IDT.IGST,
	IDT.CGST,
	IDT.SGST,
	IDT.UTGST,

<<<<<<< HEAD
<<<<<<< HEAD
    IDT.TotalInvoiceAmount  AS 'TotalAmount',
=======
  
>>>>>>> dev
=======
  
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	IDT.TotalBasicAmount as 'TotalBasicAmount',
	IDT.TotalTaxable_Amount AS 'TotalTaxableAmount',
	IDT.TotalTax_Amount  AS 'TotalTaxAmount',
	IDT.TotalInvoiceAmount  AS 'TotalInvoiceAmount',
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	IDT.TotalBasicAmount AS 'TaxableAmount', 
	IDT.TotalAmount  AS 'TotalAmount',
	IDT.TaxableAmountDetail,
	IDT.TaxAmount, 
	IDT.TCSAmount,
	IDT.BasicAmount,
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    I.ServiceLocID,
    I.AgentRefPO,
    I.AgentRefPOCreatedBy,
    I.AgentRefPOCreatedDateTime,
    I.EXP,
    I.SEZ,
    I.isTDSDeduction,
    I.CreatedBy,
    I.CreatedDateTime,
    I.LastUpdatedBy,
    I.LastUpdateDateTime,
    I.AgentBookerName,
    I.TANNumber,
    I.PanNumber,
    I.TAXNumber,
<<<<<<< HEAD
<<<<<<< HEAD

=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	B.FileCodeGeneratedOn as 'FileCodeDate',
	HM.HotelName,
	CASE 
    WHEN VM.VendorName IS NULL THEN HM.HotelName 
    ELSE VM.VendorName END AS VendorName,
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    -- Subquery to return AddendumJson
    (
        SELECT 
            AM.AddendumID,	
            AM.AddendumNo,	
            AM.AddendumDate,	
            AM.Currency,
            AM.Amount,	
            AM.InvoiceID,
            AM.InvoiceDate,	
            AM.CreatedDate,		
            AM.UpdatedDate,	
            AM.UpdatedBy,	
            AM.YearCode,
            (
                SELECT 
                    AD.ID,
                    AD.AddendumID,
                    AD.Description,
                    AD.InvoiceID,
                    AD.Currency,
                    AD.Amount,
                    AD.CreatedDate,
                    AD.YearCode,
                    AD.UpdatedDate
                FROM [Invoice].[AddendumDetails] AD
                WHERE AD.AddendumID = AM.AddendumID
                FOR JSON PATH
            ) AS AddendumJsonDetails
        FROM [Invoice].[Addendum] AM
        WHERE AM.InvoiceID = I.ID
        FOR JSON PATH
    ) AS AddendumJson

FROM Invoice.Invoice I 
<<<<<<< HEAD
<<<<<<< HEAD
INNER JOIN Invoice.InvoiceDetails IDT ON IDT.Invoice_ID  = I.ID 
LEFT JOIN  Invoice.Addendum AD ON I.ID = AD.InvoiceID 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
LEFT JOIN Invoice.InvoiceDetails IDT ON IDT.Invoice_ID  = I.ID 
LEFT JOIN  Invoice.Addendum AD ON I.ID = AD.InvoiceID 
LEFT JOIN Booking.tbl_Booking B ON B.ID = I.BookingID 
LEFT JOIN AgentMaster AM ON I.AgentID = AM.AgentID 
LEFT JOIN HotelMaster HM ON HM.HotelID = I.HotelID 
LEFT JOIN VendorMaster VM ON VM.VendorID = I.VendorID    
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
WHERE I.ID = @InvoiceID 


 

END 

END