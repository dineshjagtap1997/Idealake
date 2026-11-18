create FUNCTION [dbo].[fnSearchCalculateROEbkp]                
(@Rate numeric(18,2),@FDate DateTime,@FromCurrency varchar(10),@CurrentCurrency varchar(10))                
RETURNS NUMERIC(18,2)                        
AS                          
BEGIN                 
 DECLARE @ROE NUMERIC(18,5)='0.00'                 
 DECLARE @ROEINR NUMERIC(18,5)='0.00'  
 DECLARE @ROEFR NUMERIC(18,5)='0.00'  
                  
 if(@FromCurrency<>@CurrentCurrency)                
 BEGIN    
  IF (@FromCurrency<>'INR' AND @CurrentCurrency<>'INR')  
   BEGIN  
  SET @ROEINR = (SELECT top 1 CostingRate_FTI FROM CurrencyConversion_N                 
   WHERE CONVERT(VARCHAR,@FDate,112) BETWEEN CONVERT(VARCHAR,FromDate,112) AND CONVERT(VARCHAR,ToDate,112)                
   AND FromCurrency=@CurrentCurrency AND IsActive=1 AND CCParentID<>0)   
     
  SET @ROEFR = (SELECT top 1 CostingRate_ITF  FROM CurrencyConversion_N                 
   WHERE CONVERT(VARCHAR,@FDate,112) BETWEEN CONVERT(VARCHAR,FromDate,112) AND CONVERT(VARCHAR,ToDate,112)                
   AND FromCurrency=@FromCurrency AND IsActive=1 AND CCParentID<>0)   
    
  SET @ROEINR = ISNULL(@ROEINR,0)  
  SET @ROEFR = ISNULL(@ROEFR,0)   
  SET @ROE =@ROEINR * @ROEFR     
    
   END  
  ELSE               
   BEGIN  
    IF(@FromCurrency<>'INR')--Get the Foreign TO INR Currency                
  BEGIN                
   SET @ROE = (SELECT top 1 CostingRate_ITF  FROM CurrencyConversion_N                 
   WHERE CONVERT(VARCHAR,@FDate,112) BETWEEN CONVERT(VARCHAR,FromDate,112) AND CONVERT(VARCHAR,ToDate,112)                
   AND FromCurrency=@FromCurrency AND IsActive=1 AND CCParentID<>0)                
  END                
    ELSE --Get the INR TO Foreign Currency                
  BEGIN           
   SET @ROE = (SELECT top 1 CostingRate_FTI FROM CurrencyConversion_N                 
   WHERE CONVERT(VARCHAR,@FDate,112) BETWEEN CONVERT(VARCHAR,FromDate,112) AND CONVERT(VARCHAR,ToDate,112)                
   AND FromCurrency=@CurrentCurrency AND IsActive=1 AND CCParentID<>0)                
  END  
   END                
 END        
 ELSE        
 BEGIN        
  SET @ROE ='1.00'        
 END                 
                 
 IF(@Rate IS NOT NULL AND @Rate >0 AND @ROE<>'0.00')                
 BEGIN                
  SET @Rate = @Rate * @ROE                
 END        
 ELSE        
 BEGIN        
 IF(@Rate='-1.00')    
 BEGIN    
  SET @Rate = -1      
 END    
 ELSE    
 BEGIN      
  SET @Rate = -101      
 END    
  --SET @Rate = -101        
 END                
 RETURN @Rate                 
END 