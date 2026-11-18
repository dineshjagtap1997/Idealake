--declare
--	@Action CHAR(2) = 'S',
--	@CompanyId INT=9,
--	@YearId INT=4,
--	@OperationBy uniqueidentifier='FEECEB69-C92C-41A9-98DE-FA86FCC009E9',
--	@DaysCount INT=0
CREATE procedure [dbo].[usp_GetDashboardStayTransport]
	@Action CHAR(2) = null,
	@CompanyId INT=null,
	@YearId INT=null,
	@OperationBy uniqueidentifier=null,
	@DaysCount INT=null,
	@PageNumber INT = 0,
	@Row_Count INT = 10
AS
BEGIN
	DECLARE @Today DATE = CAST(GETDATE() AS DATE),  @TotalRecordCount INT = 0
	
	IF(@Action='SA')
		BEGIN
			SELECT @TotalRecordCount = 
				(
					select count(*) from 
						(
							select 
								DISTINCT
								tbl.StartDate,
								tbl.FHE,
								tbl.GuestName,
								C.Name as CityName,
								DB.HotelName,
								(Select top 1 ServiceName from  Booking.DayWiseBooking where RateTypeID=3 AND ID=DB.ID) as Transport,
								EM.EmpName AS FHEName
							FROM 
								Booking.DayWiseBooking DB
								left join Booking.tbl_Booking tbl on tbl.ID =db.BookingID
								left join City C ON tbl.CityIATACode=C.IATACode
								LEFT JOIN EmployeeMaster EM ON EM.UserID = tbl.FHE
							WHERE
								(ISNULL(@CompanyId,0)=0 OR tbl.CompanyId=@CompanyId)
								AND (ISNULL(@YearId,0)=0 OR tbl.YearId=@YearId)
								AND (tbl.FHE in (select * from [dbo].[fn_Get_All_Reporting] (@CompanyID,@OperationBy)))
								AND (StartDate >= @Today AND StartDate < DATEADD(DAY, @DaysCount+1, @Today))
								AND Status = 3 
							
						)
				as a
				)

			select 
				DISTINCT
				tbl.StartDate,
				tbl.FHE,
				tbl.GuestName,
				C.Name as CityName,
				DB.HotelName,
				(Select top 1 ServiceName from  Booking.DayWiseBooking where RateTypeID=3 AND ID=DB.ID) as Transport,
				EM.EmpName AS FHEName
			FROM 
				Booking.DayWiseBooking DB
				left join Booking.tbl_Booking tbl on tbl.ID =db.BookingID
				left join City C ON tbl.CityIATACode=C.IATACode
				LEFT JOIN EmployeeMaster EM ON EM.UserID = tbl.FHE
			WHERE
				(ISNULL(@CompanyId,0)=0 OR tbl.CompanyId=@CompanyId)
				AND (ISNULL(@YearId,0)=0 OR tbl.YearId=@YearId)
				AND (tbl.FHE in (select * from [dbo].[fn_Get_All_Reporting] (@CompanyID,@OperationBy)))
				AND (StartDate >= @Today AND StartDate < DATEADD(DAY, @DaysCount+1, @Today))
				AND Status = 3 
			ORDER BY StartDate ASC
			OFFSET @PageNumber * @Row_Count ROWS
			FETCH NEXT @Row_Count ROWS ONLY;

			SELECT CAST(@TotalRecordCount AS VARCHAR(20)) AS Row_Count, '200' AS returnCode, 'Data Found' AS returnMessage;

		END
	ELSE IF(@Action='S')
		BEGIN
			
			select 
				DISTINCT
				tbl.StartDate,
				tbl.FHE,
				tbl.GuestName,
				C.Name as CityName,
				DB.HotelName,
				(Select top 1 ServiceName from  Booking.DayWiseBooking where RateTypeID=3 AND ID=DB.ID) as Transport,
				EM.EmpName AS FHEName
			FROM 
				Booking.DayWiseBooking DB
				left join Booking.tbl_Booking tbl on tbl.ID =db.BookingID
				left join City C ON tbl.CityIATACode=C.IATACode
				LEFT JOIN EmployeeMaster EM ON EM.UserID = tbl.FHE
			WHERE
				(ISNULL(@CompanyId,0)=0 OR tbl.CompanyId=@CompanyId)
				AND (ISNULL(@YearId,0)=0 OR tbl.YearId=@YearId)
				AND (tbl.FHE in (select * from [dbo].[fn_Get_All_Reporting] (@CompanyID,@OperationBy)))
				AND (StartDate >= @Today AND StartDate < DATEADD(DAY, @DaysCount+1, @Today))
				AND Status = 3 
			ORDER BY StartDate ASC
			

		END
END