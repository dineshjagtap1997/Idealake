<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [Invoice].[usp_FetchInvoiceDataByQuotationID]                                                              
=======
﻿
CREATE PROCEDURE [Invoice].[usp_FetchInvoiceDataByQuotationID]                                                              
>>>>>>> dev
=======
﻿
CREATE PROCEDURE [Invoice].[usp_FetchInvoiceDataByQuotationID]                                                              
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
(                                                              
@BookingID INT,
@Action VARCHAR(1)
)                                                              
AS                                                              
BEGIN                                                              

 IF @Action = 'S'  
 BEGIN
<<<<<<< HEAD
<<<<<<< HEAD
		
SELECT DISTINCT I.ID,
I.InvoiceNumber AS 'InvoiceNumber', I.PlaceOfSupplierId , SCM.State_Code  AS PlaceOfSupplier, 
I.Invoice_Date,I.Curr_ID, C.Name as Currency, ID.TotalInvoiceAmount as TotalInvoiceAmount , I.ConvertedInvNo     
,case when IRN.Status = 1 then 'Yes' else 'No' end AS 'IRN'  
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6


 --DECLARE @isSEZ VARCHAR(10)
 --SELECT @isSEZ = isSEZ from AgentMaster Where AgentID  = (SELECT AgentID from [Invoice].Invoice where  BookingID=CAST (@BookingID AS bigint ))
		
SELECT DISTINCT I.ID,
I.InvoiceNumber AS 'InvoiceNumber', I.PlaceOfSupplierId , SCM.State_Code  AS PlaceOfSupplier, 
I.Invoice_Date,I.Curr_ID, C.CurrencyCode as Currency, ID.TotalInvoiceAmount as TotalInvoiceAmount , I.ConvertedInvNo     
,case when IRN.Status = 1 then 'Yes' else 'No' end AS 'IRN' , I.TypeOfDoc  
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
,I.isVoid, '' as InvoiceStatus , I.InvoiceType as [Status], I.AgentRefPO 
--,ISNULL(IRN.Messages,'No Data') as 'Messages'      
 , CASE 
    WHEN [EXP] = 1 THEN 'E'
    WHEN [SEZ] = 1 THEN 'S'
    ELSE NULL
<<<<<<< HEAD
<<<<<<< HEAD
END AS EXPSEZ      , I.BookingID 
                                    
FROM [Invoice].Invoice I 
LEFT JOIN [Invoice].InvoiceDetails ID ON I.ID = ID.Invoice_ID  
LEFT JOIN Currency C ON C.CurrencyID = I.Curr_ID                                           
LEFT JOIN Invoice_New_IRN_SuperTaxJob_Details IRN ON  I.ID=TRY_CAST(IRN.InvoiceID AS bigint) AND  I.YearCode = TRY_CAST(IRN.YearCode AS INT)        
LEFT JOIN State_Code_Master SCM ON I.PlaceOfSupplierId = SCM.ID                                   
WHERE BookingID=CAST (@BookingID AS bigint ) order by ID DESC --and (isTCSInvoice = 0 or isTCSInvoice is null)                                                       
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END AS EXPSEZ      , I.BookingID ,
I.QuotationID
                                    
FROM [Invoice].Invoice I 
LEFT JOIN [Invoice].InvoiceDetails ID ON I.ID = ID.Invoice_ID  
LEFT JOIN CurrencyMaster C ON C.id = I.Curr_ID                                           
LEFT JOIN Invoice_New_IRN_SuperTaxJob_Details IRN ON  I.ID=TRY_CAST(IRN.InvoiceID AS bigint) AND  I.YearCode = TRY_CAST(IRN.YearCode AS INT)        
LEFT JOIN State_Code_Master SCM ON I.PlaceOfSupplierId = SCM.ID                                   
WHERE BookingID=CAST (@BookingID AS bigint ) and I.InvoiceNumber != ''   order by ID DESC --and (isTCSInvoice = 0 or isTCSInvoice is null)                                                       
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
--AND Type_Of_Doc='Invoice' and flag_InvOrTktInv = 'Invoice'                                   
                                                              
--SELECT INV.ID,INV.Invoice_ID,Invoice_Desc,Invoice_Value,INVD.YearCode,CAST(NULL AS INT)RowID,Taxable_Amount,Tax_Amount                                                               
--FROM [Invoice].[InvoiceDetails] INVD                                                              
--INNER JOIN Invoice_New INV ON INV.Invoice_ID = INVD.Invoice_ID AND INVD.YearCode = INV.YearCode                                            
--WHERE Qut_ID=@QuotationID                                                            
                     
  
 END 

END 