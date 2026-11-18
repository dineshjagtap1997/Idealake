CREATE PROCEDURE [dbo].[usp_InsertEmployeeMarketMap]
(
    @EmpID INT,
    @MarketIDs VARCHAR(MAX) -- Comma-separated list of MarketIDs
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Table variable to hold Market IDs after splitting
    DECLARE @MarketIDTable TABLE (MarketID INT);

    -- Split MarketIDs and insert into table variable
    INSERT INTO @MarketIDTable (MarketID)
    SELECT value FROM STRING_SPLIT(@MarketIDs, ',');

    -- Delete existing mappings for EmpID (to refresh the assigned markets)
    DELETE FROM EmployeeMarketMap WHERE EmpID = @EmpID;

    -- Insert new mappings
    INSERT INTO EmployeeMarketMap (EmpID, MarketID)
    SELECT @EmpID, MarketID FROM @MarketIDTable;

    -- Return response
    --SELECT '200' AS returnCode, 'Markets Updated Successfully' AS returnMessage;
END;