CREATE PROC [dbo].[USP_GetAddendumReport] --'IN000041',103923--'IN000005',106195--'IN000024',67028--'IN000026' ,63696--'IN000027',63696                                                                  
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
	
	                                    
    
  SELECT @Tax_id=Tax_ID,                
  @Invoice_date=I.Invoice_Date,                
  @YearCode=I.YearCode                 
  FROM   Invoice_New I                 
  WHERE  I.Invoice_ID = @InvoiceID             
  AND Qut_ID = @QuotationID                                   
    
  SELECT @BizVerticalRedDot = Q.BussinessModuleID, @AddressCountryRedDot = AM.AddressCountry,
  @AddressonRecordRedDot = AM.AddressExist, @InvCurrRedDot = I.Curr_ID , @IsRedDotBankDetails = BM.isRedDot  
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
                          
    
  --OTHER(SBT) TAX DESC==============================                               
  SELECT                           
  @OtherTaxDesc= ISNULL(Tax_Desc,'') + ' @ '+ CAST(ISNULL(Tax_Percentage,0) AS VARCHAR(10)) ,                          
  @OtherTaxPerc=ISNULL(Tax_Percentage,0)                          
  FROM OtherServiceTax                  
  WHERE Tax_Type in(SELECT Tax_Type from ServiceTax WHERE Tax_ACCode in(@Tax_id))                                
  AND @Invoice_date  BETWEEN CONVERT(datetime,Tax_From_Date,112) AND CONVERT(datetime,Tax_To_Date,112) and IsActive=1                                  
  AND Other_Tax_Id=1 --1For SBT Tax                 
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
  CASE WHEN @IsRedDotPrint = '1' THEN 'RED DOT REPRESENTATIONS' ELSE 
   LEFT(CM.CompanyName, case when CHARINDEX(',', CM.CompanyName) = 0 then LEN(CM.CompanyName) ELSE CHARINDEX(',', CM.CompanyName)-1 END ) END as 'CompanyName',  
  --LEFT(CM.CompanyName, case when CHARINDEX(',', CM.CompanyName) = 0 then LEN(CM.CompanyName) ELSE CHARINDEX(',', CM.CompanyName)-1 END ) as 'CompanyName',  
 'Regd : ' + CONVERT(varchar(8000), CM.RegAddress) as 'Address',  
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
  ,ISNULL(ST.StateCode,'-') AS PlaceOfSupply            
  ,CASE         
  WHEN ISNULL(I.IsTaxReverseCharge,0)=1        
  THEN 'YES'        
  ELSE 'No'END   AS IsTaxReverseCharge         
  ,CASE               
  WHEN ISNULL(I.IsBillOfSupply,0)=1              
  THEN 'YES'              
  ELSE 'No'END   AS IsBillOfSupply,     
  IRNL.QR_Code_Signed as QRCode,    
  CAST('' AS Image) AS ShowImage, IRNL.ARN as 'IRN',CONVERT(varchar,IRNL.ACKDate,21) as  ACKDate, IRNL.ACKNo       
  ,CM.VATNo  
 ,SCM.State_Code AS 'STATE'  
 ,CM.CSTNo AS 'CGSTIN'  
 ,CM.CIN  
 ,CM.PanNo AS 'PAN'  
 ,CM.BranchAddress   
 ,dbo.fn_StripHTML_BR(BM.Details) as 'BankDetails'   
 ,CM.MsmeNo AS MSMERegNo   
   ,ISNULL(@IsRedDotPrint,0) AS 'RedDotPrint'
 --,1 AS 'RedDotPrint'
 , LEFT(CM.CompanyName, case when CHARINDEX(',', CM.CompanyName) = 0 then LEN(CM.CompanyName) ELSE CHARINDEX(',', CM.CompanyName)-1 END ) as 'CompanyNameFooter' 
  FROM Invoice_New I                                                                 
  INNER JOIN Quotation Q ON Q.QuotationID = I.Qut_ID                                       
  INNER JOIN CompanyMaster CM ON CM.CompanyID = Q.CompanyID                                                                                                            
  INNER JOIN CompanyMaster CM1 ON CM1.CompanyID = CM1.CompanyID AND CM1.HeadOffice=1                                      INNER JOIN Addendum ADM ON I.Invoice_ID = ADM.InvoiceID AND I.YearCode = ADM.YearCode                                              
  LEFT JOIN UploadImage UI ON UI.ParentID=Q.AgentID AND ParentPageType=7               
  LEFT JOIN City C ON C.IATACode=CM.CityIATACode                                                    
  LEFT JOIN State S ON S.State_ID=C.State_IATACode                                         
  LEFT JOIN State ST ON  I.StateCode_ID=ST.State_ID                  
  LEFT JOIN Country CR ON CR.IATACode=S.Country_IATACode                                                                        
  LEFT JOIN City C1 ON C1.IATACode=CM1.CityIATACode                                                         
  LEFT JOIN SAC_Master SA ON I.SAC_ID=SA.ID      
  Left join State_Code_Master SCM on CM.StateCodeID = SCM.ID   
  LEFT JOIN Invoice_ARN_ErrorLog IRNL on I.Invoice_ID = IRNL.InvoiceID and I.YearCode = IRNL.YearCode                                 
  LEFT JOIN Currency CURR on I.Curr_ID = CURR.Code  
   LEFT JOIN BankMasterNew BM ON I.compcode = BM.CompanyID and I.Curr_ID= BM.Currency                               
  WHERE I.Invoice_ID = @InvoiceID                                                                                  
  AND Q.QuotationID = @QuotationID                                                          
    
  SELECT distinct I.ID,                                                    
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
  WHEN (I.IsDirectPayment=1) THEN ISNULL(HM.HotelName,VM.VendorName)                                                         
  ELSE AM.AgentName                                                         
  END AS 'AgentName'                                                         
  ,Q.CustomerName,                                                                 
  (SELECT EmpName from EmployeeMaster EM where EM.UserID=Q.OperationBy) AS 'EmployeeName',                                                          
  CASE                                                         
  WHEN (I.IsDirectPayment=1) THEN ISNULL(HM.Address,VM.Address)                                                        
  ELSE AM.Address                     
  END AS 'AgentAddress',                                                           
  CASE                                                           
  WHEN AM.AgentName <>'' THEN 'Agent GSTIN  :'+ISNULL(AM.STRegNo,'')                   
  WHEN (I.IsDirectPayment=1) THEN 'Agent GSTIN  :'+ ISNULL(HM.STRegNo,VM.STRegNo)                                                           
  ELSE AM.AgentName                                                           
  END AS 'AgentGSTIN',    
  CASE                   
 WHEN AM.AgentName <>'' THEN 'StateCode : '+ ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM inner join AgentMaster AM on AM.StateCodeID = SCM.ID where AM.AgentCode = I.Agent_ID),'')  --'StateName  :'+ISNULL(AM.STRegNo,'')                 
 WHEN (I.IsDirectPayment=1) THEN 'StateCode  :'+ ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM inner join HotelMaster HM on HM.StateCodeID = SCM.ID where HM.HotelCode = I.Agent_ID) ,(SELECT TOP 1 State_Code from State_Code_Master SCM inner join VendorMaster VM on VM.StateCodeID = SCM.ID where VM.VendorCode = I.Agent_ID) )                                                         
 ELSE ISNULL((SELECT TOP 1 State_Code from State_Code_Master SCM left join AgentMaster AM on AM.StateCodeID = SCM.ID where AM.AgentCode = I.Agent_ID),'')                                                                        
 END AS 'AgentPhone',      
  CASE                                                           
  WHEN I.PANNo <>'' THEN '|  PAN : '+ISNULL(I.PANNo,'')                   
  ELSE ''                                                           
  END AS 'PANNo'                                                              
  ,ABM.BankAccountDetails     --added by sanket @ 06/04/2015                                                           
  ,ISNULL(IOT.ServiceTax_Amount,(I.TaxAmount-ISNULL(@SBTTaxAmount,0)-ISNULL(@KKTTaxAmount,0))) AS TaxAmount                                
  ,STC.ServiceTaxCategory +' @ '+ CAST((ISNULL(ST.Tax_Percentage,0)- ISNULL(@KKTTaxPerc,0)- ISNULL(@OtherTaxPerc,0)) AS VARCHAR(10)) TaxDesc                                          
  ,ISNULL(@OtherTaxDesc,'') AS OtherTaxDesc                          
  ,@SBTTaxAmount AS OtherTaxAmount                          
  ,ISNULL(@KKTTaxDesc,'') AS KKTTaxDesc                                              
  ,@KKTTaxAmount AS KKTTaxAmount                 
  ,@CGSTTaxDesc AS CGSTTaxDesc ,@CGSTTaxAmount AS CGSTTaxAmount                 
  ,@SGSTTaxDesc AS SGSTTaxDesc ,@SGSTTaxAmount AS SGSTTaxAmount                                 
  ,CASE               
  WHEN ISNULL(I.IsBillOfSupply,0)=1              
  THEN 'YES'              
  ELSE 'No'END   AS IsBillOfSupply                                    
  , AM.IsSEZ   -- by dhvani @11282919 to display sez line report if issez is true         
  ,HM.LegalName , IsDirectPayment ,case when (IsBTCComm = 1 ) then 1 else 0 end as IsBTCComm    
  ,I.TCSValue , t.TCSRate as TCSRate --, IsTCS_Inv  ,IsTCS_Inv1   
  FROM Invoice_New I                                                                  
  INNER JOIN Quotation Q ON Q.QuotationID = I.Qut_ID AND I.YearCode = Q.YearID                                            INNER JOIN Addendum ADM ON I.Invoice_ID = ADM.InvoiceID AND I.YearCode = ADM.YearCode               
  LEFT JOIN AgentMaster AM ON AM.AgentCode = I.Agent_ID                                                                  
  LEFT JOIN HotelMaster HM ON convert(varchar(20),HM.hotelcode)=I.Agent_ID                                         
  LEFT JOIN VendorMaster VM ON convert(VARCHAR(20),VM.VendorCode)=I.Agent_ID                                                            
  Left JOIN ServiceTax ST ON ST.Tax_ACCode = I.Tax_ID                                                                          
  LEFT JOIN ServiceTaxCategory STC ON STC.ID = ST.Tax_Type                                                                                                   
  INNER JOIN aspnet_Users AU ON AU.UserId=Q.OperationBy                                                        
  left join  AccountsBankMaster ABM ON ABM.AccountBankMasterID=AM.BankAccountID --added by sanket @ 06/04/2015                                                                                                    
  LEFT JOIN Invoice_OtherTax IOT ON IOT.Invoice_ID=I.Invoice_ID AND IOT.YearCode=I.YearCode       
  Left join TCSRateMaster t on I.TCSRateID = t.ACCode                                                      
  WHERE                                         
  I.Invoice_ID = @InvoiceID  --Modified By AP                                              
  AND Q.QuotationID = @QuotationID                                                                         
    
  Select IDT.ID,IDT.InvoiceID as Invoice_ID,Description as Invoice_Desc,IDT.Amount as Invoice_Value,IDT.YearCode,'0' as Taxable_Amount,'0' as Tax_Amount    
  ,'1' as flag ,'0' as TCSAmount  , '123' as SAC                                                                                                     
  FROM Addendum_details IDT                                                              
  INNER JOIN Addendum I ON I.InvoiceID = IDT.InvoiceID AND I.YearCode = IDT.YearCode                                                           
  --INNER JOIN Quotation Q ON Q.QuotationID = I.QuotationID AND Q.CompanyID = I.compcode                                                                 
  WHERE I.InvoiceID = @InvoiceID AND I.QuotationID = @QuotationID                                                                                    
 --End    
END 