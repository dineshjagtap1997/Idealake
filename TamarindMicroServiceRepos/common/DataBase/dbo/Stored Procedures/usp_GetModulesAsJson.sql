create PROCEDURE [dbo].[usp_GetModulesAsJson]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Recursive CTE to fetch all levels of modules (including sub-modules, tabs, sub-tabs, and now level 5)
        WITH Hierarchy AS (
            -- Base level: Select modules
            SELECT 
                ModuleID,
                ModuleName,
                DisplayOrder,
                ParentMenuID,
                Level,
                Type
            FROM Modules
        )

        -- Fetch the top-level modules (ParentMenuID IS NULL)
        SELECT 
            ModuleID AS [ModuleID],
            ModuleName AS [ModuleName],
            DisplayOrder AS [DisplayOrder],
            Level AS [Level],
            Type AS [Type],
            -- Recursively fetch children (sub-modules, tabs, sub-tabs)
            (
                SELECT 
                    SubModule.ModuleID,
                    SubModule.ModuleName,
                    SubModule.DisplayOrder,
                    SubModule.Level,
                    SubModule.Type,
                    -- Recursively fetch tabs (Level 3)
                    (
                        SELECT 
                            Tab.ModuleID,
                            Tab.ModuleName,
                            Tab.DisplayOrder,
                            Tab.Level,
                            Tab.Type,
                            -- Recursively fetch sub-tabs (Level 4)
                            (
                                SELECT 
                                    SubTab.ModuleID,
                                    SubTab.ModuleName,
                                    SubTab.DisplayOrder,
                                    SubTab.Level,
                                    SubTab.Type,
                                    -- Recursively fetch Level 5 children (Level 5)
                                    (
                                        SELECT 
                                            SubTabChild.ModuleID,
                                            SubTabChild.ModuleName,
                                            SubTabChild.DisplayOrder,
                                            SubTabChild.Level,
                                            SubTabChild.Type
                                        FROM Hierarchy AS SubTabChild
                                        WHERE SubTabChild.ParentMenuID = SubTab.ModuleID
                                        FOR JSON PATH
                                    ) AS Level5Children
                                FROM Hierarchy AS SubTab
                                WHERE SubTab.ParentMenuID = Tab.ModuleID
                                FOR JSON PATH
                            ) AS SubTabs
                        FROM Hierarchy AS Tab
                        WHERE Tab.ParentMenuID = SubModule.ModuleID
                        FOR JSON PATH
                    ) AS Tabs
                FROM Hierarchy AS SubModule
                WHERE SubModule.ParentMenuID = Modules.ModuleID
                FOR JSON PATH
            ) AS SubModules
        FROM Hierarchy AS Modules
        WHERE ParentMenuID IS NULL  -- Only get the top-level modules (level 1)
        FOR JSON PATH;

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

        -- Optionally, log the error for debugging
        -- INSERT INTO ErrorLog (ErrorCode, ErrorMessage, ErrorDate) 
        -- VALUES (ERROR_NUMBER(), ERROR_MESSAGE(), GETDATE());
    END CATCH
END;
