CREATE PROCEDURE [RateCards].[Usp_GetVendorsMaster]
AS
--EXEC [RateCards].[Usp_GetVendorsMaster]
BEGIN
	SET NOCOUNT ON;
	SELECT VendorID,VendorCode,VendorName FROM [dbo].[VendorMaster] WHERE [IsActive] = 1
END