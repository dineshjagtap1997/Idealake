CREATE FUNCTION fnGetHotelOfferMarket(@OfferRateID INT)            
RETURNS VARCHAR(MAX)            
AS            
BEGIN            
DECLARE @str VARCHAR(MAX)            
SET @str=''            
SELECT @str = @str + M.Name + ','           
FROM HotelOfferAgentMarketMap HOAMM      
INNER JOIN Market M ON HOAMM.MarketID=M.ID      
WHERE HOAMM.HotelOfferID=@OfferRateID and  HOAMM.AgentID is null          
Return @str            
END    