CREATE FUNCTION [dbo].[fn_GetNetAmountForSupplier]
(
    @SupplierTax_InCluding BIT,
    @QuotationHotelRateID INT,
	@CommissionMasterID int
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @NetAmount DECIMAL(18, 2);

    SELECT @NetAmount = 
        CASE 
            WHEN ISNULL(@SupplierTax_InCluding, 0) = 0 THEN NetAmountExcludingTax
            WHEN ISNULL(@SupplierTax_InCluding, 0) = 1 THEN NetAmountIncludingTax
        END
    FROM Booking.HotelRateCommissionDetailsBooking
    WHERE CommissionMasterID = @CommissionMasterID
	AND QuotationHotelRateID = @QuotationHotelRateID;

    RETURN @NetAmount;
END;
