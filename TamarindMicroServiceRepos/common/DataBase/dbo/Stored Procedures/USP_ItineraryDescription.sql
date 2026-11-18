  
CREATE PROCEDURE [dbo].[USP_ItineraryDescription]   
 @ItineraryDescID INT =''  
 ,@ItineraryCode VARCHAR(100)=''  
 ,@Header VARCHAR(500)=''  
 ,@ShortDescription VARCHAR(MAX)=''  
 ,@DetailDescription VARCHAR(MAX)=''  
 ,@IsActive BIT=''  
 ,@OperationBy INT=''  
 ,@Action CHAR(2)=''  
 --,@Err VARCHAR(100) OUT  
AS  
BEGIN   
IF @Action='I'  
BEGIN  
 --for autogenerate @ItineraryCode          
 DECLARE @CardNoMax VARCHAR(10)  
  Declare @LogID int; 


  
 SET @CardNoMax = (  
   SELECT MAX(SUBSTRING(ItineraryCode, 6, 5))  
   FROM ItineraryDescription  
   )  
 SET @CardNoMax = CASE   
   WHEN @CardNoMax IS NULL  
    THEN '1'  
   ELSE CAST(@CardNoMax AS INT) + 1  
   END  
 SET @ItineraryCode = SUBSTRING(CONVERT(VARCHAR, DATEPART(yy, GETDATE())), 3, 2) + REPLICATE('0', 2 - LEN(DATEPART(mm, GETDATE()))) + CONVERT(VARCHAR, DATEPART(mm, GETDATE())) + REPLICATE('0', 5 - len(@CardNoMax)) + @CardNoMax  
 SET @ItineraryCode = 'I' + @ItineraryCode  
  
 IF EXISTS (  
   SELECT ItineraryDescID  
   FROM ItineraryDescription  
   WHERE UPPER(Header) = UPPER(@Header)  
   )  
 BEGIN  
   SELECT '201' AS returnCode      
    ,'This data already exists. Please check and try again'AS returnMessage;   
   
  SET @ItineraryDescID = 0  
 END  
 ELSE  
 BEGIN  
  INSERT INTO ItineraryDescription (  
   ItineraryCode  
   ,Header  
   ,ShortDescription  
   ,DetailDescription  
   ,IsActive  
   ,Operation  
   ,OperationBy  
   ,OperationOn  
   )  
  VALUES (  
   @ItineraryCode  
   ,@Header  
   ,@ShortDescription  
   ,@DetailDescription  
   ,@IsActive  
   ,'Insert'  
   ,@OperationBy  
   ,GETDATE()  
   )  
  
   SET @ItineraryDescID = SCOPE_IDENTITY()    
  SELECT '200' AS returnCode      
    ,'New record added successfully'AS returnMessage, @ItineraryDescID AS ID;   

 END  
END  
ELSE IF @Action='U'  
BEGIN  
 IF EXISTS (  
   SELECT ItineraryDescID  
   FROM ItineraryDescription  
   WHERE UPPER(Header) = UPPER(@Header)  
    AND ItineraryDescID != @ItineraryDescID  
   )  
 BEGIN  
  SELECT '201' AS returnCode      
    ,'This data already exists. Please check and try again'AS returnMessage;    
 END  
 ELSE  
 BEGIN  
  UPDATE ItineraryDescription  
  SET Header = ISNULL (@Header,Header)  
   ,ShortDescription = @ShortDescription  
   ,DetailDescription = @DetailDescription  
   ,IsActive = @IsActive  
   ,Operation = 'Update'  
   ,OperationBy = @OperationBy  
   ,OperationOn = GETDATE()  
  WHERE ItineraryDescID = @ItineraryDescID  
  
  SELECT '200' AS returnCode      
    ,'Record updated successfully.'AS returnMessage, @ItineraryDescID AS ID;    
 END  
END  
ELSE IF @Action='S'  
BEGIN  
 SELECT ItineraryDescID  
  ,ItineraryCode  
  ,Header  
  ,IsActive  
 FROM ItineraryDescription  
 WHERE (@ItineraryDescID IS NULL OR @ItineraryDescID = 0 OR ItineraryDescID = @ItineraryDescID)   
   
END  
  
END   