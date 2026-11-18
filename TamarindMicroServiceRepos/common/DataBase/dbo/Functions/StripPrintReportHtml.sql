CREATE FUNCTION dbo.StripPrintReportHtml (@Input NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Output NVARCHAR(MAX) = @Input

    -- Replace specific HTML tags
    SET @Output = REPLACE(@Output, '<p>', '')
    SET @Output = REPLACE(@Output, '</p>', '')

    -- Replace HTML non-breaking space
    SET @Output = REPLACE(@Output, '&nbsp;', ' ')

    RETURN @Output
END
