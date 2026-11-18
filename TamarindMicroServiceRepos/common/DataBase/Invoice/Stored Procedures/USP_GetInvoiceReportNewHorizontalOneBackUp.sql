
<<<<<<< HEAD
<<<<<<< HEAD
  --ALTER Proc [dbo].[USP_GetInvoiceReport_NewBreakup]  -- 'IN000006BOM','427046'      
 --   declare
	--@InvoiceID VARCHAR(50)=1,                                                                                      
 --@QuotationID INT=3   ,
 --@Action Char(1)
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
--declare
--	@InvoiceID VARCHAR(50)=1,                                                                                      
--	@QuotationID INT=2   ,
--	@Action Char(1)='S'
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
CREATE PROC [Invoice].[USP_GetInvoiceReportNewHorizontalOneBackUp]  --'23IN000274BOM', '523820'                       
(                                                                                      
 @InvoiceID VARCHAR(50),                                                                                      
 @QuotationID INT   ,
 @Action Char(1)
)                                                                                      
AS                                                                                                        
BEGIN                                          
<<<<<<< HEAD
<<<<<<< HEAD
  
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
 FROM   Invoice.Invoice I  WHERE  I.ID = @InvoiceID  AND QuotationID = @QuotationID  
 
 DECLARE @IsRedDotCompany varchar(10)
 SELECT @IsRedDotCompany = SAP_CompanyCode  from CompanyMaster  WHERE CompanyID IN (SELECT CompanyID from Quotation where QuotationID = @QuotationID )
 print '@IsRedDotCompany'
 print @IsRedDotCompany
  
 --SELECT @BizVerticalRedDot =
 ----Q.BussinessModuleID, 
 --0,
 --@AddressCountryRedDot = AM.AddressCountry,
 -- @AddressonRecordRedDot = AM.AddressExist, @InvCurrRedDot = I.Curr_ID , @IsRedDotBankDetails = BM.isRedDot , @IsTDSChecked = I.isTDSDeduction 
 -- FROM Invoice.Invoice I   
 --LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID 
 --LEFT JOIN AgentMaster AM ON AM.AgentCode = I.AgentID    
 --LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency   and BM.isActive = 1 
 --WHERE I.ID = @InvoiceID  AND I.QuotationID = @QuotationID  
 
 
 --IF(@BizVerticalRedDot = '9' AND @AddressCountryRedDot = 'IN' AND @AddressonRecordRedDot = '1' AND @InvCurrRedDot = 'INR'  AND  @IsRedDotBankDetails = '1' )
 --BEGIN
 --    set @IsRedDotPrint = '1'
 --END
 --ELSE
 --BEGIN
	--set  @IsRedDotPrint = '0'
 --END
  
  
-- SELECT TOP 1 @ExistingAccountNumberRedDOT =  BM.AccountNo , @DisplayExistingAccountNameRedDOT=  BM.AccountName,@DisplayExistingAccountDetailsRedDOT = BM.Details  from Invoice.Invoice I  
--LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID  
--LEFT JOIN AgentMaster AM ON AM.AgentCode = I.AgentID 
--LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency AND BM.isActive = 1 AND BM.IsRedDot= 1   
--WHERE I.ID = @InvoiceID AND Q.QuotationID = @QuotationID   
 
-- SELECT TOP 1 @VirtualAccountNumber = BM.AccountPrefix + Q.FileCode, @DisplayVirtualAccountName=  BM.AccountName,@DisplayVirtualAccountDetails = BM.Details  from Invoice.Invoice I 
--LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID  
--LEFT JOIN AgentMaster AM ON AM.AgentCode = I.AgentID 
--LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency   and BM.isActive = 1  
--AND BM.IsVirtualAccount = 1 AND AM.VirtualAccount = 1 
--WHERE I.ID = @InvoiceID AND Q.QuotationID = @QuotationID   

-- SELECT TOP 1 @ExistingAccountNumber =  BM.AccountNo , @DisplayExistingAccountName=  BM.AccountName,@DisplayExistingAccountDetails = BM.Details  from Invoice.Invoice I  
--LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID  
--LEFT JOIN AgentMaster AM ON AM.AgentCode = I.AgentID 
--LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency AND BM.isActive = 1  
--WHERE I.ID = @InvoiceID AND Q.QuotationID = @QuotationID 

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
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
  IF(@Action='S')
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
	 FROM   Invoice.Invoice I  WHERE  I.ID = @InvoiceID  AND QuotationID = @QuotationID  
 
	 DECLARE @IsRedDotCompany varchar(10)
	 SELECT @IsRedDotCompany = SAP_CompanyCode  from CompanyMaster  WHERE CompanyID IN (SELECT CompanyID from Quotation where QuotationID = @QuotationID )
	 print '@IsRedDotCompany'
	 print @IsRedDotCompany
  
	 --SELECT @BizVerticalRedDot =
	 ----Q.BussinessModuleID, 
	 --0,
	 --@AddressCountryRedDot = AM.AddressCountry,
	 -- @AddressonRecordRedDot = AM.AddressExist, @InvCurrRedDot = I.Curr_ID , @IsRedDotBankDetails = BM.isRedDot , @IsTDSChecked = I.isTDSDeduction 
	 -- FROM Invoice.Invoice I   
	 --LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID 
	 --LEFT JOIN AgentMaster AM ON AM.AgentCode = I.AgentID    
	 --LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency   and BM.isActive = 1 
	 --WHERE I.ID = @InvoiceID  AND I.QuotationID = @QuotationID  
 
 
	 --IF(@BizVerticalRedDot = '9' AND @AddressCountryRedDot = 'IN' AND @AddressonRecordRedDot = '1' AND @InvCurrRedDot = 'INR'  AND  @IsRedDotBankDetails = '1' )
	 --BEGIN
	 --    set @IsRedDotPrint = '1'
	 --END
	 --ELSE
	 --BEGIN
		--set  @IsRedDotPrint = '0'
	 --END
  
  
	-- SELECT TOP 1 @ExistingAccountNumberRedDOT =  BM.AccountNo , @DisplayExistingAccountNameRedDOT=  BM.AccountName,@DisplayExistingAccountDetailsRedDOT = BM.Details  from Invoice.Invoice I  
	--LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID  
	--LEFT JOIN AgentMaster AM ON AM.AgentCode = I.AgentID 
	--LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency AND BM.isActive = 1 AND BM.IsRedDot= 1   
	--WHERE I.ID = @InvoiceID AND Q.QuotationID = @QuotationID   
 
	-- SELECT TOP 1 @VirtualAccountNumber = BM.AccountPrefix + Q.FileCode, @DisplayVirtualAccountName=  BM.AccountName,@DisplayVirtualAccountDetails = BM.Details  from Invoice.Invoice I 
	--LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID  
	--LEFT JOIN AgentMaster AM ON AM.AgentCode = I.AgentID 
	--LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency   and BM.isActive = 1  
	--AND BM.IsVirtualAccount = 1 AND AM.VirtualAccount = 1 
	--WHERE I.ID = @InvoiceID AND Q.QuotationID = @QuotationID   

	-- SELECT TOP 1 @ExistingAccountNumber =  BM.AccountNo , @DisplayExistingAccountName=  BM.AccountName,@DisplayExistingAccountDetails = BM.Details  from Invoice.Invoice I  
	--LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID  
	--LEFT JOIN AgentMaster AM ON AM.AgentCode = I.AgentID 
	--LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency AND BM.isActive = 1  
	--WHERE I.ID = @InvoiceID AND Q.QuotationID = @QuotationID 

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
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6


                                 
  
<<<<<<< HEAD
<<<<<<< HEAD
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
 FROM [Invoice].[Invoice] I                                                                      
 LEFT JOIN [Quotation].QuotationMaster Q ON Q.QuotationID = I.QuotationID AND I.YearCode = Q.YearID                                                                  
 LEFT JOIN ServiceTax ST ON ST.Tax_ACCode = I.Tax_ID                                                                                                        
 LEFT JOIN ServiceTaxCategory STC ON STC.ID = ST.Tax_Type                  
 LEFT JOIN Invoice_OtherTax IOT ON IOT.Invoice_ID=I.ID AND IOT.YearCode=I.YearCode                                                        
 WHERE                                                         
 I.ID = @InvoiceID  --Modified By AP                                                         
 AND Q.QuotationID = @QuotationID                                                   
  
 print @ServiceTaxCategory  
  
-- SELECT TOP 1 I.ID as Invoice_ID,  
--  CM.LegalName AS 'CompanyName',  

-- CONVERT(varchar(8000), CM.RegAddress) as 'Address',  
-- CM.CityIATACode,CM.Website,CM.Email,                                                            
-- CASE                                                             
-- WHEN CM.Address=CM1.Address THEN ''                                                             
-- ELSE CM1.Address                                                             
-- END AS 'HeadAddress',                                      
-- CASE                    
-- WHEN CM.CompanyName=CM1.CompanyName THEN ''                                                             
-- ELSE CM1.CompanyName                                                             
-- END AS 'HeadCompanyName',                              
-- CM1.CityIATACode AS 'HeadCityIATACode',                                                            
-- CAST('' AS Image) AS logo,UI.Image AS AgentLogo,                                                             
-- CASE                                                             
-- WHEN CM.Phone ='' THEN ''                                                             
-- ELSE 'Tel:'+CAST(convert(varchar(5), CR.ISDCode)+'-'+convert(varchar,C.STDCode)+'-'+convert(varchar(25), CM.Phone) AS VARCHAR)                                                             
-- END Phone,                                            
-- CASE                                                             
-- WHEN CM.Fax='' THEN ''                                              
-- ELSE 'Fax:'+CAST(convert(varchar(5),CR.ISDCode)+'-'+convert(varchar,C.STDCode)+'-'+convert(varchar(25),CM.Fax)AS VARCHAR)                                                             
-- END Fax,                                                                
-- CASE                                                             
-- WHEN CM1.Phone ='' THEN ''                                                             
-- ELSE 'Tel:'+CAST(convert(varchar(5),CR.ISDCode)+'-'+convert(varchar(5),C1.STDCode)+'-'+convert(varchar(25),CM1.Phone) AS VARCHAR)                                                             
-- END HeadPhone,                                                               
-- CASE                                                             
-- WHEN CM1.Fax='' THEN ''                                                             
-- ELSE 'Fax:'+CAST(convert(varchar(5),CR.ISDCode)+'-'+convert(varchar(5),C1.STDCode)+'-'+convert(varchar(25),CM1.Fax)AS VARCHAR)                                                             
-- END HeadFax,                                                             
-- CASE                                                             
-- WHEN ISNULL(CM1.Website,'')='' THEN ''                                                             
-- ELSE 'Website:'+ CM1.Website                                                             
-- END HeadWebsite,                                               
-- CASE                                                             
-- WHEN ISNULL(CM1.Email,'')='' THEN ''                                                            
-- ELSE 'Email:'+ CM1.Email                                                             
-- END HeadEmail                                                             
-- ,CASE               
-- WHEN  @ServiceTaxCategory  like '%Goods and Services%'              
-- THEN ISNULL(CM.CSTNo,'')               
-- ELSE              
-- ISNULL(CM.STNo,'')               
-- END AS GSTIN               
-- ,ISNULL(SA.Code,'-') AS SAC              
-- ,ISNULL(ST.State_Code,'-') AS PlaceOfSupply              
-- ,CASE           
-- WHEN ISNULL(I.IsTaxReverseCharge,0)=1          
-- THEN 'YES'          
-- ELSE 'No'END   AS IsTaxReverseCharge    
-- ,CASE               
-- WHEN ISNULL(I.IsBillOfSupply,0)=1              
-- THEN 'YES'              
-- ELSE 'No'END   AS IsBillOfSupply   
-- --,LTRIM(RTRIM(IRNL.QR_Code_Signed)) as QRCode   
-- ,LTRIM(RTRIM(replace(replace(IRNL.QR_Code_Signed,char(13),''),char(10),''))) as QRCode 
-- ,CAST('' AS Image) AS ShowImage, IRNL.IRN as 'IRN',CONVERT(varchar,IRNL.ACKDate,21) as  ACKDate, IRNL.AckNumber AS 'ACKNo'   
-- ,CM.VATNo  
-- ,SCM.State_Code AS 'STATE'  
-- ,CM.CSTNo AS 'CGSTIN'  
-- ,CM.CIN  
-- ,CM.PanNo AS 'PAN'  
-- ,CM.BranchAddress   
-- --,dbo.fn_StripHTML_BR(BM.Details) as 'BankDetails'   
-- ,dbo.fn_StripHTML_BR(@DisplayAccountDetails) as 'BankDetails' 
-- ,CM.MsmeNo AS MSMERegNo  
-- ,'' as IsTCS_Inv  
-- ,'' as IsTCS_Inv1
-- ,I.flag_InvOrTktInv   
-- ,LUT.LUTNumber
-- ,I.[EXP]
-- ,I.[SEZ]
-- ,@DisplayAccountName as 'AccountName'

-- ,BM.AccountPrefix 
-- ,BM.BankID 
-- ,BM.IsVirtualAccount 
-- ,AM.VirtualAccount 

-- ,@DisplayAccountNumber as 'AccountNo'
-- ,ISNULL(@IsRedDotPrint,0) AS 'RedDotPrint'
  
-- ,CM.LegalName  AS 'CompanyNameFooter'
-- ,  '1. ' + CM.NotesForInvoice as 'NotesForInvoice'
-- , CASE WHEN  @IsRedDotCompany = '1000' AND (I.IsDirectPayment = 1 OR I.IsBTCComm  = 1) THEN   '' --'2. TDS TO BE DEDUCTED AT LOWER RATE OF 3% 194 H (CERTIFICATE NO - 1AA0824BOZ)' 
--		WHEN  @IsRedDotCompany = '1000' AND (I.IsTcsInvoice = 1 ) AND  @IsTDSChecked = 1 THEN   '2. TDS TO BE DEDUCTED AT LOWER RATE OF 1.25% 194 C (CERTIFICATE NO - 1AA0824BOY)' 
--		WHEN  @IsRedDotCompany = '1000' AND (I.IsTcsInvoice = 1 ) AND  @IsTDSChecked != 1 THEN   '' 
--		WHEN  @IsRedDotCompany = '1000' THEN   '2. TDS TO BE DEDUCTED AT LOWER RATE OF 1.25% 194 C (CERTIFICATE NO - 1AA0824BOY)'
--		ELSE '' END AS BTCDPRemark 
-- FROM Invoice.Invoice I                                                                                                        
-- LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID  
--  LEFT JOIN AgentMaster AM ON AM.AgentCode = I.Agent_ID                                                                                                       
-- LEFT JOIN CompanyMaster CM ON CM.CompanyID = I.compcode                                                                                                                 
-- LEFT JOIN CompanyMaster CM1 ON CM1.CompanyID = CM1.CompanyID AND CM1.HeadOffice=1                                                                                                                
-- LEFT JOIN UploadImage UI ON UI.ParentID=Q.AgentID AND ParentPageType=7                                                      
-- LEFT JOIN City C ON C.IATACode=CM.CityIATACode                                                        
-- LEFT JOIN State S ON S.State_ID=C.State_IATACode              
-- LEFT JOIN State_Code_Master ST ON  I.PlaceOfSupplierId=ST.ID                                           
-- LEFT JOIN Country CR ON CR.IATACode=S.Country_IATACode                                                                   
-- LEFT JOIN City C1 ON C1.IATACode=CM1.CityIATACode                 
-- LEFT JOIN SAC_Master SA ON I.SAC_ID=SA.ID      
-- LEFT JOIN State_Code_Master SCM on CM.StateCodeID = SCM.ID    
-- --LEFT JOIN Invoice_ARN_ErrorLog IRNL on I.Invoice_ID = IRNL.InvoiceID and I.YearCode = IRNL.YearCode    
-- LEFT JOIN Invoice.Invoice_IRN_SuperTaxJob_Details  IRNL on I.ID = IRNL.InvoiceID 
-- and Convert(CHAR(8),I.Invoice_Date,112) = Convert(CHAR(8), CAST(IRNL.InvoiceDate AS DATE),112)
-- LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID = BM.Currency   and BM.isActive = 1  
-- LEFT JOIN LUTMASTER LUT ON I.compcode = LUT.CompanyID    
--AND CAST(I.Invoice_Date AS DATE) between CAST(LUT.ValidFrom AS DATE) AND CAST(LUT.ValidTo AS DATE) 
--AND (I.SEZ = 'SEZ' OR I.[EXP] = 'EXP') AND   LUT.IsActive = 1                                                
-- WHERE I.ID = @InvoiceID                                                                                      
-- AND Q.QuotationID = @QuotationID                                                              
  
 --SELECT DISTINCT I.ID,                                                        
 --I.ID as Invoice_ID --Modified By AP                                                        
 --,case when TypeOfDoc =1 then 'Invoice' WHEN TypeOfDoc=2 THEN 'Performa' END as Type_Of_Doc,Invoice_Type +' ' + Type_Of_Doc AS Invoice_Type,                                                            
 --CONVERT(varchar,Invoice_Date,106) AS Invoice_Date,[File_ID],QuotationID,Customer_Name,Agent_ID,Curr_ID,                                                                                                        
 --I.Tax_ID,Invoice_No_Of_Pax,Invoice_Credit_Note,Invoice_Exchg_Rate,Invoice_Curr_Amt,Invoice_Total,                                                            
 --Reference,compcode,                                                       
 --I.YearCode--Modified By AP                                                        
 --,ReceivedAmt,BalAmt                                
 --,AmtInINR,MiscAcc,RefNo,PreviousYear,isVoid,                                                            
 --ConvertedInvNo,I.CreatedBy,CreatedDateTime,LastUpdatedBy,LastUpdateDateTime,                                                                      
 --CASE                                                             
 --WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN ISNULL(HM.HotelName, VM.VendorName)                                                 
 --ELSE AM.AgentName                                                             
 --END AS 'AgentName'                                                             
 --,Q.CustomerName,                                                                     
 --(SELECT EmpName from EmployeeMaster EM where EM.UserID=Q.OperationBy) AS 'EmployeeName',                                                              
 --CASE                                                             
 --WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN ISNULL(HM.Address,VM.Address)                                                            
 --ELSE AM.Address                                                             
 --END AS 'AgentAddress',   
 --CASE                                                         
 --WHEN AM.AgentName <>'' THEN 'StateCode : '+ ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM LEFT join AgentMaster AM on AM.StateCodeID = SCM.ID where AM.AgentCode = I.Agent_ID),'')  --'StateName  :'+ISNULL(AM.STRegNo,'')                 
 --WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN 'StateCode  :'+ ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM LEFT join HotelMaster HM on HM.StateCodeID = SCM.ID where HM.HotelSAPCode = I.Agent_ID) ,(SELECT TOP 1 State_Code from State_Code_Master SCM 
 --LEFT join VendorMaster VM on VM.StateCodeID = SCM.ID where VM.VendorSAPCode = I.Agent_ID) )                                                         
 --ELSE ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM left join AgentMaster AM on AM.StateCodeID = SCM.ID where AM.AgentCode = I.Agent_ID),'')                                                                        
 --END AS 'AgentPhone',                       
                                                   
 --CASE                                                         
 --WHEN AM.AgentName <>'' THEN 'GSTIN  :'+ISNULL(AM.STRegNo,'')                 
 --WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN 'GSTIN  :'+ ISNULL(HM.STRegNo,VM.STRegNo)                                                         
 --ELSE ''                                                         
 --END AS 'AgentGSTIN',  
 
 --'' as 'PANNo' ,   
 --CASE                                                          
 --WHEN AM.AgentName <>'' THEN ABM.BankAccountDetails                 
 --WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN ISNULL(ABM1.BankAccountDetails,ABM2.BankAccountDetails)                                                         
 --ELSE ''                                                         
 --END AS 'BankAccountDetails'                                                         
 --,ISNULL(IOT.ServiceTax_Amount,(IDT.TotalTax_Amount-ISNULL(@SBTTaxAmount,0)-ISNULL(@KKTTaxAmount,0))) AS TaxAmount                                    
 --,'' AS TaxDesc                                              
 --,ISNULL(@OtherTaxDesc,'') AS OtherTaxDesc                              
 --,IDT.UTGST AS OtherTaxAmount                              
 --,ISNULL(@KKTTaxDesc,'') AS KKTTaxDesc                                                  
 --,IDT.IGST AS KKTTaxAmount  
 --,G1.GSTPercentage AS GST_Perc  
 --,ISNULL(IDT.IGST, '0.00') AS IGST     
 --,ISNULL(IDT.UTGST, '0.00') AS UTGST                 
 --,'CGSTDESC' AS CGSTTaxDesc ,ISNULL(IDT.CGST, '0.00') AS CGST                     
 --,'SGSTDESC' AS SGSTTaxDesc ,ISNULL(IDT.SGST, '0.00') AS SGST                                     
 --,CASE               
 --WHEN ISNULL(I.IsBillOfSupply,0)=1              
 --THEN 'YES'              
 --ELSE 'No'END   AS IsBillOfSupply                                    
 --,AM.IsSEZ    -- by dhvani @11282919 to display sez line report if issez is true       
 --,Case when I.IsDirectPayment=1 THEN HM.LegalName else '' end as LegalName     
 --,'' as TCSValue ,''  as TCSRate  
 --,G1.GSTPercentage AS 'GST_Perc'  
 --,Curr.Name AS 'Curr_Name'  
 --,I.Commercial_ID 
 --,I.flag_InvOrTktInv
 --,AM.VirtualAccount 
 --FROM Invoice.Invoice I  
 --LEFT JOIN Invoice.InvoiceDetails IDT  ON I.ID = IDT.Invoice_ID     
 --LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID AND I.YearCode = Q.YearID                              
          
 --LEFT JOIN AgentMaster AM ON AM.AgentCode = I.AgentID                                                                      
 --LEFT JOIN HotelMaster HM ON convert(varchar(20),HM.hotelcode)=I.AgentID                                             
 --LEFT JOIN VendorMaster VM ON convert(VARCHAR(20),VM.VendorCode)=I.AgentID          
 --left JOIN GST_Percentage G1 ON  I.GST_Perc = G1.GSTID   
 --LEFT JOIN GSTTypeMaster G ON G.GSTID=Q.GSTTypeID                                                                                                     
 --LEFT JOIN aspnet_Users AU ON AU.UserId=Q.OperationBy    
 --LEFT JOIN aspnet_Users AU ON AU.UserId=Q.CreatedBy    
 --left join  AccountsBankMaster ABM ON ABM.AccountBankMasterID=AM.BankAccountID   
 --left join  AccountsBankMaster ABM1 ON ABM1.AccountBankMasterID=HM.BankAccountID   
 --left join  AccountsBankMaster ABM2 ON ABM2.AccountBankMasterID=VM.BankAccountID                                                       
 --LEFT JOIN Invoice_OtherTax IOT ON IOT.Invoice_ID=I.ID AND IOT.YearCode=I.YearCode												 
 --LEFT JOIN Currency Curr on I.Curr_ID = Curr.Code 
          
 --WHERE                                                         
 --I.ID = @InvoiceID                                                          
 --AND Q.QuotationID = @QuotationID                                                                             
  
  select IDT.ID as InvoiceDetailID,IDT.Invoice_ID,Invoice_Desc,Invoice_Value,IDT.YearCode,IDT.TotalTaxable_Amount, IDT.TotalTax_Amount as 'Tax_Amount' 
  ,IDT.TotalBasicAmount , IDT.TotalTaxable_Amount as 'SUM_Taxable_Amount',
  --I.TaxAmount as 'SUM_Tax_Amount',  
  0 as 'SUM_Tax_Amount',  
  IDT.TotalBasicAmount AS 'SUM_TotalBaseFare',   
         TCSAmount 
		 ,IDT.TCSAmount AS 'SUM_TCS'   
  ,SACM.Code as 'SAC', 
  Tax_Per,
 -- TCSR.TCSRate ,
  0 as TCSRate,
  --CASE When Convert(varchar(50),ISNULL(CAST(TCSRate AS INT),0)) =0  Then 'TCS'  
  --ELSE 'TCS ' + Convert(varchar(50),ISNULL(CAST(TCSRate AS INT),0)) + '%' END as TCS_Per   
  '' as TCS_Per
    FROM Invoice.InvoiceDetails IDT   
  LEFT JOIN Invoice.Invoice I ON I.ID = IDT.Invoice_ID                                                             
  AND I.YearCode = IDT.YearCode                                                               
  LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID                                                             
  AND Q.CompanyID = I.compcode  
  LEFT JOIN SAC_Master SACM ON  IDT.SACID = SACM.ID   
  --LEFT JOIN TCSRateMaster TCSR ON IDT.TCSRateID = TCSR.ACCode  
  WHERE IDT.Invoice_ID = @InvoiceID  AND Q.QuotationID = @QuotationID    
  
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
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
	 FROM [Invoice].[Invoice] I                                                                      
	 LEFT JOIN [Quotation].QuotationMaster Q ON Q.QuotationID = I.QuotationID AND I.YearCode = Q.YearID                                                                  
	 LEFT JOIN ServiceTax ST ON ST.Tax_ACCode = I.Tax_ID                                                                                                        
	 LEFT JOIN ServiceTaxCategory STC ON STC.ID = ST.Tax_Type                  
	 LEFT JOIN Invoice_OtherTax IOT ON IOT.Invoice_ID=I.ID AND IOT.YearCode=I.YearCode                                                        
	 WHERE                                                         
	 I.ID = @InvoiceID  --Modified By AP                                                         
	 AND Q.QuotationID = @QuotationID                                                   
  
	 print @ServiceTaxCategory  
  
	SELECT TOP 1 I.ID as InvoiceID,  
	  CM.Companyname AS 'CompanyName',  
 
	   CM.RegAddress as 'Address',  
	CM.CityIATACode,CM.Website,CM.Email,                                                            
	  '' AS 'HeadAddress',                                      
	'' AS 'HeadCompanyName',                              
	  '' AS 'HeadCityIATACode',                                                            
	'' AS AgentLogo,                                                             
	''AS  Phone,                                            
	''AS  Fax,                                                                
	'' AS  HeadPhone,                                                               
	'' AS  HeadFax,                                                             
	''AS HeadWebsite,                                               
	'' AS  HeadEmail,                                                                            
	  '' AS GSTIN               
	,'' AS SAC              
	,'' AS PlaceOfSupply              
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
	--,BM.Details AS  'BankDetails' 
	,'' AS MSMERegNo  
	,'' as IsTCS_Inv  
	,'' as IsTCS_Inv1
	,I.flag_InvOrTktInv   
	,LUT.LUTNumber
	,I.[EXP]
	,I.[SEZ]
	--,'' as 'AccountName'
	,AccountName
	,AccountNo
	--,BM.AccountPrefix 
	--,BM.BankID 
	--,BM.IsVirtualAccount 
	,AM.VirtualAccount
 
	,'' as 'AccountNo'
	,'' AS 'RedDotPrint'
	,CM.CompanyName  AS 'CompanyNameFooter'
	,I.AgentRefPO as CommercialIDRef
	,BM.Details as BankDetails
	FROM Invoice.Invoice I                                                                                                        
	LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID  
	  LEFT JOIN AgentMaster AM ON AM.AgentID = I.AgentID                                                                                                       
	LEFT JOIN CompanyMaster CM ON CM.CompanyID = I.compcode                                                                                                                 
	LEFT JOIN CompanyMaster CM1 ON CM1.CompanyID = CM1.CompanyID AND CM1.HeadOffice=1                                                                                                                
	--LEFT JOIN UploadImage UI ON UI.ParentID=Q.AgentID AND ParentPageType=7                                                      
	LEFT JOIN City C ON C.IATACode=CM.CityIATACode                                                        
	LEFT JOIN State S ON S.State_ID=C.State_IATACode              
	LEFT JOIN State_Code_Master ST ON  I.PlaceOfSupplierId=ST.ID                                           
	LEFT JOIN Country CR ON CR.IATACode=S.Country_IATACode                                                                   
	LEFT JOIN City C1 ON C1.IATACode=CM1.CityIATACode                 
	LEFT JOIN SAC_Master SA ON I.SAC_ID=SA.ID      
	LEFT JOIN State_Code_Master SCM on CM.StateCodeID = SCM.ID        
	LEFT JOIN  Invoice_New_IRN_SuperTaxJob_Details  IRNL on I.InvoiceNumber = IRNL.InvoiceID 
	and Convert(CHAR(8),I.Invoice_Date,112) = Convert(CHAR(8), CAST(IRNL.CreatedDate AS DATE),112) 
	LEFT JOIN CurrencyMaster CU ON CU.ID = I.Curr_ID 
	LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID 
	and CU.CurrencyCode  = BM.Currency   and BM.isActive = 1  
	LEFT JOIN LUTMASTER LUT ON I.compcode = LUT.CompanyID    
	AND CAST(I.Invoice_Date AS DATE) between CAST(LUT.ValidFrom AS DATE) AND CAST(LUT.ValidTo AS DATE) 
	AND (I.SEZ = 'SEZ' OR I.[EXP] = 'EXP') AND   LUT.IsActive = 1                                                
	WHERE I.ID = 1                                                           
  
 

	SELECT DISTINCT I.ID,                                                        
	 I.ID as Invoice_ID, --Modified By AP  
	 I.InvoiceNumber,
	 case when TypeOfDoc =1 then 'Invoice' WHEN TypeOfDoc=2 THEN 'Performa' END as Type_Of_Doc, InvoiceType,                                                             
	 CONVERT(varchar,Invoice_Date,106) AS Invoice_Date,I.FileCode ,I.QuotationID,I.GuestName AS 'CustomerName',                                                                                                         
	 I.Tax_ID,Invoice_No_Of_Pax, '' as Invoice_Credit_Note, IDT.TotalInvoiceAmount ,                                                            
	 Reference,compcode,                                                       
	 I.YearCode--Modified By AP                                                        
	 ,'' AS ReceivedAmt,'' AS BalAmt                                
	 ,MiscAcc,RefNo,PreviousYear,isVoid,                                                            
	 ConvertedInvNo,I.CreatedBy,I.CreatedDateTime,I.LastUpdatedBy,I.LastUpdateDateTime,                                                                      
	 CASE                                                             
	 WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN ISNULL(HM.HotelName, VM.VendorName)                                                 
	 ELSE AM.AgentName                                                             
	 END AS 'AgentName'                                                             
	 ,I.GuestName as 'CustomerName',                                                                     
	 (SELECT TOP 1 EmpName from EmployeeMaster EM) AS 'EmployeeName',                                                              
	 CASE                                                             
	 WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN ISNULL(HM.Address,VM.Address)                                                            
	 ELSE AM.Address                                                             
	 END AS 'AgentAddress',   
	 CASE                                                         
	 WHEN AM.AgentName <>'' THEN 'StateCode : '+ ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM LEFT join AgentMaster AM on AM.StateCodeID = SCM.ID where AM.AgentID = I.AgentID),'')  --'StateName  :'+ISNULL(AM.STRegNo,'')                 
	 WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN 'StateCode  :'+ ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM LEFT join HotelMaster HM on HM.StateCodeID = SCM.ID where HM.HotelID = I.AgentID) ,(SELECT TOP 1 State_Code from State_Code_Master SCM 
	 LEFT join VendorMaster VM on VM.StateCodeID = SCM.ID where VM.VendorID  = I.AgentID) )                                                         
	 ELSE ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM left join AgentMaster AM on AM.StateCodeID = SCM.ID where AM.AgentCode = I.AgentID),'')                                                                        
	 END AS 'AgentPhone',        
	 
	 CASE                                                         
		 WHEN 
			AM.AgentName <>'' 
		THEN  
			ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM LEFT join AgentMaster AM on AM.StateCodeID = SCM.ID where AM.AgentID = I.AgentID),'')            
		 WHEN 
			(I.IsDirectPayment=1 OR IsBTCComm =1) 
		THEN  
			ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM LEFT join HotelMaster HM on HM.StateCodeID = SCM.ID where HM.HotelID = I.AgentID) ,(SELECT TOP 1 State_Code from State_Code_Master SCM 
			LEFT join VendorMaster VM on VM.StateCodeID = SCM.ID where VM.VendorID  = I.AgentID) )                                                         
		 ELSE 
			ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM left join AgentMaster AM on AM.StateCodeID = SCM.ID where AM.AgentCode = I.AgentID),'')                                                                        
	 END AS 'StateCode',                                         
	 CASE                                                         
	 WHEN AM.AgentName <>'' THEN 'GSTIN  :'+ISNULL(AM.STRegNo,'')                 
	 WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN 'GSTIN  :'+ ISNULL(HM.STRegNo,VM.STRegNo)                                                         
	 ELSE ''                                                         
	 END AS 'AgentGSTIN',  
	CASE
		WHEN 
			AM.AgentName <>'' 
		THEN 
			ISNULL(AM.STRegNo,'')                 
		WHEN 
			(I.IsDirectPayment=1 OR IsBTCComm =1) 
		THEN  
			ISNULL(HM.STRegNo,VM.STRegNo)                                                         
		ELSE ''
	END AS 'GSTIN',  
 
	 '' as 'PANNo' ,   
	 CASE                                                          
	 WHEN AM.AgentName <>'' THEN ABM.BankAccountDetails                 
	 WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN ISNULL(ABM1.BankAccountDetails,ABM2.BankAccountDetails)                                                         
	 ELSE ''                                                         
	 END AS 'BankAccountDetails'                                                         
	 ,IDT.TaxAmount AS TaxAmount                                    
	 ,'' AS TaxDesc                                              
	 ,'' AS OtherTaxDesc                              
	 ,IDT.UTGST AS OtherTaxAmount                              
	 ,'' AS KKTTaxDesc                                                  
	 ,IDT.IGST AS KKTTaxAmount  
	 ,G1.GSTPercentage AS GST_Perc  
	 ,ISNULL(IDT.IGST, '0.00') AS IGST     
	 ,ISNULL(IDT.UTGST, '0.00') AS UTGST                 
	 ,'CGSTDESC' AS CGSTTaxDesc ,ISNULL(IDT.CGST, '0.00') AS CGST                     
	 ,'SGSTDESC' AS SGSTTaxDesc ,ISNULL(IDT.SGST, '0.00') AS SGST                                     
	 ,CASE               
	 WHEN ISNULL(I.IsBillOfSupply,0)=1              
	 THEN 'YES'              
	 ELSE 'No'END   AS IsBillOfSupply                                    
	 ,AM.IsSEZ    -- by dhvani @11282919 to display sez line report if issez is true       
	 ,Case when I.IsDirectPayment=1 THEN HM.LegalName else '' end as LegalName     
	 ,'' as TCSValue ,''  as TCSRate  
	 ,G1.GSTPercentage AS 'GST_Perc'  
	 ,C.Name  AS 'Curr_Name'  
	 ,I.flag_InvOrTktInv
	 ,AM.VirtualAccount 
	 FROM Invoice.Invoice I  
	 LEFT JOIN Invoice.InvoiceDetails IDT  ON I.ID = IDT.Invoice_ID     
	 LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID AND I.YearCode = Q.YearID                              
          
	 LEFT JOIN AgentMaster AM ON AM.AgentID = I.AgentID                                                                      
	 LEFT JOIN HotelMaster HM ON HM.HotelID =I.AgentID                                             
	 LEFT JOIN VendorMaster VM ON VM.VendorID =I.AgentID          
	 left JOIN GST_Percentage G1 ON  I.GST_Perc = G1.GSTID   
	 --LEFT JOIN GSTTypeMaster G ON G.GSTID=Q.GSTTypeID                                                                                                     
	 left join  AccountsBankMaster ABM ON ABM.AccountBankMasterID=AM.BankAccountID   
	 left join  AccountsBankMaster ABM1 ON ABM1.AccountBankMasterID=HM.BankAccountID   
	 left join  AccountsBankMaster ABM2 ON ABM2.AccountBankMasterID=VM.BankAccountID                                                       
	 LEFT JOIN Invoice_OtherTax IOT ON IOT.Invoice_ID=I.ID AND IOT.YearCode=I.YearCode												 
	 LEFT JOIN CurrencyMaster C on I.Curr_ID = C.id  
          
	 WHERE                                                         
	 I.ID = 1                                                          
                                                                              
  
	  select IDT.ID as InvoiceDetailID,IDT.Invoice_ID,Invoice_Desc,Invoice_Value,IDT.YearCode,IDT.TotalTaxable_Amount, IDT.TotalTax_Amount as 'Tax_Amount' 
	  ,IDT.TotalBasicAmount , IDT.TotalTaxable_Amount as 'SUM_Taxable_Amount',
	  --I.TaxAmount as 'SUM_Tax_Amount',  
	  0 as 'SUM_Tax_Amount',  
	  IDT.TotalBasicAmount AS 'SUM_TotalBaseFare',   
			 TCSAmount 
			 ,IDT.TCSAmount AS 'SUM_TCS'   
	  ,SACM.Code as 'SAC', 
	  Tax_Per,
	 -- TCSR.TCSRate ,
	  0 as TCSRate,
	  --CASE When Convert(varchar(50),ISNULL(CAST(TCSRate AS INT),0)) =0  Then 'TCS'  
	  --ELSE 'TCS ' + Convert(varchar(50),ISNULL(CAST(TCSRate AS INT),0)) + '%' END as TCS_Per   
	  '' as TCS_Per
		FROM Invoice.InvoiceDetails IDT   
	  LEFT JOIN Invoice.Invoice I ON I.ID = IDT.Invoice_ID                                                             
	  AND I.YearCode = IDT.YearCode                                                               
	  LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID                                                             
	  AND Q.CompanyID = I.compcode  
	  LEFT JOIN SAC_Master SACM ON  IDT.SACID = SACM.ID   
	  --LEFT JOIN TCSRateMaster TCSR ON IDT.TCSRateID = TCSR.ACCode  
	  WHERE IDT.Invoice_ID = 1  --AND Q.QuotationID = @QuotationID    
  END
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END   
  
  


