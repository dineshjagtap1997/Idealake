-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>  AgentMaster.ChequeFavouring
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetBusinessDetails_InsertForSAP]

AS
BEGIN

	SET NOCOUNT ON;



IF OBJECT_ID('tempdb..#PreviousTagAgent') IS NOT NULL DROP TABLE #PreviousTagAgent
create table #PreviousTagAgent
(
id varchar(20),
PreviousCode varchar(8000)
)
insert into #PreviousTagAgent
 select AgentID , AgentCode + '-' + AgentName AS 'AgentCode' from AgentMaster WHERE IsActive = 0


IF OBJECT_ID('tempdb..#PreviousTag') IS NOT NULL DROP TABLE #PreviousTag
create table #PreviousTag
(
id varchar(20),
PreviousCode varchar(8000)
)
insert into #PreviousTag
select VendorID as ID, VendorSAPCode +'-'+ VendorName AS HotelCode  from VendorMaster where IsActive = 0


IF OBJECT_ID('tempdb..#PreviousTagHotel') IS NOT NULL DROP TABLE #PreviousTagHotel
create table #PreviousTagHotel
(
id varchar(20),
PreviousCode varchar(8000)
)
insert into #PreviousTagHotel
 select HotelID as ID, HotelSAPCode +'-'+ HotelName AS HotelCode  from HotelMaster where IsActive = 0



	
 DECLARE @runtime datetime
  set @runtime =  (SELECT SAP_BusinessDataJobTime.SAP_BusinessDate FROM SAP_BusinessDataJobTime)

 SELECT
  ROW_NUMBER() OVER ( ORDER BY T.[Biz Partner Code]) AS 'SR NO',
  T.[Object Task],
  T.[Biz Partner Code],
  T.[Biz Partner Group],
  T.[Biz Partner Type],
  T.[Biz Partner Name],
  T.[NAME2],
  T.[NAME3],
  T.[NAME4],
  T.[Address],
  T.[Address2],
  T.[Address3],	
  T.[Address4],		
  T.[Postal Code],
  T.[Country],
  T.[State],
  T.[City],
  T.[Market],
  T.[TamSalesEmpID],
  T.[GSTIN],
  T.[PanNo],
  T.[TANDetails],
  T.[MSME],
  T.[MSME Type],
  T.[IsSEZUnit],
  T.[ChequeFavouring],
  T.[BankName],
  T.[AccountNo],
  T.[BranchName],
  T.[IFSCCode],
  T.[ISCreditApplicable],
  T.[CreditPeriod],
  T.[CreditCurrencyCode],
  T.[CreditAllowance],
  T.[CreditApproveBy],
  T.[PhoneNo],
  T.[EmailID],
  T.[Legal Name],
  T.[Legal Name2],
  T.[Previous Code],
  T.[Deductee Type],
  T.[WithHoldigTax],
  T.[CustomerClassification],
  T.[VendorGrouping],
  T.[Commission Debtor],
  T.[Sales Head ID],
  T.[Business Head ID],
  T.[Active]



FROM
(



 select DISTINCT '' AS 'SR NO','I' as [Object Task], AgentCode  as 'Biz Partner Code', HotelGroups.Name as 'Biz Partner Group', 'C' as 'Biz Partner Type', 
  --SUBSTRING(REPLACE(REPLACE(AgentName, CHAR(13), ''), CHAR(10), '') ,1,40)  as 'Biz Partner Name', 
  --SUBSTRING(REPLACE(REPLACE(AgentName, CHAR(13), ''), CHAR(10), '') ,41,80) as 'NAME2', 
  --SUBSTRING(REPLACE(REPLACE(REPLACE(AgentMaster.Address, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') ,1,50) as 'Address',
  --SUBSTRING(REPLACE(REPLACE(REPLACE(AgentMaster.Address, CHAR(13), ''), CHAR(10), ''),CHAR(9), ''),51,100) as 'Address2',	
  --SUBSTRING(REPLACE(REPLACE(REPLACE(AgentMaster.Address, CHAR(13), ''), CHAR(10), ''),CHAR(9), ''),101,150)  as 'Address3',  

  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(NAME1, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitNamesToColumns]( AgentMaster.AgentName , 35)) end AS 'Biz Partner Name',
  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(NAME2, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitNamesToColumns]( AgentMaster.AgentName , 35)) end AS 'NAME2',
  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(NAME3, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitNamesToColumns]( AgentMaster.AgentName , 35)) end AS 'NAME3',
  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(NAME4, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitNamesToColumns]( AgentMaster.AgentName , 35)) end AS 'NAME4',

  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(Address1, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitAddressToColumns]( AgentMaster.Address , 35)) end AS 'Address',
  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(Address2, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitAddressToColumns]( AgentMaster.Address , 35)) end AS 'Address2',
  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(Address3, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitAddressToColumns]( AgentMaster.Address , 35)) end AS 'Address3',
  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(Address4, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitAddressToColumns]( AgentMaster.Address , 35)) end AS 'Address4',

  Case when AgentMaster.AddressCountry = 'IN' THEN AgentMaster.PostalCode else  Country.PostalCode end AS	'Postal Code',
  Country.IATACode	 AS 'Country',[State].Name AS	'State', City.Name AS 	'City', Market.Name AS 'Market',
	RelatedEmployeeID AS 'TamSalesEmpID', STRegNo AS 'GSTIN', PanNo AS  'PanNo',TANDetails  AS 'TANDetails', '' AS	'MSME','' as 'MSME Type',	IsSEZ AS 'IsSEZUnit',ChequeFavouring AS 'ChequeFavouring', '' AS	'BankName','' AS	'AccountNo',AgentBranchMapping.BranchName AS	'BranchName','' AS  'IFSCCode',CreditApplicable AS 'ISCreditApplicable',CreditPeriod AS	'CreditPeriod',CreditCurrencyCode AS	'CreditCurrencyCode',CONVERT(varchar(20),CreditAllowance) AS	'CreditAllowance',
	'' AS	'CreditApproveBy', REPLACE(REPLACE(REPLACE(PhoneNo, CHAR(13), ''), CHAR(10), ''),CHAR(9), '')  AS 'PhoneNo',EmailID AS	'EmailID',SUBSTRING(LegalName,1,40) AS	'Legal Name',SUBSTRING(LegalName,41,80) AS	'Legal Name2',#PreviousTagAgent.PreviousCode AS	'Previous Code', '' AS	'Deductee Type',
	'' AS	'WithHoldigTax',Agent_Classification_Master.Description AS	'CustomerClassification',	'' AS 'VendorGrouping','' AS	'Commission Debtor',SalesHeadID as 'Sales Head ID', AgentMaster.BusinessHeadID AS	'Business Head ID',AgentMaster.isActiveSAP AS	'Active'
	from AgentMaster
	--LEFT Join Country on AgentMaster.co = Market.ID 
	LEFT Join Market on AgentMaster.MarketID = Market.ID
	LEFT Join AccountsBankMaster  WITH(NOlOCK) on AgentMaster.BankAccountID = AccountsBankMaster.AccountBankMasterID
	LEFT JOIN AgentBranchMapping  WITH(NOlOCK) ON AgentBranchMapping.AgentID = AgentMaster.AgentID
	LEFT JOIN Agent_Classification_Master  WITH(NOlOCK) ON Agent_Classification_Master.ID = AgentMaster.AgentClassification
	left join EmployeeMaster  WITH(NOlOCK) on EmployeeMaster.EmpID = AgentMaster.RelatedEmployeeID
	LEFT JOIN City  WITH(NOlOCK) ON City.IATACode =AgentMaster.AddressCity    
	LEFT Join HotelGroups  WITH(NOlOCK) on HotelGroups.IATACode = AgentMaster.GroupID                                                                                              
	LEFT JOIn [State]  WITH(NOlOCK)  ON [State].State_ID =City.State_IATACode                                                               
	LEFT JOIN #PreviousTagAgent ON #PreviousTagAgent.id = AgentMaster.PreviousCode
	LEFT JOIN Country   WITH(NOlOCK) ON Country.IATACode = [State].Country_IATACode
	WHERE  AgentMaster.Operation = 'INSERT'  AND AgentMaster.OperationOn >=  @runtime
	--WHERE AgentMaster.AgentCode IN (
	--'DROI467'
	--)





	union

		select DISTINCT '' 'SR NO','I' as [Object Task], HotelSAPCode  as 'Biz Partner Code',  HotelGroups.Name as 'Biz Partner Group', 'V' as 'Biz Partner Type', 
		--SUBSTRING(REPLACE(REPLACE(HotelName, CHAR(13), ''), CHAR(10), '') ,1,40)  as 'Biz Partner Name',  
		--SUBSTRING(REPLACE(REPLACE(HotelName, CHAR(13), ''), CHAR(10), '') ,41,80) as 'NAME2', 
		--SUBSTRING(REPLACE(REPLACE(REPLACE(Address, CHAR(13), ''), CHAR(10), ''),CHAR(9), ''),1,50) as 'Address', 
		--SUBSTRING(REPLACE(REPLACE(REPLACE(Address, CHAR(13), ''), CHAR(10), ''),CHAR(9), ''),51,100) as 'Address2',
		--SUBSTRING(REPLACE(REPLACE(REPLACE(Address, CHAR(13), ''), CHAR(10), ''),CHAR(9), ''),101,150)  as 'Address3',

		  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(NAME1, CHAR(13), ''), CHAR(10), ''),CHAR(9), '')  FROM [dbo].[fnSplitNamesToColumns]( HotelMaster.HotelName , 35)) end AS 'Biz Partner Name',
		  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(NAME2, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitNamesToColumns]( HotelMaster.HotelName , 35)) end AS 'NAME2',
		  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(NAME3, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitNamesToColumns]( HotelMaster.HotelName , 35)) end AS 'NAME3',
		  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(NAME4, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitNamesToColumns]( HotelMaster.HotelName , 35)) end AS 'NAME4',

		  CASE WHEN 1 = 1 THEN (SELECT  REPLACE(REPLACE(REPLACE(Address1, CHAR(13), ''), CHAR(10), ''),CHAR(9), '')  FROM [dbo].[fnSplitAddressToColumns]( HotelMaster.Address , 35)) end AS 'Address',
		  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(Address2, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitAddressToColumns]( HotelMaster.Address , 35)) end AS 'Address2',
		  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(Address3, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitAddressToColumns]( HotelMaster.Address , 35)) end AS 'Address3',
		  CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(Address4, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitAddressToColumns]( HotelMaster.Address , 35)) end AS 'Address4',


		Case when HotelMaster.StateCodeID = '1' THEN  Country.PostalCode 
		when HotelMaster.StateCodeID IS NULL  THEN Country.PostalCode   else  HotelMaster.PostalCode End AS	'Postal Code',
	 --Case when HotelMaster.CompanyID  IN ('0', NULL) THEN Country.PostalCode else HotelMaster.PostalCode end AS	'Postal Code',	 
		 Country.IATACode	 AS 'Country',[State].Name AS	'State', City.Name AS 	'City', '' AS 'Market',
	'' AS 'TamSalesEmpID', STRegNo AS 'GSTIN', PanNo AS  'PanNo',TANDetails  AS 'TANDetails', isActiveMSME AS 'MSME',HotelMaster.MSMEType as 'MSME Type',
		'' AS 'IsSEZUnit',ChequeFavouring AS 'ChequeFavouring', BankName AS	'BankName',AccountNo AS	'AccountNo',BranchName AS	'BranchName', 
		IFSCCode AS	'IFSCCode', CreditApplicable AS 'ISCreditApplicable',CreditPeriod AS 'CreditPeriod',CreditCurrencyCode AS 'CreditCurrencyCode',CreditAmount AS 'CreditAllowance',CreditApproveBy AS 'CreditApproveBy',REPLACE(REPLACE(REPLACE(PhoneNo, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') AS 'PhoneNo',EmailID AS	'EmailID', SUBSTRING(LegalName,1,40) as 'Legal Name',	 SUBSTRING(LegalName,41,80) as 'Legal Name2',#PreviousTagHotel.PreviousCode AS	'Previous Code', case when Deductee ='1' then 'Company' when Deductee ='2' then 'NonCompany'else '' end AS	'Deductee Type',Withholding_Tax_Master.Tax_Code AS 'WithHoldigTax','' AS	'CustomerClassification', 'SUNDRY CR HOTEL'	as 'VendorGrouping',HotelMaster.CreateCommissionAccount AS	'Commission Debtor','' as 'Sales Head ID', '' AS	'Business Head ID',HotelMaster.isActiveSAP AS	'Active'
	from HotelMaster
	LEFT Join HotelGroups  WITH(NOlOCK) on HotelGroups.IATACode = HotelMaster.ChainIATACode 
	LEFT JOIN City   WITH(NOlOCK) ON City.IATACode =HotelMaster.CityIATACode                                                                                                  
	LEFT JOIn [State]  WITH(NOlOCK)  ON [State].State_ID =City.State_IATACode                                                                                                  
	LEFT JOIN Country  WITH(NOlOCK) ON Country.IATACode = [State].Country_IATACode
	LEFT JOIN Withholding_Tax_Master WITH(NOlOCK) ON Withholding_Tax_Master.Tax_ID = HotelMaster.WithHoldigTax 
    LEFT JOIN #PreviousTagHotel ON #PreviousTagHotel.id = HotelMaster.PreviousCode
	WHERE  HotelMaster.Operation = 'INSERT' AND HotelMaster.OperationOn >= @runtime  
	--where HotelMaster.HotelSAPCode IN ('CH00032220')

	                  

	union

    select DISTINCT '' 'SR NO', 'I' as [Object Task], VendorSAPCode as 'Biz Partner Code',  HotelGroups.Name  as 'Biz Partner Group', 'V' as 'Biz Partner Type',  

	--SUBSTRING(REPLACE(REPLACE(VendorName, CHAR(13), ''), CHAR(10), '') ,1,40)  as 'Biz Partner Name',  
	--SUBSTRING(REPLACE(REPLACE(REPLACE(VendorName, CHAR(13), ''), CHAR(10), ''),char(9), '') ,41,80) as 'NAME2', 
	--SUBSTRING(REPLACE(REPLACE(REPLACE(Address, CHAR(13), ''), CHAR(10), ''),char(9), ''),1,50) as 'Address', 
	--SUBSTRING(REPLACE(REPLACE(REPLACE(Address, CHAR(13), ''), CHAR(10), ''),char(9), ''),51,100) as 'Address2',	
	--SUBSTRING(REPLACE(REPLACE(REPLACE(Address, CHAR(13), ''), CHAR(10), ''),char(9), ''),101,150) as 'Address3',

		CASE WHEN 1 = 1 THEN (SELECT  REPLACE(REPLACE(REPLACE(NAME1, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitNamesToColumns]( VendorMaster.VendorName , 35)) end AS 'Biz Partner Name',
		CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(NAME2, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitNamesToColumns]( VendorMaster.VendorName , 35)) end AS 'NAME2',
		CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(NAME3, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitNamesToColumns]( VendorMaster.VendorName , 35)) end AS 'NAME3',
		CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(NAME4, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitNamesToColumns]( VendorMaster.VendorName , 35)) end AS 'NAME4',

		CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(Address1, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitAddressToColumns]( VendorMaster.Address , 35)) end AS 'Address',
		CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(Address2, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitAddressToColumns]( VendorMaster.Address , 35)) end AS 'Address2',
		CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(Address3, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitAddressToColumns]( VendorMaster.Address , 35)) end AS 'Address3',
		CASE WHEN 1 = 1 THEN (SELECT REPLACE(REPLACE(REPLACE(Address4, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') FROM [dbo].[fnSplitAddressToColumns]( VendorMaster.Address , 35)) end AS 'Address4',

		 Case when VendorMaster.StateCodeID = '1' THEN  Country.PostalCode 
		when VendorMaster.StateCodeID IS NULL  THEN Country.PostalCode   else  VendorMaster.PostalCode End AS	'Postal Code',
	--Case when VendorMaster.StateCodeID IN ('1', NULL) THEN  Country.PostalCode else  VendorMaster.PostalCode end AS	'Postal Code',	
			 Country.IATACode	 AS 'Country',[State].Name AS	'State', City.Name AS 	'City', '' AS 'Market',
	'' AS 'TamSalesEmpID', STRegNo AS 'GSTIN', PanNo AS  'PanNo',TANDetails  AS 'TANDetails', isActiveMSME AS	'MSME', VendorMaster.MSMEType  as 'MSME Type',	'' AS 'IsSEZUnit',ChequeFavouring AS 'ChequeFavouring', BankName AS	'BankName',
	AccountNo  AS	'AccountNo',BranchName AS	'BranchName',IFSCCode AS	'IFSCCode', CreditApplicable AS 'ISCreditApplicable',CreditPeriod AS 'CreditPeriod',CreditCurrencyCode AS 'CreditCurrencyCode', CreditAmount AS 'CreditAllowance',CreditApproveBy AS 'CreditApproveBy',REPLACE(REPLACE(REPLACE(PhoneNo, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') AS 'PhoneNo',EmailID AS	'EmailID', SUBSTRING(LegalName,1,40) AS 'Legal Name',	SUBSTRING(LegalName,41,80) as 'Legal Name2', #PreviousTag.PreviousCode AS	'Previous Code', CASE WHEN Deductee ='1' THEN 'Company' WHEN Deductee ='2' THEN 'Non Company' ELSE Deductee END AS	'Deductee Type', 
	Withholding_Tax_Master.Tax_Code  AS 'WithHoldigTax','' AS	'CustomerClassification',
		 case when Accountgroup = 'L010' then 'SUNDRY CR TRANSPORT'
		 when Accountgroup = 'L011' then 'SUNDRY CR HANDLING'
		 when Accountgroup = 'L012' then 'SUNDRY CR TICKETING'
		 when Accountgroup = 'L013' then 'SUNDRY CR EXPENSES' 
		 when Accountgroup = 'L032' then 'SUNDRY CR OUTBOUND (IMP)' else '' end  as 'VendorGrouping'
	 ,VendorMaster.CreateCommissionAccount AS	'Commission Debtor','' as 'Sales Head ID',
	 '' AS	'Business Head ID',VendorMaster.isActiveSAP AS	'Active'
	from VendorMaster
	LEFT JOIN City  WITH(NOlOCK) ON City.IATACode =VendorMaster.CityIATACode                                                                                                  
	LEFT JOIn [State]  WITH(NOlOCK) ON [State].State_ID =City.State_IATACode                                                                                                  
	LEFT JOIN Country  WITH(NOlOCK) ON Country.IATACode = [State].Country_IATACode 
	LEFT JOIN HotelGroups WITH(NOlOCK) ON VendorMaster.BizPartnerGrp = HotelGroups.IATACode 
	LEFT JOIN Withholding_Tax_Master  WITH(NOlOCK) ON Withholding_Tax_Master.Tax_ID = VendorMaster.WithHoldigTax  
		LEFT JOIN #PreviousTag ON #PreviousTag.id = VendorMaster.PreviousCode
     WHERE  VendorMaster.Operation = 'INSERT' AND VendorMaster.OperationOn >= @runtime 
	--VendorMaster.VendorID = 1610 
	--WHERE VendorMaster.Operation = 'INSERT' AND VendorMaster.VendorSAPCode in ('CV00002030')


	

	 
)T


	UPDATE SAP_BusinessDataJobTime SET SAP_BusinessDataJobTime.SAP_BusinessDate = GETDATE() WHERE ID = 1

-- ---UPDATE SAP_BusinessDataJobTime SET SAP_BusinessDataJobTime.SAP_BusinessDate = DATEADD(MI,-17,GETDATE()) WHERE ID = 1


	  INSERT INTO [BusinessPartnerFile_Log]
           ([SR NO]
           ,[CompanyCode]
           ,[Biz Partner Code]
           ,[Biz Partner Group]
           ,[Biz Partner Type]
           ,[Biz Partner Name]
           ,[NAME2]
           ,[Address]
           ,[Address2]
           ,[Address3]
           ,[Postal Code]
           ,[Country]
           ,[State]
           ,[City]
           ,[Market]
           ,[TamSalesEmpID]
           ,[GSTIN]
           ,[PanNo]
           ,[TANDetails]
           ,[MSME]
           ,[MSME Type]
           ,[IsSEZUnit]
           ,[ChequeFavouring]
           ,[BankName]
           ,[AccountNo]
           ,[BranchName]
           ,[IFSCCode]
           ,[ISCreditApplicable]
           ,[CreditPeriod]
           ,[CreditCurrencyCode]
           ,[CreditAllowance]
           ,[CreditApproveBy]
           ,[PhoneNo]
           ,[EmailID]
           ,[Legal Name]
           ,[Legal Name2]
           ,[Previous Code]
           ,[Deductee Type]
           ,[WithHoldigTax]
           ,[CustomerClassification]
           ,[VendorGrouping]
           ,[Commission Debtor]
           ,[Sales Head ID]
           ,[Business Head ID]
           ,[Active]
           ,[SAPFileName]
           ,[SAPInsertUpdateFlag]
           )

 SELECT
  ROW_NUMBER() OVER ( ORDER BY T.[Biz Partner Code]) AS 'SR NO',
  T.[Object Task],
  T.[Biz Partner Code],
  T.[Biz Partner Group],
  T.[Biz Partner Type],
  T.[Biz Partner Name],
  T.[NAME2],
  T.[Address],
  T.[Address2],
  T.[Address3],	
  T.[Postal Code],
  T.[Country],
  T.[State],
  T.[City],
  T.[Market],
  T.[TamSalesEmpID],
  T.[GSTIN],
  T.[PanNo],
  T.[TANDetails],
  T.[MSME],
  T.[MSME Type],
  T.[IsSEZUnit],
  T.[ChequeFavouring],
  T.[BankName],
  T.[AccountNo],
  T.[BranchName],
  T.[IFSCCode],
  T.[ISCreditApplicable],
  T.[CreditPeriod],
  T.[CreditCurrencyCode],
  T.[CreditAllowance],
  T.[CreditApproveBy],
  T.[PhoneNo],
  T.[EmailID],
  T.[Legal Name],
  T.[Legal Name2],
  T.[Previous Code],
  T.[Deductee Type],
  T.[WithHoldigTax],
  T.[CustomerClassification],
  T.[VendorGrouping],
  T.[Commission Debtor],
  T.[Sales Head ID],
  T.[Business Head ID],
  T.[Active],
  'BusinessPartner',
  'Insert'



FROM
(
 select DISTINCT '' AS 'SR NO','I' as [Object Task], AgentCode  as 'Biz Partner Code', HotelGroups.Name as 'Biz Partner Group', 'C' as 'Biz Partner Type', 
 --SUBSTRING(REPLACE(REPLACE(AgentName, CHAR(13), ''), CHAR(10), '') ,1,40)  as 'Biz Partner Name',  
 --SUBSTRING(REPLACE(REPLACE(AgentName, CHAR(13), ''), CHAR(10), '') ,41,80) as 'NAME2', 
 --SUBSTRING(REPLACE(REPLACE(REPLACE(AgentMaster.Address, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') ,1,50) as 'Address', 
 --SUBSTRING(REPLACE(REPLACE(REPLACE(AgentMaster.Address, CHAR(13), ''), CHAR(10), ''),CHAR(9), ''),51,100) as 'Address2',	
 --SUBSTRING(REPLACE(REPLACE(REPLACE(AgentMaster.Address, CHAR(13), ''), CHAR(10), ''),CHAR(9), ''),101,150)  as 'Address3', 


  CASE WHEN 1 = 1 THEN (SELECT NAME1 FROM [dbo].[fnSplitNamesToColumns]( AgentMaster.AgentName , 35)) end AS 'Biz Partner Name',
  CASE WHEN 1 = 1 THEN (SELECT NAME2 FROM [dbo].[fnSplitNamesToColumns]( AgentMaster.AgentName , 35)) end AS 'NAME2',
  --CASE WHEN 1 = 1 THEN (SELECT NAME3 FROM [dbo].[fnSplitNamesToColumns]( AgentMaster.AgentName , 35)) end AS 'NAME3',
  --CASE WHEN 1 = 1 THEN (SELECT NAME4 FROM [dbo].[fnSplitNamesToColumns]( AgentMaster.AgentName , 35)) end AS 'NAME4',

  CASE WHEN 1 = 1 THEN (SELECT Address1 FROM [dbo].[fnSplitAddressToColumns]( AgentMaster.Address , 35)) end AS 'Address',
  CASE WHEN 1 = 1 THEN (SELECT Address2 FROM [dbo].[fnSplitAddressToColumns]( AgentMaster.Address , 35)) end AS 'Address2',
  CASE WHEN 1 = 1 THEN (SELECT Address3 FROM [dbo].[fnSplitAddressToColumns]( AgentMaster.Address , 35)) end AS 'Address3',
  --CASE WHEN 1 = 1 THEN (SELECT Address4 FROM [dbo].[fnSplitAddressToColumns]( AgentMaster.Address , 35)) end AS 'Address4',
 
   
  Case when AgentMaster.AddressCountry = 'IN' THEN AgentMaster.PostalCode else  Country.PostalCode end AS	'Postal Code',
  Country.IATACode	 AS 'Country',[State].Name AS	'State', City.Name AS 	'City', Market.Name AS 'Market',
	RelatedEmployeeID AS 'TamSalesEmpID', STRegNo AS 'GSTIN', PanNo AS  'PanNo',TANDetails  AS 'TANDetails', '' AS	'MSME','' as 'MSME Type',	IsSEZ AS 'IsSEZUnit',ChequeFavouring AS 'ChequeFavouring', '' AS	'BankName','' AS	'AccountNo',AgentBranchMapping.BranchName AS	'BranchName','' AS  'IFSCCode',CreditApplicable AS 'ISCreditApplicable',CreditPeriod AS	'CreditPeriod',CreditCurrencyCode AS	'CreditCurrencyCode',CONVERT(varchar(20),CreditAllowance) AS	'CreditAllowance',
	'' AS	'CreditApproveBy', REPLACE(REPLACE(REPLACE(PhoneNo, CHAR(13), ''), CHAR(10), ''),CHAR(9), '')  AS 'PhoneNo',EmailID AS	'EmailID',SUBSTRING(LegalName,1,40) AS	'Legal Name',SUBSTRING(LegalName,41,80) AS	'Legal Name2',#PreviousTagAgent.PreviousCode AS	'Previous Code', '' AS	'Deductee Type',
	'' AS	'WithHoldigTax',Agent_Classification_Master.Description AS	'CustomerClassification',	'' AS 'VendorGrouping','' AS	'Commission Debtor',SalesHeadID as 'Sales Head ID', AgentMaster.BusinessHeadID AS	'Business Head ID',AgentMaster.isActiveSAP AS	'Active'
	from AgentMaster
	--LEFT Join Country on AgentMaster.co = Market.ID 
	LEFT Join Market on AgentMaster.MarketID = Market.ID
	LEFT Join AccountsBankMaster  WITH(NOlOCK) on AgentMaster.BankAccountID = AccountsBankMaster.AccountBankMasterID
	LEFT JOIN AgentBranchMapping  WITH(NOlOCK) ON AgentBranchMapping.AgentID = AgentMaster.AgentID
	LEFT JOIN Agent_Classification_Master  WITH(NOlOCK) ON Agent_Classification_Master.ID = AgentMaster.AgentClassification
	left join EmployeeMaster  WITH(NOlOCK) on EmployeeMaster.EmpID = AgentMaster.RelatedEmployeeID
	LEFT JOIN City  WITH(NOlOCK) ON City.IATACode =AgentMaster.AddressCity    
	LEFT Join HotelGroups  WITH(NOlOCK) on HotelGroups.IATACode = AgentMaster.GroupID                                                                                              
	LEFT JOIn [State]  WITH(NOlOCK)  ON [State].State_ID =City.State_IATACode                                                               
	LEFT JOIN #PreviousTagAgent ON #PreviousTagAgent.id = AgentMaster.PreviousCode
	LEFT JOIN Country   WITH(NOlOCK) ON Country.IATACode = [State].Country_IATACode
	WHERE  AgentMaster.Operation = 'INSERT' AND AgentMaster.OperationOn >= @runtime 
	--	WHERE AgentMaster.AgentCode IN (
	--'DROT1373',
	--'DROS1239'


	--)

	union

		select DISTINCT '' 'SR NO','I' as [Object Task], HotelSAPCode  as 'Biz Partner Code',  HotelGroups.Name as 'Biz Partner Group', 'V' as 'Biz Partner Type', 
		
		--SUBSTRING(REPLACE(REPLACE(HotelName, CHAR(13), ''), CHAR(10), '') ,1,40)  as 'Biz Partner Name',  
		--SUBSTRING(REPLACE(REPLACE(HotelName, CHAR(13), ''), CHAR(10), '') ,41,80) as 'NAME2', 
		--SUBSTRING(REPLACE(REPLACE(REPLACE(Address, CHAR(13), ''), CHAR(10), ''),CHAR(9), ''),1,50) as 'Address', 
		--SUBSTRING(REPLACE(REPLACE(REPLACE(Address, CHAR(13), ''), CHAR(10), ''),CHAR(9), ''),51,100) as 'Address2', 
		--SUBSTRING(REPLACE(REPLACE(REPLACE(Address, CHAR(13), ''), CHAR(10), ''),CHAR(9), ''),101,150)  as 'Address3',

		CASE WHEN 1 = 1 THEN (SELECT NAME1 FROM [dbo].[fnSplitNamesToColumns]( HotelMaster.HotelName , 35)) end AS 'Biz Partner Name',
		CASE WHEN 1 = 1 THEN (SELECT NAME2 FROM [dbo].[fnSplitNamesToColumns]( HotelMaster.HotelName , 35)) end AS 'NAME2',
		--CASE WHEN 1 = 1 THEN (SELECT NAME3 FROM [dbo].[fnSplitNamesToColumns]( HotelMaster.HotelName , 35)) end AS 'NAME3',
		--CASE WHEN 1 = 1 THEN (SELECT NAME4 FROM [dbo].[fnSplitNamesToColumns]( HotelMaster.HotelName , 35)) end AS 'NAME4',

		CASE WHEN 1 = 1 THEN (SELECT Address1 FROM [dbo].[fnSplitAddressToColumns]( HotelMaster.Address , 35)) end AS 'Address',
		CASE WHEN 1 = 1 THEN (SELECT Address2 FROM [dbo].[fnSplitAddressToColumns]( HotelMaster.Address , 35)) end AS 'Address2',
		CASE WHEN 1 = 1 THEN (SELECT Address3 FROM [dbo].[fnSplitAddressToColumns]( HotelMaster.Address , 35)) end AS 'Address3',
		--CASE WHEN 1 = 1 THEN (SELECT Address4 FROM [dbo].[fnSplitAddressToColumns]( HotelMaster.Address , 35)) end AS 'Address4',


		Case when HotelMaster.StateCodeID = '1' THEN  Country.PostalCode 
		when HotelMaster.StateCodeID IS NULL  THEN Country.PostalCode   else  HotelMaster.PostalCode End AS	'Postal Code',
	-- Case when HotelMaster.CompanyID  IN ('0', NULL) THEN Country.PostalCode else HotelMaster.PostalCode end AS	'Postal Code',	 
		 Country.IATACode	 AS 'Country',[State].Name AS	'State', City.Name AS 	'City', '' AS 'Market',
	'' AS 'TamSalesEmpID', STRegNo AS 'GSTIN', PanNo AS  'PanNo',TANDetails  AS 'TANDetails', isActiveMSME AS 'MSME',HotelMaster.MSMEType as 'MSME Type',
		'' AS 'IsSEZUnit',ChequeFavouring AS 'ChequeFavouring', BankName AS	'BankName',AccountNo AS	'AccountNo',BranchName AS	'BranchName', 
		IFSCCode AS	'IFSCCode', CreditApplicable AS 'ISCreditApplicable',CreditPeriod AS 'CreditPeriod',CreditCurrencyCode AS 'CreditCurrencyCode',CreditAmount AS 'CreditAllowance',CreditApproveBy AS 'CreditApproveBy',REPLACE(REPLACE(REPLACE(PhoneNo, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') AS 'PhoneNo',EmailID AS	'EmailID', SUBSTRING(LegalName,1,40) as 'Legal Name',	 SUBSTRING(LegalName,41,80) as 'Legal Name2',#PreviousTagHotel.PreviousCode AS	'Previous Code', case when Deductee ='1' then 'Company' when Deductee ='2' then 'NonCompany'else '' end AS	'Deductee Type',Withholding_Tax_Master.Tax_Code AS 'WithHoldigTax','' AS	'CustomerClassification', 'SUNDRY CR HOTEL'	as 'VendorGrouping',HotelMaster.CreateCommissionAccount AS	'Commission Debtor','' as 'Sales Head ID', '' AS	'Business Head ID',HotelMaster.isActiveSAP AS	'Active'
	from HotelMaster
	LEFT Join HotelGroups  WITH(NOlOCK) on HotelGroups.IATACode = HotelMaster.ChainIATACode 
	LEFT JOIN City   WITH(NOlOCK) ON City.IATACode =HotelMaster.CityIATACode                                                                                                  
	LEFT JOIn [State]  WITH(NOlOCK)  ON [State].State_ID =City.State_IATACode                                                                                                  
	LEFT JOIN Country  WITH(NOlOCK) ON Country.IATACode = [State].Country_IATACode
	LEFT JOIN Withholding_Tax_Master WITH(NOlOCK) ON Withholding_Tax_Master.Tax_ID = HotelMaster.WithHoldigTax 
    LEFT JOIN #PreviousTagHotel ON #PreviousTagHotel.id = HotelMaster.PreviousCode
	WHERE  HotelMaster.Operation = 'INSERT' AND HotelMaster.OperationOn >= @runtime   
	

	

	                         


	union

    select DISTINCT '' 'SR NO', 'I' as [Object Task], VendorSAPCode as 'Biz Partner Code',  HotelGroups.Name  as 'Biz Partner Group', 'V' as 'Biz Partner Type',  
	
	--SUBSTRING(REPLACE(REPLACE(VendorName, CHAR(13), ''), CHAR(10), '') ,1,40)  as 'Biz Partner Name',  
	--SUBSTRING(REPLACE(REPLACE(REPLACE(VendorName, CHAR(13), ''), CHAR(10), ''),char(9), '') ,41,80) as 'NAME2', 
	--SUBSTRING(REPLACE(REPLACE(REPLACE(Address, CHAR(13), ''), CHAR(10), ''),char(9), ''),1,50) as 'Address', 
	--SUBSTRING(REPLACE(REPLACE(REPLACE(Address, CHAR(13), ''), CHAR(10), ''),char(9), ''),51,100) as 'Address2',	
	--SUBSTRING(REPLACE(REPLACE(REPLACE(Address, CHAR(13), ''), CHAR(10), ''),char(9), ''),101,150) as 'Address3',

	CASE WHEN 1 = 1 THEN (SELECT NAME1 FROM [dbo].[fnSplitNamesToColumns]( VendorMaster.VendorName , 35)) end AS 'Biz Partner Name',
	CASE WHEN 1 = 1 THEN (SELECT NAME2 FROM [dbo].[fnSplitNamesToColumns]( VendorMaster.VendorName , 35)) end AS 'NAME2',
	--CASE WHEN 1 = 1 THEN (SELECT NAME3 FROM [dbo].[fnSplitNamesToColumns]( VendorMaster.VendorName , 35)) end AS 'NAME3',
	--CASE WHEN 1 = 1 THEN (SELECT NAME4 FROM [dbo].[fnSplitNamesToColumns]( VendorMaster.VendorName , 35)) end AS 'NAME4',

	CASE WHEN 1 = 1 THEN (SELECT Address1 FROM [dbo].[fnSplitAddressToColumns]( VendorMaster.Address , 35)) end AS 'Address',
	CASE WHEN 1 = 1 THEN (SELECT Address2 FROM [dbo].[fnSplitAddressToColumns]( VendorMaster.Address , 35)) end AS 'Address2',
	CASE WHEN 1 = 1 THEN (SELECT Address3 FROM [dbo].[fnSplitAddressToColumns]( VendorMaster.Address , 35)) end AS 'Address3',
	--CASE WHEN 1 = 1 THEN (SELECT Address4 FROM [dbo].[fnSplitAddressToColumns]( VendorMaster.Address , 35)) end AS 'Address4',

		 Case when VendorMaster.StateCodeID = '1' THEN  Country.PostalCode 
		when VendorMaster.StateCodeID IS NULL  THEN Country.PostalCode   else  VendorMaster.PostalCode End AS	'Postal Code',
	--Case when VendorMaster.StateCodeID IN ('1', NULL) THEN  Country.PostalCode else  VendorMaster.PostalCode end AS	'Postal Code',	
			 Country.IATACode	 AS 'Country',[State].Name AS	'State', City.Name AS 	'City', '' AS 'Market',
	'' AS 'TamSalesEmpID', STRegNo AS 'GSTIN', PanNo AS  'PanNo',TANDetails  AS 'TANDetails', isActiveMSME AS	'MSME', VendorMaster.MSMEType  as 'MSME Type',	'' AS 'IsSEZUnit',ChequeFavouring AS 'ChequeFavouring', BankName AS	'BankName',
	AccountNo  AS	'AccountNo',BranchName AS	'BranchName',IFSCCode AS	'IFSCCode', CreditApplicable AS 'ISCreditApplicable',CreditPeriod AS 'CreditPeriod',CreditCurrencyCode AS 'CreditCurrencyCode', CreditAmount AS 'CreditAllowance',CreditApproveBy AS 'CreditApproveBy',REPLACE(REPLACE(REPLACE(PhoneNo, CHAR(13), ''), CHAR(10), ''),CHAR(9), '') AS 'PhoneNo',EmailID AS	'EmailID', SUBSTRING(LegalName,1,40) AS 'Legal Name',	SUBSTRING(LegalName,41,80) as 'Legal Name2', #PreviousTag.PreviousCode AS	'Previous Code', CASE WHEN Deductee ='1' THEN 'Company' WHEN Deductee ='2' THEN 'Non Company' ELSE Deductee END AS	'Deductee Type', 
	Withholding_Tax_Master.Tax_Code  AS 'WithHoldigTax','' AS	'CustomerClassification',
		 case when Accountgroup = 'L010' then 'SUNDRY CR TRANSPORT'
		 when Accountgroup = 'L011' then 'SUNDRY CR HANDLING'
		 when Accountgroup = 'L012' then 'SUNDRY CR TICKETING'
		 when Accountgroup = 'L013' then 'SUNDRY CR EXPENSES' 
		 when Accountgroup = 'L032' then 'SUNDRY CR OUTBOUND (IMP)' else '' end  as 'VendorGrouping'
	 ,VendorMaster.CreateCommissionAccount AS	'Commission Debtor','' as 'Sales Head ID',
	 '' AS	'Business Head ID',VendorMaster.isActiveSAP AS	'Active'
	from VendorMaster
	LEFT JOIN City  WITH(NOlOCK) ON City.IATACode =VendorMaster.CityIATACode                                                                                                  
	LEFT JOIn [State]  WITH(NOlOCK) ON [State].State_ID =City.State_IATACode                                                                                                  
	LEFT JOIN Country  WITH(NOlOCK) ON Country.IATACode = [State].Country_IATACode 
	LEFT JOIN HotelGroups WITH(NOlOCK) ON VendorMaster.BizPartnerGrp = HotelGroups.IATACode 
	LEFT JOIN Withholding_Tax_Master  WITH(NOlOCK) ON Withholding_Tax_Master.Tax_ID = VendorMaster.WithHoldigTax  
		LEFT JOIN #PreviousTag ON #PreviousTag.id = VendorMaster.PreviousCode
   WHERE  VendorMaster.Operation = 'INSERT' AND VendorMaster.OperationOn >= @runtime 
   --WHERE VendorMaster.VendorSAPCode in ('CV00001457')
   --WHERE VendorMaster.VendorSAPCode in ('CV00001793') 



	
)T


END
