create PROCEDURE [XO].[USP_InsertOrUpdate_XOInstructions_bkp]
    @XO_InstructionID INT,
    @File_ID NVARCHAR(50),
    @Customer_Name VARCHAR(200),
    @Supplier_Name VARCHAR(50),
    @XO_ID NVARCHAR(50),
    @Qut_ID NUMERIC(33, 0),
    @Forign_Exchange VARCHAR(3) = NULL,
    @Meals_Menu_Basis VARCHAR(3) = NULL,
    @XO_Line_Desc VARCHAR(100) = NULL,
    @XO_Instruction VARCHAR(500) = NULL,
    @Confirmed_By NVARCHAR(100) = NULL,
    @ArrivalDate DATETIME = NULL,
    @DepartureDate DATETIME = NULL,
    @FromCity VARCHAR(100) = NULL,
    @ToCity VARCHAR(100) = NULL,
    @ArrivalBy VARCHAR(100) = NULL,
    @DeptBy VARCHAR(100) = NULL,
    @FromTime VARCHAR(50) = NULL,
    @ToTime VARCHAR(50) = NULL,
    @YearCode INT = NULL,
    @XO_IssuedOn DATETIME = NULL,
    @NoOfPax INT = NULL,
    @Action CHAR(1)  -- 'I' for Insert, 'U' for Update
AS
BEGIN
    SET NOCOUNT ON;
	IF NOT EXISTS(select top 1 XO_ID from dbo.XO where XO_ID= ISNULL(@XO_ID, ''))
 --   --BEGIN
 --   --    --RAISERROR('Please generate XO number before proceeding to XO Instruction.', 16, 1);
 --   --    --SELECT '400' AS returnCode, 'Please generate XO number before proceeding to XO Instruction.' AS returnMessage,0 AS ID;
 --   --END
	--ELSE
	BEGIN
		IF @Action = 'I'
    BEGIN
        INSERT INTO [dbo].[XO_Instructions] (
            XO_InstructionID, File_ID, Customer_Name, Supplier_Name, XO_ID, Qut_ID,
            Forign_Exchange, Meals_Menu_Basis, XO_Line_Desc, XO_Instruction, Confirmed_By,
            ArrivalDate, DepartureDate, FromCity, ToCity, ArrivalBy, DeptBy,
            FromTime, ToTime, YearCode, XO_IssuedOn, NoOfPax
        )
        VALUES (
            @XO_InstructionID, @File_ID, @Customer_Name, @Supplier_Name, @XO_ID, @Qut_ID,
            @Forign_Exchange, @Meals_Menu_Basis, @XO_Line_Desc, @XO_Instruction, @Confirmed_By,
            @ArrivalDate, @DepartureDate, @FromCity, @ToCity, @ArrivalBy, @DeptBy,
            @FromTime, @ToTime, @YearCode, @XO_IssuedOn, @NoOfPax
        );
		SELECT '200' AS returnCode, '' AS returnMessage,0 AS ID;
    END
    ELSE IF @Action = 'U'
    BEGIN
        UPDATE [dbo].[XO_Instructions]
        SET 
            File_ID = @File_ID,
            Customer_Name = @Customer_Name,
            Supplier_Name = @Supplier_Name,
            XO_ID = @XO_ID,
            Qut_ID = @Qut_ID,
            Forign_Exchange = @Forign_Exchange,
            Meals_Menu_Basis = @Meals_Menu_Basis,
            XO_Line_Desc = @XO_Line_Desc,
            XO_Instruction = @XO_Instruction,
            Confirmed_By = @Confirmed_By,
            ArrivalDate = @ArrivalDate,
            DepartureDate = @DepartureDate,
            FromCity = @FromCity,
            ToCity = @ToCity,
            ArrivalBy = @ArrivalBy,
            DeptBy = @DeptBy,
            FromTime = @FromTime,
            ToTime = @ToTime,
            YearCode = @YearCode,
            XO_IssuedOn = @XO_IssuedOn,
            NoOfPax = @NoOfPax
       WHERE XO_InstructionID = @XO_InstructionID;
		SELECT '200' AS returnCode, '' AS returnMessage,0 AS ID;
    END
	END;
	
END
