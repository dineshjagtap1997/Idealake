CREATE PROCEDURE [Booking].[usp_BookingDetails]
   -- DECLARE
@BookingID        BIGINT           = NULL,
@QuotationID      BIGINT           = NULL,
@EnquryID         INT              = NULL, -- Not in JSON
@FileCode         VARCHAR(100)     = NULL,
@AgentName        VARCHAR(100)     = NULL,
@customerName     VARCHAR(100)     = NULL,
@GuestName        VARCHAR(100)     = NULL,
@XONumber         VARCHAR(100)     = NULL,
@InvoiceNumber    VARCHAR(100)     = NULL,
@Action           CHAR(2)          = 'SA',
@PageNumber       INT              = 0,
@Row_Count        INT              = 10,
@FromDate         DATETIME         = NULL, -- Empty or missing in JSON
@ToDate           DATETIME         = NULL, -- Empty or missing in JSON
@QuotationNo      VARCHAR(100)     = NULL,
@EnquiryNo		 VARCHAR(100)     = NULL,

@BookingNo        VARCHAR(100)     = null, -- NULL in JSON, so default used
@AgentID          INT              = NULL,
@Status           INT              = NULL,
@CustomerID       INT              = NULL,
@FHE              UNIQUEIDENTIFIER = 'feeceb69-c92c-41a9-98de-fa86fcc009e9',
@isArrivalDate    BIT              = NULL,
@DateFilterType   VARCHAR(10)      = NULL,
@DaysRange        INT              = NULL,
@CompanyId        INT              = 9,
@YearId           INT              = 4,
@CreatedBy        UNIQUEIDENTIFIER = 'feeceb69-c92c-41a9-98de-fa86fcc009e9'
AS
BEGIN
    DECLARE @TotalRecordCount INT = 0
    DECLARE @SQL NVARCHAR(MAX)

	SET @DaysRange = CASE WHEN @DaysRange < 0 THEN 0 ELSE @DaysRange END

	IF (@FromDate IS NULL AND @DaysRange IS NOT NULL AND @DateFilterType IS NOT NULL)
    BEGIN
        SET @FromDate = CAST(GETDATE() AS DATE)
        SET @ToDate = DATEADD(DAY, @DaysRange, @FromDate)
    END

	IF @Action = 'SA'
    BEGIN

        -- Count total records for pagination
        SELECT @TotalRecordCount = (select count(*) from (SELECT DISTINCT
            B.id AS BookingID,
            Q.QuotationID,
            Q.QuotationNo,
			Q.QuotationID as Quotation_ID,
            Q.QuotationNo as Quotation_No,
			Q.QuotationSequence,
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
         from  [dbo].[tbl_Enquiry] E
        LEFT JOIN [Quotation].[QuotationMaster] Q ON E.EQID = Q.EnquiryID
        LEFT JOIN [Booking].[tbl_Booking] B ON B.EnquiryID = E.EQID
        LEFT JOIN [Booking].[BookingStatus] BS ON B.Status = BS.StatusCode
        LEFT JOIN AgentMaster AM ON B.AgentId = AM.AgentID
        LEFT JOIN CurrencyMaster CM ON Q.Currency = CM.ID
        LEFT JOIN Customer C ON E.ClientID = C.CID
        LEFT JOIN GST_Percentage G ON G.GSTID = Q.TaxonSale
        LEFT JOIN Invoice.Invoice I ON B.Id = I.BookingID
        LEFT JOIN EmployeeMaster EM ON EM.UserID = B.FHE
		LEFT JOIN Xo X oN X.File_ID = B.ID
        WHERE 
            --(@FromDate IS NULL OR
            --    (@isArrivalDate = 1 AND B.StartDate >= @FromDate AND B.StartDate < DATEADD(DAY, 1, @ToDate)) OR
            --    (@isArrivalDate = 0 AND B.CreatedOn >= @FromDate AND B.CreatedOn < DATEADD(DAY, 1, @ToDate)))
			(
                (@FromDate IS NULL) OR
                (
                    (@DateFilterType = 'START' AND B.StartDate  >= @FromDate AND B.StartDate <  DATEADD(DAY, @DaysRange, @FromDate)) OR
                    (@DateFilterType = 'END'   AND B.EndDate	>= @FromDate AND B.EndDate   < DATEADD(DAY, @DaysRange, @FromDate)) OR
                    (
                        (ISNULL(@DateFilterType,'')='') AND 
                        (
                            (@isArrivalDate = 1 AND B.StartDate >= @FromDate AND B.StartDate < DATEADD(DAY, 1, @ToDate)) OR
                            (@isArrivalDate = 0 AND B.CreatedOn >= @FromDate AND B.CreatedOn < DATEADD(DAY, 1, @ToDate))
                        )
                    )
                )
            )
            AND (@QuotationID IS NULL OR @QuotationID = 0 OR Q.QuotationID = @QuotationID)
            AND (@QuotationNo IS NULL OR @QuotationNo = '' OR Q.QuotationNo = @QuotationNo)
			
            AND (@EnquiryNo IS NULL OR @EnquiryNo = '' OR E.EnquiryID = @EnquiryNo)

            AND (@EnquryID IS NULL OR @EnquryID = 0 OR E.EQID = @EnquryID)
            AND (ISNULL(@AgentID, 0) = 0 OR B.AgentID = @AgentID)
            AND (@Status = 1 or @Status IS NULL OR B.Status = @Status OR @Status = 0)
            AND (@CustomerID IS NULL OR @CustomerID = 0 OR C.CID = @CustomerID)
            AND (@BookingID IS NULL OR @BookingID = 0 OR B.Id = @BookingID)
            AND (@FileCode IS NULL OR @FileCode = '' OR B.FileCode = @FileCode)
            AND (@customerName IS NULL OR @customerName = '' OR C.Fullname = @customerName)
            AND (@GuestName IS NULL OR @GuestName = '' OR B.GuestName like '%'+ @GuestName+'%')
            AND (ISNULL(@XONumber, '') = '' OR X.XONumber = @XONumber)
            AND (ISNULL(@InvoiceNumber, '') = '' OR I.InvoiceNumber = @InvoiceNumber)
			--AND
			--(
			--	(ISNULL(@DaysRange,0)=0 AND ISNULL(@DateFilterType,'')='')
				
			--)
			AND((@YearID IS null) or (Isnull(B.YearID,Isnull(Q.YearID,E.YearID))=@YearID))
			AND((@CompanyID IS null) or (Isnull(B.CompanyID,Isnull(Q.CompanyID,E.CompanyID))=@CompanyID))

			
			AND (Isnull(B.FHE,E.createdby) in (select * from [dbo].[fn_Get_All_Reporting] (@CompanyID,@FHE)))
            AND ((Isnull(@BookingNo,'-1') = '-1' )OR (B.BookingID =@BookingNo))

        )as a)
        -- Main paged result set
        SELECT DISTINCT
            B.id AS BookingID,
			B.BookingSequence,
            Q.QuotationID,
            Q.QuotationNo,
			Q.QuotationID as Quotation_ID,
            Q.QuotationNo as Quotation_No,
			Q.QuotationSequence,
            B.FileCode,
            B.GuestName,
            B.FHE,
            Q.CreatedDate AS QuotationDate,
			b.BookingID as BNO,
            CASE 
                WHEN B.Status = 2 THEN (CONCAT('D-', B.BookingID)+ case when  Isnull(convert(varchar(10),B.BookingSequence),'') ='' then '' else '.' end   + Isnull(convert(varchar(10),B.BookingSequence),'')) 
                WHEN B.Status = 3 THEN (CAST(B.BookingID AS VARCHAR)+ case when  Isnull(convert(varchar(10),B.BookingSequence),'') ='' then '' else '.' end   + Isnull(convert(varchar(10),B.BookingSequence),''))
                ELSE (CAST(B.BookingID AS VARCHAR)+ case when  Isnull(convert(varchar(10),B.BookingSequence),'') ='' then '' else '.' end   + Isnull(convert(varchar(10),B.BookingSequence),''))
            END AS BookingNo,
            case when (B.ID is null and @Status=1) then 'Pending' else BS.StatusName end as  StatusName,
            case when (B.ID is null and @Status=1) then 1 else B.Status end as Status,
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
			B.StartDate AS FromDate,
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
                SELECT BversionSeq.ParentID, BversionSeq.ID AS ChildID, BversionSeq.BookingID,
                       BversionSeq.BookingSequence, BversionSeq.Status, BS2.StatusName
                FROM Booking.tbl_Booking BversionSeq
                LEFT JOIN Booking.BookingStatus BS2 ON BversionSeq.STATUS = BS2.StatusCode
                WHERE BversionSeq.BookingID = B.BookingID
                      AND BversionSeq.BookingSequence IS NOT NULL
                FOR JSON PATH
            ) AS VersionSequence,
			E.IsSysGenEnquiry
        FROM [dbo].[tbl_Enquiry] E
        LEFT JOIN [Quotation].[QuotationMaster] Q ON E.EQID = Q.EnquiryID
        LEFT JOIN [Booking].[tbl_Booking] B ON  B.QuotationID = Q.QuotationID 
        LEFT JOIN [Booking].[BookingStatus] BS ON B.Status = BS.StatusCode
        LEFT JOIN AgentMaster AM ON B.AgentId = AM.AgentID
        LEFT JOIN CurrencyMaster CM ON Q.Currency = CM.ID
        LEFT JOIN Customer C ON E.ClientID = C.CID
        LEFT JOIN GST_Percentage G ON G.GSTID = Q.TaxonSale
        LEFT JOIN Invoice.Invoice I ON B.Id = I.BookingID
        LEFT JOIN EmployeeMaster EM ON EM.UserID = B.FHE
		LEFT JOIN Xo X oN X.File_ID = B.ID
        WHERE 
            --(@FromDate IS NULL OR
            --    (@isArrivalDate = 1 AND B.StartDate >= @FromDate AND B.StartDate < DATEADD(DAY, 1, @ToDate)) OR
            --    (@isArrivalDate = 0 AND B.CreatedOn >= @FromDate AND B.CreatedOn < DATEADD(DAY, 1, @ToDate)))
			(
                (@FromDate IS NULL) OR
                (
                    (@DateFilterType = 'START' AND B.StartDate  >= @FromDate AND B.StartDate < DATEADD(DAY, @DaysRange, @FromDate)) OR
                    (@DateFilterType = 'END'   AND B.EndDate	>= @FromDate AND B.EndDate   < DATEADD(DAY, @DaysRange, @FromDate)) OR
                    (
                        (ISNULL(@DateFilterType,'')='') AND 
                        (
                            (@isArrivalDate = 1 AND B.StartDate >= @FromDate AND B.StartDate < DATEADD(DAY, 1, @ToDate)) OR
                            (@isArrivalDate = 0 AND B.CreatedOn >= @FromDate AND B.CreatedOn < DATEADD(DAY, 1, @ToDate))
                        )
                    )
                )
            )
            AND (@QuotationID IS NULL OR @QuotationID = 0 OR Q.QuotationID = @QuotationID)
			AND (@QuotationNo IS NULL OR @QuotationNo = '' OR Q.QuotationNo = @QuotationNo)
            AND (@EnquiryNo IS NULL OR @EnquiryNo = '' OR E.EnquiryID = @EnquiryNo)

            AND (@EnquryID IS NULL OR @EnquryID = 0 OR E.EQID = @EnquryID)
            AND (ISNULL(@AgentID, 0) = 0 OR B.AgentID = @AgentID)
            AND ((B.ID is null and @Status=1)or((B.ID is not null) and (@Status IS NULL OR B.Status = @Status OR @Status = 0)))
            AND (@CustomerID IS NULL OR @CustomerID = 0 OR C.CID = @CustomerID)
            AND (@BookingID IS NULL OR @BookingID = 0 OR B.Id = @BookingID)
            AND (@FileCode IS NULL OR @FileCode = '' OR B.FileCode = @FileCode)
            AND (@customerName IS NULL OR @customerName = '' OR C.Fullname = @customerName)
            AND (@GuestName IS NULL OR @GuestName = '' OR  B.GuestName like '%'+ @GuestName+'%')
            AND (ISNULL(@XONumber, '') = '' OR X.XONumber = @XONumber)
            AND (ISNULL(@InvoiceNumber, '') = '' OR I.InvoiceNumber = @InvoiceNumber)
			--AND
			--(
			--	(ISNULL(@DaysRange,0)=0 AND ISNULL(@DateFilterType,'')='')
				
			--)
					AND((@YearID IS null) or (Isnull(B.YearID,Isnull(Q.YearID,E.YearID))=@YearID))
					AND((@CompanyID IS null) or (Isnull(B.CompanyID,Isnull(Q.CompanyID,E.CompanyID))=@CompanyID))

			AND (Isnull(B.FHE,E.createdby) in (select * from [dbo].[fn_Get_All_Reporting] (@CompanyID,@FHE)))
			            AND (
						(Isnull(@BookingNo,'-1') = '-1' )
						OR (B.BookingID =@BookingNo )
						)

						AND B.QuotationID !=0
--Order by B.BookingID,B.BookingSequence desc
Union All
        SELECT DISTINCT
            B.id AS BookingID,
			B.BookingSequence,
            0 as QuotationID,
             '' as QuotationNo,
			0 as Quotation_ID,
           '' as Quotation_No,
			0 as QuotationSequence,
            B.FileCode,
            B.GuestName,
            B.FHE,
            null AS QuotationDate,
			b.BookingID as BNO,
            CASE 
                WHEN B.Status = 2 THEN (CONCAT('D-', B.BookingID)+ case when  Isnull(convert(varchar(10),B.BookingSequence),'') ='' then '' else '.' end   + Isnull(convert(varchar(10),B.BookingSequence),'')) 
                WHEN B.Status = 3 THEN (CAST(B.BookingID AS VARCHAR)+ case when  Isnull(convert(varchar(10),B.BookingSequence),'') ='' then '' else '.' end   + Isnull(convert(varchar(10),B.BookingSequence),''))
                ELSE (CAST(B.BookingID AS VARCHAR)+ case when  Isnull(convert(varchar(10),B.BookingSequence),'') ='' then '' else '.' end   + Isnull(convert(varchar(10),B.BookingSequence),''))
            END AS BookingNo,
            case when (B.ID is null and @Status=1) then 'Pending' else BS.StatusName end as  StatusName,
            case when (B.ID is null and @Status=1) then 1 else B.Status end as Status,
            E.EnquiryID,
            E.EQID,
            CASE 
                WHEN B.SupplierTax_InCluding = 1 THEN 'Including Tax'
                ELSE 'Excluding Tax'
            END AS TaxTypeName,
            AM.AgentName AS AgentStaffName,
            G.GSTPercentage,
            B.taxID as TaxonSale,
            B.Currency AS CurrencyID,
            CM.CurrencyCode,
            AM.AgentName,
            B.CreatedOn as CreatedDate,
            B.StartDate,
			B.StartDate AS FromDate,
            B.EndDate,
            EM.EmpName AS FHEName,
          '' AS RateCardMode,
            @TotalRecordCount AS TotalCount,
            C.Fullname AS CustomerName,
            (
                SELECT BversionSeq.ParentID, BversionSeq.ID AS ChildID, BversionSeq.BookingID,
                       BversionSeq.BookingSequence, BversionSeq.Status, BS2.StatusName
                FROM Booking.tbl_Booking BversionSeq
                LEFT JOIN Booking.BookingStatus BS2 ON BversionSeq.STATUS = BS2.StatusCode
                WHERE BversionSeq.BookingID = B.BookingID
                      AND BversionSeq.BookingSequence IS NOT NULL
                FOR JSON PATH
            ) AS VersionSequence,
			E.IsSysGenEnquiry
        FROM [dbo].[tbl_Enquiry] E
        LEFT JOIN [Booking].[tbl_Booking] B ON  E.EQID = B.EnquiryID
        LEFT JOIN [Booking].[BookingStatus] BS ON B.Status = BS.StatusCode
        LEFT JOIN AgentMaster AM ON B.AgentId = AM.AgentID
        LEFT JOIN CurrencyMaster CM ON B.Currency = CM.ID
        LEFT JOIN Customer C ON E.ClientID = C.CID
        LEFT JOIN GST_Percentage G ON G.GSTID = B.taxID
        LEFT JOIN Invoice.Invoice I ON B.Id = I.BookingID
        LEFT JOIN EmployeeMaster EM ON EM.UserID = B.FHE
		LEFT JOIN Xo X oN X.File_ID = B.ID
        WHERE 
            --(@FromDate IS NULL OR
            --    (@isArrivalDate = 1 AND B.StartDate >= @FromDate AND B.StartDate < DATEADD(DAY, 1, @ToDate)) OR
            --    (@isArrivalDate = 0 AND B.CreatedOn >= @FromDate AND B.CreatedOn < DATEADD(DAY, 1, @ToDate)))
			(
                (@FromDate IS NULL) OR
                (
                    (@DateFilterType = 'START' AND B.StartDate  >= @FromDate AND B.StartDate < DATEADD(DAY, @DaysRange, @FromDate)) OR
                    (@DateFilterType = 'END'   AND B.EndDate	>= @FromDate AND B.EndDate   < DATEADD(DAY, @DaysRange, @FromDate)) OR
                    (
                        (ISNULL(@DateFilterType,'')='') AND 
                        (
                            (@isArrivalDate = 1 AND B.StartDate >= @FromDate AND B.StartDate < DATEADD(DAY, 1, @ToDate)) OR
                            (@isArrivalDate = 0 AND B.CreatedOn >= @FromDate AND B.CreatedOn < DATEADD(DAY, 1, @ToDate))
                        )
                    )
                )
            )
            --AND (@QuotationID IS NULL OR @QuotationID = 0 OR Q.QuotationID = @QuotationID)
            AND (@EnquryID IS NULL OR @EnquryID = 0 OR E.EQID = @EnquryID)
            AND (@EnquiryNo IS NULL OR @EnquiryNo = '' OR E.EnquiryID = @EnquiryNo)

            AND (ISNULL(@AgentID, 0) = 0 OR B.AgentID = @AgentID)
            AND ((B.ID is null and @Status=1)or((B.ID is not null) and (@Status IS NULL OR B.Status = @Status OR @Status = 0)))
            AND (@CustomerID IS NULL OR @CustomerID = 0 OR C.CID = @CustomerID)
            AND (@BookingID IS NULL OR @BookingID = 0 OR B.Id = @BookingID)
            AND (@FileCode IS NULL OR @FileCode = '' OR B.FileCode = @FileCode)
            AND (@customerName IS NULL OR @customerName = '' OR C.Fullname = @customerName)
            AND (@GuestName IS NULL OR @GuestName = '' OR  B.GuestName like '%'+ @GuestName+'%')
            AND (ISNULL(@XONumber, '') = '' OR X.XONumber = @XONumber)
            AND (ISNULL(@InvoiceNumber, '') = '' OR I.InvoiceNumber = @InvoiceNumber)
			--AND
			--(
			--	(ISNULL(@DaysRange,0)=0 AND ISNULL(@DateFilterType,'')='')
				
			--)
			--AND (B.YearID=@YearId)
			--AND  (B.CompanyId=@CompanyId)
								AND((@YearID IS null) or (Isnull(B.YearID,E.YearID)=@YearID))
					AND((@CompanyID IS null) or (Isnull(B.CompanyID,E.CompanyID)=@CompanyID))

			AND (Isnull(B.FHE,E.createdby) in (select * from [dbo].[fn_Get_All_Reporting] (@CompanyID,@FHE)))
			            AND (
						(Isnull(@BookingNo,'-1') = '-1' )
						OR (B.BookingID =@BookingNo )
						)
						AND B.QuotationID =0
Order by B.BookingID desc ,B.BookingSequence asc
        --ORDER BY  CASE 
        --        WHEN B.Status = 2 THEN (CONCAT('D-', B.BookingID)+ case when  Isnull(B.BookingSequence,'') ='' then '' else '.' end   + Isnull(B.BookingSequence,'')) 
        --        WHEN B.Status = 3 THEN (CAST(B.BookingID AS VARCHAR)+ case when  Isnull(B.BookingSequence,'') ='' then '' else '.' end   + Isnull(B.BookingSequence,''))
        --        ELSE (CAST(B.BookingID AS VARCHAR)+ case when  Isnull(B.BookingSequence,'') ='' then '' else '.' end   + Isnull(B.BookingSequence,''))
        --    END  DESC
        OFFSET @PageNumber * @Row_Count ROWS
        FETCH NEXT @Row_Count ROWS ONLY;

		
        SELECT CAST(@TotalRecordCount AS VARCHAR(20)) AS Row_Count, '200' AS returnCode, 'Data Found' AS returnMessage;
    END
    -- Leave @Action = 'S' logic as is, or let me know if you'd like to convert that too

  
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
