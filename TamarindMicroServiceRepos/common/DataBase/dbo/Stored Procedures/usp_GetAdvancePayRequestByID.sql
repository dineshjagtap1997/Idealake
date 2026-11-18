CREATE PROCEDURE [dbo].[usp_GetAdvancePayRequestByID]
    @Request_ID NVARCHAR(20)
AS
BEGIN
    SELECT 
        Request_ID,
        FileCode,
        GuestName,
        Hotel_Name,
        Vendor_Name,
        XO_Amt,
        GST_Per,
        TaxAmount,
        PayTo,
        Reason_For_Advance
    FROM [dbo].[AdvancePaySendRequest]
    WHERE Request_ID = @Request_ID;
END
