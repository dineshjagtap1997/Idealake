                                           
        
CREATE PROCEDURE [dbo].[usp_SearchContactInfo_AlbertBackup]                                                    
        
(                                                    
 @ContactName Varchar(50) = '',                    
 @Type Varchar(50) = null,                         
 @City_IATACode Varchar(50) = null,                           
 @TypeName Varchar(50) = null,                       
 @EmailID Varchar(50) = null,                         
 @Active BIT = 0,          
 @PhoneNo Varchar(50) = null,                        
 @MarketID INT = null,                     
 @Country_IATACode Varchar(50) = null,                     
 @State_ID int = null,                     
 @FromDate DATETIME = null,                      
 @IsDate int = null,                    
 @BizActive BIT = 0        
)                                                    
        
AS                                                    
        
begin        
 if (@isDate = 0)        
BEGIN                                                    
        
 WITH SearchContact(FullName, ContactDetailsID,ParentID,TypeID,IsPrimaryContact,SalutationID,                    
 FirstName,LastName,DesignationOrDepartment,EmailID,Email,OfficeNo,MobileNo,FaxNo,OfficeNoE,MobileNoE,FaxNoE,DateofBirth,DateofBirthE                
 , [Type], TypeName,TypeNameE,Address,ContactStatus,Country_IATACode                              
 ,CityCountry,MarketID,MarketName,ContactNameE,CityName,CountryName,CountryCodeAW,CityCodeAW,CityCode,IsForContracting,AddressCityCountry, StateName, State_ID, BizPCreationDate, IsAccStatement,BizPStatus ) AS                         
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
   C1.IATACode as CityCodeAW,C.IATACode AS CityCode,IsForContracting, '' AS AddressCityCountry,         
   S1.Name AS StateName, S1.State_ID, HM.OperationOn, CD.IsAccStatement, HM.IsActive        
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
  'Vendor' AS [Type], VM.VendorName AS TypeName,VM.VendorName AS TypeNameE,VM.Address,CD.IsActive                                  
  ,ISNULL(C.Name,'') + ' - ' + ISNULL(Cn.Name,'') AS CityCountry,VM.CityIATACode,''AS  MarketID,'' AS MarketName,                                    
   RTRIM(LTRIM(ISNULL(CD.FirstName,''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName,''))) AS ContactNameE,                                                   
   C1.Name AS CityName,Cn1.Name AS CountryName,CN1.IATACode AS CountryCodeAW,                          
   C1.IATACode as CityCodeAW,C.IATACode AS CityCode,IsForContracting, '' AS AddressCityCountry,         
   S1.Name AS StateName, S1.State_ID, VM.OperationOn, CD.IsAccStatement, VM.IsActive        
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
  ,'Agent' AS [Type], AM.AgentName AS TypeName,AM.AgentName AS TypeNameE,AM.Address,CD.IsActive                                                    
  ,ISNULL(C2.Name,'') + ' - ' + ISNULL(Cn2.Name,'') AS CityCountry,AM.AddressCity,AM.MarketID AS  MarketID, MR.Name AS MarketName,                                    
  RTRIM(LTRIM(ISNULL(CD.FirstName,''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName,''))) AS ContactNameE,                                    
  C2.Name AS CityName,Cn2.Name AS CountryName,Cn2.IATACode AS CountryCodeAW,                          
  C1.IATACode as CityCodeAW,C2.IATACode AS CityCode,cast(0 AS bit) AS IsForContracting, ISNULL(C2.Name,'') + ' - ' + ISNULL(Cn2.Name,'') AS AddressCityCountry,         
  S2.Name AS StateName, S2.State_ID, AM.OperationOn, CD.IsAccStatement, AM.IsActive        
  FROM ContactDetails CD WITH (NOLOCK)                          
        
  INNER JOIN AgentMaster AM WITH (NOLOCK) ON AM.AgentID=cd.ParentID                          
  LEFT JOIN City C WITH (NOLOCK) ON C.IATACode=CD.CityIATACode                          
  LEFT JOIN State S WITH (NOLOCK) ON S.State_ID=C.State_IATACode                                                    
  LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode=S.Country_IATACode                                             
  left join Market MR WITH (NOLOCK) ON MR.ID=AM.MarketID                               
  LEFT JOIN City C1 WITH (NOLOCK) ON C1.IATACode=AM.City_IATACode                          
  LEFT JOIN State S1 WITH (NOLOCK) ON S1.State_ID=C1.State_IATACode                                                    
  LEFT JOIN Country Cn1 WITH (NOLOCK) ON Cn1.IATACode=S1.Country_IATACode          
          
  LEFT JOIN City C2 WITH (NOLOCK) ON C2.IATACode=AM.AddressCity                          
  LEFT JOIN State S2 WITH (NOLOCK) ON S2.State_ID=AM.AddressState         
  LEFT JOIN Country Cn2 WITH (NOLOCK) ON Cn2.IATACode=AM.AddressCountry                                      
  WHERE CD.TypeID=3                                                   
 )                                                    
SELECT DesignationOrDepartment,ContactNameE as ContactName, MarketName,CityName, StateName,CountryName,        
TypeNameE as 'Associated With',[Type],OfficeNoE as 'OfficeNumber',MobileNoE as 'MobileNumber',Email,        
 IsForContracting, ISNULL(IsAccStatement,0) AS IsAccStatement,        
 ContactStatus,BizPStatus,REPLACE(CONVERT(NVARCHAR, BizPCreationDate, 106), ' ', '-') as BizPCreationDate ,        
        
ContactDetailsID,ParentID,TypeID,IsPrimaryContact,SC.SalutationID,FirstName,LastName,EmailID,OfficeNo,MobileNo,        
FaxNo,FaxNoE,DateofBirth,DateofBirthE,TypeName,Address,SC.ContactStatus as 'IsActive',CityCountry,Sa.Salutation,        
MarketID,         
FullName AS ContactNameE,AddressCityCountry,Country_IATACode,CountryCodeAW,CityCodeAW,AddressCityCountry, State_ID, CityCode        
        
 FROM SearchContact SC WITH (NOLOCK)                                                     
 LEFT JOIN Salutation Sa WITH (NOLOCK) ON SC.SalutationID=Sa.SalutationID             
 WHERE                                                     
    (FullName LIKE CASE WHEN NULLIF(@ContactName, '') IS NOT NULL THEN '%' + @ContactName + '%' ELSE FullName END)                                                    
    AND ([Type] LIKE CASE WHEN NULLIF(@Type, '') IS NOT NULL THEN @Type + '%' ELSE [Type] END)                                                    
    AND (TypeName LIKE CASE WHEN NULLIF(@TypeName, '') IS NOT NULL THEN '%' + @TypeName + '%' ELSE TypeName END)                                                    
    AND (EmailID LIKE CASE WHEN NULLIF(@EmailID, '') IS NOT NULL THEN '%' + @EmailID + '%' ELSE EmailID END)                                                    
    AND (SC.ContactStatus = CASE WHEN NULLIF(@Active, '') IS NOT NULL THEN @Active ELSE SC.ContactStatus END)                                                    
    AND (ISNULL(OfficeNo, 0) LIKE CASE WHEN NULLIF(@PhoneNo, '') IS NOT NULL THEN '%' + @PhoneNo + '%' ELSE ISNULL(OfficeNo, 0) END)                                                    
    AND (SC.CityCountry LIKE CASE WHEN NULLIF(@City_IATACode, '') IS NOT NULL THEN @City_IATACode ELSE SC.CityCountry END)                                            
    AND (SC.MarketID = CASE WHEN NULLIF(@MarketID, '') IS NOT NULL THEN @MarketID ELSE SC.MarketID END)         
    AND (SC.CountryCodeAW = CASE WHEN NULLIF(@Country_IATACode, '') IS NOT NULL THEN @Country_IATACode ELSE SC.CountryCodeAW END)        
    AND (SC.State_ID = CASE WHEN NULLIF(@State_ID, '') IS NOT NULL THEN @State_ID ELSE SC.State_ID END)         
    AND (SC.BizPStatus = CASE WHEN NULLIF(@BizActive, '') IS NOT NULL THEN @BizActive ELSE SC.BizPStatus END)      
      
        
END         
else        
BEGIN        
WITH SearchContact(FullName, ContactDetailsID,ParentID,TypeID,IsPrimaryContact,SalutationID,                    
 FirstName,LastName,DesignationOrDepartment,EmailID,Email,OfficeNo,MobileNo,FaxNo,OfficeNoE,MobileNoE,FaxNoE,DateofBirth,DateofBirthE                
 , [Type], TypeName,TypeNameE,Address,ContactStatus,Country_IATACode                              
 ,CityCountry,MarketID,MarketName,ContactNameE,CityName,CountryName,CountryCodeAW,CityCodeAW,CityCode,IsForContracting,AddressCityCountry, StateName, State_ID, BizPCreationDate, IsAccStatement, BizPStatus) AS                         
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
   C1.IATACode as CityCodeAW,C.IATACode AS CityCode,IsForContracting, '' AS AddressCityCountry,         
   S1.Name AS StateName, S1.State_ID, HM.OperationOn, CD.IsAccStatement, HM.IsActive        
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
  'Vendor' AS [Type], VM.VendorName AS TypeName,VM.VendorName AS TypeNameE,VM.Address,CD.IsActive                                  
  ,ISNULL(C.Name,'') + ' - ' + ISNULL(Cn.Name,'') AS CityCountry,VM.CityIATACode,''AS  MarketID,'' AS MarketName,                                    
   RTRIM(LTRIM(ISNULL(CD.FirstName,''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName,''))) AS ContactNameE,                                                   
   C1.Name AS CityName,Cn1.Name AS CountryName,CN1.IATACode AS CountryCodeAW,                          
   C1.IATACode as CityCodeAW,C.IATACode AS CityCode,IsForContracting, '' AS AddressCityCountry,         
   S1.Name AS StateName, S1.State_ID, VM.OperationOn, CD.IsAccStatement, VM.IsActive         
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
  ,'Agent' AS [Type], AM.AgentName AS TypeName,AM.AgentName AS TypeNameE,AM.Address,CD.IsActive                             
  ,ISNULL(C2.Name,'') + ' - ' + ISNULL(Cn2.Name,'') AS CityCountry,AM.AddressCity,AM.MarketID AS  MarketID, MR.Name AS MarketName,                                    
  RTRIM(LTRIM(ISNULL(CD.FirstName,''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName,''))) AS ContactNameE,                                    
  C2.Name AS CityName,Cn2.Name AS CountryName,Cn2.IATACode AS CountryCodeAW,                          
  C1.IATACode as CityCodeAW,C2.IATACode AS CityCode,cast(0 AS bit) AS IsForContracting, ISNULL(C2.Name,'') + ' - ' + ISNULL(Cn2.Name,'') AS AddressCityCountry,         
  S2.Name AS StateName, S2.State_ID, AM.OperationOn, CD.IsAccStatement, AM.IsActive         
  FROM ContactDetails CD WITH (NOLOCK)                          
        
  INNER JOIN AgentMaster AM WITH (NOLOCK) ON AM.AgentID=cd.ParentID                      LEFT JOIN City C WITH (NOLOCK) ON C.IATACode=CD.CityIATACode                          
  LEFT JOIN State S WITH (NOLOCK) ON S.State_ID=C.State_IATACode                                                    
  LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode=S.Country_IATACode                                             
  left join Market MR WITH (NOLOCK) ON MR.ID=AM.MarketID                               
  LEFT JOIN City C1 WITH (NOLOCK) ON C1.IATACode=AM.City_IATACode                          
  LEFT JOIN State S1 WITH (NOLOCK) ON S1.State_ID=C1.State_IATACode                                                    
  LEFT JOIN Country Cn1 WITH (NOLOCK) ON Cn1.IATACode=S1.Country_IATACode          
          
  LEFT JOIN City C2 WITH (NOLOCK) ON C2.IATACode=AM.AddressCity                          
  LEFT JOIN State S2 WITH (NOLOCK) ON S2.State_ID=AM.AddressState         
  LEFT JOIN Country Cn2 WITH (NOLOCK) ON Cn2.IATACode=AM.AddressCountry                                      
  WHERE CD.TypeID=3      
 )                                                    
 SELECT DesignationOrDepartment,ContactNameE as ContactName, MarketName,CityName, StateName,CountryName,        
 TypeNameE as 'Associated_With',[Type],OfficeNoE as 'OfficeNumber',MobileNoE as 'MobileNumber',Email,        
 IsForContracting, ISNULL(IsAccStatement,0) AS IsAccStatement,        
 ContactStatus, BizPStatus,REPLACE(CONVERT(NVARCHAR, BizPCreationDate, 106), ' ', '-') as BizPCreationDate ,        
        
ContactDetailsID,ParentID,TypeID,IsPrimaryContact,SC.SalutationID,FirstName,LastName,EmailID,OfficeNo,MobileNo,        
FaxNo,FaxNoE,DateofBirth,DateofBirthE,TypeName,Address,SC.ContactStatus as 'IsActive',CityCountry,Sa.Salutation,        
MarketID,        
FullName AS ContactNameE,AddressCityCountry,Country_IATACode,CountryCodeAW,CityCodeAW,AddressCityCountry, State_ID, CityCode        
 FROM SearchContact SC WITH (NOLOCK)                                                     
 LEFT JOIN Salutation Sa WITH (NOLOCK) ON SC.SalutationID=Sa.SalutationID             
         
 WHERE                                                     
 (FullName LIKE CASE WHEN @ContactName IS NOT NULL THEN '%'+@ContactName+'%' ELSE FullName END)                                                    
 AND ([Type] LIKE CASE WHEN @Type IS NOT NULL THEN @Type+'%' ELSE [Type] END)                                                    
 AND (TypeName LIKE CASE WHEN @TypeName IS NOT NULL THEN '%'+@TypeName+'%' ELSE TypeName END)                                                    
 AND (EmailID  LIKE CASE WHEN @EmailID IS NOT NULL THEN '%'+@EmailID+'%' ELSE EmailID  END)                                                    
 AND (SC.ContactStatus = CASE WHEN @Active IS NOT NULL THEN @Active ELSE SC.ContactStatus END)                       
 AND (ISNULL(OfficeNo,0) LIKE CASE WHEN @PhoneNo IS NOT NULL THEN '%'+@PhoneNo+'%' ELSE ISNULL(OfficeNo,0) END)                                                    
 AND (sc.CityCountry LIKE CASE WHEN @City_IATACode IS NOT NULL THEN @City_IATACode ELSE sc.CityCountry END)                                              
 AND (SC.MarketID =CASE WHEN @MarketID IS NOT NULL THEN @MarketID ELSE SC.MarketID END)         
 AND (SC.CountryCodeAW =CASE WHEN @Country_IATACode IS NOT NULL THEN @Country_IATACode ELSE SC.CountryCodeAW END)        
 AND (SC.State_ID =CASE WHEN @State_ID IS NOT NULL THEN @State_ID ELSE SC.State_ID END)                                                     
 AND (SC.BizPCreationDate >=CASE WHEN @FromDate IS NOT NULL THEN DATEADD(dd, 0, DATEDIFF(dd, 0, @FromDate)) ELSE SC.BizPCreationDate END)          
 AND (SC.BizPStatus = CASE WHEN @BizActive IS NOT NULL THEN @BizActive ELSE SC.BizPStatus END)        
     order by 1 desc       
END        
end 