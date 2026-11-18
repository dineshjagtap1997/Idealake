
CREATE PROCEDURE [dbo].[usp_GetAgentDetails]          
AS          
BEGIN          
  SELECT AM.AgentID, AM.AccCode, AM.AgentCode, AM.AgentName, AM.City_IATACode, AM.PhoneNo, 
  AM.MobileNo, AM.FaxNo, AM.PanNo, AM.TANDetails, AM.STRegNo AS GST, AM.Threshold, 
  AM.CreditAllowance, AM.CreditCurrencyCode, AM.CreditApplicable, AM.CreditPeriod, AM.UnlimitedCredit, 
  AM.AddressCountry, AM.AddressState, AM.AddressCity, AM.IsActive, AM.isActiveSAP, C.Name
  FROM AgentMaster AM
  --INNER JOIN dbo.HotelRating HR ON HR.ID = HM.HotelRatingID          
  INNER JOIN City C ON C.IATACode = AM.AddressCity
  INNER JOIN State S ON S.State_ID = AM.AddressState
  INNER JOIN Country CR ON CR.IATACode = AM.AddressCountry
  --LEFT JOIN dbo.HotelHeaderDetails HA ON HA.HotelID = HM.HotelID          
  --LEFT JOIN dbo.HeaderMaster HDM ON HDM.HeaderID = HA.HeaderID    
  --ORDER BY Hotel_Name,HDM.SequenceNo ASC  select top 4 * from agentmaster
END 