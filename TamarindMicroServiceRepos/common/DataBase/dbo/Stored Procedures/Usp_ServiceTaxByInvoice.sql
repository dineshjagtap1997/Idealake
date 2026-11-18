CREATE PROCEDURE [dbo].[Usp_ServiceTaxByInvoice] --'20180326'--'20110916'                              
(     
@AgentID INT, 
@CompanyID INT, 
@DATE DATETIME,             
@Action Varchar(1)                        
)                              
AS                              
BEGIN    

 DECLARE @GST1 INT
 Declare @IsSEZ INT
 Declare @Flag int =1  

 IF @Action = 'S'
 BEGIN




  IF(@Flag=1)            
 BEGIN    

  SELECT @IsSEZ = IsSEZ  from AgentMaster      
  WHERE MarketID=            
  (            
  SELECT MarketID from AgentMaster        
  WHERE AgentID = @AgentID     --'14276'  --- @AgentID       
  AND Miscellaneous=1 )           
 END            
 ELSE IF(@Flag=0)            
 BEGIN            
  SELECT @IsSEZ = IsSEZ 
   
  FROM AgentMaster         
  WHERE AgentID = @AgentID          
 END 


----- AgentStateCode 
Declare @AgentStateID INT, @AgentStateCode INT  
 set  @AgentStateID = (SELECT  TOP 1 StateCodeID   from AgentMaster A inner join State_Code_Master S on S.ID=A.StateCodeID  
 where AgentID=@AgentID) 

 ---GET CompanyStateCode
 Declare @CompanyStateID INT , @IsUTAgent INT , @IsUTCompany INT
 set @CompanyStateID =  (select TOP 1 StateCodeID from CompanyMaster where CompanyID=@CompanyID)  


 ---GET UTAGENT 
  select @IsUTAgent = IsUnionTerritory  from State_Code_Master where ID=@AgentStateID    


   ---GET UTCompany
  select @IsUTCompany = IsUnionTerritory  from State_Code_Master where ID=@CompanyStateID   
  

				  if(@IsUTAgent = 0 AND @IsUTCompany = 0 OR @IsUTAgent = 1 AND @IsUTCompany = 0 OR @IsUTAgent = 0 AND @IsUTCompany = 1 )
				  begin
					if(@AgentStateID = @CompanyStateID)
					 Begin
						 if(@IsSEZ = 1)
						 begin
						  SET @GST1 = 2;
						 end
						 else
						 begin
						  SET @GST1 = 1;
						 end
					 end
				   end 
                    if (@AgentStateID != @CompanyStateID)
                    begin
                        SET @GST1 = 2;

					end  
					if (@IsUTAgent =1 and  @IsUTCompany = 1)
                    begin
                        if (@AgentStateID = @CompanyStateID AND  @IsUTAgent = @IsUTCompany)
                        begin
                            if (@IsSEZ = 1)
							begin
                            
                                SET @GST1 = 2;
                            end
                            else
                            begin
                                SET @GST1 = 3;
                            end
                        end
                    end


                              
Select distinct Tax_ID,Tax_ID,GSTType,g.GSTPercentage as GSTPercentage,g.GSTID as GSTID     
from ServiceTaxNew ST       
INNER JOIN GST_Percentage g       
on ST.GSTID=g.GSTID         
WHERE                                
CONVERT(VARCHAR,CAST(@DATE AS DATETIME),112) BETWEEN  CONVERT(VARCHAR,ST.Tax_From_Date,112) AND CONVERT(VARCHAR,ST.Tax_To_Date,112)                              
AND ST.IsActive=1                              
AND GSTType= @GST1       
order by GSTPercentage     

 END 

END 