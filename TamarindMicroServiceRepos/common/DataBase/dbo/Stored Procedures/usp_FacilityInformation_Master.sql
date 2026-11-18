CREATE PROCEDURE [dbo].[usp_FacilityInformation_Master]             
@InformationName VARCHAR(50)=''                
 ,@ImageName VARCHAR(50) = NULL                
 ,@Image VARBINARY(MAX) = NULL                
 ,@MISSequenceNo INT =''               
 ,@IsActive BIT  =''              
 ,@OperationBy UNIQUEIDENTIFIER  =NULL             
 --,@ErrMsg VARCHAR(50) OUT                
 ,@Action char(2)=''                
 --,@Active BIT =''                
 ,@FacilityInfoID INT =''  ,              
  @PageNumber BIGINT = NULL,                
  @PageSize INT= NULL              
AS                
BEGIN              
      
Declare @LogID int;       
                
IF @Action='I'                
BEGIN                
IF EXISTS (                
  SELECT TOP 1 1                
  FROM FacilityInformationMaster                
  WHERE UPPER(InformationName) = UPPER(@InformationName)                
  )                
BEGIN                
 SELECT '201' AS returnCode, 'Facility Information already exists. Please check and try again.' AS returnMessage;                       
END                
ELSE                
BEGIN                
 DECLARE @MaxID INT                
                
 --EXEC usp_InsertCustomCaption 'Facilities'                
 -- ,'Facilities'                
 -- ,@InformationName                
 -- ,@MISSequenceNo                
 -- ,@MaxID OUT                
 -- ,1                
 -- ,@ImageName                
                
 INSERT INTO FacilityInformationMaster (                
  InformationName                
  ,ImageName                
  ,[Image]                
  ,MISSequenceNo                
  ,IsActive                
  ,Operation                
  ,OperationBy                
  ,OldID                
  )                
 VALUES (                
  @InformationName                
  ,@ImageName                
  ,@Image                
  ,@MISSequenceNo                
  ,@IsActive                
  ,'Insert'                
  ,@OperationBy                
  ,@MaxID                
  )                
      
  Set @LogID =  SCOPE_IDENTITY()        
  --EXEC   usp_InsertFacilityInformationMaster_Audit  @@IDENTITY, 'Insert', @OperationBy                    
  SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @LogID AS ID;                
END                
                
END--I                
ELSE IF @Action='U'                
BEGIN                                    
 IF NOT EXISTS                    
 (SELECT TOP 1 1 FROM FacilityInformationMaster WHERE UPPER(InformationName) =UPPER(@InformationName)                            
 AND FacilityInfoID <> @FacilityInfoID)                                    
 BEGIN                         
 IF(@ImageName<>'')                      
  BEGIN                      
                                    
    UPDATE FacilityInformationMaster                                    
    SET InformationName = @InformationName,                    
  MISSequenceNo = @MISSequenceNo,                                    
  IsActive  = @IsActive,                                 
  ImageName  = @ImageName,                              
  [Image]   = @Image,                                 
  Operation  = 'Update'                                    
  ,UpdatedBy = @OperationBy            
    ,UpdatedOn = GETDATE()                               
   WHERE FacilityInfoID = @FacilityInfoID                                  
  END                      
  ELSE                      
  BEGIN                       
 UPDATE FacilityInformationMaster                                    
   SET InformationName = @InformationName,                     
  MISSequenceNo = @MISSequenceNo,                                   
  IsActive  = @IsActive,                                 
  --ImageName  = @ImageName,                              
  --[Image]  = @Image,                                 
  Operation  = 'Update'                                    
 ,UpdatedBy = @OperationBy            
    ,UpdatedOn = GETDATE()                           
  WHERE FacilityInfoID  = @FacilityInfoID                           
  END                      
                    
  DECLARE @ID INT                  
 select @ID=OldID from FacilityInformationMaster where FacilityInfoID  = @FacilityInfoID                   
 --EXEC usp_UpdateCustomCaption @InformationName,@MISSequenceNo,@ID,1,@ImageName                  
                                      
SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @FacilityInfoID AS ID;      END                                    
 ELSE                                    
 BEGIN                                    
 SELECT '201' AS returnCode, 'Error In Update' AS returnMessage;                                   
 END                                    
END  --U                
ELSE IF @Action='S'                
BEGIN                          
IF(@IsActive=0)                          
BEGIN                          
  SELECT FacilityInfoID,              
  InformationName,              
  MISSequenceNo,              
  IsActive,              
  ImageName,              
  CAST(NULL AS VARBINARY) AS [Image]                             
  FROM FacilityInformationMaster             
  WHERE InformationName LIKE CASE                   
    WHEN ISNULL(@InformationName, '') <> ''                  
     THEN '%' + @InformationName + '%'                  
    ELSE InformationName                  
    END          
 --SELECT '200' AS returnCode, 'Data Fetched' AS returnMessage;           
  --Order By OperationOn Desc                
  -- added for pagination              
    --OFFSET @PageNumber * @PageSize ROWS              
    --FETCH NEXT @PageSize ROWS ONLY              
END                          
ELSE                          
BEGIN                          
  SELECT FacilityInfoID,InformationName,MISSequenceNo,IsActive,ImageName,CAST(NULL AS VARBINARY) AS [Image]                            
  FROM FacilityInformationMaster                       
  WHERE IsActive=1           
  --SELECT '200' AS returnCode, 'Data Fetched' AS returnMessage;          
  --Order By OperationOn Desc               
  ---- added for pagination              
  --  OFFSET @PageNumber * @PageSize ROWS              
  --  FETCH NEXT @PageSize ROWS ONLY              
                          
END                          
END        

ELSE IF @Action='EX'
BEGIN
IF(@IsActive=0)                          
BEGIN                          
  SELECT              
  InformationName,              
 CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive ,              
  ImageName,              
  CAST(NULL AS VARBINARY) AS [Image]                             
  FROM FacilityInformationMaster             
  WHERE InformationName LIKE CASE                   
    WHEN ISNULL(@InformationName, '') <> ''                  
     THEN '%' + @InformationName + '%'                  
    ELSE InformationName                  
    END          
 --SELECT '200' AS returnCode, 'Data Fetched' AS returnMessage;           
  --Order By OperationOn Desc                
  -- added for pagination              
    --OFFSET @PageNumber * @PageSize ROWS              
    --FETCH NEXT @PageSize ROWS ONLY              
END                          
ELSE                          
BEGIN                          
  SELECT InformationName,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive ,ImageName,CAST(NULL AS VARBINARY) AS [Image]                            
  FROM FacilityInformationMaster                       
  WHERE IsActive=1      
END
END
END 