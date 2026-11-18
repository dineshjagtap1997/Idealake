
CREATE PROCEDURE [Quotation].[usp_InsertUpdateQuotation_bkp20250617]
    @QuotationID BIGINT = 2,
    @EQID BIGINT = NULL,
    @Currency INT = NULL,
    @TaxType BIT = NULL,  
    @TaxonSale INT = NULL,
    @ParentID INT = NULL,
    @Disclaimer NVARCHAR(500) = NULL,
    @BookingID BIGINT = NULL,
    @CreatedBy UNIQUEIDENTIFIER = NULL,
    @QuotationFromDate DATETIME = NULL,
    @QuotationToDate DATETIME = NULL,
    @YearID INT = NULL,
    @CustomerID BIGINT = NULL,
    @AgentID BIGINT = NULL,
    @Status INT = NULL,
    @AgentStaffName NVARCHAR(100) = NULL,
    @OperationBy UNIQUEIDENTIFIER = NULL,
    @Action CHAR(2)='SA', -- 'I', 'U', 'S', or 'SA'
    @CompanyID INT = NULL,
    @QuotationNo NVARCHAR(500) = NULL,
    @OutQuotationID BIGINT = NULL OUTPUT,
    @RateCardMode NVARCHAR(15) = NULL,
	--@PageNumber INT=0,
	--@PageSize INT=10,
	--@TotalCount INT OUTPUT
	@Row_Count VARCHAR(max) = '10',     
	@PageNumber INT = 0 
	,@QuotationDate DATETIME = NULL
	,@AgentName nvarchar(200) = null
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CompanyCode NVARCHAR(5) = '';
    DECLARE @YearCode NVARCHAR(5) = '';
    DECLARE @Prefix NVARCHAR(20) = '';
    DECLARE @MaxNumber INT = 0;
    DECLARE @NewQuotationNo NVARCHAR(50);
  --  DECLARE @NewEnquiryID BIGINT;
    DECLARE @ExistingEnquiryID BIGINT;
    DECLARE @ID INT;

    -- Fetch CompanyCode
    IF @CompanyID IS NOT NULL AND @CompanyID > 0
    BEGIN
        SELECT @CompanyCode = ISNULL(CompCode, '')
        FROM CompanyMaster
        WHERE CompanyID = @CompanyID;
    END

    -- Fetch YearCode
    IF @YearID IS NOT NULL AND @YearID > 0
    BEGIN
        SELECT @YearCode = ISNULL(YearCode, '')
        FROM YearMaster
        WHERE YearID = @YearID;
    END

    SET @Prefix = 'Q' + @CompanyCode + @YearCode;

	DECLARE @TotalRecordCount INT,@SQL NVARCHAR(MAX);   

    --IF @Action = 'I'
    --BEGIN
    --    SELECT @MaxNumber = ISNULL(MAX(CAST(RIGHT(QuotationNo, 6) AS INT)), 0)
    --    FROM [Quotation].[QuotationMaster]
    --    WHERE QuotationNo LIKE @Prefix + '%'
    --    AND ISNUMERIC(RIGHT(QuotationNo, 6)) = 1;

    --    SET @NewQuotationNo = @Prefix + RIGHT('000000' + CAST(@MaxNumber + 1 AS VARCHAR(6)), 6);

    --    INSERT INTO [Quotation].[QuotationMaster]
    --    (
    --        QuotationNo, EnquiryID, Status, CreatedBy, CreatedDate, RateCardMode, CompanyID
    --    )
    --    VALUES
    --    (
    --        @NewQuotationNo,
    --        @EQID,
    --        CASE 
    --            WHEN @EQID IS NOT NULL AND @EQID <> 0 THEN 1
    --            ELSE 0
    --        END,
    --        @CreatedBy,
    --        GETDATE(),
    --        @RateCardMode,
    --        @CompanyID
    --    );

	-- NEW: Fetch AgentName if AgentID is provided
    IF @AgentID IS NOT NULL AND @AgentID > 0
    BEGIN
        SELECT @AgentName = COALESCE(
            (SELECT AgentName FROM AgentMaster WHERE AgentID = @AgentID), 
            @AgentName
        );
    END
	IF @Action = 'I'
BEGIN
   
    IF ISNULL(@EQID, 0) = 0
    BEGIN
        DECLARE @NewEnquiryID INT;

		CREATE TABLE #TempEnquiry
		(
			returnCode VARCHAR(1000),
			returnMessage  VARCHAR(1000),
			ID INT,
			EnquiryID VARCHAR(1000)
		);

		INSERT INTO #TempEnquiry
        EXEC [dbo].[usp_Enquiry]
            @AgentID = @AgentID,
            @AgentStaffName = @AgentStaffName,
            @OperationBy = @OperationBy,
            @Action = 'I',
            @IsDraft = 0,
            @ID = @ID output,
			@IsAutoEnquiry=1

			SELECT @NewEnquiryID = ID 
			FROM #TempEnquiry

        SET @EQID = @NewEnquiryID;

		DROP TABLE #TempEnquiry
    END

   
    SELECT @MaxNumber = ISNULL(MAX(CAST(RIGHT(QuotationNo, 6) AS INT)), 0)
    FROM [Quotation].[QuotationMaster]
    WHERE QuotationNo LIKE @Prefix + '%'
    AND ISNUMERIC(RIGHT(QuotationNo, 6)) = 1;

    SET @NewQuotationNo = @Prefix + RIGHT('000000' + CAST(@MaxNumber + 1 AS VARCHAR(6)), 6);

    
    INSERT INTO [Quotation].[QuotationMaster] (
        QuotationNo, 
        EnquiryID, 
        Status, 
        CreatedBy, 
        CreatedDate, 
        RateCardMode, 
        CompanyID,
		AgentName,
		TaxonSale,
		YearID,
		Currency
    )
    VALUES (
        @NewQuotationNo,
        @EQID,
        1,
        @CreatedBy,
        GETDATE(),
        @RateCardMode,
        @CompanyID,
		@AgentName,
		@TaxonSale,
		@YearCode
		,@Currency
    );

    SET @OutQuotationID = SCOPE_IDENTITY();
    SET @QuotationNo = @NewQuotationNo;
	
    SELECT 
        '200' AS returnCode,
        'Quotation created successfully' AS returnMessage,
        CAST(@OutQuotationID AS VARCHAR) AS ID;
END

   -- ELSE IF @Action = 'U'
   -- BEGIN
   --     SET @ExistingEnquiryID = (SELECT EnquiryID FROM [Quotation].[QuotationMaster] WHERE QuotationID = @QuotationID);

   --     IF ISNULL(@ExistingEnquiryID, 0) = 0
   --     BEGIN
   --         EXEC [dbo].[usp_Enquiry]
   --             @AgentID = @AgentID,
   --             @AgentStaffName = @AgentStaffName,
   --             @OperationBy = @OperationBy,
   --             @Action = 'I',
   --             @IsDraft = 1,
   --             @ID = @ID OUTPUT;

   --         UPDATE [Quotation].[QuotationMaster]
   --         SET EnquiryID = @ID
   --         WHERE QuotationID = @QuotationID;
   --     END
   --     ELSE
   --     BEGIN
   --         EXEC [dbo].[usp_Enquiry]
   --             @EQID = @EQID,
   --             @AgentID = @AgentID,
   --             @AgentStaffName = @AgentStaffName,
   --             @OperationBy = @OperationBy,
   --             @Action = 'U',
   --             @ID = @ID OUTPUT;
   --     END

   --     UPDATE [Quotation].[QuotationMaster]
   --     SET
   --         Currency = @Currency,
   --         TaxType = @TaxType,
   --         TaxonSale = @TaxonSale,
   --         ParentID = @ParentID,
   --         Disclaimer = @Disclaimer,
   --         BookingID = @BookingID,
   --         Status = 1,
   --         UpdatedBy = @CreatedBy,
   --         UpdatedDate = GETDATE(),
   --         RateCardMode = @RateCardMode,
   --         CompanyID = @CompanyID,
			--AgentName = @AgentName,
			--YearID = @YearCode
   --     WHERE QuotationID = @QuotationID;

   --     SET @OutQuotationID = @QuotationID;

   --     SELECT 
   --         '200' AS returnCode,
   --         'Quotation Updated successfully' AS returnMessage,
   --         @QuotationID AS ID;
   -- END
   --returncode
   ELSE IF @Action = 'U'
BEGIN
    SET @ExistingEnquiryID = (SELECT EnquiryID FROM [Quotation].[QuotationMaster] WHERE QuotationID = @QuotationID);

    IF ISNULL(@ExistingEnquiryID, 0) = 0
    BEGIN
        EXEC [dbo].[usp_Enquiry]
            @AgentID = @AgentID,
            @AgentStaffName = @AgentStaffName,
            @OperationBy = @OperationBy,
            @Action = 'I',
            @IsDraft = 1,
            @ID = @ID OUTPUT;

        UPDATE [Quotation].[QuotationMaster]
        SET EnquiryID = @ID
        WHERE QuotationID = @QuotationID;
    END
    ELSE
    BEGIN
        EXEC [dbo].[usp_Enquiry]
            @EQID = @EQID,
            @AgentID = @AgentID,
            @AgentStaffName = @AgentStaffName,
            @OperationBy = @OperationBy,
            @Action = 'U',
            @ID = @ID OUTPUT;
    END

    UPDATE [Quotation].[QuotationMaster]
    SET
        Currency = @Currency,
        TaxType = @TaxType,
        TaxonSale = @TaxonSale,
        ParentID = @ParentID,
        Disclaimer = @Disclaimer,
        BookingID = @BookingID,
        Status = 1,
        UpdatedBy = @CreatedBy,
        UpdatedDate = GETDATE(),
        RateCardMode = @RateCardMode,
        CompanyID = @CompanyID,
        AgentName = @AgentName,
        YearID = @YearCode
    WHERE QuotationID = @QuotationID;

    SET @OutQuotationID = @QuotationID;

    -- Return success message with "Data updated successfully"
    SELECT 
        '200' AS returnCode,
        'Data updated successfully' AS returnMessage,
        CAST(@QuotationID AS VARCHAR) AS ID;
END
  --  ELSE IF @Action = 'S'
  --  BEGIN
		------ 1. Getting total count 
		----SELECT 
		----	@TotalCount = COUNT(1)
  ----      FROM 
		----	[Quotation].[QuotationMaster] Q
		----	INNER JOIN [Quotation].[QuotationStatus] QS ON Q.Status = QS.StatusCode
		----	LEFT JOIN [dbo].[tbl_Enquiry] E ON Q.EnquiryID = E.EQID
		----	LEFT JOIN Currency CM ON Q.Currency = CM.CurrencyID
		----	LEFT JOIN AgentMaster AM ON E.AgentId = AM.AgentID
		----	LEFT JOIN CompanyMaster C ON Q.CompanyID = C.CompanyID
  ----      WHERE
		----	Q.QuotationID = @QuotationID;

		------ 2. Return paginated data
  ----      SELECT 
  ----          Q.QuotationID AS ID,
  ----          CASE 
  ----              WHEN Q.Status = 1 THEN CONCAT('D-', Q.QuotationNo)
  ----              WHEN Q.Status = 0 THEN ''
  ----              ELSE Q.QuotationNo
  ----          END AS QuotationNo,
  ----          E.EnquiryID,
  ----          E.EQID,
  ----          CASE 
  ----            WHEN Q.TaxType = 1 THEN 'Including Tax'  -- 1 represents TRUE
  ----              WHEN Q.TaxType = 0 THEN 'Excluding Tax'  
  ----              ELSE ''
  ----          END AS TaxTypeName,
  ----          Q.TaxonSale,
  ----          CM.Code AS CurrencyCode,
  ----          AM.AgentName,
  ----          E.Agent_Staff_Name AS AgentStaffName,
  ----          Q.Status,
  ----          QS.StatusName,
  ----          C.CompanyName,
  ----          C.CompCode AS CompanyCode,
  ----          CASE
  ----              WHEN RateCardMode = '1' THEN 'Contract'
  ----              WHEN RateCardMode = '2' THEN 'Adhoc'
  ----              WHEN RateCardMode = '3' THEN 'Custom'
  ----              WHEN RateCardMode = '4' THEN 'Negotiated'
  ----              WHEN RateCardMode = '5' THEN 'IncludingExcludingTax'
  ----          END AS RateCardMode
  ----      FROM 
		----	[Quotation].[QuotationMaster] Q
		----	INNER JOIN [Quotation].[QuotationStatus] QS ON Q.Status = QS.StatusCode
		----	LEFT JOIN [dbo].[tbl_Enquiry] E ON Q.EnquiryID = E.EQID
		----	LEFT JOIN Currency CM ON Q.Currency = CM.CurrencyID
		----	LEFT JOIN AgentMaster AM ON E.AgentId = AM.AgentID
		----	LEFT JOIN CompanyMaster C ON Q.CompanyID = C.CompanyID
  ----      WHERE 
		----	Q.QuotationID = @QuotationID
		----Order by Q.QuotationID
		----OFFSET (@PageNumber - 1) * @PageSize ROWS
		----FETCH NEXT @PageSize ROWS ONLY;



		-- IF OBJECT_ID('TEMPDB..#TempReport') IS NOT NULL
		--	DROP TABLE #TempReport;

		--SELECT *
		--INTO #TempReport
		--FROM (
		--		 SELECT 
		--			Q.QuotationID AS ID,
		--			CASE 
		--				WHEN Q.Status = 1 THEN CONCAT('D-', Q.QuotationNo)
		--				WHEN Q.Status = 0 THEN ''
		--				ELSE Q.QuotationNo
		--			END AS QuotationNo,
		--			E.EnquiryID,
		--			E.EQID,
		--			CASE 
		--			  WHEN Q.TaxType = 1 THEN 'Including Tax'  -- 1 represents TRUE
		--				WHEN Q.TaxType = 0 THEN 'Excluding Tax'  
		--				ELSE ''
		--			END AS TaxTypeName,
		--			Q.TaxonSale,
		--			CM.Code AS CurrencyCode,
		--			AM.AgentName,
		--			E.Agent_Staff_Name AS AgentStaffName,
		--			Q.Status,
		--			QS.StatusName,
		--			C.CompanyName,
		--			C.CompCode AS CompanyCode,
		--			CASE
		--				WHEN RateCardMode = '1' THEN 'Contract'
		--				WHEN RateCardMode = '2' THEN 'Adhoc'
		--				WHEN RateCardMode = '3' THEN 'Custom'
		--				WHEN RateCardMode = '4' THEN 'Negotiated'
		--				WHEN RateCardMode = '5' THEN 'IncludingExcludingTax'
		--			END AS RateCardMode
		--		FROM 
		--			[Quotation].[QuotationMaster] Q
		--			LEFT JOIN [Quotation].[QuotationStatus] QS ON Q.Status = QS.StatusCode
		--			LEFT JOIN [dbo].[tbl_Enquiry] E ON Q.EnquiryID = E.EQID
		--			LEFT JOIN Currency CM ON Q.Currency = CM.CurrencyID
		--			LEFT JOIN AgentMaster AM ON E.AgentId = AM.AgentID
		--			LEFT JOIN CompanyMaster C ON Q.CompanyID = C.CompanyID
		--		WHERE 
		--			(ISNULL(@QuotationID,0)=0 OR Q.QuotationID = @QuotationID)
		--	) AS RowConstrainedResult
		--	ORDER BY ID DESC
				

		--	SELECT @TotalRecordCount = count(*) FROM #TempReport                                                                  
		--	IF @Row_Count = ''                                                                  
		--	 OR @Row_Count = - 1                                                                  
		--	BEGIN                                                                  
		--		SET @Row_Count = @TotalRecordCount                                                                  
		--	END                                                                  
		--	SELECT @SQL = 'select * from #TempReport                                                                                                                                 
		--	  ORDER BY ID DESC                                                                                                                              
		--	  OFFSET ' + CAST((@PageNumber * @Row_Count) AS VARCHAR(20)) + ' ROWS                                                                      
		--	  FETCH NEXT ' + CAST(@Row_Count AS VARCHAR(20)) + ' ROWS ONLY'                                                      
		--	EXEC sys.sp_executesql @SQL     
			
		--  --  -- select * from #TempReport                                      
		--  select  CAST(@TotalRecordCount AS VARCHAR(20))  as Row_Count , '200' AS returnCode                                                                      
		--	  ,'Data Found' AS returnMessage                     
		--  SELECT '200' AS returnCode        
		--   ,'Data Found' AS returnMessage  

  --  END
	ELSE IF @Action = 'S'
BEGIN
    IF OBJECT_ID('TEMPDB..#TempReport') IS NOT NULL
        DROP TABLE #TempReport;

    SELECT *
    INTO #TempReport
    FROM (
        SELECT 
            Q.QuotationID AS QuotationID,
			Q.CreatedDate  AS QuotationDate, -- Added CreatedDate here
            CASE 
                WHEN Q.Status = 1 THEN CONCAT('D-', Q.QuotationNo)
                WHEN Q.Status = 0 THEN ''
                ELSE Q.QuotationNo
            END AS QuotationNo,
            E.EnquiryID,
            E.EQID,
            CASE 
                WHEN Q.TaxType = 1 THEN 'Including Tax'
                WHEN Q.TaxType = 0 THEN 'Excluding Tax'  
                ELSE ''
            END AS TaxTypeName,
			G.GSTPercentage,
            Q.TaxonSale,
			 -- Q.Currency AS CurrencyID,
            CM.CurrencyCode AS CurrencyCode,
			CM.ID AS CurrencyID,
            Q.AgentName,
			AM.AgentID,
            E.Agent_Staff_Name AS AgentStaffName,
            Q.Status,
            QS.StatusName,
			QS.ColourCode,
            C.CompanyName,
            C.CompCode AS CompanyCode,
            --CASE
            --    WHEN RateCardMode = '1' THEN 'Contract'
            --    WHEN RateCardMode = '2' THEN 'Adhoc'
            --    WHEN RateCardMode = '3' THEN 'Custom'
            --    WHEN RateCardMode = '4' THEN 'Negotiated'
            --    WHEN RateCardMode = '5' THEN 'IncludingExcludingTax'
            --END AS RateCardMode
			RateCardMode
        FROM 
            [Quotation].[QuotationMaster] Q
            LEFT JOIN [Quotation].[QuotationStatus] QS ON Q.Status = QS.StatusCode
          LEFT JOIN [dbo].[tbl_Enquiry] E ON Q.EnquiryID = E.EQID
            LEFT JOIN CurrencyMaster CM ON Q.Currency = CM.id
           LEFT JOIN AgentMaster AM ON E.AgentId = AM.AgentID
            LEFT JOIN CompanyMaster C ON Q.CompanyID = C.CompanyID
			LEFT JOIN GST_Percentage G ON G.GSTID = Q.TaxonSale
        WHERE 
            (ISNULL(@QuotationID,0)=0 OR Q.QuotationID = @QuotationID)

    ) AS RowConstrainedResult
    ORDER BY QuotationID DESC

    SELECT @TotalRecordCount = count(*) FROM #TempReport                                                                  
    IF @Row_Count = '' OR @Row_Count = -1                                                                  
    BEGIN                                                                  
        SET @Row_Count = @TotalRecordCount                                                                  
    END                                                                  
    SELECT @SQL = 'SELECT * FROM #TempReport                                                                                                                                 
        ORDER BY QuotationID DESC                                                                                                                              
        OFFSET ' + CAST((@PageNumber * @Row_Count) AS VARCHAR(20)) + ' ROWS                                                                      
        FETCH NEXT ' + CAST(@Row_Count AS VARCHAR(20)) + ' ROWS ONLY'                                                      
    EXEC sys.sp_executesql @SQL     
    
    SELECT CAST(@TotalRecordCount AS VARCHAR(20)) AS Row_Count, '200' AS returnCode, 'Data Found' AS returnMessage                     
    SELECT '200' AS returnCode, 'Data Found' AS returnMessage  
END
	
    ELSE IF @Action = 'SA'
    BEGIN

		IF OBJECT_ID('TEMPDB..#TempReportSA') IS NOT NULL
			DROP TABLE #TempReportSA;

		
		SELECT *
		INTO #TempReportSA
		FROM (
				SELECT 
				 Q.QuotationID AS QuotationID,
				Q.CreatedDate  AS QuotationDate, -- Added CreatedDate here
					CASE 
						WHEN Q.Status = 1 THEN CONCAT('D-', Q.QuotationNo)
						WHEN Q.Status = 0 THEN Q.QuotationNo
						ELSE Q.QuotationNo
					END AS QuotationNo,
					QS.StatusName,
					Q.Status,
					E.EnquiryID,
					E.EQID,
					CASE 
						WHEN Q.TaxType = 1 THEN 'Including Tax'
						ELSE 'Excluding Tax'
					END AS TaxTypeName,
					 E.Agent_Staff_Name AS AgentStaffName,
					 G.GSTPercentage,
					Q.TaxonSale,
					 Q.Currency AS CurrencyID,
					CM.Code AS CurrencyCode,
					Q.AgentName,
					Q.CreatedDate,
					CASE
						WHEN RateCardMode = '1' THEN 'Contract'
						WHEN RateCardMode = '2' THEN 'Adhoc'
						WHEN RateCardMode = '3' THEN 'Custom'
						WHEN RateCardMode = '4' THEN 'Negotiated'
						WHEN RateCardMode = '5' THEN 'IncludingExcludingTax'
					END AS RateCardMode,
			   ( select * from   ( SELECT
			QversionSeq.ParentID as QuotationID,
			QversionSeq.QuotationID as ChildID,
			QversionSeq.QuotationNo,
			QversionSeq.QuotationSequence
        FROM [Quotation].[QuotationMaster] QversionSeq where QversionSeq.ParentID =Q.QuotationID
		and QversionSeq.QuotationSequence is not null
    ) as QVs
    FOR JSON PATH ) as VersionSequence
				FROM [Quotation].[QuotationMaster] Q
					LEFT JOIN [Quotation].[QuotationStatus] QS ON Q.Status = QS.StatusCode
					LEFT JOIN [dbo].[tbl_Enquiry] E ON Q.EnquiryID = E.EQID
					LEFT JOIN AgentMaster AM ON E.AgentId = AM.AgentID
					LEFT JOIN Currency CM ON Q.Currency = CM.CurrencyID
					LEFT JOIN Customer C ON E.ClientID = C.CID
					LEFT JOIN GST_Percentage G ON G.GSTPercentage = Q.TaxonSale
				WHERE 
					(
						(@QuotationFromDate IS NULL)
						OR
						(
							Q.CreatedDate >= @QuotationFromDate
							AND Q.CreatedDate < DATEADD(DAY, 1, @QuotationToDate)
						)
					)
					-- AND  Q.QuotationNo = @QuotationNo
					--AND (@QuotationID IS NULL OR Q.QuotationID=@QuotationID)
					--AND 
					--( 
					--	@QuotationNo IS NULL 
					--	OR @QuotationNo = '' 
					--	OR CAST(Q.QuotationNo AS nvarchar) LIKE '%' + @QuotationNo + '%'
					--	OR CAST(Q.QuotationNo AS nvarchar) LIKE '%D-' + @QuotationNo + '%'
					--)
					--AND (@EQID IS NULL OR @EQID = 0 OR E.EQID = @EQID)
					--AND (@AgentID IS NULL OR @AgentID = 0 OR E.AgentID = @AgentID)
					--AND (@Status IS NULL OR @Status=0 OR Q.Status = @Status )
					--AND (@CustomerID IS NULL OR @CustomerID = 0 OR C.CID = @CustomerID)

					--AND (
					--	  @QuotationNo IS NULL 
					--	  OR @QuotationNo = '' 
					--	  OR Q.QuotationNo LIKE '%' + @QuotationNo + '%'
					--	  OR Q.QuotationNo LIKE '%D-' + @QuotationNo + '%'
					--	)
					AND (
						@QuotationNo IS NULL 
						OR @QuotationNo = '' 
						OR (
							-- Normalize both sides for matching
							'D-' + CAST(Q.QuotationNo AS NVARCHAR) LIKE '%' + @QuotationNo + '%'
							OR CAST(Q.QuotationNo AS NVARCHAR) LIKE '%' + @QuotationNo + '%'
						)
					)
AND (@EQID IS NULL OR @EQID = 0 OR E.EQID = @EQID)
AND (@AgentID IS NULL OR @AgentID = 0 OR E.AgentID = @AgentID)
AND (@Status IS NULL OR @Status = 0 OR Q.Status = @Status ) and Q.QuotationID=2
			) AS RowConstrainedResult
			ORDER BY CreatedDate DESC
				

			SELECT @TotalRecordCount = count(*) FROM #TempReportSA                                                                  
			IF @Row_Count = ''                                                                  
			 OR @Row_Count = - 1                                                                  
			BEGIN                                                                  
				SET @Row_Count = @TotalRecordCount                                                                  
			END                                                                  
			SELECT @SQL = 'select * from #TempReportSA                                                                                                                                
			  ORDER BY CreatedDate DESC                                                                                                                              
			  OFFSET ' + CAST((@PageNumber * @Row_Count) AS VARCHAR(20)) + ' ROWS                                                                      
			  FETCH NEXT ' + CAST(@Row_Count AS VARCHAR(20)) + ' ROWS ONLY'                                                      
			EXEC sys.sp_executesql @SQL     
			
		  --  -- select * from #TempReportSA                                      
		  select  '200' AS returnCode                                                                      
			  ,'Data Found' AS returnMessage, CAST(@TotalRecordCount AS VARCHAR(20))  as Row_Count                    
		  --SELECT '200' AS returnCode        
		  -- ,'Data Found' AS returnMessage 
    END

END
