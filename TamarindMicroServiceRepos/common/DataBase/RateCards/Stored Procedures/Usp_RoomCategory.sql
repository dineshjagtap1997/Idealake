


CREATE PROCEDURE [RateCards].[Usp_RoomCategory]
(
@Action CHAR = NULL
)
--EXEC [RateCards].Usp_RoomCategory @Action='S'
AS 
BEGIN
	--Gets all active transfer data from master table 
	IF @Action = 'S'
	BEGIN 
		SELECT [ID],[Name],[IsActive] FROM [dbo].[RoomCategory]
		WHERE IsActive = 1;
	END
END
