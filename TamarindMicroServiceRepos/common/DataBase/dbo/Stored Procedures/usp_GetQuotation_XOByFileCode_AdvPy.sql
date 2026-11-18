CREATE PROCEDURE [dbo].[usp_GetQuotation_XOByFileCode_AdvPy]
(
    @FileCode VARCHAR(50),
    @companyID VARCHAR(50),
    @XOID VARCHAR(20),
    @QuotationID INT,
    @Action CHAR(2) = 's'
)
AS
BEGIN
    IF @Action = 's'
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM XO X
            INNER JOIN Quotation Q ON X.Qut_ID = Q.QuotationID
            WHERE Q.FileCode = @FileCode
              AND Q.CompanyID = @companyID
              AND X.XO_ID = @XOID
              AND (X.IsDirectPayment IS NULL OR X.IsDirectPayment = 0)
              AND X.Undo IS NULL
        )
        BEGIN
            SELECT TOP 1 
                C.SAP_CompanyCode AS SAPCompCode,
                '' AS Request_ID,
                '' AS Request_Date,
                '' AS Requested_By,
                '' AS FileHandler,
                B.FileCode,
                C.CityIATACode AS Filebranch,
                X.XO_ID,
                X.Curr_Id,
                '' AS AmtToBeReleased,
                '' AS ModeOfPay,
                X.XO_Customer_Name AS GuestName,
                Q.AgentName,
                'False' AS AgentCredit,
                H.HotelName,
                V.VendorName,
                '' AS PayTo,
                '' AS HotelVendorCredit,
                CONVERT(VARCHAR, XI.ArrivalDate, 103) AS [Check-in],
                CONVERT(VARCHAR, XI.DepartureDate, 103) AS [Check-out],
                XIM.Invoice_ID AS TACInvNo,
                I.Invoice_Total AS TACInvAmt,
                ((2 * I.Invoice_Curr_Amt) / 100) AS TDS,
                X.xo_amt AS VoucherAmt,
                '' AS [GST%],
                '' AS [GST Amt],
                '' AS VendorBillAmt,
                X.IsBTCComm,
                CASE WHEN (V.VendorName IS NULL OR V.VendorName = '') THEN H.ChequeFavouring ELSE V.ChequeFavouring END AS ChequeFavouring,
                CASE WHEN (V.VendorName IS NULL OR V.VendorName = '') THEN H.AccountNo ELSE V.AccountNo END AS AccountNo,
                CASE WHEN (V.VendorName IS NULL OR V.VendorName = '') THEN H.ChequeFavouring ELSE V.ChequeFavouring END AS Bank_Account_Name,
                CASE WHEN (V.VendorName IS NULL OR V.VendorName = '') THEN H.BankName ELSE V.BankName END AS BankName,
                CASE WHEN (V.VendorName IS NULL OR V.VendorName = '') THEN H.IFSCCode ELSE V.IFSCCode END AS IFSCCode,
                CASE WHEN (V.VendorName IS NULL OR V.VendorName = '') THEN H.HotelSAPCode ELSE V.VendorSAPCode END AS VendorSAPCode,
                '' AS BizVertical,
                X.CompName AS XOLocation,
                '' AS ApprovedBy,
                '' AS ReasonForadvance,
                CM.SAP_BusinessPlaceCode AS SAPXOBizPlaceCode,
                Q.QuotationID,
                CONVERT(VARCHAR, GETDATE(), 103) AS Emaildate,
                '' AS Status,
                '' AS AstraEntry,
                XI.DepartureDate,
                XI.ArrivalDate,
                '' AS PaymentRecd,
                '' AS Remarks,
                '' AS [CC Charge Date],
                '' AS [CC ChargedAmt],
               -- Am.CreditApplicable,
                HotelVendorFlag,
                H.CreditApplicable AS HotelCredit,
                V.CreditApplicable AS VendorCredit,
                '' AS DOCID
            FROM XO X
            INNER JOIN Booking.tbl_Booking B ON X.Qut_ID = B.ID
			left JOIN Quotation.QuotationMaster Q ON Q.QuotationID = B.QuotationID
            LEFT JOIN CompanyMaster C ON Q.CompanyID = C.CompanyID
            LEFT JOIN CompanyMaster CM ON X.CompName = CM.CityIATaCode AND CM.IsActive = 1
            LEFT JOIN AgentMaster A ON B.AgentID = A.AgentID
            LEFT JOIN HotelMaster H ON X.HotelCode = H.HotelCode
            LEFT JOIN VendorMaster V ON X.VendorCode = V.VendorCode
            LEFT JOIN AccountsBankMaster AH ON H.BankAccountID = AH.AccountBankMasterID
            LEFT JOIN AccountsBankMaster AV ON V.BankAccountID = AV.AccountBankMasterID
            LEFT JOIN XOInvoiceMapping XIM ON X.XO_ID = XIM.XO_ID AND X.Qut_ID = XIM.Qut_ID
            LEFT JOIN XO_Instructions XI ON X.XO_ID = XI.XO_ID AND X.Qut_ID = XI.Qut_ID
            LEFT JOIN Invoice_new I ON XIM.Invoice_ID = I.Invoice_ID AND XIM.Qut_ID = I.Qut_ID
            WHERE B.FileCode = @FileCode
              AND Q.CompanyID = @companyID
              AND X.XO_ID = @XOID
              AND (X.IsDirectPayment IS NULL OR X.IsDirectPayment = 0)
              AND X.Undo IS NULL
        END
        ELSE
        BEGIN
            -- Return empty/default row
            --SELECT 
            --    '' AS SAPCompCode,
            --    '' AS Request_ID,
            --    '' AS Request_Date,
            --    '' AS Requested_By,
            --    '' AS FileHandler,
            --    '' AS FileCode,
            --    '' AS Filebranch,
            --    '' AS XO_ID,
            --    '' AS Curr_Id,
            --    '' AS AmtToBeReleased,
            --    '' AS ModeOfPay,
            --    '' AS GuestName,
            --    '' AS AgentName,
            --    'False' AS AgentCredit,
            --    '' AS HotelName,
            --    '' AS VendorName,
            --    '' AS PayTo,
            --    '' AS HotelVendorCredit,
            --    '' AS [Check-in],
            --    '' AS [Check-out],
            --    '' AS TACInvNo,
            --    0 AS TACInvAmt,
            --    0 AS TDS,
            --    0 AS VoucherAmt,
            --    '' AS [GST%],
            --    '' AS [GST Amt],
            --    '' AS VendorBillAmt,
            --    NULL AS IsBTCComm,
            --    '' AS ChequeFavouring,
            --    '' AS AccountNo,
            --    '' AS Bank_Account_Name,
            --    '' AS BankName,
            --    '' AS IFSCCode,
            --    '' AS VendorSAPCode,
            --    '' AS BizVertical,
            --    '' AS XOLocation,
            --    '' AS ApprovedBy,
            --    '' AS ReasonForadvance,
            --    '' AS SAPXOBizPlaceCode,
            --    0 AS QuotationID,
            --    CONVERT(VARCHAR, GETDATE(), 103) AS Emaildate,
            --    '' AS Status,
            --    '' AS AstraEntry,
            --    NULL AS DepartureDate,
            --    NULL AS ArrivalDate,
            --    '' AS PaymentRecd,
            --    '' AS Remarks,
            --    '' AS [CC Charge Date],
            --    '' AS [CC ChargedAmt],
            --    NULL AS CreditApplicable,
            --    NULL AS HotelVendorFlag,
            --    NULL AS HotelCredit,
            --    NULL AS VendorCredit,
            --    '' AS DOCID
      --  END

        SELECT '200' AS returnCode, 'Data Found' AS returnMessage;
    END
END
end
