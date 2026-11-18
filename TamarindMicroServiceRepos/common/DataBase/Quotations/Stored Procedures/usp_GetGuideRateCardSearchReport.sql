



 ---Including     --exec [RateCards].[usp_GetGuideRateCardSearchReport] 'INR','Adhoc', 'Inclusive', 'DEL',7,2957,'HI',3,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000'
 ----exec [RateCards].[usp_GetGuideRateCardSearchReport] 'USD','Adhoc,Contract', 'Inclusive', 'DEL',7,0,'',3,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000'
  ----exec [RateCards].[usp_GetGuideRateCardSearchReport] 'INR','Adhoc', 'Inclusive', 'DEL',7,2957,'HI',3,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000'
-- Excluding Tax  --exec [usp_GetGuideRateCardSearchReport] 'INR','1', '2',  'BOM',207,2956,'EN',7,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000' 

---exec [usp_GetGuideRateCardSearchReport] 'INR','Contract', 'Exclusive',  'BOM',207,2956,'EN',7,'2025-05-01 00:00:00.000','2025-05-30 00:00:00.000'

CREATE PROCEDURE [Quotations].[usp_GetGuideRateCardSearchReport]
(
@ID  INT         = NULL
    --@DisplayRate           VARCHAR(5)  = NULL,   --- Available
    --@RateCardModeType    Varchar(50)         = NULL,   --- Available
    --@TaxID                 INT        = NULL,
    --@CityIata              CHAR(3)     = NULL,   --- Available
    --@Service               INT         = NULL,   --- Available
    --@Vendor                INT         = NULL,   --- Available
    --@Language              CHAR(2)     = NULL,
    --@NoofPax               INT         = NULL,
    --@ValidFrom             DATETIME    = NULL,
    --@ValidTo               DATETIME    = NULL
)
AS
BEGIN
    SET NOCOUNT ON;  






    SELECT 
		GRM.ID,
		--GRD.GuideRateDetailID,
		GRC.ID as GuideRateCommissionID,
		GRM.ServiceID,
		GRM.CardNumber,
		GRM.Heading,
		GRM.ContractDate,
		GRM.CityID,
		GRM.VendorID ,
		GRM.CurrencyID,
		GRM.LanguageID,
        CT.Name AS City,
        GS.Name AS GuideService,
        VM.VendorName AS Vendor,
		GRM.InfoForOperation,
		GRM.InfoForAgent,
		GRM.InfoForRemark,
		GRM.IsActive,
		GRM.CreatedOn,
	--	GRM.CreatedBy,
		GRM.UpdatedOn,
	--	GRM.UpdatedBy,
		GRM.Notes,
		GRM.StateID,
		GRM.VendorID,
        L.Language,
        CONCAT(GRC.MinimumPax, ' - ', GRC.MaximumPax) AS PaxRange,
        GRM.ValidFrom,
        GRM.ValidTo,
		GRC.MinimumPax,
		GRC.MaximumPax,
		GRM.MISSequence,
        GRM.CurrencyID,
        CASE GRM.RateCardModeTypeID 
            WHEN 1 THEN 'Contract' 
            WHEN 2 THEN 'Adhoc' 
            WHEN 3 THEN 'Negotiated' 
        END AS RateCardType,
        GRM.RateCardModeTypeID,
   
	 GRC.GrossRate,
       GRC.SellingRates,
		 GRC.TaxPercentage,
         GRC.TaxAmount,
         GRC.NetAmountIncludingTax,
         GRC.NetAmountExcludingTax
    FROM Quotation.OthersRateCardMaster GRM
   
   
    LEFT JOIN Quotation.OthersRateCardCommission GRC  ON GRC.OthersRateRefrenceID = GRM.ID
	 LEFT JOIN [Language] L ON L.ID = GRM.LanguageID
    LEFT JOIN City CT  ON CT.IATACode = GRM.CityID
    LEFT JOIN VendorMaster VM  ON VM.VendorID = GRM.VendorID
    LEFT JOIN GuideServices GS ON GS.Code = GRM.ServiceID
    LEFT JOIN Currency C ON C.Code = GRM.CurrencyID

    WHERE 
	GRM.ID=@ID
  --      (GRM.ServiceID = @Service)
  -- -- NOT EXISTS (SELECT 1 FROM @RateCardModeTable) 
  --      AND GRM.RateCardModeTypeID IN (SELECT ModeID FROM @RateCardModeTable)

  --      AND (GRM.CityID = @CityIata)
  --      AND GRM.VendorID = COALESCE(NULLIF(@Vendor, 0), GRM.VendorID)
		--AND GRM.LanguageID = COALESCE(NULLIF(@Language, ''), GRM.LanguageID)
  --   --   AND (GRD.TaxID = @TaxID OR @TaxID IS NULL)
  --      AND GRD.ValidFrom >= @ValidFrom
  --      AND (GRD.ValidTo <= @ValidTo OR @ValidTo IS NULL) 
  --      AND GRM.IsActive = 1
  --      AND GRD.IsActive = 1
		--AND (
		--	NULLIF(@NoofPax, '') IS NULL
		--	OR @NoofPax BETWEEN GRC.PaxMinimum AND GRC.PaxMaximum
		--)
   

    SET NOCOUNT OFF;
END
