-- [Usp_GenerateAdvancePayID] 524422,'','08/06/2024 12:00:00 AM'    
CREATE PROCEDURE [dbo].[Usp_GenerateAdvancePayID]                            
(                            
@BookingID bigint,                            
@TravelDate datetime,          
@FileCode VARCHAR(15) OUTPUT                            
)                            
AS                            
BEGIN                            
DECLARE @CNT INT                                        
DECLARE @SERIALNO CHAR(10)               
declare @Date VARCHAR(10)             
if(@BookingID  > 0)        
    begin        
  SELECT @Date = CONVERT(VARCHAR,Q.StartDate,1)            
  FROM Booking.tbl_Booking Q WITH (NOLOCK)                                     
  LEFT JOIN Booking.tbl_Booking Q1 WITH (NOLOCK) ON Q1.ParentID = Q.ID                                      
  WHERE Q.ID=@BookingID OR Q1.ParentID=@BookingID           
end        
    else        
    begin        
  set @Date = CONVERT(VARCHAR,@TravelDate,1)                    
    end        
                                  
SELECT @SERIALNO = CAST(REPLICATE('0',8-LEN(CAST(SUBSTRING(Request_ID ,5,8) AS INT) + 1)) AS VARCHAR(10))                          
+CAST((CAST(SUBSTRING(Request_ID ,5,8) AS INT) + 1) AS VARCHAR(10))                                   
FROM AdvancePaySendRequest  WITH (Nolock)                                   
WHERE  SUBSTRING(Request_ID  ,3,2)  = SUBSTRING(@Date  ,7,8)   
if(@SERIALNO is null)        
begin   
SET @FileCode = 'AV' +ltrim(rtrim(( SUBSTRING(@DATE,7,8) + '00000001')))      
End   
else   
  begin   
SET @FileCode = 'AV' +ltrim(rtrim(( SUBSTRING(@DATE,7,8) + @SERIALNO)))      
End   
select @FileCode                  
END

