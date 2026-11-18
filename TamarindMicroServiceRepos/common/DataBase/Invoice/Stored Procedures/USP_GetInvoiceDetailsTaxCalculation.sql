
<<<<<<< HEAD
<<<<<<< HEAD

=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
--declare
--@Action varchar(1)='S',
--@AgentID varchar(50)=14626,   
--@CompanyID INT=9, 
--@TaxID INT=5,
--@TCSTaxID INT=0,
--@TotalAmount decimal(18,2)=7500,
--@ServiceTaxableAmount decimal(18,2)=7142.86,
--@InvoiceTaxType int=2
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6





CREATE PROCEDURE [Invoice].[USP_GetInvoiceDetailsTaxCalculation]               
(   
<<<<<<< HEAD
<<<<<<< HEAD
@Action varchar(1),
@AgentID varchar(50),   
@CompanyID INT, 
@TaxID INT,
@TCSTaxID INT,
@TotalAmount decimal(18,2),
@ServiceTaxableAmount decimal(18,2)
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	@Action varchar(1),
	@AgentID varchar(50),   
	@CompanyID INT, 
	@TaxID INT,
	@TCSTaxID INT,
	@TotalAmount decimal(18,2),
	@ServiceTaxableAmount decimal(18,2),
	@InvoiceTaxType int
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
)              
AS              
Begin              


 IF @Action = 'S'  
 BEGIN

 DECLARE @GST1 INT
 Declare @IsSEZ INT
 Declare @Flag int =1  


<<<<<<< HEAD
<<<<<<< HEAD
 	DECLARE @SelectedTax decimal(18,2) , @BasicValue decimal(18,2),  
	@CGST decimal(18,2), @SGST decimal(18,2), @IGST decimal(18,2) , @UTGST decimal(18,2), 
	@CalculatedTaxableAmt decimal(18,2), @CalculatedTaxValue decimal(18,2) , @TaxableAmount decimal(18,2),
	@TaxAmount decimal(18,2),@SubTotal decimal(18,2),  @TCSAmount decimal(18,2), 
	@ServiceFeeTaxableAmount decimal(18,2)
	set @TotalAmount = 1000  
	set  @SelectedTax = @TaxID  
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 --	DECLARE @SelectedTax decimal(18,2) , @BasicValue decimal(18,2),  
	--@CGST decimal(18,2), @SGST decimal(18,2), @IGST decimal(18,2) , @UTGST decimal(18,2), 
	--@CalculatedTaxableAmt decimal(18,2), @CalculatedTaxValue decimal(18,2) , @TaxableAmount decimal(18,2),
	--@TaxAmount decimal(18,2),@SubTotal decimal(18,2),  @TCSAmount decimal(18,2), 
	--@ServiceFeeTaxableAmount decimal(18,2) 

	
 	DECLARE @SelectedTax decimal(18,6) , @BasicValue decimal(18,6),  
	@CGST decimal(18,6), @SGST decimal(18,6), @IGST decimal(18,6) , @UTGST decimal(18,6), 
	@CalculatedTaxableAmt decimal(18,6), @CalculatedTaxValue decimal(18,6) , @TaxableAmount decimal(18,6),
	@TaxAmount decimal(18,6),@SubTotal decimal(18,6),  @TCSAmount decimal(18,6), 
	@ServiceFeeTaxableAmount decimal(18,6) 



	select  @SelectedTax = GSTPER.GSTPercentage  FROM ServiceTaxNew ST                          
  INNER JOIN GSTTypeMaster N3 ON N3.GSTID = ST.GSTType                          
  INNER JOIN GST_Percentage GSTPER ON GSTPER.GSTID = ST.GSTID   
  where ST.Tax_ID = @TaxID 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6


  IF(@Flag=1)            
 BEGIN    
   --AgentID,AgentName,AccCode,AgentCode,AddressExist,AgentMaster.StateCodeID,IsSEZ,Panno,AddressCountry,  
  --AddressExist,TANDetails,AddressCountry as AgentCountry 
  SELECT @IsSEZ = IsSEZ  from AgentMaster      
  WHERE MarketID=            
  (            
  SELECT MarketID from AgentMaster        
  WHERE AgentID =@AgentID       
  AND Miscellaneous=1 )           
 END            
 ELSE IF(@Flag=0)            
 BEGIN            
  SELECT @IsSEZ = IsSEZ 
  
  --AgentID,AgentName,AccCode,AgentCode        
  --,PanNo,AddressExist,AddressCountry,AgentMaster.StateCodeID,IsSEZ,Panno,AddressCountry,AddressExist  
  --,TANDetails           
  --,AddressCountry  as AgentCountry  
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


 
  -- set @TaxID = 5 
  ------ ServiceTaxbyGSTTaxID 5%
 -- Select Tax_ID,Tax_Desc,Tax_Percentage,Tax_Type, IsActive,Other_Tax_Id from OtherServiceTaxNew           
	--WHERE Tax_Type= @TaxID      
	--AND IsActive=1    


		 		DECLARE @CGSTTax DECIMAL(10, 2) = 0,
				@SGSTTax DECIMAL(10, 2) = 0,
				@UTGSTTax DECIMAL(10, 2) = 0,
				@IGSTTax DECIMAL(10, 2) = 0;

				-- Set each tax type individually
				SELECT @CGSTTax = Tax_Percentage  
				FROM OtherServiceTaxNew 
				WHERE Tax_Type = @TaxID AND Tax_Desc = 'CGST';

				SELECT @SGSTTax = Tax_Percentage 
				FROM OtherServiceTaxNew 
				WHERE Tax_Type = @TaxID AND Tax_Desc = 'SGST';

				SELECT @UTGSTTax = Tax_Percentage 
				FROM OtherServiceTaxNew 
				WHERE Tax_Type = @TaxID AND Tax_Desc = 'UTGST';

				SELECT @IGSTTax = Tax_Percentage  
				FROM OtherServiceTaxNew 
				WHERE Tax_Type = @TaxID AND Tax_Desc = 'IGST';


<<<<<<< HEAD
<<<<<<< HEAD
	declare @InvoiceTaxType int = 1 
=======
	--declare @InvoiceTaxType int = 1
	

>>>>>>> dev
=======
	--declare @InvoiceTaxType int = 1
	

>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	if(@InvoiceTaxType = 1)
	begin

	  print 'Regular'

	  set @BasicValue = (@TotalAmount * 100)/ (100 + @SelectedTax)

		IF(@GST1 = 1)
		BEGIN
	      		set @CGST = @BasicValue * (@CGSTTax / 100);
				set @SGST = @BasicValue * (@SGSTTax / 100);
		END
		IF(@GST1 = 2)
		BEGIN

				set @IGST = @BasicValue * (@IGSTTax / 100);
		END
		IF(@GST1 = 3)
		BEGIN
				set @CGST = @BasicValue * (@CGSTTax / 100);
				set @UTGST = @BasicValue * (@UTGSTTax / 100);
		END


		set @CalculatedTaxableAmt = ISNULL(@TotalAmount, 0) - (ISNULL(@CGST,0) + ISNULL(@SGST,0)  + ISNULL(@IGST,0) + ISNULL(@UTGST,0))
		--SELECT @CalculatedTaxableAmt 
<<<<<<< HEAD
<<<<<<< HEAD
		set @CalculatedTaxValue = ISNULL(@TotalAmount,0) - ISNULL(@CalculatedTaxableAmt,0) 
		--SELECT @CalculatedTaxValue

=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		--set @CalculatedTaxValue = ISNULL(@TotalAmount,0) - ISNULL(@CalculatedTaxableAmt,0) 
		set @CalculatedTaxValue = ISNULL(@TotalAmount,0) - ISNULL((FLOOR(@CalculatedTaxableAmt * 100) / 100),0)  

		--SELECT @CalculatedTaxValue
		--select @CalculatedTaxValue
		--select ISNULL(@TotalAmount,0) , ISNULL((FLOOR(@CalculatedTaxableAmt * 100) / 100),0)  
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

	end
	if(@InvoiceTaxType = 2)
	begin
	 print 'Service'

	   set @BasicValue = @ServiceTaxableAmount

		IF(@GST1 = 1)
		BEGIN
	      		set @CGST = @BasicValue * (@CGSTTax / 100);
				set @SGST = @BasicValue * (@SGSTTax / 100);
		END
		IF(@GST1 = 2)
		BEGIN

				set @IGST = @BasicValue * (@IGSTTax / 100);
		END
		IF(@GST1 = 3)
		BEGIN
				set @CGST = @BasicValue * (@CGSTTax / 100);
				set @UTGST = @BasicValue * (@UTGSTTax / 100);
		END


		set @CalculatedTaxableAmt = ISNULL(@ServiceTaxableAmount, 0) - (ISNULL(@CGST,0) + ISNULL(@SGST,0)  + ISNULL(@IGST,0) + ISNULL(@UTGST,0))
<<<<<<< HEAD
<<<<<<< HEAD
=======
		
>>>>>>> dev
=======
		
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		--SELECT @CalculatedTaxableAmt 
		set @CalculatedTaxValue = ISNULL(@ServiceTaxableAmount,0) - ISNULL(@CalculatedTaxableAmt,0) 
		--SELECT @CalculatedTaxValue



	end
	if(@InvoiceTaxType = 3)
	begin
	 print 'TCS'
				
			set @SubTotal = (@TotalAmount * 100)/ (100 + @TCSTaxID)
			set @TCSAmount = (@TotalAmount - @SubTotal)
			set @BasicValue = (@SubTotal * 100) / (100 + @TaxID)

<<<<<<< HEAD
<<<<<<< HEAD
=======
			

>>>>>>> dev
=======
			

>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

				IF(@GST1 = 1)
				BEGIN
	      				set @CGST = @BasicValue * (@CGSTTax / 100);
						set @SGST = @BasicValue * (@SGSTTax / 100);
				END
				IF(@GST1 = 2)
				BEGIN

						set @IGST = @BasicValue * (@IGSTTax / 100);
				END
				IF(@GST1 = 3)
				BEGIN
						set @CGST = @BasicValue * (@CGSTTax / 100);
						set @UTGST = @BasicValue * (@UTGSTTax / 100);
				END
		
		set @CalculatedTaxableAmt = ISNULL(@TotalAmount, 0) - (ISNULL(@CGST,0) + ISNULL(@SGST,0)  + ISNULL(@IGST,0) + ISNULL(@UTGST,0))
		--SELECT @CalculatedTaxableAmt 
		set @CalculatedTaxValue = ISNULL(@TotalAmount,0) - ISNULL(@CalculatedTaxableAmt,0) 
<<<<<<< HEAD
<<<<<<< HEAD
		--SELECT @CalculatedTaxValue

=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		
		--SELECT @CalculatedTaxValue


<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	end


-- Declare output variables
		--DECLARE @CGSTTax DECIMAL(10, 2) = 0,
		--		@SGSTTax DECIMAL(10, 2) = 0,
		--		@UTGSTTax DECIMAL(10, 2) = 0,
		--		@IGSTTax DECIMAL(10, 2) = 0;

				---- Set each tax type individually
				--SELECT @CGSTTax = Tax_Percentage  
				--FROM OtherServiceTaxNew 
				--WHERE Tax_Type = @TaxID AND Tax_Desc = 'CGST';

				--SELECT @SGSTTax = Tax_Percentage 
				--FROM OtherServiceTaxNew 
				--WHERE Tax_Type = @TaxID AND Tax_Desc = 'SGST';

				--SELECT @UTGSTTax = Tax_Percentage 
				--FROM OtherServiceTaxNew 
				--WHERE Tax_Type = @TaxID AND Tax_Desc = 'UTGST';

				--SELECT @IGSTTax = Tax_Percentage  
				--FROM OtherServiceTaxNew 
				--WHERE Tax_Type = @TaxID AND Tax_Desc = 'IGST';

-- Output for verification
		--SELECT 
		--@CGSTTax AS CGST, 
		--@SGSTTax AS SGST, 
		--@UTGSTTax AS UTGST, 
		--@IGSTTax AS IGST;






	

<<<<<<< HEAD
<<<<<<< HEAD
	SELECT @TotalAmount AS 'TotalAmount', 
	@SelectedTax as 'SelectedTax',
	@BasicValue as 'BasicValue',
	@CGST as 'CGST',
	@SGST as 'SGST',
	@IGST as 'IGST',
	@UTGST as 'UTGST',
    @BasicValue as 'TotalBasicAmount',
	@CalculatedTaxableAmt as 'TaxableAmount',
	@TaxAmount as 'TotalTaxAmount',
	@CalculatedTaxValue as 'TaxValue',
	@TotalAmount  as 'TotalInvoiceAmount'




END

=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	--SELECT @TotalAmount AS 'TotalAmount', 
	--@SelectedTax as 'SelectedTax',
	--@BasicValue as 'BasicValue',
	--@CGST as 'CGST',
	--@SGST as 'SGST',
	--@IGST as 'IGST',
	--@UTGST as 'UTGST',
 --   @BasicValue as 'TotalBasicAmount',
	--@CalculatedTaxableAmt as 'TaxableAmount',
	--@CalculatedTaxValue as 'TotalTaxAmount',
	--@CalculatedTaxValue as 'TaxValue',
	--@TotalAmount  as 'TotalInvoiceAmount'

	IF(@InvoiceTaxType=2)
		BEGIN
			SELECT 
			FORMAT(@TotalAmount, '#,##0.##')       AS TotalAmount, 
			FORMAT(@SelectedTax, '#,##0.##')       AS SelectedTax,
			--FORMAT(@BasicValue, '#,##0.##')        AS BasicValue,
			CAST(FLOOR(@BasicValue * 100) / 100.0 AS DECIMAL(18,2)) AS BasicValue,
			FORMAT(@CGST, '#,##0.##')              AS CGST,
			FORMAT(@SGST, '#,##0.##')              AS SGST,
			FORMAT(@IGST, '#,##0.##')              AS IGST,
			FORMAT(@UTGST, '#,##0.##')             AS UTGST,
			----FORMAT(@BasicValue, '#,##0.##')         AS  TotalBasicAmount, 
			CAST(FLOOR(@BasicValue * 100) / 100.0 AS DECIMAL(18,2)) AS  TotalBasicAmount,
			--FORMAT(@CalculatedTaxableAmt, '#,##0.##') AS TaxableAmount,
			--CAST(FLOOR(@CalculatedTaxableAmt * 100) / 100.0 AS DECIMAL(18,2)) AS TaxableAmount,
			CAST(FLOOR(@BasicValue * 100) / 100.0 AS DECIMAL(18,2)) AS TaxableAmount,
			FORMAT(@CalculatedTaxValue, '#,##0.##')  AS TotalTaxAmount,
			FORMAT(@CalculatedTaxValue, '#,##0.##') AS TaxValue,
			FORMAT(@TotalAmount, '#,##0.##')       AS TotalInvoiceAmount;
		END
	ELSE
		SELECT 
			FORMAT(@TotalAmount, '#,##0.##')       AS TotalAmount, 
			FORMAT(@SelectedTax, '#,##0.##')       AS SelectedTax,
			--FORMAT(@BasicValue, '#,##0.##')        AS BasicValue,
			CAST(FLOOR(@BasicValue * 100) / 100.0 AS DECIMAL(18,2)) AS BasicValue,
			FORMAT(@CGST, '#,##0.##')              AS CGST,
			FORMAT(@SGST, '#,##0.##')              AS SGST,
			FORMAT(@IGST, '#,##0.##')              AS IGST,
			FORMAT(@UTGST, '#,##0.##')             AS UTGST,
			----FORMAT(@BasicValue, '#,##0.##')         AS  TotalBasicAmount, 
			CAST(FLOOR(@BasicValue * 100) / 100.0 AS DECIMAL(18,2)) AS  TotalBasicAmount,
			--FORMAT(@CalculatedTaxableAmt, '#,##0.##') AS TaxableAmount,
			CAST(FLOOR(@CalculatedTaxableAmt * 100) / 100.0 AS DECIMAL(18,2)) AS TaxableAmount,
			FORMAT(@CalculatedTaxValue, '#,##0.##')  AS TotalTaxAmount,
			FORMAT(@CalculatedTaxValue, '#,##0.##') AS TaxValue,
			FORMAT(@TotalAmount, '#,##0.##')       AS TotalInvoiceAmount;
		END



<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
End 
