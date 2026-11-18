--declare
--	@DisplayRate        VARCHAR(5) = 'INR',
--    @RateCardModeTypeID VARCHAR(50) = '1,2,3,4',
--    @TaxID              INT = NULL,
--    @CityIata           CHAR(3)    = NULL,  
--    @Service            INT        = NULL,  
--    @Vendor             INT        = NULL,                                                                                                      
--    @NationalityID      INT        = NULL,                                                                                                    
--    @Adult              INT = NULL,
--    @Child             INT= NULL,   
--    @ValidFrom          DATETIME   = NULL,                                                      
--    @ValidTo            DATETIME   = NULL   ,
--	@QuotationID        INT        = NULL
--exec [usp_GetMonumentRateCardSearchReport] 'INR','1', '1','ZRP',99,0,2,'1','1','2023-03-13 00:00:00.000','2025-12-01 00:00:00.000'
--exec [RateCards].[usp_GetMonumentRateCardSearchReport] 'INR','2', '1','ZRP',159,0,null,null,1,'2025-03-13 00:00:00.000','2025-12-01 00:00:00.000'
--exec [RateCards].[usp_GetMonumentRateCardSearchReport] 'INR','Adhoc', 'Inclusive','ZRP',159,0,2,0,0,'2025-05-01 00:00:00.000','2025-05-05 00:00:00.000'
--exec [RateCards].[usp_GetMonumentRateCardSearchReport_Old] 'INR','Adhoc', 'Inclusive','ZRP',159,0,2,'1',null,'2025-05-01 00:00:00.000','2025-05-05 00:00:00.000'
CREATE PROCEDURE [RateCards].[usp_GetMonumentRateCardSearchReportNew]  
(
    @DisplayRate        VARCHAR(5) = NULL,
    @RateCardModeTypeID VARCHAR(50) = NULL,
    @TaxID              INT = NULL,
    @CityIata           CHAR(3)    = NULL,  
    @Service            INT        = NULL,  
    @Vendor             INT        = NULL,                                                                                                      
    @NationalityID      INT        = NULL,                                                                                                    
    @Adult              INT = NULL,
    @Child             INT= NULL,   
    @ValidFrom          DATETIME   = NULL,                                                      
    @ValidTo            DATETIME   = NULL   ,
<<<<<<< HEAD
<<<<<<< HEAD
	@QuotationID        INT        = NULL
=======
	@QuotationID        INT        = NULL,
	@BookingID			bigint =null,
	@MonumentRateID bigint =null
>>>>>>> dev
=======
	@QuotationID        INT        = NULL,
	@BookingID			bigint =null,
	@MonumentRateID bigint =null
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
)                                                    
AS                                                    
BEGIN
    SET NOCOUNT ON;
	  DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX), @LogID BIGINT;
	DECLARE @RateCardModeTable TABLE (ModeID INT)

-- Convert names to IDs and insert into table
--INSERT INTO @RateCardModeTable (ModeID)
--SELECT DISTINCT
--    CASE value
--        WHEN 'Contract' THEN 1
--        WHEN 'Adhoc' THEN 2
--        WHEN 'Negotiated' THEN 3
--        ELSE NULL
--    END
--FROM STRING_SPLIT(@RateCardModeTypeID, ',')
--WHERE value IS NOT NULL

INSERT INTO @RateCardModeTable (ModeID)
SELECT DISTINCT TRY_CAST(value AS INT)
FROM STRING_SPLIT(@RateCardModeTypeID, ',')
WHERE TRY_CAST(value AS INT) IS NOT NULL



--	IF (@TaxID = 'Inclusive')
--    SET @TaxID = '1';
--ELSE
--    SET @TaxID = 2;
	--SET @TaxID = CASE 
 --               WHEN @TaxID = 'Inclusive' THEN 1 
 --               ELSE 2 
 --            END;

   print @TaxID 


    SELECT 
	    MRM.MonumentRateID, 
		'RateCard' as Type,
        MRD.MonumentDetailID, 
		CRC.MonumentCommissionDetailID,
        CT.Name AS City, 
        VM.VendorName,
        MS.Name AS MonumentService, 
        N.Nationality, 
        CAST(MRD.ValidFrom AS DATE) AS ValidFrom, 
        CAST(MRD.ValidTo AS DATE) AS ValidTo,

        CASE MRM.RateCardModeTypeID 
            WHEN 1 THEN 'Contract' 
            WHEN 2 THEN 'Adhoc' 
            WHEN 3 THEN 'Negotiated' 
        END AS RateCardModeType,
		MRM.RateCardModeTypeID, 
		MRD.TaxID, 
        MRM.CardNumber, 
		MRM.Heading,
		MRM.ContractDate,
		MRM.CurrencyID,
		MRM.StateID,
		MRM.VendorID,
		MRM.InfoForOperation,
		MRM.InfoForAgent,
		MRM.InfoForRemark,
		MRM.IsActive,
--		MRM.CreatedBy,
		
--		MRM.UpdatedBy,
		MRM.UpdatedOn,
		MRM.GSTStatus,
       -- MRM.RateCardModeTypeID,
		
        MRM.CityID,
        MS.ClosedOn, 
        MS.ID AS MonumentServiceID, 
        MRD.NationalityID,
		MRD.MISSequence,
		RCM.RateType,
		CRC.CommissionMasterID,


		CRC.NetAmountExcludingTax, 
		CRC.NetAmountIncludingTax, 
		    (
        SELECT 
            CASE 
                WHEN EXISTS (SELECT 1 FROM [RateCards].[Rules] WHERE RateCardID = MRM.MonumentRateID) 
                THEN CAST(1 AS BIT) 
                ELSE CAST(0 AS BIT) 
            END
    ) AS HasRules,
    (SELECT TOP 1 
        CASE 
            WHEN ud.DocumentID IS NOT NULL THEN CAST(1 AS BIT) 
            ELSE CAST(0 AS BIT) 
        END
     FROM dbo.LinkedDocuments ld 
     INNER JOIN dbo.UploadDocuments ud 
         ON ld.ParentID = MRM.MonumentRateID 
         AND ud.DocumentID = ld.DocumentID 
         AND ud.ParentTypeID = 2
    ) AS HasDocument,

	        CASE 
            WHEN @TaxID = 1 THEN 
                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
            WHEN @TaxID = 2 THEN 
                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountExcludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
            ELSE 
                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
        END AS [GrossRate],

		-- GrossRate for Adult (CommissionMasterID = 7)
--CASE 
--    WHEN CRC.CommissionMasterID = 7 THEN 
--        CASE 
--            WHEN @TaxID = 1 THEN 
--                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
--            WHEN @TaxID = 2 THEN 
--                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountExcludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
--            ELSE 
--                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
--        END
--    ELSE NULL
--END AS [GrossRateAdult],

---- GrossRate for Child (CommissionMasterID = 8)
--CASE 
--    WHEN CRC.CommissionMasterID = 8 THEN 
--        CASE 
--            WHEN @TaxID = 1 THEN 
--                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
--            WHEN @TaxID = 2 THEN 
--                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountExcludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
--            ELSE 
--                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
--        END
--    ELSE NULL
--END AS [GrossRateChild],


--        --CASE 
--        --    WHEN @TaxID = 1 THEN 
--        --        CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
--        --    WHEN @TaxID = 2 THEN 
--        --        CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountExcludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
--        --    ELSE 
--        --        CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
--        --END AS [SellingRate],
		CRC.TaxPercentage, 
        CRC.TaxAmount, 
		CRC.NetAmountExcludingTax, 
		CRC.NetAmountIncludingTax,
<<<<<<< HEAD
<<<<<<< HEAD
		  CRC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(Cu.Code, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
		   CRC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(Cu.Code, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con,
=======
		  CRC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(MRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
		   CRC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(MRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con,
>>>>>>> dev
=======
		  CRC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(MRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
		   CRC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(MRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		MRM.CreatedOn,
	
MRM.InfoForOperation,
MRM.InfoForRemark

    FROM RateCards.MonumentRateMaster MRM
    INNER JOIN RateCards.MonumentRateDetails MRD 
        ON MRD.MonumentRateID = MRM.MonumentRateID
    INNER JOIN Nationality N 
        ON N.ID = MRD.NationalityID 
    LEFT JOIN RateCards.MonumentRateCommissionDetails CRC 
        ON CRC.MonumentDetailID = MRD.MonumentDetailID
    LEFT JOIN City CT 
        ON CT.IATACode = MRM.CityID
    LEFT JOIN VendorMaster VM 
        ON VM.VendorID = MRM.VendorID
    LEFT JOIN MonumentService MS 
        ON MS.ID = MRM.MonumentServiceID
<<<<<<< HEAD
<<<<<<< HEAD
    LEFT JOIN Currency Cu 
        ON Cu.Code = MRM.CurrencyID 
    LEFT JOIN RateCommissionMaster RCM 
        ON RCM.CommMasterID = CRC.CommissionMasterID

    WHERE 
        (MRM.MonumentServiceID = @Service)
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    LEFT JOIN CurrencyMaster Cu 
        ON Cu.CurrencyCode = MRM.CurrencyID 
    LEFT JOIN RateCommissionMaster RCM 
        ON RCM.CommMasterID = CRC.CommissionMasterID

    WHERE (MRM.MonumentRateID =@MonumentRateID and Isnull(@MonumentRateID,0)<>0) Or

       ( (Isnull(@MonumentRateID,0)=0) and
	   (@Service IS NULL OR @Service = 0 OR MRM.MonumentServiceID = @Service)
	   
	   --(MRM.MonumentServiceID = @Service)
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        --AND (@RateCardModeTypeID IS NULL OR MRM.RateCardModeTypeID = @RateCardModeTypeID)
	--	AND (
 --   NOT EXISTS (SELECT 1 FROM @RateCardModeTable) 
 --   OR MRM.RateCardModeTypeID IN (SELECT ModeID FROM @RateCardModeTable)
	--)

        AND (MRM.CityID = @CityIata) 
        --AND (MRM.VendorID = @Vendor OR @Vendor IS NULL)
		AND (MRM.VendorID = @Vendor OR isnull(@Vendor,0)=0)
      AND (MRD.NationalityID = @NationalityID OR @NationalityID IS NULL OR @NationalityID = 0)

        --AND MRD.ValidFrom >=  @ValidFrom 
        --AND (MRD.ValidTo <= @ValidTo OR @ValidTo IS NULL )
        --AND (MRD.TaxID = @TaxID OR @TaxID IS NULL)

		AND MRD.ValidFrom <= @ValidTo AND MRD.ValidTo >= @ValidFrom
		AND (
    (@Child > 0 AND CRC.CommissionMasterID = 8)
    OR (@Adult > 0 AND CRC.CommissionMasterID = 7)
    OR ((@Child IS NULL OR @Child = 0) AND (@Adult IS NULL OR @Adult = 0))
)

		 AND MRM.RateCardModeTypeID IN (SELECT ModeID FROM @RateCardModeTable)


        AND MRM.IsActive = 1
        AND MRD.IsActive = 1
<<<<<<< HEAD
<<<<<<< HEAD

=======
				   AND( (( MRM.BookingID=@BookingID and MRM.RateCardModeTypeID=3) or(MRM.BookingID is null and MRM.RateCardModeTypeID in (1,2,3,4))) or (@BookingID is null) or (@BookingID =0 ))
			)	   
>>>>>>> dev
=======
				   AND( (( MRM.BookingID=@BookingID and MRM.RateCardModeTypeID=3) or(MRM.BookingID is null and MRM.RateCardModeTypeID in (1,2,3,4))) or (@BookingID is null) or (@BookingID =0 ))
			)	   
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    --ORDER BY 
    --    CT.Name, MS.Name, MRD.ValidFrom;

	UNION
	SELECT
		CHRM.HotelRateID as MonumentRateID,
		'CustomRateCard' as Type,
		0 as MonumentDetailID,
		RC.RateCommisionID as MonumentCommissionDetailID,
		CT.Name AS City,
		VM.VendorName,
		MS.Name AS MonumentService, 
		isnull(N.Nationality,'') as Nationality, 
		'' AS ValidFrom, 
        '' AS ValidTo,
		'' AS RateCardModeType,
		0 as RateCardModeTypeID,
		0 as TaxID,
		'' as CardNumber,
		'' as Heading,
		'' as ContractDate,
		CHRM.CurrencyID,
		0 as StateID,
		CHRM.VendorID,
		'' as InfoForOperation,
		'' as InfoForAgent,
		'' as InfoForRemark,
		CHRM.IsActive,
	
		CHRM.UpdatedOn,
		'' as GSTStatus,
		--0 as RateCardModeTypeID,
		
		CHRM.CityID,
		'' as ClosedOn,
		0 as MonumentServiceID,
		CHRM.NationalityId,
		0 as MISSequence,
		RCM.RateType,
		0 as CommissionMasterID,


		RC.NetAmountExcludingTax, 
		RC.NetAmountIncludingTax,
		0 AS HasRules,
		0 AS HasDocument,
		CASE 
            WHEN @TaxID = 1 THEN 
                CAST(CAST(dbo.fnSearchCalculateROE(RC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
            WHEN @TaxID = 2 THEN 
                CAST(CAST(dbo.fnSearchCalculateROE(RC.NetAmountExcludingTax, @ValidFrom, @DisplayRate, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
            ELSE 
                CAST(CAST(dbo.fnSearchCalculateROE(RC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, CHRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
        END AS [GrossRate],
		--NULL AS [GrossRateAdult],

		---- GrossRate for Child (CommissionMasterID = 8)
		--NULL AS [GrossRateChild],




		RC.TaxPercentage, 
        RC.TaxAmount, 
		RC.NetAmountExcludingTax, 
		RC.NetAmountIncludingTax,
		RC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
		   RC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(CHRM.CurrencyID, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con,
		CHRM.CreatedOn,
		'' as InfoForOperation,
'' as InfoForRemark
	FROM
		CustomRateCards.HotelRateMaster CHRM WITH (NOLOCK)
		LEFT OUTER JOIN [CustomRateCards].[HotelRateCommisionDetails] RC WITH (NOLOCK) ON RC.HotelRateID = CHRM.HotelRateId
		LEFT OUTER JOIN Nationality N WITH (NOLOCK) ON N.ID = CHRM.NationalityID 
		LEFT OUTER JOIN City CT WITH (NOLOCK) ON CT.IATACode = CHRM.CityID
		LEFT JOIN VendorMaster VM WITH (NOLOCK)  ON VM.VendorID = CHRM.VendorID
		LEFT JOIN RateCommissionMaster RCM 
        WITH (NOLOCK)  ON  RCM.CommMasterID = RC.CommissionMasterID
		LEFT JOIN MonumentService MS 
        ON MS.ID = CHRM.ServiceID
	WHERE
		CHRM.RateType=2
        AND CHRM.IsActive = 1
		AND CHRM.QuotationID=@QuotationID
		AND (CHRM.VendorID = @Vendor OR isnull(@Vendor,0)=0)
		AND
		(
			(@ValidFrom IS NOT NULL AND @ValidTo IS NOT NULL AND CAST(CHRM.CheckIn AS DATE) <= CAST(@ValidTo AS DATE) AND CAST(CHRM.CheckOut AS DATE) >= CAST(@ValidFrom AS DATE))
			OR
			(@ValidFrom IS NOT NULL AND @ValidTo IS NULL AND CAST(CHRM.CheckOut AS DATE) >= CAST(@ValidFrom AS DATE))
			OR
			(@ValidFrom IS NULL AND @ValidTo IS NOT NULL AND CAST(CHRM.CheckIn AS DATE) <= CAST(@ValidTo AS DATE))
			OR
			(@ValidFrom IS NULL AND @ValidTo IS NULL)
		)
	--ORDER BY CreatedOn DESC
	ORDER BY City,MonumentService,ValidFrom


    SET NOCOUNT OFF;

	SET @ReturnCode = '409'; -- Conflict
            SET @ReturnMessage = 'Data already exists';
            SET @LogID = 0;

            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID AS ID;
            RETURN;
END