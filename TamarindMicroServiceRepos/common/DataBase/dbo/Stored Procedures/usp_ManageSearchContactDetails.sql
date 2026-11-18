-- =============================================                                    
-- Author:  sanket                                 
-- Create date: 30 june 2011                                    
-- Description: Update the  Contact Details table                     
-- Mofified By : 15 Jan 2016, Afreen, Added IsForContracting Details                                       
-- =============================================                                    
CREATE PROCEDURE [dbo].[usp_ManageSearchContactDetails] (  
    @ContactName VARCHAR(50) = NULL,  
    @Type VARCHAR(50) = NULL,  
    @City_IATACode VARCHAR(50) = NULL,  
    @TypeName VARCHAR(50) = NULL,  
    @Active BIT = NULL,  
    @PhoneNo VARCHAR(50) = NULL,  
    @MarketID INT = NULL,  
    @ContactDetailsID INT = NULL,  
    @ParentID INT = NULL,  
    @TypeID TINYINT = NULL,  
    @IsPrimaryContact BIT = NULL,  
    @SalutationID INT = NULL,  
    @FirstName VARCHAR(50) = NULL,  
    @LastName VARCHAR(50) = NULL,  
    @DesignationOrDepartment VARCHAR(100) = NULL,  
    @EmailID VARCHAR(200) = NULL,  
    @OfficeNo VARCHAR(15) = NULL,  
    @MobileNo VARCHAR(15) = NULL,  
    @FaxNo VARCHAR(15) = NULL,  
    @DateofBirth DATETIME = NULL,  
    @CityIATACode VARCHAR(35) = NULL,  
    @IsActive TINYINT = NULL,  
    @IsForContracting TINYINT = 0,  
    @Action VARCHAR(20) = NULL,  
    @BizPStatus BIT = NULL    
)  
AS  
BEGIN  
 IF @Action = 'I'  
BEGIN  
    INSERT INTO ContactDetails (  
        ParentID,  
        TypeID,  
        IsPrimaryContact,  
        SalutationID,  
        FirstName,  
        LastName,  
        DesignationOrDepartment,  
        EmailID,  
        OfficeNo,  
        MobileNo,  
        FaxNo,  
        DateofBirth,  
        CityIATACode,  
        IsActive,  
        IsForContracting,  
        BizPStatus  -- Added column  
    )  
    VALUES (  
        @ParentID,  
        @TypeID,  
        @IsPrimaryContact,  
        @SalutationID,  
        @FirstName,  
        @LastName,  
        @DesignationOrDepartment,  
        @EmailID,  
        @OfficeNo,  
        @MobileNo,  
        @FaxNo,  
        @DateofBirth,  
        @City_IATACode,  
        @IsActive,  
        @IsForContracting,  
        @BizPStatus  -- Added parameter  
    );  
  
    SELECT '200' AS returnCode,  
           'New record added successfully' AS returnMessage;  
END  
 ELSE IF @Action = 'U'  
BEGIN  
    UPDATE ContactDetails  
    SET  
        TypeID = @TypeID,  
        IsPrimaryContact = @IsPrimaryContact,  
        SalutationID = @SalutationID,  
        FirstName = @FirstName,  
        LastName = @LastName,  
        DesignationOrDepartment = @DesignationOrDepartment,  
        EmailID = @EmailID,  
        OfficeNo = @OfficeNo,  
        MobileNo = @MobileNo,  
        FaxNo = @FaxNo,  
        DateofBirth = @DateofBirth,  
        CityIATACode = @City_IATACode,  
        IsActive = @IsActive,  
        IsForContracting = @IsForContracting,  
        BizPStatus = @BizPStatus  -- Added column  ,
		,parentid = @ParentID
    WHERE ContactDetailsID = @ContactDetailsID;  
  
    SELECT '200' AS returnCode,  
           'Record updated successfully' AS returnMessage;  
END  
  
 --ELSE IF @Action = 's'  
 --BEGIN  
  --WITH SearchContact (          
  -- FullName          
  -- ,ContactDetailsID          
  -- ,ParentID          
  -- ,TypeID          
  -- ,IsPrimaryContact          
  -- ,SalutationID          
  -- ,FirstName          
  -- ,LastName          
  -- ,DesignationOrDepartment          
  -- ,EmailID          
  -- ,Email          
  -- ,OfficeNo          
  -- ,MobileNo          
  -- ,FaxNo          
  -- ,OfficeNoE          
  -- ,MobileNoE          
  -- ,FaxNoE          
  -- ,DateofBirth          
  -- ,DateofBirthE          
  -- ,[Type]          
  -- ,TypeName          
  -- ,TypeNameE          
  -- ,Address          
  -- ,IsActive          
  -- ,Country_IATACode          
  -- ,CityCountry          
  -- ,MarketID          
  -- ,MArketName          
  -- ,ContactNameE          
  -- ,CityName          
  -- ,CountryName          
  -- ,CountryCodeAW          
  -- ,CityCodeAW          
  -- ,CityCode          
  -- ,IsForContracting          
  -- )          
  --AS (          
  -- SELECT RTRIM(LTRIM(ISNULL(CD.FirstName, ''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName, ''))) + ' <br/>' + CD.EmailID AS FullName          
  --  ,ContactDetailsID          
  --  ,ParentID          
  --  ,TypeID          
  --  ,IsPrimaryContact          
  --  ,CD.SalutationID          
  --  ,FirstName          
  --  ,LastName          
  --  ,DesignationOrDepartment          
  --  ,CD.EmailID      
  --  ,CD.EmailID AS Email          
  --  ,OfficeNo          
  --  ,CD.MobileNo          
  --  ,CD.FaxNo          
  --  ,CASE           
  --   WHEN ISNULL(CD.OfficeNo, '') <> ''          
  --    THEN ISNULL(CAST(CN.ISDCode AS VARCHAR), '') + ' ' + ISNULL(CAST(C.STDCode AS VARCHAR), '') + ' ' + CONVERT(VARCHAR(50), OfficeNo)          
  --   ELSE ''          
  --   END AS OfficeNoE          
  --  ,CASE           
  --   WHEN ISNULL(CD.MobileNo, '') <> ''          
  --    THEN ISNULL(CAST(CN.ISDCode AS VARCHAR), '') + ' ' + CONVERT(VARCHAR(50), CD.MobileNo)          
  --   ELSE ''          
  --   END AS MobileNoE          
  --  ,CASE           
  --   WHEN ISNULL(CD.FaxNo, '') <> ''          
  --    THEN ISNULL(CAST(CN.ISDCode AS VARCHAR), '') + ' ' + ISNULL(CAST(C.STDCode AS VARCHAR), '') + ' ' + CONVERT(VARCHAR(50), CD.FaxNo)          
  --   ELSE ''          
  --   END AS FaxNoE          
  --  ,DateofBirth          
  --  ,CONVERT(VARCHAR(50), DAY(DateofBirth)) + ' ' + CONVERT(VARCHAR(3), DATENAME(MM, DateofBirth)) AS DateofBirthE          
  --  ,'Hotel' AS [Type]          
  --  ,HM.HotelName AS TypeName          
  --  ,HM.HotelName AS TypeNameE          
  --  ,HM.Address          
  --  ,CD.IsActive --HM.IsActive                                                        
  --  ,ISNULL(C.Name, '') + ' - ' + ISNULL(Cn.Name, '') AS CityCountry          
  --  ,HM.CityIATACode          
  --  ,'' AS MarketID          
  --  ,'' AS MarketName          
  --  ,RTRIM(LTRIM(ISNULL(CD.FirstName, ''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName, ''))) AS ContactNameE          
  --  ,C.Name AS CityName          
  --  ,Cn.Name AS CountryName          
  --  ,CN1.IATACode AS CountryCodeAW          
  --  ,C1.IATACode AS CityCodeAW          
  --  ,C.IATACode AS CityCode          
  --  ,IsForContracting          
  -- FROM ContactDetails CD WITH (NOLOCK)          
  -- INNER JOIN HotelMaster HM WITH (NOLOCK) ON HM.HotelID = CD.ParentID          
  -- LEFT JOIN City C WITH (NOLOCK) ON C.IATACode = CD.CityIATACode          
  -- LEFT JOIN STATE S          
  -- WITH (NOLOCK) ON S.State_ID = C.State_IATACode          
  -- LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = S.Country_IATACode          
  -- LEFT JOIN City C1 WITH (NOLOCK) ON C1.IATACode = HM.CityIATACode          
  -- LEFT JOIN STATE S1          
  -- WITH (NOLOCK) ON S1.State_ID = C1.State_IATACode          
  -- LEFT JOIN Country Cn1 WITH (NOLOCK) ON Cn1.IATACode = S1.Country_IATACode          
  -- WHERE CD.TypeID = 1          
  -- UNION          
  -- SELECT RTRIM(LTRIM(ISNULL(CD.FirstName, ''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName, ''))) + ' <br/>' + CD.EmailID AS FullName          
  --  ,ContactDetailsID          
  --  ,ParentID          
  --  ,TypeID          
  --  ,IsPrimaryContact          
  --  ,CD.SalutationID          
  --  ,FirstName          
  --  ,LastName          
  --  ,DesignationOrDepartment          
  --  ,CD.EmailID          
  --  ,CD.EmailID AS Email          
  --  ,CD.OfficeNo          
  --  ,CD.MobileNo          
  --  ,CD.FaxNo          
  --  ,CASE           
  --   WHEN ISNULL(CD.OfficeNo, '') <> ''          
  --    THEN ISNULL(CAST(CN.ISDCode AS VARCHAR), '') + ' ' + ISNULL(CAST(C.STDCode AS VARCHAR), '') + ' ' + CONVERT(VARCHAR(50), OfficeNo)          
  --   ELSE ''          
  --   END AS OfficeNoE          
  --  ,CASE           
  --   WHEN ISNULL(CD.MobileNo, '') <> ''          
  --    THEN ISNULL(CAST(CN.ISDCode AS VARCHAR), '') + ' ' + CONVERT(VARCHAR(50), CD.MobileNo)          
  --   ELSE ''          
  --   END AS MobileNoE          
  --  ,CASE           
  --   WHEN ISNULL(CD.FaxNo, '') <> ''          
  --    THEN ISNULL(CAST(CN.ISDCode AS VARCHAR), '') + ' ' + ISNULL(CAST(C.STDCode AS VARCHAR), '') + ' ' + CONVERT(VARCHAR(50), CD.FaxNo)          
  --   ELSE ''          
  --   END AS FaxNoE          
  --  ,DateofBirth          
  --  ,CONVERT(VARCHAR(50), DAY(DateofBirth)) + ' ' + CONVERT(VARCHAR(3), DATENAME(MM, DateofBirth)) AS DateofBirthE          
  --  ,'Vendor' AS [Type]          
  --  ,VM.VendorName AS TypeName          
  --  ,VM.VendorName AS TypeNameE          
  --  ,VM.Address          
  --  ,VM.IsActive          
  --  ,ISNULL(C.Name, '') + ' - ' + ISNULL(Cn.Name, '') AS CityCountry          
  --  ,VM.CityIATACode          
  --  ,'' AS MarketID          
  --  ,'' AS MarketName          
  --  ,RTRIM(LTRIM(ISNULL(CD.FirstName, ''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName, ''))) AS ContactNameE          
  --  ,C.Name AS CityName          
  --  ,Cn.Name AS CountryName          
  --  ,CN1.IATACode AS CountryCodeAW          
  --  ,C1.IATACode AS CityCodeAW          
  --  ,C.IATACode AS CityCode          
  --  ,IsForContracting          
  -- FROM ContactDetails CD WITH (NOLOCK)          
  -- INNER JOIN VendorMaster VM WITH (NOLOCK) ON VM.VendorID = cd.ParentID          
  -- LEFT JOIN City C WITH (NOLOCK) ON C.IATACode = CD.CityIATACode          
  -- LEFT JOIN STATE S          
  -- WITH (NOLOCK) ON S.State_ID = C.State_IATACode          
  -- LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = S.Country_IATACode          
  -- LEFT JOIN City C1 WITH (NOLOCK) ON C1.IATACode = VM.CityIATACode          
  -- LEFT JOIN STATE S1          
  -- WITH (NOLOCK) ON S1.State_ID = C1.State_IATACode          
  -- LEFT JOIN Country Cn1 WITH (NOLOCK) ON Cn1.IATACode = S1.Country_IATACode          
  -- WHERE CD.TypeID = 2          
  -- UNION          
  -- SELECT RTRIM(LTRIM(ISNULL(CD.FirstName, ''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName, ''))) + ' <br/>' + CD.EmailID AS FullName          
  --  ,ContactDetailsID          
  --  ,ParentID          
  --  ,TypeID          
  --  ,IsPrimaryContact          
  --  ,CD.SalutationID          
  --  ,FirstName          
  --  ,LastName          
  --  ,DesignationOrDepartment          
  --  ,CD.EmailID          
  --  ,CD.EmailID AS Email          
  --  ,CD.OfficeNo          
  --  ,CD.MobileNo          
  --  ,CD.FaxNo          
  --  ,CASE           
  --   WHEN ISNULL(CD.OfficeNo, '') <> ''          
  --    THEN ISNULL(CAST(CN.ISDCode AS VARCHAR), '') + ' ' + ISNULL(CAST(C.STDCode AS VARCHAR), '') + ' ' + CONVERT(VARCHAR(50), OfficeNo)          
  --   ELSE ''          
  --   END AS OfficeNoE          
  --  ,CASE           
  --   WHEN ISNULL(CD.MobileNo, '') <> ''          
  --    THEN ISNULL(CAST(CN.ISDCode AS VARCHAR), '') + ' ' + CONVERT(VARCHAR(50), CD.MobileNo)          
  --   ELSE ''          
  --   END AS MobileNoE          
  --  ,CASE           
  --   WHEN ISNULL(CD.FaxNo, '') <> ''          
  --    THEN ISNULL(CAST(CN.ISDCode AS VARCHAR), '') + ' ' + ISNULL(CAST(C.STDCode AS VARCHAR), '') + ' ' + CONVERT(VARCHAR(50), CD.FaxNo)          
  --   ELSE ''          
  --   END AS FaxNoE          
  --  ,DateofBirth          
  --  ,CONVERT(VARCHAR(50), DAY(DateofBirth)) + ' ' + CONVERT(VARCHAR(3), DATENAME(MM, DateofBirth)) AS DateofBirthE          
  --  ,'Agent' AS [Type]          
  --  ,AM.AgentName AS TypeName          
  --  ,AM.AgentName AS TypeNameE          
  --  ,AM.Address          
  --  ,AM.IsActive          
  --  ,ISNULL(C.Name, '') + ' - ' + ISNULL(Cn.Name, '') AS CityCountry          
  --  ,AM.City_IATACode          
  --  ,AM.MarketID AS MarketID          
  --  ,MR.Name AS MarketName          
  --  ,RTRIM(LTRIM(ISNULL(CD.FirstName, ''))) + ' ' + RTRIM(LTRIM(ISNULL(CD.LastName, ''))) AS ContactNameE          
  --  ,C.Name AS CityName          
  --  ,Cn.Name AS CountryName          
  --  ,CN1.IATACode AS CountryCodeAW          
  --  ,C1.IATACode AS CityCodeAW          
  --  ,C.IATACode AS CityCode          
  --  ,cast(0 AS BIT) AS IsForContracting          
  -- FROM ContactDetails CD WITH (NOLOCK)          
  -- INNER JOIN AgentMaster AM WITH (NOLOCK) ON AM.AgentID = cd.ParentID          
  -- LEFT JOIN City C WITH (NOLOCK) ON C.IATACode = CD.CityIATACode          
  -- LEFT JOIN STATE S          
  -- WITH (NOLOCK) ON S.State_ID = C.State_IATACode       -- LEFT JOIN Country Cn WITH (NOLOCK) ON Cn.IATACode = S.Country_IATACode          
  -- LEFT JOIN Market MR WITH (NOLOCK) ON MR.ID = AM.MarketID          
  -- LEFT JOIN City C1 WITH (NOLOCK) ON C1.IATACode = AM.City_IATACode          
  -- LEFT JOIN STATE S1          
  -- WITH (NOLOCK) ON S1.State_ID = C1.State_IATACode          
  -- LEFT JOIN Country Cn1 WITH (NOLOCK) ON Cn1.IATACode = S1.Country_IATACode          
  -- WHERE CD.TypeID = 3     
  -- )          
  --SELECT FullName AS ContactName          
  -- ,ContactDetailsID          
  -- ,ParentID          
  -- ,TypeID          
  -- ,IsPrimaryContact          
  -- ,SC.SalutationID          
  -- ,FirstName          
  -- ,LastName          
  -- ,DesignationOrDepartment          
  -- ,EmailID          
  -- ,Email          
  -- ,OfficeNo          
  -- ,MobileNo          
  -- ,FaxNo          
  -- ,OfficeNoE          
  -- ,MobileNoE          
  -- ,FaxNoE          
  -- ,DateofBirth          
  -- ,DateofBirthE          
  -- ,[Type]          
  -- ,TypeName          
  -- ,TypeNameE          
  -- ,Address          
  -- ,SC.IsActive          
  -- ,CityCountry          
  -- ,Sa.Salutation          
  -- ,Country_IATACode          
  -- ,MarketID          
  -- ,MArketName          
  -- ,ContactNameE          
  -- ,CityName          
  -- ,CountryName          
  -- ,CountryCodeAW          
  -- ,CityCodeAW          
  -- ,CityCode          
  -- ,IsForContracting          
  --FROM SearchContact SC WITH (NOLOCK)          
  --LEFT JOIN Salutation Sa WITH (NOLOCK) ON SC.SalutationID = Sa.SalutationID          
  --WHERE (          
  --  FullName LIKE CASE           
  --   WHEN @ContactName IS NOT NULL          
  --    THEN '%' + @ContactName + '%'          
  --   ELSE FullName          
  --   END          
  --  )          
  -- AND (          
  --  [Type] LIKE CASE           
  --   WHEN @Type IS NOT NULL          
  --    THEN @Type + '%'          
  --   ELSE [Type]          
  --   END          
  --  )          
  -- AND (          
  --  TypeName LIKE CASE           
  --   WHEN @TypeName IS NOT NULL          
  --    THEN '%' + @TypeName + '%'          
  --   ELSE TypeName          
  --   END          
  --  )          
  -- AND (          
  --  EmailID LIKE CASE           
  --   WHEN @EmailID IS NOT NULL          
  --    THEN '%' + @EmailID + '%'          
  --   ELSE EmailID          
  --   END          
  --  )          
  -- AND (          
  --  SC.IsActive = CASE           
  --   WHEN @Active IS NOT NULL          
  --    THEN @Active          
  --   ELSE SC.IsActive          
  --   END          
  --  )          
  -- AND (          
  --  ISNULL(OfficeNo, 0) LIKE CASE           
  --   WHEN @PhoneNo IS NOT NULL          
  --    THEN '%' + @PhoneNo + '%'          
  --   ELSE ISNULL(OfficeNo, 0)          
  --   END          
  --  )          
  -- AND (          
  --  sc.CityCountry LIKE CASE           
  --   WHEN @City_IATACode IS NOT NULL          
  --    THEN @City_IATACode          
  --   ELSE sc.CityCountry          
  --   END          
  --  )          
  -- AND (          
  --  SC.MarketID = CASE           
  --   WHEN @MarketID IS NOT NULL          
  --    THEN @MarketID          
  --   ELSE SC.MarketID          
  --   END          
  --  )          
 -- SELECT ContactDetailsID  
 --  ,ParentID  
 --  ,TypeID  
 --  ,IsPrimaryContact  
 --  ,Cd.SalutationID  
 --  ,FirstName  
 --  ,LastName  
 --  ,DesignationOrDepartment  
 --  ,EmailID  
 --  ,OfficeNo  
 --  ,MobileNo  
 --  ,FaxNo  
 --  ,S.Salutation AS Salutation  
 --  ,Replace(CONVERT(VARCHAR(15), DateOfBirth, 106), ' ', '-') AS DateOfBirth  
 --  ,CityIATACode,  
 --  CityIATACode as City_IATACode  
 --  ,City.Name AS CityName  
 --  --,Cd.IsActive   commneted by sanket @ 23/11/2015                                                         
 --  ,CASE   
 --   WHEN Cd.TypeID = 3  
 --    THEN AL.IsActive  
 --   ELSE Cd.IsActive  
 --   END AS IsActive -- if agent then contact isactive from  AgentLogin else contactdetails page                                                     
 --  ,Cd.IsForContracting  
 --  ,ISNULL(Cd.IsAccStatement, 0) AS IsAccStatement  
 --  ,ISNULL(AL.IsB2BLogin, 0) AS IsB2BLogin  
 --  ,isnull(AL.IsB2CLogin, 0) AS IsB2CLogin  
 -- FROM ContactDetails Cd  
 -- LEFT JOIN City ON Cd.CityIATACode = City.IATACode  
 -- LEFT JOIN Salutation S ON Cd.SalutationID = S.SalutationID  
 -- LEFT JOIN AgentLogin AL ON AL.AgentContactID = Cd.ContactDetailsID  
 --  AND Cd.TypeID = 3 --added by sanket @ 23/11/2015                                        
 -- WHERE (  
 --   TypeID = @TypeID  
 --   OR @TypeID IS NULL  
 --   OR @TypeID = 0  
 --   )  
 --  AND (  
 --   ParentID = @ParentID  
 --   OR @ParentID IS NULL  
 --   OR @ParentID = 0  
 --   )  
 --  AND (  
 --   @ContactDetailsID = ContactDetailsID  
 --   OR @ContactDetailsID = 0  
 --   OR @ContactDetailsID IS NULL  
 --   )  
 --   Order by 1 Desc  
 --END  
 ELSE IF @Action = 's'  
BEGIN  
    SELECT   
        ContactDetailsID,  
        ParentID,  
        TypeID,  
        IsPrimaryContact,  
        Cd.SalutationID,  
        FirstName,  
        LastName,  
        DesignationOrDepartment,  
        EmailID,  
        OfficeNo,  
        MobileNo,  
        FaxNo,  
        S.Salutation AS Salutation,  
        Replace(CONVERT(VARCHAR(15), DateOfBirth, 106), ' ', '-') AS DateOfBirth,  
        CityIATACode,  
        CityIATACode AS City_IATACode,  
        City.Name AS CityName,  
        CASE   
            WHEN Cd.TypeID = 3 THEN AL.IsActive  
            ELSE Cd.IsActive  
        END AS IsActive,  
        Cd.IsForContracting,  
        ISNULL(Cd.IsAccStatement, 0) AS IsAccStatement,  
        ISNULL(AL.IsB2BLogin, 0) AS IsB2BLogin,  
        ISNULL(AL.IsB2CLogin, 0) AS IsB2CLogin,  
        Cd.BizPStatus  -- Added column to results  
    FROM ContactDetails Cd  
    LEFT JOIN City ON Cd.CityIATACode = City.IATACode  
    LEFT JOIN Salutation S ON Cd.SalutationID = S.SalutationID  
    LEFT JOIN AgentLogin AL ON AL.AgentContactID = Cd.ContactDetailsID  
    WHERE (  
        TypeID = @TypeID OR @TypeID IS NULL OR @TypeID = 0  
    )  
    AND (  
        ParentID = @ParentID OR @ParentID IS NULL OR @ParentID = 0  
    )  
    AND (  
        @ContactDetailsID = ContactDetailsID OR @ContactDetailsID = 0 OR @ContactDetailsID IS NULL  
    )  
    ORDER BY ContactDetailsID DESC;  
END  
 ELSE IF @Action = 'D'  
 BEGIN  
 DELETE FROM ContactDetails  
 WHERE ContactDetailsID = @ContactDetailsID  
 SELECT '200' AS returnCode,'Record Deleted Successfully' AS returnMessage  
 END  
END