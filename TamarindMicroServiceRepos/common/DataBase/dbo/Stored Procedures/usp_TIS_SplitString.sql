CREATE PROCEDURE [dbo].[usp_TIS_SplitString] ( @Array varchar(8000),@separator varchar(10))       
 AS      
begin      
 create table #IntTable        
  (IntValue varchar(8000))      
      
--  declare @separator char(1)      
--  set @separator = ','      
      
  declare @separator_position int       
  declare @array_value varchar(8000)       
        
  set @array = @array +@separator      
        
  while patindex('%'+ @separator +'%' , @array) <> 0       
  begin      
        
    select @separator_position =  patindex('%'+ @separator +'%' , @array)      
    select @array_value = left(@array, @separator_position - 1)      
        
   Insert into #IntTable      
   Values (Cast(@array_value as varchar))     
      
    select @array = stuff(@array, 1, @separator_position, '')      
  end      
      
  select * From #IntTable     
 --select * From #IntTable  order by IntValue desc    
 drop table #IntTable      
 end  