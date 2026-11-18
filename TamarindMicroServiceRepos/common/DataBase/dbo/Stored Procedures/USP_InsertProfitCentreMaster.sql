CREATE Procedure [dbo].[USP_InsertProfitCentreMaster]     
 @SAPCompCode varchar(5),     
 @EntityMasterID int,  
 @CompanyName varchar(200),  
 @SAP_BusinessPlaceCode varchar(5),  
 @BussinessModuleID int,  
  
 @ProfitCentreCode varchar(10),  
 @ProfitCentreName nvarchar(51),  
 @IsActive bit,  
 @OperationBy uniqueidentifier,  
 @ErrMsg   VARCHAR(50) OUT            
as      
begin      
 Declare @new_identity INT  
  
 DECLARE @CompanyID INT  
 SET @CompanyID = (SELECT COMPANYID FROM COMPANYMASTER WHERE CompanyName = @CompanyName)  
   
 IF  EXISTS(SELECT * FROM ProfitCentreMaster WHERE ProfitCentreCode = @ProfitCentreCode)            
 BEGIN            
  SET   @ErrMsg = 'Profit Centre Code already exist!'            
 END            
 ELSE  
 IF  EXISTS(SELECT * FROM ProfitCentreMaster WHERE SAPCompCode = @SAPCompCode AND EntityMasterID = @EntityMasterID AND  
 CompanyID = @CompanyID AND SAP_BusinessPlaceCode = @SAP_BusinessPlaceCode AND BussinessModuleID = @BussinessModuleID  
 AND IsActive = 1)  
  BEGIN  
   SET   @ErrMsg = 'Same selected combination as active already exist!'   
  END  
 ELSE  
  BEGIN        
   INSERT INTO ProfitCentreMaster  
   (SAPCompCode, EntityMasterID, CompanyID, SAP_BusinessPlaceCode, BussinessModuleID,  
   ProfitCentreCode, ProfitCentreName, IsActive, Operation, OperationBy, OperationOn)      
   VALUES      
   (@SAPCompCode, @EntityMasterID, @CompanyID, @SAP_BusinessPlaceCode, @BussinessModuleID,  
   @ProfitCentreCode, @ProfitCentreName, @IsActive, 'INSERT', @OperationBy, GETDATE())  
       
   SELECT @new_identity = SCOPE_IDENTITY()            
            
   EXEC  USP_InsertProfitCentreMaster_Log @new_identity,@SAPCompCode,@EntityMasterID,@CompanyID,@SAP_BusinessPlaceCode,@BussinessModuleID,@ProfitCentreCode,@ProfitCentreName,@IsActive,'INSERT', @OperationBy   
   SET   @ErrMsg = ''  
  END  
end  