
CREATE PROCEDURE [RateCards].[Get_MOTRate]
(
@Operation VARCHAR(20) = 'GETALL',
@ID BIGINT = 0,
@CardNumber VARCHAR(30) = NULL,
@RateCardModeType VARCHAR(50) = NULL,
@Heading VARCHAR(50) = NULL,
@ContractDate VARCHAR(20) = NULL,
@MOT VARCHAR(20) = NULL,
@Vendor VARCHAR(50) = NULL,
@IsActive BIT = 1,
@PageSize INT = 10,
@PageNumber INT = 1
)
AS
BEGIN
	IF @Operation = 'GETALL' 
	BEGIN
		SET NOCOUNT ON;
		DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
		SELECT mrm.ID
,RateCardNo
,ContractDate
,ValidFrom
,ValidTO
,FromDate
,ToDate
,TravelModeTypeID
,MOTNameORNumber
,Sector
,RateCardModeTypeID
,InformationToOperations
,XORemarks
,mrm.VendorID
,CurrencyCode
,mrm.IsActive
,CompanyID
,YearID
,CreatedBy
,CreatedOn
,ModifiedBy
,ModifiedOn,             
		CASE 
			WHEN mrm.RateCardModeTypeID =1 THEN 'Contract' 
			WHEN mrm.RateCardModeTypeID =2 THEN 'Adhoc' 
			WHEN mrm.RateCardModeTypeID =3 THEN 'Negotiated'      
		END AS 'RateCardMode',mrm.ContractHeading as Heading,
		vm.VendorName AS Vendor,mot.MOT AS TravelMode
		FROM [RateCards].MOTRateMaster mrm             
        INNER JOIN dbo.VendorMaster vm ON mrm.VendorID = vm.VendorID
		LEFT JOIN [dbo].[MOT] mot ON mot.ID = mrm.TravelModeTypeID
		WHERE 
		((@CardNumber IS NULL OR @CardNumber = '') OR mrm.RateCardNo LIKE '%' + @CardNumber + '%')
            AND ((@RateCardModeType IS NULL OR @RateCardModeType = '') OR 
                (mrm.RateCardModeTypeID = 
                    CASE 
                        WHEN @RateCardModeType = 'Contract' THEN 1
                        WHEN @RateCardModeType = 'Adhoc' THEN 2
                        WHEN @RateCardModeType = 'Negotiated' THEN 3
                        ELSE NULL
                    END
                )
            )
            AND ((@Heading IS NULL OR @Heading = '') OR mrm.ContractHeading LIKE '%' + @Heading + '%')
            AND ((@ContractDate IS NULL OR @ContractDate = '') OR CONVERT(VARCHAR, mrm.ContractDate, 23) = @ContractDate)
            AND ((@MOT IS NULL OR @MOT = '') OR mot.MOT LIKE '%' + @MOT + '%')
            AND ((@Vendor IS NULL OR @Vendor = '') OR vm.VendorName LIKE '%' + @Vendor + '%')
		AND  mrm.IsActive= @IsActive AND mot.IsActive = 1
		ORDER BY mrm.CreatedOn DESC     
		OFFSET @Offset ROWS
		FETCH NEXT @PageSize ROWS ONLY;
	END

	IF @Operation = 'GETBYID' 
	BEGIN
		SET NOCOUNT ON;
		SELECT ID
,RateCardNo
,ContractDate
,ValidFrom
,ValidTO
,FromDate
,ToDate
,ContractHeading
,TravelModeTypeID
,MOTNameORNumber
,Sector
,RateCardModeTypeID
,InformationToOperations
,XORemarks
,VendorID
,CurrencyCode
,IsActive
,CompanyID
,YearID
,CreatedBy
,CreatedOn
,ModifiedBy
,ModifiedOn
		FROM [RateCards].MOTRateMaster mrm             
		WHERE mrm.ID = @ID
	END
	IF @Operation = 'GETDETAIL_BYID' 
	BEGIN
		SET NOCOUNT ON;
		SELECT 
		MOTRateDetailID
,ClassTypeID
,ValidFrom
,ValidTo
,MISSequence
,IsActive
,CreatedOn
,UpdatedOn
,MOTRateID
,ApplicableTo
,Description
,CreatedBy
,UpdatedBy
		FROM [RateCards].MOTRateDetail mrd
		WHERE mrd.MOTRateDetailID = @ID

		SELECT mrcd.MotRateCommissionDetailID,mrcd.MOTRateDetailID,mrcd.CategoryID,mrcd.Tax,mrcd.TaxAmount,mrcd.NetAmountExcludingTax,
		mrcd.NetAmountIncludingTax
		FROM [RateCards].MOTRateCommissionDetail mrcd
		WHERE mrcd.MOTRateDetailID = @ID

	END
	IF @Operation = 'GETALLDETAILS_BYID' 
	BEGIN
		--SELECT * FROM [dbo].[ClassType]
		SET NOCOUNT ON;
		SELECT MOTRateDetailID
,ClassTypeID
,ValidFrom
,ValidTo
,MISSequence
,mrd.IsActive
,CreatedOn
,mrd.UpdatedOn
,MOTRateID
,ApplicableTo
,Description
,CreatedBy
,mrd.UpdatedBy
		FROM [RateCards].MOTRateDetail mrd
		LEFT JOIN [dbo].[ClassType] ct ON ct.ID = mrd.ClassTypeID
		WHERE mrd.MOTRateID = @ID

	END
	IF @Operation = 'GETCOMMISSION_BYID' 
	BEGIN
		SET NOCOUNT ON;
		SELECT mrcd.MotRateCommissionDetailID,mrcd.MOTRateDetailID,mrcd.CategoryID,cm.Category,mrcd.Tax,mrcd.TaxAmount,mrcd.NetAmountExcludingTax,
		mrcd.NetAmountIncludingTax,RCM.RateType,mrcd.CommissionMasterID
		FROM [RateCards].MOTRateCommissionDetail mrcd
		LEFT JOIN dbo.CategoryMaster cm ON cm.CategoryTypeID = mrcd.CategoryID
		LEFT JOIN dbo.RateCommissionMaster Rcm ON Rcm.CommMasterID = mrcd.CommissionMasterID

		WHERE mrcd.IsActive  = 1 AND mrcd.MOTRateDetailID = @ID
		ORDER BY mrcd.CreatedOn DESC
	END
END