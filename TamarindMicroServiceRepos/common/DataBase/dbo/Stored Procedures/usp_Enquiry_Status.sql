CREATE PROCEDURE [dbo].[usp_Enquiry_Status]
@Action CHAR(2)=''  
AS  
IF  @Action='S'  
BEGIN  
 SELECT [StatusID]  
  ,[StatusDescription]  
  ,[Colourcode]  
<<<<<<< HEAD
<<<<<<< HEAD
 FROM [dbo].[tbl_Enquiry_Status]  
=======
 FROM [dbo].[tbl_Enquiry_Status]   ORDER BY DisplayOrder
>>>>>>> dev
=======
 FROM [dbo].[tbl_Enquiry_Status]   ORDER BY DisplayOrder
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END
ELSE IF  @Action='EX'  
BEGIN  
 SELECT 
 [StatusDescription]  
  ,[Colourcode]  
 FROM [dbo].[tbl_Enquiry_Status]  
END