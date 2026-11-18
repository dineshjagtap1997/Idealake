--DECLARE
-- @InvoiceID int=282,                                                                                      
-- @BookingID INT =476,
-- @Action Char(1)='S'
ALTER PROC [Invoice].[USP_GetInvoiceReportNewHorizontalOne]                 
(                                                                                      
 @InvoiceID int,                                                                                      
 @BookingID INT   ,
 @Action Char(1)
)                                                                                      
AS                                                                                                        
BEGIN                                          
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
	 FROM   Invoice.Invoice I  WHERE  I.ID = @InvoiceID  AND BookingID = @BookingID  
 
	 DECLARE @IsRedDotCompany varchar(10)
	 SELECT @IsRedDotCompany = SAP_CompanyCode  from CompanyMaster  WHERE CompanyID IN (SELECT CompanyID from Booking.tbl_Booking where id = @BookingID )
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
  
  
	 SELECT TOP 1 @ExistingAccountNumberRedDOT =  BM.AccountNo , @DisplayExistingAccountNameRedDOT=  BM.AccountName,@DisplayExistingAccountDetailsRedDOT = BM.Details  from Invoice.Invoice I  
	LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID  
	LEFT JOIN AgentMaster AM ON AM.AgentID = I.AgentID 
	LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID --and I.Curr_ID = BM.Currency 
	AND BM.isActive = 1 AND BM.IsRedDot= 1   
	WHERE I.ID = @InvoiceID AND I.BookingID = @BookingID   
 
	 SELECT TOP 1 @VirtualAccountNumber = BM.AccountPrefix + B.FileCode, @DisplayVirtualAccountName=  BM.AccountName,@DisplayVirtualAccountDetails = BM.Details  from Invoice.Invoice I 
	LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID  
	LEFT JOIN AgentMaster AM ON AM.AgentID = I.AgentID 
	LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID --and I.Curr_ID = BM.Currency   
	and BM.isActive = 1  
	LEFT JOIN Booking.tbl_Booking B ON I.BookingID=B.Id
	AND BM.IsVirtualAccount = 1 AND AM.VirtualAccount = 1 
	WHERE I.ID = @InvoiceID AND I.BookingID = @BookingID  

	 SELECT TOP 1 @ExistingAccountNumber =  BM.AccountNo , @DisplayExistingAccountName=  BM.AccountName,@DisplayExistingAccountDetails = BM.Details  from Invoice.Invoice I  
	LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID  
	LEFT JOIN AgentMaster AM ON AM.AgentID = I.AgentID 
	LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID --and I.Curr_ID = BM.Currency 
	AND BM.isActive = 1  
	WHERE I.ID = @InvoiceID AND I.BookingID = @BookingID

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
	 inner join Booking.tbl_Booking tbl on tbl.ID =i.BookingID                                                                
	 LEFT JOIN ServiceTax ST ON ST.Tax_ACCode = I.Tax_ID                                                                                                        
	 LEFT JOIN ServiceTaxCategory STC ON STC.ID = ST.Tax_Type                  
	 --LEFT JOIN Invoice_OtherTax IOT ON IOT.Invoice_ID=I.ID AND IOT.YearCode=I.YearCode                                                        
	 WHERE                                                         
	 I.ID = @InvoiceID  --Modified By AP                                                         
	 AND tbl.ID = @BookingID                                                   
  
	 print @ServiceTaxCategory  
  
	SELECT TOP 1 I.ID as InvoiceID,  
	  CM.Companyname AS 'CompanyName',  
 
	   CM.Address as 'Address',  
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
	  CM.salesTaxRegNumber AS GSTIN               
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
	, CM.Address as BranchAddress   
	--,dbo.fn_StripHTML_BR(BM.Details) as 'BankDetails'   
	--,BM.Details AS  'BankDetails' 
	--,CM.MsmeNo AS MSMERegNo  
	,(select top 1  Msmeno from EntityMaster where id=CM.TEntity_ID) as MSMERegNo
	,'' as IsTCS_Inv  
	,'' as IsTCS_Inv1
	,I.flag_InvOrTktInv   
	,LUT.LUTNumber
	,I.[EXP]
	,I.[SEZ]
	--,'' as 'AccountName'
	--,AccountName
	,@DisplayAccountName as AccountName
	--,AccountNo
	,@DisplayAccountNumber as AccountNo
	--,BM.AccountPrefix 
	--,BM.BankID 
	--,BM.IsVirtualAccount 
	,AM.VirtualAccount
 
	,'' as 'AccountNo'
	,'' AS 'RedDotPrint'
	,CM.CompanyName  AS 'CompanyNameFooter'
	,I.AgentRefPO as CommercialIDRef
	--,BM.Details as BankDetails
	,dbo.fn_StripHTML_BR(@DisplayAccountDetails) as 'BankDetails'  
	FROM Invoice.Invoice I  
	inner join Booking.tbl_Booking tbl on tbl.ID =i.BookingID
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
	--LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID 
	LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and BM.isActive = 1  
	and CU.CurrencyCode  = BM.Currency   and BM.isActive = 1  
	LEFT JOIN LUTMASTER LUT ON I.compcode = LUT.CompanyID    
	AND CAST(I.Invoice_Date AS DATE) between CAST(LUT.ValidFrom AS DATE) AND CAST(LUT.ValidTo AS DATE) 
	AND ((ISNULL(I.SEZ,'')='' OR I.SEZ = 'SEZ') OR (ISNULL(I.[EXP],'')='' OR I.[EXP] = 'EXP'))
	AND LUT.IsActive = 1                                                
	WHERE I.ID = @InvoiceID and tbl.ID =@BookingID                                                          
  
 

	SELECT DISTINCT I.ID,                                                        
	 I.ID as Invoice_ID, --Modified By AP  
	 I.InvoiceNumber,
	 case when TypeOfDoc =1 then 'Invoice' WHEN TypeOfDoc=2 THEN 'Proforma' END as Type_Of_Doc, InvoiceType,                                                             
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
	 --CASE                                                             
	 --WHEN (I.IsDirectPayment=1 OR IsBTCComm =1) THEN ISNULL(HM.Address,VM.Address)                                                            
	 --ELSE AM.Address                                                             
	 --END AS 'AgentAddress',
	  CASE 
		WHEN (I.IsDirectPayment=1 OR IsBTCComm=1) 
			 THEN REPLACE(REPLACE(REPLACE(REPLACE(
				 dbo.fn_StripHTML(ISNULL(HM.Address, VM.Address)),
				 '&nbsp;', ' '), '&amp;', '&'), '&lt;', '<'), '&gt;', '>')
		ELSE REPLACE(REPLACE(REPLACE(REPLACE(
				 dbo.fn_StripHTML(AM.Address),
				 '&nbsp;', ' '), '&amp;', '&'), '&lt;', '<'), '&gt;', '>')
	END AS AgentAddress,
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
	 ,isnull(IDT.TotalBasicAmount,0) AS TotalBasicAmount
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
	 --,  I.Reference as BookedBy
	 ,I.AgentBookerName as BookedBy
	 --, I.RefNo as YourRef
	 ,I.AgentRefPO as YourRef
	 ,isnull((select TOP 1 Description from InvoiceDescription_Master WHERE InvDesc_ID=IDT.Invoice_Desc_ID),'') as InvoiceDesc
	 FROM Invoice.Invoice I  
	 inner join Booking.tbl_Booking tbl on tbl.id =i.BookingID
	 LEFT JOIN Invoice.InvoiceDetails IDT  ON I.ID = IDT.Invoice_ID                                  
     LEFT JOIN AgentMaster AM ON AM.AgentID = I.AgentID                                                                      
	 LEFT JOIN HotelMaster HM ON HM.HotelID =I.AgentID                                             
	 LEFT JOIN VendorMaster VM ON VM.VendorID =I.AgentID          
	 left JOIN GST_Percentage G1 ON  I.GST_Perc = G1.GSTID   
	 --LEFT JOIN GSTTypeMaster G ON G.GSTID=Q.GSTTypeID                                                                                                     
	 left join  AccountsBankMaster ABM ON ABM.AccountBankMasterID=AM.BankAccountID   
	 left join  AccountsBankMaster ABM1 ON ABM1.AccountBankMasterID=HM.BankAccountID   
	 left join  AccountsBankMaster ABM2 ON ABM2.AccountBankMasterID=VM.BankAccountID                                                       
	 --LEFT JOIN Invoice_OtherTax IOT ON IOT.b AND IOT.YearCode=I.YearCode												 
	 LEFT JOIN CurrencyMaster C on I.Curr_ID = C.id  
     WHERE                                                         
	 I.ID = @InvoiceID and tbl.ID =@BookingID                                                          
                                                                              
  
	  select IDT.ID as InvoiceDetailID,IDT.Invoice_ID,Invoice_Desc,Invoice_Value,IDT.YearCode,isnull(IDT.TotalTaxable_Amount,0) as TotalTaxable_Amount,
	  isnull(IDT.TotalTax_Amount,0) as 'Tax_Amount' 
	  ,isnull(IDT.TotalBasicAmount,0) as 'TotalBasicAmount', 
	  --isnull(IDT.TotalTaxable_Amount,0) as 'SUM_Taxable_Amount',
	  isnull(IDT.TotalAmount,0) as 'SUM_Taxable_Amount',
	  --I.TaxAmount as 'SUM_Tax_Amount',  
	  0 as 'SUM_Tax_Amount',  
	  isnull(IDT.TotalBasicAmount,0) AS 'SUM_TotalBaseFare',   
			isnull( TCSAmount,0) as  TCSAmount
			 ,isnull(IDT.TCSAmount,0) AS 'SUM_TCS'   
	  ,SACM.Code as 'SAC', 
	  -- isnull(Tax_Per,0) as Tax_Per,

		isnull
		(
			(
				Select 
					TOP 1 g.GSTPercentage 
				from 
					ServiceTaxNew ST       
					INNER JOIN GST_Percentage g on ST.GSTID=g.GSTID
				WHERE
					Tax_ID=IDT.Tax_ID
			),0
		)
		as Tax_Per,
	 -- TCSR.TCSRate ,
	  0 as TCSRate,
	  --CASE When Convert(varchar(50),ISNULL(CAST(TCSRate AS INT),0)) =0  Then 'TCS'  
	  --ELSE 'TCS ' + Convert(varchar(50),ISNULL(CAST(TCSRate AS INT),0)) + '%' END as TCS_Per   
	  Convert(varchar(50),ISNULL(
		--CAST(
			(SELECT 
				TOP 1 
				TCSRate 
			FROM
				TCSRateMaster 
			WHERE
				TCSID = (
							SELECT 
								TOP 1 
								TCSRateId 
							FROM
								TCSLogicNew 
							WHERE 
								TCSLogicID=IDT.TCSRateID
						))
			--AS INT)
			,0)) + '%' AS TCS_Per,
	  c.CurrencyCode
		FROM Invoice.InvoiceDetails IDT   
	  inner join Invoice.Invoice I ON I.ID = IDT.Invoice_ID                                                             
	  AND I.YearCode = IDT.YearCode
	  inner join Booking.tbl_Booking tbl on tbl.id =i.BookingID
	  LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = I.QuotationID AND Q.CompanyID = I.compcode 
	  left join CurrencyMaster c on c.id =i.Curr_ID
	  LEFT JOIN SAC_Master SACM ON  IDT.SACID = SACM.ID   
	  --LEFT JOIN TCSRateMaster TCSR ON IDT.TCSRateID = TCSR.ACCode  
	  WHERE i.ID = @InvoiceID  AND tbl.ID = @BookingID    
  END
END   