


CREATE PROCEDURE [RateCards].[Usp_Transfer]
(
@Action CHAR = NULL
)
--EXEC [RateCards].Usp_Transfer @Action='S'
AS 
BEGIN
	--Gets all active transfer data from master table 
	IF @Action = 'S'
	BEGIN 
		SELECT TransferID,TransferCode,TransferValue,IsActive FROM [dbo].[TransferMaster]
		WHERE IsActive = 1 ORDER BY SequenceNo ASC;
	END
END
