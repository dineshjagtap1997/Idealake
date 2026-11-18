






Create PROCEDURE [Invoice].[USP_GetStateCodePerAgentCode] --DROM0052              
(              
@AgentID varchar(50)              
)              
AS              
Begin              
 select StateCodeID,STRegNo,S.State_Code from AgentMaster A inner join State_Code_Master S on S.ID=A.StateCodeID  
 where AgentCode=@AgentID       
End 

