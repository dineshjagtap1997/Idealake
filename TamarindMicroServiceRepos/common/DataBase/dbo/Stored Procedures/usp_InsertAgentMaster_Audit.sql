CREATE PROCEDURE [dbo].[usp_InsertAgentMaster_Audit]  
(  
@AgentID int,  
@CreditApplicable bit,  
@CreditCurrencyCode varchar(5),  
@CreditAllowance decimal(18,5),  
@Threshold decimal(18,5),  
@CreditPeriod int,  
@OutStandingAmount decimal(18,5),  
@UnlimitedCredit bit,  
@Operation varchar(10),  
@OperationBy uniqueidentifier,  
@IsActive bit=0    
)  
AS  
BEGIN  
  
INSERT INTO AgentMaster_Audit (AgentID,CreditApplicable,CreditCurrencyCode,CreditAllowance,Threshold,CreditPeriod,OutStandingAmount,  
   UnlimitedCredit,Operation,OperationBy,OperationOn,IsActive)  
 VALUES (@AgentID,@CreditApplicable,@CreditCurrencyCode,@CreditAllowance,@Threshold,@CreditPeriod,@OutStandingAmount,@UnlimitedCredit,  
   @Operation,@OperationBy,GETDATE(),@IsActive)  
  
END