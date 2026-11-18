CREATE PROCEDURE SelectFiscalVariant 
@Action char(2)='' 
AS 
BEGIN 
IF @Action='S' 
BEGIN     
SELECT * FROM fiscal_variant; 
END 
END