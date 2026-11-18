-- =============================================    
-- Author:  Dhanya    
-- Create date: 16th May 2011    
-- Description: Inserts or Updates HotelRuleMaster    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_InsertUpdateHotelRule] (    
    @HotelRuleID INT = 0,         -- Default value changed to 0 for an integer    
    @HotelID INT,    
    @RuleID INT,    
    @MISSequenceNo INT,    
    @ApplicableTo INT,    
    @Description VARCHAR(500),    
    @Action CHAR(2) = ''          -- Default value remains an empty string    
)    
AS    
BEGIN    
    IF @Action = 'U'        
    BEGIN    
        -- Check if the record exists    
        IF EXISTS (    
            SELECT HotelRuleID    
            FROM HotelRuleMaster    
            WHERE HotelRuleID = @HotelRuleID    
        )    
        BEGIN    
            -- Update the record    
            UPDATE HotelRuleMaster    
            SET HotelID = @HotelID,    
                RuleID = @RuleID,    
                MISSequenceNo = @MISSequenceNo,    
                ApplicableTo = @ApplicableTo,    
                [Description] = @Description    
            WHERE HotelRuleID = @HotelRuleID;    
    
            -- Return success message    
            SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage;    
        END    
        ELSE    
        BEGIN    
            -- Return error message if the record doesn't exist    
            SELECT '404' AS returnCode, 'Record Not Found.' AS returnMessage;    
        END    
    END    
    ELSE IF @Action = 'I'          
    BEGIN    
        -- Insert a new record    
        INSERT INTO HotelRuleMaster (    
            HotelID,    
            RuleID,    
            MISSequenceNo,    
            ApplicableTo,    
            Description    
        )    
        VALUES (    
            @HotelID,    
            @RuleID,    
            @MISSequenceNo,    
            @ApplicableTo,    
            @Description    
        );    
    
        -- Return success message    
        SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage;    
    END    
    ELSE    
    BEGIN    
        -- Return error message for invalid action    
        SELECT '400' AS returnCode, 'Invalid Action.' AS returnMessage;    
    END    
END    
    
--select * from HotelRuleMaster