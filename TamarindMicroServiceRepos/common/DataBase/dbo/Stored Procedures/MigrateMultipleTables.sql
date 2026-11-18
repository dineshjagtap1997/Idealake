
CREATE PROCEDURE dbo.MigrateMultipleTables
    @Mappings dbo.TableMappingType READONLY
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SrcDB NVARCHAR(128),
            @SrcTable NVARCHAR(128),
            @DstDB NVARCHAR(128),
            @DstTable NVARCHAR(128),
            @TopRecords INT,
            @SQL NVARCHAR(MAX),
            @IdentitySQL NVARCHAR(MAX);

    -- Cursor to iterate through table mappings
    DECLARE mapping_cursor CURSOR FOR
    SELECT SourceDatabase, SourceTable, DestinationDatabase, DestinationTable, TopRecords
    FROM @Mappings;

    OPEN mapping_cursor;
    FETCH NEXT FROM mapping_cursor INTO @SrcDB, @SrcTable, @DstDB, @DstTable, @TopRecords;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            -- Enable IDENTITY_INSERT for the destination table
            SET @IdentitySQL = 'SET IDENTITY_INSERT [' + @DstDB + ']..[' + @DstTable + '] ON';
            EXEC sp_executesql @IdentitySQL;

            -- Build dynamic SQL for data migration
            SET @SQL = N'
                INSERT INTO [' + @DstDB + ']..[' + @DstTable + '] (
                    AccCode, AgentCode, AgentName, CategoryID, Miscellaneous, GroupID, MarketID, City_IATACode,
                    Website, PhoneNo, MobileNo, FaxNo, EmailID, PanNo, STRegNo, ChequeFavouring,
                    Address, CreateAdvanceAccount, CreditApplicable, CreditCurrencyCode,
                    CreditAllowance, Threshold, CreditPeriod, OutStandingAmount,
                    UnlimitedCredit, IsActive, IsOtherBooking, Operation,
                    OperationBy, OperationOn, OldID /* Add other columns as needed */
                )
                SELECT TOP (' + CAST(@TopRecords AS NVARCHAR(10)) + ') 
                    AccCode, AgentCode, AgentName, CategoryID /* Add other columns as needed */
                FROM [' + @SrcDB + ']..[' + @SrcTable + ']';

            -- Execute the dynamic SQL
            EXEC sp_executesql @SQL;

            -- Disable IDENTITY_INSERT for the destination table
            SET @IdentitySQL = 'SET IDENTITY_INSERT [' + @DstDB + ']..[' + @DstTable + '] OFF';
            EXEC sp_executesql @IdentitySQL;

            PRINT 'Migrated ' + CAST(@TopRecords AS NVARCHAR) +
                  ' records from ' + @SrcDB + '.' + @SrcTable +
                  ' to ' + @DstDB + '.' + @DstTable;
        END TRY
        BEGIN CATCH
            PRINT ERROR_MESSAGE();
            PRINT 'Failed to migrate: ' + @SrcDB + '.' + @SrcTable;

            -- Ensure IDENTITY_INSERT is turned off in case of error
            SET @IdentitySQL = 'SET IDENTITY_INSERT [' + @DstDB + ']..[' + @DstTable + '] OFF';
            EXEC sp_executesql @IdentitySQL;
        END CATCH

        FETCH NEXT FROM mapping_cursor INTO @SrcDB, @SrcTable, @DstDB, @DstTable, @TopRecords;
    END

    CLOSE mapping_cursor;
    DEALLOCATE mapping_cursor;
END;
