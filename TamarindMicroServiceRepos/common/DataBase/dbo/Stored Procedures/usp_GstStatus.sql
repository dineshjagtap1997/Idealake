CREATE PROCEDURE [dbo].[usp_GstStatus] (                    
 @State_ID INT = NULL            
 ,@Status_ID INT = NULL             
 ,@EffectiveDate Nvarchar(500)=''                    
 ,@OperationBy UNIQUEIDENTIFIER=NUll                    
 ,@Action CHAR(2)=''                    
 ,@ID INT = NULL                   
 )                    
AS                    
BEGIN              
 Declare @LogID int;           
   IF @Action='I'                    
    BEGIN                                  
   IF EXISTS (
    SELECT ID
    FROM GSTStatus
    WHERE [State] = @State_ID
)
BEGIN
    SET @LogID = SCOPE_IDENTITY()
    SELECT '201' AS ReturnCode, 
           'Gst Status already exists for the selected State. Please check and try again.' AS ReturnMessage, 
           @LogID AS ID;
END
ELSE
BEGIN
    INSERT INTO [GSTStatus] (
        [State], [Status], [EffectiveDate], [CreatedDate], [CreatedBy]
    )
    VALUES (
        @State_ID, @Status_ID, CAST(@EffectiveDate AS datetime), GETDATE(), @OperationBy
    )

    SET @LogID = SCOPE_IDENTITY()
    SELECT '200' AS ReturnCode, 
           'New record added successfully.' AS ReturnMessage, 
           @LogID AS ID;
END
END
    ELSE IF @Action='U'                    
    BEGIN                    
        SET NOCOUNT ON;                    
                         
        UPDATE [GSTStatus]                     
        SET [State] = @State_ID,                    
            [Status] = @Status_ID,                    
            [EffectiveDate] = CAST (@EffectiveDate  AS datetime)                   
        WHERE ID = @ID                     
                         
        SELECT '200' AS ReturnCode, 'Record updated successfully.' AS ReturnMessage  , @ID AS ID;                   
    END                      
    ELSE IF @Action='S'                    
    BEGIN                    
        SELECT GST.ID,                    
               ST.State_ID AS State_ID,                    
               ST.Name AS State,                  
               FG.ID AS Status_ID,                    
               FG.FlagName AS 'Status',                    
               FORMAT(GST.EffectiveDate, 'ddMMMyyyy') AS EffectiveDate,                    
               FORMAT(GST.CreatedDate, 'ddMMMyyyy') AS CreatedDate,                    
               GST.CreatedBy                    
        FROM GSTStatus GST                    
        LEFT JOIN STATE ST ON GST.STATE = ST.State_ID                    
        LEFT JOIN GSTFlag FG ON FG.ID = GST.STATUS                    
        WHERE (@ID IS NULL OR @ID = 0 OR GST.ID = @ID)        
        ORDER BY GST.ID DESC;              
    END         
    ELSE IF @Action='EX'                    
    BEGIN                    
<<<<<<< HEAD
<<<<<<< HEAD
        SELECT ST.Name AS State,                  
=======
        SELECT	
			ST.State_ID,
			ST.Name AS State,                  
>>>>>>> dev
=======
        SELECT	
			ST.State_ID,
			ST.Name AS State,                  
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
               FG.FlagName AS 'Status',                    
               FORMAT(GST.EffectiveDate, 'ddMMMyyyy') AS EffectiveDate
        FROM GSTStatus GST                    
        LEFT JOIN STATE ST ON GST.STATE = ST.State_ID                    
        LEFT JOIN GSTFlag FG ON FG.ID = GST.STATUS                    
        WHERE (@ID IS NULL OR @ID = 0 OR GST.ID = @ID)        
        ORDER BY GST.ID DESC;              
    END       
END
