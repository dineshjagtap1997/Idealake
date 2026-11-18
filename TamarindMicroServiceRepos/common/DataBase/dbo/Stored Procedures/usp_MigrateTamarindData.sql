
CREATE PROCEDURE usp_MigrateTamarindData

AS
BEGIN


	DECLARE @DstDatabaseName NVARCHAR(128);
	DECLARE @DstTableName NVARCHAR(128);

	-- Set Destination database and table names
	SET @DstDatabaseName = 'Tamarind_V_1';  
	SET @DstTableName = 'AgentMaster';  

		DECLARE @SrcDatabaseName NVARCHAR(128);
	DECLARE @SrcTableName NVARCHAR(128);

	-- Set Source database and table names
	SET @SrcDatabaseName = 'tamarind_devdb';  
	SET @SrcTableName = 'AgentMaster';  

DECLARE @TableName NVARCHAR(100)
DECLARE TableCursor CURSOR FOR 
SELECT TABLE_NAME FROM tamarind_devdb.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'AgentMaster'

OPEN TableCursor
FETCH NEXT FROM TableCursor INTO @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '-- Migrating table: ' + @TableName

    -- Auto-generate column list (only if columns match or are subset)
    DECLARE @cols NVARCHAR(MAX)
    SELECT @cols = STRING_AGG(COLUMN_NAME, ', ') 
    FROM tamarind_devdb.INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = @TableName

    DECLARE @sql NVARCHAR(MAX) = '
    INSERT INTO tamarind_uatdb.dbo.' + @TableName + ' (' + @cols + ')
    SELECT ' + @cols + ' FROM tamarind_devdb.dbo.' + @TableName + ' where AgentID Between 300 and 350;'

    PRINT @sql
    EXEC sp_executesql @sql -- Uncomment after testing

    FETCH NEXT FROM TableCursor INTO @TableName
END

CLOSE TableCursor
DEALLOCATE TableCursor


END
