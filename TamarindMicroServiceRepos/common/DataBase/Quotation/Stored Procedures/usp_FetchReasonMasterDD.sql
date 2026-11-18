CREATE Procedure [Quotation].[usp_FetchReasonMasterDD]
	@Action char(1)=null
AS
BEGIN
	IF(@Action='S')
		BEGIN
			Select
				ID,
				Reason
			FROM
				Quotation.ReasonMaster
			Where
				isActive=1
		END
END