CREATE PROCEDURE [dbo].[QuotationSearch_DetailsTest]
    @QuotationID NVARCHAR(50) = NULL,
  -- @EQID BIGINT = NULL,
    @AgentName NVARCHAR(100) = NULL,
    @CustomerID  BIGINT = NULL,
    @QuoteStatus INT = NULL,
    @Action CHAR(2) = ''
AS
BEGIN
    SET NOCOUNT ON;
 
    -- Handle empty string parameters by converting them to NULL
    SET @QuotationID = NULLIF(@QuotationID, '');
    --SET @EQID = NULLIF(@EQID, '');
    SET @AgentName = NULLIF(@AgentName, '');
    --SET @CustomerID = NULLIF(@CustomerID, '');
	--IF ISNUMERIC(@CustomerID) = 0 SET @CustomerID = NULL;
    SET @QuoteStatus = CASE WHEN @QuoteStatus = '' THEN NULL ELSE @QuoteStatus END;
 
        SELECT 
            Q.QuotationID AS ID,
            CASE 
                WHEN Q.Status = 1 THEN CONCAT('D-', Q.QuotationNo)
				  WHEN Q.Status = 0 THEN ''
                ELSE Q.QuotationNo
            END AS QuotationNo,
            E.EnquiryID,
            E.EQID,
            CASE 
                WHEN Q.TaxType = 1 THEN 'Including Tax'
				WHEN Q.TaxType = 2 THEN 'Excluding Tax'
                ELSE ''
            END AS TaxTypeName,
            Q.TaxonSale,
            CM.Code AS CurrencyCode,
            AM.AgentName,
			E.Agent_Staff_Name as AgentStaffName,
            Q.Status,
            QS.StatusName,
            C.CompanyName,
            C.CompCode AS CompanyCode
        FROM [Quotation].[QuotationMaster] Q
        INNER JOIN [Quotation].[QuotationStatus] QS ON Q.Status = QS.StatusCode
        LEFT JOIN [dbo].[tbl_Enquiry] E ON Q.EnquiryID = E.EQID
        LEFT JOIN Currency CM ON Q.Currency = CM.CurrencyID
        LEFT JOIN AgentMaster AM ON E.AgentId = AM.AgentID
        LEFT JOIN CompanyMaster C ON Q.CompanyID = C.CompanyID
        WHERE Q.QuotationID = @QuotationID AND
		  (@AgentName IS NULL OR AM.AgentName LIKE '%' + @AgentName + '%')
		    --(@EQID IS NULL OR E.EQID = @EQID)
			
		
      

    END