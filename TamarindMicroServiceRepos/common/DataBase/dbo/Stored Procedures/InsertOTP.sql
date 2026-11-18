CREATE PROCEDURE dbo.InsertOTP (
	@otp_value INT
	,@UserID VARCHAR(500)
	,@Action CHAR(2)
	)
AS
BEGIN
	IF @Action = 'I'
	BEGIN
		INSERT INTO tbl_OTP (
			OTP
			,CreatedON
			,USerID
			)
		VALUES (
			@otp_value
			,GETDATE()
			,@UserID
			);
	END
	ELSE IF @Action = 'V'
	BEGIN
		DECLARE @Valid INT

		SELECT @Valid = count(*)
		FROM tbl_otp
		WHERE Createdon > DATEADD(minute, - 5, GetDate())
			AND Userid = @UserID
			AND OTP = @otp_value

		IF (@Valid > 0)
		BEGIN
			SELECT 'Success'
		END
		ELSE
		BEGIN
			SELECT 'OTP Validation Faild'
		END
	END
END