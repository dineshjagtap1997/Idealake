CREATE FUNCTION [dbo].[fn_IsDayEnabled] (
    @code VARCHAR(7),  
    @date DATE
)
RETURNS BIT
AS
BEGIN
    DECLARE @position INT;
    DECLARE @result BIT;

    -- Adjust weekday so Monday = 1, Sunday = 7 regardless of server DATEFIRST
    SET @position = (DATEPART(WEEKDAY, @date) + @@DATEFIRST - 2) % 7 + 1;

    -- Get the corresponding bit from the code
    SET @result = CASE SUBSTRING(@code, @position, 1)
                    WHEN '1' THEN 1
                    ELSE 0
                  END;

    RETURN @result;
END;