CREATE PROCEDURE [dbo].[usp_DestinationDetails_Master]            
(            
@DestinationDetailID INT OUT,          
@CityIATACode CHAR(3) = '',            
@DestinationHeaderID INT = null,            
@Details VARCHAR(MAX) = '',            
@IsActive BIT = null,            
@OperationBy UNIQUEIDENTIFIER = null,            
@Action CHAR(2)='',    
@ACTIVE  CHAR (2) = ''         
)            
AS            
BEGIN     
DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);      
      IF @Action ='I'    
   BEGIN    
  IF EXISTS(SELECT DestinationDetailID FROM DestinationDetails WHERE UPPER(CityIATACode)=UPPER(@CityIATACode) AND DestinationHeaderID=@DestinationHeaderID )            
  BEGIN            
  SET @ReturnCode = '201';        
   SET @ReturnMessage ='Destination Details already exists for particular City and Destination Header.';                
  --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;     
             
  END            
  ELSE            
   BEGIN            
    INSERT INTO DestinationDetails(CityIATACode,DestinationHeaderID,Details,IsActive,Operation,OperationBy,OperationOn)            
    VALUES (@CityIATACode,@DestinationHeaderID,@Details,@IsActive,'INSERT',@OperationBy,GETDATE())            
    SET    @DestinationDetailID =@@IDENTITY              
       SET @ReturnCode = '200';        
 SET @ReturnMessage = 'Data Inserted';      
 --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;        
   END         
   END    
   ELSE IF @Action = 'U'    
   BEGIN           
  IF EXISTS(SELECT DestinationDetailID FROM DestinationDetails WHERE UPPER(CityIATACode)=UPPER(@CityIATACode)           
        AND DestinationHeaderID=@DestinationHeaderID          
        AND DestinationDetailID<>@DestinationDetailID)          
  BEGIN       
  SET @ReturnCode = '201';        
   SET @ReturnMessage ='Destination Details already exists for particular City and Destination Header.';                
 -- SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;        
       
  END          
  ELSE          
   BEGIN          
    UPDATE DestinationDetails SET          
    CityIATACode=@CityIATACode,          
    DestinationHeaderID=@DestinationHeaderID,          
    Details=@Details,          
    IsActive=@IsActive,          
    Operation='UPDATE'   
    ,UpdatedBy = @OperationBy
				,UpdatedOn = GETDATE()        
    WHERE DestinationDetailID=@DestinationDetailID       
     SET @ReturnCode = '200';        
    SET @ReturnMessage = 'Data Updated';      
    --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;        
   END          
   END    
   ELSE IF @Action = 'S'    
   BEGIN    
  IF (@Active=1)            
   BEGIN            
    SELECT DD.DestinationDetailID,DD.CityIATACode,DD.DestinationHeaderID,DD.Details,DD.IsActive,DH.DestinationHeader,          
    DD.Operation,DD.OperationBy,DD.OperationOn,CT.Name,        
   ImageExists=CASE WHEN EXISTS (select ID from UploadImage Where ParentPageType=8 and ParentID=DestinationDetailID) THEN 1          
     ELSE 0 END               
    FROM DestinationDetails DD          
    INNER JOIN City CT ON CT.IATACode=DD.CityIATACode           
    INNER JOIN DestinationHeader DH ON DH.DestinationHeaderID=DD.DestinationHeaderID          
    WHERE DD.IsActive=1         
    ORDER BY DD.OperationOn desc         
   END            
  ELSE            
   BEGIN            
   SELECT DD.DestinationDetailID,DD.CityIATACode,DD.DestinationHeaderID,DD.Details,DD.IsActive,DH.DestinationHeader,          
    DD.Operation,DD.OperationBy,DD.OperationOn,CT.Name,        
    ImageExists=CASE WHEN EXISTS (select ID from UploadImage Where ParentPageType=8 and ParentID=DestinationDetailID) THEN 1          
     ELSE 0 END                 
    FROM DestinationDetails DD          
    INNER JOIN City CT ON CT.IATACode=DD.CityIATACode             
    INNER JOIN DestinationHeader DH ON DH.DestinationHeaderID=DD.DestinationHeaderID         
     ORDER BY DD.OperationOn desc         
   END      
       
      SET @ReturnCode = '200';        
   SET @ReturnMessage = 'Data Fetched';      
   --SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;        
   END    
  SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage;     
END