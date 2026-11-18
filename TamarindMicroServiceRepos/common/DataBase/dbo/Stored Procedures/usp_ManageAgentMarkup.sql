CREATE PROCEDURE [dbo].[usp_ManageAgentMarkup]              
(              
    @Action VARCHAR(10), -- 'SELECT', 'INSERT', 'UPDATE'              
    @AgentMarkupID INT = NULL, -- For UPDATE and DELETE              
    @AgentCategoryID INT = NULL, -- For INSERT/UPDATE              
    @CodeDescription VARCHAR(100) = NULL,              
    @ValidFrom DATETIME = '',              
    @ValidTo DATETIME = '',              
    @Hotel NUMERIC(18,2) = NULL,              
    @Transport NUMERIC(18,2) = NULL,              
    @Guide NUMERIC(18,2) = NULL,              
    @Monument NUMERIC(18,2) = NULL,              
    @FlightTrain NUMERIC(18,2) = NULL,              
    @SpecialService NUMERIC(18,2) = NULL,              
    @Package NUMERIC(18,2) = NULL,              
    @IsActive BIT = NULL,              
    @OperationBy UNIQUEIDENTIFIER = NULL,              
    @SupplierID INT = NULL              
)              
AS              
BEGIN              
   DECLARE @ReturnCode NVARCHAR(3), @ReturnMessage NVARCHAR(MAX);                      
     Declare @LogID int;             
              
    -- SELECT Operation              
    IF @Action = 'S'              
    BEGIN              
     SELECT AgentMarkupID,VendorName,AgentCategoryID,AgentCategoryMaster.CategoryValue,CodeDescription,ValidFrom,ValidTo,Hotel,Transport,Guide,Monument,  
  FlightTrain,      
  SpecialService,Package,AgentMarkup.IsActive,AgentMarkup.Operation,AgentMarkup.OperationBy,AgentMarkup.OperationOn  
    ,SupplierID --addded by sanket @ 25/02/2014      
  ,CASE WHEN  SupplierID=0 THEN 'Tamarind' ELSE VM.VendorName END AS SupplierName      
  FROM AgentMarkup      
  inner join AgentCategoryMaster on AgentCategoryMaster.CategoryID=AgentMarkup.AgentCategoryID  
    left JOIN VendorMaster VM ON VM.VendorID=SupplierID       
 WHERE (    
    @AgentMarkupID IS NULL    
    OR @AgentMarkupID = 0    
    OR AgentMarkupID = @AgentMarkupID    
    )    
 order by 1 desc  
    END              
      
	  ELSE IF @Action='EX'
	  BEGIN
	                
     SELECT VendorName,AgentCategoryMaster.CategoryValue,CodeDescription,ValidFrom,ValidTo,Hotel,Transport,Guide,Monument,  
  FlightTrain,      
  SpecialService,Package,CASE   
        WHEN AgentMarkup.IsActive = 1 THEN 'True'  
        WHEN AgentMarkup.IsActive = 0 THEN 'False'  
    END AS IsActive    
  ,CASE WHEN  SupplierID=0 THEN 'Tamarind' ELSE VM.VendorName END AS SupplierName      
  FROM AgentMarkup      
  inner join AgentCategoryMaster on AgentCategoryMaster.CategoryID=AgentMarkup.AgentCategoryID  
    left JOIN VendorMaster VM ON VM.VendorID=SupplierID       
 WHERE (    
    @AgentMarkupID IS NULL    
    OR @AgentMarkupID = 0    
    OR AgentMarkupID = @AgentMarkupID    
    )    
 order by 1 desc  
    
	  END
	  
    ELSE IF @Action = 'I'              
    BEGIN              
        -- Check if the combination of AgentCategoryID and SupplierID already exists for the specified period              
        IF EXISTS (              
            SELECT AgentMarkupID              
            FROM AgentMarkup              
            WHERE AgentCategoryID = @AgentCategoryID        
            AND SupplierID = @SupplierID              
            AND (              
                CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112) BETWEEN CONVERT(VARCHAR, ValidFrom, 112) AND CONVERT(VARCHAR, ValidTo, 112)              
                OR CONVERT(VARCHAR, CAST(@ValidTo AS DATETIME), 112) BETWEEN CONVERT(VARCHAR, ValidFrom, 112) AND CONVERT(VARCHAR, ValidTo, 112)              
                OR CONVERT(VARCHAR, CAST(ValidFrom AS DATETIME), 112) = CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112)              
                OR CONVERT(VARCHAR, CAST(ValidTo AS DATETIME), 112) = CONVERT(VARCHAR, CAST(@ValidTo AS DATETIME), 112)              
            )              
        )              
        BEGIN              
            SET @ReturnCode = '201';                        
     SET @ReturnMessage ='Agent category already exist for this period. Please check and try again.'   
  SET  @LogID = @LogID ;     
        END              
ELSE              
        BEGIN              
            -- Insert the new AgentMarkup record              
            INSERT INTO AgentMarkup              
            (              
                AgentCategoryID,               
                CodeDescription,               
                ValidFrom,               
                ValidTo,               
                Hotel,               
                Transport,               
                Guide,               
                Monument,               
                FlightTrain,               
                SpecialService,               
                Package,               
                IsActive,               
                Operation,               
                OperationBy,               
                OperationOn,               
                SupplierID              
            )              
            VALUES              
            (              
                @AgentCategoryID,               
                @CodeDescription,               
                @ValidFrom,               
                @ValidTo,               
                @Hotel,               
                @Transport,               
                @Guide,               
                @Monument,               
                @FlightTrain,               
                @SpecialService,               
                @Package,               
                @IsActive,               
                'Insert',               
                @OperationBy,               
                GETDATE(),               
                @SupplierID              
            )          
   SET @LogID = SCOPE_IDENTITY()   
            SET @ReturnCode = '200';                        
     SET @ReturnMessage ='New record added successfully'; -- No error, operation successful              
        END              
    END              
              
    -- UPDATE Operation              
    ELSE IF @Action = 'U'              
    BEGIN              
        -- Check if the combination of AgentCategoryID and SupplierID already exists for the specified period, excluding the current AgentMarkupID              
        IF EXISTS (              
            SELECT AgentMarkupID              
            FROM AgentMarkup              
            WHERE AgentCategoryID = @AgentCategoryID              
            AND AgentMarkupID <> @AgentMarkupID              
            AND SupplierID = @SupplierID              
            AND (              
                CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112) BETWEEN CONVERT(VARCHAR, ValidFrom, 112) AND CONVERT(VARCHAR, ValidTo, 112)              
                OR CONVERT(VARCHAR, CAST(@ValidTo AS DATETIME), 112) BETWEEN CONVERT(VARCHAR, ValidFrom, 112) AND CONVERT(VARCHAR, ValidTo, 112)              
                OR CONVERT(VARCHAR, CAST(ValidFrom AS DATETIME), 112) = CONVERT(VARCHAR, CAST(@ValidFrom AS DATETIME), 112)              
                OR CONVERT(VARCHAR, CAST(ValidTo AS DATETIME), 112) = CONVERT(VARCHAR, CAST(@ValidTo AS DATETIME), 112)              
            )              
        )              
        BEGIN              
            SET @ReturnCode = '201';                        
     SET @ReturnMessage ='Agent category already exist for this period. Please check and try again'       
  SET @LogID = @LogID   
        END              
        ELSE              
        BEGIN              
            -- Update the existing AgentMarkup record              
            UPDATE AgentMarkup              
            SET              
                AgentCategoryID = @AgentCategoryID,              
                CodeDescription = @CodeDescription,              
                ValidFrom = @ValidFrom,              
                ValidTo = @ValidTo,              
                Hotel = @Hotel,              
                Transport = @Transport,              
                Guide = @Guide,              
                Monument = @Monument,              
                FlightTrain = @FlightTrain,              
                SpecialService = @SpecialService,              
                Package = @Package,              
                IsActive = @IsActive,              
                Operation = 'Update'              
               ,UpdatedBy = @OperationBy              
    ,UpdatedOn = GETDATE(),              
                SupplierID = @SupplierID              
            WHERE AgentMarkupID = @AgentMarkupID              
            SET @ReturnCode = '200';                        
     SET @ReturnMessage ='Record updated successfully.'; -- No error, operation successful       
  SET @LogID = @AgentMarkupID   
        END              
    END              
        
    ELSE              
    BEGIN              
        SET @ReturnCode = '201';                        
     SET @ReturnMessage ='Invalid action.';              
    END              
    SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage , @LogID AS ID;                  
END 