<<<<<<< HEAD
<<<<<<< HEAD
﻿CREATE PROCEDURE [Invoice].[USP_InsertBTCCommisionInvoice] --'S13000003',35--'H13023420'    
@Action varchar(1) = null,
@XOID varchar(20)=null,            
@YearCode INT =null,
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿
CREATE PROCEDURE [Invoice].[USP_InsertBTCCommisionInvoice] --'S13000003',35--'H13023420'    
@Action varchar(1) = null,
@XOID varchar(20)=null,            
@YearCode INT =null,
@BookingID int = 5,
@GroupKey int = 1,
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
@CreatedBy UNIQUEIDENTIFIER
                         
AS                                
            
BEGIN         
 
 declare @YearID INT  = @YearCode 
 declare @HotelVendorFlag varchar(1) = 'H'
 declare @XOHotelID int 
 declare @res varchar(1) 
         SELECT @res = SUBSTRING(@XOID , 1, 1) 
declare @InvoiceID int 



<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		--DECLARE 
  --          @ReturnCode NVARCHAR(3),
  --          @ReturnMessage NVARCHAR(MAX),
  --          @RecordID BIGINT;

  --          IF EXISTS (
  --              select TOP 1  CommInvNumber from XO where XO_ID = @XOID 
  --          )
  --          BEGIN
  --              SET @ReturnCode = '409';
  --              SET @ReturnMessage = ' record exists for the same xo';
  --              SET @RecordID = 0;
                
  --              SELECT @ReturnCode AS returnCode, @ReturnMessage AS returnMessage, @RecordID AS ID;
  --              RETURN;
  --          END

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

 DECLARE @QuotationHotelCommission TABLE (
    QuotationID INT,
    XO_ID VARCHAR(50),
<<<<<<< HEAD
<<<<<<< HEAD
    CostingCurrencyCode INT,
=======
    CostingCurrencyCode VARCHAR(5),
>>>>>>> dev
=======
    CostingCurrencyCode VARCHAR(5),
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    AccCode VARCHAR(50),
    HotelName VARCHAR(255),
    HotelCode VARCHAR(50),
    HotelSAPCode VARCHAR(50),
    QuotationDate DATETIME,
    TravelDateFrom DATETIME,
    TravelDateTo DATETIME,
    FileCode VARCHAR(100),
    OperationBy VARCHAR(100),
    YearID INT,
    CompanyID INT,
    Confirmed_By VARCHAR(100),
    SGLCommission DECIMAL(18,2),
    DBLCommission DECIMAL(18,2),
    CityIATACode VARCHAR(10),
    VendorID VARCHAR(50),
    VendorAccCode VARCHAR(50),
    VendorName VARCHAR(255),
    VendorCode VARCHAR(50),
    VendorSAPCode VARCHAR(50),
    SAP_CompanyCode VARCHAR(50),
    [3DigitCode] VARCHAR(10),
<<<<<<< HEAD
<<<<<<< HEAD
    SAPCompID INT
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    SAPCompID INT,
	GuestName varchar(50),
	BookingID INT,
	CurrID varchar(5),
	PlaceofSupply INT,
	AgentID INT,
	RoomCategory Varchar(250),
	TAXNumber varchar(20),
	TANNumber varchar(20),
	PANNumber varchar(20)

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
);
                         
 -- SET NOCOUNT ON added to prevent extra result sets from                                
 -- interfering with SELECT statements.                                
 SET NOCOUNT ON;    
 
<<<<<<< HEAD
<<<<<<< HEAD
 INsert into @QuotationHotelCommission 
 SELECT Q.QuotationID,            
 --Q.QuotationItemID,            
 XO.XO_ID,            
   
 HRMB.CurrencyID AS 'CostingCurrencyCode',            
 HM.AccCode,            
 HM.HotelName,            
 HM.HotelCode,
 hm.HotelSAPCode,            
 --case WHEN QS.IsVendorHotel=1 THEN VM.VendorSAPCode ELSE HM.HotelSAPCode end AS 'HotelSAPCode',            
 Q.CreatedDate AS  QuotationDate,            
 HRMB.CheckIn AS  TravelDateFrom,            
 HRMB.CheckIn AS TravelDateTo,                              
 B.FileCode,            
 B.CreatedBy AS OperationBy,            
 Q.YearID,            
 Q.CompanyID,            
 XOI.Confirmed_By,   
--  CASE 
--    WHEN RCM.CommMasterID = 1 THEN 
--        CASE 
--            WHEN ISNULL(CommisionPercentage, '') <> '' THEN CommisionPercentage 
--            ELSE CommissionAmount 
--        END
--    ELSE NULL
--END AS SGLCommission ,
 100 AS SGLCommission,
 CASE 
    WHEN RCM.CommMasterID = 2 THEN 
        CASE 
            WHEN ISNULL(CommisionPercentage, '') <> '' THEN CommisionPercentage 
            ELSE CommissionAmount 
        END
    ELSE NULL
END AS DBLCommission ,
 --ISNULL(HRD.SGLCommission,0) AS SGLCommission,            
 --ISNULL(HRD.DBLCommission,0) AS DBLCommission,            
 --HRM.IsDirectPayment,            
 --Q.CustomerName,  --added by afreen                        
 --QA.ItineraryDate                      
 --,HRM.IsBTCComm      
 --,ISNULL(HRD.BTCSComm,0) AS BTCSGLCommission,   --Jyoti @05Feb2019   
 --ISNULL(HRD.BTCDComm,0) AS BTCDBLCommission,     --Jyoti @05Feb2019    
  CM.CityIATACode  
 ,'' AS VendorID 
 ,'' AS VendorAccCode
 ,'' AS VendorName
 ,'' AS VendorCode 
 ,'' AS VendorSAPCode 
 ,CM.SAP_CompanyCode
 ,CM.CompCode  AS '3DigitCode'  
 ,CM.CompanyID AS 'SAPCompID'    
 FROM XO     

 
LEFT JOIN [Booking].tbl_Booking B ON  B.QuotationID = XO.Qut_ID  
LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = B.QuotationID  
LEFT JOIN [Booking].DayWiseBooking  DWB ON DWB.BookingID = B.BookingID 
LEFT JOIN Booking.HotelRateCardMasterBooking  HRMB ON DWB.BookingID = HRMB.BookingID 
LEFT JOIN Booking.HotelRateCommissionDetailsBooking  HRCB ON DWB.BookingID = HRCB.BookingID 
LEFT JOIN Booking.HotelRateMealPlanMasterBooking  HRPB ON DWB.BookingID = HRPB.BookingID 
LEFT JOIN  RateCommissionMaster RCM ON HRCB.RateCommisionID = RCM.CommMasterID 
LEFT JOIN RoomCategory RC ON RC.ID=HRMB.RoomCategoryID                                                         
LEFT JOIN MealPlan MP ON MP.ID = HRPB.MealTypeID                      
 LEFT JOIN dbo.HotelMaster HM ON HRMB.HotelID=HM.HotelID       
 --LEFT outer JOIN dbo.VendorMaster vm ON HRM.VendorID=vm.VendorID                       
LEFT OUTER JOIN XO_Instructions XOI ON XOI.XO_ID=XO.XO_ID       
LEFT JOIN CompanyMaster CM ON Q.CompanyID = CM.CompanyID                          
 WHERE XO.XO_ID= 'TINH26000001'             
 ---AND QXOM.ServiceTypeID=1               
 --AND Q.YearID=@YearID           
     
	 

DECLARE	 @AgentID varchar(50),   
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
INSERT into @QuotationHotelCommission 
SELECT 
    QuotationID,
    XO_ID,
    CostingCurrencyCode,
    AccCode,
    HotelName,
    HotelCode,
    HotelSAPCode,
    QuotationDate,
    TravelDateFrom,
    TravelDateTo,
    FileCode,
    OperationBy,
    YearID,
    CompanyID,
    Confirmed_By,
    --SUM(SGLCommission) AS SGLCommission,
    --SUM(DBLCommission) AS DBLCommission,
	(SELECT DISTINCT TOP 1 HRCB.CommissionAmount
		FROM [Booking].tbl_Booking B
		INNER JOIN [Booking].DayWiseBooking DWB ON DWB.BookingID = B.ID AND DWB.GroupKey = @GroupKey 
		INNER JOIN Booking.HotelRateCardMasterBooking HRMB ON DWB.BHRMID = HRMB.ID
		INNER JOIN Booking.HotelRateCommissionDetailsBooking HRCB ON HRMB.ID = HRCB.QuotationHotelRateID  
		WHERE B.ID = ((select top 1 xo.Qut_ID from XO Where XO.XO_ID = @XOID )) AND CommissionMasterID = 1) AS SGLCommission,
	(SELECT DISTINCT TOP 1 HRCB.CommissionAmount
		FROM [Booking].tbl_Booking B
		INNER JOIN [Booking].DayWiseBooking DWB ON DWB.BookingID = B.ID
		INNER JOIN Booking.HotelRateCardMasterBooking HRMB ON DWB.BHRMID = HRMB.ID AND DWB.GroupKey = @GroupKey 
		INNER JOIN Booking.HotelRateCommissionDetailsBooking HRCB ON HRMB.ID = HRCB.QuotationHotelRateID  
		WHERE B.ID = ((select top 1 xo.Qut_ID from XO Where XO.XO_ID = @XOID )) AND CommissionMasterID = 2) AS DBLCommission,
    CityIATACode,
    VendorID,
    VendorAccCode,
    VendorName,
    VendorCode,
    VendorSAPCode,
    SAP_CompanyCode,
    [3DigitCode],
    SAPCompID,
	GuestName,
	BookingID,
	CurrID,
	PlaceofSupply,
	AgentID,
	RoomCategory,
	TAXNumber,
	TANNumber,
	PANNumber
FROM
(
    SELECT 
        Q.QuotationID,            
        XO.XO_ID,            
        HRMB.CurrencyID AS CostingCurrencyCode,            
        HM.AccCode,            
        XO.XO_Supplier_Name AS HotelName,            
        HM.HotelCode,
        HM.HotelSAPCode,            
        Q.CreatedDate AS QuotationDate,            
        XOI.ArrivalDate AS TravelDateFrom,            
        XOI.DepartureDate AS TravelDateTo,                              
        B.FileCode,            
        B.CreatedBy AS OperationBy,            
        B.YearID,            
        B.CompanyID,            
        XOI.Confirmed_By,   
        CASE 
            WHEN RCM.CommMasterID = 1 THEN 
                CASE 
                    WHEN ISNULL(CommissionAmount, 0) <> 0 THEN CommissionAmount 
                    ELSE  CommisionPercentage
                END
            ELSE 0
        END AS SGLCommission,
        CASE 
            WHEN RCM.CommMasterID = 2 THEN 
                CASE 
                    WHEN ISNULL(CommissionAmount, 0) <> 0 THEN CommissionAmount 
                    ELSE  CommisionPercentage
                END
            ELSE 0
        END AS DBLCommission,
        CM.CityIATACode,
        VM.VendorID  AS VendorID,
        '' AS VendorAccCode,
        VM.VendorName,
        VM.VendorCode, 
        VM.VendorSAPCode ,
        CM.SAP_CompanyCode,
        CM.CompCode AS [3DigitCode],
        CM.CompanyID AS SAPCompID,
		B.GuestName as GuestName,
		B.ID AS BookingID,
	    B.Currency as CurrID,
		SCM.ID AS PlaceofSupply,
		B.AgentID AS AgentID,
		RC.Name AS RoomCategory, 
		CASE WHEN  VM.STRegNo IS NULL THEN HM.STRegNo ELSE VM.STRegNo END AS TAXNumber,
		AM.TANDetails as TANNumber,
	    AM.PanNo as PANNumber
 
    FROM XO     
    INNER JOIN [Booking].tbl_Booking B ON B.ID = XO.Qut_ID  
    LEFT JOIN Quotation.QuotationMaster Q ON Q.QuotationID = B.QuotationID  
    INNER JOIN [Booking].DayWiseBooking DWB ON DWB.BookingID = B.ID  AND DWB.GroupKey = @GroupKey   
    INNER JOIN Booking.HotelRateCardMasterBooking HRMB ON DWB.BHRMID = HRMB.ID 
	LEFT JOIN VendorMaster VM on VM.VendorID = HRMB.VendorID 
    INNER JOIN Booking.HotelRateCommissionDetailsBooking HRCB ON HRMB.ID = HRCB.QuotationHotelRateID 
    LEFT JOIN RateCommissionMaster RCM ON HRCB.CommissionMasterID = RCM.CommMasterID 
	LEFT JOIN RoomCategory RC ON RC.ID = HRMB.RoomCategoryID 
    LEFT JOIN dbo.HotelMaster HM ON HRMB.HotelID = HM.HotelID       
    LEFT OUTER JOIN XO_Instructions XOI ON XOI.XO_ID = XO.XO_ID       
    LEFT JOIN CompanyMaster CM ON Q.CompanyID = CM.CompanyID 
	LEFT JOIN AgentMaster AM ON B.AgentID = AM.AgentID 
	LEFT JOIN State_Code_Master SCM ON AM.StateCodeID  = SCM.ID  
    WHERE XO.XO_ID = @XOID 
) AS CommissionData
GROUP BY 
    QuotationID,
    XO_ID,
    CostingCurrencyCode,
    AccCode,
    HotelName,
    HotelCode,
    HotelSAPCode,
    QuotationDate,
    TravelDateFrom,
    TravelDateTo,
    FileCode,
    OperationBy,
    YearID,
    CompanyID,
    Confirmed_By,
    CityIATACode,
    VendorID,
    VendorAccCode,
    VendorName,
    VendorCode,
    VendorSAPCode,
    SAP_CompanyCode,
    [3DigitCode],
    SAPCompID,
	GuestName,
	BookingID,
	CurrID,
	PlaceofSupply,
	AgentID,
    RoomCategory,
	TAXNumber,
	TANNumber,
	PANNumber
	 

DECLARE	  --- @AgentID varchar(50),   
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
@CompanyID INT = 9, 
@TaxID INT,
@TotalAmount decimal(18,2)

  DECLARE @GST1 INT
  DECLARE @GSTTypeID INT
 
 Declare @IsSEZ INT
 declare @CompanyStateCode INT 
 declare @HotelStateCode INT 
 declare @Tax_Accode int
 declare @IsUTHotel INT  
 declare @IsUTCompany INT
<<<<<<< HEAD
<<<<<<< HEAD
=======
 declare @HotelID INT
 declare @HotelCodeN varchar(20)

>>>>>>> dev
=======
 declare @HotelID INT
 declare @HotelCodeN varchar(20)

>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

  declare @CompanyStateCode_N int    

  declare @CompID INT 

<<<<<<< HEAD
<<<<<<< HEAD
     
    --set @CompanyStateCode_N = (select * FROM HotelMaster )
    select top 1 @CompID = CompanyID  from [Quotation].[QuotationMaster] Where QuotationID = (select top 1 xo.Qut_ID from XO Where XO.XO_ID = @XOID )

	--select top 1 @CompID = CompanyID  from CompanyMaster 
	--where CompanyID = (select top 1 xo.CompName from XO Where XO.XO_ID = @XOID )

     select TOP 1 @HotelStateCode =StateCodeID , @CompanyStateCode_N = CompanyID  from HotelMaster where HotelCode='CAMB0001'          
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
     declare @DLBSum int 
	 declare @SGLSum  int
	 declare @Count  int

     Select @DLBSum = Sum(DBL), @SGLSum = SUM(SGL)   
	 FROM Booking.DayWiseBooking where BookingID  = (select top 1 xo.Qut_ID from XO Where XO.XO_ID = @XOID ) AND GroupKey = @GroupKey   

	  Select @Count = Count(1)  FROM Booking.DayWiseBooking where BookingID  = (select top 1 xo.Qut_ID from XO Where XO.XO_ID = @XOID ) AND GroupKey = @GroupKey  

	 SELECT @TotalAmount = SUM(ISNULL(SGLCommission * @SGLSum, 0) + ISNULL(DBLCommission * @DLBSum, 0)) * @Count  
	FROM 
		@QuotationHotelCommission WHERE XO_ID = @XOID 

	select @HotelCodeN = HotelCode from   @QuotationHotelCommission WHERE XO_ID = @XOID 


    --set @CompanyStateCode_N = (select * FROM HotelMaster )
    select top 1 @CompID = CompanyID  from Booking.tbl_Booking Where ID = (select top 1 xo.Qut_ID from XO Where XO.XO_ID = @XOID )
	
	set @CompanyID = @CompID 


	 
	--select top 1 @CompID = CompanyID  from CompanyMaster 
	--where CompanyID = (select top 1 xo.CompName from XO Where XO.XO_ID = @XOID )

     select TOP 1 @HotelStateCode =StateCodeID , @CompanyStateCode_N = CompanyID  from HotelMaster where HotelCode=@HotelCodeN           
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	--union             
	--select TOP 1 StateCodeID,STRegNo as GSTIN,isSEZ from VendorMaster where VendorCode= ''
	

	set @CompanyID = @CompID 

	
  
   set @CompanyStateCode = (select TOP 1 C.StateCodeID    
					 from CompanyMaster C
					 --INNER JOIn [State] S ON S.State_ID =C.SAP_StateCode
					 where CompanyID=@CompanyID )

	
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

<<<<<<< HEAD
<<<<<<< HEAD

=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
  --SELECT @IsSEZ = IsSEZ  from AgentMaster      
  --WHERE MarketID=            
  --(            
  --SELECT MarketID from AgentMaster        
  --WHERE AgentID =@AgentID       
  --AND Miscellaneous=1 )   
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
 ---GET CompanyStateCode
 Declare @CompanyStateID INT  
 set @CompanyStateID =  (select StateCodeID from CompanyMaster where CompanyID=@CompID)  


 ---GET UTHotel
  select @IsUTHotel  = ISNULL(IsUnionTerritory,0) from State_Code_Master where ID=@HotelStateCode     


   ---GET UTCompany
  select @IsUTCompany = ISNULL(IsUnionTerritory,0)  from State_Code_Master where ID=@CompanyStateCode_N   

  Print 'A'  

				  if(@IsUTHotel = 0 AND @IsUTCompany = 0 OR @IsUTHotel = 1 AND @IsUTCompany = 0 OR @IsUTHotel = 0 AND @IsUTCompany = 1 )
				  begin
					if(@HotelStateCode = @CompanyStateID)
					 Begin
						   if (@IsSEZ = 1 )
						   BEGIN

						    set @GST1 = 2;

						   END
						   ELSE
						   BEGIN
						   SET @GST1 = 1;
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


 
<<<<<<< HEAD
<<<<<<< HEAD
  set @TaxID = 5 
  ------ ServiceTaxbyGSTTaxID 5%
  Select Tax_ID,Tax_Desc,Tax_Percentage,Tax_Type, IsActive,Other_Tax_Id from OtherServiceTaxNew           
	WHERE Tax_Type= @TaxID      
	AND IsActive=1    


	SELECT @GST1 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
  -- set @TaxID = 5 
  ------ ServiceTaxbyGSTTaxID 5%
 -- Select Tax_ID,Tax_Desc,Tax_Percentage,Tax_Type, IsActive,Other_Tax_Id from OtherServiceTaxNew           
	--WHERE Tax_Type= @TaxID      
	--AND IsActive=1     

	SELECT top 1   @TaxID  = ST.Tax_ID  
	FROM ServiceTaxNew ST               
	WHERE
	CONVERT(VARCHAR,CAST(GETDATE() AS DATETIME),112)
	BETWEEN  CONVERT(VARCHAR,ST.Tax_From_Date,112) AND CONVERT(VARCHAR,ST.Tax_To_Date,112)              
	AND ST.IsActive=1 and ST.IsCommercial = 1  and GSTType = @GST1 


	--SELECT @GST1 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

-- Declare output variables
		DECLARE @CGSTTax DECIMAL(10, 2) = 0,
				@SGSTTax DECIMAL(10, 2) = 0,

				@UTGSTTax DECIMAL(10, 2) = 0,
				@IGSTTax DECIMAL(10, 2) = 0,
				@dectax1 DECIMAL(10, 2) = 0,
				@decTotalValue DECIMAL(10, 2) = 0,
<<<<<<< HEAD
<<<<<<< HEAD
				@dtotal DECIMAL(10, 2) =  0, --- Commission Total
=======
				@dtotal DECIMAL(10, 2) =  @TotalAmount, --- Commission Total
>>>>>>> dev
=======
				@dtotal DECIMAL(10, 2) =  @TotalAmount, --- Commission Total
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
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
<<<<<<< HEAD
<<<<<<< HEAD
	set @TotalAmount = 1000 
	set  @SelectedTax = @TaxID  
=======
	set @SelectedTax = @TaxID  
>>>>>>> dev
=======
	set @SelectedTax = @TaxID  
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6


	set @BasicValue = (@TotalAmount * 100)/ (100 + @SelectedTax)



	set @CalculatedTaxableAmt = ISNULL(@TotalAmount, 0) - (ISNULL(@CGST,0) + ISNULL(@SGST,0)  + ISNULL(@IGST,0) + ISNULL(@UTGST,0))
	--SELECT @CalculatedTaxableAmt 
<<<<<<< HEAD
<<<<<<< HEAD

=======
	set @TaxableAmount = @CalculatedTaxableAmt
>>>>>>> dev
=======
	set @TaxableAmount = @CalculatedTaxableAmt
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

	set @CalculatedTaxValue = ISNULL(@TotalAmount,0) - ISNULL(@CalculatedTaxableAmt,0) 
	--SELECT @CalculatedTaxValue

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
	@CalculatedTaxableAmt as 'TotalTaxAmount',
	@CalculatedTaxValue as 'TaxValue',
	@TotalAmount  as 'TotalInvoiceAmount'
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
	--@CalculatedTaxableAmt as 'TotalTaxAmount',
	--@CalculatedTaxValue as 'TaxValue',
	--@TotalAmount  as 'TotalInvoiceAmount'
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6



	declare @XOBillingStateCodeId varchar(5)
	declare @XOSAP_StateCode varchar(5)
	declare @XOCountry_IATACode Varchar(5)
	declare @XOSAP_CompanyCode Varchar(5)
	declare @XOCompanyID Varchar(5)




	 select  @XOBillingStateCodeId=  C.StateCodeID, @XOSAP_StateCode = C.SAP_StateCode,
	  @XOCountry_IATACode = S.Country_IATACode, @XOSAP_CompanyCode =C.SAP_CompanyCode, @XOCompanyID = C.CompanyID   
	 from CompanyMaster C
	 INNER JOIn [State] S ON S.State_ID =C.SAP_StateCode
<<<<<<< HEAD
<<<<<<< HEAD
	 where CompanyID= 9  
=======
	 where CompanyID= @CompID   
>>>>>>> dev
=======
	 where CompanyID= @CompID   
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	 

	select @XOBillingStateCodeId = C.StateCodeID  
		 from CompanyMaster C
		 INNER JOIn [State] S ON S.State_ID =C.SAP_StateCode
		 where CompanyID= @CompID      --- XO Company


<<<<<<< HEAD
<<<<<<< HEAD
		    ---- Yearid from HotelVendor Code
		    select Y.YearID,Y.YearCode ,A.StateCodeID from(select StateCodeID,STRegNo as GSTIN 
			from HotelMaster where HotelCode=  'CTAJ0001'            
			 --union                 
			 --select StateCodeID,STRegNo as GSTIN from VendorMaster where VendorCode=1
			 )    
			 AS A    
			 inner join CompanyMaster C on A.StateCodeID=C.StateCodeID    
			 inner join YearMaster Y on Y.CompanyID=C.CompanyID    
			 where C.StateCodeID=A.StateCodeID and C.IsActive=1   and Y.YearCode=@YearID    

			 ------GetYearIDByCompanyStateCode
			 select top 1 YearID from YearMaster Y inner join CompanyMaster C 
			on Y.CompanyID=C.CompanyID where C.StateCodeID=28  and C.IsActive=1 and Y.YearID=@YearID   
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		 --   ---- Yearid from HotelVendor Code
		 --   select Y.YearID,Y.YearCode ,A.StateCodeID from(select StateCodeID,STRegNo as GSTIN 
			--from HotelMaster where HotelCode=  'CTAJ0001'            
			-- --union                 
			-- --select StateCodeID,STRegNo as GSTIN from VendorMaster where VendorCode=1
			-- )    
			-- AS A    
			-- inner join CompanyMaster C on A.StateCodeID=C.StateCodeID    
			-- inner join YearMaster Y on Y.CompanyID=C.CompanyID    
			-- where C.StateCodeID=A.StateCodeID and C.IsActive=1   and Y.YearCode=@YearID    

			-- ------GetYearIDByCompanyStateCode
			-- select top 1 YearID from YearMaster Y inner join CompanyMaster C 
			--on Y.CompanyID=C.CompanyID where C.StateCodeID=28  and C.IsActive=1 and Y.YearID=@YearID   
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6






			 -----select Companyid by yearID           
<<<<<<< HEAD
<<<<<<< HEAD
			Select CompanyID from YearMaster where YearID=@YearID 
=======
			--Select CompanyID from YearMaster where YearID=@YearID 
>>>>>>> dev
=======
			--Select CompanyID from YearMaster where YearID=@YearID 
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6


			declare @BillingStateCodeId_New varchar(5)
			declare @LoginCountry varchar(5)
			declare @dsGethotelsState varchar(5)
			declare @HotelStateID varchar(5)
			declare @HotelCountry varchar(5)
			declare @BranchPostingCode  varchar(5)
			declare @dsGetYearCode varchar(5)
			declare @FinalCompID varchar(5)


			set @BillingStateCodeId_New = @XOSAP_StateCode 
			set @LoginCountry = @XOCountry_IATACode 
			set @HotelCountry = @XOCountry_IATACode 


			  	if(@HotelVendorFlag = 'V')
				begin
					select S.State_ID , S.Name , S.Country_IATACode ,'' BTCBranchPosting   
					from VendorMaster HM  
					INNER JOIN City C ON C.IATACode = HM.CityIATACode   
					INNER JOIn [State] S ON S.State_ID =C.State_IATACode  
					where VendorID = @XOHotelID  
				end
				else 
				begin
					select  @HotelStateID =S.State_ID, @BranchPostingCode = HM.BTCBranchPosting   
					from HotelMaster HM  
					INNER JOIN City C ON C.IATACode = HM.CityIATACode   
					INNER JOIn [State] S ON S.State_ID =C.State_IATACode  
					where HotelID = @XOHotelID  
				end

                    if (@HotelVendorFlag  = 'H')
                    BEGIN
                       set  @BranchPostingCode  = @BranchPostingCode
                    END
                    ELSE
					BEGIN
					   set  @BranchPostingCode  = @CompID 
					END

					 if (@BillingStateCodeId_New  != @HotelStateID  AND @LoginCountry = 'IN' AND @HotelCountry = 'IN' AND @BranchPostingCode > 0)
                     begin
					   select @dsGetYearCode = YearID  from YearMaster where CompanyID = @CompanyID and YearCode = @YearID 
					    


					   set @FinalCompID = @BranchPostingCode;

					 end

                    

				-- Step 1: Declare the table variable (assuming it already exists and filled)
				-- @QuotationHotelCommission is already populated

				-- Step 2: Declare variables to hold column values from each row
				DECLARE 
					@QuotationID INT,
					@XO_ID VARCHAR(50),
<<<<<<< HEAD
<<<<<<< HEAD
					@CostingCurrencyCode INT,
=======
					@CostingCurrencyCode VARCHAR(5),
>>>>>>> dev
=======
					@CostingCurrencyCode VARCHAR(5),
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					@AccCode VARCHAR(50),
					@HotelName VARCHAR(255),
					@HotelCode VARCHAR(50),
					@HotelSAPCode VARCHAR(50),
					@QuotationDate DATETIME,
					@TravelDateFrom DATETIME,
					@TravelDateTo DATETIME,
					@FileCode VARCHAR(100),
					@OperationBy VARCHAR(100),
					@CurYearID INT,
					@CurCompanyID INT,
					@Confirmed_By VARCHAR(100),
					@SGLCommission DECIMAL(18,2),
					@DBLCommission DECIMAL(18,2),
					@CityIATACode VARCHAR(10),
					@VendorID VARCHAR(50),
					@VendorAccCode VARCHAR(50),
					@VendorName VARCHAR(255),
					@VendorCode VARCHAR(50),
					@VendorSAPCode VARCHAR(50),
					@SAP_CompanyCode VARCHAR(50),
					@ThreeDigitCode VARCHAR(10),
<<<<<<< HEAD
<<<<<<< HEAD
					@SAPCompID INT;

				-- Step 3: Declare the cursor
				DECLARE cur CURSOR FOR
				SELECT 
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					@SAPCompID INT,
					@GuestName Varchar(250),
					@BID INT,
					@CurrID VARCHAR(5),
					@PlaceofSupply INT,
					@AgentID INT,
					@RoomCategory VARCHAR(30), 
					@TAXNumber varchar(20),
					@TANNumber  varchar(20),
					@PANNumber  varchar(20); 

				-- Step 3: Declare the cursor
				DECLARE cur CURSOR FOR
				SELECT TOP 1 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					QuotationID,
					XO_ID,
					CostingCurrencyCode,
					AccCode,
					HotelName,
					HotelCode,
					HotelSAPCode,
					QuotationDate,
					TravelDateFrom,
					TravelDateTo,
					FileCode,
					OperationBy,
					YearID,
					CompanyID,
					Confirmed_By,
					SGLCommission,
					DBLCommission,
					CityIATACode,
					VendorID,
					VendorAccCode,
					VendorName,
					VendorCode,
					VendorSAPCode,
					SAP_CompanyCode,
					[3DigitCode],
<<<<<<< HEAD
<<<<<<< HEAD
					SAPCompID
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					SAPCompID,
					GuestName,
					BookingID,
					CurrID,
					PlaceofSupply,
				    AgentID,
					RoomCategory,
					TAXNumber,
					TANNumber,
					PANNumber 

					
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				FROM @QuotationHotelCommission;

				-- Step 4: Open cursor and fetch first row
				OPEN cur;
				FETCH NEXT FROM cur INTO 
					@QuotationID, @XO_ID, @CostingCurrencyCode, @AccCode, @HotelName, @HotelCode, @HotelSAPCode,
					@QuotationDate, @TravelDateFrom, @TravelDateTo, @FileCode, @OperationBy, @YearID, @CompanyID,
					@Confirmed_By, @SGLCommission, @DBLCommission, @CityIATACode, @VendorID, @VendorAccCode,
<<<<<<< HEAD
<<<<<<< HEAD
					@VendorName, @VendorCode, @VendorSAPCode, @SAP_CompanyCode, @ThreeDigitCode, @SAPCompID;

				-- Step 5: Loop through each row
				WHILE @@FETCH_STATUS = 0
				BEGIN
						-- Perform insert
					INSERT INTO [Invoice].Invoice (
						InvoiceNumber,
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					@VendorName, @VendorCode, @VendorSAPCode, @SAP_CompanyCode, @ThreeDigitCode, @SAPCompID,
					@GuestName, @BID, @CurrID, @PlaceofSupply,@AgentID, @RoomCategory,@TAXNumber,
					@TANNumber,@PANNumber;

				-- Step 5: Loop through each row
				WHILE @@FETCH_STATUS = 0
				BEGIN  



				     
				  SELECT @HotelID =  HotelID from HotelMaster where HotelCode= @HotelCode


						-- Perform insert
					INSERT INTO [Invoice].Invoice (
						InvoiceNumber,
						InvoiceType,
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						TypeOfDoc,
						Invoice_Date,
						PlaceOfSupplierId,
						Tax_ID,
						GuestName,
						AgentID,
						Curr_ID,
						AgentBookerName,
						AgentRefPO,
<<<<<<< HEAD
<<<<<<< HEAD
						InvoiceType,
=======
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						FileCode,
						BookingID,
						QuotationID,
						compcode,
						YearCode,
						CreatedBy,
						CreatedDateTime,
						isTDSDeduction,
						TANNumber,
						PanNumber,
<<<<<<< HEAD
<<<<<<< HEAD
						TAXNumber 
					)
					VALUES (
						NULL,                  -- InvoiceNumber
						1,						-- TypeOfDoc
						@QuotationDate,        -- Invoice_Date
						NULL,                  -- PlaceOfSupplierId
						NULL,                  -- Tax_ID
						NULL,                  -- GuestName
						NULL,                  -- AgentID
						NULL,                  -- Curr_ID
						NULL,                  -- AgentBookerName
						NULL,                  -- AgentRefPO
						1,                     -- InvoiceType
						@FileCode,             -- FileCode
						NULL,                  -- BookingID
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						TAXNumber,
						XO_ID,
						VendorID,
						HotelID
					)
					VALUES (
						NULL,                  -- InvoiceNumber
						4,
						1,						-- TypeOfDoc
						GETDATE(),				-- Invoice_Date
						@PlaceofSupply,        -- PlaceOfSupplierId
						NULL,                  -- Tax_ID
						@GuestName,                  -- GuestName
						@AgentID,                  -- AgentID
						@CurrID,                  -- Curr_ID
						NULL,                  -- AgentBookerName
						NULL,                  -- AgentRefPO
						@FileCode,             -- FileCode
						@BID,                  -- BookingID
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						@QuotationID,          -- QuotationID
						@ThreeDigitCode,       -- compcode
						@YearID,               -- YearCode
						@OperationBy,          -- CreatedBy
						GETDATE(),             -- CreatedDateTime
						0,                     -- isTDSDeduction
<<<<<<< HEAD
<<<<<<< HEAD
						NULL,                  -- TANNumber
						NULL,                  -- PanNumber
						NULL                   -- TAXNumber
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						@TANNumber,                  -- TANNumber
						@PANNumber,                  -- PanNumber
						@TAXNumber,                   -- TAXNumber 
						@XO_ID,
						@VendorID,
						@HotelID

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					);



					-- Get the generated Invoice ID
					SET @InvoiceID = SCOPE_IDENTITY(); 

					    DECLARE @InvoiceDate DATE;
						DECLARE @InvoiceTypeID INT;
						DECLARE @InvoiceType VARCHAR(2);
						DECLARE @GeneratedInvoiceNo VARCHAR(50);

						--SELECT 
						--	@InvoiceDate = I.Invoice_Date, 
						--	@CompanyID = I.compcode, 
						--	@InvoiceTypeID = I.TypeOfDoc
						--FROM [Invoice].[Invoice] I 
						--WHERE I.ID = @InvoiceID;

						SELECT 
							@InvoiceDate = GETDATE(), 
							@CompanyID = 9, 
							@InvoiceTypeID = '1'
						FROM [Invoice].[Invoice] I 
						WHERE I.ID = @InvoiceID;

						IF @InvoiceTypeID = 1 SET @InvoiceType = 'IN';

						EXEC [Invoice].[usp_GenerateInvoiceNumber]
							@InvoiceDate = @InvoiceDate,
							@CompanyID = @CompanyID,
							@InvoiceType = 'IN',
							@YearID = @YearCode,
							@GeneratedInvoiceNo = @GeneratedInvoiceNo OUTPUT;

						UPDATE [Invoice].Invoice 
						SET InvoiceNumber = @GeneratedInvoiceNo  
						WHERE ID = @InvoiceID;

<<<<<<< HEAD
<<<<<<< HEAD
=======
						update XO SET XO.CommInvNumber = @GeneratedInvoiceNo 
						where XO.XO_ID= @XO_ID 

>>>>>>> dev
=======
						update XO SET XO.CommInvNumber = @GeneratedInvoiceNo 
						where XO.XO_ID= @XO_ID 

>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
					-- Now insert into InvoiceDetails
					INSERT INTO [Invoice].[InvoiceDetails] (
						[Invoice_ID],
						[Invoice_Desc],
						[Invoice_Value],
						[YearCode],
						[flag],
						[SAC],
						[Tax_Per],
						[Allocate],
						[StateCode],
						[SACID],
						[Tax_ID],
						[TCSRateID],
						[CGST],
						[SGST],
						[UTGST],
						[IGST],
						[TotalBasicAmount],
						[TotalTaxable_Amount],
						[TotalTax_Amount],
						[TotalInvoiceAmount],
						[TCSAmount],
						[StateCodeID],
						[InvGenerated],
						[Commercial_ID],
						[Parent_ID],
						[TotalTktCost],
						[MarkUp],
						[TTC_MarkUp],
						[BaseFare],
						[Invoice_Desc_ID],
						[CreatedBy],
						[CreatedDateTime],
						[LastUpdatedBy],
<<<<<<< HEAD
<<<<<<< HEAD
						[LastUpdateDateTime]
					)
					VALUES (
						@InvoiceID,
						'Hotel Charges',        -- Example Invoice_Desc
						1000.00,                -- Example Invoice_Value
						@YearID,
						0,                      -- flag
						'9985',                 -- Example SAC
						18.0,                   -- Tax_Per
						1,                      -- Allocate
						'27',                   -- Example StateCode
						1,                      -- SACID
						NULL,                   -- Tax_ID
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						[LastUpdateDateTime],
						TaxableAmountDetail , 
						TotalAmount , 
						TaxAmount, 
						BasicAmount 

					)
					VALUES (
						@InvoiceID,
						@RoomCategory,        -- Example Invoice_Desc
						@TotalAmount,                -- Example Invoice_Value
						@YearID,
						0,                      -- flag
						'9985',                 -- Example SAC
						18,                   -- Tax_Per
						'The Accounts Manager',    -- Allocate
						@CompanyStateCode,      -- Example StateCode
						1,                      -- SACID
						@TaxID,                   -- Tax_ID
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						NULL,                   -- TCSRateID
						@CGST,                    -- CGST
						@SGST,                    -- SGST
						@UTGST,                    -- UTGST
						@IGST,                    -- IGST
<<<<<<< HEAD
<<<<<<< HEAD
						@TotalAmount,                -- TotalBasicAmount
						@TaxableAmount,                -- TotalTaxable_Amount
						@TaxAmount,                 -- TotalTax_Amount
						@Invoice_Total,                -- TotalInvoiceAmount
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						@TotalAmount,              -- TotalBasicAmount
						@CalculatedTaxableAmt,            -- TotalTaxable_Amount
						@CalculatedTaxValue,       -- TotalTax_Amount
						@Invoice_Total,         -- TotalInvoiceAmount
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						NULL,                   -- TCSAmount
						NULL,                   -- StateCodeID
						1,                      -- InvGenerated
						NULL,                   -- Commercial_ID
						NULL,                   -- Parent_ID
						NULL,                -- TotalTktCost
						NULL,                   -- MarkUp
						NULL,                   -- TTC_MarkUp
						NULL,                -- BaseFare
						1,                      -- Invoice_Desc_ID
						@OperationBy,
						GETDATE(),
						NULL,                   -- LastUpdatedBy
<<<<<<< HEAD
<<<<<<< HEAD
						NULL                    -- LastUpdateDateTime
					);
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						NULL,                    -- LastUpdateDateTime
						@CalculatedTaxableAmt,
						@Invoice_Total,
						@BasicValue,
						@TotalAmount  
					);  


					 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

					-- Fetch next row
					FETCH NEXT FROM cur INTO 
						@QuotationID, @XO_ID, @CostingCurrencyCode, @AccCode, @HotelName, @HotelCode, @HotelSAPCode,
						@QuotationDate, @TravelDateFrom, @TravelDateTo, @FileCode, @OperationBy, @CurYearID, @CurCompanyID,
						@Confirmed_By, @SGLCommission, @DBLCommission, @CityIATACode, @VendorID, @VendorAccCode,
<<<<<<< HEAD
<<<<<<< HEAD
						@VendorName, @VendorCode, @VendorSAPCode, @SAP_CompanyCode, @ThreeDigitCode, @SAPCompID;
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
						@VendorName, @VendorCode, @VendorSAPCode, @SAP_CompanyCode, @ThreeDigitCode, @SAPCompID
						,@GuestName,@BID,@CurrID, @PlaceofSupply,@AgentID, @RoomCategory,@TAXNumber,
						@TANNumber,@PANNumber;


						SELECT '200' AS returnCode ,'Commission Invoice is generated' AS returnMessage,GETDATE() as LastSavedOn;    
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
				END

				-- Step 6: Clean up
				CLOSE cur;
				DEALLOCATE cur;
<<<<<<< HEAD
<<<<<<< HEAD





	








                          
=======
				
>>>>>>> dev
=======
				
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
END