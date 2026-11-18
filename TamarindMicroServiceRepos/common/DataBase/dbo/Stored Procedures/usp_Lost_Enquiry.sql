<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [dbo].[usp_Lost_Enquiry]      
    @EQID BIGINT='',      
    @LostID BIGINT='',      
    @AgentID BIGINT='',      
    @Comment VARCHAR(MAX)='',      
    @LostReason VARCHAR(MAX)='',      
 @Action CHAR(2) =''      
AS      
BEGIN    
DECLARE @LogID INT  
IF @Action ='I'      
      
BEGIN      
      
    INSERT INTO tbl_lostEnquiry (EQID, LostID, AgentID, Comment)      
    VALUES (@EQID, @LostID, @AgentID, @Comment)      
    
  SET @LogID = SCOPE_IDENTITY()  
 select '200' as returnCode, 'Enquiry Lost Successfully' as returnMessage, @LogID AS ID    
 END      
 ELSE IF @Action='S'      
 BEGIN      
    SELECT * FROM tbl_lostEnquiry      
 END      
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿CREATE PROCEDURE [dbo].[usp_Lost_Enquiry]        
    @EQID BIGINT='',        
    @LostID BIGINT='',        
    @AgentID BIGINT='',        
    @Comment VARCHAR(MAX)='',        
    @LostReason VARCHAR(MAX)='',        
 @Action CHAR(2) =''        
AS        
BEGIN      
DECLARE @LogID INT    
IF @Action ='I'        
        
BEGIN        
        
    INSERT INTO tbl_lostEnquiry (EQID, LostID, AgentID, Comment)        
    VALUES (@EQID, @LostID, @AgentID, @Comment)        
      
  SET @LogID = SCOPE_IDENTITY()    
 select '200' as returnCode, 'Enquiry Lost status has been updated successfully.' as returnMessage, @LogID AS ID      
 END        
 ELSE IF @Action='S'        
 BEGIN        
    SELECT * FROM tbl_lostEnquiry        
 END        
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END; 