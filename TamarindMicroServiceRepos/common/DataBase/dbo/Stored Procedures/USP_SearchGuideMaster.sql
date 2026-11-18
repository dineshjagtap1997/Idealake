CREATE PROCEDURE [dbo].[USP_SearchGuideMaster] --null,null,null,'RU,AR'                     
@StateID INT = NULL,                                 
@CityID VARCHAR(25) = NULL,                                 
@StarRating VARCHAR(100) = NULL,                                 
@Language VARCHAR(250) = NULL                                 
AS                                 
BEGIN                               
         --Select '200' as returncode, 'data retrieved' as returnmessage          
SELECT * FROM                              
(                            
SELECT *,CASE WHEN ISNULL(@Language, '') <> '' THEN dbo.fn_CompareLanguages(Languages, @Language) ELSE 1 END AS CompareLanguage                    
,(SELECT dbo.fn_getLanguag(Languages)) AS Language                    
FROM                            
(                            
SELECT GuideID, GM.Salutation + ' ' + GM.Name AS Name,      PhoneNo                 
--CASE WHEN ISNULL(PhoneNo, '') <> '' THEN 'Phone No :' + PhoneNo ELSE '' END  +                    
--CASE WHEN ISNULL(MobileNo, '') <> '' THEN '<br /> Mobile No :' + MobileNo ELSE '' END  AS PhoneNo                       
,StarRating, Address                      
,C.Name AS City, S.Name AS State, Languages                   
,Ranking, ISNULL(IsDOT, 0) As IsDOT,                  
ISNULL(IsState, 0) As IsState,                    
ISNULL(IsASI, 0) As IsASI                  
FROM GuideInfoMaster GM                               
LEFT JOIN State S ON S.State_ID = GM.StateIATACode                               
LEFT JOIN City C ON C.IATACode = GM.CityIATACode                               
LEFT JOIN Language L ON L.ID = GM.Languages                      
WHERE                          
(@StateID IS NULL OR @StateID = 0 or GM.StateIATACode = @StateID) AND                         
(@CityID IS NULL OR @CityID = '' or GM.CityIATACode = @CityID) AND                                
(@StarRating IS NULL OR @StarRating = '' or GM.StarRating = @StarRating) AND    
(@Language is null or @Language = '' or GM.Languages like '%' +@Language+'%')    
--AND GM.IsActive = 1                      
) AS A                        
) AS B                        
WHERE B.CompareLanguage = 1                
ORDER BY Ranking ASC, GuideID DESC                 
                
END 