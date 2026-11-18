-- =============================================      
-- Author:  Dhanya     
-- Create date: 01 June,2011      
-- Description: Retrive data from RateRules       
-- =============================================      
CREATE PROCEDURE [dbo].[usp_GetRateRuleOnParentRateID]  --7,2    
(      
 @ParentRateID INT,    
 @ParentRateTypeID TINYINT     
)      
AS        
BEGIN        
SELECT R.Header as 'Rule',RR.MISSequenceNo,RR.Description,                  
 CASE WHEN RR.ApplicableTo=0 THEN 'ALL'        
 WHEN RR.ApplicableTo=1 THEN 'B2B Agent'              
 WHEN RR.ApplicableTo=2 THEN 'Operations'              
END as 'ApplicableToText' from RateRules RR                  
INNER JOIN Rules R ON R.ID=RR.HeaderRuleID              
WHERE (RR.ParentRateID=@ParentRateID or @ParentRateID is null or @ParentRateID = 0)   and (ParentRateTypeID=@ParentRateTypeID or @ParentRateTypeID is null or @ParentRateTypeID = 0)   
END 


select * from RateRules