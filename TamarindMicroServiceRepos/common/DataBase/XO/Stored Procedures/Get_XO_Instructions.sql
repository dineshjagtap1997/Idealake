
CREATE PROCEDURE [XO].[Get_XO_Instructions]                          
(
    @BookingID INT=80,
    @Action CHAR(2) = 'S',
	@XODayWiseID Nvarchar(100)='4632'
)   
AS           
BEGIN    
    IF @Action = 'S'
    BEGIN
        select DISTINCT XI.XO_InstructionID, X.XoType, X.XONumber AS XO_ID, ISNULL(XI.Supplier_Name, X.XO_Supplier_Name) AS Supplier_Name,XI.Confirmed_By,XI.XO_Instruction,XI.Customer_Name,
<<<<<<< HEAD
<<<<<<< HEAD
		Convert(datetime,XI.ArrivalDate) as ArrivalDate, Convert(datetime,XI.DepartureDate) as DepartureDate ,XI.FromCity,XI.ToCity,XI.ArrivalBy,XI.DeptBy,XI.FromTime,XI.ToTime,X.DayWiseID AS XODayWiseID
		from dbo.XO X
		LEFT join dbo.XO_Instructions XI on X.DayWiseID=XI.DayWiseID AND IsActive=1
		--Where X.Qut_ID=@BookingID
		WHERE 
		X.DayWiseID IN (SELECT value FROM STRING_SPLIT(@XODayWiseID, ','));
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		Convert(datetime,XI.ArrivalDate) as ArrivalDate, Convert(datetime,XI.DepartureDate) as DepartureDate ,XI.FromCity,XI.ToCity,XI.ArrivalBy,XI.DeptBy,XI.FromTime,XI.ToTime, XI.NoOfPax,X.DayWiseID AS XODayWiseID
		FROM dbo.XO X Left JOIN dbo.XO_Instructions XI ON X.XO_ID = XI.XO_ID AND XI.IsActive = 1
		--JOIN STRING_SPLIT(@XODayWiseID, ',') AS ids ON X.DayWiseID LIKE '%' + ids.value + '%'
		WHERE X.Qut_ID = @BookingID and X.GroupKey IN (SELECT value FROM STRING_SPLIT(@XODayWiseID, ','))
		And X.Undo=0;
		--from dbo.XO X
		--LEFT join dbo.XO_Instructions XI on X.XO_ID =XI.XO_ID AND IsActive=1
		--WHERE X.Qut_ID=@BookingID and
		--X.DayWiseID 
		----LIKE '%'+@XODayWiseID+'%'
		--IN (SELECT value FROM STRING_SPLIT(@XODayWiseID, ','));
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    END
END