      
CREATE PROCEDURE [dbo].[usp_Header_Master]                  
@HeaderCode  VARCHAR(50),                  
@HeaderValue VARCHAR(50),                  
@Sequence  INT,                  
@IsActive  BIT,                  
@OperationBy UNIQUEIDENTIFIER,                  
--@ErrMsg   VARCHAR(50) OUT             
@Action char(2)='',          
@HeaderID INT =''          
AS             
BEGIN          
      
 Declare @LogID int;       
IF @Action='I'          
BEGIN                  
 IF EXISTS(SELECT HeaderCode FROM HeaderMaster WHERE upper(HeaderCode)=upper(@HeaderCode))                  
 BEGIN            
 SELECT '201' AS returnCode, 'HeaderCode already exists. Please check and try again.'   AS returnMessage;                 
 END                  
 ELSE                  
 IF EXISTS(SELECT HeaderValue FROM HeaderMaster WHERE upper(HeaderValue)=upper(@HeaderValue))                  
 BEGIN           
 SELECT '201' AS returnCode, 'HeaderValue already exists. Please check and try again.'  AS returnMessage;                   
 END                  
 ELSE                  
 IF EXISTS(SELECT SequenceNo FROM HeaderMaster WHERE SequenceNo=@Sequence)                  
 BEGIN                  
 SELECT '201' AS returnCode, 'SequenceNo already exists. Please check and try again.'  AS returnMessage;                  
 END                  
 ELSE                  
 BEGIN                  
  SET    @HeaderCode=UPPER(@HeaderCode)                  
                   
   --declare @MaxID int  = (Select MAX(OldID) from HeaderMaster) + 1                 
   declare @MaxID int            
   --EXEC usp_InsertCustomCaption 'header','WebHotelDetails',@HeaderCode,@Sequence,@MaxID out             
                
  INSERT INTO  HeaderMaster                  
      (HeaderCode,HeaderValue,SequenceNo,IsActive, Operation , OperationBy , OperationOn,OldID)                  
  VALUES   (@HeaderCode, @HeaderValue, @Sequence, @IsActive, 'Insert'  , @OperationBy, GETDATE(),@MaxID )                  
                    
  --EXEC   usp_InsertHeaderMaster_Audit @Code, 'Insert', @OperationBy                  
  SET @LogID = SCOPE_IDENTITY()                   
  SELECT '200' AS returnCode, 'New record added successfully.'  AS returnMessage, @LogID AS ID;           
 END                        
END--I          
ELSE IF @Action='U'          
BEGIN              
 IF EXISTS(SELECT HeaderValue FROM HeaderMaster WHERE upper(HeaderCode)=upper(@HeaderCode) and HeaderID<>@HeaderID)              
 BEGIN            
 SELECT '201' AS returnCode, 'HeaderCode already exists. Please check and try again.' AS returnMessage;              
 END              
 ELSE              
 IF EXISTS(SELECT HeaderValue FROM HeaderMaster WHERE upper(HeaderValue)=upper(@HeaderValue)  and HeaderID<>@HeaderID)              
 BEGIN           
 SELECT '201' AS returnCode, 'HeaderValue already exists. Please check and try again.' AS returnMessage;           
 END              
 ELSE              
 IF EXISTS(SELECT HeaderValue FROM HeaderMaster WHERE SequenceNo=@Sequence and HeaderID<>@HeaderID)              
 BEGIN           
 SELECT '201' AS returnCode, 'SequenceNo already exists. Please check and try again.'    AS returnMessage;           
 END              
 ELSE              
 BEGIN              
               
  SET  @HeaderCode=UPPER(@HeaderCode)              
               
  UPDATE HeaderMaster              
  SET  HeaderCode  = @HeaderCode,              
    HeaderValue  = @HeaderValue,              
    SequenceNo  = @Sequence,              
    IsActive  = @IsActive,              
    Operation  = 'Update',          
 OperationBy = @OperationBy          
 ,OperationOn = GETDATE()              
  WHERE HeaderID  = @HeaderID              
                
    DECLARE @ID INT            
 --select @ID=OldID from HeaderMaster where HeaderID  = @HeaderID               
 --EXEC usp_UpdateCustomCaption @HeaderCode,@Sequence,@ID            
                
 SELECT '200' AS returnCode, 'Record updated successfully.'    AS returnMessage, @HeaderID AS ID ;              
 END              
               
END--U            
          
ELSE IF @Action='S'          
BEGIN              
IF(@IsActive=0)            
BEGIN            
  SELECT HeaderID,HeaderCode,HeaderValue,SequenceNo,IsActive              
  FROM HeaderMaster              
  --Order By OperationOn Desc              
END            
ELSE            
BEGIN            
  SELECT HeaderID,HeaderCode,HeaderValue,SequenceNo,IsActive              
  FROM HeaderMaster             
  WHERE IsActive=1            
  --Order By OperationOn Desc              
            
END            
END--S       

ELSE IF @Action='EX'          
BEGIN              
IF(@IsActive=0)            
BEGIN            
  SELECT HeaderCode,HeaderValue,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive               
  FROM HeaderMaster              
  --Order By OperationOn Desc              
END            
ELSE            
BEGIN            
  SELECT HeaderCode,HeaderValue,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive               
  FROM HeaderMaster             
  WHERE IsActive=1            
  --Order By OperationOn Desc              
            
END            
END--S 




          
END 