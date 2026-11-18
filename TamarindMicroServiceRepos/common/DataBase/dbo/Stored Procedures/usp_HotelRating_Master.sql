CREATE PROCEDURE [dbo].[usp_HotelRating_Master]         
 @Code VARCHAR(10)=''              
 ,@Description VARCHAR(50)   =''           
 ,@MISSequence INT  =''            
 ,@Ratings INT =''             
 ,@IsActive BIT =''             
 ,@OperationBy UNIQUEIDENTIFIER  =null            
 ,              
 --@ErrMsg   VARCHAR(50) ='',              
 @Action CHAR(3) = ''              
 ,@ID INT = ''              
AS              
BEGIN           
      
         Declare @LogID int;       
      
 IF @Action = 'I'              
 BEGIN              
  IF EXISTS (              
    SELECT Code              
    FROM HotelRating              
    WHERE upper(Code) = upper(@Code)              
    )              
  BEGIN              
   SELECT '201' AS returnCode              
    ,'This rating already exists. Please check and try again.' AS returnMessage;              
  END              
  ELSE              
  BEGIN              
   DECLARE @MaxID INT = (              
     SELECT MAX(OldID)              
     FROM HotelRating              
     ) + 1              
              
   INSERT INTO HotelRating (              
    Code              
    ,Description              
    ,MISSequence              
    ,IsActive              
    ,Operation              
    ,OperationBy              
    ,OperationOn              
    ,Ratings              
    ,OldID              
    )              
   VALUES (              
    @Code              
    ,@Description              
    ,@MISSequence              
    ,@IsActive              
    ,'Insert'              
    ,@OperationBy              
    ,GETDATE()              
    ,@Ratings              
    ,@MaxID              
    )              
              
   --EXEC usp_InsertHotelRating_Audit @@IDENTITY              
   -- ,'Insert'              
   -- ,@OperationBy         
         
      
      
    Set @LogID =  @@identity       
   SELECT '200' AS returnCode ,'New record added successfully.' AS returnMessage, @LogID as ID;              
  END              
 END --I              
 ELSE IF @Action = 'U'              
 BEGIN              
  IF EXISTS (              
    SELECT Code              
    FROM HotelRating              
    WHERE UPPER(Code) = Upper(@Code)              
     AND ID != @ID              
    )              
  BEGIN              
   SELECT '201' AS returnCode              
    ,'This rating already exists. Please check and try again.' AS returnMessage;              
    --SET  @ErrMsg = 'Rating already exists!'                    
  END              
  ELSE              
  BEGIN              
   UPDATE HotelRating              
   SET Code = ISNULL(@Code  ,Code)           
    ,Description = ISNULL(@Description ,Description)             
    ,MISSequence = isnull(@MISSequence, MISSequence)              
    ,IsActive = Isnull (@IsActive  ,IsActive)           
    ,Operation = 'Update'              
    ,UpdatedBy = Isnull(@OperationBy ,OperationBy)            
    ,UpdatedOn = GETDATE()              
    ,Ratings = isnull(@Ratings  ,Ratings)        
   WHERE ID = @ID              
              
   --EXEC usp_InsertHotelRating_Audit @ID              
   -- ,'Update'              
   -- ,@OperationBy              
              
   SELECT '200' AS returnCode  ,'Record updated successfully.' AS returnMessage,  @ID as ID;;              
  END              
 END --U              
 ELSE IF @Action = 'S'              
 BEGIN              
   SELECT ID              
    ,Code              
    ,Description              
    ,MISSequence              
    ,IsActive              
    ,CONVERT(VARCHAR(10), ID) + '|' + CONVERT(VARCHAR(10), MISSequence) AS HotelRatingValue              
    ,Ratings              
   FROM HotelRating              
   WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)              
   ORDER BY ID DESC              
               
  END    
  ELSE IF @Action='EX'
  BEGIN
    SELECT              
    Description              
    ,MISSequence              
    ,CASE   
        WHEN IsActive = 1 THEN 'True'  
        WHEN IsActive = 0 THEN 'False'  
    END AS IsActive               
    --,CONVERT(VARCHAR(10), ID) + '|' + CONVERT(VARCHAR(10), MISSequence) AS HotelRatingValue              
    ,Ratings              
   FROM HotelRating              
   WHERE (@ID IS NULL OR @ID = 0 OR ID = @ID)              
   ORDER BY ID DESC   
  END
END 