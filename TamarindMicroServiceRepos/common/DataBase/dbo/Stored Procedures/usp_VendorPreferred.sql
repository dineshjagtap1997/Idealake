CREATE PROCEDURE [dbo].[usp_VendorPreferred] (        
 @VendorID INT=''        
 ,@ValidFrom DATETIME=NULL        
 ,@ValidTo DATETIME=NULL        
 ,@IsPreferred BIT = NULL        
 ,@OperationBy UNIQUEIDENTIFIER=NULL        
 ,@Action char(2)=''        
 ,@PreferredVendorID INT=''        
 --,@ErrMsg VARCHAR(50) OUT        
 )        
AS        
BEGIN      
  
declare @LogID int;   
  
IF @Action='I'        
BEGIN        
 IF EXISTS (        
   SELECT PreferredVendorID        
   FROM VendorPreferred        
   WHERE VendorID = @VendorID        
    AND CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112) BETWEEN CONVERT(VARCHAR, ValidFrom, 112)        
     AND CONVERT(VARCHAR, ValidTo, 112)        
   )        
 BEGIN        
  SELECT '201' AS returnCode,  'This data already exists. Please check and try again.' AS returnMessage, @LogID as ID;             
 END        
 ELSE        
 BEGIN        
  INSERT INTO VendorPreferred (        
   VendorID        
   ,ValidFrom        
   ,ValidTo        
   ,IsPreferred        
   ,Operation        
   ,OperationBy        
   ,OperationOn        
   )        
  VALUES (        
   @VendorID        
   ,@ValidFrom        
   ,@ValidTo        
   ,@IsPreferred        
   ,'Insert'        
   ,@OperationBy        
   ,GETDATE()        
   )        
         
     SET @LogID = SCOPE_IDENTITY()      
 SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @LogID AS ID;             
        
 END        
        
END        
ELSE IF @Action='U'        
BEGIN                
                
  IF EXISTS (SELECT PreferredVendorID FROM VendorPreferred                 
    WHERE VendorID=@VendorID              
    AND CONVERT(varchar,CAST(@ValidFrom AS datetime),112) BETWEEN CONVERT(varchar,ValidFrom,112) AND  CONVERT(varchar,ValidTo,112)                
    AND PreferredVendorID <> @PreferredVendorID)                
                    
  BEGIN        
  SELECT '201' AS returnCode, 'This data already exists. Please check and try again.'   AS returnMessage, @LogID AS ID;                
  END                
  ELSE                
  BEGIN                
    UPDATE  VendorPreferred                   
    SET  VendorID=@VendorID,                
      ValidFrom=@ValidFrom,                
      ValidTo=@ValidTo,                
      IsPreferred=@IsPreferred,                
      Operation='Update',                 
      OperationBy=@OperationBy,                
      OperationOn=GETDATE()                
                
    WHERE PreferredVendorID=@PreferredVendorID          
          
 SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @PreferredVendorID AS ID;             
                
  END                
                 
END         
        
ELSE IF @Action='S'        
BEGIN                  
                
 BEGIN                
  SELECT PreferredVendorID,VP.VendorID,ValidFrom,ValidTo,IsPreferred,                
    VendorName                 
  FROM VendorPreferred VP               
  INNER JOIN VendorMaster VM ON VM.VendorID=VP.VendorID        
       
  WHERE  (@PreferredVendorID IS NULL OR @PreferredVendorID = 0  OR PreferredVendorID = @PreferredVendorID )    -- AND  (@IsPreferred IS NULL OR IsPreferred = @IsPreferred)          
  order by  PreferredVendorID DESC      
 END                 
END         
--ELSE IF @Action='EX'
--BEGIN
-- BEGIN                
--  SELECT ValidFrom,ValidTo,CASE WHEN IsPreferred='1' THEN 'Yes' WHEN IsPreferred='0' THEN 'No' END AS IsPreferred,                
--    VendorName                 
--  FROM VendorPreferred VP               
--  INNER JOIN VendorMaster VM ON VM.VendorID=VP.VendorID        
       
--  WHERE  (@PreferredVendorID IS NULL OR @PreferredVendorID = 0  OR PreferredVendorID = @PreferredVendorID )    -- AND  (@IsPreferred IS NULL OR IsPreferred = @IsPreferred)          
--  order by  PreferredVendorID DESC      
-- END 
ELSE IF @Action='EX'
BEGIN
 BEGIN 
SELECT ValidFrom, ValidTo, IsPreferred, VendorName
FROM VendorPreferred VP
INNER JOIN VendorMaster VM ON VM.VendorID=VP.VendorID
WHERE (@PreferredVendorID IS NULL OR @PreferredVendorID = 0 OR PreferredVendorID = @PreferredVendorID)
ORDER BY PreferredVendorID DESC
end
END
END