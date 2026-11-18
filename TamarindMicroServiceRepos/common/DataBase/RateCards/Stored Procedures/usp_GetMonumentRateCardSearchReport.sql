--exec [usp_GetMonumentRateCardSearchReport] 'INR','1', '1','ZRP',99,0,2,'1','1','2023-03-13 00:00:00.000','2025-12-01 00:00:00.000'
--exec [RateCards].[usp_GetMonumentRateCardSearchReport] 'INR','2', '1','ZRP',159,0,null,null,1,'2025-03-13 00:00:00.000','2025-12-01 00:00:00.000'
--exec [RateCards].[usp_GetMonumentRateCardSearchReport] 'INR','Adhoc', 'Inclusive','ZRP',159,0,2,0,0,'2025-05-01 00:00:00.000','2025-05-05 00:00:00.000'
--exec [RateCards].[usp_GetMonumentRateCardSearchReport_Old] 'INR','Adhoc', 'Inclusive','ZRP',159,0,2,'1',null,'2025-05-01 00:00:00.000','2025-05-05 00:00:00.000'
CREATE PROCEDURE [RateCards].[usp_GetMonumentRateCardSearchReport]  
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
    @ValidTo            DATETIME   = NULL                                                    
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
		MRM.CreatedOn,
--		MRM.UpdatedBy,
		MRM.UpdatedOn,
		MRM.GSTStatus,
        MRM.RateCardModeTypeID,
		RCM.RateType,
        MRM.CityID,
        MS.ClosedOn, 
        MS.ID AS MonumentServiceID, 
        MRD.NationalityID,
		MRD.MISSequence,
		RCM.RateType,
		CRC.CommissionMasterID,
        CRC.TaxPercentage, 
        CRC.TaxAmount, 
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
CASE 
    WHEN CRC.CommissionMasterID = 7 THEN 
        CASE 
            WHEN @TaxID = 1 THEN 
                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
            WHEN @TaxID = 2 THEN 
                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountExcludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
            ELSE 
                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
        END
    ELSE NULL
END AS [GrossRateAdult],

-- GrossRate for Child (CommissionMasterID = 8)
CASE 
    WHEN CRC.CommissionMasterID = 8 THEN 
        CASE 
            WHEN @TaxID = 1 THEN 
                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
            WHEN @TaxID = 2 THEN 
                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountExcludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
            ELSE 
                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
        END
    ELSE NULL
END AS [GrossRateChild],


        --CASE 
        --    WHEN @TaxID = 1 THEN 
        --        CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
        --    WHEN @TaxID = 2 THEN 
        --        CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountExcludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20))  
        --    ELSE 
        --        CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyID) AS NUMERIC(18,0)) AS VARCHAR(20)) 
        --END AS [SellingRate],
		CRC.TaxPercentage, 
        CRC.TaxAmount, 
		CRC.NetAmountExcludingTax, 
		CRC.NetAmountIncludingTax

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
    LEFT JOIN Currency Cu 
        ON Cu.Code = MRM.CurrencyID 
    LEFT JOIN RateCommissionMaster RCM 
        ON RCM.CommMasterID = CRC.CommissionMasterID

    WHERE 
        (MRM.MonumentServiceID = @Service)
        --AND (@RateCardModeTypeID IS NULL OR MRM.RateCardModeTypeID = @RateCardModeTypeID)
	--	AND (
 --   NOT EXISTS (SELECT 1 FROM @RateCardModeTable) 
 --   OR MRM.RateCardModeTypeID IN (SELECT ModeID FROM @RateCardModeTable)
	--)

        AND (MRM.CityID = @CityIata) 
        AND (MRM.VendorID = @Vendor OR @Vendor IS NULL OR @Vendor = 0)

      AND (MRD.NationalityID = @NationalityID OR @NationalityID IS NULL OR @NationalityID = 0)

        AND MRD.ValidFrom >=  @ValidFrom 
        AND (MRD.ValidTo <= @ValidTo OR @ValidTo IS NULL )
        AND (MRD.TaxID = @TaxID OR @TaxID IS NULL)
		AND (
    (@Child > 0 AND CRC.CommissionMasterID = 8)
    OR (@Adult > 0 AND CRC.CommissionMasterID = 7)
    OR ((@Child IS NULL OR @Child = 0) AND (@Adult IS NULL OR @Adult = 0))
)

		 AND MRM.RateCardModeTypeID IN (SELECT ModeID FROM @RateCardModeTable)


        AND MRM.IsActive = 1
        AND MRD.IsActive = 1

    ORDER BY 
        CT.Name, MS.Name, MRD.ValidFrom;

    SET NOCOUNT OFF;

	SET @ReturnCode = '409'; -- Conflict
            SET @ReturnMessage = 'Data already exists';
            SET @LogID = 0;

            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID AS ID;
            RETURN;
END