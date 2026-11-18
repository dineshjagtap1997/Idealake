create PROCEDURE [dbo].[usp_GetModulesHierarchy]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Fetch all modules, sub-modules, tabs, and sub-tabs in a flat structure
        SELECT 
            ModuleID,
            ModuleName,
            DisplayOrder,
            Level,
            Type,
            ParentMenuID
        FROM Modules
        ORDER BY ParentMenuID, DisplayOrder;

        -- Return success metadata
        SELECT 
            '200' AS returnCode,
            'Data Retrieved Successfully' AS returnMessage;
    END TRY
    BEGIN CATCH
        -- Return error metadata
        SELECT 
            '201' AS returnCode,
            'Error in Retrieving Data' AS returnMessage;
    END CATCH
END;
