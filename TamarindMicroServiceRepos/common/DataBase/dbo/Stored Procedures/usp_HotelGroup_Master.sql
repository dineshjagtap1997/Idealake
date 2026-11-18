CREATE PROCEDURE [dbo].[usp_HotelGroup_Master] @IATACode CHAR(3)             
,@HotelGroupID int=null            
 ,@Name VARCHAR(200)              
 ,@IsActive BIT              
 ,@OperationBy uniqueidentifier=''              
 --,@ErrMsg VARCHAR(50) =''              
 ,@Action char(2)=''              
               
AS              
BEGIN              
            
            
 Declare @LogID int;             
            
            
IF @Action ='I'              
BEGIN              
             
 IF EXISTS (              
   SELECT Name              
   FROM HotelGroups              
   WHERE UPPER(Name) = UPPER(@Name)              
   )              
 BEGIN              
 SELECT '201' AS returnCode, 'Hotel Group already exists. Please check and try again.' as returnMessage              
 -- SET @ErrMsg = 'Name already exists!'              
 END              
 ELSE              
 BEGIN              
  INSERT INTO HotelGroups (              
   IATACode              
   ,Name              
   ,IsActive              
   ,Operation              
   ,OperationBy              
   ,OperationOn              
   ,OldID              
   )              
  VALUES (              
   UPPER(@IATACode)              
   ,@Name              
   ,@IsActive              
   ,'Insert'              
   ,@OperationBy              
   ,GETDATE()              
   ,UPPER(@IATACode)              
   )              
              
  --EXEC usp_InsertHotelGroups_Audit @IATACode              
  -- ,'Insert'              
  -- ,@OperationBy              
  Set @LogID =  @@identity            
 SELECT '200' AS returnCode, 'New record added successfully.' as returnMessage, @LogID as ID               
              
  --SET @ErrMsg = ''              
 END              
END--I              
ELSE IF @Action='S'              
BEGIN              
SELECT HotelGroupID,IATACode,               
Name,               
IsActive                
FROM HotelGroups               
Where (@HotelGroupID IS NULL OR @HotelGroupID = 0 OR HotelGroupID = @HotelGroupID)        
ORDER BY HotelGroupID DESC      
END              
ELSE IF @Action='U'              
BEGIN              
 IF EXISTS (              
   SELECT Name              
   FROM HotelGroups              
   WHERE UPPER(Name) = UPPER(@Name)              
    AND UPPER(IATACode) <> UPPER(@IATACode)              
   )              
 BEGIN              
  --SET @ErrMsg = 'Name already exists!'              
 SELECT '201' AS returnCode, 'IATACode already exists. Please check and try again.' as returnMessage              
              
 END              
 ELSE              
 BEGIN              
  UPDATE HotelGroups              
  SET Name = @Name              
   ,IsActive = @IsActive              
   ,Operation = 'Update'              
   ,OperationBy = @OperationBy              
   ,UpdatedOn = GETDATE()              
  , IATACode = @IATACode              
  WHERE HotelGroupID = @HotelGroupID              
              
  --EXEC usp_InsertHotelGroups_Audit @IATACode              
  -- ,'Update'              
  -- ,@OperationBy              
 SELECT '200' AS returnCode, 'Record updated successfully.' as returnMessage , @HotelGroupID AS ID              
              
 END              
END   
ELSE IF @Action='EX'  
BEGIN  
SELECT IATACode,               
Name, CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive                
FROM HotelGroups               
Where (@HotelGroupID IS NULL OR @HotelGroupID = 0 OR HotelGroupID = @HotelGroupID)        
ORDER BY HotelGroupID DESC      
END     
  
END 