CREATE PROCEDURE [dbo].[usp_Client]   
 @ClientName VARCHAR(255)=NUll  
 ,@MobileNumber VARCHAR(20)=NUll  
 ,@Reference VARCHAR(MAX)=NUll  
 ,@EmailID VARCHAR(255)=NUll  
 ,@CreatedBy INT=NUll  
 ,@UpdatedBy INT=NUll  
 ,@UpdatedDateTime DATETIME=NUll  
 ,@Action CHAR(2) =NUll  
 ,@ClientId INT =NUll  
AS  
BEGIN  
  
IF EXISTS (               SELECT TOP 1 1               FROM [tbl_Client]               WHERE [ClientName] = @ClientName                AND [MobileNumber] = @MobileNumber               )    
 BEGIN  
 SELECT '201' AS returnCode, 'Already Exist' AS returnMessage;  
 END  
 ELSE  
    
 IF @Action = 'I'  
 BEGIN  
  INSERT INTO [dbo].[tbl_Client] (  
   [ClientName]  
   ,[MobileNumber]  
   ,[Reference]  
   ,[EmailID]  
   ,[CreatedBy]  
   ,[CreatedDateTime]  
   ,[UpdatedBy]  
     
   )  
  VALUES (  
   @ClientName  
   ,@MobileNumber  
   ,@Reference  
   ,@EmailID  
   ,@CreatedBy  
   ,GETDATE()  
   ,@UpdatedBy  
     
   );  
   SELECT '200' AS returnCode, 'Data Inserted' AS returnMessage;  
 END  
   
   
 ELSE IF @Action = 'U'  
 BEGIN  
  UPDATE [dbo].[tbl_Client]  
  SET [ClientName] = isnull(@ClientName,ClientName)  
   ,[MobileNumber] = isnull(@MobileNumber,MobileNumber)  
   ,[Reference] = isnull (@Reference,Reference)  
   ,[EmailID] = isnull (@EmailID,EmailID)  
   ,[UpdatedBy] = @UpdatedBy  
   ,[UpdatedDateTime] = GETDATE()  
  WHERE [ClientId] = @ClientId;  
  SELECT '200' AS returnCode, 'Data Updated' AS returnMessage;  
 END  
 ELSE IF @Action = 'S'  
	BEGIN
		SELECT [ClientId]  
		,[ClientName]  
		,[MobileNumber]  
		,[Reference]  
		,[EmailID]  
		,[CreatedBy]  
		,[CreatedDateTime]  
		,[UpdatedBy]  
		,[UpdatedDateTime]  
		FROM [dbo].[tbl_Client];  
	END

 ELSE IF @Action = 'EX'  
	BEGIN
		SELECT
		 [ClientName]  
		,[MobileNumber]  
		,[Reference]  
		,[EmailID]  
		,[CreatedDateTime]  
		,[UpdatedDateTime]  
		FROM [dbo].[tbl_Client];  
	END
END