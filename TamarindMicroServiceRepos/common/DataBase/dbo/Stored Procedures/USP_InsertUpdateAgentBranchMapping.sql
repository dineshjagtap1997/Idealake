                      
CREATE PROCEDURE [dbo].[USP_InsertUpdateAgentBranchMapping]                          
@AgentBranchID INT = 0 ,                          
@AgentID INT = 0,                          
@BranchName VARCHAR(250) = '',                    
@Action CHAR(2) = ''  ,      
@OperationBy UNIQUEIDENTIFIER = NULL       
AS                      
BEGIN                    
 Declare @LogID int;                
    IF @Action = 'U'                    
    BEGIN                          
        IF EXISTS (SELECT 1 FROM AgentBranchMapping WHERE AgentID = @AgentID and BranchName = @BranchName)          
  begin        
          
        SELECT '201' AS returnCode, 'This Branch already exists. Please check and try again.' AS returnMessage        
  end               
  else      
        BEGIN                          
            UPDATE AgentBranchMapping                     
            SET BranchName = @BranchName                     
            WHERE AgentBranchID = @AgentBranchID                        
                    
            SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage , @AgentBranchID as ID;                    
        END                      
                         
    END                    
                        
    ELSE IF @Action = 'S'                    
    BEGIN                    
        DECLARE @RowCount INT;                    
                    
        SELECT * FROM AgentBranchMapping WHERE   (AgentID = @AgentID OR @AgentID IS NULL )  AND  (AgentBranchID = @AgentBranchID OR @AgentBranchID IS NULL  OR @AgentBranchID =0)       
          
  ORDER BY  AgentBranchID DESC          
                    
        -- Check if any rows were returned                    
        SET @RowCount = @@ROWCOUNT;                    
                    
        --IF @RowCount > 0                    
        --BEGIN                    
        --    --SELECT '200' AS returnCode, 'Data Retrieved Successfully' AS returnMessage;                    
        --END                    
        --ELSE                    
        --BEGIN                    
        --    SELECT '404' AS returnCode, 'No Record Found' AS returnMessage;                    
        --END                    
    END                    
    
	ELSE IF @Action = 'EX'                    
    BEGIN                                      
                    
        SELECT BranchName FROM AgentBranchMapping 
		WHERE   (AgentID = @AgentID OR @AgentID IS NULL )  
		AND  (AgentBranchID = @AgentBranchID OR @AgentBranchID IS NULL  OR @AgentBranchID =0)       
        ORDER BY  AgentBranchID DESC          
        
    END                    
                    
    ELSE IF @Action = 'I'                    
    BEGIN                  
         
        IF EXISTS (SELECT 1 FROM AgentBranchMapping WHERE AgentID = @AgentID and BranchName = @BranchName)          
  begin        
          
        SELECT '201' AS returnCode, 'This Branch already exists. Please check and try again.' AS returnMessage        
  end        
  else        
  begin        
        
        INSERT INTO AgentBranchMapping (AgentID, BranchName)                           
        VALUES (@AgentID, @BranchName);                      
                     
    SET @LogID = SCOPE_IDENTITY()              
        SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @LogID as ID;          
  end        
    END                    
                    
    ELSE                    
    BEGIN                    
        SELECT '400' AS returnCode, 'Invalid Action' AS returnMessage;                    
    END                    
END 