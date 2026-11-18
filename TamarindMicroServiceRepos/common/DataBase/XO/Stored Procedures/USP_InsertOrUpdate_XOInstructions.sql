
CREATE PROCEDURE [XO].[USP_InsertOrUpdate_XOInstructions] @XO_InstructionID INT
	,@File_ID NVARCHAR(50)
	,@Customer_Name VARCHAR(200) = NULL
	,@Supplier_Name VARCHAR(50)
	,@XODayWiseID NVARCHAR(500)
	,@XO_ID NVARCHAR(50)
	,@Qut_ID NUMERIC(33, 0)
	,@Forign_Exchange VARCHAR(3) = NULL
	,@Meals_Menu_Basis VARCHAR(3) = NULL
	,@XO_Line_Desc VARCHAR(100) = NULL
	,@XO_Instruction VARCHAR(500) = NULL
	,@Confirmed_By NVARCHAR(100) = NULL
	,@ArrivalDate DATETIME = NULL
	,@DepartureDate DATETIME = NULL
	,@FromCity VARCHAR(100) = NULL
	,@ToCity VARCHAR(100) = NULL
	,@ArrivalBy VARCHAR(100) = NULL
	,@DeptBy VARCHAR(100) = NULL
	,@FromTime VARCHAR(50) = NULL
	,@ToTime VARCHAR(50) = NULL
	,@YearCode INT = NULL
	,@XO_IssuedOn DATETIME = NULL
	,@NoOfPax INT = NULL
	,@Action CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;

	-- Trim XO_ID before checking
	DECLARE @TrimmedXO_ID NVARCHAR(50) = LTRIM(RTRIM(@XO_ID));

	IF NOT EXISTS (
			SELECT TOP 1 XO_ID
			FROM dbo.XO
			WHERE LTRIM(RTRIM(XONumber)) = @TrimmedXO_ID
			)
	BEGIN
		SELECT '400' AS returnCode
			,'Please generate XO number before proceeding to XO Instruction.' AS returnMessage
			,0 AS ID;

		RETURN;
	END

	--IF @Action = 'I'
	--BEGIN
		IF NOT EXISTS (
				SELECT *
				FROM [dbo].[XO_Instructions]
				WHERE XO_ID = @XO_ID
				)
		BEGIN
			--INSERT INTO [dbo].[XO_Instructions] (
			--	XO_InstructionID
			--	,File_ID
			--	,Customer_Name
			--	,Supplier_Name
			--	,XO_ID
			--	,Qut_ID
			--	,Forign_Exchange
			--	,Meals_Menu_Basis
			--	,XO_Line_Desc
			--	,XO_Instruction
			--	,Confirmed_By
			--	,ArrivalDate
			--	,DepartureDate
			--	,FromCity
			--	,ToCity
			--	,ArrivalBy
			--	,DeptBy
			--	,FromTime
			--	,ToTime
			--	,YearCode
			--	,XO_IssuedOn
			--	,NoOfPax
			--	,DayWiseID
			--	,IsActive
			--	)
			--VALUES (
			--	@XO_InstructionID
			--	,@Qut_ID
			--	,@Customer_Name
			--	,@Supplier_Name
			--	,@TrimmedXO_ID
			--	,@Qut_ID
			--	,@Forign_Exchange
			--	,@Meals_Menu_Basis
			--	,@XO_Line_Desc
			--	,@XO_Instruction
			--	,@Confirmed_By
			--	,@ArrivalDate
			--	,@DepartureDate
			--	,@FromCity
			--	,@ToCity
			--	,@ArrivalBy
			--	,@DeptBy
			--	,@FromTime
			--	,@ToTime
			--	,@YearCode
			--	,@XO_IssuedOn
			--	,@NoOfPax
			--	,@XODayWiseID
			--	,1
			--	);
			--	SELECT '200' AS returnCode,'Inserted successfully' AS returnMessage,0 AS ID;
			-- Inserting into XO_Instructions
INSERT INTO [dbo].[XO_Instructions] (
	XO_InstructionID,
	File_ID,
	Customer_Name,
	Supplier_Name,
	XO_ID,
	Qut_ID,
	Forign_Exchange,
	Meals_Menu_Basis,
	XO_Line_Desc,
	XO_Instruction,
	Confirmed_By,
	ArrivalDate,
	DepartureDate,
	FromCity,
	ToCity,
	ArrivalBy,
	DeptBy,
	FromTime,
	ToTime,
	YearCode,
	XO_IssuedOn,
	NoOfPax,
	DayWiseID,
	IsActive
)
VALUES (
	@XO_InstructionID,
	@File_ID,           
	@Customer_Name,
	@Supplier_Name,
	@TrimmedXO_ID,
	@Qut_ID,
	@Forign_Exchange,
	@Meals_Menu_Basis,
	@XO_Line_Desc,
	@XO_Instruction,
	@Confirmed_By,
	@ArrivalDate,
	@DepartureDate,
	@FromCity,
	@ToCity,
	@ArrivalBy,
	@DeptBy,
	@FromTime,
	@ToTime,
	@YearCode,
	@XO_IssuedOn,
	@NoOfPax,           
	@XODayWiseID,
	1
);

SELECT '200' AS returnCode, 'Inserted successfully' AS returnMessage, 0 AS ID,GETDATE() as LastSavedOn;

		END
		ELSE
		BEGIN
			UPDATE [dbo].[XO_Instructions]
			SET File_ID = @File_ID
				,Customer_Name = @Customer_Name
				,Supplier_Name = @Supplier_Name
				,XO_ID = @TrimmedXO_ID
				,Qut_ID = @Qut_ID
				,Forign_Exchange = @Forign_Exchange
				,Meals_Menu_Basis = @Meals_Menu_Basis
				,XO_Line_Desc = @XO_Line_Desc
				,XO_Instruction = @XO_Instruction
				,Confirmed_By = @Confirmed_By
				,ArrivalDate = @ArrivalDate
				,DepartureDate = @DepartureDate
				,FromCity = @FromCity
				,ToCity = @ToCity
				,ArrivalBy = @ArrivalBy
				,DeptBy = @DeptBy
				,FromTime = @FromTime
				,ToTime = @ToTime
				,YearCode = @YearCode
				,XO_IssuedOn = @XO_IssuedOn
				,NoOfPax = @NoOfPax
				,IsActive = 1
			WHERE XO_ID = @XO_ID;
			SELECT '200' AS returnCode,'Updated successfully' AS returnMessage,0 AS ID,GETDATE() as LastSavedOn;
		END

		
	--END
	--ELSE IF @Action = 'U'
	--BEGIN
	--	UPDATE [dbo].[XO_Instructions]
	--	SET File_ID = @File_ID
	--		,Customer_Name = @Customer_Name
	--		,Supplier_Name = @Supplier_Name
	--		,XO_ID = @TrimmedXO_ID
	--		,Qut_ID = @Qut_ID
	--		,Forign_Exchange = @Forign_Exchange
	--		,Meals_Menu_Basis = @Meals_Menu_Basis
	--		,XO_Line_Desc = @XO_Line_Desc
	--		,XO_Instruction = @XO_Instruction
	--		,Confirmed_By = @Confirmed_By
	--		,ArrivalDate = @ArrivalDate
	--		,DepartureDate = @DepartureDate
	--		,FromCity = @FromCity
	--		,ToCity = @ToCity
	--		,ArrivalBy = @ArrivalBy
	--		,DeptBy = @DeptBy
	--		,FromTime = @FromTime
	--		,ToTime = @ToTime
	--		,YearCode = @YearCode
	--		,XO_IssuedOn = @XO_IssuedOn
	--		,NoOfPax = @NoOfPax
	--		,IsActive = 1
	--	WHERE XO_ID = @XO_ID;

	--	SELECT '200' AS returnCode
	--		,'Updated successfully' AS returnMessage
	--		,0 AS ID;
	--END
END


	