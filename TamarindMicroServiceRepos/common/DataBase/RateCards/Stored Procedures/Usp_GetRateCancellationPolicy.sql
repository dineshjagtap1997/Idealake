CREATE PROCEDURE [RateCards].[Usp_GetRateCancellationPolicy]
(
@Operation VARCHAR(30) = 'GETALL',
@PolicyID BIGINT NULL,
@RateCardID BIGINT NULL
)
AS
BEGIN
	IF @Operation = 'GETALL' AND @RateCardID > 0
		BEGIN
			SELECT PolicyID,RateCardTypeID,RateCardID,ValidFrom,ValidTo,TsStart,TsEnd,AgentStart,AgentEnd,ChangePercent,ChargeNight,IsActive 
			FROM RateCards.CancellationPolicy WHERE RateCardID = @RateCardID
			ORDER BY PolicyID DESC
		END
	IF @Operation = 'GETBYID' AND @PolicyID > 0 AND @RateCardID > 0
		BEGIN
			SELECT PolicyID,RateCardTypeID,RateCardID,ValidFrom,ValidTo,TsStart,TsEnd,AgentStart,AgentEnd,ChangePercent,ChargeNight,IsActive
			FROM RateCards.CancellationPolicy WHERE PolicyID = @PolicyID and RateCardID = @RateCardID
		END
END