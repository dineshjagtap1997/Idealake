CREATE PROCEDURE [RateCards].[Usp_GetRateRules]
(
@Operation VARCHAR(30) = 'GETALL',
@ID BIGINT NULL,
@RateCardID BIGINT NULL,
@RateCardTypeID INT = 0
)
AS
BEGIN
	IF @Operation = 'GETALL'
		BEGIN
			SELECT rul.ID,rul.RateCardTypeID,rul.RateCardID,rul.RuleID,rg.Header AS [Rule],rul.MISSeqeunce AS MISSequence,
			CASE WHEN rul.ApplicableID = '1' THEN 'ALL' 
				WHEN rul.ApplicableID = '2' THEN 'B2B Agent'
				WHEN rul.ApplicableID = '3' THEN 'Operations'
			END AS Applicable,
			rul.ApplicableID,rul.[Description],rul.IsActive 
			FROM RateCards.Rules rul
			LEFT JOIN dbo.Rules rg ON rg.ID = rul.RuleID
<<<<<<< HEAD
<<<<<<< HEAD
			WHERE rul.RateCardID = @RateCardID AND rul.RateCardTypeID = @RateCardTypeID
=======
			WHERE rul.RateCardID = @RateCardID 
			AND rul.RateCardTypeID = @RateCardTypeID
>>>>>>> dev
=======
			WHERE rul.RateCardID = @RateCardID 
			AND rul.RateCardTypeID = @RateCardTypeID
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			ORDER BY  rul.MISSeqeunce Asc
		END
	IF @Operation = 'GETBYID' AND @ID > 0
		BEGIN
			SELECT RateCardTypeID,RateCardID,RuleID,'' AS [Rule],MISSeqeunce AS MISSequence,'' AS Applicable,ApplicableID,[Description],IsActive 
			FROM RateCards.Rules WHERE ID = @ID
		END
<<<<<<< HEAD
<<<<<<< HEAD
END
=======
END
>>>>>>> dev
=======
END
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
