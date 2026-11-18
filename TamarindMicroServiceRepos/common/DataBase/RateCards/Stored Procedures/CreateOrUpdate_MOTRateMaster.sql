

ALTER PROCEDURE [RateCards].[CreateOrUpdate_MOTRateMaster]
(
 @Operation               VARCHAR(50)      = 'INSERT',
    @ID                      INT              = 0,
    @ContractDate            DATETIME         = '2025-09-02',
    @ValidFrom               DATETIME         = '2025-09-05',
    @ValidTo                 DATETIME         = '2025-12-31',
    @FromDate                 DATETIME        = '2025-09-05',
    @ToDate                   DATETIME        = '2025-09-20',
    @ContractHeading          NVARCHAR(400)   = N'Dummy Corporate Contract',
    @TravelModeTypeID         INT             = 1,
    @MOTNameORNumber          NVARCHAR(200)   = N'MH-14-AB-1234',
    @Sector                   NVARCHAR(400)   = N'Mumbai–Pune Expressway',
    @RateCardModeTypeID       INT             = 2,
    @InformationToOperations  NVARCHAR(MAX)   = N'Ops team must coordinate with vendor',
    @XORemarks                NVARCHAR(MAX)   = N'Test entry created on dev system',
    @VendorID                 INT             = 101,
    @CurrencyCode             NVARCHAR(20)    = N'INR',
    @IsActive                 BIT             = 1,  -- NOT NULL
    @CompanyID                INT             = 9,
    @YearID                   INT             = 4,
	@CreatedBy uniqueidentifier = 'FEECEB69-C92C-41A9-98DE-FA86FCC009E9',
@ModifiedBy uniqueidentifier = 'FEECEB69-C92C-41A9-98DE-FA86FCC009E9',
@BookingID int =0,
@MOTRateID BIGINT=0 OUTPUT,
@CardNumber VARCHAR(30)='' OUTPUT
)
AS
BEGIN
	IF @Operation = 'INSERT'
	BEGIN
		DECLARE @CardNoMax VARCHAR(10),@CurrentMonthPrefix VARCHAR(6)
		-- Generate current month prefix (YYMM)
		SET @CurrentMonthPrefix = SUBSTRING(CONVERT(VARCHAR, DATEPART(yy, GETDATE())), 3, 2) +
                          RIGHT('0' + CONVERT(VARCHAR, DATEPART(mm, GETDATE())), 2)

		-- Get the max CardNo for the current month
		SET @CardNoMax = (SELECT MAX(CAST(SUBSTRING(RateCardNo, 6, 6) AS INT)) 
        FROM [RateCards].MOTRateMaster WHERE SUBSTRING(RateCardNo, 2, 4) = @CurrentMonthPrefix)

		-- If no records exist for the current month, start from 1
		SET @CardNoMax = CASE WHEN @CardNoMax IS NULL THEN '1' ELSE CAST(@CardNoMax AS INT) + 1 END
		-- Generate the new CardNo
		SET @CardNumber = 'MOT' + @CurrentMonthPrefix + RIGHT('000000' + CAST(@CardNoMax AS VARCHAR), 6)

		--INSERT INTO [RateCards].MOTRateMaster(CardNumber,Heading,ContractDate,RateCardModeTypeID,CurrencyID,VendorID,
		--TravelModeTypeID,CityID,NameORNumber,LocationFrom,LocationTo,DepartureTime,ArrivalTime,Sectors,InfoForOperation,InfoForAgent,
		--InfoForRemark,Notes,CreatedBy,IsActive,CreatedOn)
		--VALUES(@CardNumber,@Heading,@ContractDate,@RateCardModeTypeID,@CurrencyID,@VendorID,@TravelModeTypeID,@CityID,@NameORNumber,@LocationFrom,
		--@LocationTo,@DepartureTime,@ArrivalTime,@Sectors,@InfoForOperation,@InfoForAgent,@InfoForRemark,@Notes,@CreatedBy,@IsActive,GETDATE())


INSERT INTO [RateCards].MOTRateMaster
(
    RateCardNo,
    ContractDate,
    ValidFrom,
    ValidTo,
    FromDate,
    ToDate,
    ContractHeading,
    TravelModeTypeID,
    MOTNameORNumber,
    Sector,
    RateCardModeTypeID,
    InformationToOperations,
    XORemarks,
    VendorID,
    CurrencyCode,
    IsActive,
    CompanyID,
    YearID,
    CreatedBy,
    CreatedOn
)
VALUES
(
    @CardNumber,
    @ContractDate,
    @ValidFrom,
    @ValidTo,
    @FromDate,
    @ToDate,
    @ContractHeading,
    @TravelModeTypeID,
    @MOTNameORNumber,
    @Sector,
    @RateCardModeTypeID,
    @InformationToOperations,
    @XORemarks,
    @VendorID,
    @CurrencyCode,
    @IsActive,
    @CompanyID,
    @YearID,
    @CreatedBy,
    GETDATE()
);
		SET @MOTRateID = @@IDENTITY
	END
	IF @Operation = 'UPDATE' AND @ID > 0
	BEGIN
	UPDATE [RateCards].MOTRateMaster
SET
    ContractDate             = ISNULL(@ContractDate, ContractDate),
    ValidFrom                = ISNULL(@ValidFrom, ValidFrom),
    ValidTo                  = ISNULL(@ValidTo, ValidTo),
    FromDate                 = ISNULL(@FromDate, FromDate),
    ToDate                   = ISNULL(@ToDate, ToDate),
    ContractHeading          = ISNULL(@ContractHeading, ContractHeading),
    TravelModeTypeID         = ISNULL(@TravelModeTypeID, TravelModeTypeID),
    MOTNameORNumber          = ISNULL(@MOTNameORNumber, MOTNameORNumber),
    Sector                   = ISNULL(@Sector, Sector),
    RateCardModeTypeID       = ISNULL(@RateCardModeTypeID, RateCardModeTypeID),
    InformationToOperations  = ISNULL(@InformationToOperations, InformationToOperations),
    XORemarks                = ISNULL(@XORemarks, XORemarks),
    VendorID                 = ISNULL(@VendorID, VendorID),
    CurrencyCode             = ISNULL(@CurrencyCode, CurrencyCode),
    IsActive                 = ISNULL(@IsActive, IsActive),
    CompanyID                = ISNULL(@CompanyID, CompanyID),
    YearID                   = ISNULL(@YearID, YearID),
    ModifiedBy                = ISNULL(@ModifiedBy, ModifiedBy),
    ModifiedOn                = GETDATE()
WHERE ID = @ID;
		SET @MOTRateID = @ID
		SET @CardNumber = (SELECT RateCardNo FROM [RateCards].MOTRateMaster WHERE ID = @MOTRateID )
	END
END