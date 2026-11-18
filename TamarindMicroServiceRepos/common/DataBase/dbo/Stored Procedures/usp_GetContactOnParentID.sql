CREATE PROCEDURE [dbo].[usp_GetContactOnParentID]  --952,3                                                  
(                                                      
@ID int,                                            
@TypeID int                                            
)                                                      
AS                                                      
BEGIN                                                
 SELECT ContactDetailsID,ParentID,TypeID,IsPrimaryContact,Cd.SalutationID,FirstName,LastName,DesignationOrDepartment,EmailID,OfficeNo,                                                          
 MobileNo,FaxNo,S.Salutation AS Salutation              
 ,Replace(CONVERT(varchar(15), DateOfBirth,106),' ','-') AS DateOfBirth,CityIATACode,City.Name AS CityName              
 --,Cd.IsActive   commneted by sanket @ 23/11/2015                                               
 ,CASE WHEN  Cd.TypeID=3 THEN  AL.IsActive  ELSE Cd.IsActive END AS IsActive    -- if agent then contact isactive from  AgentLogin else contactdetails page                                           
 ,Cd.IsForContracting          
 ,ISNULL(Cd.IsAccStatement,0) As  IsAccStatement           
 ,ISNULL(AL.IsB2BLogin,0)AS IsB2BLogin,isnull(AL.IsB2CLogin,0) AS IsB2CLogin        
 FROM ContactDetails  Cd                                         
 LEFT JOIN City ON Cd.CityIATACode=City.IATACode                                                 
 LEFT JOIN Salutation S on Cd.SalutationID=S.SalutationID                
  LEFT JOIN AgentLogin AL on AL.AgentContactID=Cd.ContactDetailsID AND Cd.TypeID=3  --added by sanket @ 23/11/2015                                                
 WHERE (TypeID=@TypeID or @TypeID is null or @TypeID = 0) AND (ParentID=@ID or @ID is null or @ID =0)                    
                             
 IF(@TypeID=1)                            
 BEGIN                            
 SELECT Country.IATACode,HotelMaster.HotelName AS DisplayName FROM HotelMaster                                  
 INNER JOIN City ON HotelMaster.CityIATACode=City.IATACode                                  
 INNER JOIN State ON City.State_IATACode=State.State_ID                                  
 INNER JOIN Country ON State.Country_IATACode=Country.IATACode                                  
 WHERE  (HotelID=@ID   or @ID is null or @ID =0)                                     
 END                            
 ELSE IF(@TypeID=2)                            
 BEGIN                            
 SELECT Country.IATACode, VendorMaster.VendorName AS DisplayName FROM VendorMaster                                  
 INNER JOIN City ON VendorMaster.CityIATACode=City.IATACode                                  
 INNER JOIN State ON City.State_IATACode=State.State_ID                                  
 INNER JOIN Country ON State.Country_IATACode=Country.IATACode                                  
 WHERE  (VendorID=@ID or @ID is null or @ID =0)       
 END                            
 ELSE IF(@TypeID=3)                            
 BEGIN                            
 SELECT Country.IATACode,AgentMaster.AgentName AS DisplayName FROM AgentMaster                                  
 INNER JOIN City ON AgentMaster.City_IATACode=City.IATACode                                  
 INNER JOIN State ON City.State_IATACode=State.State_ID                                  
 INNER JOIN Country ON State.Country_IATACode=Country.IATACode                                  
 WHERE  (AgentID=@ID or @ID is null or @ID =0)     
 END                            
END   