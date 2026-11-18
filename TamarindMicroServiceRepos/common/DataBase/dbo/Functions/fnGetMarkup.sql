    
CREATE FUNCTION [dbo].[fnGetMarkup]                    
(@MarkUpFor varchar(25),@ParentDetailsID uniqueidentifier,@AgentCategoryID int,@Rate numeric(18,2),                    
@FromDate DateTime,@ToDate DateTime,@FromCurrency varchar(10),@CurrentCurrency varchar(10),@FDate DateTime)                            
RETURNS NUMERIC(18,2)                          
AS              
BEGIN              
IF(@Rate IS NOT NULL OR @Rate <>'')              
              
BEGIN                            
 DECLARE @Total NUMERIC(18,2)='0.00'                     
 DECLARE @ROE NUMERIC(18,5)='0.00'                              
 DECLARE @Markup NUMERIC(18,2)='0.00'              
 DECLARE @ROEINR NUMERIC(18,5)='0.00'            
DECLARE @ROEFR NUMERIC(18,5)='0.00'            
               
 SET @Markup =(SELECT top 1Occupancy FROM OccupancyMarkup WHERE ParentRateDetailsID=@ParentDetailsID AND AgentCategoryID=@AgentCategoryID)                          
 IF(@Markup ='0.00' OR @Markup IS NULL)              
 BEGIN                          
 SET @Markup =(SELECT top 1 Transport FROM AgentMarkup            
      WHERE AgentCategoryID=@AgentCategoryID                          
      AND (CONVERT(VARCHAR,@FDate,112) BETWEEN CONVERT(VARCHAR,ValidFrom,112)  AND CONVERT(VARCHAR,ValidTo,112))                                                 
      --AND ( CONVERT(VARCHAR,@ToDate,112) BETWEEN CONVERT(VARCHAR,ValidFrom,112) AND CONVERT(VARCHAR,ValidTo,112))                          
      AND IsActive=1 AND SupplierID=0)               
 END               
                       
IF(@FromCurrency<>@CurrentCurrency)                      
 BEGIN             
 IF(@FromCurrency<>'INR' AND @CurrentCurrency<>'INR')            
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
 SET @ROE=1      
 END      
               
 IF(@Markup <>'0.00' AND @Markup IS NOT NULL)                          
  BEGIN                          
   SET @Total =@Rate+((@Rate*@Markup)/100)                          
  END                           
 ELSE                          
  BEGIN                          
   SET @Total =@Rate              
  END                          
                          
 IF(@ROE<>'0.00')                              
  BEGIN                      
   SET @Total = @Total*@ROE                       
 END              
                        
 END                    
RETURN @Total                
              
                       
                   
END 