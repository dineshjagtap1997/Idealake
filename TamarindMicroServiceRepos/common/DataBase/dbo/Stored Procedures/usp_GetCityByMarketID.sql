       
        
CREATE PROCEDURE [dbo].[usp_GetCityByMarketID]        
(        
 @MarketID int          
)        
AS        
BEGIN    
 if(@MarketID = 0)    
 begin    
  SELECT DISTINCT ct.IATACode,ct.Name FROM CountryMarket_Mapping  CMM--where Market_ID=2          
  INNER JOIN [State] St  ON cmm.Country_IATACode=st.Country_IATACode          
  INNER JOIN City Ct ON st.State_ID=ct.State_IATACode     
  WHERE --Market_ID=@MarketID AND     
  ct.IsActive=1         
  Order by Ct.Name        
 end    
 else    
 begin       
  SELECT DISTINCT ct.IATACode,ct.Name FROM CountryMarket_Mapping  CMM--where Market_ID=2        
  INNER JOIN [State] St  ON cmm.Country_IATACode=st.Country_IATACode        
  INNER JOIN City Ct ON st.State_ID=ct.State_IATACode WHERE Market_ID=@MarketID AND ct.IsActive=1       
  Order by Ct.Name  
 end      
END     