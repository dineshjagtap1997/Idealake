CREATE PROCEDURE [dbo].[USP_UpdateDataForLockUnlockQuotation]          
@Filecode VARCHAR(50),          
@Var VARCHAR(50)  ,        
@CompID int  = null,        
@YearID int = null,  
@OperationBy UNIQUEIDENTIFIER = ''  
  
AS          
BEGIN   
  
DECLARE @LogID INT  
IF(@Var='Lock')          
 BEGIN          
 UPDATE Quotation SET LockedDate=getdate(),IsLocked=1 WHERE FileCode=@FileCode         
 AND CompanyID=@CompID and YearID=@YearID      
   
 Select '200' as returnCode, +@Filecode+ ' locked successfully.' as returnMessage  
 END          
ELSE          
 BEGIN          
 UPDATE Quotation SET IsLocked=0 WHERE FileCode=@FileCode          
 AND CompanyID=@CompID and YearID=@YearID   
   
 Select '200' as returnCode,  +@Filecode+ ' unlocked successfully.' as returnMessage  
 END           
END