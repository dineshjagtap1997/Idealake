ALTER PROCEDURE [RateCards].[usp_GetMOTRateCardSearchReportNew]  
(
    @DisplayRate        VARCHAR(5)  = NULL,
    @RateCardModeTypeID VARCHAR(50) = 3,
    @TaxID              INT			= 1,
    @CityIata           CHAR(3)		= NULL,  
    @Service            INT			= NULL,  
    @Vendor             INT			= NULL,                                                                                                      
    @NationalityID      INT			= NULL,                                                                                                    
    @Adult              INT			= NULL,
    @Child              INT			= NULL,   
    @ValidFrom          DATETIME   = '2025-10-20T00:00:00',                                                      
    @ValidTo            DATETIME   = '2025-10-21T00:00:00'   ,
	@QuotationID        INT        = NULL,
	@BookingID			bigint =518,
	@MOTRateID bigint =null
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


   print @TaxID 


    SELECT 
	    MRM.ID as MOTRateID, 

		'RateCard' as Type,
        MRD.MOTrateDetailID, 
        VM.VendorName,
        CAST(MRD.ValidFrom AS DATE) AS ValidFrom, 
        CAST(MRD.ValidTo AS DATE) AS ValidTo,

        CASE MRM.RateCardModeTypeID 
            WHEN 1 THEN 'Contract' 
            WHEN 2 THEN 'Adhoc' 
            WHEN 3 THEN 'Negotiated' 
        END AS RateCardModeType,
		MRM.RateCardModeTypeID, 
        MRM.RateCardNo, 
		MRM.ContractHeading,
		MRM.ContractDate,
		MRM.CurrencyCode,
		MRM.VendorID,
		MRM.IsActive,
		MRM.ModifiedOn,
		MRD.MISSequence,
		    (
        SELECT 
            CASE 
                WHEN EXISTS (SELECT 1 FROM [RateCards].[Rules] WHERE RateCardID = MRM.ID) 
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
         ON ld.ParentID = MRM.ID 
         AND ud.DocumentID = ld.DocumentID 
         AND ud.ParentTypeID = 2
    ) AS HasDocument,

	       
		MRM.CreatedOn,
		mt.MOT as MOTType,
		ct.Class as ClassType,
		(
					SELECT 
		CRC.MotRateCommissionDetailID AS MOTCommissionDetailID,
					 CASE 
            WHEN @TaxID = 1 THEN 
                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyCode) AS NUMERIC(18,0)) AS VARCHAR(20))  
            WHEN @TaxID = 2 THEN 
                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountExcludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyCode) AS NUMERIC(18,0)) AS VARCHAR(20))  
            ELSE 
                CAST(CAST(dbo.fnSearchCalculateROE(CRC.NetAmountIncludingTax, @ValidFrom, @DisplayRate, MRM.CurrencyCode) AS NUMERIC(18,0)) AS VARCHAR(20)) 
        END AS [GrossRate],
		RCM.RateType,

		CRC.Tax, 
        CRC.TaxAmount, 
		  CRC.NetAmountExcludingTax * dbo.fnGetPurchaseRate(MRM.CurrencyCode, @DisplayRate, GETDATE()) AS NetAmountExcludingTax_Con,
		   CRC.NetAmountIncludingTax * dbo.fnGetPurchaseRate(MRM.CurrencyCode, @DisplayRate, GETDATE()) AS NetAmountIncludingTax_Con,
		   
		CRC.CommissionMasterID,
		CRC.NetAmountExcludingTax, 
		CRC.NetAmountIncludingTax
						FROM 
							RateCards.MOTRateCommissionDetail CRC 
							LEFT JOIN RateCommissionMaster RCM ON CRC.CommissionMasterID = RCM.CommMasterID
						WHERE 
							CRC.MOTRateDetailID=MRD.MOTRateDetailID
							
						FOR JSON PATH
				) AS CommissionJSON


    FROM RateCards.MOTRateMaster MRM
    INNER JOIN RateCards.MOTRateDetail MRD ON MRD.MOTRateID = MRM.ID
    INNER JOIN MOT mt ON mt.ID = MRM.TravelModeTypeID
    INNER JOIN ClassType ct ON ct.ID = MRD.ClassTypeID

	--Inner JOIN  CRC ON CRC.MOTRateDetailID = MRD.MOTRateDetailID
    LEFT JOIN VendorMaster VM 
        ON VM.VendorID = MRM.VendorID
    LEFT JOIN CurrencyMaster Cu 
        ON Cu.CurrencyCode = MRM.CurrencyCode 

    WHERE (MRM.ID =@MOTRateID and Isnull(@MOTRateID,0)<>0) Or

       ( (Isnull(@MOTRateID,0)=0) 
		AND (MRM.VendorID = @Vendor OR isnull(@Vendor,0)=0)

		AND MRD.ValidFrom <= @ValidTo AND MRD.ValidTo >= @ValidFrom
		 AND MRM.RateCardModeTypeID IN (SELECT ModeID FROM @RateCardModeTable)


        AND MRM.IsActive = 1
        AND MRD.IsActive = 1
				   AND( (( MRM.BookingID=@BookingID and MRM.RateCardModeTypeID=3) or(MRM.BookingID is null and MRM.RateCardModeTypeID in (1,2,3,4))) or (@BookingID is null) or (@BookingID =0 ))
			)	   
    --ORDER BY 
    --    CT.Name, MS.Name, MRD.ValidFrom;

	

    SET NOCOUNT OFF;

	SET @ReturnCode = '200'; -- Conflict
            SET @ReturnMessage = 'Data exists';
            SET @LogID = 0;

            SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @LogID AS ID;
            RETURN;
END