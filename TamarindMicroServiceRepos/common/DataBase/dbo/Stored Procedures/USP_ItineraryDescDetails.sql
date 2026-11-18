CREATE PROCEDURE [dbo].[USP_ItineraryDescDetails]         
@ItineraryDescID INT=NULL,        
@ServiceType INT=NULL,        
@ServiceID INT=NULL,    
@Action CHAR(2)=''    
AS        
BEGIN     
  
 DECLARE @LogID INT     
IF @Action='I'    
BEGIN    
    
IF NOT EXISTS(SELECT ItineraryDescDetailID FROM ItineraryDescriptionDetails         
WHERE ItineraryDescID=@ItineraryDescID AND ServiceType=@ServiceType AND ServiceID=@ServiceID)        
BEGIN        
 INSERT INTO ItineraryDescriptionDetails         
 (ItineraryDescID,ServiceType,ServiceID)         
 VALUES (@ItineraryDescID,@ServiceType,@ServiceID )    
   
 SET @LogID = SCOPE_IDENTITY()  
  SELECT '200' AS returnCode                          
    ,'New record added successfully.' AS returnMessage , @LogID AS ID    
END    
else
begin 
select '201' as returnCode, 'This data already exists. Please check and try again' as returnMessage
end
END    
    
--ELSE IF @Action='S'    
--BEGIN    
-- SELECT ItineraryDescID,ItineraryCode,Header,IsActive from ItineraryDescriptionDetails          
--END    
    
END    