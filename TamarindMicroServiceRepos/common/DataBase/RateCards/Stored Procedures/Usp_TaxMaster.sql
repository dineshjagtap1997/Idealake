
CREATE PROCEDURE [RateCards].[Usp_TaxMaster]
(
@Action CHAR = NULL
)
--EXEC [RateCards].[Usp_TaxMaster] @Action='S'
AS 
BEGIN
	--Gets all active transfer data from master table 
	IF @Action = 'S'
	BEGIN 
		SET NOCOUNT OFF;
		SELECT taxID as TaxID,taxValue AS TaxValue FROM [dbo].Tax_Percentage
	END
END
