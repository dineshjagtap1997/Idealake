CREATE PROCEDURE [dbo].[usp_ManageHotelRateMaster]  
@Operation CHAR(1) = 'S',
@HotelRateID INT OUT,                                               
@RateCardMode TINYINT,                        
@Heading  VARCHAR (100),                        
@ContractDate DATETIME,                        
@HotelID  INT,                      
@VendorID  INT,                        
@CurrencyID  VARCHAR (5),                        
@ValidFrom  DATETIME,                        
@ValidTo  DATETIME,                       
@IsMarketAgent tinyint,                       
@ReuseAllocation BIT,                      
@InfoForOps  VARCHAR (max),                        
@InfoForAgents VARCHAR (max),                        
@InfoForXO  VARCHAR (max),                        
@Remarks  VARCHAR (max),                        
@IsActive  BIT,                                  
@ValueAddOn VARCHAR(MAX),                    
@MinNights INT=NULL,                
@MaxNights INT=NULL,           
@IsDirectPayment bit = 0,     
@IsBTCComm BIT = 0, 
@RateType BIGINT =0,
@OperationBy UNIQUEIDENTIFIER,
@CardNo CHAR (15) OUT                        
                        
AS                        
BEGIN                        
       IF @Operation = 'I'
	   BEGIN
			 DECLARE @CardNoMax VARCHAR(10);
		 
			 SET @CardNoMax=(SELECT MAX(CAST(SUBSTRING(CardNo,6,6) AS INT)) FROM dbo.HotelRateMaster)                      
			 SET @CardNoMax = CASE WHEN @CardNoMax IS NULL THEN '1' ELSE CAST(@CardNoMax AS INT)+1 END                      
			 SET @CardNo = SUBSTRING(CONVERT(VARCHAR,DATEPART(yy,GETDATE())),3,2)+                      
			 REPLICATE('0',2-LEN(DATEPART(mm,GETDATE())))+CONVERT(VARCHAR,DATEPART(mm,GETDATE()))+                      
			 REPLICATE('0',6-len(@CardNoMax))+@CardNoMax                      
			 SET @CardNo='H'+@CardNo                      
                      
			DECLARE @MaxID INT  = (SELECT MAX(OldID) FROM dbo.HotelRateMaster) + 1                     
                    
			INSERT INTO dbo.HotelRateMaster(CardNo,RateCardMode,Heading,ContractDate,HotelID,VendorID,CurrencyID,ValidFrom,                        
			ValidTo,IsMarketAgent,ReuseAllocation,InfoForOps,InfoForAgents,InfoForXO,Remarks,IsActive,Operation,OperationBy,OperationOn,OldID,ValueAddOn                
		   ,MinNights,MaxNights,IsDirectPayment,IsBTCComm,RateType)                        
			VALUES  (@CardNo,@RateCardMode,@Heading,@ContractDate,@HotelID,@VendorID,@CurrencyID,@ValidFrom,                        
			@ValidTo,@IsMarketAgent,@ReuseAllocation,@InfoForOps,@InfoForAgents,@InfoForXO,@Remarks,@IsActive,'INSERT',@OperationBy,GETDATE(),@MaxID,@ValueAddOn,                
			@MinNights,@MaxNights,@IsDirectPayment,@IsBTCComm,@RateType)                        
                        
			SET @HotelRateID = @@IDENTITY                        
	   END
	   ELSE IF @Operation = 'S'
		BEGIN
			SELECT * FROM dbo.HotelRateMaster
		END
	   ELSE IF @Operation = 'D'
		BEGIN
			DELETE FROM dbo.HotelRateMaster WHERE HotelRateID = @HotelRateID
		END
	   ELSE IF @Operation = 'E'
		BEGIN
			SELECT * FROM dbo.HotelRateMaster WHERE HotelRateID = @HotelRateID
		END
END   
