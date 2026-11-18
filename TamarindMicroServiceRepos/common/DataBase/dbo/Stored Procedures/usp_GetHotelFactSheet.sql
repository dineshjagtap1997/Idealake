-- NEW BY NEHA    
    
CREATE PROCEDURE [dbo].[usp_GetHotelFactSheet]       
(      
    @HotelID INT = 0,      
    @ParentID INT = 0,      
    @ParentPageType INT = 0      
)      
AS      
BEGIN     
    
    SELECT         
        HM.HotelID,         
        HM.HotelName,         
        HM.Address,         
        Ct.Name AS City,         
        HRT.Code AS Rate,         
        HM.PhoneNo,         
        HM.FaxNo      
        ,UI.ImageName    
  ,HHD.HeaderID,         
        HDM.HeaderValue,         
        HHD.Description,    
  HLM.HotelLandMarkID,         
        HLM.LandMarkID,         
        LM.LandMarkName,    
  HP.ProximityID,         
        CONVERT(VARCHAR(50),     
  CAST(HP.Distance AS DECIMAL(18,2))) + ' km ( ' + HP.Measure + ' ) from the ' + HP.LandMark + '.' AS LandmarkInfo     
        ,HFS.FacilityInfoID,          
        FI.InformationName,      
        FI.ImageName,      
        FI.Image     ,  
  UI.Image   
    FROM HotelMaster HM        
    LEFT JOIN HotelRating HRT WITH (NOLOCK)  ON HRT.ID = HM.HotelRatingID        
    LEFT JOIN City Ct WITH (NOLOCK) ON Ct.IATACode = HM.CityIATACode        
 LEFT JOIN UploadImage UI  WITH (NOLOCK) ON HM.HOTELID = UI.PARENTID    
 LEFT JOIN HotelHeaderDetails HHD WITH (NOLOCK) ON HHD.HOTELID = HM.HOTELID    
    LEFT JOIN HeaderMaster HDM WITH (NOLOCK) ON HDM.HeaderID = HHD.HeaderID       
 LEFT JOIN HotelLandMark HLM WITH (NOLOCK)  ON HLM.HotelID = HM.HOTELID    
    LEFT JOIN LandMarksMaster LM WITH (NOLOCK) ON LM.LandMarkID = HLM.LandMarkID        
 LEFT JOIN HotelProximity HP  WITH (NOLOCK) ON HP.HotelID = HM.HOTELID    
 LEFT JOIN HotelFactSheetInformation HFS WITH (NOLOCK) ON HFS.HOTELID = HM.HOTELID    
 LEFT JOIN FacilityInformationMaster FI WITH (NOLOCK) ON FI.FacilityInfoID = HFS.FacilityInfoID         
   
    WHERE  
 (HM.HotelID = @HotelID OR @HotelID IS NULL OR @HotelID = 0)   or    
 (UI.ParentID = @ParentID or @ParentID = 0 or @ParentID is null ) and     
 (UI.ParentPageType = @ParentPageType or @ParentPageType = 0 or @ParentPageType is null)      
 or    
 (HHD.HotelID = @HotelID OR @HotelID IS NULL OR @HotelID = 0)       
 or (HLM.HotelID = @HotelID OR @HotelID IS NULL OR @HotelID = 0)     
 or (HP.HotelID = @HotelID OR @HotelID IS NULL OR @HotelID = 0)      
 or (HFS.HotelID = @HotelID OR @HotelID IS NULL OR @HotelID = 0)     
    
      
    --UNION ALL        
      
    --SELECT         
    --    HHD.HotelID,         
    --    NULL AS HotelName,         
    --    NULL AS Address,         
    --    NULL AS City,         
    --    NULL AS Rate,         
    --    NULL AS PhoneNo,         
    --    NULL AS FaxNo,         
    --    HHD.HeaderID,         
    --    HDM.HeaderValue,         
    --    HHD.Description,         
    --    NULL AS HotelLandMarkID,         
    --    NULL AS LandMarkID,         
    --    NULL AS LandMarkName,         
    --    NULL AS ProximityID,         
    --    NULL AS LandmarkInfo,        
    --    NULL AS FacilityInfoID,      
    --    NULL AS InformationName,      
    --    NULL AS ImageName,      
    --    NULL AS [Image]      
    --FROM HotelHeaderDetails HHD        
    --INNER JOIN HeaderMaster HDM ON HDM.HeaderID = HHD.HeaderID        
    --WHERE (HHD.HotelID = @HotelID OR @HotelID IS NULL OR @HotelID = 0)        
      
    --UNION ALL        
      
    --SELECT         
    --    HLM.HotelID,         
    --    NULL AS HotelName,         
    --    NULL AS Address,         
    --    NULL AS City,         
    --    NULL AS Rate,         
    --    NULL AS PhoneNo,         
    --    NULL AS FaxNo,         
    --    NULL AS HeaderID,         
    --    NULL AS HeaderValue,         
    --    NULL AS Description,         
    --    HLM.HotelLandMarkID,         
    --    HLM.LandMarkID,         
    --    LM.LandMarkName,         
    --    NULL AS ProximityID,         
    --    NULL AS LandmarkInfo,        
    --    NULL AS FacilityInfoID,      
    --    NULL AS InformationName,      
    --    NULL AS ImageName,      
    --    NULL AS [Image]      
    --FROM HotelLandMark HLM        
    --INNER JOIN LandMarksMaster LM ON LM.LandMarkID = HLM.LandMarkID        
    --WHERE (HLM.HotelID = @HotelID OR @HotelID IS NULL OR @HotelID = 0)        
    
    --UNION ALL        
      
    --SELECT         
    --    HP.HotelID,         
    --    NULL AS HotelName,         
    --    NULL AS Address,         
    --    NULL AS City,         
    --    NULL AS Rate,         
    --    NULL AS PhoneNo,         
    --    NULL AS FaxNo,         
    --    NULL AS HeaderID,         
    --    NULL AS HeaderValue,         
    --    NULL AS Description,         
    --    NULL AS HotelLandMarkID,         
    --    NULL AS LandMarkID,         
    --    NULL AS LandMarkName,         
    --    HP.ProximityID,         
    --    CONVERT(VARCHAR(50), CAST(HP.Distance AS DECIMAL(18,2))) + ' km ( ' + HP.Measure + ' ) from the ' + HP.LandMark + '.' AS LandmarkInfo,        
    --    NULL AS FacilityInfoID,      
    --    NULL AS InformationName,      
    --    NULL AS ImageName,      
    --    NULL AS [Image]      
    --FROM HotelProximity HP        
    --WHERE (HP.HotelID = @HotelID OR @HotelID IS NULL OR @HotelID = 0)      
      
    --UNION ALL        
      
    --SELECT       
    --    HFS.HotelID,      
    --    NULL AS HotelName,         
    --    NULL AS Address,         
    --    NULL AS City,         
    --    NULL AS Rate,         
    --    NULL AS PhoneNo,         
    --    NULL AS FaxNo,         
    --    NULL AS HeaderID,         
    --    NULL AS HeaderValue,         
    --    NULL AS Description,         
    --    NULL AS HotelLandMarkID,         
    --    NULL AS LandMarkID,         
    --    NULL AS LandMarkName,        
    --    NULL AS ProximityID,      
    --    NULL AS LandmarkInfo,      
    --    HFS.FacilityInfoID,          
    --    FI.InformationName,      
    --    FI.ImageName,      
    --    FI.Image      
    --FROM HotelFactSheetInformation HFS          
    --INNER JOIN FacilityInformationMaster FI ON FI.FacilityInfoID = HFS.FacilityInfoID          
    --WHERE (HFS.HotelID = @HotelID OR @HotelID IS NULL OR @HotelID = 0)      
      
    --UNION ALL      
      
    --SELECT       
    --    UI.ParentID AS HotelID,        
    --    NULL AS HotelName,         
    --    NULL AS Address,         
    --    NULL AS City,         
    --    NULL AS Rate,         
    --    NULL AS PhoneNo,         
    --    NULL AS FaxNo,         
    --    NULL AS HeaderID,         
    --    NULL AS HeaderValue,         
    --    NULL AS Description,         
    --    NULL AS HotelLandMarkID,         
    --    NULL AS LandMarkID,         
    --    NULL AS LandMarkName,        
    --    NULL AS ProximityID,      
    --    NULL AS LandmarkInfo,      
    --    NULL AS FacilityInfoID,      
    --    NULL AS InformationName,      
    --    UI.ImageName,      
    --    UI.[Image]      
    --FROM UploadImage UI      
    --WHERE (UI.ParentID = @ParentID or @ParentID = 0 or @ParentID is null ) AND (UI.ParentPageType = @ParentPageType or @ParentPageType = 0 or @ParentPageType is null)      
END 