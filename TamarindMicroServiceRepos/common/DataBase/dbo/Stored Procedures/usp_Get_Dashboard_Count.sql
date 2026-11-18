--declare
--	@Action char(5)='S',
--	@CompanyId int=9,
--	@YearId int=4,
--	@OperationBy uniqueidentifier='FEECEB69-C92C-41A9-98DE-FA86FCC009E9',
--	@DaysCount int=6

CREATE PROCEDURE [dbo].[usp_Get_Dashboard_Count]
	@Action char(5)=null,
	@CompanyId int=null,
	@YearId int=null,
	@OperationBy uniqueidentifier=null,
	@DaysCount int=null
AS
BEGIN
    SET NOCOUNT ON;
	

	DECLARE @Today DATE = CAST(GETDATE() AS DATE)
	DECLARE @NextDays DATE;
	DECLARE @PrevDays DATE;


	
	SELECT
		@NextDays= DATEADD(DAY, @DaysCount, @Today),
		@PrevDays  = DATEADD(DAY, -@DaysCount, @Today)

	IF(@Action='S')
		BEGIN
			
			DECLARE @ResultDashboardStayTransport TABLE (
				StartDate DATE,
				FHE NVARCHAR(100),
				GuestName NVARCHAR(200),
				CityName NVARCHAR(200),
				HotelName NVARCHAR(200),
				Transport NVARCHAR(200),
				FHEName NVARCHAR(200)
			);

			INSERT INTO @ResultDashboardStayTransport (StartDate, FHE, GuestName, CityName, HotelName, Transport,FHEName)
			EXEC [dbo].[usp_GetDashboardStayTransport]
				@Action = @Action,
				@CompanyId = @CompanyId,
				@YearId = @YearId,
				@OperationBy = @OperationBy,
				@DaysCount = @DaysCount,
				@PageNumber  = 0,
				@Row_Count  = 10;

			DECLARE @ResultDashAgentInvoice TABLE (
				BookingID varchar(255),
				FileCode varchar(255),
				AgentName varchar(200),
				CustomerName varchar(255),
				StartDate DATETIME,
				Enddate DATETIME,
				FHE UNIQUEIDENTIFIER
			);

			INSERT INTO @ResultDashAgentInvoice (BookingID, FileCode, AgentName, CustomerName, StartDate, Enddate,FHE)
			EXEC [dbo].[usp_GetDashAgentInvoice]
				@Action = @Action,
				@CompanyId = @CompanyId,
				@YearId = @YearId,
				@OperationBy = @OperationBy,
				@DaysCount = @DaysCount;

			DECLARE @ResultDashCommInvoice TABLE 
			(
				BookingID NVARCHAR(255),
				FileCode NVARCHAR(100),
				XONumber NVARCHAR(100),
				SupplierName NVARCHAR(200),
				CustomerName NVARCHAR(200),
				ArrivalDate DATETIME,
				DepartureDate DATETIME,
				CommType NVARCHAR(100),
				FHE UNIQUEIDENTIFIER
			);

			
			INSERT INTO @ResultDashCommInvoice (
				BookingID, FileCode, XONumber, SupplierName, CustomerName, 
				ArrivalDate, DepartureDate, CommType, FHE
			)
			EXEC [dbo].[usp_GetDashCommInvoice]
				@Action = @Action,
				@CompanyId = @CompanyId,
				@YearId = @YearId,
				@OperationBy = @OperationBy,
				@DaysCount = @DaysCount;


			
			DECLARE @ResultDashPerformaNotConverted TABLE (
				Invoice_Date DATE,
				InvoiceNumber NVARCHAR(100),
				Amount DECIMAL(18, 2),
				FileCode NVARCHAR(100),
				AgentName NVARCHAR(200),
				GuestName NVARCHAR(200),
				StartDate DATE,
				EndDate DATE,
				FHE UNIQUEIDENTIFIER
			);

			
			INSERT INTO @ResultDashPerformaNotConverted (
				Invoice_Date,
				InvoiceNumber,
				Amount,
				FileCode,
				AgentName,
				GuestName,
				StartDate,
				EndDate,
				FHE
			)
			EXEC [dbo].[usp_GetDashPerformaNotConverted]
				@Action = @Action,
				@CompanyId = @CompanyId,
				@YearId = @YearId,
				@OperationBy = @OperationBy,
				@DaysCount = @DaysCount;

			
			SELECT
				(
					SELECT 
						COUNT(*) 
					FROM 
						[Booking].[tbl_Booking] 
					WHERE 
						StartDate >= @Today 
						AND StartDate < @NextDays
						AND Status = 3  
						AND CompanyID=@CompanyId
						AND YearID=@YearId
						AND (FHE in (select * from [dbo].[fn_Get_All_Reporting] (@CompanyID,@OperationBy)))
				)
				AS ToursStartingCount,
				(
					SELECT 
						COUNT(*)
					FROM 
						[Booking].[tbl_Booking] 
					WHERE 
						EndDate >= @Today 
						AND EndDate < @NextDays
						AND Status = 3 
						AND CompanyID=@CompanyId
						AND YearID=@YearId
						AND (FHE in (select * from [dbo].[fn_Get_All_Reporting] (@CompanyID,@OperationBy)))
				)
				AS ToursEndingCount,
				(
					SELECT 
						COUNT(*)
					FROM 
						tbl_Enquiry E
					WHERE 
						E.StatusID IN (1)
						AND CompanyID=@CompanyId
						AND YearID=@YearId
						AND E.CreatedBy=@OperationBy
				)

				AS EnqPendingToAction,
				(
					SELECT 
						COUNT(*)
					FROM 
						tbl_Enquiry E
					WHERE 
						E.StatusID IN (2)
						AND CompanyID=@CompanyId
						AND YearID=@YearId
						AND E.CreatedBy=@OperationBy
				)
				AS EnqQuoted,
				(
					SELECT 
						COUNT(*) 
					FROM 
						AdvancePaySendRequest A
						INNER JOIN dbo.XO XO ON A.XO_ID = XO.XO_ID
						INNER JOIN Booking.tbl_booking B ON B.ID = XO.File_ID
					WHERE 
						B.CompanyID = @CompanyId
						AND A.Request_Date <= @Today
						AND A.Request_Date > @PrevDays
						AND B.YearID = @YearId
						AND B.FHE = @OperationBy
						AND A.AgentPaymentStatus IS NULL
				)
				AS AdvPayReqApprovalPending,
				(
					select 
						COUNT(*) 
					from 
						TBL_Follow_Up_Section f
						INNER JOIN tbl_Enquiry e on f.EnquiryID=e.EQID
					WHERE
						e.CompanyID=@CompanyId
						AND e.YearID=@YearId
						AND f.CreatedBy=@OperationBy
				)
				AS FollowUpsPendingForAction,
				(
					select 
						COUNT(*) 
					from 
						TBL_Follow_Up_Section
					WHERE
						CAST(FollowUpDate AS DATE)=CAST(GETDATE() AS DATE)
				)
				AS FollowUpsForToday,
				(
					SELECT
						COUNT(*)
					FROM
						@ResultDashboardStayTransport
				)
				AS DailyStayTransport,
				(
					SELECT
						COUNT(*)
					FROM
						@ResultDashAgentInvoice
				)
				AS AgentInvoice,
				(
					SELECT
						COUNT(*)
					FROM
						@ResultDashCommInvoice
				)
				AS CommInvoice,
				(
					SELECT
						COUNT(*)
					FROM
						@ResultDashPerformaNotConverted
				)
				AS PerformaNotConverted

		END
	 
END
