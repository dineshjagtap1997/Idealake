CREATE PROCEDURE [dbo].[usp_GetPlaceOfSupplyLogic_Audit] (@POSLogID BIGINT)
AS
BEGIN
	SELECT CASE 
			WHEN TypeID = 1
				THEN 'B2B'
			WHEN TypeID = 2
				THEN 'B2CWA'
			WHEN TypeID = 3
				THEN 'B2CWOA'
			END AS Type
		,s.Description ServiceType
		,CONVERT(VARCHAR, DATEADD(DAY, 0, validFrom), 103) AS validFromDate
		,CONVERT(VARCHAR, DATEADD(DAY, 0, validTo), 103) AS validToDate
		,CASE 
			WHEN BuyerLocationID = 1
				THEN 'India'
			WHEN BuyerLocationID = 2
				THEN 'Non India'
			END AS BuyerLoc
		,su.Description AS ServiceUtilsation
		,IsGST
		,IsAddress
		,IsCommercial
		,CASE 
			WHEN POSStateCode = 1
				THEN 'Agent Master'
			WHEN POSStateCode = 2
				THEN 'Tamarind Logged in Branch'
			WHEN POSStateCode = 3
				THEN 'Open to user Selection'
			END AS POsStaeCode
		,p.IsActive
		,p.Operation
		,OperationBy
		,CONVERT(VARCHAR, DATEADD(DAY, 0, OperationDate), 103) AS OperationDate
	FROM PlaceOfSupplyLogic_Audit p
	INNER JOIN QuotationServiceType_Master s ON p.ServiceID = s.QutServ_ID
	INNER JOIN ServiceLocation_Master su ON p.ServiceLocID = su.ServLoc_ID
	WHERE p.POSLogID = @POSLogID
END