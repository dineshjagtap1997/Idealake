  

CREATE PROCEDURE [dbo].[usp_GetWithholdingTax]      

(        

@Active bit        

)        

AS          

BEGIN          

IF(@Active=0)        

BEGIN        

  SELECT *          

  FROM Withholding_Tax_Master C      

  Order by C.Tax_ID desc    

END         

ELSE        

BEGIN        

  SELECT *          

  FROM Withholding_Tax_Master C         

  WHERE C.IsActive=1        

  Order by C.Tax_ID desc    

END         

END   
 