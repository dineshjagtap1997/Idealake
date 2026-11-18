CREATE PROCEDURE [dbo].[Usp_ServiceTaxByInvoice_NewN] --'20180326'--'20110916'                              
(                              
@DATE VARCHAR(10),              
@QutID int                            
)                              
AS                              
BEGIN                              
                              
Select distinct Tax_ID,Tax_ID,GSTType,g.GSTPercentage as GSTPercentage,g.GSTID as GSTID     
from ServiceTaxNew ST       
INNER JOIN GST_Percentage g       
on ST.GSTID=g.GSTID         
WHERE                                
CONVERT(VARCHAR,CAST(@DATE AS DATETIME),112) BETWEEN  CONVERT(VARCHAR,ST.Tax_From_Date,112) AND CONVERT(VARCHAR,ST.Tax_To_Date,112)                              
AND ST.IsActive=1                              
AND GSTType= @QutID      
order by GSTPercentage      
END 