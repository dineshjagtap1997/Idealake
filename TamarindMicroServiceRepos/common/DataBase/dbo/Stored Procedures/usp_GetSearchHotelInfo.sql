              
                
-- =============================================                                
-- Author:  Shweta                                
-- Create date: 1 July 2011                              
-- Description: Retrieves HotelGetDetails table                                
-- =============================================                               
CREATE PROCEDURE [dbo].[usp_GetSearchHotelInfo]-- null,null,null,null,null                  
(                              
@HotelChain varchar(25) = '',                               
@HotelId int = 0,                              
@CityIATACode varchar(10)= '',                                 
@RatingFromID int = null,                            
@RatingToID int  = null                          
)                              
AS                              
BEGIN                            
  --SELECT '200' as returnCode, 'data retrived' as returnMessage        
                          
Declare @MisSequenceFrom int                             
SET @MisSequenceFrom=(Select MISSequence FROM  HotelRating Where ID=@RatingFromID)                            
Declare @MisSequenceTo int                             
SET @MisSequenceTo=(Select MISSequence FROM  HotelRating Where ID=@RatingToID)                  
          
                    
                              
SELECT HM.HotelID,HM.CityIATACode,HM.HotelCode,HM.HotelName,                        
HM.HotelRatingID,                        
--+'Fax No :'+CONVERT(VARCHAR(20),ISNULL(HM.FaxNo,''))+                        
--'<br/>Mobile No:'+CONVERT(VARCHAR(20),ISNULL(HM.MobileNo,''))+                        
--'<br/>'+'Phone No:'+CONVERT(VARCHAR(20),ISNULL(HM.PhoneNo,'')) as Contacts,                        
                        
CASE WHEN HM.FaxNo IS NOT NULL THEN CONVERT(VARCHAR(100),'Fax No :'+ISNULL(REPLACE(HM.FaxNo,'~','-'),''))ELSE '' END+                        
CASE WHEN HM.MobileNo IS NOT NULL THEN CONVERT(VARCHAR(100),'<br/>Mob No :'+ISNULL(REPLACE(HM.MobileNo,'~','-'),''))ELSE '' END+                        
CASE WHEN HM.PhoneNo IS NOT NULL THEN CONVERT(VARCHAR(100),'<br/>Phone No :'+ISNULL(REPLACE(HM.PhoneNo,'~','-'),''))ELSE '' END +                  
'<br/>Email :'+''+CASE WHEN HM.EmailID IS NOT NULL THEN HM.EmailID ELSE '' END+                  
'<br/>Web :'+''+CASE WHEN HM.Website IS NOT NULL THEN HM.Website ELSE '' END                  
as Contacts,                        
HM.ChainIATACode,                              
c.Name AS CityName,HR.Code,HR.[Description],HG.Name as HotelChain,                        
+'Infant: '+convert(varchar(15),HM.InfantFromAge) +'-'+                           
convert(varchar(15),HM.InfantToAge)+'<br/>'+'Child: '+convert(varchar(15),HM.ChildFromAge)+ '-'+convert(varchar(15),HM.ChildToAge)as Age,                  
 'Applicable:'+''+CASE WHEN CONVERT(VARCHAR(10),HM.CreditApplicable)= 0 THEN 'NO' ELSE'YES' END+                  
'<br/>Credit Days:'+''+CASE WHEN HM.CreditPeriod IS NOT NULL THEN CONVERT(VARCHAR(50),HM.CreditPeriod) ELSE '' END+                  
'<br/>Credit Limit:'+''+ CASE WHEN HM.CreditAmount IS NOT NULL THEN CONVERT(VARCHAR(50),HM.CreditAmount) ELSE '' END+                  
'<br/>Approved By:'+''+ CASE WHEN HM.CreditApproveBy IS NOT NULL THEN CONVERT(VARCHAR(50),HM.CreditApproveBy) ELSE '' END AS CreditDetails,                  
'Chq Fav:'+''+CASE WHEN HM.ChequeFavouring IS NOT NULL THEN CONVERT(VARCHAR(60),HM.ChequeFavouring) ELSE '' END +                  
CASE WHEN HM.AccountNo IS NOT NULL THEN '<br/>Acc No:'+CONVERT(VARCHAR(30),HM.AccountNo) ELSE '' END+                  
CASE WHEN HM.BankName IS NOT NULL THEN '<br/>Bank:'+CONVERT(VARCHAR(85),HM.BankName) ELSE '' END+             
CASE WHEN ISNULL(HM.BranchName,'')<>'' THEN '<br/>BranchName:'+CONVERT(VARCHAR(85),HM.BranchName) ELSE '' END+                  
CASE WHEN HM.PanNo IS NOT NULL THEN '<br/>PAN:'+CONVERT(VARCHAR(85),HM.PanNo) ELSE '' END          
          
---sanket @ 07/11/2014 below 2 lines          
          
+CASE WHEN HM.IFSCCode IS NOT NULL THEN '<br/>IFSCCode:'+CONVERT(VARCHAR(25),HM.IFSCCode) ELSE '' END          
+CASE WHEN HM.SWIFTCode IS NOT NULL THEN '<br/>SWIFTCode:'+CONVERT(VARCHAR(25),HM.SWIFTCode) ELSE '' END           
+CASE WHEN (HM.STRegNo IS NOT NULL and ISNULL(HM.STRegNo,'')<>'' ) THEN '<br/>GSTIN:'+CONVERT(VARCHAR(25),HM.STRegNo) ELSE '' END --by dhvani @10242019          
 AS ChqDetails                  
 FROM HotelMaster HM INNER JOIN City c ON c.IATACode=HM.CityIATACode                              
 INNER JOIN HotelGroups HG ON HG.IATACode=HM.ChainIATACode                   
 INNER JOIN HotelRating HR ON HR.ID=HM.HotelRatingID                              
 WHERE                             
 --HM.ChainIATACode=CASE WHEN @HotelChain IS NOT NULL THEN @HotelChain ELSE HM.ChainIATACode END                              
 --or HM.HotelID = CASE WHEN @HotelId IS NOT NULL THEN @HotelId ELSE HM.HotelID END                              
 --or HM.CityIATACode = CASE WHEN @CityIATACode IS NOT NULL THEN  @CityIATACode ELSE HM.CityIATACode END                              
 --or HR.MISSequence >= CASE WHEN @MisSequenceFrom IS NOT NULL THEN @MisSequenceFrom ELSE HR.MISSequence END                              
 --or HR.MISSequence <= CASE WHEN @MisSequenceTo IS NOT NULL THEN @MisSequenceTo ELSE HR.MISSequence END                
         
(@HotelChain IS NULL or @HotelChain = '' OR HM.ChainIATACode = @HotelChain)        
AND (@HotelId IS NULL OR  @HotelId = 0 or HM.HotelID = @HotelId)        
AND (@CityIATACode IS NULL OR @CityIATACode = '' or HM.CityIATACode = @CityIATACode)  
AND (@MisSequenceFrom IS NULL OR HR.MISSequence >= @MisSequenceFrom)  
AND (@MisSequenceTo IS NULL OR HR.MISSequence <= @MisSequenceTo);  
          
                         
END 