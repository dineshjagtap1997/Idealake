<<<<<<< HEAD
<<<<<<< HEAD
﻿--Drop Procedure usp_InsertUpdateBooking_PrimaryInfo
CREATE PROCEDURE [dbo].[usp_InsertUpdateBooking_PrimaryInfo]
	
@Action varchar(1)= 'S',
@ID bigint = 17688 Output,
@QuotationID bigint = NULL,
@StartDate datetime = NULL,
@EndDate datetime = NULL,
@City varchar(255) = NULL,
@Service int = NULL,
@Vehical int = NULL,
@Vendor int = NULL,
@Currency varchar(10) = NULL,
@Count int = NULL,
@Adult int = NULL,
@Child int = NULL,
@Consolidated bigint = NULL,
@Nationality int = NULL,
@Cost int = NULL,
@Type varchar(50) = NULL,
@Lock bit = NULL,
@FileCode varchar(255) = NULL,
@GuestName varchar(255) = NULL,
@XONumber varchar(255) = NULL,
@BookingID varchar(255) = NULL,
@Status int = NULL,
@FHE nvarchar(100) = NULL,
@PaxName varchar(200) = NULL,
@MobileNO varchar(30) = NULL,
@PaxEmailID varchar(200) = NULL,
@Numberofpax int = NULL,
@BizVirticale varchar(500) = NULL,
@DepartmentID varchar(max) = NULL,
@BookingCreationDate datetime = NULL,
@PrePone tinyint = NULL,
@PrePoneDate datetime = NULL,
@AgentInvoiceReq tinyint = NULL,
@Reason varchar(max) = NULL,
@PacageCode varchar(50) = NULL,
@PrmSrvcLoc varchar(500) = NULL,
@Origin varchar(50) = NULL,
@OnlineBookingID varchar(500) = NULL,
@FIT tinyint = NULL,
@SupplierTax_B2b tinyint = NULL,
@SupplierTax_InCluding tinyint = NULL,
@MarkupType_Gross tinyint = NULL,
@AgentID int = NULL,
@MarketID varchar(max) = NULL,
@CityIATACode char(3) = NULL,
@BillingAddress varchar(max) = NULL,
@PANNo varchar(20) = NULL,
@GSTNo varchar(20) = NULL,
@TANNo varchar(20) = NULL,
@SEZ varchar(20) = NULL,
@FreeZone tinyint = NULL,
@AgentOnCredit tinyint = NULL,
@CreditAmount decimal(18, 2) = NULL,
@OutStandingAmount decimal(18, 2) = NULL,
@DBL int = NULL,
@EBA int = NULL,
@EBC int = NULL,
@CNB int = NULL,
@SGL int = NULL,
@taxID int = NULL,
@UserNote1 varchar(max) = NULL,
@UserNote2 varchar(max) = NULL,
@CreatedBy uniqueidentifier = NULL,
--@CreatedOn datetime = NULL,
--@ModifiedBy uniqueidentifier = NULL,
--@ModifiedOn datetime = NULL,
@TamSalesrep INT  = NULL
  , @CompanyID INT = 9,
    @YearID INT = 4,
	@EQID bigint =null
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
﻿
CREATE PROCEDURE [dbo].[usp_InsertUpdateBooking_PrimaryInfo]
@Action                  VARCHAR(1)         = 'S',
@QuotationID            BIGINT             = null,
@StartDate              DATETIME           = null,
@EndDate                DATETIME           = null,
@City                   VARCHAR(255)       = null,
@Service                INT                = null,
@Vehical                INT                = null,
@Vendor                 INT                = null,
@Currency               VARCHAR(10)        = null,
@Count                  INT                = null,
@Adult                  INT                = null,
@Child                  INT                = null,
@Consolidated           BIGINT             = NULL,
@Nationality            INT                = null,
@Cost                   INT                = null,
@Type                   VARCHAR(50)        = null,
@Lock                   BIT                = null,
@FileCode               VARCHAR(255)       = null,
@GuestName              VARCHAR(255)       =null,
@XONumber               VARCHAR(255)       = null,
@BookingID              VARCHAR(255)       = null,
@Status                 INT                = null,
@FHE                    NVARCHAR(100)      = null,
@PaxName                VARCHAR(200)       = null,
@MobileNO               VARCHAR(30)        = null,
@PaxEmailID             VARCHAR(200)       = null,
@Numberofpax            INT                = null,
@BizVirticale           VARCHAR(500)       = null,
@DepartmentID           VARCHAR(MAX)       = null,
@BookingCreationDate    DATETIME           = NULL,
@PrePone                TINYINT            = null,
@PrePoneDate            DATETIME           = NULL,
@AgentInvoiceReq        TINYINT            = null,
@Reason                 VARCHAR(MAX)       = null,
@PacageCode             VARCHAR(50)        = null,
@PrmSrvcLoc             VARCHAR(500)       = null,
@Origin                 VARCHAR(50)        = null,
@OnlineBookingID        VARCHAR(500)       = null,
@FIT                    TINYINT            = null,
@SupplierTax_B2b        TINYINT            = null,
@SupplierTax_InCluding  TINYINT            = null,
@MarkupType_Gross       TINYINT            = null,
@AgentID                INT                = null,
@MarketID               VARCHAR(MAX)       = null,
@CityIATACode           CHAR(3)            = null,
@BillingAddress         VARCHAR(MAX)       = null,
@PANNo                  VARCHAR(20)        = null,
@GSTNo                  VARCHAR(20)        = null,
@TANNo                  VARCHAR(20)        = null,
@SEZ                    VARCHAR(20)        = null,
@FreeZone               TINYINT            = null,
@AgentOnCredit          TINYINT            = null,
@CreditAmount           DECIMAL(18,2)      = null,
@OutStandingAmount      DECIMAL(18,2)      = null,
@DBL                    INT                = null,
@EBA                    INT                = null,
@EBC                    INT                = null,
@CNB                    INT                = null,
@SGL                    INT                = null,
@Twin                   INT                = null,
@taxID                  INT                = null,
@UserNote1              VARCHAR(MAX)       = null,
@UserNote2              VARCHAR(MAX)       = null,
@CreatedBy              UNIQUEIDENTIFIER   = null,
@TamSalesrep            INT                = null,
@CompanyID              INT                = null,
@YearID                 INT                = null,
@EQID                   BIGINT             = null,
@ReassignTo             UNIQUEIDENTIFIER   = NULL,
@IsSubBooking           BIT                = 0,
@IsCopyBooking          INT                = 0,
@ID                     BIGINT             = null output

<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
AS
BEGIN                                              
 

 SET NOCOUNT ON;
 DECLARE @ReturnCode NVARCHAR(3),                                              
         @ReturnMessage NVARCHAR(MAX),                     
         @LogID INT;
	DECLARE @CompanyCode NVARCHAR(5) = '';
	DECLARE @YearCode NVARCHAR(5) = '';
	DECLARE @Prefix NVARCHAR(20) = '';
		DECLARE @MaxNumber INT = 0;

 IF @Action = 'I'                                              
 BEGIN   
 
 	DECLARE @NewEnquiryID INT;
	IF(@EQID Is Null)
	BEGIN
	Declare @AgentStaffName varchar(500);
	set @AgentStaffName =( select AgentName from AgentMaster where AgentID=@AgentID )
<<<<<<< HEAD
<<<<<<< HEAD
=======
	if(@IsSubBooking=0 and @IsCopyBooking=0)
		BEGIN
>>>>>>> dev
=======
	if(@IsSubBooking=0 and @IsCopyBooking=0)
		BEGIN
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			CREATE TABLE #TempEnquiry (
				returnCode VARCHAR(1000)
				,returnMessage VARCHAR(1000)
				,ID INT --,
				--EnquiryID VARCHAR(1000)
				);

			INSERT INTO #TempEnquiry
			EXEC [dbo].[usp_Enquiry] @AgentID = @AgentID
				,@AgentStaffName = @AgentStaffName
				,@OperationBy = @CreatedBy
				,@Action = 'I'
				,@IsDraft = 0
				,@IsSysGenEnquiry = 2
				,@ID = @ID OUTPUT

			SELECT @NewEnquiryID = ID
			FROM #TempEnquiry

			SET @EQID = @NewEnquiryID;

			DROP TABLE #TempEnquiry
			END
<<<<<<< HEAD
<<<<<<< HEAD
=======
			END
>>>>>>> dev
=======
			END
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
-- Fetch CompanyCode
	IF @CompanyID IS NOT NULL
		AND @CompanyID > 0
	BEGIN
		SELECT @CompanyCode = ISNULL(CompCode, '')
		FROM CompanyMaster
		WHERE CompanyID = @CompanyID;
	END

	-- Fetch YearCode
	IF @YearID IS NOT NULL
		AND @YearID > 0
	BEGIN
		SELECT @YearCode = ISNULL(YearCode, '')
		FROM YearMaster
		WHERE YearID = @YearID;
	END
<<<<<<< HEAD
<<<<<<< HEAD
=======
	
>>>>>>> dev
=======
	
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6

    SET @Prefix = 'B' + @CompanyCode + @YearCode;

	SELECT @MaxNumber = ISNULL(MAX(CAST(RIGHT(BookingID, 6) AS INT)), 0)
	FROM [Booking].[tbl_Booking]
	WHERE BookingID LIKE @Prefix + '%'
		AND ISNUMERIC(RIGHT(BookingID, 6)) = 1;
<<<<<<< HEAD
<<<<<<< HEAD

	SET @BookingID = @Prefix + RIGHT('000000' + CAST(@MaxNumber + 1 AS VARCHAR(6)), 6);
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		if(@IsSubBooking=0 and @IsCopyBooking=0)
		BEGIN
	SET @BookingID = @Prefix + RIGHT('000000' + CAST(@MaxNumber + 1 AS VARCHAR(6)), 6);
	END
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
                                        
       INSERT INTO Booking.tbl_Booking (
     QuotationID
    ,StartDate
    ,EndDate
   -- ,City
    ,Service
    ,Vehical
    ,Vendor
    ,Currency
    ,[Count]
    ,Adult
    ,Child
    ,Consolidated
    ,Nationality
    ,Cost
    ,[Type]
    ,[Lock]
    ,FileCode
    ,GuestName
    ,XONumber
    ,BookingID
    ,[Status]
    ,FHE
    ,PaxName
    ,MobileNO
    ,PaxEmailID
    ,Numberofpax
    ,BizVirticale
    ,DepartmentID
    ,BookingCreationDate
    ,PrePone
    ,PrePoneDate
    ,AgentInvoiceReq
    ,Reason
    ,PacageCode
    ,PrmSrvcLoc
    ,Origin
    ,OnlineBookingID
    ,FIT
    ,SupplierTax_B2b
    ,SupplierTax_InCluding
    ,MarkupType_Gross
    ,AgentID
    ,MarketID
    ,CityIATACode
    ,BillingAddress
    ,PANNo
    ,GSTNo
    ,TANNo
    ,SEZ
    ,FreeZone
    ,AgentOnCredit
    ,CreditAmount
    ,OutStandingAmount
    ,DBL
    ,EBA
    ,EBC
    ,CNB
    ,SGL
<<<<<<< HEAD
<<<<<<< HEAD
=======
	,Twin
>>>>>>> dev
=======
	,Twin
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    ,taxID
    ,UserNote1
    ,UserNote2
    ,CreatedBy
    ,CreatedOn
	,TamSalesrep
	,EnquiryID
	,CompanyID
	,YearID 
<<<<<<< HEAD
<<<<<<< HEAD
=======
	,IsCopyBooking
>>>>>>> dev
=======
	,IsCopyBooking
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
)
VALUES (
     @QuotationID
    ,@StartDate
    ,@EndDate
    --,@City
    ,@Service
    ,@Vehical
    ,@Vendor
    ,@Currency
    ,@Count
    ,@Adult
    ,@Child
    ,@Consolidated
    ,@Nationality
    ,@Cost
    ,@Type
    ,@Lock
    ,@FileCode
    ,@GuestName
    ,@XONumber
    ,@BookingID
    ,3
    ,@CreatedBy
    ,@PaxName
    ,@MobileNO
    ,@PaxEmailID
    ,@Numberofpax
    ,@BizVirticale
    ,@DepartmentID
    ,@BookingCreationDate
    ,@PrePone
    ,@PrePoneDate
    ,@AgentInvoiceReq
    ,@Reason
    ,@PacageCode
    ,@PrmSrvcLoc
    ,@Origin
    ,@OnlineBookingID
    ,@FIT
    ,@SupplierTax_B2b
    ,@SupplierTax_InCluding
    ,@MarkupType_Gross
    ,@AgentID
    ,@MarketID
    ,@CityIATACode
    ,@BillingAddress
    ,@PANNo
    ,@GSTNo
    ,@TANNo
    ,@SEZ
    ,@FreeZone
    ,@AgentOnCredit
    ,@CreditAmount
    ,@OutStandingAmount
    ,@DBL
    ,@EBA
    ,@EBC
    ,@CNB
    ,@SGL
<<<<<<< HEAD
<<<<<<< HEAD
=======
	,Isnull(@Twin,0)
>>>>>>> dev
=======
	,Isnull(@Twin,0)
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    ,@taxID
    ,@UserNote1
    ,@UserNote2
    ,@CreatedBy
    ,getdate()
	,@TamSalesrep
	,@EQID	
	,@CompanyID
	,@YearID 
<<<<<<< HEAD
<<<<<<< HEAD
=======
	,@IsCopyBooking
>>>>>>> dev
=======
	,@IsCopyBooking
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
);
                                
         SET @LogID = SCOPE_IDENTITY();  
		 		set @ID=@LogID


			CREATE TABLE #TempFileCode (
				FileCode VARCHAR(1000)
				
				);
<<<<<<< HEAD
<<<<<<< HEAD

=======
				if(@IsSubBooking=0 and @IsCopyBooking=0)
		BEGIN
>>>>>>> dev
=======
				if(@IsSubBooking=0 and @IsCopyBooking=0)
		BEGIN
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
			INSERT INTO #TempFileCode
		 EXEC [Booking].[GenerateFileCode] @CompanyID=@CompanyID,@BookingID= @ID

		 Update booking.tbl_booking set FIleCode=(select FileCode from #TempFileCode),FileCodeGeneratedOn=getdate() where ID=@ID        
                     Drop table #TempFileCode                              
<<<<<<< HEAD
<<<<<<< HEAD
		 
=======
		 END
>>>>>>> dev
=======
		 END
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
		 SELECT '200' AS returnCode, 'New record added successfully.' AS returnMessage, @LogID AS ID;                                              
 END                                              

 ELSE IF @Action = 'U'                                              
<<<<<<< HEAD
<<<<<<< HEAD
 BEGIN                                              
     IF NOT EXISTS (SELECT TOP 1 1 FROM Booking.tbl_Booking WHERE ID = @ID)                                              
     BEGIN                                              
         SELECT '201' AS returnCode, 'Record Not Found.' AS returnMessage;                                              
     END                                              
     ELSE                                              
     BEGIN                        
	 IF NOT EXISTS (SELECT  TOP 1 1 FROM Booking.tbl_Booking WHERE ID = @ID and Status=2)                                              
     BEGIN
			CREATE TABLE #TempFileCodeU (
				FileCode VARCHAR(1000)
				
				);

			INSERT INTO #TempFileCodeU
		 EXEC [Booking].[GenerateFileCode] @CompanyID=@CompanyID,@BookingID= @ID

		 Update booking.tbl_booking set FIleCode=(select FileCode from #TempFileCodeU)  ,FileCodeGeneratedOn=getdate() where ID=@ID   
                     Drop table #TempFileCodeU                              
		 
	 END


         UPDATE Booking.tbl_Booking
SET
     QuotationID = ISNULL(@QuotationID, QuotationID)
    ,StartDate = ISNULL(@StartDate, StartDate)
    ,EndDate = ISNULL(@EndDate, EndDate)
   -- ,City = ISNULL(@City, City)
    ,[Service] = ISNULL(@Service, [Service])
    ,Vehical = ISNULL(@Vehical, Vehical)
    ,Vendor = ISNULL(@Vendor, Vendor)
    ,Currency = ISNULL(@Currency, Currency)
    ,[Count] = ISNULL(@Count, [Count])
    ,Adult = ISNULL(@Adult, Adult)
    ,Child = ISNULL(@Child, Child)
    ,Consolidated = ISNULL(@Consolidated, Consolidated)
    ,Nationality = ISNULL(@Nationality, Nationality)
    ,Cost = ISNULL(@Cost, Cost)
    ,[Type] = ISNULL(@Type, [Type])
    ,[Lock] = ISNULL(@Lock, [Lock])
    ,GuestName = ISNULL(@GuestName, GuestName)
    ,XONumber = ISNULL(@XONumber, XONumber)
    ,[Status] = 3
    ,PaxName = ISNULL(@PaxName, PaxName)
    ,MobileNO = ISNULL(@MobileNO, MobileNO)
    ,PaxEmailID = ISNULL(@PaxEmailID, PaxEmailID)
    ,Numberofpax = ISNULL(@Numberofpax, Numberofpax)
    ,BizVirticale = ISNULL(@BizVirticale, BizVirticale)
    ,DepartmentID = ISNULL(@DepartmentID, DepartmentID)
    ,BookingCreationDate = ISNULL(@BookingCreationDate, BookingCreationDate)
    ,PrePone = ISNULL(@PrePone, PrePone)
    ,PrePoneDate = ISNULL(@PrePoneDate, PrePoneDate)
    ,AgentInvoiceReq = ISNULL(@AgentInvoiceReq, AgentInvoiceReq)
    ,Reason = ISNULL(@Reason, Reason)
    ,PacageCode = ISNULL(@PacageCode, PacageCode)
    ,PrmSrvcLoc = ISNULL(@PrmSrvcLoc, PrmSrvcLoc)
    ,Origin = ISNULL(@Origin, Origin)
    ,OnlineBookingID = ISNULL(@OnlineBookingID, OnlineBookingID)
    ,FIT = ISNULL(@FIT, FIT)
    ,SupplierTax_B2b = ISNULL(@SupplierTax_B2b, SupplierTax_B2b)
    ,SupplierTax_InCluding = ISNULL(@SupplierTax_InCluding, SupplierTax_InCluding)
    ,MarkupType_Gross = ISNULL(@MarkupType_Gross, MarkupType_Gross)
    ,AgentID = ISNULL(@AgentID, AgentID)
    ,MarketID = ISNULL(@MarketID, MarketID)
    ,CityIATACode = ISNULL(@CityIATACode, CityIATACode)
    ,BillingAddress = ISNULL(@BillingAddress, BillingAddress)
    ,PANNo = ISNULL(@PANNo, PANNo)
    ,GSTNo = ISNULL(@GSTNo, GSTNo)
    ,TANNo = ISNULL(@TANNo, TANNo)
    ,SEZ = ISNULL(@SEZ, SEZ)
    ,FreeZone = ISNULL(@FreeZone, FreeZone)
    ,AgentOnCredit = ISNULL(@AgentOnCredit, AgentOnCredit)
    ,CreditAmount = ISNULL(@CreditAmount, CreditAmount)
    ,OutStandingAmount = ISNULL(@OutStandingAmount, OutStandingAmount)
    ,DBL = ISNULL(@DBL, DBL)
    ,EBA = ISNULL(@EBA, EBA)
    ,EBC = ISNULL(@EBC, EBC)
    ,CNB = ISNULL(@CNB, CNB)
    ,SGL = ISNULL(@SGL, SGL)
    ,taxID = ISNULL(@taxID, taxID)
    ,UserNote1 = ISNULL(@UserNote1, UserNote1)
    ,UserNote2 = ISNULL(@UserNote2, UserNote2)
    ,ModifiedBy = @CreatedBy
    ,ModifiedOn = GETDATE()
	,TamSalesrep =@TamSalesrep
WHERE ID = @ID;
                           

     END        
	 SET @LogID = (SELECT ID FROM Booking.tbl_Booking WHERE ID = @ID);                                              
SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @LogID AS ID;                                              

 END                                              

 ELSE IF @Action = 'S'                                              
 BEGIN                                              
SELECT 
	B.ID
     ,B.QuotationID
    ,B.StartDate
    ,B.EndDate
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
-- BEGIN                                              
--     IF NOT EXISTS (SELECT TOP 1 1 FROM Booking.tbl_Booking WHERE ID = @ID)                                              
--     BEGIN                                              
--         SELECT '201' AS returnCode, 'Record Not Found.' AS returnMessage;                                              
--     END                                              
--     ELSE                                              
--     BEGIN                        
--	 IF NOT EXISTS (SELECT  TOP 1 1 FROM Booking.tbl_Booking WHERE ID = @ID and Status=2)                                              
--     BEGIN
--	  IF EXISTS (SELECT  TOP 1 1 FROM Booking.tbl_Booking WHERE ID = @ID  and Isnull(FileCode,'')='')                                              
--     BEGIN
--			CREATE TABLE #TempFileCodeU (
--				FileCode VARCHAR(1000)
				
--				);

--			INSERT INTO #TempFileCodeU
--		 EXEC [Booking].[GenerateFileCode] @CompanyID=@CompanyID,@BookingID= @ID

--		 Update booking.tbl_booking set FIleCode=(select FileCode from #TempFileCodeU)  ,FileCodeGeneratedOn=getdate() where ID=@ID   
--                     Drop table #TempFileCodeU                              
--		 END
--	 END
	  

--         UPDATE Booking.tbl_Booking
--SET
--     QuotationID = ISNULL(@QuotationID, QuotationID)
--    ,StartDate = ISNULL(@StartDate, StartDate)
--    ,EndDate = ISNULL(@EndDate, EndDate)
--   -- ,City = ISNULL(@City, City)
--    ,[Service] = ISNULL(@Service, [Service])
--    ,Vehical = ISNULL(@Vehical, Vehical)
--    ,Vendor = ISNULL(@Vendor, Vendor)
--    ,Currency = ISNULL(@Currency, Currency)
--    ,[Count] = ISNULL(@Count, [Count])
--    ,Adult = ISNULL(@Adult, Adult)
--    ,Child = ISNULL(@Child, Child)
--    ,Consolidated = ISNULL(@Consolidated, Consolidated)
--    ,Nationality = ISNULL(@Nationality, Nationality)
--    ,Cost = ISNULL(@Cost, Cost)
--    ,[Type] = ISNULL(@Type, [Type])
--    ,[Lock] = ISNULL(@Lock, [Lock])
--    ,GuestName = ISNULL(@GuestName, GuestName)
--    ,XONumber = ISNULL(@XONumber, XONumber)
--    ,[Status] = 3
--    ,PaxName = ISNULL(@PaxName, PaxName)
--    ,MobileNO = ISNULL(@MobileNO, MobileNO)
--    ,PaxEmailID = ISNULL(@PaxEmailID, PaxEmailID)
--    ,Numberofpax = ISNULL(@Numberofpax, Numberofpax)
--    ,BizVirticale = ISNULL(@BizVirticale, BizVirticale)
--    ,DepartmentID = ISNULL(@DepartmentID, DepartmentID)
--    ,BookingCreationDate = ISNULL(@BookingCreationDate, BookingCreationDate)
--    ,PrePone = ISNULL(@PrePone, PrePone)
--    ,PrePoneDate = ISNULL(@PrePoneDate, PrePoneDate)
--    ,AgentInvoiceReq = ISNULL(@AgentInvoiceReq, AgentInvoiceReq)
--    ,Reason = ISNULL(@Reason, Reason)
--    ,PacageCode = ISNULL(@PacageCode, PacageCode)
--    ,PrmSrvcLoc = ISNULL(@PrmSrvcLoc, PrmSrvcLoc)
--    ,Origin = ISNULL(@Origin, Origin)
--    ,OnlineBookingID = ISNULL(@OnlineBookingID, OnlineBookingID)
--    ,FIT = ISNULL(@FIT, FIT)
--    ,SupplierTax_B2b = ISNULL(@SupplierTax_B2b, SupplierTax_B2b)
--    ,SupplierTax_InCluding = ISNULL(@SupplierTax_InCluding, SupplierTax_InCluding)
--    ,MarkupType_Gross = ISNULL(@MarkupType_Gross, MarkupType_Gross)
--    ,AgentID = ISNULL(@AgentID, AgentID)
--    ,MarketID = ISNULL(@MarketID, MarketID)
--    ,CityIATACode = ISNULL(@CityIATACode, CityIATACode)
--    ,BillingAddress = ISNULL(@BillingAddress, BillingAddress)
--    ,PANNo = ISNULL(@PANNo, PANNo)
--    ,GSTNo = ISNULL(@GSTNo, GSTNo)
--    ,TANNo = ISNULL(@TANNo, TANNo)
--    ,SEZ = ISNULL(@SEZ, SEZ)
--    ,FreeZone = ISNULL(@FreeZone, FreeZone)
--    ,AgentOnCredit = ISNULL(@AgentOnCredit, AgentOnCredit)
--    ,CreditAmount = ISNULL(@CreditAmount, CreditAmount)
--    ,OutStandingAmount = ISNULL(@OutStandingAmount, OutStandingAmount)
--    ,DBL = ISNULL(@DBL, DBL)
--    ,EBA = ISNULL(@EBA, EBA)
--    ,EBC = ISNULL(@EBC, EBC)
--    ,CNB = ISNULL(@CNB, CNB)
--    ,SGL = ISNULL(@SGL, SGL)
--    ,Twin = ISNULL(@Twin, Twin)	
--    ,taxID = ISNULL(@taxID, taxID)
--    ,UserNote1 = ISNULL(@UserNote1, UserNote1)
--    ,UserNote2 = ISNULL(@UserNote2, UserNote2)
--    ,ModifiedBy = @CreatedBy
--    ,ModifiedOn = GETDATE()
--	,TamSalesrep =@TamSalesrep
--WHERE ID = @ID;
                           

--     END        
--	 SET @LogID = (SELECT ID FROM Booking.tbl_Booking WHERE ID = @ID);                                              
--SELECT '200' AS returnCode, 'Record updated successfully.' AS returnMessage, @LogID AS ID,
--	getdate() as LastSavedOn;                                              

-- END                                              
BEGIN
    IF NOT EXISTS (SELECT TOP 1 1 FROM Booking.tbl_Booking WHERE ID = @ID)
    BEGIN
        SELECT '201' AS returnCode, 'Record Not Found.' AS returnMessage;
    END
    ELSE
    BEGIN
        -- Generate FileCode if needed
      
            IF EXISTS (SELECT TOP 1 1 FROM Booking.tbl_Booking WHERE ID = @ID AND ISNULL(FileCode, '') = '')
            BEGIN
                IF OBJECT_ID('tempdb..#TempFileCodeU') IS NOT NULL DROP TABLE #TempFileCodeU;

                CREATE TABLE #TempFileCodeU (
                    FileCode VARCHAR(1000)
                );

                INSERT INTO #TempFileCodeU
                EXEC [Booking].[GenerateFileCode] @CompanyID = @CompanyID, @BookingID = @ID;

                UPDATE Booking.tbl_Booking 
                SET FileCode = (SELECT TOP 1 FileCode FROM #TempFileCodeU),
                    FileCodeGeneratedOn = GETDATE()
                WHERE ID = @ID;

                DROP TABLE #TempFileCodeU;
            END
        

        -- Main UPDATE
        UPDATE Booking.tbl_Booking
        SET
            StartDate = ISNULL(@StartDate, StartDate),
            EndDate = ISNULL(@EndDate, EndDate),
            [Service] = ISNULL(@Service, [Service]),
            Vehical = ISNULL(@Vehical, Vehical),
            Vendor = ISNULL(@Vendor, Vendor),
            Currency = ISNULL(@Currency, Currency),
            [Count] = ISNULL(@Count, [Count]),
            Adult = ISNULL(@Adult, Adult),
            Child = ISNULL(@Child, Child),
            Consolidated = ISNULL(@Consolidated, Consolidated),
            Nationality = ISNULL(@Nationality, Nationality),
            Cost = ISNULL(@Cost, Cost),
            [Type] = ISNULL(@Type, [Type]),
            [Lock] = ISNULL(@Lock, [Lock]),
            GuestName = ISNULL(@GuestName, GuestName),
            XONumber = ISNULL(@XONumber, XONumber),
            [Status] = 3,
            PaxName = ISNULL(@PaxName, PaxName),
            MobileNO = ISNULL(@MobileNO, MobileNO),
            PaxEmailID = ISNULL(@PaxEmailID, PaxEmailID),
            Numberofpax = ISNULL(@Numberofpax, Numberofpax),
            BizVirticale = ISNULL(@BizVirticale, BizVirticale),
            DepartmentID = ISNULL(@DepartmentID, DepartmentID),
            BookingCreationDate = ISNULL(@BookingCreationDate, BookingCreationDate),
            PrePone = ISNULL(@PrePone, PrePone),
            PrePoneDate = ISNULL(@PrePoneDate, PrePoneDate),
            AgentInvoiceReq = ISNULL(@AgentInvoiceReq, AgentInvoiceReq),
            Reason = ISNULL(@Reason, Reason),
            PacageCode = ISNULL(@PacageCode, PacageCode),
            PrmSrvcLoc = ISNULL(@PrmSrvcLoc, PrmSrvcLoc),
            Origin = ISNULL(@Origin, Origin),
            OnlineBookingID = ISNULL(@OnlineBookingID, OnlineBookingID),
            FIT = ISNULL(@FIT, FIT),
            SupplierTax_B2b = ISNULL(@SupplierTax_B2b, SupplierTax_B2b),
            SupplierTax_InCluding = ISNULL(@SupplierTax_InCluding, SupplierTax_InCluding),
            MarkupType_Gross = ISNULL(@MarkupType_Gross, MarkupType_Gross),
            AgentID = ISNULL(@AgentID, AgentID),
            MarketID = ISNULL(@MarketID, MarketID),
            CityIATACode = ISNULL(@CityIATACode, CityIATACode),
            BillingAddress = ISNULL(@BillingAddress, BillingAddress),
            PANNo = ISNULL(@PANNo, PANNo),
            GSTNo = ISNULL(@GSTNo, GSTNo),
            TANNo = ISNULL(@TANNo, TANNo),
            SEZ = ISNULL(@SEZ, SEZ),
            FreeZone = ISNULL(@FreeZone, FreeZone),
            AgentOnCredit = ISNULL(@AgentOnCredit, AgentOnCredit),
            CreditAmount = ISNULL(@CreditAmount, CreditAmount),
            OutStandingAmount = ISNULL(@OutStandingAmount, OutStandingAmount),
            DBL = ISNULL(@DBL, DBL),
            EBA = ISNULL(@EBA, EBA),
            EBC = ISNULL(@EBC, EBC),
            CNB = ISNULL(@CNB, CNB),
            SGL = ISNULL(@SGL, SGL),
            Twin = ISNULL(@Twin, Twin),
            taxID = ISNULL(@taxID, taxID),
            UserNote1 = ISNULL(@UserNote1, UserNote1),
            UserNote2 = ISNULL(@UserNote2, UserNote2),
            ModifiedBy = @CreatedBy,
            ModifiedOn = GETDATE(),
            TamSalesrep = @TamSalesrep
        WHERE ID = @ID;

        -- Set LogID
        SET @LogID = @ID;

        SELECT '200' AS returnCode, 
               'Record updated successfully.' AS returnMessage, 
               @LogID AS ID,
               GETDATE() AS LastSavedOn;
    END
END

 ELSE IF @Action = 'S'                                              
 BEGIN                                              
SELECT Distinct
	B.ID
     ,B.QuotationID
     ,B.EnquiryID
    --,B.StartDate
    --,B.EndDate
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
  --  ,B.City
    ,B.Service
    ,B.Vehical
    ,B.Vendor
    ,B.Currency
    ,B.Count
    ,B.Adult
    ,B.Child
    ,B.Consolidated
    ,B.Nationality
    ,B.Cost
    ,B.Type
    ,B.Lock
    ,B.FileCode
    ,B.GuestName
    ,B.XONumber
    ,B.BookingID
    ,B.Status
    ,B.FHE
    ,B.PaxName
    ,B.MobileNO
    ,B.PaxEmailID
    ,B.Numberofpax
<<<<<<< HEAD
<<<<<<< HEAD
    ,Convert(DateTime,Format(B.StartDate,'yyyy-MM-dd 00:00:000')) as StartDate
    ,B.EndDate
    ,B.BizVirticale
    ,'' AS 'Department'
    ,B.BookingCreationDate
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    ,case when B.StartDate is null then getdate() else Convert(DateTime,Format(B.StartDate,'yyyy-MM-dd 00:00:000')) end  as StartDate
    ,case when B.EndDate is null then getdate() else Convert(DateTime,Format(B.EndDate,'yyyy-MM-dd 00:00:000')) end  as EndDate
    ,B.BizVirticale
    ,'' AS 'Department'
    ,ISNULL(B.BookingCreationDate, GETDATE()) AS BookingCreationDate
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    ,B.PrePone
    ,B.PrePoneDate
    ,B.AgentInvoiceReq
    ,B.Reason
    ,B.PacageCode
    ,B.PrmSrvcLoc
<<<<<<< HEAD
<<<<<<< HEAD
=======
	,PrmSrvLocc.Name AS PrmSrvcLocName
>>>>>>> dev
=======
	,PrmSrvLocc.Name AS PrmSrvcLocName
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    ,B.Origin
    ,B.OnlineBookingID
    ,B.FIT
    ,B.SupplierTax_B2b
    ,B.SupplierTax_InCluding
    ,B.MarkupType_Gross
    ,B.AgentID
    ,B.MarketID
    ,B.CityIATACode
    ,B.BillingAddress
    ,B.PANNo
    ,B.GSTNo
    ,B.TANNo
    ,B.SEZ
    ,B.FreeZone
    ,B.AgentOnCredit
    ,B.CreditAmount
    ,B.OutStandingAmount
    ,B.DBL
    ,B.EBA
    ,B.EBC
    ,B.CNB
    ,B.SGL
<<<<<<< HEAD
<<<<<<< HEAD
=======
	,B.Twin
>>>>>>> dev
=======
	,B.Twin
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    ,B.taxID
    ,B.UserNote1
    ,B.UserNote2
    ,B.CreatedBy
<<<<<<< HEAD
<<<<<<< HEAD
    ,B.CreatedOn
    ,B.ModifiedBy
    ,B.ModifiedOn
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
    --,Convert(DateTime,Format(B.CreatedOn,'yyyy-MM-dd 00:00:000')) CreatedOn
    ,B.ModifiedBy
    ,B.ModifiedOn
	,B.ModifiedOn as LastSaved
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	,B.TamSalesrep
	,Am.AgentName
	,c.Name as City
	,PrmSrvLocc.Name as PrmSrvLocName
	,B.Currency
	,CM.Name as CurrenncyName
	,B.DepartmentID as DepartmentID
	,B.CompanyID
	,B.YearID 
	,EM.EmpName AS FHEName
<<<<<<< HEAD
<<<<<<< HEAD

=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
	,QQ.QuotationNo
	,te.EnquiryID as EnquiryNo
	,GP.GSTPercentage AS TaxOnSales,
	BS1.StatusName
	,(
					SELECT *
					FROM (
					SELECT   BversionSeq.ParentID AS ParentID
							,BversionSeq.QuotationID AS ChildID
							,BversionSeq.BookingID
							,BversionSeq.BookingSequence
							,BversionSeq.Status
							,BS.StatusName


						FROM Booking.tbl_Booking BversionSeq
						LEFT JOIN Booking.BookingStatus BS ON BversionSeq.STATUS = BS.StatusCode

						WHERE BversionSeq.BookingID = B.BookingID
							AND BversionSeq.BookingSequence IS NOT NULL
						) AS BVs
					FOR JSON PATH
					) AS VersionSequence,
					te.IsSysGenEnquiry,
					Isnull(B.BookingSequence,0) as BookingSequence,
					ISnull((select top 1 1 from Invoice.Invoice i where i.BookingID = b.ID ),0) as  IsInvoiceGen,
                    AM.City_IATACode AS AgentCityIATACode,
					CM.CurrencyCode
FROM Booking.tbl_Booking B
--LEFT JOIN Department D ON D.ID = B.DepartmentID
LEFT JOIN AgentMaster AM ON AM.AgentID = B.AgentID
LEFT JOIN City c ON c.IATACode = B.CityIATACode
LEFT JOIN Country PrmSrvLocc ON PrmSrvLocc.IATACode = B.PrmSrvcLoc
LEFT JOIN CurrencyMaster CM ON CM.id = B.Currency 
LEFT JOIn EmployeeMaster EM ON  EM.UserID = B.FHE
<<<<<<< HEAD
<<<<<<< HEAD

=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
LEFT JOIn Quotation.QuotationMaster QQ ON  QQ.QuotationID = B.QuotationID
LEFT JOIn tbl_Enquiry te ON  te.EQID = B.EnquiryID
LEFT JOIN  GST_Percentage GP ON B.taxID = GP.GSTID
LEFT JOIN Booking.BookingStatus BS1 ON B.STATUS = BS1.StatusCode
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6


WHERE 
    (@ID IS NULL OR @ID = 0 OR B.ID = @ID)
<<<<<<< HEAD
<<<<<<< HEAD
	AND((@YearID IS null) or (B.YearID=@YearID))
				AND((@CompanyID IS null) or (B.CompanyID=@CompanyID))
				AND((@CreatedBy IS null) or (B.CreatedBy=@CreatedBy))
ORDER BY 
    B.BookingCreationDate DESC, 
    B.ID DESC;
                                            
 END                                              
=======
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
ORDER BY 
    --BookingCreationDate DESC, 
    B.ID DESC;
                                            
 END     
 
 ELSE IF @Action='R'
 BEGIN
 Update  Booking.tbl_Booking set FHE=@ReassignTo,ModifiedBy = @CreatedBy,ModifiedOn=GETDATE() where ID=@ID 
 SELECT '200' AS returnCode, 'Reassigend successfully.' AS returnMessage;              
 END 
  ELSE IF @Action='C'
 BEGIN
 Update  Booking.tbl_Booking set Status = 4 ,ModifiedBy = @CreatedBy,ModifiedOn=GETDATE() where ID=@ID 
  SELECT '200' AS returnCode, 'Cancelled successfully.' AS returnMessage;              

 END 
<<<<<<< HEAD
>>>>>>> dev
=======
>>>>>>> 42bb970832000d684c5b89bfe253cf8daa6a25d6
                                  
END

