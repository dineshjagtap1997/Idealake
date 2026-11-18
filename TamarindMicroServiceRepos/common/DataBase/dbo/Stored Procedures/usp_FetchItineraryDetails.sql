-- =============================================         
-- Author: Albert                                       
-- Create date: 05 june 2024    
-- Description:                   
-- =====================================================  
-- new by neha 10022025
CREATE PROCEDURE [dbo].[usp_FetchItineraryDetails] (
	@ItineraryID INT
	,@FileCode VARCHAR(30) = NULL
	,@EnquiryID VARCHAR(50) = NULL
	,@Country CHAR(4) = NULL
	,@TourDate VARCHAR(10) = NULL
	,@IsDate INT = NULL
	,
	--@HotelType VARCHAR(200) = NULL,    
	@IsActive BIT = 1
	,@Action VARCHAR(10) = NULL,
	@OperationBy Uniqueidentifier = null
	)
AS
BEGIN
	IF @Action = 'S'
	BEGIN
		--SELECT IC.ItineraryID, IC.EnquiryID, IC.FileCode, IC.TourDate, C.Name AS 'CountryName', IC.HotelTypeValue    
		SELECT IC.ItineraryID
			,IC.EnquiryID
			,IC.FileCode
			,IC.TourDate
			,C.Name AS 'CountryName'
		FROM ItineraryCreator IC
		LEFT JOIN Country C ON IC.COUNTRY = C.IATACode
		WHERE (
				IC.ItineraryID = CASE 
					WHEN @ItineraryID IS NOT NULL
						THEN @ItineraryID
					ELSE IC.ItineraryID
					END
				)
			OR (
				IC.FileCode = CASE 
					WHEN @FileCode IS NOT NULL
						THEN @FileCode
					ELSE IC.FileCode
					END
				)
			OR (
				IC.EnquiryID = CASE 
					WHEN @EnquiryID IS NOT NULL
						THEN @EnquiryID
					ELSE IC.EnquiryID
					END
				)
			OR (
				IC.Country = CASE 
					WHEN @Country IS NOT NULL
						THEN @Country
					ELSE IC.Country
					END
				)
		--(CONVERT(VARCHAR(50),IC.TourDate,112) >= CASE WHEN @IsDate IS NOT NULL THEN CONVERT(varchar(50),CAST(@TourDate AS DATETIME),112) ELSE CONVERT(VARCHAR(50),IC.TourDate,112) END) AND    
		--(IC.HotelTypeValue = CASE WHEN @HotelType IS NOT NULL THEN @HotelType ELSE IC.HotelTypeValue END)    
		ORDER BY IC.ItineraryID DESC
	END
	ELSE IF @Action = 'I'
	BEGIN     
   INSERT INTO ItineraryCreator             
   (EnquiryID, FileCode,TourDate, IsActive, Operation, OperationBy, OperationOn, COUNTRY )    
   VALUES (@EnquiryID,@FileCode, @TourDate  ,@IsActive,'INSERT',@OperationBy,GETDATE(), @Country)            
   --SET @Err=''            
   SET @ItineraryID=@@IDENTITY        
	END 
	ELSE IF @Action = 'U'
	BEGIN
		--  SELECT IC.ItineraryID, IC.EnquiryID, IC.FileCode, IC.TourDate, IC.IsActive, IC.OperationBy, IC.COUNTRY AS 'Destination'   
		--FROM ItineraryCreator IC  
		--LEFT JOIN Country C ON IC.COUNTRY = C.IATACode  
		--WHERE IC.ItineraryID = @ItineraryID AND IC.IsActive = 1  
		SELECT ICD.ID
			,ICD.ItineraryID
			,'' AS 'EnquiryID'
			,ICD.DAYS AS 'Days'
			,ICD.TourDate AS 'ItineraryDate'
			,CT1.Name AS 'IATACodeFC'
			,CT1.Name AS 'FromCity'
			,ICD.ArrCity AS 'IATACodeFCHDN'
			,CT2.Name AS 'IATACodeTC'
			,CT2.Name AS 'ToCity'
			,ICD.DeptCity AS 'IATACodeTCHDN'
			,ID.DetailedHeader AS 'HeaderID'
			,ICD.Header AS 'HeaderIDHDN'
			,ID.DetailedHeader AS 'HeaderText'
			,'UPDATE' AS 'DELETE'
			,ICD.UpdatedBy AS 'OperationBy'
			,WeekDay AS 'WeekDay'
		FROM ItineraryCreator_Details ICD
		LEFT JOIN City CT1 ON ICD.ArrCity = CT1.IATACode
		LEFT JOIN City CT2 ON ICD.DeptCity = CT2.IATACode
		LEFT JOIN ItineraryDescription ID ON ICD.Header = ID.ItineraryDescID
		WHERE ICD.itineraryID = @ItineraryID
		--ORDER BY ICD.ID ASC    
		--ORDER BY ICD.DAYS ASC    
		ORDER BY CAST(ICD.DAYS AS INT) ASC
	END
END