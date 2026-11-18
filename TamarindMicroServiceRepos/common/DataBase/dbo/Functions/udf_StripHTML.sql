CREATE FUNCTION [dbo].[udf_StripHTML] (@HTMLText VARCHAR(MAX))
RETURNS VARCHAR(MAX) AS
BEGIN
    DECLARE @Start INT
    DECLARE @End INT
    DECLARE @Length INT
	set @HTMLText = REPLACE(@HTMLText,'|', '')
	set @HTMLText = REPLACE(@HTMLText,'&nbsp;', '')
	set @HTMLText = REPLACE(REPLACE(REPLACE(REPLACE(@HTMLText, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), CHAR(160), '')
    SET @Start = CHARINDEX('<',@HTMLText)
    SET @End = CHARINDEX('>',@HTMLText,CHARINDEX('<',@HTMLText))
    SET @Length = (@End - @Start) + 1
    WHILE @Start > 0 AND @End > 0 AND @Length > 0
    BEGIN
        SET @HTMLText = STUFF(@HTMLText,@Start,@Length,'')
        SET @Start = CHARINDEX('<',@HTMLText)
        SET @End = CHARINDEX('>',@HTMLText,CHARINDEX('<',@HTMLText))
        SET @Length = (@End - @Start) + 1
    END
	 
    RETURN LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(@HTMLText, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), CHAR(160), '') ))
END
