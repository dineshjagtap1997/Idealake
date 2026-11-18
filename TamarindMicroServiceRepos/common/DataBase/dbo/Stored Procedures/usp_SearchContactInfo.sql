                          
  
CREATE PROCEDURE [dbo].[usp_SearchContactInfo]                                              
  
(                                              
  
 @ContactName Varchar(50),                                              
  
 @Type   Varchar(50),                                              
  
 @City_IATACode   Varchar(50),                                              
  
 @TypeName    Varchar(50),                                              
  
 @EmailID     Varchar(50),                                              
  
 @Active      BIT,                                              
  
 @PhoneNo  Varchar(50),                                      
  
 @MarketID INT                                              
  
)                                              
  
AS                                              
  
BEGIN                                              
  
                                               
  
 WITH SearchContact(FullName, ContactDetailsID,ParentID,TypeID,IsPrimaryContact,SalutationID,                              
  
 FirstName,LastName,DesignationOrDepartment,EmailID,Email,OfficeNo,MobileNo,FaxNo,OfficeNoE,MobileNoE,FaxNoE,DateofBirth,DateofBirthE                                             
  
 , [Type], TypeName,TypeNameE,Address,IsActive,Country_IATACode                                              
  
 ,CityCountry,MarketID,MArketName,ContactNameE,CityName,CountryName,CountryCodeAW,CityCodeAW,CityCode,IsForContracting) AS                                              
  
 (                                              
  
  SELECT  RTRIM(LTRIM(ISNULL(CD.FirstName,''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName,''))) + ' <br/>' + CD.EmailID  as FullName,                               
  
  ContactDetailsID,ParentID,TypeID,IsPrimaryContact,CD.SalutationID,FirstName,LastName,                              
  
  DesignationOrDepartment,CD.EmailID,CD.EmailID AS Email ,OfficeNo,CD.MobileNo,CD.FaxNo,                        
  
  CASE WHEN ISNULL(CD.OfficeNo,'') <> '' THEN ISNULL(CAST(CN.ISDCode AS VARCHAR),'') +' '+ISNULL(CAST(C.STDCode AS VARCHAR),'') +' '+ CONVERT(VARCHAR(50),OfficeNo) ELSE '' END AS OfficeNoE ,                        
  
  CASE WHEN ISNULL(CD.MobileNo,'') <> '' THEN ISNULL(CAST(CN.ISDCode AS VARCHAR),'') +' '+ CONVERT(VARCHAR(50),CD.MobileNo) ELSE '' END AS MobileNoE,                        
  
  CASE WHEN ISNULL(CD.FaxNo,'') <> '' THEN ISNULL(CAST(CN.ISDCode AS VARCHAR),'') +' '+ISNULL(CAST(C.STDCode AS VARCHAR),'') +' '+ CONVERT(VARCHAR(50),CD.FaxNo) ELSE '' END AS FaxNoE,DateofBirth                      
  
  ,CONVERT(VARCHAR(50),DAY(DateofBirth))+' ' + CONVERT(VARCHAR(3),DATENAME(MM,DateofBirth)) AS DateofBirthE                      
  
  ,'Hotel' AS [Type], HM.HotelName AS TypeName,HM.HotelName AS TypeNameE,HM.Address,CD.IsActive--HM.IsActive                                              
  
  ,ISNULL(C.Name,'') + ' - ' + ISNULL(Cn.Name,'') AS CityCountry,HM.CityIATACode,''AS  MarketID,'' AS MarketName,                              
  
   RTRIM(LTRIM(ISNULL(CD.FirstName,''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName,''))) AS ContactNameE,                              
  
   C.Name AS CityName,Cn.Name AS CountryName,CN1.IATACode AS CountryCodeAW,                    
  
   C1.IATACode as CityCodeAW,C.IATACode AS CityCode,IsForContracting    
  
  FROM ContactDetails CD WITH (NOLOCK)                    
  
  INNER JOIN HotelMaster HM WITH (NOLOCK) ON HM.HotelID=CD.ParentID                                              
  
  LEFT JOIN City C WITH (NOLOCK) ON C.IATACode=CD.CityIATACode                                              
  
  LEFT JOIN State S WITH (NOLOCK) ON S.State_ID=C.State_IATACode                                              
  
  LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode=S.Country_IATACode                    
  
  LEFT JOIN City C1 WITH (NOLOCK) ON C1.IATACode=HM.CityIATACode                                              
  
  LEFT JOIN State S1 WITH (NOLOCK) ON S1.State_ID=C1.State_IATACode                         
  
  LEFT JOIN Country Cn1 WITH (NOLOCK) ON Cn1.IATACode=S1.Country_IATACode                                            
  
  WHERE CD.TypeID=1                                           
  
                       
  
  UNION                                              
  
                                
  
  SELECT RTRIM(LTRIM(ISNULL(CD.FirstName,''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName,''))) + ' <br/>' + CD.EmailID  as FullName,                               
  
  ContactDetailsID,ParentID,TypeID,IsPrimaryContact,CD.SalutationID,FirstName,LastName,                              
  
  DesignationOrDepartment,CD.EmailID,CD.EmailID AS Email, CD.OfficeNo,CD.MobileNo,CD.FaxNo,                        
  
  CASE WHEN ISNULL(CD.OfficeNo,'') <> '' THEN ISNULL(CAST(CN.ISDCode AS VARCHAR),'') +' '+ISNULL(CAST(C.STDCode AS VARCHAR),'') +' '+ CONVERT(VARCHAR(50),OfficeNo) ELSE '' END AS OfficeNoE ,                        
  
  CASE WHEN ISNULL(CD.MobileNo,'') <> '' THEN ISNULL(CAST(CN.ISDCode AS VARCHAR),'') +' '+ CONVERT(VARCHAR(50),CD.MobileNo) ELSE '' END AS MobileNoE,                        
  
  CASE WHEN ISNULL(CD.FaxNo,'') <> '' THEN ISNULL(CAST(CN.ISDCode AS VARCHAR),'') +' '+ISNULL(CAST(C.STDCode AS VARCHAR),'') +' '+ CONVERT(VARCHAR(50),CD.FaxNo) ELSE '' END AS FaxNoE,                        
  
  DateofBirth,CONVERT(VARCHAR(50),DAY(DateofBirth))+ ' '+ CONVERT(VARCHAR(3),DATENAME(MM,DateofBirth)) AS DateofBirthE,                      
  
  'Vendor' AS [Type], VM.VendorName AS TypeName,VM.VendorName AS TypeNameE,VM.Address,VM.IsActive                            
  
  ,ISNULL(C.Name,'') + ' - ' + ISNULL(Cn.Name,'') AS CityCountry,VM.CityIATACode,''AS  MarketID,'' AS MarketName,                              
  
   RTRIM(LTRIM(ISNULL(CD.FirstName,''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName,''))) AS ContactNameE,                                             
  
   C.Name AS CityName,Cn.Name AS CountryName,CN1.IATACode AS CountryCodeAW,                    
  
   C1.IATACode as CityCodeAW,C.IATACode AS CityCode       
  
   ,IsForContracting                 
  
  FROM ContactDetails CD WITH (NOLOCK)                                               
  
  INNER JOIN VendorMaster VM WITH (NOLOCK) ON VM.VendorID=cd.ParentID                                             
  
  LEFT JOIN City C WITH (NOLOCK) ON C.IATACode=CD.CityIATACode                                              
  
  LEFT JOIN State S WITH (NOLOCK) ON S.State_ID=C.State_IATACode                                              
  
  LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode=S.Country_IATACode                    
  
  LEFT JOIN City C1 WITH (NOLOCK) ON C1.IATACode=VM.CityIATACode                                              
  
  LEFT JOIN State S1 WITH (NOLOCK) ON S1.State_ID=C1.State_IATACode                                              
  
  LEFT JOIN Country Cn1 WITH (NOLOCK) ON Cn1.IATACode=S1.Country_IATACode                                              
  
  WHERE CD.TypeID=2                                           
  
                                                
  
  UNION                                              
  
                                                
  
  SELECT  RTRIM(LTRIM(ISNULL(CD.FirstName,''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName,''))) + ' <br/>' + CD.EmailID  as FullName,                            
  
  ContactDetailsID,ParentID,TypeID,IsPrimaryContact,CD.SalutationID,FirstName,LastName,                              
  
  DesignationOrDepartment,CD.EmailID,CD.EmailID AS Email,CD.OfficeNo,CD.MobileNo,CD.FaxNo,                        
  
  CASE WHEN ISNULL(CD.OfficeNo,'') <> '' THEN ISNULL(CAST(CN.ISDCode AS VARCHAR),'') +' '+ISNULL(CAST(C.STDCode AS VARCHAR),'') +' '+ CONVERT(VARCHAR(50),OfficeNo) ELSE '' END AS OfficeNoE ,                        
  
  CASE WHEN ISNULL(CD.MobileNo,'') <> '' THEN ISNULL(CAST(CN.ISDCode AS VARCHAR),'') +' '+ CONVERT(VARCHAR(50),CD.MobileNo) ELSE '' END AS MobileNoE,                        
  
  CASE WHEN ISNULL(CD.FaxNo,'') <> '' THEN ISNULL(CAST(CN.ISDCode AS VARCHAR),'') +' '+ISNULL(CAST(C.STDCode AS VARCHAR),'') +' '+ CONVERT(VARCHAR(50),CD.FaxNo) ELSE '' END AS FaxNoE,                        
  
  DateofBirth,CONVERT(VARCHAR(50),DAY(DateofBirth))+' ' + CONVERT(VARCHAR(3),DATENAME(MM,DateofBirth)) AS DateofBirthE                                           
  
  ,'Agent' AS [Type], AM.AgentName AS TypeName,AM.AgentName AS TypeNameE,AM.Address,AM.IsActive                                              
  
  ,ISNULL(C.Name,'') + ' - ' + ISNULL(Cn.Name,'') AS CityCountry,AM.City_IATACode,AM.MarketID AS  MarketID,                              
  
  MR.Name AS MarketName,                              
  
  RTRIM(LTRIM(ISNULL(CD.FirstName,''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName,''))) AS ContactNameE,                              
  
  C.Name AS CityName,Cn.Name AS CountryName,CN1.IATACode AS CountryCodeAW,                    
  
  C1.IATACode as CityCodeAW,C.IATACode AS CityCode    
  
   ,cast(0 AS bit) AS IsForContracting                      
  
  FROM ContactDetails CD WITH (NOLOCK)                    
  
  INNER JOIN AgentMaster AM WITH (NOLOCK) ON AM.AgentID=cd.ParentID                    
  
  LEFT JOIN City C WITH (NOLOCK) ON C.IATACode=CD.CityIATACode                    
  
  LEFT JOIN State S WITH (NOLOCK) ON S.State_ID=C.State_IATACode                                              
  
  LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode=S.Country_IATACode                                       
  
  left join Market MR WITH (NOLOCK) ON MR.ID=AM.MarketID                         
  
  LEFT JOIN City C1 WITH (NOLOCK) ON C1.IATACode=AM.City_IATACode                    
  
  LEFT JOIN State S1 WITH (NOLOCK) ON S1.State_ID=C1.State_IATACode                                              
  
  LEFT JOIN Country Cn1 WITH (NOLOCK) ON Cn1.IATACode=S1.Country_IATACode                                 
  
  WHERE CD.TypeID=3                                             
  
 )                                              
  
 SELECT FullName AS ContactName, ContactDetailsID,ParentID,TypeID,                              
  
 IsPrimaryContact,SC.SalutationID,FirstName,LastName,DesignationOrDepartment,EmailID,Email,                              
  
 OfficeNo,MobileNo,FaxNo,OfficeNoE,MobileNoE,FaxNoE,DateofBirth ,DateofBirthE, [Type], TypeName,TypeNameE,Address,SC.IsActive                                              
  
 ,CityCountry,Sa.Salutation,Country_IATACode,MarketID,MArketName,                              
  
 ContactNameE,CityName,CountryName,CountryCodeAW,CityCodeAW,CityCode,IsForContracting                      
  
 FROM SearchContact SC WITH (NOLOCK)                                               
  
 LEFT JOIN Salutation Sa WITH (NOLOCK) ON SC.SalutationID=Sa.SalutationID                                              
  
 WHERE                                               
  
 (FullName LIKE CASE WHEN @ContactName IS NOT NULL THEN '%'+@ContactName+'%' ELSE FullName END)                                              
  
 AND ([Type] LIKE CASE WHEN @Type IS NOT NULL THEN @Type+'%' ELSE [Type] END)                                              
  
 AND (TypeName LIKE CASE WHEN @TypeName IS NOT NULL THEN '%'+@TypeName+'%' ELSE TypeName END)                                              
  
 AND (EmailID  LIKE CASE WHEN @EmailID IS NOT NULL THEN '%'+@EmailID+'%' ELSE EmailID  END)                                              
  
 AND (SC.IsActive = CASE WHEN @Active IS NOT NULL THEN @Active ELSE SC.IsActive END)                                              
  
 AND (ISNULL(OfficeNo,0) LIKE CASE WHEN @PhoneNo IS NOT NULL THEN '%'+@PhoneNo+'%' ELSE ISNULL(OfficeNo,0) END)                                              
  
 AND (sc.CityCountry LIKE CASE WHEN @City_IATACode IS NOT NULL THEN @City_IATACode ELSE sc.CityCountry END)                                        
  
 AND (SC.MarketID =CASE WHEN @MarketID IS NOT NULL THEN @MarketID ELSE SC.MarketID END)                                       
  
END 