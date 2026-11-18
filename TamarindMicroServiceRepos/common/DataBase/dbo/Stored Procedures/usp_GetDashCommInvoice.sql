--declare
--	@Action CHAR(2) = 'S',
--	@CompanyId INT=9,
--	@YearId INT=4,
--	@OperationBy uniqueidentifier='FEECEB69-C92C-41A9-98DE-FA86FCC009E9',
--	@DaysCount INT=6
CREATE procedure [dbo].[usp_GetDashCommInvoice]
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
			
			SELECT 
				B.BookingID,
				B.FileCode,
				X.XO_ID AS XONumber,
				XO_Supplier_Name as SupplierName,
				XO_Customer_Name as CustomerName,
				XO_Arr AS ArrivalDate,
				XO_Dep AS DepartureDate,
				(
					SELECT TOP 1 
						CASE 
							WHEN HRM.IsCommission = 1 THEN 'BTC Commission'
							WHEN HRM.IsCommission = 0 THEN 'Direct Payment'
							ELSE '-'
						END
					FROM RateCards.HotelRateMaster HRM
					LEFT JOIN Booking.HotelRateCardMasterBooking HRMB 
						ON HRM.HotelRateID = HRMB.HotelRateID
					WHERE HRMB.ID IN (
						SELECT MIN(BHRMID)
						FROM Booking.DayWiseBooking
						WHERE GroupKey = X.GroupKey 
					)
				) AS   CommType,
				FHE
			FROM 
				XO X
				LEFT JOIN Booking.tbl_Booking B ON X.Qut_ID=B.ID
			where 
				ISNULL(CommInvNumber,'')=''
				AND IsBTCComm=1
				AND (ISNULL(@CompanyId,0)=0 OR B.CompanyId=@CompanyId)
				AND (ISNULL(@YearId,0)=0 OR B.YearId=@YearId)
				AND (B.FHE in (select * from [dbo].[fn_Get_All_Reporting] (@CompanyID,@OperationBy)))
				--AND CAST(StartDate AS DATE) <= CAST(GETDATE() AS DATE)
				AND (StartDate >= @Today AND StartDate < DATEADD(DAY, @DaysCount+1, @Today))
			ORDER BY 
				StartDate ASC;
		END
END