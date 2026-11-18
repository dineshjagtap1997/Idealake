CREATE PROCEDURE [dbo].[USP_InsertEmailConfiguration]  
(  
    @Action CHAR(2), 
	@EmailTemplateId Int,
    @EmailCategory INT = NULL,  
    @FromEmailAddress VARCHAR(50) = NULL,  
    @ToEmailAddress VARCHAR(1000) = NULL,  
    @Subject VARCHAR(200) = NULL,  
    @EmailBody VARCHAR(MAX) = NULL,  
    @OperationBy Int  = NULL 
)  
AS  
BEGIN  
    BEGIN TRY  
        IF @Action = 'S' -- Select  
        BEGIN  

	--	Select	EmailTemplateID,EmailCategory,FromEmailAddress,ToEmailAddress,Subject,EmailBody,Operation,CreatedBy,CreatedOn
	--From	Email_Configuration
	--WHERE	EmailCategory= @EmailCategory
            SELECT EmailTemplateID,EmailCategory, FromEmailAddress, ToEmailAddress, Subject, EmailBody, Operation, CreatedBy,CreatedOn 
            FROM Email_Configuration where (@EmailCategory IS NULL OR @EmailCategory = 0 OR EmailCategory = @EmailCategory);  
  
            SELECT '200' AS returnCode, 'Data retrieved successfully.' AS returnMessage;  
        END  
        ELSE IF @Action = 'U' -- Update  
        BEGIN  
           IF EXISTS(SELECT EmailCategory FROM Email_Configuration WHERE EmailCategory=@EmailCategory AND EmailTemplateID!=@EmailTemplateId)        
BEGIN
                SELECT '201' AS returnCode, 'Email Category is already exists!' AS returnMessage;  
            END  
            ELSE  
            BEGIN  
			Update Email_Configuration SET EmailCategory=@EmailCategory,            
FromEmailAddress=@FromEmailAddress,ToEmailAddress=@ToEmailAddress,[Subject]=@Subject,EmailBody=@EmailBody,            
UpdatedBy=@operationBy,Operation='UPDATE',UpdatedOn=GETDATE()           
WHERE EmailTemplateID=@EmailTemplateId 
    --            UPDATE Email_Configuration  
    --            SET FromEmailAddress = @FromEmailAddress,  
    --                ToEmailAddress = @ToEmailAddress,  
    --                [Subject] = @Subject,  
    --                EmailBody = @EmailBody,  
    --                Operation = 'UPDATE',  
    -- UpdatedBy = @OperationBy  
    --,UpdatedOn = GETDATE()  
    --            WHERE EmailCategory = @EmailCategory;  
  
                SELECT '200' AS returnCode, 'Data updated successfully.' AS returnMessage;  
            END  
        END  
        ELSE IF @Action = 'I' -- Insert  
        BEGIN  
            IF EXISTS (SELECT 1 FROM Email_Configuration WHERE EmailCategory = @EmailCategory)  
            BEGIN  
                SELECT '201' AS returnCode, 'Email category already exists.' AS returnMessage;  
            END  
            ELSE  
            BEGIN  
                INSERT INTO Email_Configuration  
                (EmailCategory, FromEmailAddress, ToEmailAddress, [Subject], EmailBody, Operation, CreatedBy, CreatedOn)  
                VALUES  
                (@EmailCategory, @FromEmailAddress, @ToEmailAddress, @Subject, @EmailBody, 'INSERT', @OperationBy, GETDATE());  
  
                SELECT '200' AS returnCode, 'Data inserted successfully.' AS returnMessage;  
            END  
        END  
        ELSE  
        BEGIN  
            SELECT '201' AS returnCode, 'Invalid action performed. Use "I" for Insert, "U" for Update, or "S" for Select.' AS returnMessage;  
        END  
    END TRY  
    BEGIN CATCH  
        SELECT '500' AS returnCode, 'Error' AS returnMessage;  
    END CATCH  
END  