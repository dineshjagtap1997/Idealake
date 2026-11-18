-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE usp_GetInvoiceDetailsForSAPJobApplicable   
(  
@InvFromDate datetime,  
@InvToDate datetime   
)  
  
AS  
BEGIN   
  
  
set  @InvFromDate = '2023-01-12'   
set @InvToDate = '2023-01-12'  
  
 DECLARE @runtime datetime  
  set @runtime = (SELECT SAP_InvoiceDate FROM SAP_InvoiceJobTime)  
    
  
    
select '1000' as 'CompanyCode', INV.Agent_ID as 'Customer Code', Convert(Varchar, INV.Invoice_Date, 104)  as 'Invoice Date',Convert(Varchar, INV.Invoice_Date, 104) AS 'PostingDate', INV.Invoice_ID as 'Document Number( Astra)',ST.SAPCode as 'Tax Code', SAC
.Code AS 'SAC', SCM.[2DigitCode] as 'Place of Supply', CM.SAP_BusinessPlaceCode  AS 'Business Place', REPLACE(REPLACE(REPLACE(INV.Customer_Name, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') AS 'Item Text (Passenger Name)',   REPLACE(REPLACE(REPLACE(INV.Curr_ID, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') AS 'Curr', INV.Invoice_Exchg_Rate  
 AS 'ROE', IND.TotalBaseFare AS 'Basic Amount', IND.Taxable_Amount AS 'Taxable Amount', INV.File_ID  AS 'File Code',   
 AM.AgentCode AS 'Primary Customer Code', INV.Reference AS 'AgentBookerName', INV.IsDirectPayment AS 'IsDpCommInvoice', ISNULL(INV.IsBTCComm,0) AS 'IsBTCCommInvoice', CM.CityIATACode as 'Invoice location', INV.Commercial_ID as 'Commercial ID', REPLACE(REPLACE(IND.Invoice_Desc, CHAR(13), ''), CHAR(10), '')  AS  'Service Desc',  '' as 'TCS appl',  
  --INV.TCSValue as 'TCS amount' , IND.CGST, IND.SGST,IND.IGST,  (select TOP 1 Tax_Percentage from OtherServiceTaxNew WHERE ST_Tax_ID = IND.Tax_ID ) AS 'TAX Rate'   
  CASE WHEN ISNULL(INV.TCSValue,'0.00') = '0.00' THEN '' ELSE CAST(INV.TCSValue AS VARCHAR(50)) END AS 'TCS amount',   
  CASE WHEN ISNULL(IND.CGST,'0.00') = '0.00' THEN '' ELSE CAST(IND.CGST AS VARCHAR(50)) END AS CGST,   
  CASE WHEN ISNULL(IND.SGST,'0.00') = '0.00' THEN '' ELSE  CAST(IND.SGST AS VARCHAR(50)) END AS SGST,  
  CASE WHEN ISNULL(IND.IGST,'0.00') = '0.00' THEN '' ELSE  CAST(IND.IGST AS VARCHAR(50)) END AS IGST,   
   (select TOP 1  CASE WHEN CAST(ISNULL(Tax_Percentage,'0.00') AS DECIMAL(18,2)) = '0.00' THEN '' ELSE CAST(Tax_Percentage AS VARCHAR(50))  END  from OtherServiceTaxNew WHERE ST_Tax_ID = IND.Tax_ID ) AS 'TAX Rate'   
 from Invoice_New INV INNER JOIN Invoice_Detail_New IND with (NOLOCK) ON INV.ID = IND.Parent_ID   
 INNER JOIN CompanyMaster CM with (NOLOCK) ON INV.Compcode = CM.CompanyID   
 LEFT JOIN Quotation QM with (NOLOCK) ON QM.QuotationID = INV.Qut_ID  
 Inner join AgentMaster AM with (NOLOCK) ON QM.AgentID = AM.AgentID   
  left join SAC_Master SAC with (NOLOCK) ON IND.SACID = SAC.ID   
 left join State_Code_Master SCM with (NOLOCK) ON INV.PlaceOfSupplierId = SCM.ID   
 INNER JOIN ServiceTaxNew ST with (NOLOCK) ON IND.Tax_ID = ST.Tax_ID WHERE   --INV.CreatedDateTime >= @runtime AND   
 cast (INV.CreatedDateTime as date) between Cast (@InvFromDate as date) and CAST (@InvToDate as date) AND   
 (INV.Commercial_ID is not null  and INV.Invoice_ID !='' AND ISNULL(INV.IsStateWiseflag,0) != 1)   
     
  
  
  
  
  
END  