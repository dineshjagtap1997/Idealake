
  --ALTER Proc [dbo].[USP_GetInvoiceReport_NewBreakup]  -- 'IN000006BOM','427046'      
    
CREATE PROC [dbo].[USP_GetInvoiceReportNewHorizontalOne]  --'23IN000274BOM', '523820'                       
(                                                                                      
 @InvoiceID VARCHAR(50),                                                                                      
 @QuotationID INT                                                                                      
)                                                                                      
AS                                                                                                        
BEGIN                                          
  
 DECLARE @Tax_id INT                                     
 DECLARE @YearCode INT                                     
 DECLARE @Invoice_date datetime                                      
 DECLARE @KKTTaxDesc VARCHAR(MAX) =''                                      
 DECLARE @KKTTaxAmount VARCHAR(MAX)                               
 DECLARE @KKTTaxPerc NUMERIC(18, 2)                              
 DECLARE @OtherTaxDesc VARCHAR(MAX) =''                                                   
 DECLARE @SBTTaxAmount VARCHAR(MAX)=NULL                                             
 DECLARE @OtherTaxPerc NUMERIC(18, 2)=NULL                     
 DECLARE @CGSTTaxDesc VARCHAR(MAX)=''                                      
 DECLARE @CGSTTaxAmount VARCHAR(MAX)                               
 DECLARE @CGSTTaxPerc NUMERIC(18, 2)                     
 DECLARE @SGSTTaxDesc VARCHAR(MAX) =''                                      
 DECLARE @SGSTTaxAmount VARCHAR(MAX)                               
 DECLARE @SGSTTaxPerc NUMERIC(18, 2)                                                  
 DECLARE @IGSTTaxDesc VARCHAR(MAX) =''                                      
 DECLARE @IGSTTaxAmount VARCHAR(MAX)                               
 DECLARE @IGSTTaxPerc NUMERIC(18, 2)    
 
    DECLARE @VirtualAccountNumber varchar(1000)   
	DECLARE @ExistingAccountNumber varchar(1000)   
	DECLARE @DisplayAccountNumber varchar(1000)  
	DECLARE @DisplayVirtualAccountName varchar(1000)             
	DECLARE @DisplayVirtualAccountDetails varchar(5000)
	DECLARE @DisplayExistingAccountName varchar(1000)             
	DECLARE @DisplayExistingAccountDetails varchar(5000)    
	DECLARE @DisplayAccountName varchar(1000)             
	DECLARE @DisplayAccountDetails varchar(5000)  
	
	DECLARE @ExistingAccountNumberRedDOT varchar(1000)  
	DECLARE @DisplayExistingAccountNameRedDOT varchar(1000) 
	DECLARE @DisplayExistingAccountDetailsRedDOT varchar(5000)    
	
	DECLARE @BizVerticalRedDot varchar(5)  
	DECLARE @AddressCountryRedDot varchar(50)  
	DECLARE @AddressonRecordRedDot varchar(50)  
	DECLARE @InvCurrRedDot varchar(50)  
	DECLARE @IsRedDotBankDetails varchar(50)  
	DECLARE @IsRedDotPrint varchar(50)  
	DECLARE @RedDotCompany varchar(500)
	DECLARE @IsTDSChecked varchar(5)
  
 SELECT @Tax_id=Tax_ID,@Invoice_date=I.Invoice_Date,@YearCode=I.YearCode                     
 FROM   Invoice I  WHERE  I.Invoice_ID = @InvoiceID  AND Qut_ID = @QuotationID  
 
 DECLARE @IsRedDotCompany varchar(10)
 SELECT @IsRedDotCompany = SAP_CompanyCode  from CompanyMaster  WHERE CompanyID IN (SELECT CompanyID from Quotation where QuotationID = @QuotationID )
 print '@IsRedDotCompany'
 print @IsRedDotCompany
  
 SELECT @BizVerticalRedDot = Q.BussinessModuleID, @AddressCountryRedDot = AM.AddressCountry,
  @AddressonRecordRedDot = AM.AddressExist, @InvCurrRedDot = I.Curr_ID , @IsRedDotBankDetails = BM.isRedDot , @IsTDSChecked = I.isTDSDeduction 
  FROM Invoice_New I   
 INNER JOIN Quotation Q ON Q.QuotationID = I.Qut_ID 
 LEFT JOIN AgentMaster AM ON AM.AgentCode = I.Agent_ID    
 LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency   and BM.isActive = 1 
 WHERE I.Invoice_ID = @InvoiceID  AND Qut_ID = @QuotationID  
 
 
 IF(@BizVerticalRedDot = '9' AND @AddressCountryRedDot = 'IN' AND @AddressonRecordRedDot = '1' AND @InvCurrRedDot = 'INR'  AND  @IsRedDotBankDetails = '1' )
 BEGIN
     set @IsRedDotPrint = '1'
 END
 ELSE
 BEGIN
	set  @IsRedDotPrint = '0'
 END
  
  
 SELECT TOP 1 @ExistingAccountNumberRedDOT =  BM.AccountNo , @DisplayExistingAccountNameRedDOT=  BM.AccountName,@DisplayExistingAccountDetailsRedDOT = BM.Details  from Invoice_New I  
INNER JOIN Quotation Q ON Q.QuotationID = I.Qut_ID  
LEFT JOIN AgentMaster AM ON AM.AgentCode = I.Agent_ID 
LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency AND BM.isActive = 1 AND BM.IsRedDot= 1   
WHERE I.Invoice_ID = @InvoiceID AND Q.QuotationID = @QuotationID   
 
 SELECT TOP 1 @VirtualAccountNumber = BM.AccountPrefix + Q.FileCode, @DisplayVirtualAccountName=  BM.AccountName,@DisplayVirtualAccountDetails = BM.Details  from Invoice_New I 
INNER JOIN Quotation Q ON Q.QuotationID = I.Qut_ID  
LEFT JOIN AgentMaster AM ON AM.AgentCode = I.Agent_ID 
LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency   and BM.isActive = 1  
AND BM.IsVirtualAccount = 1 AND AM.VirtualAccount = 1 
WHERE I.Invoice_ID = @InvoiceID AND Q.QuotationID = @QuotationID   

 SELECT TOP 1 @ExistingAccountNumber =  BM.AccountNo , @DisplayExistingAccountName=  BM.AccountName,@DisplayExistingAccountDetails = BM.Details  from Invoice_New I  
INNER JOIN Quotation Q ON Q.QuotationID = I.Qut_ID  
LEFT JOIN AgentMaster AM ON AM.AgentCode = I.Agent_ID 
LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency AND BM.isActive = 1  
WHERE I.Invoice_ID = @InvoiceID AND Q.QuotationID = @QuotationID 

  if(@VirtualAccountNumber != '') 
  begin
  select @DisplayAccountNumber = @VirtualAccountNumber
  select @DisplayAccountName = @DisplayVirtualAccountName
  select @DisplayAccountDetails = @DisplayVirtualAccountDetails
  end   
  else
  begin
   select @DisplayAccountNumber = @ExistingAccountNumber
   select @DisplayAccountName = @DisplayExistingAccountName
  select @DisplayAccountDetails = @DisplayExistingAccountDetails
  end  

	if(@IsRedDotPrint = '1') 
	  begin
	  select @DisplayAccountNumber = @ExistingAccountNumberRedDOT 
	  select @DisplayAccountName = @DisplayExistingAccountNameRedDOT 
	  select @DisplayAccountDetails = @DisplayExistingAccountDetailsRedDOT 
	  end  
	else
	begin
	    print 'NOT RedDOT'
	end
-- SELECT @ExistingAccountNumberwithBankVirtual = BM.AccountNo  from Invoice_New I 
--INNER JOIN Quotation Q ON Q.QuotationID = I.Qut_ID  
--LEFT JOIN AgentMaster AM ON AM.AgentCode = I.Agent_ID 
--LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency AND BM.isActive = 1  
--AND BM.IsVirtualAccount = 1 
--WHERE I.Invoice_ID = @InvoiceID AND Q.QuotationID = @QuotationID 

                                 
  
 --OTHER(SBT) TAX DESC==============================                                   
 SELECT @OtherTaxDesc= ISNULL(Tax_Desc,'') + ' @ '+ CAST(ISNULL(Tax_Percentage,0) AS VARCHAR(10)) ,@OtherTaxPerc=ISNULL(Tax_Percentage,0)                              
 FROM OtherServiceTax                      
 WHERE Tax_Type in(SELECT Tax_Type from ServiceTax WHERE Tax_ACCode in(@Tax_id)) AND Other_Tax_Id=1                                   
 AND @Invoice_date  BETWEEN CONVERT(datetime,Tax_From_Date,112) AND CONVERT(datetime,Tax_To_Date,112) and IsActive=1                                      
  
 print @OtherTaxDesc                               
 --KKT TAX DESC==============================                                   
 SELECT                               
 @KKTTaxDesc= ISNULL(Tax_Desc,'') + ' @ '+ CAST(ISNULL(Tax_Percentage,0) AS VARCHAR(10)) ,                              
 @KKTTaxPerc=ISNULL(Tax_Percentage,0)                              
 FROM OtherServiceTax                                     
 WHERE Tax_Type in(SELECT Tax_Type from ServiceTax WHERE Tax_ACCode in(@Tax_id))                                    
 AND @Invoice_date  BETWEEN CONVERT(datetime,Tax_From_Date,112) AND CONVERT(datetime,Tax_To_Date,112) and IsActive=1                                      
 AND Other_Tax_Id=2 --2 For Kisan Tax                                        
  
 --KKT TAX DESC==============================                                   
 SELECT                               
 @KKTTaxDesc= ISNULL(Tax_Desc,'') + ' @ '+ CAST(ISNULL(Tax_Percentage,0) AS VARCHAR(10)) ,                              
 @KKTTaxPerc=ISNULL(Tax_Percentage,0)                              
 FROM OtherServiceTax      
 WHERE Tax_Type in(SELECT Tax_Type from ServiceTax WHERE Tax_ACCode in(@Tax_id))                                    
 AND @Invoice_date  BETWEEN CONVERT(datetime,Tax_From_Date,112) AND CONVERT(datetime,Tax_To_Date,112) and IsActive=1                                      
 AND Other_Tax_Id=2 --2 For Kisan Tax                      
  
 --CGST TAX DESC==============================                                   
 SELECT                               
 @CGSTTaxDesc= ISNULL(Tax_Desc,'') + ' @ '+ CAST(ISNULL(Tax_Percentage,0) AS VARCHAR(10)) ,                   
 @CGSTTaxPerc=ISNULL(Tax_Percentage,0)                              
 FROM OtherServiceTax                                     
 WHERE Tax_Type in(SELECT Tax_Type from ServiceTax WHERE Tax_ACCode in(@Tax_id))                                    
 AND @Invoice_date  BETWEEN CONVERT(datetime,Tax_From_Date,112) AND CONVERT(datetime,Tax_To_Date,112) and IsActive=1                                      
 AND Other_Tax_Id=3 --2 For CGST Tax                     
  
 --SGST TAX DESC==============================                 
 SELECT                               
 @SGSTTaxDesc= ISNULL(Tax_Desc,'') + ' @ '+ CAST(ISNULL(Tax_Percentage,0) AS VARCHAR(10)) ,                              
 @SGSTTaxPerc=ISNULL(Tax_Percentage,0)                              
 FROM OtherServiceTax                                     
 WHERE Tax_Type in(SELECT Tax_Type from ServiceTax WHERE Tax_ACCode in(@Tax_id))                                    
 AND @Invoice_date  BETWEEN CONVERT(datetime,Tax_From_Date,112) AND CONVERT(datetime,Tax_To_Date,112) and IsActive=1                                      
 AND Other_Tax_Id=4 --2 For SGST Tax                                          
  
 SELECT                               
 @KKTTaxAmount=ISNULL(KKT_TaxAmount,0),                     
 @SBTTaxAmount=ISNULL(SBT_TaxAmount,0),                    
 @CGSTTaxAmount=ISNULL(CGST,0),                     
 @SGSTTaxAmount=ISNULL(SGST,0)                                  
 FROM    Invoice_OtherTax                                
 WHERE   Invoice_ID = @InvoiceID                               
 AND YearCode=@YearCode                                         
  
 print @KKTTaxPerc                              
  
 declare @ServiceTaxCategory  VARCHAR(MAX)=''                     
  
 SELECT   @ServiceTaxCategory =STC.ServiceTaxCategory                                               
 FROM Invoice_New I                                                                      
 INNER JOIN Quotation Q ON Q.QuotationID = I.Qut_ID AND I.YearCode = Q.YearID                                                                  
 INNER JOIN ServiceTax ST ON ST.Tax_ACCode = I.Tax_ID                                                                                                        
 LEFT JOIN ServiceTaxCategory STC ON STC.ID = ST.Tax_Type                  
 LEFT JOIN Invoice_OtherTax IOT ON IOT.Invoice_ID=I.Invoice_ID AND IOT.YearCode=I.YearCode                                                        
 WHERE                                                         
 I.Invoice_ID = @InvoiceID  --Modified By AP                                                         
 AND Q.QuotationID = @QuotationID                                                   
  
 print @ServiceTaxCategory  
  
 SELECT TOP 1 I.Invoice_ID,  
  CM.LegalName AS 'CompanyName',  
 --CASE WHEN @IsRedDotPrint = '1' THEN 'RED DOT REPRESENTATIONS' ELSE 
 --LEFT(CM.CompanyName, case when CHARINDEX(',', CM.CompanyName) = 0 then LEN(CM.CompanyName) ELSE CHARINDEX(',', CM.CompanyName)-1 END ) END as 'CompanyName',  
 CONVERT(varchar(8000), CM.RegAddress) as 'Address',  
 CM.CityIATACode,CM.Website,CM.Email,                                                            
 CASE                                                             
 WHEN CM.Address=CM1.Address THEN ''                                                             
 ELSE CM1.Address                                                             
 END AS 'HeadAddress',                                      
 CASE                    
 WHEN CM.CompanyName=CM1.CompanyName THEN ''                                                             
 ELSE CM1.CompanyName                                                             
 END AS 'HeadCompanyName',                              
 CM1.CityIATACode AS 'HeadCityIATACode',                                                            
 CAST('' AS Image) AS logo,UI.Image AS AgentLogo,                                                             
 CASE                                                             
 WHEN CM.Phone ='' THEN ''                                                             
 ELSE 'Tel:'+CAST(convert(varchar(5), CR.ISDCode)+'-'+convert(varchar,C.STDCode)+'-'+convert(varchar(25), CM.Phone) AS VARCHAR)                                                             
 END Phone,                                            
 CASE                                                             
 WHEN CM.Fax='' THEN ''                                              
 ELSE 'Fax:'+CAST(convert(varchar(5),CR.ISDCode)+'-'+convert(varchar,C.STDCode)+'-'+convert(varchar(25),CM.Fax)AS VARCHAR)                                                             
 END Fax,                                                                
 CASE                                                             
 WHEN CM1.Phone ='' THEN ''                                                             
 ELSE 'Tel:'+CAST(convert(varchar(5),CR.ISDCode)+'-'+convert(varchar(5),C1.STDCode)+'-'+convert(varchar(25),CM1.Phone) AS VARCHAR)                                                             
 END HeadPhone,                                                               
 CASE                                                             
 WHEN CM1.Fax='' THEN ''                                                             
 ELSE 'Fax:'+CAST(convert(varchar(5),CR.ISDCode)+'-'+convert(varchar(5),C1.STDCode)+'-'+convert(varchar(25),CM1.Fax)AS VARCHAR)                                                             
 END HeadFax,                                                             
 CASE                                                             
 WHEN ISNULL(CM1.Website,'')='' THEN ''                                                             
 ELSE 'Website:'+ CM1.Website                                                             
 END HeadWebsite,                                               
 CASE                                                             
 WHEN ISNULL(CM1.Email,'')='' THEN ''                                                            
 ELSE 'Email:'+ CM1.Email                                                             
 END HeadEmail                                                             
 ,CASE               
 WHEN  @ServiceTaxCategory  like '%Goods and Services%'              
 THEN ISNULL(CM.CSTNo,'')               
 ELSE              
 ISNULL(CM.STNo,'')               
 END AS GSTIN               
 ,ISNULL(SA.Code,'-') AS SAC              
 ,ISNULL(ST.State_Code,'-') AS PlaceOfSupply              
 ,CASE           
 WHEN ISNULL(I.IsTaxReverseCharge,0)=1          
 THEN 'YES'          
 ELSE 'No'END   AS IsTaxReverseCharge    
 ,CASE               
 WHEN ISNULL(I.IsBillOfSupply,0)=1              
 THEN 'YES'              
 ELSE 'No'END   AS IsBillOfSupply   
 --,LTRIM(RTRIM(IRNL.QR_Code_Signed)) as QRCode   
 ,LTRIM(RTRIM(replace(replace(IRNL.QR_Code_Signed,char(13),''),char(10),''))) as QRCode 
 ,CAST('' AS Image) AS ShowImage, IRNL.IRN as 'IRN',CONVERT(varchar,IRNL.ACKDate,21) as  ACKDate, IRNL.AckNumber AS 'ACKNo'   
 ,CM.VATNo  
 ,SCM.State_Code AS 'STATE'  
 ,CM.CSTNo AS 'CGSTIN'  
 ,CM.CIN  
 ,CM.PanNo AS 'PAN'  
 ,CM.BranchAddress   
 --,dbo.fn_StripHTML_BR(BM.Details) as 'BankDetails'   
 ,dbo.fn_StripHTML_BR(@DisplayAccountDetails) as 'BankDetails' 
 ,CM.MsmeNo AS MSMERegNo  
 ,'' as IsTCS_Inv  
 ,'' as IsTCS_Inv1
 ,I.flag_InvOrTktInv   
 ,LUT.LUTNumber
 ,I.[EXP]
 ,I.[SEZ]
 ,@DisplayAccountName as 'AccountName'
 --,BM.AccountName
 --,BM.AccountNo
 ,BM.AccountPrefix 
 ,BM.BankID 
 ,BM.IsVirtualAccount 
 ,AM.VirtualAccount 
 --,CASE WHEN (AM.VirtualAccount = 1 AND BM.IsVirtualAccount = 1 AND I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency   and BM.isActive = 1 
 --) then BM.AccountPrefix + Q.FileCode ELSE BM.AccountNo END  AS 'AccountNo',
 ,@DisplayAccountNumber as 'AccountNo'
 ,ISNULL(@IsRedDotPrint,0) AS 'RedDotPrint'
 --,1 AS 'RedDotPrint'
 --, LEFT(CM.CompanyName, case when CHARINDEX(',', CM.CompanyName) = 0 then LEN(CM.CompanyName) ELSE CHARINDEX(',', CM.CompanyName)-1 END ) as 'CompanyNameFooter' 
 ,CM.LegalName  AS 'CompanyNameFooter'
 ,  '1. ' + CM.NotesForInvoice as 'NotesForInvoice'
 , CASE WHEN  @IsRedDotCompany = '1000' AND (I.IsDirectPayment = 1 OR I.IsBTCComm  = 1) THEN   '' --'2. TDS TO BE DEDUCTED AT LOWER RATE OF 3% 194 H (CERTIFICATE NO - 1AA0824BOZ)' 
		WHEN  @IsRedDotCompany = '1000' AND (I.IsTcsInvoice = 1 ) AND  @IsTDSChecked = 1 THEN   '2. TDS TO BE DEDUCTED AT LOWER RATE OF 1.25% 194 C (CERTIFICATE NO - 1AA0824BOY)' 
		WHEN  @IsRedDotCompany = '1000' AND (I.IsTcsInvoice = 1 ) AND  @IsTDSChecked != 1 THEN   '' 
		WHEN  @IsRedDotCompany = '1000' THEN   '2. TDS TO BE DEDUCTED AT LOWER RATE OF 1.25% 194 C (CERTIFICATE NO - 1AA0824BOY)'
		ELSE '' END AS BTCDPRemark 
 FROM Invoice_New I                                                                                                        
 INNER JOIN Quotation Q ON Q.QuotationID = I.Qut_ID  
  LEFT JOIN AgentMaster AM ON AM.AgentCode = I.Agent_ID                                                                                                       
 INNER JOIN CompanyMaster CM ON CM.CompanyID = I.compcode                                                                                                                 
 INNER JOIN CompanyMaster CM1 ON CM1.CompanyID = CM1.CompanyID AND CM1.HeadOffice=1                                                                                                                
 LEFT JOIN UploadImage UI ON UI.ParentID=Q.AgentID AND ParentPageType=7                                                      
 LEFT JOIN City C ON C.IATACode=CM.CityIATACode                                                        
 LEFT JOIN State S ON S.State_ID=C.State_IATACode              
 LEFT JOIN State_Code_Master ST ON  I.PlaceOfSupplierId=ST.ID                                           
 LEFT JOIN Country CR ON CR.IATACode=S.Country_IATACode                                                                   
 LEFT JOIN City C1 ON C1.IATACode=CM1.CityIATACode                 
 LEFT JOIN SAC_Master SA ON I.SAC_ID=SA.ID      
 LEFT JOIN State_Code_Master SCM on CM.StateCodeID = SCM.ID    
 --LEFT JOIN Invoice_ARN_ErrorLog IRNL on I.Invoice_ID = IRNL.InvoiceID and I.YearCode = IRNL.YearCode    
 LEFT JOIN Invoice_New_IRN_SuperTaxJob_Details  IRNL on I.Invoice_ID = IRNL.InvoiceID 
 and Convert(CHAR(8),I.Invoice_Date,112) = Convert(CHAR(8), CAST(IRNL.InvoiceDate AS DATE),112)
 LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency   and BM.isActive = 1  
 LEFT JOIN LUTMASTER LUT ON I.compcode = LUT.CompanyID    
AND CAST(I.Invoice_Date AS DATE) between CAST(LUT.ValidFrom AS DATE) AND CAST(LUT.ValidTo AS DATE) 
AND (I.SEZ = 'SEZ' OR I.[EXP] = 'EXP') AND   LUT.IsActive = 1                                                
 WHERE I.Invoice_ID = @InvoiceID                                                                                      
 AND Q.QuotationID = @QuotationID                                                              
  
 SELECT DISTINCT I.ID,                                                        
 I.Invoice_ID --Modified By AP                                                        
 ,Type_Of_Doc,Invoice_Type +' ' + Type_Of_Doc AS Invoice_Type,                                                            
 CONVERT(varchar,Invoice_Date,106) AS Invoice_Date,[File_ID],Qut_ID,Customer_Name,Agent_ID,Curr_ID,                                                                                                        
 I.Tax_ID,Invoice_No_Of_Pax,Invoice_Credit_Note,Invoice_Exchg_Rate,Invoice_Curr_Amt,Invoice_Total,                                                            
 Reference,compcode,                                                       
 I.YearCode--Modified By AP                                                        
 ,ReceivedAmt,BalAmt                                
 ,AmtInINR,MiscAcc,RefNo,PreviousYear,isVoid,                                                            
 ConvertedInvNo,I.CreatedBy,CreatedDateTime,LastUpdatedBy,LastUpdateDateTime,                                                                      
 CASE                                                             
 WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN ISNULL(HM.HotelName, VM.VendorName)                                                 
 ELSE AM.AgentName                                                             
 END AS 'AgentName'                                                             
 ,Q.CustomerName,                                                                     
 (SELECT EmpName from EmployeeMaster EM where EM.UserID=Q.OperationBy) AS 'EmployeeName',                                                              
 CASE                                                             
 WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN ISNULL(HM.Address,VM.Address)                                                            
 ELSE AM.Address                                                             
 END AS 'AgentAddress',   
 CASE                                                         
 WHEN AM.AgentName <>'' THEN 'StateCode : '+ ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM inner join AgentMaster AM on AM.StateCodeID = SCM.ID where AM.AgentCode = I.Agent_ID),'')  --'StateName  :'+ISNULL(AM.STRegNo,'')                 
 WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN 'StateCode  :'+ ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM inner join HotelMaster HM on HM.StateCodeID = SCM.ID where HM.HotelSAPCode = I.Agent_ID) ,(SELECT TOP 1 State_Code from State_Code_Master SCM 
 inner join VendorMaster VM on VM.StateCodeID = SCM.ID where VM.VendorSAPCode = I.Agent_ID) )                                                         
 ELSE ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM left join AgentMaster AM on AM.StateCodeID = SCM.ID where AM.AgentCode = I.Agent_ID),'')                                                                        
 END AS 'AgentPhone',                       
 --'Agent GSTIN  : '+ ISNULL(AM.STRegNo,'')  AS AgentGSTIN,                                                            
 CASE                                                         
 WHEN AM.AgentName <>'' THEN 'GSTIN  :'+ISNULL(AM.STRegNo,'')                 
 WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN 'GSTIN  :'+ ISNULL(HM.STRegNo,VM.STRegNo)                                                         
 ELSE ''                                                         
 END AS 'AgentGSTIN',  
 --CASE                                                         
 --WHEN I.PANNo <>'' THEN '|  PAN : '+ISNULL(I.PANNo,'')                 
 --ELSE ''                                                         
 --END AS 'PANNo',     
 '' as 'PANNo' ,   
 CASE                                                          
 WHEN AM.AgentName <>'' THEN ABM.BankAccountDetails                 
 WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN ISNULL(ABM1.BankAccountDetails,ABM2.BankAccountDetails)                                                         
 ELSE ''                                                         
 END AS 'BankAccountDetails'                                                         
 ,ISNULL(IOT.ServiceTax_Amount,(I.TaxAmount-ISNULL(@SBTTaxAmount,0)-ISNULL(@KKTTaxAmount,0))) AS TaxAmount                                    
 ,'' AS TaxDesc                                              
 ,ISNULL(@OtherTaxDesc,'') AS OtherTaxDesc                              
 ,I.UTGST AS OtherTaxAmount                              
 ,ISNULL(@KKTTaxDesc,'') AS KKTTaxDesc                                                  
 ,I.IGST AS KKTTaxAmount  
 ,G1.GSTPercentage AS GST_Perc  
 ,ISNULL(I.IGST, '0.00') AS IGST     
 ,ISNULL(I.UTGST, '0.00') AS UTGST                 
 ,'CGSTDESC' AS CGSTTaxDesc ,ISNULL(I.CGST, '0.00') AS CGST                     
 ,'SGSTDESC' AS SGSTTaxDesc ,ISNULL(I.SGST, '0.00') AS SGST                                     
 ,CASE               
 WHEN ISNULL(I.IsBillOfSupply,0)=1              
 THEN 'YES'              
 ELSE 'No'END   AS IsBillOfSupply                                    
 ,AM.IsSEZ    -- by dhvani @11282919 to display sez line report if issez is true       
 ,Case when I.IsDirectPayment=1 THEN HM.LegalName else '' end as LegalName     
 ,'' as TCSValue ,''  as TCSRate  
 ,G1.GSTPercentage AS 'GST_Perc'  
 ,Curr.Name AS 'Curr_Name'  
 ,I.Commercial_ID 
 ,I.flag_InvOrTktInv
 ,AM.VirtualAccount 
 FROM Invoice_New I                                                                      
 INNER JOIN Quotation Q ON Q.QuotationID = I.Qut_ID AND I.YearCode = Q.YearID                              
          
 LEFT JOIN AgentMaster AM ON AM.AgentCode = I.Agent_ID                                                                      
 LEFT JOIN HotelMaster HM ON convert(varchar(20),HM.hotelcode)=I.Agent_ID                                             
 LEFT JOIN VendorMaster VM ON convert(VARCHAR(20),VM.VendorCode)=I.Agent_ID                                                            
 --Inner Join ServiceTaxNew ST ON  Q.GSTTypeID=ST.GSTType    
 left JOIN GST_Percentage G1 ON  I.GST_Perc = G1.GSTID   
 INNER JOIN GSTTypeMaster G ON G.GSTID=Q.GSTTypeID                                                                                                     
 INNER JOIN aspnet_Users AU ON AU.UserId=Q.OperationBy                                                            
 left join  AccountsBankMaster ABM ON ABM.AccountBankMasterID=AM.BankAccountID   
 left join  AccountsBankMaster ABM1 ON ABM1.AccountBankMasterID=HM.BankAccountID   
 left join  AccountsBankMaster ABM2 ON ABM2.AccountBankMasterID=VM.BankAccountID                                                       
 LEFT JOIN Invoice_OtherTax IOT ON IOT.Invoice_ID=I.Invoice_ID AND IOT.YearCode=I.YearCode												 
 LEFT JOIN Currency Curr on I.Curr_ID = Curr.Code 
          
 WHERE                                                         
 I.Invoice_ID = @InvoiceID                                                          
 AND Q.QuotationID = @QuotationID                                                                             
  
 --Select IDT.ID,IDT.Invoice_ID,Invoice_Desc,Invoice_Value,IDT.YearCode,IDT.Taxable_Amount,IDT.Tax_Amount  
 --,IDT.TotalBaseFare , SUM(IDT.Taxable_Amount) AS SUM_Taxable_Amount, SUM(IDT.Tax_Amount) AS SUM_Tax_Amount  
 --,SUM(IDT.TotalBaseFare) AS SUM_TotalBaseFare  
 --,'' as TCSAmount                                                                                                       
 --FROM Invoice_Detail_New IDT                                                                                                        
 --INNER JOIN Invoice_New I ON I.Invoice_ID = IDT.Invoice_ID                                                             
 --AND I.YearCode = IDT.YearCode                                                               
 --INNER JOIN Quotation Q ON Q.QuotationID = I.Qut_ID                                                             
 --AND Q.CompanyID = I.compcode                                                                     
 --WHERE I.Invoice_ID = @InvoiceID                                                                                   
 --AND Q.QuotationID = @QuotationID                                                                                        
 --Group By IDT.Invoice_ID,Invoice_Desc,Invoice_Value,IDT.YearCode,IDT.Taxable_Amount,IDT.Tax_Amount  
 --,IDT.TotalBaseFare  
  
  
  --;WITH CTE_TEST AS (SELECT IDT.Invoice_ID, SUM(IDT.Taxable_Amount) AS SUM_Taxable_Amount, SUM(IDT.Tax_Amount) AS      SUM_Tax_Amount   
  --,SUM(IDT.TotalBaseFare) AS SUM_TotalBaseFare  
  --FROM Invoice_Detail_New IDT   
  --GROUP BY IDT.Invoice_ID)  
  -- SELECT DISTINCT IDT.ID,IDT.Invoice_ID,Invoice_Desc,Invoice_Value,IDT.YearCode,IDT.Taxable_Amount,IDT.Tax_Amount  
  --,IDT.TotalBaseFare , CTE_TEST.SUM_Taxable_Amount,  CTE_TEST.SUM_Tax_Amount,  CTE_TEST.SUM_TotalBaseFare, '' as TCSAmount   
  --,IDT.SAC   
  --FROM Invoice_Detail_New IDT   
  --INNER JOIN Invoice_New I ON I.Invoice_ID = IDT.Invoice_ID                                                             
  --AND I.YearCode = IDT.YearCode                                                               
  --INNER JOIN Quotation Q ON Q.QuotationID = I.Qut_ID                                                             
  --AND Q.CompanyID = I.compcode    
  --INNER JOIN CTE_TEST ON CTE_TEST.Invoice_ID = IDT.Invoice_ID  WHERE IDT.Invoice_ID = @InvoiceID  AND Q.QuotationID = @QuotationID    
    
  select IDT.ID,IDT.Invoice_ID,Invoice_Desc,Invoice_Value,IDT.YearCode,IDT.Taxable_Amount, I.TaxAmount as 'Tax_Amount' 
  --IDT.Tax_Amount  -- commented for decimal varience in details table
  ,IDT.TotalBaseFare , I.Invoice_Curr_Amt as 'SUM_Taxable_Amount',  I.TaxAmount as 'SUM_Tax_Amount',  
  I.TotalBaseAmt AS 'SUM_TotalBaseFare',   
         TCSAmount 
		 ,IDT.TCSAmount AS 'SUM_TCS'   
  ,SACM.Code as 'SAC', Tax_Per,TCSR.TCSRate,   
  CASE When Convert(varchar(50),ISNULL(CAST(TCSRate AS INT),0)) =0  Then 'TCS'  
  ELSE 'TCS ' + Convert(varchar(50),ISNULL(CAST(TCSRate AS INT),0)) + '%' END as TCS_Per   
    FROM Invoice_Detail_New IDT   
  INNER JOIN Invoice_New I ON I.Invoice_ID = IDT.Invoice_ID                                                             
  AND I.YearCode = IDT.YearCode                                                               
  INNER JOIN Quotation Q ON Q.QuotationID = I.Qut_ID                                                             
  AND Q.CompanyID = I.compcode  
  INNER JOIN SAC_Master SACM ON  IDT.SACID = SACM.ID   
  LEFT JOIN TCSRateMaster TCSR ON IDT.TCSRateID = TCSR.ACCode  
  WHERE IDT.Invoice_ID = @InvoiceID  AND Q.QuotationID = @QuotationID    
  
END   
  
  


