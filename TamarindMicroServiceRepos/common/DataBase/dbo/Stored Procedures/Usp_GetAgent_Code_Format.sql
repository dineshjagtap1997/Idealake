CREATE PROCEDURE [dbo].[Usp_GetAgent_Code_Format]      
(      
@Code_Format VARCHAR(50)      
)      
AS      
BEGIN       
      
SELECT Code_No from tamarind_devdb..Agent_Code_Format       
where upper(Code_Format)=UPPER(@Code_Format)      
      
END