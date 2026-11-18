<<<<<<< HEAD
<<<<<<< HEAD
﻿--"{\"YearCode\":4,\"XOID\":\"TINH26000003\",\"Action\":\"S\",\"OnePDF\":\"Y\",\"XOFlag\":\"A\"}"
CREATE PROC [XO].[USP_GetXOReportbkp] 
    @XOID VARCHAR(50)='TINH26000003', 
    @YearCode VARCHAR(10)='4', 
    @Action CHAR(2) = 's'
AS
BEGIN
    DECLARE @Origin INT;
    DECLARE @QutID INT;

    SELECT @Origin = 1, @QutID = QuotationID 
    FROM Quotation.QuotationMaster  
    WHERE QuotationID = (SELECT TOP 1 QUT_ID FROM XO WHERE XO_ID = @XOID AND YearCode = @YearCode);

    DECLARE @VendorFlag VARCHAR(5);
    SET @VendorFlag = (SELECT TOP 1 HotelVendorFlag FROM XO WHERE XO_ID = @XOID AND YearCode = @YearCode);

    DECLARE @CompId VARCHAR(5);
    SET @CompId = (SELECT TOP 1 CompanyID FROM YearMaster WHERE YearID = @YearCode);

    DECLARE @REDDOT VARCHAR(10);
    DECLARE @SAPCompCode VARCHAR(10);
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿CREATE PROC [XO].[USP_GetXOReportbkp] 
    @XOID VARCHAR(50)='', 
    @YearCode VARCHAR(10)='', 
    @Action CHAR(2) = ''
AS
BEGIN
    DECLARE @QutID INT, @VendorFlag VARCHAR(5), @CompId VARCHAR(5), @SAPCompCode VARCHAR(10);

    SELECT @QutID = ID,@CompId=CompanyID
    FROM Booking.Tbl_Booking  
    WHERE ID = (SELECT TOP 1 QUT_ID 
	FROM XO WHERE XO_ID = @XOID AND YearCode = @YearCode);

    SELECT TOP 1 @VendorFlag=HotelVendorFlag FROM XO WHERE XO_ID = @XOID AND YearCode = @YearCode;

    DECLARE @REDDOT VARCHAR(10);
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    SET @SAPCompCode = (SELECT TOP 1 SAP_CompanyCode FROM CompanyMaster WHERE CompanyID = @CompId);

    PRINT 'A- DATA FIRST ROW';

    -- Company Information
    SELECT DISTINCT 
        X.XO_ID,
        GETDATE() AS VoucherDate,
<<<<<<< HEAD
<<<<<<< HEAD
        Q.QuotationNo,
        '' AS FileCode,
=======
        Q.BookingID as QuotationNo,
        Q.FileCode,
>>>>>>> dev
=======
        Q.BookingID as QuotationNo,
        Q.FileCode,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        Q.YearID AS YearCode,
        CM.CompanyName,
        CM.Address,
        CM.CityIATACode,
        CM.Website,
        CM.Email,
        CM.LegalName AS HeadCompanyName,
        CASE WHEN CM.Phone = '' THEN '' ELSE 'Tel: ' + CONVERT(VARCHAR(5), CR.ISDCode) + '-' + CONVERT(VARCHAR, C.STDCode) + '-' + CONVERT(VARCHAR(25), CM.Phone) END AS Phone,
        CASE WHEN CM.Fax = '' THEN '' ELSE 'Fax: ' + CONVERT(VARCHAR(5), CR.ISDCode) + '-' + CONVERT(VARCHAR, C.STDCode) + '-' + CONVERT(VARCHAR(25), CM.Fax) END AS Fax,
<<<<<<< HEAD
<<<<<<< HEAD
        CASE WHEN @SAPCompCode = @REDDOT THEN CM.Address ELSE CASE WHEN CM.Address = CM1.Address THEN '' ELSE CM1.Address END END AS HeadAddress,
=======
        --CASE WHEN @SAPCompCode = @REDDOT THEN CM.Address ELSE CASE WHEN CM.Address = CM1.Address THEN '' ELSE CM1.Address END END AS HeadAddress,
>>>>>>> dev
=======
        --CASE WHEN @SAPCompCode = @REDDOT THEN CM.Address ELSE CASE WHEN CM.Address = CM1.Address THEN '' ELSE CM1.Address END END AS HeadAddress,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        CASE WHEN CM1.Phone = '' THEN '' ELSE 'Tel: ' + CONVERT(VARCHAR(5), CR.ISDCode) + '-' + CONVERT(VARCHAR(5), C1.STDCode) + '-' + CONVERT(VARCHAR(25), CM1.Phone) END AS HeadPhone,
        CASE WHEN CM1.Fax = '' THEN '' ELSE 'Fax: ' + CONVERT(VARCHAR(5), CR.ISDCode) + '-' + CONVERT(VARCHAR(5), C1.STDCode) + '-' + CONVERT(VARCHAR(25), CM1.Fax) END AS HeadFax,
        CM1.CityIATACode AS HeadCityIATACode,
        'Website: ' + CM.Website AS HeadWebsite,
        CASE WHEN ISNULL(CM1.Email, '') = '' THEN '' ELSE 'Email: ' + CM1.Email END AS HeadEmail,
        '' AS AgentLogo,
        '' AS IsTTCLogo,
        'bills@tamarindglobal.com' AS InvoiceEmail,
        CM.CIN AS CorporateIdentityNumber,
        'AC' AS XOFlag,
<<<<<<< HEAD
<<<<<<< HEAD
        @SAPCompCode AS CompFlag,
=======
        --@SAPCompCode AS CompFlag,
>>>>>>> dev
=======
        --@SAPCompCode AS CompFlag,
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
        CM.PanNo AS PAN,
        --CM.CSTNO AS GSTIN,
		CM.CSTNo AS GSTIN,
        CM.CompanyLogoImage, 
        '' AS AgentLogoImage,
        CM.CIN AS CIN,
        CM.MsmeNo AS MSMERegNo,
        L.LUTNumber AS LUTNumber,
        I.ACKNo AS ACKNo,
        I.AmtInINR AS IRN,
        CONVERT(VARCHAR, I.ACKDate, 106) AS ACKDate
    FROM XO X
<<<<<<< HEAD
<<<<<<< HEAD
    LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = X.Qut_ID
=======
    LEFT JOIN Booking.tbl_booking Q ON Q.ID = X.Qut_ID
>>>>>>> dev
=======
    LEFT JOIN Booking.tbl_booking Q ON Q.ID = X.Qut_ID
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    LEFT JOIN CompanyMaster CM ON CM.CompanyID = Q.CompanyID
    LEFT JOIN CompanyMaster CM1 ON CM1.HeadOffice = 1
    LEFT JOIN City C ON C.IATACode = CM.CityIATACode
    LEFT JOIN State S ON S.State_ID = C.State_IATACode
    LEFT JOIN Country CR ON CR.IATACode = S.Country_IATACode
    LEFT JOIN City C1 ON C1.IATACode = CM1.CityIATACode
    LEFT JOIN Invoice I ON I.Qut_ID = Q.QuotationID
    LEFT JOIN LUTMaster L ON L.CompanyID = CM.CompanyID
<<<<<<< HEAD
<<<<<<< HEAD
    WHERE X.XONumber = @XOID;

    -- Booking Details for PDF
    SELECT TOP 1
        ISNULL(HM.HotelName, '') AS HotelName,
        GETDATE() AS VoucherDate,
        ISNULL(At.VoucherNo, '') AS VoucherNo,
        B.FileCode AS FileNo,
        B.NumberofPax AS NoOfPax,
        HM.MembershipNo,
        HM.PhoneNo AS HotelPhone,
        HM.FaxNo AS HotelFax,
        '' AS ConfirmedBy,
        B.GuestName,
        '' AS Twin,
        HM.Address AS HotelAddress,
        DWB.DayWiseDate AS CheckInDate,
        DATEADD(DAY, 1, DWB.DayWiseDate) AS CheckOutDate,
        RC.Name AS RoomType,
        B.SGL AS Sgl,
        B.DBL AS Dbl,
        '' AS ExBed1,
        '' AS ExBed2,
        --'' AS ArrivalDate,
        --'' AS ArrivalFrom,
        --'' AS DepartureDate,
        --'' AS DepartureTo,
        --'' AS ArrivalBy,
        --'' AS ArrivalTime,
        --'' AS DepartureBy,
        --'' AS DepartureTime,
		   XI.ArrivalDate,
    XI.ArrivalDate,
    XI.DepartureDate,
    --XI.FromCity AS ArrivalFrom,
	XI.FromCity AS ArrivalFrom,
    --XI.ToCity AS DepartureTo,
	XI.ToCity AS DepartureTo,
    --XI.ArrivalBy,
	XI.ArrivalBy as ArrivalBy,
    --XI.FromTime AS ArrivalTime,
	DATEADD(HOUR, 6, GETDATE()) AS ArrivalTime,
    XI.DeptBy AS DepartureBy,
    DATEADD(HOUR, 6, GETDATE()) AS DepartureTime,
        '' AS SignatoryName,
        '' AS SignatoryMobile,
        CASE 
            WHEN MP.Code IN ('JP', 'JP1', 'JP2') THEN MP.Description
            WHEN DWB.Breakfast = 0 AND DWB.Lunch = 0 AND DWB.Dinner = 0 THEN 'Room Only'
            ELSE
                CASE WHEN DWB.Breakfast = 1 THEN 'Bfst' ELSE '' END +
                CASE WHEN DWB.Breakfast = 1 AND DWB.Lunch = 1 THEN '+' ELSE '' END +
                CASE WHEN DWB.Lunch = 1 THEN 'Lun' ELSE '' END +
                CASE WHEN (DWB.Lunch = 1 OR DWB.Dinner = 1) AND DWB.Breakfast = 1 THEN '+' ELSE '' END +
                CASE WHEN DWB.Dinner = 1 THEN 'Din' ELSE '' END
        END AS 'Plan'
    FROM XO X
    LEFT JOIN Booking.DayWiseBooking DWB ON DWB.ID = X.DayWiseID

    LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = DWB.QuotationID
    LEFT JOIN Booking.tbl_Booking B ON B.ID = DWB.BookingID
    LEFT JOIN RoomCategory RC ON RC.ID = B.ID
    LEFT JOIN Booking.HotelRateMealPlanMasterBooking HRPB ON DWB.BookingID = HRPB.BookingID
    LEFT JOIN MealPlan MP ON MP.ID = HRPB.MealTypeID
    LEFT JOIN HotelMaster HM ON HM.HotelID = B.ID
    LEFT JOIN AcTransactions AT ON AT.TranId = B.ID
LEFT JOIN XO_Instructions XI ON XI.XO_ID = X.XONumber AND XI.YearCode = @YearCode
    WHERE X.XONumber = @XOID;

    end
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	WHERE X.XONumber = @XOID;

	DECLARE @RateType INT = 0,@XOType varchar(10);
	SELECT TOP 1 @RateType = RateTypeID,
	@XOType=(CASE D.RateTypeID
                WHEN 1 THEN 'G'
                WHEN 2 THEN 'M'
                WHEN 3 THEN 'T'
                WHEN 4 THEN 'S'
                WHEN 5 THEN 'H'
                WHEN 7 THEN 'A'
                ELSE 'Unknown'
            END)
    FROM Booking.DayWiseBooking D Inner Join dbo.XO X ON D.BookingID=X.QUT_ID
	AND D.GroupKey=X.GroupKey where X.XONumber = @XOID;
	
	IF (@RateType = 5)
    BEGIN
		-- Booking Details for PDF
		WITH PlanData AS (
		SELECT ISNULL(XO_Supplier_Name, '') AS HotelName,
        X.GroupKey,
        DWB.SGL, DWB.DBL, DWB.EBA, DWB.EBC,DWB.DayWiseDate,
        XI.Confirmed_By, XI.ArrivalDate, XI.DepartureDate,
        XI.FromCity, XI.ToCity, XI.ArrivalBy, XI.FromTime,
        XI.DeptBy, XI.ToTime,
        CASE 
            WHEN MP.Code IN ('JP', 'JP1', 'JP2') THEN MP.Description
            WHEN DWB.Breakfast = 0 AND DWB.Lunch = 0 AND DWB.Dinner = 0 THEN 'Room Only'
            ELSE CONCAT_WS('+',
                    CASE WHEN DWB.Breakfast = 1 THEN 'Bfst' END,
                    CASE WHEN DWB.Lunch = 1 THEN 'Lun' END,
                    CASE WHEN DWB.Dinner = 1 THEN 'Din' END
                 )
        END AS [Plan],
		B.FileCode AS FileNo,B.NumberofPax AS NoOfPax,B.GuestName,
		HM.MembershipNo,HM.PhoneNo AS HotelPhone,HM.FaxNo AS HotelFax,HM.Address AS HotelAddress
		,RC.Name as RoomType,ISNULL(At.VoucherNo, '') AS VoucherNo
			FROM XO X
			LEFT JOIN XO_Instructions XI ON XI.XO_ID = X.XONumber 
			INNER JOIN Booking.tbl_Booking B ON B.ID = X.Qut_ID
			INNER JOIN Booking.DayWiseBooking DWB ON DWB.BookingID = B.ID AND X.GroupKey = DWB.GroupKey
			Left JOIN Booking.HotelRateCardMasterBooking HRM ON DWB.BHRMID=HRM.ID
			LEFT JOIN Booking.HotelRateMealPlanMasterBooking HRPB ON HRPB.BookingID = B.ID
			LEFT JOIN MealPlan MP ON MP.ID = HRPB.MealTypeID
			LEFT JOIN HotelMaster HM ON HM.HotelID = HRM.HotelID
			LEFT JOIN RoomCategory RC ON RC.ID = HRM.RoomCategoryID
			LEFT JOIN AcTransactions AT ON AT.TranId = B.ID
			WHERE X.XONumber = @XOID
		) 
		SELECT 
			SUM(SGL) AS Sgl,
			SUM(DBL) AS Dbl,
			SUM(EBA) AS ExBed1,
			SUM(EBC) AS ExBed2,
			MIN(Confirmed_By) AS ConfirmedBy,
			MIN(ArrivalDate) AS ArrivalDate,
			MIN(DepartureDate) AS DepartureDate,
			MIN(FromCity) AS ArrivalFrom,
			MIN(ToCity) AS DepartureTo,
			MIN(ArrivalBy) AS ArrivalBy,
			MIN(DATEADD(HOUR, 6, TRY_CAST(FromTime AS DATETIME))) AS ArrivalTime,
			MIN(DeptBy) AS DepartureBy,
			MIN(DATEADD(HOUR, 6, TRY_CAST(ToTime AS DATETIME))) AS DepartureTime,
			MIN([Plan]) AS [Plan],
			MIN(FileNo) AS FileNo,
			MIN(NoOfPax) as NoOfPax,
			MIN(GuestName) as GuestName,
			MIN(MembershipNo) as MembershipNo,MIN(HotelPhone) as HotelPhone,MIN(HotelFax) as HotelFax,MIN(HotelAddress) as HotelAddress,
			MIN(DayWiseDate) as CheckInDate, MAX(DayWiseDate) as CheckOutDate,MIN(RoomType) AS RoomType,MIN(GETDATE()) AS VoucherDate,MIN(VoucherNo) as VoucherNo
			,MIN('') AS Twin,MIN('') AS SignatoryName,MIN('') AS SignatoryMobile,MIN('') AS Remark,
				MIN(HotelName) as HotelName,MIN(@XOType) as XOType
		FROM PlanData
		GROUP BY GroupKey;
	END
	ELSE
	BEGIN
		WITH PlanData AS (
SELECT ISNULL(XO_Supplier_Name, '') AS HotelName,
        X.GroupKey,DWB.DayWiseDate,
        DWB.COUNT,DWB.Adult,DWB.Child,
		Case when DWB.RateType =1 then
			(select TOP 1 GS.Name from dbo.GuideServices GS where GS.Code=DWB.ServiceID)
			WHEN DWB.RateType =2 then 
			(select TOP 1 MS.Name from [dbo].[MonumentService] MS where MS.ID=DWB.ServiceID)
			WHEN DWB.RateType =3 then 
			(select TOP 1 TS.Name from [dbo].[TransportServices] TS where TS.Code=DWB.ServiceID)
			WHEN DWB.RateType =4 then 
			(select TOP 1 SS.Name from [dbo].[SpecialServices] SS where SS.ID=DWB.ServiceID)
		ELSE '' END as [Services],
        XI.Confirmed_By, XI.ArrivalDate, XI.DepartureDate,
        XI.FromCity, XI.ToCity, XI.ArrivalBy, XI.FromTime,
        XI.DeptBy, XI.ToTime,
		B.FileCode AS FileNo,B.NumberofPax AS NoOfPax,B.GuestName,
		VM.MembershipNo,VM.PhoneNo As HotelPhone,VM.FaxNo AS HotelFax,VM.Address AS HotelAddress
		,ISNULL(At.VoucherNo, '') AS VoucherNo,N.Nationality,V.DisplayName,L.Language
			FROM XO X
			LEFT JOIN XO_Instructions XI ON XI.XO_ID = X.XONumber 
			INNER JOIN Booking.tbl_Booking B ON B.ID = X.Qut_ID
			INNER JOIN Booking.DayWiseBooking DWB ON DWB.BookingID = B.ID AND X.GroupKey = DWB.GroupKey
			Left JOIN Booking.OthersRateCardMasterBooking ORMB ON DWB.BORMID=ORMB.ID
			LEFT JOIN dbo.VendorMaster VM ON VM.VendorID = DWB.Vendor
			LEFT JOIN AcTransactions AT ON AT.TranId = B.ID
			LEFT JOIN DBO.Nationality N on N.ID=ORMB.NationalityID
			LEFT JOIN DBO.VehicleTypeMaster V on V.ID=ORMB.VehicleCategoryID
			LEFT JOIN DBO.Language L on L.ID=ORMB.LanguageID
			WHERE X.XONumber =  @XOID)
			SELECT 
			MIN(Confirmed_By) AS ConfirmedBy,
			MIN(ArrivalDate) AS ArrivalDate,
			MIN(DepartureDate) AS DepartureDate,
			MIN(FromCity) AS ArrivalFrom,
			MIN(ToCity) AS DepartureTo,
			MIN(ArrivalBy) AS ArrivalBy,
			MIN(DATEADD(HOUR, 6, TRY_CAST(FromTime AS DATETIME))) AS ArrivalTime,
			MIN(DeptBy) AS DepartureBy,
			MIN(DATEADD(HOUR, 6, TRY_CAST(ToTime AS DATETIME))) AS DepartureTime,
			MIN(FileNo) AS FileNo,
			MIN(NoOfPax) as NoOfPax,
			MIN(GuestName) as GuestName,
			MIN(MembershipNo) as MembershipNo,MIN(HotelPhone) as HotelPhone,MIN(HotelFax) as HotelFax,MIN(HotelAddress) as HotelAddress,
			MIN(DayWiseDate) as CheckInDate, MAX(DayWiseDate) as CheckOutDate,MIN(GETDATE()) AS VoucherDate,MIN(VoucherNo) as VoucherNo
			,MIN('') AS Twin,MIN('') AS SignatoryName,MIN('') AS SignatoryMobile,MIN('') AS Remark,
				MIN(HotelName) as HotelName,MIN([Services]) as Services,MIN(Nationality) as Nationality,MIN(DisplayName) as VehicleCategory,MIN(Language) as Language,SUM(COUNT) as Count,SUM(Adult) as Adult,SUM(Child) as Child
				,MIN(@XOType) as XOType
		FROM PlanData
		GROUP BY GroupKey;
	END
end
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6


