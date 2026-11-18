<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE GetReportTypes
@Action char(2)=''
AS
BEGIN
IF @Action='S'
BEGIN
    SELECT ID, ReportTypeValue, ReportTypeName
    FROM ReportType
    ORDER BY ReportTypeValue;
END 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿CREATE PROCEDURE GetReportTypes @Action CHAR(2) = ''
AS
BEGIN
	IF @Action = 'S'
	BEGIN
		SELECT ID
			,ReportTypeValue
			,ReportTypeName
		FROM ReportType
		ORDER BY ReportTypeValue;
	END
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END