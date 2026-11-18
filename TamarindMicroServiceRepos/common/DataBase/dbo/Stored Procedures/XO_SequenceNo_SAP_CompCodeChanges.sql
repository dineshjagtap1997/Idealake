   
-- =============================================     
-- Author: Santosh                                   
-- Create date: 21 MAR 2012    
-- Description:               
-- =====================================================         
Create PROCEDURE [dbo].[XO_SequenceNo_SAP_CompCodeChanges]    
(    
@Type CHAR(1),    
@DATE CHAR(4),  
@CompID varchar(5),  
@CODE CHAR(15) OUTPUT    
)          
AS            
BEGIN     
           
DECLARE @CNT INT            
DECLARE @SERIALNO CHAR(6)            
DECLARE @RETURNSERIALNO CHAR(15)            
DECLARE @YEAR CHAR(2)       
DECLARE @CityIATA CHAR(5)  
DECLARE @SAPCompanyCode varchar(20)
Declare @SAPThreeDigCompCode varchar(10)

set @CityIATA = ''
set @SAPCompanyCode = ''
set @SAPThreeDigCompCode = '' 

 Select top 1 @CityIATA = CityIATACode, @SAPCompanyCode=SAP_CompanyCode, @SAPThreeDigCompCode=CompCode 
 From CompanyMaster where CompanyID=@CompID and IsActive=1
      
            
SET @YEAR =SUBSTRING(@DATE,3,4)          
SELECT @CNT = COUNT(*) FROM XOCodeSequence          
WHERE TYPE = @Type AND YY = @YEAR AND SAPCompCode = @SAPCompanyCode         
            
IF(@CNT > 0)            
 BEGIN            
 UPDATE XOCodeSequence --WITH(ROWLOCK)            
 SET CURRENTSERIALNO = CAST(CurrentSerialNo AS INT) + 1          
 WHERE TYPE = @Type AND YY =  @YEAR  AND SAPCompCode = @SAPCompanyCode            
 END            
ELSE            
  BEGIN            
   INSERT INTO XOCodeSequence (TYPE,YY,CURRENTSERIALNO, SAPCompCode)    
   VALUES (@Type, @YEAR ,'1', @SAPCompanyCode)            
END            
    
SELECT @SERIALNO = CURRENTSERIALNO FROM XOCodeSequence with(nolock)     
WHERE TYPE = @Type AND YY =  @YEAR   AND SAPCompCode = @SAPCompanyCode        
          
--RETURN THE SEQ. NO With Leading ZEROS. THE SEQ NO Should be of 6 Chars.          
SET @RETURNSERIALNO =RTRIM(REVERSE('000000'+ RTRIM(@SERIALNO) ))          
SET @RETURNSERIALNO =REVERSE(SUBSTRING(@RETURNSERIALNO,1,6))          
          
  --SET @CODE = @Type + SUBSTRING(@DATE,7,8) + @SERIALNO            
SET @CODE = @Type +  @YEAR + LTRIM(RTRIM(@RETURNSERIALNO))+LTRIM(RTRIM(ISNULL(@SAPThreeDigCompCode,'')))          
    
END          
        



