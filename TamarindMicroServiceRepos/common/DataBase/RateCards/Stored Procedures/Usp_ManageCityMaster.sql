CREATE PROCEDURE [RateCards].[Usp_ManageCityMaster]
AS
--EXEC [RateCards].[Usp_ManageCityMaster]
BEGIN
	SET NOCOUNT ON;
	SELECT [IATACode],[Name],[STDCode],[IsActive]FROM [dbo].[City]
	WHERE IsActive = 1 ORDER BY NAME ASC
END