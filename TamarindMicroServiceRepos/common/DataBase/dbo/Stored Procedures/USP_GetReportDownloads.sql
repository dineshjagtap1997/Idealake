-- USP_GetReportDownloads '2023-06-01 00:00:00.000','2023-06-30 00:00:00.000','IN',213                                                          
CREATE PROCEDURE [dbo].[USP_GetReportDownloads] @dtFromdate DATETIME
	,@dtTodate DATETIME
	,@reportType NVARCHAR(20)
	,@YearCode INT
	, @OperationBy UNIQUEIDENTIFIER = NULL
	,@ReportName varchar(50) = NULL
	--,@Action CHAR(2) = 'S'
AS
BEGIN
	IF (@reportType = 'IN')
	BEGIN
		SELECT I.Invoice_ID
			,REPLACE(CONVERT(NVARCHAR, I.Invoice_date, 106), ' ', '-') AS Invoice_date
			,I.File_ID
			,AM.agentname AS QAgentName
			,I.Customer_Name
			,I.agent_id AS InvoicedAgentCode
			,CASE 
				WHEN I.agent_id LIKE 'DR%'
					THEN A.Agentname
				WHEN I.agent_id LIKE 'CV%'
					THEN V.Vendorname
				ELSE H.Hotelname
				END AS InvoicedAgentName
			,CASE 
				WHEN I.agent_id LIKE 'DR%'
					THEN A.stregno
				WHEN I.agent_id LIKE 'CV%'
					THEN V.stregno
				ELSE H.stregno
				END AS InvAgentGST
			--, case when I.agent_id like 'DR%' then A.Panno                                                           
			--when I.agent_id like 'CV%' then V.Panno                                                          
			--else H.Panno end as InvAgentPAN                                                          
			,CASE 
				WHEN istcsinvoice = 1
					THEN I.Panno
				ELSE (
						CASE 
							WHEN I.agent_id LIKE 'DR%'
								THEN A.Panno
							WHEN I.agent_id LIKE 'CV%'
								THEN V.Panno
							ELSE H.Panno
							END
						)
				END AS InvAgentPAN
			,CASE 
				WHEN I.agent_id LIKE 'DR%'
					THEN SCA.state_code
				WHEN I.agent_id LIKE 'CV%'
					THEN SCV.state_code
				ELSE SCH.state_code
				END AS InvAgentStateCode
			,I.Curr_id
			,I.invoice_exchg_rate AS 'ROE'
			,I.TotalBaseAmt AS BasicAmt
			,Invoice_Curr_Amt TaxableAmt
			--,(select top 1 tax_per from Invoice_Detail_new ID where ID.Invoice_id = I.Invoice_id                                                           
			--and ID.yearcode = I.yearcode) as TaxRate                                        
			,tax_per AS TaxRate
			,I.IGST
			,I.CGST
			,I.SGST
			,I.UTGST
			,t.TCSRate AS TCSRate
			,I.TCSValue
			,I.Invoice_Total AS TotalInvAmt
			--  ,(select top 1 SAC from Invoice_Detail_new ID where ID.Invoice_id = I.Invoice_id                                                           
			--   and ID.yearcode = I.yearcode) as SAC_Code                                      
			,SAC AS SAC_Code
			,Reference
			,Refno AS 'Ref/PO Number'
			,E.empname AS Username
			,Invoice_Type
			,c.CSTNo AS [Branch GSTIN]
			,'' AS 'Original invoice no'
			,'' AS 'Original invoice date'
			,c.companyname
			,B.BusinessModuleName AS BizVertical
			,CASE 
				WHEN I.agent_id LIKE 'DR%'
					THEN (
							CASE 
								WHEN (A.IsSez = '1')
									THEN 'True'
								ELSE 'False'
								END
							)
				WHEN I.agent_id LIKE 'CV%'
					THEN (
							CASE 
								WHEN (V.IsSez = '1')
									THEN 'True'
								ELSE 'False'
								END
							)
				ELSE (
						CASE 
							WHEN (H.IsSez = '1')
								THEN 'True'
							ELSE 'False'
							END
						)
				END AS Sez
			--, '' as Export                                                          
			,(
				CASE 
					WHEN (
							CR.Code != 'INR'
							AND (
								SCA.id = 1
								OR SCH.id = 1
								OR SCV.id = 1
								)
							AND SL.servLoc_id = 2
							)
						THEN 'Yes'
					ELSE 'No'
					END
				) AS Export
			,CASE 
				WHEN I.IsBTCComm = 1
					THEN 'True'
				ELSE 'False'
				END AS BTCComm
			,CASE 
				WHEN I.IsDirectPayment = 1
					THEN 'True'
				ELSE 'False'
				END AS DPComm
			,SL.Description AS ServiceLocation
			--,(select top 1 REPLACE(REPLACE(REPLACE(REPLACE(Invoice_desc, CHAR(13), ''), CHAR(10), ''),CHAR(9), ''),',', '-') from Invoice_Detail_new ID where ID.Invoice_id = I.Invoice_id                        
			--and ID.yearcode = I.yearcode) as InvDescription                            
			,REPLACE(REPLACE(REPLACE(REPLACE(Invoice_desc, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ',', '-') AS InvDescription
		FROM Invoice_New I WITH (NOLOCK)
		LEFT JOIN Invoice_Detail_new IDN WITH (NOLOCK) ON IDN.Invoice_id = I.Invoice_id
			AND IDN.yearcode = I.yearcode
			AND IDN.parent_id = I.ID
		LEFT JOIN agentmaster A WITH (NOLOCK) ON I.agent_id = A.AgentCode
		LEFT JOIN hotelmaster H WITH (NOLOCK) ON I.agent_id = H.HotelSAPCode
		LEFT JOIN vendormaster V WITH (NOLOCK) ON I.agent_id = V.VendorSAPCode
		LEFT JOIN State_Code_Master SCA WITH (NOLOCK) ON a.statecodeid = SCA.ID
		LEFT JOIN State_Code_Master SCH WITH (NOLOCK) ON H.statecodeid = SCH.ID
		LEFT JOIN State_Code_Master SCV WITH (NOLOCK) ON V.statecodeid = SCV.ID
		LEFT JOIN Quotation Q WITH (NOLOCK) ON I.qut_id = Q.Quotationid
		LEFT JOIN AgentMaster AM WITH (NOLOCK) ON Q.AgentID = AM.AgentID
		LEFT JOIN employeemaster E WITH (NOLOCK) ON I.createdby = E.userid
		--left join companymaster c on C.companyid = (case when isbtccomm = 1 then I.original_compid else I.compcode end)                                                                                                 
		LEFT JOIN companymaster c WITH (NOLOCK) ON C.companyid = I.compcode
		LEFT JOIN Businessmaster B WITH (NOLOCK) ON Q.BussinessModuleID = B.BussinessModuleID
		-- Left join Invoice_New_IRN_SuperTaxJob_Details IR with (nolock) on IR.Invoiceid = I.Invoice_id                                                         
		--and IR.invoicedate = CONVERT(CHAR(8),I.invoice_date,112)                                                        
		LEFT JOIN TCSRateMaster t WITH (NOLOCK) ON I.TCSRateID = t.ACCode
		LEFT JOIN currency CR WITH (NOLOCK) ON I.Curr_ID = CR.Code
		LEFT JOIN ServiceLocation_Master SL WITH (NOLOCK) ON Q.ServiceLocID = SL.servLoc_id
		WHERE I.Invoice_date BETWEEN @dtFromdate
				AND @dtTodate
			AND I.Invoice_ID LIKE '%IN%'
		OPTION (RECOMPILE)
	END
	ELSE IF (@reportType = 'XO')
	BEGIN
		SELECT Q.Filecode
			,RTRIM(Ltrim(X.XO_ID)) AS Xo_id
			,REPLACE(CONVERT(NVARCHAR, X.XO_date, 106), ' ', '-') AS XO_date
			,X.Sapcode
			,X.XO_Supplier_Name
			,x.Curr_ID
			,X.XO_Amt
			,CASE 
				WHEN X.Undo = 1
					THEN 'True'
				ELSE 'False'
				END AS Undo
			,REPLACE(CONVERT(NVARCHAR, X.UndoDate, 106), ' ', '-') AS UndoDate
			,CASE 
				WHEN X.IsDirectPayment = 1
					THEN 'True'
				ELSE 'False'
				END AS IsDirectPayment
			,CASE 
				WHEN X.IsBTCComm = 1
					THEN 'True'
				ELSE 'False'
				END AS IsBTCComm
			,X.CompName
			,X.XO_Customer_Name
			--,X.XO_Arr, X.XO_Dep                                                
			,CASE 
				WHEN X.isChange = 1
					THEN 'True'
				ELSE 'False'
				END AS SupplierChange
			,x.SAPUpdatedcode AS SupplierChangeCode
			,v.Vendorname AS SupplierChangeName
			,REPLACE(CONVERT(NVARCHAR, X.XO_Arr, 106), ' ', '-') AS XO_Arr
			,REPLACE(CONVERT(NVARCHAR, X.XO_Dep, 106), ' ', '-') AS XO_Dep
			--,X.XO_Arr, X.XO_Dep                                           
			,AU.UserName AS 'FHEName'
			,Confirmed_By AS RefrenceNo
			,CASE 
				WHEN HM.HotelSAPCode IS NOT NULL
					THEN HM.STRegNo
				WHEN v.VendorSAPCode IS NOT NULL
					THEN v.STRegNo
				ELSE ''
				END AS VendorGST
			,CASE 
				WHEN HMA.acccode IS NOT NULL
					THEN SMH.State_code
				WHEN vMA.acccode IS NOT NULL
					THEN SMV.State_code
				ELSE ''
				END AS StateCode
			,CM.CityIaTACode AS FileLocation
		FROM XO X
		LEFT JOIN Quotation Q WITH (NOLOCK) ON X.Qut_id = Q.Quotationid
		LEFT JOIN Vendormaster v WITH (NOLOCK) ON x.SAPUpdatedcode = v.VendorSAPCode
		LEFT JOIN HotelMaster HM WITH (NOLOCK) ON X.SAPCode = HM.HotelSAPCode
		LEFT JOIN XO_Instructions XOI WITH (NOLOCK) ON X.XO_ID = XOI.XO_ID
		LEFT JOIN aspnet_Users AU WITH (NOLOCK) ON AU.UserId = X.InsertedBy
		LEFT JOIN vendormaster VMA WITH (NOLOCK) ON X.accode = VMA.acccode
		LEFT JOIN Hotelmaster HMA WITH (NOLOCK) ON X.accode = HMA.acccode
		LEFT JOIN State_Code_Master SMV WITH (NOLOCK) ON VMA.statecodeid = SMv.ID
		LEFT JOIN State_Code_Master SMH WITH (NOLOCK) ON HMA.statecodeid = SMH.ID
		LEFT JOIN companymaster CM WITH (NOLOCK) ON Q.companyid = CM.companyid
		--from XO X                                    
		--Left join Quotation Q on X.Qut_id = Q.Quotationid                                             
		-- left join Vendormaster v with (nolock) on x.SAPUpdatedcode = v.VendorSAPCode                                                 
		--where X.XO_date between @dtFromdate and @dtTodate                                                       
		WHERE cast(xo_date AS DATE) BETWEEN cast(@dtFromdate AS DATE)
				AND cast(@dtTodate AS DATE)
		ORDER BY Q.Filecode
	END
	ELSE IF (@reportType = 'INR')
	BEGIN
		SELECT DISTINCT AU.[UserName] AS [USER Id]
			,QUOT.QuotationNo AS [Quot No]
			,
			--ISNULL(CONVERT(VARCHAR(10), Quot.[QuotationDate], 103), '') AS [Qtn Date],                                                 
			REPLACE(CONVERT(NVARCHAR, Quot.[QuotationDate], 106), ' ', '-') AS [Qtn Date]
			,QUOT.FileCode AS [File Code]
			,Upper(CM.CompanyName) AS Company_Name
			,CT.Name AS City
			,A.[AgentName] AS Agent
			,QUOT.[CustomerName] AS Customer
			,
			--ISNULL(CONVERT(VARCHAR(10), QUOT.TravelDateFrom, 103), '') AS [Arr Date],                                                 
			REPLACE(CONVERT(NVARCHAR, Quot.TravelDateFrom, 106), ' ', '-') AS [Arr Date]
			,
			--ISNULL(CONVERT(VARCHAR(10), Quot.TravelDateTo, 103), '') AS [Dep Date],                                                  
			REPLACE(CONVERT(NVARCHAR, Quot.TravelDateTo, 106), ' ', '-') AS [Dep Date]
			,CASE 
				WHEN ISNULL(QUOT.STATUS, 0) = 0
					THEN 'Yes'
				ELSE 'No'
				END AS Cancelled
		FROM --[Invoice] INV                                                                      
			Tamarind_V_1..[Quotation] QUOT WITH (NOLOCK)
		INNER JOIN Tamarind_V_1..[AgentMaster] A WITH (NOLOCK) ON QUOT.AgentID = A.[AgentID]
		INNER JOIN Tamarind_V_1..[City] CT WITH (NOLOCK) ON A.City_IATACode = CT.IATACode
		INNER JOIN Tamarind_V_1..aspnet_Users AU WITH (NOLOCK) ON AU.UserId = QUOT.OperationBy
		LEFT JOIN [CompanyMaster] CM WITH (NOLOCK) ON QUOT.CompanyID = CM.[CompanyID]
		WHERE CONVERT(VARCHAR(12), QUOT.TravelDateFrom, 112) BETWEEN CONVERT(VARCHAR(12), @dtFromdate, 112)
				AND CONVERT(VARCHAR(12), @dtTodate, 112)
			AND QUOT.QuotationID NOT IN (
				SELECT DISTINCT Qut_ID
				FROM Invoice_New WITH (NOLOCK)
				WHERE YearCode = @YearCode
					AND Invoice_ID LIKE '%IN%'
					AND (
						isbtccomm = 0
						OR isbtccomm IS NULL
						)
					AND (
						isdirectpayment = 0
						OR isdirectpayment IS NULL
						)
				)
			AND ISNULL(Quot.Costing, 0) = 2
			AND QUOT.YearID = @YearCode
			AND QUOT.IsInvoiceReqd = 1 --and AU.[UserName] like 'clintd'                                                        
		ORDER BY AU.UserName
			,QUOT.QuotationNo
	END
	ELSE IF (@reportType = 'IRN')
	BEGIN
		SELECT ID
			,InvoiceId AS [Invoice No]
			,REPLACE(CONVERT(VARCHAR(50), CAST(Invoicedate AS DATETIME), 106), ' ', '-') AS [Invoice Date]
			,AckNumber
			--,ACKDate             
			,REPLACE(CONVERT(VARCHAR(50), CAST(ACKDate AS DATETIME), 106), ' ', '-') AS ACKDate
			,IRN
			,REPLACE(REPLACE(REPLACE(REPLACE(Messages, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), '"', '') AS [Error Message]
		FROM Invoice_New_IRN_SuperTaxJob_Details
		WHERE invoicedate BETWEEN CONVERT(CHAR(8), @dtFromdate, 112)
				AND CONVERT(CHAR(8), @dtTodate, 112)
			AND InvoiceID LIKE '%IN%'
		ORDER BY ID DESC
	END
	ELSE IF (@reportType = 'XBTD')
	BEGIN
		SELECT REPLACE(CONVERT(NVARCHAR, Q.traveldatefrom, 106), ' ', '-') AS 'Tour Start Date'
			,Q.Filecode
			,Trim(X.Xo_id) AS Xo_id
			,REPLACE(CONVERT(NVARCHAR, X.XO_date, 106), ' ', '-') AS XO_date
			,X.Sapcode
			,X.XO_Supplier_Name
			,x.Curr_ID
			,X.XO_Amt
			,CASE 
				WHEN X.Undo = 1
					THEN 'True'
				ELSE 'False'
				END AS Undo
			,REPLACE(CONVERT(NVARCHAR, X.UndoDate, 106), ' ', '-') AS UndoDate
			,CASE 
				WHEN X.IsDirectPayment = 1
					THEN 'True'
				ELSE 'False'
				END AS IsDirectPayment
			,CASE 
				WHEN X.IsBTCComm = 1
					THEN 'True'
				ELSE 'False'
				END AS IsBTCComm
			,X.CompName
			,X.XO_Customer_Name
			--,X.XO_Arr, X.XO_Dep                                            
			,CASE 
				WHEN X.isChange = 1
					THEN 'True'
				ELSE 'False'
				END AS SupplierChange
			,x.SAPUpdatedcode AS SupplierChangeCode
			,v.Vendorname AS SupplierChangeName
			,REPLACE(CONVERT(NVARCHAR, X.XO_Arr, 106), ' ', '-') XO_Arr
			,REPLACE(CONVERT(NVARCHAR, X.XO_Dep, 106), ' ', '-') XO_Dep
			,AU.UserName AS 'FHEName'
			,Confirmed_By AS RefrenceNo
			,CASE 
				WHEN HM.HotelSAPCode IS NOT NULL
					THEN HM.STRegNo
				WHEN v.VendorSAPCode IS NOT NULL
					THEN v.STRegNo
				ELSE ''
				END AS VendorGST
			,CASE 
				WHEN HM.acccode IS NOT NULL
					THEN SMH.State_code
				WHEN vM.acccode IS NOT NULL
					THEN SMV.State_code
				ELSE ''
				END AS StateCode
			,CM.CityIaTACode AS FileLocation
		FROM XO X
		LEFT JOIN Quotation Q WITH (NOLOCK) ON X.Qut_id = Q.Quotationid
		LEFT JOIN Vendormaster v WITH (NOLOCK) ON x.SAPUpdatedcode = v.VendorSAPCode
		LEFT JOIN HotelMaster HM WITH (NOLOCK) ON X.SAPCode = HM.HotelSAPCode
		LEFT JOIN Vendormaster VM WITH (NOLOCK) ON X.SAPCode = VM.VendorSAPCode
		LEFT JOIN XO_Instructions XOI WITH (NOLOCK) ON X.XO_ID = XOI.XO_ID
		LEFT JOIN aspnet_Users AU WITH (NOLOCK) ON AU.UserId = X.InsertedBy
		LEFT JOIN State_Code_Master SMV WITH (NOLOCK) ON VM.statecodeid = SMv.ID
		LEFT JOIN State_Code_Master SMH WITH (NOLOCK) ON HM.statecodeid = SMH.ID
		LEFT JOIN companymaster CM WITH (NOLOCK) ON Q.companyid = CM.companyid
		WHERE Q.traveldatefrom BETWEEN @dtFromdate
				AND @dtTodate
		ORDER BY Q.traveldatefrom
	END
	ELSE IF (@reportType = 'CINR')
	BEGIN
		SELECT AU.UserName
			,QuotationNo
			,REPLACE(CONVERT(NVARCHAR, Q.QuotationDate, 106), ' ', '-') AS QuotationDate
			,q.FileCode AS Filecode
			,CM.CompanyName
			,AM.AgentName AS 'Agent'
			,XO_Customer_Name AS 'Customer'
			,CASE 
				WHEN v.Vendorname IS NULL
					THEN H.Hotelname
				ELSE V.Vendorname
				END AS VendorName
			,CASE 
				WHEN X.IsDirectPayment = 1
					THEN 'DP'
				WHEN X.IsBTCComm = 1
					THEN 'BTC'
				ELSE ''
				END AS CommType
			,REPLACE(CONVERT(NVARCHAR, Q.Traveldatefrom, 106), ' ', '-') AS 'Arr Date'
			,REPLACE(CONVERT(NVARCHAR, Q.Traveldateto, 106), ' ', '-') AS 'Dep Date'
			,XO_ID
			,REPLACE(CONVERT(NVARCHAR, X.XO_Arr, 106), ' ', '-') AS 'XOArrDate'
			,REPLACE(CONVERT(NVARCHAR, X.XO_Dep, 106), ' ', '-') AS 'XODepDate'
		FROM XO x
		LEFT JOIN Quotation q WITH (NOLOCK) ON x.Qut_ID = q.QuotationID
		LEFT JOIN aspnet_Users AU WITH (NOLOCK) ON Q.OperationBy = AU.userID
		LEFT JOIN Companymaster CM WITH (NOLOCK) ON Q.companyid = CM.companyid
		LEFT JOIN AgentMaster AM WITH (NOLOCK) ON AM.AgentID = Q.AgentID
		LEFT JOIN Vendormaster v WITH (NOLOCK) ON x.SAPcode = v.VendorSAPCode
		LEFT JOIN Hotelmaster H WITH (NOLOCK) ON x.SAPcode = H.HotelSAPCode
		WHERE NOT EXISTS (
				SELECT NULL
				FROM XOInvoiceMapping
				WHERE XOInvoiceMapping.XO_ID = x.XO_ID
					AND XOInvoiceMapping.Qut_ID = x.Qut_ID
				)
			AND (
				x.IsDirectPayment = 1
				OR x.IsBTCComm = 1
				)
			AND (
				x.Undo IS NULL
				OR x.undo = 0
				)
			AND Q.traveldatefrom BETWEEN @dtFromdate
				AND @dtTodate
		ORDER BY Q.QuotationNo
	END
	ELSE IF (@reportType = 'XBU')
	BEGIN
		SELECT REPLACE(CONVERT(NVARCHAR, X.UndoDate, 106), ' ', '-') AS UndoDate
			,Q.Filecode
			,Trim(X.Xo_id) AS Xo_id
			,REPLACE(CONVERT(NVARCHAR, X.XO_date, 106), ' ', '-') AS XO_date
			,X.Sapcode
			,X.XO_Supplier_Name
			,x.Curr_ID
			,X.XO_Amt
			,CASE 
				WHEN X.Undo = 1
					THEN 'True'
				ELSE 'False'
				END AS Undo
			,CASE 
				WHEN X.IsDirectPayment = 1
					THEN 'True'
				ELSE 'False'
				END AS IsDirectPayment
			,CASE 
				WHEN X.IsBTCComm = 1
					THEN 'True'
				ELSE 'False'
				END AS IsBTCComm
			,X.CompName
			,X.XO_Customer_Name
			--,X.XO_Arr, X.XO_Dep                                          
			,CASE 
				WHEN X.isChange = 1
					THEN 'True'
				ELSE 'False'
				END AS SupplierChange
			,x.SAPUpdatedcode AS SupplierChangeCode
			,v.Vendorname AS SupplierChangeName
			,X.XO_Arr
			,X.XO_Dep
			,AU.UserName AS 'FHEName'
			,Confirmed_By AS RefrenceNo
			,CASE 
				WHEN HM.HotelSAPCode IS NOT NULL
					THEN HM.STRegNo
				WHEN v.VendorSAPCode IS NOT NULL
					THEN v.STRegNo
				ELSE ''
				END AS VendorGST
			,CASE 
				WHEN HMA.acccode IS NOT NULL
					THEN SMH.State_code
				WHEN vMA.acccode IS NOT NULL
					THEN SMV.State_code
				ELSE ''
				END AS StateCode
			,CM.CityIaTACode AS FileLocation
		FROM XO X
		LEFT JOIN Quotation Q WITH (NOLOCK) ON X.Qut_id = Q.Quotationid
		LEFT JOIN Vendormaster v WITH (NOLOCK) ON x.SAPUpdatedcode = v.VendorSAPCode
		LEFT JOIN HotelMaster HM WITH (NOLOCK) ON X.SAPCode = HM.HotelSAPCode
		LEFT JOIN XO_Instructions XOI WITH (NOLOCK) ON X.XO_ID = XOI.XO_ID
		LEFT JOIN aspnet_Users AU WITH (NOLOCK) ON AU.UserId = X.InsertedBy
		LEFT JOIN vendormaster VMA WITH (NOLOCK) ON X.accode = VMA.acccode
		LEFT JOIN Hotelmaster HMA WITH (NOLOCK) ON X.accode = HMA.acccode
		LEFT JOIN State_Code_Master SMV WITH (NOLOCK) ON VMA.statecodeid = SMv.ID
		LEFT JOIN State_Code_Master SMH WITH (NOLOCK) ON HMA.statecodeid = SMH.ID
		LEFT JOIN companymaster CM WITH (NOLOCK) ON Q.companyid = CM.companyid
		WHERE (
				(CONVERT(CHAR(8), X.UndoDate, 112) >= CONVERT(CHAR(8), @dtFromdate, 112))
				AND (CONVERT(CHAR(8), X.UndoDate, 112) <= CONVERT(CHAR(8), @dtTodate, 112))
				)
		ORDER BY x.UndoDate
	END
	ELSE IF (@reportType = 'FPC')
	BEGIN
		SELECT Q.FileCode
			,AM.AgentName
			,Q.CustomerName AS Pax
			,convert(VARCHAR, Q.TravelDateFrom, 106) StartDate
			,convert(VARCHAR, Q.TravelDateTo, 106) EndDate
			,e.empname AS Employeename
			,U.UserName AS FHEName
			,Opsremarks
			,c.companyname
		FROM Quotation Q WITH (NOLOCK)
		LEFT JOIN AgentMaster AM WITH (NOLOCK) ON AM.AgentID = Q.AgentID
		INNER JOIN aspnet_Users U WITH (NOLOCK) ON Q.OperationBy = U.UserId
		LEFT JOIN Fileclosure F WITH (NOLOCK) ON Q.Quotationid = F.quotationid
			AND F.OpsFileClosed != 1
		LEFT JOIN companymaster c WITH (NOLOCK) ON c.companyid = Q.CompanyID
		LEFT JOIN employeemaster e WITH (NOLOCK) ON u.userid = e.userid
		WHERE (
				Q.parenquotationid = 0
				OR Q.parenquotationid IS NULL
				)
			AND Q.filecode != ''
			AND Q.Quotationid NOT IN (
				SELECT Quotationid
				FROM Fileclosure
				WHERE opsfileclosed = 1
				)
			AND (
				(CONVERT(CHAR(8), Q.TravelDateFrom, 112) >= CONVERT(CHAR(8), @dtFromdate, 112))
				AND (CONVERT(CHAR(8), Q.TravelDateFrom, 112) <= CONVERT(CHAR(8), @dtTodate, 112))
				)
		ORDER BY Q.FileCode
	END
	ELSE IF (@reportType = 'PI')
	BEGIN
		SELECT REPLACE(CONVERT(NVARCHAR, Q.traveldatefrom, 106), ' ', '-') AS TourDate
			,REPLACE(CONVERT(NVARCHAR, Q.TravelDateTo, 106), ' ', '-') AS TourEndDate
			,I.Invoice_ID
			,REPLACE(CONVERT(NVARCHAR, I.Invoice_date, 106), ' ', '-') AS Invoice_date
			,I.File_ID
			,I.Customer_Name
			,I.agent_id AS InvoicedAgentCode
			--,AM.agentname as QAgentNam                                                  
			,CASE 
				WHEN I.agent_id LIKE 'DR%'
					THEN A.Agentname
				WHEN I.agent_id LIKE 'CV%'
					THEN V.Vendorname
				ELSE H.Hotelname
				END AS InvoicedAgentName
			,CASE 
				WHEN I.agent_id LIKE 'DR%'
					THEN A.stregno
				WHEN I.agent_id LIKE 'CV%'
					THEN V.stregno
				ELSE H.stregno
				END AS InvAgentGST
			,CASE 
				WHEN I.agent_id LIKE 'DR%'
					THEN A.Panno
				WHEN I.agent_id LIKE 'CV%'
					THEN V.Panno
				ELSE H.Panno
				END AS InvAgentPAN
			,CASE 
				WHEN I.agent_id LIKE 'DR%'
					THEN SCA.state_code
				WHEN I.agent_id LIKE 'CV%'
					THEN SCV.state_code
				ELSE SCH.state_code
				END AS InvAgentStateCode
			,I.Curr_id
			--, I.invoice_exchg_rate as 'ROE', I.TotalBaseAmt as BasicAmt , Invoice_Curr_Amt TaxableAmt                                                  
			--,tax_per  as TaxRate                                                                 
			--,I.IGST,I.CGST,I.SGST,I.UTGST ,  t.TCSRate as TCSRate   , I.TCSValue                                                  
			,I.Invoice_Total AS TotalInvAmt
			,SAC AS SAC_Code
			,Reference
			,Refno AS 'Ref/PO Number'
			,E.empname AS Username --, Invoice_Type                                                  
			,c.CSTNo AS [Branch GSTIN]
			,'' AS 'Original invoice no'
			,'' AS 'Original invoice date'
			,c.companyname
			,B.BusinessModuleName AS BizVertical
			,CASE 
				WHEN I.agent_id LIKE 'DR%'
					THEN (
							CASE 
								WHEN (A.IsSez = '1')
									THEN 'True'
								ELSE 'False'
								END
							)
				WHEN I.agent_id LIKE 'CV%'
					THEN (
							CASE 
								WHEN (V.IsSez = '1')
									THEN 'True'
								ELSE 'False'
								END
							)
				ELSE (
						CASE 
							WHEN (H.IsSez = '1')
								THEN 'True'
							ELSE 'False'
							END
						)
				END AS Sez
			,(
				CASE 
					WHEN (
							CR.Code != 'INR'
							AND (
								SCA.id = 1
								OR SCH.id = 1
								OR SCV.id = 1
								)
							AND SL.servLoc_id = 2
							)
						THEN 'Yes'
					ELSE 'No'
					END
				) AS Export
			,CASE 
				WHEN I.IsBTCComm = 1
					THEN 'True'
				ELSE 'False'
				END AS BTCComm
			,CASE 
				WHEN I.IsDirectPayment = 1
					THEN 'True'
				ELSE 'False'
				END AS DPComm
			,REPLACE(REPLACE(REPLACE(REPLACE(Invoice_desc, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), ',', '-') AS InvDescription
		FROM Invoice_New I
		LEFT JOIN Invoice_Detail_new IDN WITH (NOLOCK) ON IDN.Invoice_id = I.Invoice_id
			AND IDN.yearcode = I.yearcode
			AND IDN.parent_id = I.ID
		LEFT JOIN agentmaster A WITH (NOLOCK) ON I.agent_id = A.AgentCode
		LEFT JOIN hotelmaster H WITH (NOLOCK) ON I.agent_id = H.HotelSAPCode
		LEFT JOIN vendormaster V WITH (NOLOCK) ON I.agent_id = V.VendorSAPCode
		LEFT JOIN State_Code_Master SCA WITH (NOLOCK) ON a.statecodeid = SCA.ID
		LEFT JOIN State_Code_Master SCH WITH (NOLOCK) ON H.statecodeid = SCH.ID
		LEFT JOIN State_Code_Master SCV WITH (NOLOCK) ON V.statecodeid = SCV.ID
		LEFT JOIN Quotation Q WITH (NOLOCK) ON I.qut_id = Q.Quotationid
		LEFT JOIN AgentMaster AM WITH (NOLOCK) ON Q.AgentID = AM.AgentID
		LEFT JOIN employeemaster E WITH (NOLOCK) ON I.createdby = E.userid
		LEFT JOIN companymaster c WITH (NOLOCK) ON C.companyid = I.compcode
		LEFT JOIN Businessmaster B WITH (NOLOCK) ON Q.BussinessModuleID = B.BussinessModuleID
		LEFT JOIN TCSRateMaster t WITH (NOLOCK) ON I.TCSRateID = t.ACCode
		LEFT JOIN currency CR WITH (NOLOCK) ON I.Curr_ID = CR.Code
		LEFT JOIN ServiceLocation_Master SL WITH (NOLOCK) ON Q.ServiceLocID = SL.servLoc_id
		WHERE (
				(CONVERT(CHAR(8), Q.traveldatefrom, 112) >= CONVERT(CHAR(8), @dtFromdate, 112))
				AND (CONVERT(CHAR(8), Q.traveldatefrom, 112) <= CONVERT(CHAR(8), @dtTodate, 112))
				)
			AND
			-- --and Q.traveldatefrom between @dtFromdate and @dtTodate                                                  
			I.Invoice_ID LIKE 'PF%'
			AND (
				I.isvoid IS NULL
				OR I.isvoid = 0
				)
			AND I.convertedinvno IS NULL
	END
	ELSE IF (@reportType = 'IID')
	BEGIN
		SELECT I.Invoice_ID
			,REPLACE(CONVERT(NVARCHAR, I.Invoice_date, 106), ' ', '-') AS Invoice_date
			,I.File_ID
			,I.agent_id AS InvoicedAgentCode
			,CASE 
				WHEN I.agent_id LIKE 'DR%'
					THEN A.Agentname
				WHEN I.agent_id LIKE 'CV%'
					THEN V.Vendorname
				ELSE H.Hotelname
				END AS InvoicedAgentName
			,CASE 
				WHEN I.agent_id LIKE 'DR%'
					THEN A.stregno
				WHEN I.agent_id LIKE 'CV%'
					THEN V.stregno
				ELSE H.stregno
				END AS InvAgentGST
			,CASE 
				WHEN I.agent_id LIKE 'DR%'
					THEN SCA.state_code
				WHEN I.agent_id LIKE 'CV%'
					THEN SCV.state_code
				ELSE SCH.state_code
				END AS InvAgentStateCode
			,I.Curr_id
			,I.invoice_exchg_rate AS 'ROE'
			,I.TotalBaseAmt AS BasicAmt
			,Invoice_Curr_Amt AS TaxableAmt
			,tax_per AS TaxRate
			,I.IGST
			,I.CGST
			,I.SGST
			,I.UTGST
			,t.TCSRate AS TCSRate
			,I.TCSValue
			,I.Invoice_Total AS TotalInvAmt
			,c.companyname
			,CASE 
				WHEN I.agent_id LIKE 'DR%'
					THEN (
							CASE 
								WHEN (A.IsSez = '1')
									THEN 'True'
								ELSE 'False'
								END
							)
				WHEN I.agent_id LIKE 'CV%'
					THEN (
							CASE 
								WHEN (V.IsSez = '1')
									THEN 'True'
								ELSE 'False'
								END
							)
				ELSE (
						CASE 
							WHEN (H.IsSez = '1')
								THEN 'True'
							ELSE 'False'
							END
						)
				END AS Sez
			,(
				CASE 
					WHEN (
							CR.Code != 'INR'
							AND (
								SCA.id = 1
								OR SCH.id = 1
								OR SCV.id = 1
								)
							AND SL.servLoc_id = 2
							)
						THEN 'Yes'
					ELSE 'No'
					END
				) AS Export
			,IRD.AckNumber
			,REPLACE(CONVERT(VARCHAR(50), CAST(IRD.AckDate AS DATETIME), 106), ' ', '-') AS ACKDate
			,IRD.IRN
			,REPLACE(REPLACE(REPLACE(REPLACE(IRD.Messages, CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), '"', '') AS [Error Message]
		FROM Invoice_New I
		LEFT JOIN Invoice_Detail_new IDN WITH (NOLOCK) ON IDN.Invoice_id = I.Invoice_id
			AND IDN.yearcode = I.yearcode
			AND IDN.parent_id = I.ID
		LEFT JOIN agentmaster A WITH (NOLOCK) ON I.agent_id = A.AgentCode
		LEFT JOIN hotelmaster H WITH (NOLOCK) ON I.agent_id = H.HotelSAPCode
		LEFT JOIN vendormaster V WITH (NOLOCK) ON I.agent_id = V.VendorSAPCode
		LEFT JOIN State_Code_Master SCA WITH (NOLOCK) ON a.statecodeid = SCA.ID
		LEFT JOIN State_Code_Master SCH WITH (NOLOCK) ON H.statecodeid = SCH.ID
		LEFT JOIN State_Code_Master SCV WITH (NOLOCK) ON V.statecodeid = SCV.ID
		LEFT JOIN Quotation Q WITH (NOLOCK) ON I.qut_id = Q.Quotationid
		LEFT JOIN companymaster c WITH (NOLOCK) ON C.companyid = I.compcode
		LEFT JOIN Businessmaster B WITH (NOLOCK) ON Q.BussinessModuleID = B.BussinessModuleID
		LEFT JOIN Invoice_New_IRN_SuperTaxJob_Details IRD WITH (NOLOCK) ON IRD.Invoiceid = I.Invoice_id
		--and IRD.invoicedate = CONVERT(CHAR(8),I.invoice_date,112)             
		LEFT JOIN TCSRateMaster t WITH (NOLOCK) ON I.TCSRateID = t.ACCode
		LEFT JOIN currency CR WITH (NOLOCK) ON I.Curr_ID = CR.Code
		LEFT JOIN ServiceLocation_Master SL WITH (NOLOCK) ON Q.ServiceLocID = SL.servLoc_id
		WHERE I.Invoice_date BETWEEN @dtFromdate
				AND @dtTodate
					--and I.YearCode = @YearCode   
			AND I.Invoice_ID LIKE '%IN%'
	END
	ELSE IF (@reportType = 'AD')
	BEGIN
		SELECT *
		FROM (
			SELECT DISTINCT TOP 100000 ROW_NUMBER() OVER (
					ORDER BY INV.Invoice_Date ASC
					) AS RowNum
				,INV.Invoice_ID
				,REPLACE(CONVERT(NVARCHAR, Invoice_Date, 106), ' ', '-') AS Invoice_Date
				,File_ID
				,Agent_ID
				,AM.AgentName AS InvoicedAgentName
				,CM.CompanyName
				,Curr_ID
				,ADN.Amount AS AddendumDetailsAmount
				,AD.Amount AS TotalAddendumAmount
				,REPLACE(REPLACE(REPLACE(REPLACE(ADN.[Description], CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), '"', '') AS AddendumDescription
			--,ADN.[Description] AS AddendumDescription       
			FROM Invoice_New INV
			INNER JOIN Addendum AD ON INV.Invoice_ID = AD.InvoiceID
				AND INV.YearCode = AD.YearCode
			LEFT JOIN CompanyMaster CM ON INV.compcode = CM.CompanyID
			LEFT JOIN AgentMaster AM ON INV.Agent_ID = AM.AgentCode
			INNER JOIN Addendum_Details ADN ON INV.Invoice_ID = ADN.InvoiceID
				AND INV.YearCode = ADN.YearCode
			WHERE DATEADD(dd, 0, DATEDIFF(dd, 0, INV.Invoice_Date)) >= @dtFromdate
				AND INV.YearCode = @YearCode
				AND DATEADD(dd, 0, DATEDIFF(dd, 0, INV.Invoice_Date)) <= @dtTodate
				AND INV.Invoice_ID NOT LIKE 'pf%'
				AND INV.IsBTCComm IS NULL
				OR INV.IsBTCComm = 0
				AND INV.ISDIRECTPAYMENT != 1
			) AS A
	END
	ELSE IF (@reportType = 'ED')
	BEGIN

	print 'ED'
		SELECT ED.EnquiryNo
			,REPLACE(CONVERT(NVARCHAR, ED.OperationOn, 106), ' ', '-') AS EnquiryDate
			,ED.AgentID
			,AM.AgentName
			,M.Name AS 'Agent Market'
			,C.NAME AS 'Agent Address Country'
			,S.Name AS 'Agent Address State'
			,CT.Name AS 'Agent Address City'
			,REPLACE(CONVERT(NVARCHAR, ED.TravelDate, 106), ' ', '-') AS TravelDate
			,ED.Value
			,ED.Description
			,ED.YearID
			,CM.CompanyName
			,REPLACE(CONVERT(NVARCHAR, ED.OperationOn, 106), ' ', '-') AS OperationOn
			,ED.AgentName
			,ED.STATUS
			,ED.AgentStaffName
			,ED.Remark
			,ED.BigBilling
			,ED.RelatedSaleEmployeeID
			,EMFHE.EmpName AS 'FHE EMPName'
			,EM.EmpName AS 'Related Sales Employee'
		FROM EnquiryDetails ED
		LEFT JOIN AgentMaster AM ON ED.AgentID = AM.AgentID
		LEFT JOIN Country C ON AM.AddressCountry = C.IATACode
		LEFT JOIN STATE S ON AM.AddressState = S.State_ID
		LEFT JOIN CITY CT ON AM.AddressCity = CT.IATACode
		LEFT JOIN MARKET M ON AM.MarketID = M.ID
		LEFT JOIN CompanyMaster CM ON ED.CompanyID = CM.CompanyID
		LEFT JOIN EmployeeMaster EM ON ED.RelatedSaleEmployeeID = EM.EmpID
		LEFT JOIN EmployeeMaster EMFHE ON ED.FHE = EMFHE.UserID
		WHERE DATEADD(dd, 0, DATEDIFF(dd, 0, ED.OperationOn)) >= @dtFromdate
			AND DATEADD(dd, 0, DATEDIFF(dd, 0, ED.OperationOn)) <= @dtTodate
		ORDER BY ED.OperationOn ASC
	END
	   ELSE IF(@reportType = 'CND')                 
  BEGIN           
 select       
 SALES_ID,CompCode,FiscalYear,Status,SAPDocID,SAPPostingDate,DocType,VendorID,RefNo,FileCode      
 ,DocDate,DocCurr,TotalDocAmt,ROE,NonTaxableSaleLC,TaxableSaleLC,TotalSaleLC,IsReversed,CreatedDate,UpdatedDateTime      
 from SAP_ASTRA_SALES where DocType = 'DG'       
 and DATEADD(dd, 0, DATEDIFF(dd, 0, Cast(convert(varchar, convert(date, SAPPostingDate, 105), 101) as date))) >= @dtFromdate     
 AND DATEADD(dd, 0, DATEDIFF(dd, 0, Cast(convert(varchar, convert(date, SAPPostingDate, 105), 101) as date) )) <= @dtTodate             
    ORDER BY SALES_ID ASC      
  END    
    
  ELSE IF(@reportType = 'FD')    
  BEGIN  
 SELECT Q.QuotationID AS 'Primary QID', QuotationNo AS 'Quote No', EM.EmpName AS 'FHE', Q.FileCode, M.Name AS 'Market',  
 Q.PaxTo AS 'Pax', convert(VARCHAR,Q.TravelDateFrom,106) AS 'StartDate' , convert(VARCHAR,Q.TravelDateTo,106) AS 'EndDate',  
 BM.BusinessModuleName AS 'Biz Vertical', Q.Guests_Nationality AS 'Guest Nationality',  
 CASE WHEN Q.BookingType = 1 THEN 'Hotel / Transport' WHEN Q.BookingType = 2 THEN 'Itinerary' ELSE '' END AS 'Booking Type',  
 QST.Description AS 'Service Type', SL.Description AS 'Service Location', --PM.PackageName + ' ' + PM.PackageCode AS 'Package Code',  
 CASE WHEN Q.RateCategory = 1 THEN 'FIT' WHEN Q.RateCategory = 2 THEN 'GIT' ELSE '' END AS 'FIT / GIT',  
 CASE WHEN Q.Origin = 1 THEN 'Offline' ELSE 'Online' END AS 'Origin', C.Name AS 'Agent City' ,AM.AgentName AS 'Agent Name',  
 CM.CompanyName AS 'Company Name',  
 EM1.EmpName AS 'Tam Sales Rep'  
 FROM Quotation Q  
 LEFT JOIN EmployeeMaster EM ON Q.OperationBy = EM.UserID  
 LEFT JOIN EmployeeMaster EM1 ON Q.RelatedEmployeeID = EM1.EmpID  
 LEFT JOIN Market M ON Q.Market = M.ID  
 LEFT JOIN BusinessMaster BM ON Q.BussinessModuleID = BM.BussinessModuleID  
 LEFT JOIN QuotationServiceType_Master QST ON Q.ServiceTypeID = QST.QutServ_ID  
 LEFT JOIN ServiceLocation_Master SL ON Q.ServiceLocID = SL.ServLoc_ID  
 --LEFT JOIN PackageCodeMaster PM ON Q.PackageID = PM.PackageID  
 LEFT JOIN AgentMaster AM ON Q.AgentID = AM.AgentID  
 LEFT JOIN CITY C ON AM.AddressCity = C.IATACode  
 LEFT JOIN CompanyMaster CM ON Q.CompanyID = CM.CompanyID  
  
 WHERE Q.ParenQuotationID = 0 AND Q.FileCode IS NOT NULL  
 AND Q.TravelDateFrom >= @dtFromdate   
 and Q.TravelDateTo <= @dtTodate  
 ORDER BY Q.TravelDateFrom ASC  
  
  END    
END

