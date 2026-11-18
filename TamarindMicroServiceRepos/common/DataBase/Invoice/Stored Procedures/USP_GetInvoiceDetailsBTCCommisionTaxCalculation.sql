



CREATE PROCEDURE [Invoice].[USP_GetInvoiceDetailsBTCCommisionTaxCalculation]               
(              
@AgentID varchar(50),   
@CompanyID INT, 
@TaxID INT,
@TotalAmount decimal(18,2)
)              
AS              
Begin              

 DECLARE @GST1 INT
  DECLARE @GSTTypeID INT
 
 Declare @IsSEZ INT
 declare @CompanyStateCode INT 
 declare @HotelStateCode INT 
 declare @Tax_Accode int
 declare @IsUTHotel INT  
 declare @IsUTCompany INT

  declare @CompanyStateCode_N int

   set  @HotelStateCode = (select TOP 1 StateCodeID   from HotelMaster where HotelCode='CAMB0001'          
	--union             
	--select TOP 1 StateCodeID,STRegNo as GSTIN,isSEZ from VendorMaster where VendorCode= ''
	) 

  
   set @CompanyStateCode = (select TOP 1 C.StateCodeID    
					 from CompanyMaster C
					 INNER JOIn [State] S ON S.State_ID =C.SAP_StateCode
					 where CompanyID=9)

   
 
   declare @BillingStateCodeId int = @CompanyStateCode
   declare @HotelStateCodeID int = @HotelStateCode 

   if(@BillingStateCodeId = @HotelStateCodeID)
   begin
		set @Tax_Accode = 24376;
   end
   if(@BillingStateCodeId <> @HotelStateCodeID AND @HotelStateCodeID = 1)
   begin
		set @Tax_Accode = 24376;
   end
   else
   begin
		set @Tax_Accode = 24661;
   end





   -- GET DATA FROM dsDirectXODetails  




 --   IF(@HotelStateCode = @CompanyStateCode)
	--BEGIN
	    

	--END
	 




 ---GET CompanyStateCode
 Declare @CompanyStateID INT  
 set @CompanyStateID =  (select StateCodeID from CompanyMaster where CompanyID=@CompanyID)  


 ---GET UTHotel
  select @IsUTHotel  = IsUnionTerritory  from State_Code_Master where ID=@HotelStateCode     


   ---GET UTCompany
  select @IsUTCompany = IsUnionTerritory  from State_Code_Master where ID=@CompanyStateCode_N   
  

				  if(@IsUTHotel = 0 AND @IsUTCompany = 0 OR @IsUTHotel = 1 AND @IsUTCompany = 0 OR @IsUTHotel = 0 AND @IsUTCompany = 1 )
				  begin
					if(@HotelStateCode = @CompanyStateID)
					 Begin
						   if (@IsSEZ = 1 )
						   BEGIN

						    set @GSTTypeID = 2;

						   END
						   ELSE
						   BEGIN
						   SET @GSTTypeID = 1;
						   END         
					 end
				   end 
                    if (@HotelStateCode != @CompanyStateID)
                    begin
                        SET @GST1 = 2;

					end  
					if (@IsUTHotel =1 and  @IsUTCompany = 1)
                    begin
                        if (@HotelStateCode = @CompanyStateID AND  @IsUTHotel = @IsUTCompany)
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


 
  set @TaxID = 5 
  ------ ServiceTaxbyGSTTaxID 5%
  Select Tax_ID,Tax_Desc,Tax_Percentage,Tax_Type, IsActive,Other_Tax_Id from OtherServiceTaxNew           
	WHERE Tax_Type= @TaxID      
	AND IsActive=1    


-- Declare output variables
		DECLARE @CGSTTax DECIMAL(10, 2) = 0,
				@SGSTTax DECIMAL(10, 2) = 0,

				@UTGSTTax DECIMAL(10, 2) = 0,
				@IGSTTax DECIMAL(10, 2) = 0,
				@dectax1 DECIMAL(10, 2) = 0,
				@decTotalValue DECIMAL(10, 2) = 0,
				@dtotal DECIMAL(10, 2) =  0, --- Commission Total
				@basicvalue1 DECIMAL(10, 2) =  0,
				@taxvalue DECIMAL(10, 2) =  0,
				@Invoice_Total DECIMAL(10, 2) =  0,
				@dCGST DECIMAL(10, 2) =  0, 
				@dSGST DECIMAL(10, 2) =  0,
				@dIGST DECIMAL(10, 2) =  0, 
				@dUTGST DECIMAL(10, 2) =  0,
				@CGST DECIMAL(10, 2) =  0, 
				@SGST DECIMAL(10, 2) =  0,
			    @UTGST DECIMAL(10, 2) =  0,
				@IGST DECIMAL(10, 2) =  0,
				@dIGSTN DECIMAL(10, 2) =  0,
				@GSTPerc DECIMAL(10, 2) =  0,
				@TaxAmount DECIMAL(10, 2) =  0,
				@Invoice_Curr_Amt DECIMAL(10, 2) =  0

    IF(@GST1 = 1)
	BEGIN
                set  @CGSTTax = '9.00000';
  
                set  @SGSTTax = '9.00000';

                set  @dectax1 = 18;

               set @decTotalValue = @dtotal + (@dtotal * (@dectax1 / 100));
               set @decTotalValue  = Round(@decTotalValue, 0);

                set @basicvalue1 = (@decTotalValue * 100) / (100 + @dectax1);
                set @dCGST = @basicvalue1 * (@CGSTTax / 100);
                set @dSGST = @basicvalue1 * (@SGSTTax / 100);
                set @taxvalue = @decTotalValue - @basicvalue1;

                set @Invoice_Total = @decTotalValue;
                set @CGST = @dCGST;
                set @SGST = @dSGST;

                set @GSTPerc = 6;
                set @TaxAmount = @taxvalue;
                set @Invoice_Curr_Amt = @decTotalValue - @dCGST - @dSGST; 

	END
	IF(@GST1 = 3)
	BEGIN
                set  @CGSTTax = '9.00000';
  
                set  @UTGSTTax = '9.00000';

                set  @dectax1 = 18;

               set @decTotalValue = @dtotal + (@dtotal * (@dectax1 / 100));
               set @decTotalValue  = Round(@decTotalValue, 0);

                set @basicvalue1 = (@decTotalValue * 100) / (100 + @dectax1);
                set @dCGST = @basicvalue1 * (@CGSTTax / 100);
                set @dUTGST = @basicvalue1 * (@UTGSTTax / 100);
                set @taxvalue = @decTotalValue - @basicvalue1;

                set @Invoice_Total = @decTotalValue;
                set @CGST = @dCGST;
                set @UTGST = @dUTGST;

                set @GSTPerc = 29;
                set @TaxAmount = @taxvalue;
                set @Invoice_Curr_Amt = @decTotalValue - @dCGST - @dUTGST; 

	END
	IF(@GST1 = 2)
	BEGIN
  
                set  @IGSTTax = '18.00000';

                set  @dectax1 = 18;

               set @decTotalValue = @dtotal + (@dtotal * (@dectax1 / 100));
               set @decTotalValue  = Round(@decTotalValue, 0);

                set @basicvalue1 = (@decTotalValue * 100) / (100 + @dectax1);
 
                set @dIGSTN = @basicvalue1 * (@IGSTTax / 100);
                set @taxvalue = @decTotalValue - @basicvalue1;

                set @Invoice_Total = @decTotalValue;

                set @IGST = @dIGST;

                set @GSTPerc = 3;
                set @TaxAmount = @taxvalue;
                set @Invoice_Curr_Amt = @decTotalValue - @IGST ; 

	END

	DECLARE @SelectedTax decimal(18,2) , @BasicValue decimal(18,2),
	
	@CalculatedTaxableAmt decimal(18,2), @CalculatedTaxValue decimal(18,2) , @TaxableAmount decimal(18,2) 
	set @TotalAmount = 1000 
	set  @SelectedTax = @TaxID  


	set @BasicValue = (@TotalAmount * 100)/ (100 + @SelectedTax)



	set @CalculatedTaxableAmt = ISNULL(@TotalAmount, 0) - (ISNULL(@CGST,0) + ISNULL(@SGST,0)  + ISNULL(@IGST,0) + ISNULL(@UTGST,0))
	--SELECT @CalculatedTaxableAmt 


	set @CalculatedTaxValue = ISNULL(@TotalAmount,0) - ISNULL(@CalculatedTaxableAmt,0) 
	--SELECT @CalculatedTaxValue

	SELECT @TotalAmount AS 'TotalAmount', 
	@SelectedTax as 'SelectedTax',
	@BasicValue as 'BasicValue',
	@CGST as 'CGST',
	@SGST as 'SGST',
	@IGST as 'IGST',
	@UTGST as 'UTGST',
    @BasicValue as 'TotalBasicAmount',
	@CalculatedTaxableAmt as 'TaxableAmount',
	@CalculatedTaxableAmt as 'TotalTaxAmount',
	@CalculatedTaxValue as 'TaxValue',
	@TotalAmount  as 'TotalInvoiceAmount'





End 