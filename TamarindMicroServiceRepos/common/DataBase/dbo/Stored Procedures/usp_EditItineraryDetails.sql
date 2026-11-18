
-- =============================================     
-- Author: Albert                                   
-- Create date: 08 Jul 2024
-- Description:               
-- =====================================================     
create PROCEDURE [dbo].[usp_EditItineraryDetails]      
(
	@ItineraryID INT
)
AS   
BEGIN      
	SELECT IC.ItineraryID, IC.EnquiryID, IC.FileCode, IC.TourDate, IC.IsActive, IC.OperationBy, IC.COUNTRY AS 'Destination' 
	FROM ItineraryCreator IC
	LEFT JOIN Country C ON IC.COUNTRY = C.IATACode
	WHERE IC.ItineraryID = @ItineraryID AND IC.IsActive = 1

	SELECT ICD.ID,
	 ICD.ItineraryID, '' AS 'EnquiryID', ICD.DAYS AS 'Days',  ICD.TourDate AS 'ItineraryDate'  ,  CT1.Name AS 'IATACodeFC', CT1.Name  as 'FromCity', ICD.ArrCity as 'IATACodeFCHDN' ,
	   CT2.Name AS 'IATACodeTC',CT2.Name as 'ToCity',  ICD.DeptCity as 'IATACodeTCHDN',
	ID.DetailedHeader AS 'HeaderID',  ICD.Header AS 'HeaderIDHDN',   ID.DetailedHeader as  'HeaderText',   'UPDATE'AS  'DELETE',  ICD.UpdatedBy AS 'OperationBy', WeekDay  as 'WeekDay'  
	FROM ItineraryCreator_Details ICD 
	LEFT JOIN City CT1 ON ICD.ArrCity = CT1.IATACode
	LEFT JOIN City CT2 ON ICD.DeptCity = CT2.IATACode
	 LEFT JOIN ItineraryDescription ID ON ICD.Header = ID.ItineraryDescID 
	WHERE ICD.itineraryID = @ItineraryID 
	--ORDER BY ICD.ID ASC		
	--ORDER BY ICD.DAYS ASC		
	ORDER BY CAST(ICD.DAYS AS INT)ASC
END 

