


CREATE PROCEDURE [RateCards].[Usp_Meals]
(
@Action CHAR = NULL
)
--EXEC [RateCards].Usp_Meals @Action='S'
AS 
BEGIN
	--Gets all active transfer data from master table 
	IF @Action = 'S'
	BEGIN 
		SELECT [ID],[Code],[Description],[Breakfast],[Lunch],[Dinner],[IsActive] FROM [dbo].[MealPlan]
		WHERE IsActive = 1;
	END
END
