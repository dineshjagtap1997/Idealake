CREATE PROCEDURE [Quotation].[usp_SaveQuotation]
    @QuotationID BIGINT = NULL,
    @Status INT= NULL,
    @CreatedBy UNIQUEIDENTIFIER= NULL,
<<<<<<< HEAD
<<<<<<< HEAD
    @RateCardUpdates [Quotation].[RateCardUpdateType] READONLY
=======
    @RateCardUpdates [Quotation].[RateCardUpdateType] READONLY,
	 @GuideRateCardUpdates [Quotation].[GuideRateCardUpdateType] READONLY
>>>>>>> dev
=======
    @RateCardUpdates [Quotation].[RateCardUpdateType] READONLY,
	 @GuideRateCardUpdates [Quotation].[GuideRateCardUpdateType] READONLY
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
AS
BEGIN
    SET NOCOUNT ON;

    -- Update main quotation
    UPDATE [Quotation].[QuotationMaster]
    SET
        Status = ISNULL(@Status, Status),
        UpdatedBy = @CreatedBy,
        UpdatedDate = GETDATE()
    WHERE 
        QuotationID = @QuotationID;

  UPDATE HRM
SET
    HRM.ShowAnnouncement     = ISNULL(RC.ShowAnnouncement, HRM.ShowAnnouncement),
    HRM.ShowTransfers        = ISNULL(RC.ShowTransfers, HRM.ShowTransfers),
    HRM.ShowValueAddOns      = ISNULL(RC.ShowValueAddOns, HRM.ShowValueAddOns),
    HRM.ShowCancellationDays = ISNULL(RC.ShowCancellationDays, HRM.ShowCancellationDays),
	UpdatedBy = @CreatedBy,
        UpdatedOn = GETDATE()
FROM [Quotation].[HotelRateCardMaster] HRM
INNER JOIN @RateCardUpdates RC ON RC.QuotationRateCardId = HRM.ID
WHERE HRM.QuotationID = @QuotationID;

<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

  UPDATE ORM
SET
    
    ORM.ShowValueAddOns      = ISNULL(OC.ShowValueAddOns, ORM.ShowValueAddOns),
    
	UpdatedBy = @CreatedBy,
        UpdatedOn = GETDATE()
FROM [Quotation].OthersRateCardMaster ORM
INNER JOIN @GuideRateCardUpdates OC ON OC.QuotationRateCardId = ORM.ID
WHERE ORM.QuotationID = @QuotationID and RateType =1;

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    SELECT 
        '200' AS returnCode,
        'Records updated successfully' AS returnMessage,
        @QuotationID AS ID;
END
