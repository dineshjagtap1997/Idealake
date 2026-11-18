Create PROCEDURE [XO].[Get_XO_Data] (
    @BookingID INT = 454,
    @Action CHAR(2) = 'S',
	@IsDashboard INT=NULL,
	@DashCompanyId INT=NULL,
	@OperationBy uniqueidentifier=NULL,
	@DashYearId INT=NULL,
	@DaysCount INT=NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @Action = 'S'
    BEGIN
        -- Declare variables
        DECLARE @SupplierTax_InCluding INT = 0;
        DECLARE @Location VARCHAR(10) = 'BOM';
        DECLARE @StateCodeID INT;
        DECLARE @CompStateCodeID INT;
        DECLARE @CompanyID INT;
        DECLARE @ComGST VARCHAR(15);
        DECLARE @HotelGST VARCHAR(15);
        DECLARE @XOPost VARCHAR(10) = 'BOM';
        DECLARE @HotelID INT = 0;
		Declare @BaseCurrencyCode varchar(10)='';
		 -- Get an effective BookingID even if null is passed
        DECLARE @EffectiveBookingID INT;

		IF(ISNULL(@IsDashboard,0)=0)
			BEGIN
				SET @EffectiveBookingID = ISNULL(@BookingID, (
					SELECT TOP 1 ID FROM Booking.tbl_Booking ORDER BY ID DESC
				));
	
				-- Get data from tbl_Booking
				SELECT 
					@SupplierTax_InCluding = ISNULL(SupplierTax_InCluding, 0),
					@CompanyID = CompanyID,
					@HotelID = ISNULL(@HotelID, 0)
				FROM Booking.tbl_Booking 
				WHERE ID = @EffectiveBookingID;

				-- Get Location from Company
				SELECT @Location = ISNULL(CityIATACode, 'BOM'), @BaseCurrencyCode = ISNULL(C.CurrencyCode, 'INR')
				--select CM.*
				FROM CompanyMaster CM Left JOIN 
				Dbo.CurrencyMaster C on CM.CurrencyComp_id=C.id
				WHERE CompanyID = @CompanyID;
				IF (@SupplierTax_InCluding = 1)
				BEGIN
					SET @XOPost = @Location;
				END
				ELSE
				BEGIN
					SELECT 
						@ComGST = GSTVERIFICATION, 
						@CompStateCodeID = StateCodeID 
					FROM CompanyMaster 
					WHERE CompanyID = @CompanyID;

					SELECT 
						@HotelGST = GSTNID, 
						@StateCodeID = StateCodeID 
					FROM HotelMaster 
					WHERE HotelID = @HotelID;

					IF (@CompStateCodeID IS NOT NULL AND @StateCodeID IS NOT NULL)
					BEGIN
						IF (@CompStateCodeID = @StateCodeID)
							SET @XOPost = CAST(@StateCodeID AS VARCHAR);
						ELSE
							SET @XOPost = @Location;
					END
					ELSE
					BEGIN
						SET @XOPost = @Location;
					END
				END;
			END
		ELSE
			BEGIN
				DECLARE @Today DATE = CAST(GETDATE() AS DATE)
				DECLARE @PrevDays DATE;

				SET @PrevDays= DATEADD(DAY, -@DaysCount, @Today)
			END


        ---------------------- SELECT 1: New XO ----------------------
        SELECT DISTINCT
			--MIN(DWB.ID) as ID,
            '' AS CompName,
            '' AS YearCode,
            MIN(TB.FileCode) AS File_ID,
            MIN(CAST(DWB.XOLock AS INT)) AS XOLock,
            CASE MIN(DWB.RateTypeID)
                WHEN 1 THEN 'G' WHEN 2 THEN 'M' WHEN 3 THEN 'T'
                WHEN 4 THEN 'S' WHEN 5 THEN 'H' WHEN 7 THEN 'A'
                ELSE 'Unknown'
            END AS XOType,
            NULL AS AdvanceXOID,
            DWB.BookingID,
            '' AS XONumber,
            CASE 
                WHEN MIN(DWB.RateTypeID) = 5 THEN MIN(DWB.HotelName)
                ELSE MIN(VM.VendorName)
            END AS Supplier,
			isnull(DWB.Currency,'')+' '+Convert(varchar,isnull([XO].[fn_Get_XO_Amount](DWB.BookingID, DWB.GroupKey),0)) AS XOAmount,
            --[XO].[fn_Get_XO_Amount](DWB.BookingID, DWB.GroupKey) AS XOAmount,
			--isnull(@BaseCurrencyCode,'')+' '+ Case when @BaseCurrencyCode != MIN(DWB.Currency)
			--	THEN 
			--		Convert(varchar,isnull([XO].[fn_Get_XO_Amount](DWB.BookingID, DWB.GroupKey),0)*MIN(CR.PurchaseRate))
			--	ELSE
			--		Convert(varchar,isnull([XO].[fn_Get_XO_Amount](DWB.BookingID, DWB.GroupKey),0))
			--	END AS XOAmount,
            MIN(@BaseCurrencyCode) AS Currency,
            SUM(DWB.GrossRate) AS GrossRate,
            (SELECT MIN(SDWB.DayWiseDate) FROM Booking.DayWiseBooking SDWB WHERE SDWB.BookingID = DWB.BookingID and SDWB.GroupKey = DWB.GroupKey) AS Checkin,
            --(SELECT MAX(SDWB.DayWiseDate) FROM Booking.DayWiseBooking SDWB WHERE SDWB.BookingID = DWB.BookingID and SDWB.GroupKey = DWB.GroupKey) AS Checkout,
			CASE 
				MIN(DWB.RateTypeID)
				WHEN 5 
				THEN DATEADD(
								DAY, 1,(
										(SELECT MAX(SDWB.DayWiseDate) FROM Booking.DayWiseBooking SDWB WHERE SDWB.BookingID = DWB.BookingID and SDWB.GroupKey = DWB.GroupKey)
									)
							)
				ELSE (SELECT MAX(SDWB.DayWiseDate) FROM Booking.DayWiseBooking SDWB WHERE SDWB.BookingID = DWB.BookingID and SDWB.GroupKey = DWB.GroupKey)
			END AS Checkout,
            MIN(DWB.HotelName) AS HotelName,
			null as Supplier_Credit,
            MIN(DWB.Currency) AS XOCurrency,
            NULL AS PayTo,
            NULL AS HotelVendorCredit,
           min( case when isnull(A.CreditApplicable,0)=1 then 'Yes' Else 'No' end) AS Agent_Credit_Status,
            NULL AS InvoiceNumber,          
			NULL AS TACInvoiceNo,

            NULL AS ApprovedBy,
            MIN(VM.VendorName) AS VendorName,
            NULL AS TACInvoiceAmount,
            NULL AS ReasonForAdvance,
            NULL AS ModeOfPayment,
            NULL AS VendorAmount,
            NULL AS TaxPercentage,
            NULL AS TaxValue,
            NULL AS XOlock,
            (SELECT TOP 1 SDWB.IsLock FROM Booking.DayWiseBooking SDWB WHERE SDWB.GroupKey = DWB.GroupKey) AS Xolock,
            (
                SELECT TOP 1 
                    CASE 
                        WHEN HRM.PaymentTypeID = 2 THEN 
						CASE when HRM.IsCommission=1 THEN 'BTC Commission' ELSE '-' END
                        ELSE 'Direct Payment'
                    END
                FROM RateCards.HotelRateMaster HRM
                LEFT JOIN Booking.HotelRateCardMasterBooking HRMB 
                    ON HRM.HotelRateID = HRMB.HotelRateID
                WHERE HRMB.ID IN (
                    SELECT MIN(BHRMID)
                    FROM Booking.DayWiseBooking
                    WHERE GroupKey = DWB.GroupKey and BookingID = @BookingID
                )
            ) AS CommXO,
			(
                SELECT TOP 1 
                    CASE 
                        WHEN HRM.PaymentTypeID = 2 THEN 
						CASE when HRM.IsCommission=1 THEN 1 ELSE 0 END
                        ELSE 1
                    END
                FROM RateCards.HotelRateMaster HRM
                LEFT JOIN Booking.HotelRateCardMasterBooking HRMB 
                    ON HRM.HotelRateID = HRMB.HotelRateID
                WHERE HRMB.ID IN (
                    SELECT MIN(BHRMID)
                    FROM Booking.DayWiseBooking
                    WHERE GroupKey = DWB.GroupKey and BookingID = @BookingID
                )
            ) AS IsBTCComm,
            --(
            --    SELECT TOP 1 
            --        CASE 
            --            WHEN CommInvNumber IS NULL THEN '' 
            --            ELSE CommInvNumber  
            --        END 
            --    FROM XO  
            --    WHERE XO.Qut_ID = DWB.ID
            --) 
			'' AS CommInv,
            MIN(@XOPost) AS City,
            --ISNULL((SELECT TOP 1 'Yes' FROM dbo.XO_Instructions XI WHERE XI.DayWiseID = DWB.ID AND XI.ISActive = 1), 'No') 
			'No' AS XOInstruction,
            DWB.GroupKey,
            --DWB.ID AS IDList,
			STUFF((
				SELECT ',' + CAST(SDWB.ID AS VARCHAR)
				FROM Booking.DayWiseBooking SDWB
				WHERE SDWB.GroupKey = DWB.GroupKey AND SDWB.BookingID = DWB.BookingID
				FOR XML PATH(''), TYPE
			).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS IDList,
            NULL AS RequestID,
            NULL AS RequestedBy,
            NULL AS FileCode,
            NULL AS InvoiceNumber,
            NULL AS StatusName,
            ISNULL(@XOPost, 'BOM') AS LOC,
			NULL AS Request_Date,
			NULL AS FHE,
			NULL AS FileCode,
			null AS XO,
			NULL AS GuestName,
			NULL AS AgentName,
			NULL AS Status,
			--IsNull(DWB.XOLock,0),
			0 as XoLock,
			NULL as HotelName,
			NULL as XO_ID,
			NULL as XO_Amount,
			NULL as Currency,
		    NULL as SVCStartDate,
			NULL as SVCEndDate,
			NULL as Commission,
			--MIN(a.AgentName) AS Bank_Account_Name,
			--MIN(A.Accountnumber) AS Bank_Account_No,
			--MIN(A.BankName) AS Bank_Name,
			--MIN(A.ifsccode) AS IFSC,
			CASE WHEN (MIN(VM.VendorName) IS NULL OR MIN(VM.VendorName) = '') THEN MIN(HM.AccountNo) ELSE MIN(VM.AccountNo) END AS Bank_Account_No,      
			CASE WHEN (MIN(VM.VendorName) IS NULL OR MIN(VM.VendorName) = '') THEN MIN(HM.ChequeFavouring) ELSE MIN(VM.ChequeFavouring) END AS Bank_Account_Name,                        
			CASE WHEN (MIN(VM.VendorName) IS NULL OR MIN(VM.VendorName) = '') THEN MIN(HM.BankName) ELSE MIN(VM.BankName) END AS Bank_Name,                        
			CASE WHEN (MIN(VM.VendorName) IS NULL OR MIN(VM.VendorName) = '') THEN MIN(HM.IFSCCode) ELSE MIN(VM.IFSCCode) END AS IFSC,  
 
			MIN(VM.VendorSAPCode) AS SAP_Vendor_Code,
			E.EmpName AS FileHandler,
			E.EmpName AS File_Handler,

			min(CM.SAP_CompanyCode) AS SAPCompCode,
			min(CM.SAP_CompanyCode) AS SAP_Comp_Code,

			min(CM.SAP_BusinessPlaceCode) as SAPXOBizPlaceCode,
			min(CM.SAP_BusinessPlaceCode) as SAP_XO_BizPlace_Code,

			min(BM.BusinessModuleName) as Biz_Vertical
        FROM Booking.DayWiseBooking DWB
        LEFT JOIN Booking.tbl_Booking TB ON TB.ID = DWB.BookingID
        LEFT JOIN AgentMaster A ON A.AgentID = TB.AgentID
		LEFT JOIN BusinessMaster BM on BM.BussinessModuleID=TB.BizVirticale
        LEFT JOIN dbo.VendorMaster VM ON VM.VendorID = DWB.Vendor
        LEFT JOIN dbo.HotelMaster HM ON HM.HotelName = DWB.HotelName

			LEFT JOIN EmployeeMaster E ON TB.FHE = E.UserID
		LEFT JOIN CompanyMaster CM  ON CM.CompanyID = TB.CompanyID
		--Outer Apply dbo.fnGetCurrencyConversionRate(DWB.Currency, @BaseCurrencyCode) CR
        WHERE 
            (@BookingID IS NULL OR DWB.BookingID = @BookingID)
            AND DWB.IsOkXO = 1
            AND NOT EXISTS (
                SELECT 1
                FROM dbo.XO XO
                WHERE XO.Qut_ID = DWB.BookingID
                AND ISNULL(XO.GroupKey, -1) = ISNULL(DWB.GroupKey, -1) AND XO.Undo=0
            )
			AND ISNULL(@IsDashboard,0)=0
        GROUP BY 
			
            DWB.GroupKey, DWB.BookingID, DWB.RateTypeID, DWB.Vendor, DWB.ID,DWB.XOLock,DWB.Currency,DWB.IsXoGen,E.EmpName,CM.SAP_CompanyCode,TB.BizVirticale 
		

        ---------------------- SELECT 2: Existing XO ----------------------
        UNION 

        SELECT DISTINCT
			--DWB.ID,
            XO.CompName,
            XO.YearCode,
            B.FileCode as File_ID,
            (
                SELECT TOP 1 IsLock
                FROM Booking.DayWiseBooking
                WHERE BookingID = XO.Qut_ID
                    AND ISNULL(GroupKey, -1) = ISNULL(XO.GroupKey, -1)
            ) AS XOLock,
            XO.XoType,
            XO.XO_ID AS AdvanceXOID,
            XO.Qut_ID AS BookingID,
            XO.XONumber AS XONumber,
            XO.XO_Supplier_Name AS Supplier,
            --XO.XO_Amt AS XOAmount,
			isnull(XO.Curr_ID,'')+' '+Convert(varchar,isnull(XO.XO_Amt,0)) AS XOAmount,
            XO.Curr_ID AS Currency,
            XO.XO_Amt AS GrossRate,
            (
                SELECT MIN(SDWB.DayWiseDate)
                FROM Booking.DayWiseBooking SDWB
                WHERE SDWB.BookingID = XO.Qut_ID
                  AND ISNULL(GroupKey, -1) = ISNULL(XO.GroupKey, -1)
            ) AS Checkin,
            --(
            --    SELECT MAX(SDWB.DayWiseDate)
            --    FROM Booking.DayWiseBooking SDWB
            --    WHERE SDWB.BookingID = XO.Qut_ID
            --      AND ISNULL(GroupKey, -1) = ISNULL(XO.GroupKey, -1)
            --) AS Checkout,
			CASE
				WHEN XO.XoType='H' 
				THEN (
						DATEADD(
								DAY, 1,(
							SELECT MAX(SDWB.DayWiseDate)
							FROM Booking.DayWiseBooking SDWB
							WHERE SDWB.BookingID = XO.Qut_ID
							  AND ISNULL(GroupKey, -1) = ISNULL(XO.GroupKey, -1)
							  )
							) 
						)
				ELSE
					(
						SELECT MAX(SDWB.DayWiseDate)
						FROM Booking.DayWiseBooking SDWB
						WHERE SDWB.BookingID = XO.Qut_ID
						  AND ISNULL(GroupKey, -1) = ISNULL(XO.GroupKey, -1)
					)
			END as Checkout,
            XO.XO_Supplier_Name AS HotelName,
			 XO.XO_Supplier_Name AS Supplier_Credit,
            XO.Curr_ID AS XOCurrency,
			--(select top 1 PayTo from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) as PayTo,
			case when Isnull(VM.VendorName,'')='' then DWB.HotelName else VM.VendorName end as PayTo,
            (select top 1 Supplier_Credit from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID)  AS HotelVendorCredit,
            --A.AgentCredit AS AgentPaymentStatus,
			(select top 1 AgentCredit from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) AS Agent_Credit_Status,
            (select top 1 InvoiceNumber from Invoice.Invoice I where  I.InvoiceType = 4 and XO.XO_ID = I.XO_ID) AS InvoiceNumber,
			(select top 1 InvoiceNumber from Invoice.Invoice I where  I.InvoiceType = 4 and XO.XO_ID = I.XO_ID) AS TACInvoiceNo,
            --A.Approved_By AS ApprovedBy,

			(select top 1 Approved_By from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) AS ApprovedBy,
			 VM.VendorName AS VendorName,

            --XO.XO_Supplier_Name AS VendorName,

            --A.TAC_Invoice_Amt AS TACInvoiceAmount,

			(select top 1 TAC_Invoice_Amt from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) AS TACInvoiceAmount,

            --A.Reason_For_Advance AS ReasonForAdvance,
			(select top 1 Reason_For_Advance from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) AS ReasonForAdvance,

            NULL AS ModeOfPayment,
            --A.Vendor_Bill_Amt AS VendorAmount,
			(select top 1 Vendor_Bill_Amt from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) AS VendorAmount,

            --A.GST_Per AS TDSPercentage,
			(select top 1 GST_Per from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) AS TDSPercentage,

            --(A.TAC_Invoice_Amt - A.XO_Amt) AS TaxValue,
			(select top 1 (TAC_Invoice_Amt - XO_Amt) from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) AS TaxValue,

            NULL AS XOlock,
            (
                SELECT TOP 1 SDWB.IsLock
                FROM Booking.DayWiseBooking SDWB
                WHERE SDWB.BookingID = XO.Qut_ID
                    AND ISNULL(SDWB.GroupKey, -1) = ISNULL(XO.GroupKey, -1)
            ) AS Xolock,
            (
                SELECT TOP 1 
                    CASE 
                        WHEN HRM.PaymentTypeID = 2 THEN 
						CASE when HRM.IsCommission=1 THEN 'BTC Commission' ELSE '-' END
                        ELSE 'Direct Payment'
                    END
                FROM RateCards.HotelRateMaster HRM
                LEFT JOIN Booking.HotelRateCardMasterBooking HRMB 
                    ON HRM.HotelRateID = HRMB.HotelRateID
                WHERE HRMB.ID IN (
                    SELECT MIN(BHRMID)
                    FROM Booking.DayWiseBooking
                    WHERE BookingID = XO.Qut_ID and BookingID=@BookingID
                    AND ISNULL(GroupKey, -1) = ISNULL(XO.GroupKey, -1)
                )
            ) AS CommXO,
			(
                SELECT TOP 1 
                    CASE 
                        WHEN HRM.PaymentTypeID = 2 THEN 
						CASE when HRM.IsCommission=1 THEN 1 ELSE 0 END
                        ELSE 1
                    END
                FROM RateCards.HotelRateMaster HRM
                INNER JOIN Booking.HotelRateCardMasterBooking HRMB 
                    ON HRM.HotelRateID = HRMB.HotelRateID
                WHERE HRMB.ID IN (SELECT TOP 1 BHRMID
                FROM Booking.DayWiseBooking
                WHERE BookingID = XO.Qut_ID and BookingID=@BookingID
                    AND ISNULL(GroupKey, -1) = ISNULL(XO.GroupKey, -1))
            ) AS IsBTCComm,
            (CASE WHEN CommInvNumber IS NULL THEN '' ELSE CommInvNumber END) AS CommInv,
            (
                SELECT TOP 1 City
                FROM Booking.DayWiseBooking
                WHERE BookingID = XO.Qut_ID
                    AND ISNULL(GroupKey, -1) = ISNULL(XO.GroupKey, -1)
            ) AS City,
            CASE WHEN XI.XO_ID IS NOT NULL THEN 'Yes' ELSE 'No' END AS XOInstruction,
            XO.GroupKey,
            XO.DayWiseID AS IDList,
            --A.Request_ID AS RequestID,
			(select top 1 Request_ID from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) AS RequestID,

            --A.Requested_By AS RequestedBy,
			(select top 1 Requested_By from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) AS RequestedBy,

            B.FILECODE AS FileCode, 
            '' as InvoiceNumber,
            BS.StatusName,
            ISNULL(@XOPost, 'BOM') AS LOC,
			(select top 1 Request_Date from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) as Request_Date,
			B.FHE,
			B.FileCode,
			XO.XO_ID as XO,
			--A.GuestName,
			(select top 1 GuestName from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) as GuestName,

			--A.AgentName,
			(select top 1 AgentName from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) as AgentName,

			--A.AgentPaymentStatus as Status,
			(select top 1 AgentPaymentStatus from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) as Status ,

			IsNull((
                SELECT TOP 1 XOLock
                FROM Booking.DayWiseBooking
                WHERE BookingID = XO.Qut_ID
                    AND ISNULL(GroupKey, -1) = ISNULL(XO.GroupKey, -1)
            ),0) as XoLock,
			XO.XO_Supplier_Name as HotelName,
			XO.XO_ID as XO_ID,
			XO.XO_Amt as XO_Amount,
			XO.Curr_ID as Currency,
		    XO.CheckINDate as SVCStartDate,
			XO.CheckOutDate as SVCEndDate,
			XO.IsBTCComm as Commission,
			--(AM.AgentName) AS Bank_Account_Name,
			--(AM.Accountnumber) AS Bank_Account_No,
			--(AM.BankName) AS Bank_Name,
			--(AM.ifsccode) AS IFSC,
			--A.Bank_Name AS Bank_Account_Name,
			--A.Bank_Account_No AS Bank_Account_No,
			--A.Bank_Name AS Bank_Name,
			--A.IFSC AS IFSC,
			CASE WHEN ((VM.VendorName) IS NULL OR (VM.VendorName) = '') THEN (HM.AccountNo) ELSE (VM.AccountNo) END AS Bank_Account_No,      
			CASE WHEN ((VM.VendorName) IS NULL OR (VM.VendorName) = '') THEN (HM.ChequeFavouring) ELSE (VM.ChequeFavouring) END AS Bank_Account_Name,                        
			CASE WHEN ((VM.VendorName) IS NULL OR (VM.VendorName) = '') THEN (HM.BankName) ELSE (VM.BankName) END AS Bank_Name,                        
			CASE WHEN ((VM.VendorName) IS NULL OR (VM.VendorName) = '') THEN (HM.IFSCCode) ELSE (VM.IFSCCode) END AS IFSC,  

			(select top 1 SAP_Vendor_Code from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) AS SAP_Vendor_Code,

			--A.SAP_Vendor_Code,
			E.EmpName AS FileHandler,
			E.EmpName AS File_Handler,

			(select top 1 SAPCompCode from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) AS SAP_Comp_Code,
			(select top 1 SAPCompCode from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) AS SAPCompCode,

			--CM.SAP_CompanyCode AS SAPCompCode,
			(select top 1 SAPXOBizPlaceCode from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) AS SAPXOBizPlaceCode,
			(select top 1 SAPXOBizPlaceCode from AdvancePaySendRequest A1 where A1.XO_ID = XO.XO_ID) AS SAP_XO_BizPlace_Code,


			--A.SAPXOBizPlaceCode,
			BM.BusinessModuleName as Biz_Vertical-- as Biz_Vertical
        FROM dbo.XO XO
       --LEFT  JOIN AdvancePaySendRequest A ON A.XO_ID = XO.XO_ID
        LEFT JOIN dbo.XO_Instructions XI ON XI.XO_ID = XO.XO_ID AND XI.ISActive = 1
        LEFT JOIN Booking.tbl_booking B ON B.ID = XO.File_ID
		LEFT JOIN BusinessMaster BM on BM.BussinessModuleID=B.BizVirticale

        LEFT JOIN Booking.BookingStatus BS ON B.Status = BS.StatusCode
		LEFT JOIN  Booking.DayWiseBooking DWB on DWB.BookingID=XO.Qut_ID and DWB.GroupKey=XO.GroupKey
		LEFT JOIN dbo.VendorMaster VM ON VM.VendorID = DWB.Vendor
        LEFT JOIN dbo.HotelMaster HM ON HM.HotelName = DWB.HotelName

		LEFT JOIN dbo.AgentMaster AM ON AM.AgentID = B.AgentID
		LEFT JOIN EmployeeMaster E ON B.FHE = E.UserID
		--LEFT JOIN CompanyMaster CM ON CM.SAP_CompanyCode = A.SAPCompCode
        WHERE 
			(XO.Qut_ID = @EffectiveBookingID AND XO.Undo=0)
			OR
			(
				ISNULL(@IsDashboard,0)=1 
				AND
				(
					(
						ISNULL(@DashCompanyId,0)<>0
						AND 
						B.CompanyID=@DashCompanyId
					)
					--AND 
					--(
					--	A.Request_Date<=@Today
					--	AND A.Request_Date > @PrevDays
					--)
					AND B.YearID=@DashYearId 
					AND B.FHE=@OperationBy
				)
			)
		order by DWB.GroupKey

        -- Return message
        SELECT '200' AS returnCode, 'Data Found' AS returnMessage;
    END
END
