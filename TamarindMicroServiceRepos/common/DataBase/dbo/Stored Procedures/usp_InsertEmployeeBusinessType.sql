CREATE PROCEDURE [dbo].[usp_InsertEmployeeBusinessType]
(
    @EmpID INT,
    @BusinessTypeIDs VARCHAR(MAX) -- Comma-separated list of BusinessTypeIDs
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Table variable to hold BusinessType IDs after splitting
    DECLARE @BusinessTypeIDTable TABLE (BusinessTypeID INT);

    -- Split BusinessTypeIDs and insert into table variable
    INSERT INTO @BusinessTypeIDTable (BusinessTypeID)
    SELECT value FROM STRING_SPLIT(@BusinessTypeIDs, ',');

    -- Delete existing mappings for EmpID (to refresh the assigned business types)
    DELETE FROM EmployeeBusinessTypeMap WHERE EmpID = @EmpID;

    -- Insert new mappings
    INSERT INTO EmployeeBusinessTypeMap (EmpID, BusinessTypeID)
    SELECT @EmpID, BusinessTypeID FROM @BusinessTypeIDTable;

    -- Return response
    --SELECT '200' AS returnCode, 'Business Types Updated Successfully' AS returnMessage;
END;