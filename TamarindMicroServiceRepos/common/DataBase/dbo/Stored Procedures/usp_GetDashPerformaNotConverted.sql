--declare
--	@Action CHAR(2) = 'S',
--	@CompanyId INT=9,
--	@YearId INT=4,
--	@OperationBy uniqueidentifier='FEECEB69-C92C-41A9-98DE-FA86FCC009E9',
--	@DaysCount INT=10
CREATE procedure [dbo].[usp_GetDashPerformaNotConverted]
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
				Invoice_Date ,
				InvoiceNumber,
				ID.TotalAmount as Amount,
				B.FileCode,
				AM.AgentName,
				I.GuestName,
				B.StartDate,
				B.EndDate,
				B.FHE
			from   
				Invoice.Invoice I
				LEFT JOIN Invoice.InvoiceDetails ID ON I.ID=ID.Invoice_ID
				LEFT JOIN AgentMaster AM ON I.AgentID=AM.AgentID
				LEFT JOIN Booking.tbl_Booking B ON I.BookingID=B.ID
			where 
				TypeOfDoc=2
				and ISNULL(ConvertedInvNo,'')=''
				AND (ISNULL(@CompanyId,0)=0 OR B.CompanyId=@CompanyId)
				AND (ISNULL(@YearId,0)=0 OR B.YearId=@YearId)
				AND (B.FHE IN (select * from [dbo].[fn_Get_All_Reporting] (@CompanyID,@OperationBy)))
				--AND CAST(StartDate AS DATE) <= CAST(GETDATE() AS DATE)
				AND (StartDate >= @Today AND StartDate < DATEADD(DAY, @DaysCount+1, @Today))
			ORDER BY 
				StartDate ASC;
		END
END


