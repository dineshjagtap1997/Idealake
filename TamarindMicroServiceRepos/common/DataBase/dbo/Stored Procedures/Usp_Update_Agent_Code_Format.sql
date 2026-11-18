CREATE PROCEDURE [dbo].[Usp_Update_Agent_Code_Format]      
(      
@Code_No INT,      
@Code_Format VARCHAR(50)      
)      
AS      
BEGIN      
      
UPDATE tamarind_devdb..Agent_Code_Format       
SET Code_No=@Code_No       
where Code_Format=@Code_Format      
      
END