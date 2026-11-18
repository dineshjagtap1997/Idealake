
CREATE PROCEDURE [Booking].[usp_BookingDetails_v1]
    @BookingID BIGINT = null,
    @QuotationID BIGINT = NULL,
    @EnquryID INT = NULL,
    @FileCode VARCHAR(100) = NULL,
    @AgentName VARCHAR(100) = NULL,
    @customerName VARCHAR(100) = NULL,
    @GuestName VARCHAR(100) = NULL,
    @XONumber VARCHAR(100) = '',
    @InvoiceNumber VARCHAR(100) = NULL,
    @Action CHAR(2) = 'SA',
    @PageNumber INT = 0,
    @Row_Count INT = 10, -- ✅ Changed from VARCHAR(MAX) to INT
    @FromDate DATETIME = NULL,
    @ToDate DATETIME = NULL,
    @QuotationNo VARCHAR(100) = NULL,
    @BookingNo VARCHAR(100) = NULL,
    @AgentID INT = NULL,
    @Status INT = 2,
    @CustomerID INT = NULL,
    @FHE UNIQUEIDENTIFIER = NULL,
    @isArrivalDate BIT = 0
AS
BEGIN
    DECLARE @TotalRecordCount INT = 0
    DECLARE @SQL NVARCHAR(MAX)

	IF @Action = 'SA'
    BEGIN
        -- Count total records for pagination
        SELECT @TotalRecordCount = (select count(*) from (SELECT DISTINCT
            B.id AS BookingID,
            Q.QuotationID,
            Q.QuotationNo,
			Q.QuotationID as Quotation_ID,
            Q.QuotationNo as Quotation_No,
            B.FileCode,
            B.GuestName,
            B.FHE,
            Q.CreatedDate AS QuotationDate,
            CASE 
                WHEN B.Status = 2 THEN CONCAT('D-', B.BookingID)
                WHEN B.Status = 3 THEN CAST(B.BookingID AS VARCHAR)
                ELSE CAST(B.BookingID AS VARCHAR)
            END AS BookingNo,
            BS.StatusName,
            B.Status,
            E.EnquiryID,
            E.EQID,
            CASE 
                WHEN Q.TaxType = 1 THEN 'Including Tax'
                ELSE 'Excluding Tax'
            END AS TaxTypeName,
            AM.AgentName AS AgentStaffName,
            G.GSTPercentage,
            Q.TaxonSale,
            Q.Currency AS CurrencyID,
            CM.CurrencyCode,
            AM.AgentName,
            Q.CreatedDate,
            B.StartDate,
            B.EndDate,
            EM.EmpName AS FHEName,
            CASE
                WHEN Q.RateCardMode = '1' THEN 'Contract'
                WHEN Q.RateCardMode = '2' THEN 'Adhoc'
                WHEN Q.RateCardMode = '3' THEN 'Custom'
                WHEN Q.RateCardMode = '4' THEN 'Negotiated'
                WHEN Q.RateCardMode = '5' THEN 'IncludingExcludingTax'
            END AS RateCardMode,
            @TotalRecordCount AS TotalCount,
            C.Fullname AS CustomerName
           
        FROM [Booking].[tbl_Booking] B
        LEFT JOIN [Booking].[BookingStatus] BS ON B.Status = BS.StatusCode
        LEFT JOIN [Quotation].[QuotationMaster] Q ON B.QuotationID = Q.QuotationID
        LEFT JOIN [dbo].[tbl_Enquiry] E ON B.EnquiryID = E.EQID
        LEFT JOIN AgentMaster AM ON B.AgentId = AM.AgentID
        LEFT JOIN CurrencyMaster CM ON Q.Currency = CM.ID
        LEFT JOIN Customer C ON E.ClientID = C.CID
        LEFT JOIN GST_Percentage G ON G.GSTID = Q.TaxonSale
        LEFT JOIN Invoice.Invoice I ON B.Id = I.BookingID
        LEFT JOIN EmployeeMaster EM ON EM.UserID = B.FHE
        WHERE 
            (@FromDate IS NULL OR
                (@isArrivalDate = 1 AND B.StartDate >= @FromDate AND B.StartDate < DATEADD(DAY, 1, @ToDate)) OR
                (@isArrivalDate = 0 AND B.CreatedOn >= @FromDate AND B.CreatedOn < DATEADD(DAY, 1, @ToDate)))
            AND (@QuotationID IS NULL OR @QuotationID = 0 OR Q.QuotationID = @QuotationID)
            AND (@BookingNo IS NULL OR @BookingNo = '' OR CAST(B.BookingID AS NVARCHAR) LIKE '%' + @BookingNo + '%')
            AND (@EnquryID IS NULL OR @EnquryID = 0 OR B.EnquiryID = @EnquryID)
            AND (ISNULL(@AgentID, 0) = 0 OR B.AgentID = @AgentID)
            AND (@Status IS NULL OR B.Status = @Status OR @Status = 0)
            AND (@CustomerID IS NULL OR @CustomerID = 0 OR C.CID = @CustomerID)
            AND (@BookingID IS NULL OR @BookingID = 0 OR B.Id = @BookingID)
            AND (@FileCode IS NULL OR @FileCode = '' OR B.FileCode = @FileCode)
            AND (@customerName IS NULL OR @customerName = '' OR C.Fullname = @customerName)
            AND (@GuestName IS NULL OR @GuestName = '' OR B.GuestName = @GuestName)
            AND (ISNULL(@XONumber, '') = '' OR B.XONumber = @XONumber)
            AND (@FHE IS NULL OR B.FHE = @FHE)
            AND (ISNULL(@InvoiceNumber, '') = '' OR I.InvoiceNumber = @InvoiceNumber)
        )as a)
        -- Main paged result set
        SELECT DISTINCT
            B.id AS BookingID,
            Q.QuotationID,
            Q.QuotationNo,
			Q.QuotationID as Quotation_ID,
            Q.QuotationNo as Quotation_No,
            B.FileCode,
            B.GuestName,
            B.FHE,
            Q.CreatedDate AS QuotationDate,
            CASE 
                WHEN B.Status = 2 THEN CONCAT('D-', B.BookingID)
                WHEN B.Status = 3 THEN CAST(B.BookingID AS VARCHAR)
                ELSE CAST(B.BookingID AS VARCHAR)
            END AS BookingNo,
            BS.StatusName,
            B.Status,
            E.EnquiryID,
            E.EQID,
            CASE 
                WHEN Q.TaxType = 1 THEN 'Including Tax'
                ELSE 'Excluding Tax'
            END AS TaxTypeName,
            AM.AgentName AS AgentStaffName,
            G.GSTPercentage,
            Q.TaxonSale,
            Q.Currency AS CurrencyID,
            CM.CurrencyCode,
            AM.AgentName,
            Q.CreatedDate,
            B.StartDate,
            B.EndDate,
            EM.EmpName AS FHEName,
            CASE
                WHEN Q.RateCardMode = '1' THEN 'Contract'
                WHEN Q.RateCardMode = '2' THEN 'Adhoc'
                WHEN Q.RateCardMode = '3' THEN 'Custom'
                WHEN Q.RateCardMode = '4' THEN 'Negotiated'
                WHEN Q.RateCardMode = '5' THEN 'IncludingExcludingTax'
            END AS RateCardMode,
            @TotalRecordCount AS TotalCount,
            C.Fullname AS CustomerName,
            (
                SELECT BversionSeq.ParentID, BversionSeq.QuotationID AS ChildID, BversionSeq.BookingID,
                       BversionSeq.BookingSequence, BversionSeq.Status, BS2.StatusName
                FROM Booking.tbl_Booking BversionSeq
                LEFT JOIN Booking.BookingStatus BS2 ON BversionSeq.STATUS = BS2.StatusCode
                WHERE BversionSeq.ParentID = B.ID
                      AND BversionSeq.BookingSequence IS NOT NULL
                FOR JSON PATH
            ) AS VersionSequence
        FROM [Booking].[tbl_Booking] B
        LEFT JOIN [Booking].[BookingStatus] BS ON B.Status = BS.StatusCode
        LEFT JOIN [Quotation].[QuotationMaster] Q ON B.QuotationID = Q.QuotationID
        LEFT JOIN [dbo].[tbl_Enquiry] E ON B.EnquiryID = E.EQID
        LEFT JOIN AgentMaster AM ON B.AgentId = AM.AgentID
        LEFT JOIN CurrencyMaster CM ON Q.Currency = CM.ID
        LEFT JOIN Customer C ON E.ClientID = C.CID
        LEFT JOIN GST_Percentage G ON G.GSTID = Q.TaxonSale
        LEFT JOIN Invoice.Invoice I ON B.Id = I.BookingID
        LEFT JOIN EmployeeMaster EM ON EM.UserID = B.FHE
        WHERE 
            (@FromDate IS NULL OR
                (@isArrivalDate = 1 AND B.StartDate >= @FromDate AND B.StartDate < DATEADD(DAY, 1, @ToDate)) OR
                (@isArrivalDate = 0 AND B.CreatedOn >= @FromDate AND B.CreatedOn < DATEADD(DAY, 1, @ToDate)))
            AND (@QuotationID IS NULL OR @QuotationID = 0 OR Q.QuotationID = @QuotationID)
            AND (@BookingNo IS NULL OR @BookingNo = '' OR CAST(B.BookingID AS NVARCHAR) LIKE '%' + @BookingNo + '%')
            AND (@EnquryID IS NULL OR @EnquryID = 0 OR B.EnquiryID = @EnquryID)
            AND (ISNULL(@AgentID, 0) = 0 OR B.AgentID = @AgentID)
            AND (@Status IS NULL OR B.Status = @Status OR @Status = 0)
            AND (@CustomerID IS NULL OR @CustomerID = 0 OR C.CID = @CustomerID)
            AND (@BookingID IS NULL OR @BookingID = 0 OR B.Id = @BookingID)
            AND (@FileCode IS NULL OR @FileCode = '' OR B.FileCode = @FileCode)
            AND (@customerName IS NULL OR @customerName = '' OR C.Fullname = @customerName)
            AND (@GuestName IS NULL OR @GuestName = '' OR B.GuestName = @GuestName)
            AND (ISNULL(@XONumber, '') = '' OR B.XONumber = @XONumber)
            AND (@FHE IS NULL OR B.FHE = @FHE)
            AND (ISNULL(@InvoiceNumber, '') = '' OR I.InvoiceNumber = @InvoiceNumber)
        ORDER BY B.Id DESC
        OFFSET @PageNumber * @Row_Count ROWS
        FETCH NEXT @Row_Count ROWS ONLY;

        SELECT CAST(@TotalRecordCount AS VARCHAR(20)) AS Row_Count, '200' AS returnCode, 'Data Found' AS returnMessage;
    END
    -- Leave @Action = 'S' logic as is, or let me know if you'd like to convert that too

  
    --IF @Action = 'SA'
    --BEGIN
    --    SELECT @TotalRecordCount = COUNT(*)
    --    FROM [Booking].[tbl_Booking] B
    --        LEFT JOIN [Booking].[BookingStatus] BS ON B.Status = BS.StatusCode
    --        LEFT JOIN [Quotation].[QuotationMaster] Q ON Q.QuotationID = B.QuotationID
    --        LEFT JOIN [dbo].[tbl_Enquiry] E ON B.EnquiryID = E.EQID
    --        LEFT JOIN AgentMaster AM ON B.AgentId = AM.AgentID
    --        LEFT JOIN CurrencyMaster CM ON B.Currency = CM.ID
    --        LEFT JOIN Customer C ON E.ClientID = C.CID
    --        LEFT JOIN GST_Percentage G ON G.GSTID = Q.TaxonSale
    --        LEFT JOIN Invoice.Invoice I ON B.Id = I.BookingID
    --    WHERE 
    --        (
    --            @FromDate IS NULL OR
    --            (
    --                (@isArrivalDate = 1 AND B.StartDate >= @FromDate AND B.StartDate < DATEADD(DAY, 1, @ToDate)) OR
    --                (@isArrivalDate = 0 AND B.CreatedOn >= @FromDate AND B.CreatedOn < DATEADD(DAY, 1, @ToDate))
    --            )
    --        )
    --        AND (@QuotationID IS NULL OR @QuotationID = 0 OR Q.QuotationID = @QuotationID)
    --        AND (@BookingNo IS NULL OR @BookingNo = '' OR CAST(B.BookingID AS NVARCHAR) LIKE '%' + @BookingNo + '%')
    --        AND (@EnquryID IS NULL OR @EnquryID = 0 OR B.EnquiryID = @EnquryID)
    --        AND (ISNULL(@AgentID, 0) = 0 OR B.AgentID = @AgentID)
    --        AND (@Status IS NULL OR B.Status = @Status OR @Status = 0)
    --        AND (@CustomerID IS NULL OR @CustomerID = 0 OR C.CID = @CustomerID)
    --        AND (@BookingID IS NULL OR @BookingID = 0 OR B.Id = @BookingID)
    --        AND (@FileCode IS NULL OR @FileCode = '' OR B.FileCode = @FileCode)
    --        AND (@customerName IS NULL OR @customerName = '' OR C.Fullname = @customerName)
    --        AND (@GuestName IS NULL OR @GuestName = '' OR B.GuestName = @GuestName)
    --        AND ((ISNULL(@XONumber, '') = '') OR (B.XONumber = @XONumber))
    --        AND (@FHE IS NULL OR B.FHE = @FHE)
    --        AND (ISNULL(@InvoiceNumber, '') = '' OR I.InvoiceNumber = @InvoiceNumber)

    --    SET @SQL = N'
    --    SELECT DISTINCT

    --        B.id AS BookingID,
    --        Q.QuotationID,
    --        Q.QuotationNo,
    --        B.FileCode,
    --        B.GuestName,
    --        B.FHE,
    --        Q.CreatedDate AS QuotationDate,
    --        CASE 
    --            WHEN B.Status = 2 THEN CONCAT(''D-'', B.BookingID)
    --            WHEN B.Status = 3 THEN CAST(B.BookingID AS VARCHAR)
    --            ELSE CAST(B.BookingID AS VARCHAR)
    --        END AS BookingNo,
    --        BS.StatusName,
    --        B.Status,
    --        E.EnquiryID,
    --        E.EQID,
    --        CASE 
    --            WHEN Q.TaxType = 1 THEN ''Including Tax''
    --            ELSE ''Excluding Tax''
    --        END AS TaxTypeName,
    --        AM.AgentName AS AgentStaffName,
    --        G.GSTPercentage,
    --        Q.TaxonSale,
    --        Q.Currency AS CurrencyID,
    --        CM.CurrencyCode,
    --        AM.AgentName,
    --        Q.CreatedDate,
    --        B.StartDate,
    --        B.EndDate,
    --        EM.EmpName AS FHEName,
    --        CASE
    --            WHEN Q.RateCardMode = ''1'' THEN ''Contract''
    --            WHEN Q.RateCardMode = ''2'' THEN ''Adhoc''
    --            WHEN Q.RateCardMode = ''3'' THEN ''Custom''
    --            WHEN Q.RateCardMode = ''4'' THEN ''Negotiated''
    --            WHEN Q.RateCardMode = ''5'' THEN ''IncludingExcludingTax''
    --        END AS RateCardMode,
    --        ' + CAST(@TotalRecordCount AS NVARCHAR(20)) + ' AS TotalCount,
    --        C.Fullname AS CustomerName,
    --        (
    --            SELECT *
    --            FROM (
    --                SELECT   
    --                    BversionSeq.ParentID AS ParentID,
    --                    BversionSeq.QuotationID AS ChildID,
    --                    BversionSeq.BookingID,
    --                    BversionSeq.BookingSequence,
    --                    BversionSeq.Status,
    --                    BS.StatusName
    --                FROM Booking.tbl_Booking BversionSeq
    --                    LEFT JOIN Booking.BookingStatus BS ON BversionSeq.STATUS = BS.StatusCode
    --                WHERE BversionSeq.ParentID = B.ID
    --                    AND BversionSeq.BookingSequence IS NOT NULL
    --            ) AS BVs
    --            FOR JSON PATH
    --        ) AS VersionSequence
    --    FROM [Booking].[tbl_Booking] B
    --        LEFT JOIN [Booking].[BookingStatus] BS ON B.Status = BS.StatusCode
    --        LEFT JOIN [Quotation].[QuotationMaster] Q ON B.QuotationID = Q.QuotationID
    --        LEFT JOIN [dbo].[tbl_Enquiry] E ON B.EnquiryID = E.EQID
    --        LEFT JOIN AgentMaster AM ON B.AgentId = AM.AgentID
    --        LEFT JOIN CurrencyMaster CM ON Q.Currency = CM.ID
    --        LEFT JOIN Customer C ON E.ClientID = C.CID
    --        LEFT JOIN GST_Percentage G ON G.GSTID = Q.TaxonSale
    --        LEFT JOIN Invoice.Invoice I ON B.Id = I.BookingID
    --        LEFT JOIN EmployeeMaster EM ON EM.UserID = B.FHE
    --    WHERE 
    --        (
    --            @FromDate IS NULL OR
    --            (
    --                (@isArrivalDate = 1 AND B.StartDate >= @FromDate AND B.StartDate < DATEADD(DAY, 1, @ToDate)) OR
    --                (@isArrivalDate = 0 AND B.CreatedOn >= @FromDate AND B.CreatedOn < DATEADD(DAY, 1, @ToDate))
    --            )
    --        )
    --        AND (@QuotationID IS NULL OR @QuotationID = 0 OR Q.QuotationID = @QuotationID)
    --        AND (@BookingNo IS NULL OR @BookingNo = '''' OR CAST(B.BookingID AS NVARCHAR) LIKE ''%'' + @BookingNo + ''%'')
    --        AND (@EnquryID IS NULL OR @EnquryID = 0 OR B.EnquiryID = @EnquryID)
    --        AND (ISNULL(@AgentID, 0) = 0 OR B.AgentID = @AgentID)
    --        AND (@Status IS NULL OR B.Status = @Status OR @Status = 0)
    --        AND (@CustomerID IS NULL OR @CustomerID = 0 OR C.CID = @CustomerID)
    --        AND (@BookingID IS NULL OR @BookingID = 0 OR B.Id = @BookingID)
    --        AND (@FileCode IS NULL OR @FileCode = '''' OR B.FileCode = @FileCode)
    --        AND (@customerName IS NULL OR @customerName = '''' OR C.Fullname = @customerName)
    --        AND (@GuestName IS NULL OR @GuestName = '''' OR B.GuestName = @GuestName)
    --        AND (@XONumber IS NULL OR @XONumber = '''' OR B.XONumber = @XONumber)
    --        AND (@FHE IS NULL OR B.FHE = @FHE)
    --        AND (ISNULL(@InvoiceNumber, '''') = '''' OR I.InvoiceNumber = @InvoiceNumber)
    --    ORDER BY B.Id DESC
    --    OFFSET ' + CAST(@PageNumber * @Row_Count AS NVARCHAR) + ' ROWS
    --    FETCH NEXT ' + CAST(@Row_Count AS NVARCHAR) + ' ROWS ONLY'

    --    EXEC sp_executesql @SQL,
    --        N'@FromDate DATETIME, @ToDate DATETIME, @QuotationID INT, @BookingNo VARCHAR(100),
    --          @EnquryID INT, @AgentID INT, @Status INT, @CustomerID INT, @BookingID BIGINT,
    --          @FileCode VARCHAR(100), @AgentName VARCHAR(100), @customerName VARCHAR(100),
    --          @GuestName VARCHAR(100), @XONumber VARCHAR(100), @FHE UNIQUEIDENTIFIER,
    --          @isArrivalDate BIT, @InvoiceNumber VARCHAR(100)',
    --        @FromDate = @FromDate,
    --        @ToDate = @ToDate,
    --        @QuotationID = @QuotationID,
    --        @BookingNo = @BookingNo,
    --        @EnquryID = @EnquryID,
    --        @AgentID = @AgentID,
    --        @Status = @Status,
    --        @CustomerID = @CustomerID,
    --        @BookingID = @BookingID,
    --        @FileCode = @FileCode,
    --        @AgentName = @AgentName,
    --        @customerName = @customerName,
    --        @GuestName = @GuestName,
    --        @XONumber = @XONumber,
    --        @FHE = @FHE,
    --        @isArrivalDate = @isArrivalDate,
    --        @InvoiceNumber = @InvoiceNumber

    --    SELECT CAST(@TotalRecordCount AS VARCHAR(20)) AS Row_Count,'200' AS returnCode, 'Data Found' AS returnMessage
    --END
    ELSE IF @Action = 'S'
    BEGIN
        -- Unchanged logic for 'S'
        SELECT @TotalRecordCount = COUNT(*)
        FROM [Booking].[tbl_Booking] B
            LEFT JOIN [Booking].[BookingStatus] BS ON B.Status = BS.StatusCode
            LEFT JOIN [Quotation].[QuotationMaster] Q ON B.QuotationID = Q.QuotationID
            LEFT JOIN [dbo].[tbl_Enquiry] E ON B.EnquiryID = E.EQID
            LEFT JOIN CurrencyMaster CM ON Q.Currency = CM.ID
            LEFT JOIN AgentMaster AM ON B.AgentId = AM.AgentID
            LEFT JOIN CompanyMaster C ON Q.CompanyID = C.CompanyID
            LEFT JOIN GST_Percentage G ON G.GSTID = Q.TaxonSale

        IF @Row_Count IS NULL OR @Row_Count = -1
        BEGIN
            SET @Row_Count = @TotalRecordCount
        END

        SET @SQL = N'
        SELECT DISTINCT
            B.id AS BookingID,
            Q.QuotationID,
            Q.QuotationNo,
            B.FileCode,
            B.GuestName,
            EM.EmpName AS FHEName,
            Q.CreatedDate AS QuotationDate,
            CASE 
                WHEN B.Status = 2 THEN CONCAT(''D-'', B.BookingID)
                WHEN B.Status = 3 THEN CAST(B.BookingID AS VARCHAR)
                ELSE CAST(B.BookingID AS VARCHAR)
            END AS BookingNo,
            BS.StatusName,
            B.Status,
            E.EnquiryID,
            E.EQID,
            CASE 
                WHEN Q.TaxType = 1 THEN ''Including Tax''
                ELSE ''Excluding Tax''
            END AS TaxTypeName,
            AM.AgentName AS AgentStaffName,
            G.GSTPercentage,
            Q.TaxonSale,
            Q.Currency AS CurrencyID,
            CM.CurrencyCode,
            AM.AgentName,
            Q.CreatedDate,
            B.StartDate,
            B.EndDate,
            CASE
                WHEN Q.RateCardMode = ''1'' THEN ''Contract''
                WHEN Q.RateCardMode = ''2'' THEN ''Adhoc''
                WHEN Q.RateCardMode = ''3'' THEN ''Custom''
                WHEN Q.RateCardMode = ''4'' THEN ''Negotiated''
                WHEN Q.RateCardMode = ''5'' THEN ''IncludingExcludingTax''
            END AS RateCardMode,
            ' + CAST(@TotalRecordCount AS NVARCHAR(20)) + ' AS TotalCount
        FROM [Booking].[tbl_Booking] B
            LEFT JOIN [Booking].[BookingStatus] BS ON B.Status = BS.StatusCode
            LEFT JOIN [Quotation].[QuotationMaster] Q ON B.QuotationID = Q.QuotationID
            LEFT JOIN [dbo].[tbl_Enquiry] E ON B.EnquiryID = E.EQID
            LEFT JOIN AgentMaster AM ON B.AgentId = AM.AgentID
            LEFT JOIN CurrencyMaster CM ON Q.Currency = CM.ID
            LEFT JOIN Customer C ON E.ClientID = C.CID
            LEFT JOIN GST_Percentage G ON G.GSTID = Q.TaxonSale
            LEFT JOIN EmployeeMaster EM ON EM.UserID = B.FHE
        WHERE (ISNULL(@BookingID, 0) = 0 OR B.Id = @BookingID)
        ORDER BY B.ID DESC
        OFFSET ' + CAST(@PageNumber * @Row_Count AS NVARCHAR) + ' ROWS
        FETCH NEXT ' + CAST(@Row_Count AS NVARCHAR) + ' ROWS ONLY'

        EXEC sp_executesql @SQL,
            N'@BookingID BIGINT, @PageNumber INT, @Row_Count INT',
            @BookingID = @BookingID,
            @PageNumber = @PageNumber,
            @Row_Count = @Row_Count

        SELECT CAST(@TotalRecordCount AS VARCHAR(20)) AS Row_Count,'200' AS returnCode, 'Data Found' AS returnMessage 
    END
END
