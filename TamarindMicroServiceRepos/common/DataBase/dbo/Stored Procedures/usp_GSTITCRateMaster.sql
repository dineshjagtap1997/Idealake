CREATE PROCEDURE [dbo].[usp_GSTITCRateMaster]             
    @ITCPercentage DECIMAL(10, 2)= NULL,            
    @RateForSAP DECIMAL(10, 2)=NULL,            
    @IsActive BIT=NULL,            
    @OperationBy UNIQUEIDENTIFIER=NULL,            
    @Action CHAR(2) = NULL,            
    @UpdatedBy UNIQUEIDENTIFIER = NULL,  -- Change to UNIQUEIDENTIFIER            
    @TAXID INT = NULL            
AS            
BEGIN      
    
declare @LogID int;     
    IF @Action = 'I'            
    BEGIN            
        DECLARE @new_identity INT            
            
        IF EXISTS (            
                SELECT ITCPercentage            
                FROM GSTITCRateMaster            
                WHERE ITCPercentage = @ITCPercentage            
                )            
        BEGIN            
            SELECT '201' AS returnCode, 'ITC Percentage already exists. Please check and try again.' AS returnMessage, @LogID as ID;            
        END            
        ELSE            
        BEGIN            
            INSERT INTO GSTITCRateMaster (            
                ITCPercentage, RateForSAP, IsActive, Operation, CreatedBy, CreatedDatetime            
            )            
            VALUES (            
                @ITCPercentage, @RateForSAP, @IsActive, 'Insert', @OperationBy, GETDATE()            
            )            
            
            SELECT @new_identity = SCOPE_IDENTITY()            
            
            --EXEC usp_InsertGSTITCRateMaster_Audit             
            --    @new_identity, @ITCPercentage, @RateForSAP, @IsActive, 'Insert', @CreatedBy            
            
            SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @new_identity AS ID ;            
        END            
    END            
    ELSE IF @Action = 'U'            
    BEGIN            
        -- Ensure UpdatedBy is passed correctly            
        UPDATE GSTITCRateMaster            
        SET ITCPercentage = @ITCPercentage,            
            RateForSAP = @RateForSAP,            
            IsActive = @IsActive,            
            Operation = 'Update',            
            UpdatedBy = @OperationBy, -- Now correctly using UNIQUEIDENTIFIER            
            UpdatedDatetime = GETDATE()            
        WHERE TAXID = @TAXID            
            
        -- EXEC usp_InsertGST_Percentage_Audit @GSTID, @GSTPercentage, @IsActive, 'Update', @OperationBy                   
        --EXEC usp_InsertGSTITCRateMaster_Audit             
        --    @TAXID, @ITCPercentage, @RateForSAP, @IsActive, 'Update', @UpdatedBy            
            
        SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @TAXID as ID;            
    END            
    ELSE IF @Action = 'S'            
    BEGIN             
            SELECT TaxID, ITCPercentage, RateForSAP  ,IsActive         
            FROM GSTITCRateMaster C           
   where  (@TAXID IS NULL OR @TAXID = 0 OR TaxID = @TAXID)          
            ORDER BY C.TAXID   DESC            
         
    END        
    
	ELSE IF @Action = 'EX'            
BEGIN             
    SELECT  
        ITCPercentage, 
        RateForSAP,
        IsActive  
    FROM GSTITCRateMaster
    WHERE (@TAXID IS NULL OR @TAXID = 0 OR TaxID = @TAXID)          
    ORDER BY TAXID DESC;            
END
END 