CREATE PROCEDURE usp_UpdateLastApiCall
    @UserId NVARCHAR(100),
    @LastCallTime DATETIME,
    @Action NVARCHAR(10)
AS
BEGIN
    IF @Action = 'U'
    BEGIN
        UPDATE UserSessionTokens
        SET LastApiCall = @LastCallTime
        WHERE UserId = @UserId
    END
END