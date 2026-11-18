
CREATE PROCEDURE [dbo].[usp_GetAllAgentData]
(
    @TableName NVARCHAR(500) = 'QuotationMaster'
)
AS
BEGIN

    DECLARE @SQL NVARCHAR(MAX)

    -- Basic validation to avoid SQL injection
    IF OBJECT_ID(@TableName) IS NULL
    BEGIN
        RAISERROR('Table does not exist.', 16, 1)
        RETURN
    END

    -- Construct dynamic SQL
<<<<<<< HEAD
<<<<<<< HEAD
    SET @SQL = N'SELECT * FROM ' + QUOTENAME(@TableName)
=======
    SET @SQL = N'SELECT * FROM Quotation Where  QuotationID > 586875'   --+ QUOTENAME(@TableName) 
>>>>>>> dev
=======
    SET @SQL = N'SELECT * FROM Quotation Where  QuotationID > 586875'   --+ QUOTENAME(@TableName) 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

	print @SQL 
    -- Execute the SQL
    EXEC sp_executesql @SQL
END



--ALTER PROCEDURE [dbo].[usp_GetAllAgentData]
--(
--    @TableName NVARCHAR(500) = 'PLBMaster'
--)
--AS
--BEGIN
--    DECLARE @FullTableName NVARCHAR(512)
--    DECLARE @SQL NVARCHAR(MAX)

--    -- Construct full table name with schema (assume dbo if not provided)
--    IF CHARINDEX('.', @TableName) = 0
--        SET @FullTableName = 'dbo.' + @TableName
--    ELSE
--        SET @FullTableName = @TableName

--    -- Validate table existence using full name
--    IF OBJECT_ID(@FullTableName, 'U') IS NULL
--    BEGIN
--        RAISERROR('Table does not exist.', 16, 1)
--        RETURN
--    END


--    -- Construct dynamic SQL safely
--    SET @SQL = N'SELECT * FROM ' + QUOTENAME(PARSENAME(@FullTableName, 2)) + '.' + QUOTENAME(PARSENAME(@FullTableName, 1))
	
--	print @SQL 

--    EXEC sp_executesql @SQL
--END


--ALTER PROCEDURE [dbo].[usp_GetAllAgentData]
--(
--    @TableName NVARCHAR(500)
--)
--AS
--BEGIN
--    DECLARE @SchemaName NVARCHAR(128)
--    DECLARE @OnlyTableName NVARCHAR(128)
--    DECLARE @SQL NVARCHAR(MAX)

--    -- Parse schema and table name
--    SET @SchemaName = PARSENAME(@TableName, 2)
--    SET @OnlyTableName = PARSENAME(@TableName, 1)

--    IF @SchemaName IS NULL OR @OnlyTableName IS NULL
--    BEGIN
--        RAISERROR('Invalid table name format. Must be schema.table', 16, 1)
--        RETURN
--    END

--    -- Validate if table exists
--    IF OBJECT_ID(QUOTENAME(@SchemaName) + '.' + QUOTENAME(@OnlyTableName), 'U') IS NULL
--    BEGIN
--        RAISERROR('Table does not exist: %s', 16, 1, @TableName)
--        RETURN
--    END

--    -- Build dynamic SQL
--    SET @SQL = N'SELECT * FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@OnlyTableName)

--    EXEC sp_executesql @SQL
--END
