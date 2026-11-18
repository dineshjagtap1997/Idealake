 
CREATE PROCEDURE [dbo].[usp_GetFileCode]  
(  
 @CompanyID int,  
 @YearID int,  
 @FileCode varchar(30)  
 ,@Action CHAR(2)=''
)  
AS  
BEGIN  
IF @Action ='S'
BEGIN
  
SELECT DISTINCT FileCode from Quotation  
WHERE  
FileCode like CASE WHEN  ISNULL(@FileCode,'')<>'' THEN  '%' + @FileCode + '%'   ELSE  FileCode END   and      
CompanyID = @CompanyID AND YearID = @YearID AND FileCode IS NOT NULL and FileCode != ''  
  END
END  
  
  
  
  