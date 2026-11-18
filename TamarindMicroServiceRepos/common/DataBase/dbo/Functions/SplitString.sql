CREATE FUNCTION [dbo].[SplitString]
(
    @Input NVARCHAR(MAX),
    @Delimiter CHAR(1)
)
RETURNS @Items TABLE (Item INT)
AS
BEGIN
    DECLARE @Start INT, @End INT
    SELECT @Start = 1, @End = CHARINDEX(@Delimiter, @Input)
    WHILE @Start <= LEN(@Input)
    BEGIN
        IF @End = 0  
            SET @End = LEN(@Input) + 1

        INSERT INTO @Items(Item)  
        VALUES (CAST(SUBSTRING(@Input, @Start, @End - @Start) AS INT))

        SET @Start = @End + 1
        SET @End = CHARINDEX(@Delimiter, @Input, @Start)
    END
    RETURN
END