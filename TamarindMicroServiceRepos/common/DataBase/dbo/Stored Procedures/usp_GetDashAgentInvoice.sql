--declare
--	@Action CHAR(2) = 'S',
--	@CompanyId INT=9,
--	@YearId INT=4,
--	@OperationBy uniqueidentifier='FEECEB69-C92C-41A9-98DE-FA86FCC009E9',
--	@DaysCount INT=6
create procedure [dbo].[usp_GetDashAgentInvoice]
	@Action CHAR(2) = NULL,
	@CompanyId INT=NULL,
	@YearId INT=NULL,
	@OperationBy uniqueidentifier=NULL,
	@DaysCount INT=NULL
AS
BEGIN
	IF(@Action='S')
		BEGIN
			DECLARE @Today DATE = CAST(GETDATE() AS DATE)
			

			select 
				BookingID,FileCode,AM.AgentName,
				GuestName as CustomerName,
				StartDate,
				Enddate,
				FHE
			from 
				Booking.tbl_Booking B
				LEFT JOIN AgentMaster AM ON B.AgentId = AM.AgentID
			where 
				AgentInvoiceReq=1
				and B.ID NOT IN (Select BookingID from Invoice.Invoice where isnull(bookingid,0)<>0)
				and Status=3
				AND (ISNULL(@CompanyId,0)=0 OR B.CompanyId=@CompanyId)
				AND (ISNULL(@YearId,0)=0 OR B.YearId=@YearId)
				AND (B.FHE in (select * from [dbo].[fn_Get_All_Reporting] (@CompanyID,@OperationBy)))
				--AND CAST(StartDate AS DATE) <= CAST(GETDATE() AS DATE)
				AND (StartDate >= @Today AND StartDate < DATEADD(DAY, @DaysCount+1, @Today))
			ORDER BY 
				StartDate ASC;
		END
END