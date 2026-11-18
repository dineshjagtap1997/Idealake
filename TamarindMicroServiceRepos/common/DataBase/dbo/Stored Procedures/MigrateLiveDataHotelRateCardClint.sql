 
CREATE PROCEDURE MigrateLiveDataHotelRateCardClint
@Action VARCHAR(1) 	 
AS
BEGIN
 



 

 if @Action = 'S'
 BEGIN 



--drop table #HotelRateDetail

CREATE TABLE #HotelRateDetail (
    HotelRateDetailID INT,
    HotelRateID INT,
    SGL INT,
    DBL INT,
    AdultExtra INT,
    ChildExtra INT,
    Breakfast INT,
    Lunch INT,
    Dinner INT,
    SLGTAXPercent INT,
    DBLTAXPercent INT,
    EBATaxPercent INT,
    EBCTaxPercent INT,
    BfstTaxPercent INT,
    LunTaxPercent INT,
    DinTaxPercent INT,
	RateValidFrom DATETIME,
	RateValidTo  DATETIME
);


--SELECT * FROM #HotelRateDetail

INSERT INTO #HotelRateDetail
SELECT HRD.HotelRateDetailID, RLV.HotelRateID, SGL, DBL, AdultExtra, ChildExtra, Breakfast, Lunch, Dinner, 
      [SLGTAX%] AS SLGTAXPercent , [DBLTAX%] AS DBLTAXPercent , [EBATAX%] AS EBATaxPercent,
	  [EBCTAX%] AS  EBCTaxPercent, [BfstTax%]  AS  BfstTaxPercent,[LunTax%] as LunTaxPercent,[DinTax%] as   DinTaxPercent,
	  RLV.RateValidFrom ,RLV.RateValidTo 
	FROM RateCards.HotelRateDetails HRD INNER JOIN   RateCardMigratedLive RLV ON 
                HRD.OldHotelRateDetailsID = RLV.HotelRateDetailsID  



--Select DISTINCT HRD.HotelRateDetailID, RCL.RoomCategoryID  , RCL.HotelRateID, SGL, DBL, SGL, DBL, AdultExtra, ChildExtra, Breakfast,
--Lunch, Dinner, [SLGTAX%], [DBLTAX%], [EBATax%], [EBCTax%], [BfstTax%], [LunTax%], [DinTax%]    
--FROM RateCardMigratedLive RCL INNER JOIN RateCards.HotelRateDetails HRD  ON RCL.HotelRateID = HRD.HotelRateID
--AND RCL.RoomCategoryID = HRD.RoomCategoryID
--where HRD.HotelRateID = '438770'


--SELECT  RCL.RoomCategoryID  , RCL.HotelRateID, SGL, DBL, SGL, DBL, AdultExtra, ChildExtra, Breakfast,
--Lunch, Dinner, [SLGTAX%], [DBLTAX%], [EBATax%], [EBCTax%], [BfstTax%], [LunTax%], [DinTax%] FROM RateCardMigratedLive RCL where HotelRateID = '438770'   AND RoomCategoryID = 213

--SELECT * FROM RateCards.HotelRateDetails where HotelRateID = '438770' AND RoomCategoryID = 213


--SELECT * FROM RateCards.HotelRateDetails
--SELECT * FROM RateCardMigratedLive where HotelRateID = '438770'



DECLARE @HotelRateDetailID INT,
        @SGL INT,
        @DBL INT,
        @AdultExtra INT,
        @ChildExtra INT,
        @Breakfast INT,
        @Lunch INT,
        @Dinner INT,
        @SLGTAXPercent INT,
        @DBLTAXPercent INT,
        @EBATaxPercent INT,
        @EBCTaxPercent INT,
        @BfstTaxPercent INT,
        @LunTaxPercent INT,
        @DinTaxPercent INT;

DECLARE @CommissionMasterID INT,
        @NetAmountExcludingTax INT,
        @TaxPercent INT;   
		
--DECLARE @RateValidFrom DateTime,
--		@RateValidTo DateTime




--DECLARE ValidityCursor CURSOR FOR
--SELECT HotelRateDetailID, RateValidFrom, RateValidTo
--FROM #HotelRateDetail
 

--OPEN ValidityCursor;

--FETCH NEXT FROM ValidityCursor INTO @HotelRateDetailID, @RateValidFrom, @RateValidTo;

--WHILE @@FETCH_STATUS = 0
--BEGIN
--    INSERT INTO [RateCards].[RateValidityMaster]
--       ([BookFrom], [BookTo], [RateValidFrom], [RateValidTo], [HotelRateDetailID], [CreatedOn], [IsActive])
--    VALUES
--       ( NULL,
--	     NULL,
--        @RateValidFrom,
--        @RateValidTo,
--        @HotelRateDetailID,
--        GETDATE(),
--        1);

--    FETCH NEXT FROM ValidityCursor INTO @HotelRateDetailID, @RateValidFrom, @RateValidTo; 
--END

--CLOSE ValidityCursor;
--DEALLOCATE ValidityCursor;  






DECLARE HotelRateCursor CURSOR FOR
SELECT HRD.HotelRateDetailID,  SGL, DBL, AdultExtra, ChildExtra, Breakfast, Lunch, Dinner, 
      [SLGTAX%] AS SLGTAXPercent , [DBLTAX%] AS DBLTAXPercent , [EBATAX%] AS EBATaxPercent,
	  [EBCTAX%] AS  EBCTaxPercent, [BfstTax%]  AS  BfstTaxPercent,[LunTax%] as LunTaxPercent,[DinTax%] as   DinTaxPercent
	FROM RateCards.HotelRateDetails HRD INNER JOIN   RateCardMigratedLive RLV ON 
                HRD.OldHotelRateDetailsID = RLV.HotelRateDetailsID 


OPEN HotelRateCursor;

FETCH NEXT FROM HotelRateCursor INTO
    @HotelRateDetailID, @SGL, @DBL, @AdultExtra, @ChildExtra, @Breakfast, @Lunch, @Dinner,
    @SLGTAXPercent, @DBLTAXPercent, @EBATaxPercent, @EBCTaxPercent, @BfstTaxPercent, @LunTaxPercent, @DinTaxPercent;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- CommissionMasterID 1: SGL + SLGTAX%
    SET @CommissionMasterID = 1;
    SET @NetAmountExcludingTax = @SGL;
    SET @TaxPercent = @SLGTAXPercent;
    INSERT INTO [RateCards].[RateCommisionDetails]
        ([CommissionMasterID], [TaxPercentage], [NetAmountExcludingTax], [HotelRateDetailID], [IsTax], [CreatedOn])
    VALUES
        (@CommissionMasterID, ISNULL(@TaxPercent,0), @NetAmountExcludingTax, @HotelRateDetailID, 1, GETDATE());

    -- CommissionMasterID 2: DBL + DBLTAX%
    SET @CommissionMasterID = 2;
    SET @NetAmountExcludingTax = @DBL;
    SET @TaxPercent = @DBLTAXPercent;
    INSERT INTO [RateCards].[RateCommisionDetails]
       ([CommissionMasterID], [TaxPercentage], [NetAmountExcludingTax], [HotelRateDetailID], [IsTax], [CreatedOn])
    VALUES
        (@CommissionMasterID, ISNULL(@TaxPercent,0), @NetAmountExcludingTax, @HotelRateDetailID, 1, GETDATE());

    -- CommissionMasterID 3: AdultExtra + EBATax%
    SET @CommissionMasterID = 3;
    SET @NetAmountExcludingTax = @AdultExtra;
    SET @TaxPercent = @EBATaxPercent;
    INSERT INTO [RateCards].[RateCommisionDetails]
       ([CommissionMasterID], [TaxPercentage], [NetAmountExcludingTax], [HotelRateDetailID], [IsTax], [CreatedOn])
    VALUES
        (@CommissionMasterID, ISNULL(@TaxPercent,0),  @NetAmountExcludingTax, @HotelRateDetailID, 1, GETDATE());

    -- CommissionMasterID 4: Breakfast + BfstTax%
    SET @CommissionMasterID = 4;
    SET @NetAmountExcludingTax = @Breakfast;
    SET @TaxPercent = @BfstTaxPercent;
  --  INSERT INTO [RateCards].[RateCommisionDetails]
       --([CommissionMasterID], [TaxPercentage], [NetAmountExcludingTax], [HotelRateDetailID], [IsTax], [CreatedOn])
       INSERT INTO [RateCards].[HotelMealOverviewMaster]
           ([HotelRateDetailID],[MealTypeID],[GstPercentage],[NetAmountExcludingTax],[MasterCommissionID])
    VALUES
           (@HotelRateDetailID,  0, ISNULL(@TaxPercent,0),@NetAmountExcludingTax, @CommissionMasterID);

    -- CommissionMasterID 5: Lunch + LunTax%
    SET @CommissionMasterID = 5;
    SET @NetAmountExcludingTax = @Lunch;
    SET @TaxPercent = @LunTaxPercent;
  --  INSERT INTO [RateCards].[RateCommisionDetails]
       --([CommissionMasterID], [TaxPercentage], [NetAmountExcludingTax], [HotelRateDetailID], [IsTax], [CreatedOn])
        INSERT INTO [RateCards].[HotelMealOverviewMaster]
           ([HotelRateDetailID],[MealTypeID],[GstPercentage],[NetAmountExcludingTax],[MasterCommissionID])
    VALUES
        (@HotelRateDetailID,  0, ISNULL(@TaxPercent,0),@NetAmountExcludingTax, @CommissionMasterID);

    -- CommissionMasterID 6: Dinner + DinTax%
    SET @CommissionMasterID = 6;
    SET @NetAmountExcludingTax = @Dinner;
    SET @TaxPercent = @DinTaxPercent;
  --  INSERT INTO [RateCards].[RateCommisionDetails]
       --([CommissionMasterID], [TaxPercentage], [NetAmountExcludingTax], [HotelRateDetailID], [IsTax], [CreatedOn])
  --  VALUES
  --      (@CommissionMasterID, ISNULL(@TaxPercent,0),  @NetAmountExcludingTax, @HotelRateDetailID, 1, GETDATE());
        INSERT INTO [RateCards].[HotelMealOverviewMaster]
           ([HotelRateDetailID],[MealTypeID],[GstPercentage],[NetAmountExcludingTax],[MasterCommissionID])
        VALUES
            (@HotelRateDetailID,  0, ISNULL(@TaxPercent,0),@NetAmountExcludingTax, @CommissionMasterID);

  --  -- CommissionMasterID 7: AdultExtra (no tax)
  --  SET @CommissionMasterID = 7;
  --  SET @NetAmountExcludingTax = @AdultExtra;
  --  SET @TaxPercent = NULL;
  --  INSERT INTO [RateCards].[RateCommisionDetails]
       --([CommissionMasterID], [TaxPercentage], [NetAmountExcludingTax], [HotelRateDetailID], [IsTax], [CreatedOn])
  --  VALUES
  --      (@CommissionMasterID, ISNULL(@TaxPercent,0), @NetAmountExcludingTax, @HotelRateDetailID, 1, GETDATE());

  --  -- CommissionMasterID 8: ChildExtra (no tax)
  --  SET @CommissionMasterID = 8;
  --  SET @NetAmountExcludingTax = @ChildExtra;
  --  SET @TaxPercent = NULL;
  --  INSERT INTO [RateCards].[RateCommisionDetails]
       --([CommissionMasterID], [TaxPercentage], [NetAmountExcludingTax], [HotelRateDetailID], [IsTax], [CreatedOn])
  --  VALUES
  --      (@CommissionMasterID, ISNULL(@TaxPercent,0),  @NetAmountExcludingTax, @HotelRateDetailID, 1, GETDATE());

    -- CommissionMasterID 23: Dinner + EBCTax%
    SET @CommissionMasterID = 23;
    SET @NetAmountExcludingTax = @ChildExtra;
    SET @TaxPercent = @EBCTaxPercent;
    INSERT INTO [RateCards].[RateCommisionDetails]
       ([CommissionMasterID], [TaxPercentage], [NetAmountExcludingTax], [HotelRateDetailID], [IsTax], [CreatedOn])
    VALUES
        (@CommissionMasterID, ISNULL(@TaxPercent,0),  @NetAmountExcludingTax, @HotelRateDetailID, 1, GETDATE());

    FETCH NEXT FROM HotelRateCursor INTO
        @HotelRateDetailID, @SGL, @DBL, @AdultExtra, @ChildExtra, @Breakfast, @Lunch, @Dinner,
        @SLGTAXPercent, @DBLTAXPercent, @EBATaxPercent, @EBCTaxPercent, @BfstTaxPercent, @LunTaxPercent, @DinTaxPercent;
END

CLOSE HotelRateCursor;
DEALLOCATE HotelRateCursor;




END

END
